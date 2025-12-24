import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yakaixin_app/core/utils/error_message_mapper.dart';
import '../models/video_state.dart';
import '../services/video_service.dart';
import '../../../core/storage/storage_service.dart';
import '../../../app/constants/storage_keys.dart';
import '../../../core/utils/safe_type_converter.dart';

/// 视频播放 Provider
/// 负责业务逻辑和状态管理
class VideoNotifier extends StateNotifier<VideoState> {
  final VideoService _videoService;
  final StorageService _storage;
  final String? initialLessonId;
  final String? goodsId;
  final String? filterGoodsId;
  final String? systemId;
  final String? classId;
  final String? name;
  final List<Map<String, dynamic>>? chapterData;

  VideoNotifier({
    required VideoService videoService,
    required StorageService storage,
    this.initialLessonId,
    this.goodsId,
    this.filterGoodsId,
    this.systemId,
    this.classId,
    this.name,
    this.chapterData,
  })  : _videoService = videoService,
        _storage = storage,
        super(VideoState(
          currentLessonId: initialLessonId ?? '',
          lessonName: name ?? '',
          chapterData: chapterData?.map((chapter) {
                return {...chapter, 'expand': true};
              }).toList() ??
              [],
        )) {
    _init();
  }

  /// 初始化
  Future<void> _init() async {
    // 优先使用传入的章节数据
    if (chapterData != null && chapterData!.isNotEmpty) {
      debugPrint('✅ [Provider] 使用传入的章节数据，共 ${chapterData!.length} 个');
    }

    // 后台加载讲义
    if (systemId != null && systemId!.isNotEmpty) {
      loadHandout(systemId!);
    }

    // 加载视频数据
    await loadVideoData();
  }

  /// 加载视频数据
  Future<void> loadVideoData() async {
    if (state.currentLessonId.isEmpty) {
      state = state.copyWith(error: '课程ID为空');
      return;
    }

    try {
      final userInfo = _storage.getJson(StorageKeys.userInfo);
      final studentId = userInfo?['student_id']?.toString() ?? '';

      // 1. 获取录播地址
      final playbackPath = await _videoService.getPlaybackPath(
        lessonId: state.currentLessonId,
      );

      // 拼接完整URL
      String videoUrl = playbackPath;
      if (!videoUrl.startsWith('http://') &&
          !videoUrl.startsWith('https://')) {
        videoUrl = 'https://yakaixin.oss-cn-beijing.aliyuncs.com/$videoUrl';
      }
      videoUrl = Uri.decodeComponent(videoUrl);

      state = state.copyWith(videoUrl: videoUrl);

      // 2. 如果没有章节数据，加载章节
      if (state.chapterData.isEmpty &&
          studentId.isNotEmpty &&
          goodsId != null) {
        await _loadGoodsDetailAndChapter(studentId);
      }
    } on DioException catch (e) {
      // ✅ 使用拦截器已处理好的用户友好错误信息
      final errorMsg = e.error?.toString() ?? '加载视频失败，请稍后重试';
      state = state.copyWith(error: errorMsg);
    } catch (e) {
      // ✅ 兜底：未预期的错误
      state = state.copyWith(error: '加载视频失败，请稍后重试');
    }
  }

  /// 加载商品详情并获取章节
  Future<void> _loadGoodsDetailAndChapter(String studentId) async {
    if (goodsId == null || goodsId!.isEmpty) return;

    try {
      final goodsDetail = await _videoService.getGoodsDetail(
        goodsId: goodsId!,
        userId: studentId,
        studentId: studentId,
      );

      // 选择实际的课程ID
      String? actualGoodsId;
      if (filterGoodsId != null && filterGoodsId!.isNotEmpty) {
        actualGoodsId = filterGoodsId;
      } else if (goodsDetail.detailPackageGoods != null &&
          goodsDetail.detailPackageGoods!.isNotEmpty) {
        actualGoodsId = SafeTypeConverter.toSafeString(
          goodsDetail.detailPackageGoods![0].id,
        );
      } else {
        actualGoodsId = goodsId;
      }

      // 获取章节列表
      if (actualGoodsId != null && actualGoodsId.isNotEmpty) {
        await loadChapterList(studentId, actualGoodsId);
      }
    } catch (e) {
      debugPrint('❌ [Provider] 加载商品详情&章节失败: $e');
    }
  }

  /// 加载章节列表
  Future<void> loadChapterList(String studentId, String goodsId) async {
    if (goodsId.isEmpty || studentId.isEmpty) return;

    try {
      final chapters = await _videoService.getChapterList(
        goodsId: goodsId,
        studentId: studentId,
      );

      state = state.copyWith(
        chapterData: chapters.map((chapter) {
          return {...chapter, 'expand': true};
        }).toList(),
      );
    } catch (e) {
      debugPrint('❌ [Provider] 加载章节失败: $e');
    }
  }

  /// 加载讲义
  Future<void> loadHandout(String systemId) async {
    try {
      final content = await _videoService.getHandout(
        teachingSystemRelationId: systemId,
      );
      state = state.copyWith(handoutContent: content);
    } catch (e) {
      debugPrint('❌ [Provider] 加载讲义失败: $e');
    }
  }

  /// 切换课节
  Future<void> switchLesson(Map<String, dynamic> section) async {
    final lessonId = section['lesson_id']?.toString() ?? '';
    if (lessonId.isEmpty || lessonId == '0') {
      return; // View 层处理提示
    }

    final systemId = section['system_id']?.toString() ?? '';
    final lessonName = section['name']?.toString() ?? '';

    // 重置签到标志
    state = state.copyWith(
      currentLessonId: lessonId,
      lessonName: lessonName,
      hasSignedIn: false,
    );

    // 后台加载讲义
    if (systemId.isNotEmpty) {
      loadHandout(systemId);
    }

    // 加载新视频
    await loadVideoData();
  }

  /// 课程签到
  Future<void> performClassSignin() async {
    if (state.currentLessonId.isEmpty || state.hasSignedIn) return;

    try {
      final userInfo = _storage.getJson(StorageKeys.userInfo);
      final studentId = userInfo?['student_id']?.toString() ?? '';
      if (studentId.isEmpty) return;

      await _videoService.classSignin(
        lessonId: state.currentLessonId,
        classId: classId,
        studentId: studentId,
      );

      state = state.copyWith(hasSignedIn: true);
      debugPrint('✅ [Provider] 签到成功');
    } catch (e) {
      debugPrint('❌ [Provider] 签到失败: $e');
    }
  }

  /// 更新当前播放时间
  void updateCurrentTime(double time) {
    state = state.copyWith(currentTime: time);
  }

  /// 切换 Tab
  void switchTab(int index) {
    state = state.copyWith(tabIndex: index);
  }

  /// 切换章节展开状态
  void toggleChapterExpand(int index) {
    final chapters = List<Map<String, dynamic>>.from(state.chapterData);
    chapters[index]['expand'] = !(chapters[index]['expand'] as bool? ?? true);
    state = state.copyWith(chapterData: chapters);
  }
}

/// VideoNotifier Provider
final videoNotifierProvider = StateNotifierProvider.family
    .autoDispose<VideoNotifier, VideoState, Map<String, dynamic>>(
  (ref, params) {
    return VideoNotifier(
      videoService: ref.read(videoServiceProvider),
      storage: ref.read(storageServiceProvider),
      initialLessonId: params['lessonId'] as String?,
      goodsId: params['goodsId'] as String?,
      filterGoodsId: params['filterGoodsId'] as String?,
      systemId: params['systemId'] as String?,
      classId: params['classId'] as String?,
      name: params['name'] as String?,
      chapterData: params['chapterData'] as List<Map<String, dynamic>>?,
    );
  },
);
