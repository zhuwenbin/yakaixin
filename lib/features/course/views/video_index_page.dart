import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:better_player/better_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_html/flutter_html.dart';
import '../services/video_service.dart';
import '../../../core/utils/safe_type_converter.dart';
import '../../../core/storage/storage_service.dart';
import '../../../app/constants/storage_keys.dart';
import '../../../core/media/video_player_manager.dart';

/// 视频播放页面 - 对应小程序 study/newVideo/index.vue
/// 功能：播放录播视频课程，显示目录和讲义
class VideoIndexPage extends ConsumerStatefulWidget {
  final String? lessonId;
  final String? goodsId;
  final String? orderId;
  final String? goodsPid;
  final String? systemId;
  final String? name;
  final String? filterGoodsId;
  final String? classId;
  /// 当前班级在列表中的下标，用于选 detail_package_goods[classIndex] 拉目录（与小程序一致）
  final int? classIndex;
  final List<Map<String, dynamic>>? chapterData;

  const VideoIndexPage({
    super.key,
    this.lessonId,
    this.goodsId,
    this.orderId,
    this.goodsPid,
    this.systemId,
    this.name,
    this.filterGoodsId,
    this.classId,
    this.classIndex,
    this.chapterData,
  });

  @override
  ConsumerState<VideoIndexPage> createState() => _VideoIndexPageState();
}

class _VideoIndexPageState extends ConsumerState<VideoIndexPage> {
  BetterPlayerController? _betterPlayerController;
  int _tabIndex = 1; // 1=目录, 2=讲义
  String _lessonName = '';
  String _videoUrl = '';
  String _handoutContent = '';
  List<Map<String, dynamic>> _chapterData = [];
  String? _error;
  Timer? _progressTimer;
  double _currentTime = 0;
  String _currentLessonId = '';
  String? _goodsId;
  String? _filterGoodsId;
  int? _classIndex;
  bool _hasSignedIn = false;

  @override
  void initState() {
    super.initState();
    _currentLessonId = widget.lessonId ?? '';
    _goodsId = widget.goodsId;
    _filterGoodsId = widget.filterGoodsId;
    _classIndex = widget.classIndex;
    _lessonName = widget.name ?? '';

    // 目录与小程序一致：统一由 chapterpaper API 返回，不使用传入的 chapterData

    // ✅ 立即显示UI，后台加载讲义
    if (widget.systemId != null && widget.systemId!.isNotEmpty) {
      _loadHandout(widget.systemId!);
    }

    // ✅ 异步加载视频数据（不阻塞UI）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVideoData();
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    // ✅ 使用管理器释放视频播放器资源
    VideoPlayerManager.instance.disposeVideoPlayer();
    super.dispose();
  }

  /// 加载视频数据
  /// 对应小程序：newVideo.vue mounted() + getDetail() + getChapter()
  Future<void> _loadVideoData() async {
    if (_currentLessonId.isEmpty) {
      setState(() {
        _error = '课程ID为空';
      });
      return;
    }

    try {
      // ✅ 不设置 isLoading，保持UI显示
      final videoService = ref.read(videoServiceProvider);
      final storage = ref.read(storageServiceProvider);
      final userInfo = storage.getJson(StorageKeys.userInfo);
      final studentId = userInfo?['student_id']?.toString() ?? '';

      // ✅ 第一步：并行加载视频URL和讲义（不依赖商品详情）
      final results = await Future.wait([
        // 1. 获取录播地址
        videoService.getPlaybackPath(lessonId: _currentLessonId),
        // 2. 获取讲义（如果有 systemId）
        if (widget.systemId != null && widget.systemId!.isNotEmpty)
          _loadHandout(widget.systemId!)
        else
          Future.value(),
      ]);

      final playbackPath = results[0] as String;

      // 拼接完整URL
      String videoUrl = playbackPath;
      if (!videoUrl.startsWith('http://') && !videoUrl.startsWith('https://')) {
        videoUrl = 'https://yakaixin.oss-cn-beijing.aliyuncs.com/$videoUrl';
      }
      videoUrl = Uri.decodeComponent(videoUrl);

      // 获取保存的播放进度
      final savedTime = await _getSavedProgress(videoUrl, _currentLessonId);

      // ✅ 初始化视频播放器（后台加载，不阻塞UI）
      await _initVideoPlayer(videoUrl, savedTime);

      setState(() {
        _videoUrl = videoUrl;
      });

      // 与小程序一致：目录统一由 chapterpaper API 拉取（filterGoodsId / 套餐ID）
      if (studentId.isNotEmpty && _goodsId != null) {
        await _loadGoodsDetailAndChapter(studentId);
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  /// 加载商品详情并获取章节列表
  /// 对应小程序: getDetail() + getChapter()
  /// 小程序逻辑：newVideo.vue Line 386-419
  Future<void> _loadGoodsDetailAndChapter(String studentId) async {
    if (_goodsId == null || _goodsId!.isEmpty) {
      print('⚠️ [商品详情] goodsId 为空，跳过');
      return;
    }

    try {
      // 1. 获取商品详情
      final videoService = ref.read(videoServiceProvider);
      print('\n========== 📦 [开始加载商品详情] ==========');
      print('🎯 goods_id: $_goodsId');
      print('🎯 filter_goods_id: $_filterGoodsId');
      print('👨‍🎓 student_id: $studentId');
      print('=========================================\n');

      // ✅ 关键修复：对照小程序 newVideo.vue Line 389-396
      // 小程序调用 getGoodsDetail 时传了 user_id + student_id
      final goodsDetail = await videoService.getGoodsDetail(
        goodsId: _goodsId!,
        userId: studentId, // ✅ 新增：对应小程序 user_id
        studentId: studentId, // ✅ 新增：对应小程序 student_id
      );

      print('✅ [商品详情] 获取成功');
      print(
        '📦 [商品详情] detail_package_goods: ${goodsDetail.detailPackageGoods?.length ?? 0} 个',
      );

      // 2. 选择用于 chapterpaper 的 goods_id
      // 章节接口只认「套餐商品 id」(detail_package_goods[].id)，不能传主商品 id(goods_id)。
      // 若 filterGoodsId 等于主商品 id（如 series/goods 返回的 id 与主 id 相同），必须用 classIndex 或套餐列表中的 id。
      String? actualGoodsId;

      print('\n========== 🎯 [选择用于获取章节的ID] ==========');
      print('🎯 主商品 goods_id: $_goodsId (不能用于 chapter 接口)');

      if (goodsDetail.detailPackageGoods != null &&
          goodsDetail.detailPackageGoods!.isNotEmpty) {
        final packages = goodsDetail.detailPackageGoods!;
        final packageIds =
            packages.map((p) => SafeTypeConverter.toSafeString(p.id)).toList();
        final filterStr = _filterGoodsId != null ? _filterGoodsId!.trim() : '';
        final mainGoodsId = _goodsId != null ? _goodsId!.trim() : '';
        final isFilterSameAsMain = filterStr.isNotEmpty &&
            mainGoodsId.isNotEmpty &&
            filterStr == mainGoodsId;
        if (filterStr.isNotEmpty &&
            packageIds.contains(filterStr) &&
            !isFilterSameAsMain) {
          actualGoodsId = filterStr;
          print('✅ [与小程序一致] 使用 filter_goods_id: $actualGoodsId');
        } else if (isFilterSameAsMain) {
          if (_classIndex != null &&
              _classIndex! >= 0 &&
              _classIndex! < packages.length) {
            actualGoodsId = packageIds[_classIndex!];
            print(
              '✅ [修正] filter 与主商品 id 相同，改用 classIndex=$_classIndex → 套餐 id: $actualGoodsId',
            );
          } else {
            actualGoodsId = packageIds.first;
            print(
              '✅ [修正] filter 与主商品 id 相同，改用 detail_package_goods[0].id: $actualGoodsId',
            );
          }
        } else if (_classIndex != null &&
            _classIndex! >= 0 &&
            _classIndex! < packages.length) {
          actualGoodsId = packageIds[_classIndex!];
          print(
            '✅ [兜底] filter 不在列表中，使用 classIndex=$_classIndex → $actualGoodsId',
          );
        } else {
          actualGoodsId = packageIds.first;
          print('✅ [兜底] 使用 detail_package_goods[0].id: $actualGoodsId');
        }
      } else {
        actualGoodsId = _goodsId;
        print('⚠️ [兜底] 无套餐列表，使用 goods_id: $actualGoodsId');
      }

      print('=========================================\n');

      // 3. 使用实际的课程ID获取章节列表
      if (actualGoodsId != null && actualGoodsId.isNotEmpty) {
        print('🔄 [开始加载章节列表]');
        print('✅ 使用 actualGoodsId: $actualGoodsId');
        print('✅ 使用 studentId: $studentId\n');
        await _loadChapterList(studentId, actualGoodsId);
      } else {
        print('\u274c [章节列表] actualGoodsId 为空，无法获取章节');
      }
    } catch (e) {
      print('❌ [商品详情&章节] 加载失败: $e');
    }
  }

  /// 加载课程目录
  /// 对应小程序：newVideo.vue getChapter() Line 325-361
  Future<void> _loadChapterList(String studentId, String goodsId) async {
    if (goodsId.isEmpty || studentId.isEmpty) {
      print('\n\u274c [课程目录] 参数不完整');
      print('⚠️ goodsId: $goodsId');
      print('⚠️ studentId: $studentId\n');
      return;
    }

    try {
      final videoService = ref.read(videoServiceProvider);
      print('\n========== 📚 [请求章节列表] ==========');
      print('🎯 goods_id: $goodsId');
      print('👨‍🎓 student_id: $studentId');
      print('=========================================\n');

      final chapters = await videoService.getChapterList(
        goodsId: goodsId,
        studentId: studentId,
      );

      print('\n========== ✅ [章节数据获取成功] ==========');
      print('📚 章节总数: ${chapters.length} 个');
      if (chapters.isNotEmpty) {
        print('📖 第一个章节:');
        print('   - name: ${chapters[0]['name']}');
        print('   - subs: ${(chapters[0]['subs'] as List?)?.length ?? 0} 个子课节');
        if ((chapters[0]['subs'] as List?)?.isNotEmpty == true) {
          final firstSub = (chapters[0]['subs'] as List)[0];
          print('   - 第一个子课节:');
          print('     * lesson_id: ${firstSub['lesson_id']}');
          print('     * name: ${firstSub['name']}');
        }
      } else {
        print('⚠️ 章节列表为空');
      }
      print('=========================================\n');

      setState(() {
        _chapterData = chapters.map((chapter) {
          return {
            ...chapter,
            'expand': true, // 播放页：默认展开（对应小程序 Line 356）
          };
        }).toList();
      });

      print('\n========== 🎉 [UI已更新] ==========');
      print('✅ 章节数据已设置到 _chapterData');
      print('📊 _chapterData.length: ${_chapterData.length}');
      print('📊 _tabIndex: $_tabIndex (1=目录, 2=讲义)');
      print('=========================================\n');
    } catch (e) {
      print('❌ [课程目录] 加载失败: $e');
      // ✅ 添加堆栈追踪，方便调试
      if (e is Error) {
        print('堆栈: ${e.stackTrace}');
      }
    }
  }

  /// 初始化视频播放器
  /// 使用 Better Player
  Future<void> _initVideoPlayer(String url, double initialTime) async {
    try {
      debugPrint('🎬 [视频播放] 开始初始化播放器');

      // ✅ 初始化 Better Player Controller
      _betterPlayerController = await VideoPlayerManager.instance
          .initVideoPlayer(url, initialTime: initialTime);

      // ✅ 监听播放进度（Better Player 内部使用 video_player）
      _betterPlayerController!.videoPlayerController?.addListener(
        _onVideoProgress,
      );

      // ✅ 启动定时器保存进度
      _progressTimer?.cancel();
      _progressTimer = Timer.periodic(const Duration(seconds: 5), (_) {
        _saveProgress();
      });

      if (mounted) {
        setState(() {});
      }

      debugPrint('✅ [视频播放] Better Player 初始化成功');
    } catch (e, stackTrace) {
      // ✅ 详细错误日志（用于诊断鸿蒙系统问题）
      debugPrint('❌ [视频播放] 初始化失败');
      debugPrint('   错误类型: ${e.runtimeType}');
      debugPrint('   错误信息: $e');
      debugPrint('   堆栈追踪: $stackTrace');

      // ✅ 检测设备信息（用于诊断）
      try {
        final platform = Theme.of(context).platform;
        debugPrint('   平台: $platform');
      } catch (_) {}

      String errorMessage = '播放失败';

      // ✅ 检查错误类型，提供更友好的提示
      final errorString = e.toString().toLowerCase();
      final stackString = stackTrace.toString().toLowerCase();

      if (e is VideoPlayerConflictException) {
        errorMessage = '播放失败';
      } else if (errorString.contains('mediacodec') ||
          errorString.contains('exoplaybackexception') ||
          errorString.contains('videorenderer') ||
          errorString.contains('failed to allocate') ||
          errorString.contains('insufficient') ||
          stackString.contains('mediacodec') ||
          stackString.contains('exoplayer') ||
          stackString.contains('failed to allocate')) {
        // ✅ MediaCodec 错误（硬件解码器不支持，常见于鸿蒙系统）
        // ✅ 检测是否是资源不足错误（常见于华为设备）
        final isResourceError =
            errorString.contains('failed to allocate') ||
            errorString.contains('insufficient') ||
            stackString.contains('failed to allocate') ||
            stackString.contains('insufficient');

        if (isResourceError) {
          // ✅ 资源不足错误（常见于鸿蒙系统华为设备）
          errorMessage = '播放失败';
        } else {
          // ✅ 其他解码器错误
          errorMessage = '播放失败';
        }

        // ✅ 鸿蒙系统特殊处理：记录详细错误信息
        debugPrint('⚠️ [鸿蒙兼容] 检测到 MediaCodec 错误');
        if (isResourceError) {
          debugPrint('   错误类型：硬件解码器资源不足');
          debugPrint('   受影响设备：华为 Mate 60 Pro、华为平板等鸿蒙系统设备');
          debugPrint('   建议：联系后端提供多分辨率视频或降低视频分辨率');
        } else {
          debugPrint('   可能原因：鸿蒙系统的硬件解码器不支持该视频格式');
          debugPrint('   建议：检查视频编码格式（H.264/H.265）');
        }
      } else if (errorString.contains('timeout') ||
          errorString.contains('超时')) {
        errorMessage = '播放失败';
      } else if (errorString.contains('network') ||
          errorString.contains('网络')) {
        errorMessage = '网络连接失败，请检查网络设置';
      } else {
        errorMessage = '播放失败';
      }

      if (mounted) {
        setState(() {
          _error = errorMessage;
        });
      }

      // ✅ 移除 SnackBar，错误只在视频播放区域显示
      // 不再显示底部 SnackBar，避免重复提示
    }
  }

  /// 视频进度监听
  /// 对应小程序: newVideo.vue onTimeUpdate() + videoNearEnd()
  void _onVideoProgress() {
    if (_betterPlayerController != null) {
      final videoController = _betterPlayerController!.videoPlayerController;
      if (videoController != null) {
        final newTime = videoController.value.position.inSeconds.toDouble();
        if ((newTime - _currentTime).abs() > 1) {
          _currentTime = newTime;
        }

        // ✅ 视频快结束时签到（对应小程序 videoNearEnd）
        // 小程序逻辑：Line 180-204
        final duration =
            videoController.value.duration?.inSeconds.toDouble() ?? 0.0;
        final position = videoController.value.position.inSeconds.toDouble();

        // ✅ 剩余30秒时签到（只签到一次，防止重复调用）
        if (!_hasSignedIn && duration > 0 && (duration - position) <= 30) {
          _hasSignedIn = true; // ✅ 标记已签到
          _performClassSignin();
        }
      }
    }
  }

  /// 执行课程签到
  /// 对应小程序: newVideo.vue videoNearEnd() Line 180-204
  Future<void> _performClassSignin() async {
    if (_currentLessonId.isEmpty) {
      debugPrint('⚠️ [课程签到] 课节ID为空，跳过签到');
      return;
    }

    try {
      final storage = ref.read(storageServiceProvider);
      final userInfo = storage.getJson(StorageKeys.userInfo);
      final studentId = userInfo?['student_id']?.toString() ?? '';

      if (studentId.isEmpty) {
        debugPrint('⚠️ [课程签到] 学生ID为空，跳过签到');
        return;
      }

      debugPrint('📝 [课程签到] 视频快结束，开始签到...');
      debugPrint('   lesson_id: $_currentLessonId');
      debugPrint('   class_id: ${widget.classId}');
      debugPrint('   student_id: $studentId');

      final videoService = ref.read(videoServiceProvider);
      await videoService.classSignin(
        lessonId: _currentLessonId,
        classId: widget.classId, // ✅ 使用从上一页传入的 classId
        studentId: studentId,
      );

      debugPrint('✅ [课程签到] 签到请求已发送');
    } catch (e) {
      debugPrint('❌ [课程签到] 签到失败: $e');
      // ✅ 签到失败不影响视频播放
    }
  }

  /// 获取保存的播放进度
  Future<double> _getSavedProgress(String url, String lessonId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString('--video-data--');
      if (savedData == null) return 0;

      final records = jsonDecode(savedData) as List;
      final md5String = _generateMd5('$url-$lessonId');

      final targetRecord = records.firstWhere(
        (item) => item['md5'] == md5String,
        orElse: () => null,
      );

      if (targetRecord != null) {
        return SafeTypeConverter.toDouble(targetRecord['currentTime']);
      }
    } catch (e) {
      print('❌ 获取播放进度失败: $e');
    }
    return 0;
  }

  /// 保存播放进度
  Future<void> _saveProgress() async {
    if (_betterPlayerController == null ||
        _betterPlayerController!.videoPlayerController == null ||
        _videoUrl.isEmpty ||
        _currentLessonId.isEmpty) {
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString('--video-data--');
      List records = savedData != null ? jsonDecode(savedData) : [];

      final md5String = _generateMd5('$_videoUrl-$_currentLessonId');
      final index = records.indexWhere((item) => item['md5'] == md5String);

      if (index >= 0) {
        records[index]['currentTime'] = _currentTime;
      } else {
        records.add({'md5': md5String, 'currentTime': _currentTime});
      }

      await prefs.setString('--video-data--', jsonEncode(records));
    } catch (e) {
      print('❌ 保存播放进度失败: $e');
    }
  }

  /// 生成MD5
  String _generateMd5(String input) {
    final bytes = utf8.encode(input);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  /// 加载讲义内容
  Future<void> _loadHandout(String systemId) async {
    try {
      final videoService = ref.read(videoServiceProvider);
      final content = await videoService.getHandout(
        teachingSystemRelationId: systemId,
      );

      setState(() {
        _handoutContent = content;
      });
    } catch (e) {
      print('❌ 加载讲义失败: $e');
    }
  }

  /// 切换课节
  Future<void> _switchLesson(Map<String, dynamic> section) async {
    final lessonId = section['lesson_id']?.toString() ?? '';
    if (lessonId.isEmpty || lessonId == '0') {
      // 跳转到商品详情页
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('该课程需要购买')));
      return;
    }

    final systemId = section['system_id']?.toString() ?? '';

    // ✅ 重置签到标志（切换课节时重置）
    _hasSignedIn = false;

    // ✅ 优化策略：先显示loading，后台释放
    // ✅ 1. 立即更新UI状态，显示黑色背景
    setState(() {
      _betterPlayerController = null;
      _currentLessonId = lessonId;
      _lessonName = section['name']?.toString() ?? '';
    });

    // ✅ 2. 异步释放旧控制器（不阻塞UI）
    Future.microtask(() async {
      try {
        // ✅ 使用管理器释放 Better Player
        await VideoPlayerManager.instance.disposeVideoPlayer();
      } catch (e) {
        debugPrint('⚠️ [视频切换] 释放旧控制器失败: $e');
      }
    });

    // ✅ 3. 后台加载讲义
    if (systemId.isNotEmpty) {
      _loadHandout(systemId);
    }

    // ✅ 4. 加载新视频
    await _loadVideoData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // ✅ 使用 AppBar（对应小程序的 uni.setNavigationBarTitle）
      // 小程序使用 uni.setNavigationBarTitle 设置系统导航栏标题和返回按钮
      appBar: AppBar(
        title: Text(
          // _lessonName.isNotEmpty ? _lessonName : '视频课程',
          '视频课程',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w400, // ✅ 小程序导航栏标题：font-weight: 400
            color: const Color(0xFF000000), // ✅ 小程序导航栏标题：color: #000000
          ),
        ),
        backgroundColor: Colors.white, // ✅ 小程序导航栏：background: #fff
        elevation: 0,
        centerTitle: true, // ✅ 小程序导航栏标题居中
        // ✅ 自定义返回按钮（对应小程序的返回箭头图片）
        // 小程序：width: 16px, height: 20px, padding-left: 16px
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios, // ✅ 使用 iOS 风格箭头（与小程序图片样式一致）
            size: 16.sp, // ✅ 小程序：width: 16px
            color: const Color(0xFF000000), // ✅ 小程序：color: #000000
          ),
          padding: EdgeInsets.only(left: 16.w), // ✅ 小程序：padding-left: 16px
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // ✅ 视频播放器区域（Better Player 自动处理宽高比）
        AspectRatio(
          aspectRatio: 16 / 9, // ✅ Better Player 会自动适配视频实际宽高比
          child: Container(
            color: Colors.black,
            child: _error != null
                ? _buildVideoError() // ✅ 错误只在视频播放区域显示
                : (_betterPlayerController != null
                      ? BetterPlayer(
                          controller: _betterPlayerController!,
                        ) // ✅ Better Player 原生全屏，系统自动处理转屏和宽高比
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )), // ✅ 页面级加载指示器（Better Player 的 placeholder 已移除，避免重复）
          ),
        ),
        // 课程标题
        _buildTitle(),
        // Tab切换
        _buildTabBar(),
        // Tab内容
        Expanded(child: _buildTabBody()),
      ],
    );
  }

  /// 视频播放区域错误显示
  /// ✅ 错误只在视频播放区域显示，而不是整页显示
  Widget _buildVideoError() {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ✅ 错误图标
          Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
          SizedBox(height: 16.h),
          // ✅ 错误信息
          Text(
            _error ?? '播放失败',
            style: TextStyle(fontSize: 14.sp, color: Colors.white, height: 1.5),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          // ✅ 刷新按钮
          ElevatedButton(
            onPressed: () {
              // ✅ 清除错误状态后重试
              setState(() {
                _error = null;
              });
              _loadVideoData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
            child: const Text('刷新'),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    // ✅ 与小程序样式一致：padding: 32rpx, font-size: 34rpx, font-weight: 600
    return Container(
      padding: EdgeInsets.all(16.w), // ✅ 小程序：padding: 32rpx
      color: Colors.white,
      child: Text(
        _lessonName.isNotEmpty ? _lessonName : '课程名称',
        style: TextStyle(
          fontSize: 17.sp, // ✅ 小程序：font-size: 34rpx (34/2 = 17)
          fontWeight: FontWeight.w600, // ✅ 小程序：font-weight: 600
          color: const Color(0xFF262629), // ✅ 小程序：color: #262629
        ),
        textAlign: TextAlign.left, // ✅ 小程序：text-align: left
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1)),
      ),
      child: Row(children: [_buildTabItem(1, '目录'), _buildTabItem(2, '讲义')]),
    );
  }

  Widget _buildTabItem(int index, String title) {
    final isActive = _tabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _tabIndex = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isActive
                      ? const Color(0xFF3B7BFB)
                      : const Color(0xFF262629),
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                width: 40.w,
                height: 3.h,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF3B7BFB)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBody() {
    if (_tabIndex == 2) {
      return _buildHandout();
    } else {
      return _buildChapterList();
    }
  }

  /// 目录列表（与小程序 newVideo.vue .tab-body + .pane-wrapper-outline 一致：白底、顶部分割线、内边距 20rpx 32rpx）
  Widget _buildChapterList() {
    if (_chapterData.isEmpty) {
      return Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Text(
          '暂无目录',
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF999999)),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF4F5F5), width: 1)),
      ),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        itemCount: _chapterData.length,
        itemBuilder: (context, index) {
          final chapter = _chapterData[index];
          return _buildChapterItem(chapter);
        },
      ),
    );
  }

  Widget _buildChapterItem(Map<String, dynamic> chapter) {
    final isExpanded = chapter['expand'] == true;
    // 与小程序一致：接口可能返回 subs 或 list
    final subs = (chapter['subs'] ?? chapter['list']) as List? ?? [];

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Column(
        children: [
          // 章节标题
          GestureDetector(
            onTap: () {
              setState(() {
                chapter['expand'] = !isExpanded;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      chapter['name']?.toString() ?? '',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF262629),
                      ),
                    ),
                  ),
                  Text(
                    '${subs.length}节',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF999999),
                    ),
                  ),
                  SizedBox(width: 12.w), // 与小程序 newVideo.vue .section-count margin-right 24rpx
                  // 与小程序 .expand-button 一致：arrow-d.png，收起时 .down 旋转 180deg
                  AnimatedRotation(
                    turns: isExpanded ? 0 : 0.5,
                    duration: const Duration(milliseconds: 300),
                    child: Image.asset(
                      'assets/images/arrow_d.png',
                      width: 16.w,
                      height: 16.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 课节列表
          if (isExpanded)
            ...subs.map<Widget>((section) => _buildSectionItem(section)),
        ],
      ),
    );
  }

  /// 课节项（与小程序 newVideo.vue .section-line 一致：left-point 3px×12px、time 在上 name 在下、播放按钮）
  Widget _buildSectionItem(Map<String, dynamic> section) {
    final timeStr = section['time']?.toString() ?? '';
    final nameStr = section['name']?.toString() ?? '';

    return GestureDetector(
      onTap: () => _switchLesson(section),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: const Color(0xFFF4F5F5), width: 1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 3.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: const Color(0xFF3B7BFB),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (timeStr.isNotEmpty)
                    Text(
                      timeStr,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF696E7A),
                      ),
                    ),
                  if (timeStr.isNotEmpty) SizedBox(height: 3.h),
                  Text(
                    nameStr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF5B6E81),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4FF),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Text(
                '播放',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF3B7BFB),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHandout() {
    if (_handoutContent.isEmpty) {
      return Center(
        child: Text(
          '暂无讲义',
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF999999)),
        ),
      );
    }

    // ✅ 使用 flutter_html 渲染 HTML 内容（参考小程序 v-html）
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Html(
        data: _handoutContent,
        style: {
          // 全局样式
          "*": Style(
            fontSize: FontSize(14.sp),
            color: const Color(0xFF262629),
            lineHeight: const LineHeight(1.6),
          ),
          // 段落样式
          "p": Style(margin: Margins.only(bottom: 12.h)),
          // 标题样式
          "h1": Style(
            fontSize: FontSize(20.sp),
            fontWeight: FontWeight.bold,
            margin: Margins.only(bottom: 16.h, top: 16.h),
          ),
          "h2": Style(
            fontSize: FontSize(18.sp),
            fontWeight: FontWeight.bold,
            margin: Margins.only(bottom: 14.h, top: 14.h),
          ),
          "h3": Style(
            fontSize: FontSize(16.sp),
            fontWeight: FontWeight.w600,
            margin: Margins.only(bottom: 12.h, top: 12.h),
          ),
          // 列表样式
          "ul": Style(
            padding: HtmlPaddings.only(left: 20.w),
            margin: Margins.only(bottom: 12.h),
          ),
          "ol": Style(
            padding: HtmlPaddings.only(left: 20.w),
            margin: Margins.only(bottom: 12.h),
          ),
          "li": Style(margin: Margins.only(bottom: 6.h)),
          // 图片样式
          "img": Style(
            width: Width.auto(),
            margin: Margins.symmetric(vertical: 10.h),
          ),
          // 代码样式
          "code": Style(
            backgroundColor: const Color(0xFFF5F5F5),
            padding: HtmlPaddings.symmetric(horizontal: 4.w, vertical: 2.h),
            fontFamily: 'monospace',
          ),
          "pre": Style(
            backgroundColor: const Color(0xFFF5F5F5),
            padding: HtmlPaddings.all(12.w),
            margin: Margins.only(bottom: 12.h),
          ),
          // 引用样式
          "blockquote": Style(
            border: const Border(
              left: BorderSide(color: Color(0xFF3B7BFB), width: 4),
            ),
            padding: HtmlPaddings.only(left: 12.w),
            margin: Margins.only(bottom: 12.h),
            backgroundColor: const Color(0xFFF8F8F8),
          ),
          // 表格样式
          "table": Style(
            border: const Border.fromBorderSide(
              BorderSide(color: Color(0xFFE5E5E5), width: 1),
            ),
            margin: Margins.only(bottom: 12.h),
          ),
          "th": Style(
            padding: HtmlPaddings.all(8.w),
            backgroundColor: const Color(0xFFF5F5F5),
            fontWeight: FontWeight.bold,
          ),
          "td": Style(
            padding: HtmlPaddings.all(8.w),
            border: const Border.fromBorderSide(
              BorderSide(color: Color(0xFFE5E5E5), width: 1),
            ),
          ),
        },
        // ✅ 链接处理
        onLinkTap: (url, attributes, element) {
          if (url != null) {
            debugPrint('[讲义] 点击链接: $url');
            // TODO: 使用 url_launcher 打开链接
          }
        },
      ),
    );
  }
}
