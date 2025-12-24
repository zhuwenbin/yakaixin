import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_html/flutter_html.dart';
import '../services/video_service.dart';
import '../../../core/utils/safe_type_converter.dart';
import '../../../core/storage/storage_service.dart';
import '../../../app/constants/storage_keys.dart';
import '../../../core/media/video_player_manager.dart'; // ✅ 新增

/// 视频播放页面 - 对应小程序 study/newVideo/index.vue
/// 功能：播放录播视频课程，显示目录和讲义
class VideoIndexPage extends ConsumerStatefulWidget {
  final String? lessonId;
  final String? goodsId;
  final String? orderId;
  final String? goodsPid;
  final String? systemId;
  final String? name;
  final String? filterGoodsId; // ✅ 新增：对应小程序 filter_goods_id
  final String? classId; // ✅ 新增：对应小程序 class_id
  final List<Map<String, dynamic>>? chapterData; // ✅ 新增：从上一页传递的章节数据

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
    this.chapterData, // ✅ 新增参数
  });

  @override
  ConsumerState<VideoIndexPage> createState() => _VideoIndexPageState();
}

class _VideoIndexPageState extends ConsumerState<VideoIndexPage> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
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
  String? _filterGoodsId; // ✅ 实际用于获取目录的ID
  bool _hasSignedIn = false; // ✅ 防止重复签到标志

  @override
  void initState() {
    super.initState();
    _currentLessonId = widget.lessonId ?? '';
    _goodsId = widget.goodsId;
    _filterGoodsId = widget.filterGoodsId; // ✅ 保存 filter_goods_id
    _lessonName = widget.name ?? '';

    // ✅ 优先使用传入的章节数据（避免重复请求）
    if (widget.chapterData != null && widget.chapterData!.isNotEmpty) {
      print('✅ [章节数据] 使用从上一页传递的数据，共 ${widget.chapterData!.length} 个章节');
      _chapterData = widget.chapterData!.map((chapter) {
        return {
          ...chapter,
          'expand': true, // 默认展开
        };
      }).toList();
    }

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
    _chewieController?.dispose();
    // ✅ 使用管理器释放 video_player 资源
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

      // ✅ 第二步：如果没有传入章节数据，才去请求
      // 对应小程序 newVideo.vue Line 386-418
      if ((widget.chapterData == null || widget.chapterData!.isEmpty) &&
          studentId.isNotEmpty &&
          _goodsId != null) {
        print('⚠️ [章节数据] 未传入，开始请求...');
        await _loadGoodsDetailAndChapter(studentId);
      } else {
        print('✅ [章节数据] 已存在，跳过请求');
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

      // 2. 选择实际的课程ID
      // 小程序逻辑 (newVideo.vue Line 408-415):
      // - 如果有 filter_goods_id，用它
      // - 否则从 detail_package_goods[0].id 取第一个
      String? actualGoodsId;

      print('\n========== 🎯 [选择用于获取章节的ID] ==========');

      if (_filterGoodsId != null && _filterGoodsId!.isNotEmpty) {
        // ✅ 优先使用 filter_goods_id（对应班级的ID）
        actualGoodsId = _filterGoodsId;
        print('✅ [优先级 1] 使用 filter_goods_id: $actualGoodsId');
      } else if (goodsDetail.detailPackageGoods != null &&
          goodsDetail.detailPackageGoods!.isNotEmpty) {
        // ✅ 从套餐商品中获取第一个ID
        actualGoodsId = SafeTypeConverter.toSafeString(
          goodsDetail.detailPackageGoods![0].id,
        );
        print('✅ [优先级 2] 使用 detail_package_goods[0].id: $actualGoodsId');
      } else {
        // 兜底：使用传入的 goodsId
        actualGoodsId = _goodsId;
        print('⚠️ [优先级 3 - 兜底] 使用 goods_id: $actualGoodsId');
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
            'expand': true, // 默认展开（对应小程序 Line 356）
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
  /// 参考 Chewie 官方示例：https://github.com/fluttercommunity/chewie
  Future<void> _initVideoPlayer(String url, double initialTime) async {
    try {
      debugPrint('🎬 [视频播放] 开始初始化播放器');
      
      // 1. 初始化 VideoPlayerController
      _videoPlayerController = await VideoPlayerManager.instance.initVideoPlayer(url);
      await _videoPlayerController!.initialize();
      
      // 2. 释放旧的 Chewie Controller
      _chewieController?.dispose();

      // 3. 创建 ChewieController（官方推荐配置）
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        // ✅ 使用视频原始宽高比（关键！）
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        startAt: Duration(seconds: initialTime.toInt()),
        // ✅ Material 风格控制条
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFF3B7BFB),
          handleColor: const Color(0xFF3B7BFB),
          backgroundColor: Colors.grey.shade300,
          bufferedColor: Colors.grey.shade400,
        ),
        // ✅ 占位符
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ),
        ),
        // ✅ 错误处理
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              '视频加载失败: $errorMessage',
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );

      // 4. 监听播放进度
      _videoPlayerController!.addListener(_onVideoProgress);

      // 5. 启动定时器保存进度
      _progressTimer?.cancel();
      _progressTimer = Timer.periodic(const Duration(seconds: 5), (_) {
        _saveProgress();
      });

      if (mounted) {
        setState(() {});
      }
      
      debugPrint('✅ [视频播放] 播放器初始化成功');
      debugPrint('📐 [视频比例] ${_videoPlayerController!.value.aspectRatio}');
      
    } catch (e) {
      debugPrint('❌ [视频播放] 初始化失败: $e');
      
      String errorMessage = '视频加载失败';
      
      // ✅ 检查错误类型，提供更友好的提示
      final errorString = e.toString().toLowerCase();
      
      if (e is VideoPlayerConflictException) {
        errorMessage = '播放器冲突：${e.message}';
      } else if (errorString.contains('mediacodec') ||
          errorString.contains('exoplaybackexception') ||
          errorString.contains('videorenderer')) {
        // ✅ MediaCodec 错误（硬件解码器不支持）
        errorMessage = '设备不支持该视频格式，请尝试：\n'
            '1. 更新系统到最新版本\n'
            '2. 重启应用后重试\n'
            '3. 联系客服获取帮助';
      } else if (errorString.contains('timeout') || errorString.contains('超时')) {
        errorMessage = '视频加载超时，请检查网络连接';
      } else if (errorString.contains('network') || errorString.contains('网络')) {
        errorMessage = '网络连接失败，请检查网络设置';
      } else {
        errorMessage = '视频加载失败：${e.toString()}';
      }
      
      if (mounted) {
        setState(() {
          _error = errorMessage;
        });
      }
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: '重试',
              textColor: Colors.white,
              onPressed: () {
                // ✅ 重试加载
                _loadVideoData();
              },
            ),
          ),
        );
      }
    }
  }

  /// 视频进度监听
  /// 对应小程序: newVideo.vue onTimeUpdate() + videoNearEnd()
  void _onVideoProgress() {
    if (_videoPlayerController != null &&
        _videoPlayerController!.value.isInitialized) {
      final newTime = _videoPlayerController!.value.position.inSeconds
          .toDouble();
      if ((newTime - _currentTime).abs() > 1) {
        _currentTime = newTime;
      }
      
      // ✅ 视频快结束时签到（对应小程序 videoNearEnd）
      // 小程序逻辑：Line 180-204
      final duration = _videoPlayerController!.value.duration.inSeconds.toDouble();
      final position = _videoPlayerController!.value.position.inSeconds.toDouble();
      
      // ✅ 剩余30秒时签到（只签到一次，防止重复调用）
      if (!_hasSignedIn && duration > 0 && (duration - position) <= 30) {
        _hasSignedIn = true; // ✅ 标记已签到
        _performClassSignin();
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
    if (_videoPlayerController == null ||
        !_videoPlayerController!.value.isInitialized ||
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
    final oldChewieController = _chewieController;
    final oldVideoPlayerController = _videoPlayerController;

    // ✅ 1. 立即更新UI状态，显示黑色背景
    setState(() {
      _chewieController = null;
      _videoPlayerController = null;
      _currentLessonId = lessonId;
      _lessonName = section['name']?.toString() ?? '';
    });

    // ✅ 2. 异步释放旧控制器（不阻塞UI）
    Future.microtask(() async {
      try {
        // ✅ 先暂停播放，防止 dispose 后计时器仍然触发
        await oldVideoPlayerController?.pause();
        // ✅ 稍微延迟，确保计时器停止
        await Future.delayed(const Duration(milliseconds: 100));
        // ✅ 释放 Chewie
        oldChewieController?.dispose();
        // ✅ 使用管理器释放 video_player
        VideoPlayerManager.instance.disposeVideoPlayer();
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
      appBar: AppBar(
        title: const Text('视频播放'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      // ✅ 不使用 SafeArea，让 Chewie 全屏时自动占满整个屏幕
      body: _error != null ? _buildError() : _buildContent(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text(
              _error ?? '加载失败',
              style: TextStyle(fontSize: 14.sp, color: Colors.red),
              textAlign: TextAlign.center,
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                // ✅ 清除错误状态后重试
                setState(() {
                  _error = null;
                });
                _loadVideoData();
              },
              child: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // ✅ 视频播放器区域（官方推荐：AspectRatio 包裹）
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            color: Colors.black,
            child: _chewieController != null &&
                    _chewieController!.videoPlayerController.value.isInitialized
                ? Chewie(controller: _chewieController!)
                : const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
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

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Text(
        _lessonName.isNotEmpty ? _lessonName : '课程名称',
        style: TextStyle(
          fontSize: 17.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF262629),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5E5E5),
            width: 1,
          ),
        ),
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
          padding: EdgeInsets.symmetric(vertical: 20.h),
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

  Widget _buildChapterList() {
    if (_chapterData.isEmpty) {
      return Center(
        child: Text(
          '暂无目录',
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF999999)),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _chapterData.length,
      itemBuilder: (context, index) {
        final chapter = _chapterData[index];
        return _buildChapterItem(chapter);
      },
    );
  }

  Widget _buildChapterItem(Map<String, dynamic> chapter) {
    final isExpanded = chapter['expand'] == true;
    final subs = chapter['subs'] as List? ?? [];

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
                  SizedBox(width: 8.w),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20.sp,
                    color: const Color(0xFF999999),
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

  Widget _buildSectionItem(Map<String, dynamic> section) {
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
                children: [
                  Text(
                    section['time']?.toString() ?? '',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF696E7A),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    section['name']?.toString() ?? '',
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
          "p": Style(
            margin: Margins.only(bottom: 12.h),
          ),
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
          "li": Style(
            margin: Margins.only(bottom: 6.h),
          ),
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
