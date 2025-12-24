import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../core/network/dio_client.dart';
import '../views/live_player_page.dart';
import '../views/video_index_page.dart';

/// 课程导航辅助类
/// 
/// 对应小程序: courseList.vue goLookCourse()
/// 功能：根据课程类型跳转到对应播放页面
class CourseNavigationHelper {
  CourseNavigationHelper._();

  /// 跳转到课程播放页面
  /// 
  /// 对应小程序逻辑（完全一致）:
  /// ```javascript
  /// // 录播课程 (teaching_type == "3")
  /// playbackPath({ lesson_id }).then(res => {
  ///   const path = this.completePath(res.data.path);
  ///   this.$xh.push('jintiku', `pages/study/newVideo/index?url=${encodeURIComponent(path)}...`);
  /// });
  /// 
  /// // 直播课程 (teaching_type == "1")
  /// study.liveUrl({ lesson_id }).then(({ data }) => {
  ///   if (data.playback_url) {
  ///     // 有回放 → 跳转视频播放页（回放web）
  ///     this.$xh.push('jintiku', `pages/study/video/index?url=${encodeURIComponent(data.playback_url)}...`);
  ///   } else {
  ///     // 无回放 → 跳转直播web页面
  ///     const longUrl = data.live_url + '&enterH5=true&dsp=1&disable_ppt_animate=1';
  ///     this.$xh.push('jintiku', `pages/study/live/index?lesson_id=${lesson_id}&url=${encodeURIComponent(longUrl)}`);
  ///   }
  /// });
  /// ```
  /// 
  /// 参数:
  /// - context: BuildContext
  /// - ref: WidgetRef
  /// - lessonId: 课节ID
  /// - lessonName: 课节名称（用于显示AppBar标题）
  /// - teachingType: 教学类型（"1": 直播, "3": 录播）
  /// - classId: 班级ID（可选，用于签到接口）
  /// - chapterData: 章节数据（可选，用于显示目录）
  /// - goodsId: 商品ID（可选）
  /// - orderId: 订单ID（可选）
  /// - systemId: 系统ID（可选，用于讲义）
  /// 
  /// 返回:
  /// - Future<void>
  static Future<void> navigateToLesson({
    required BuildContext context,
    required WidgetRef ref,
    required String lessonId,
    required String lessonName,
    required String teachingType,
    String? classId, // ✅ 新增参数：班级ID（用于签到）
    List<Map<String, dynamic>>? chapterData, // ✅ 章节数据
    String? goodsId, // ✅ 商品ID
    String? orderId, // ✅ 订单ID
    String? systemId, // ✅ 系统ID
  }) async {
    try {
      EasyLoading.show(status: '加载中...');
      final dio = ref.read(dioClientProvider);

      // ✅ 录播课程（teaching_type == "3"）
      if (teachingType == '3') {
        debugPrint('📹 [课程跳转] 录播课程，跳转到视频播放页（VideoIndexPage）');
        
        // ✅ 直接跳转到视频播放页面，让VideoIndexPage自己调用接口获取视频地址
        // 对应小程序: pages/study/newVideo/index
        EasyLoading.dismiss();
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoIndexPage(
              lessonId: lessonId,
              name: lessonName,
              classId: classId, // ✅ 传递 classId（用于签到）
              chapterData: chapterData, // ✅ 传递章节数据（用于显示目录）
              goodsId: goodsId, // ✅ 传递商品ID
              orderId: orderId, // ✅ 传递订单ID
              systemId: systemId, // ✅ 传递系统ID（用于讲义）
            ),
          ),
        );
        return;
      }

      // ✅ 直播课程（teaching_type == "1"）
      if (teachingType == '1') {
        debugPrint('📺 [课程跳转] 直播课程，调用 liveUrl 接口');
        
        // 1. 调用 liveUrl 接口
        final response = await dio.get(
          '/c/study/learning/live',
          queryParameters: {'lesson_id': lessonId},
        );

        EasyLoading.dismiss();

        if (response.data['code'] != 100000) {
          throw Exception(response.data['msg']?.first ?? '获取直播地址失败');
        }

        final data = response.data['data'];
        if (data == null) {
          throw Exception('直播数据为空');
        }

        // 2. 判断是否有回放
        if (data['playback_url'] != null && data['playback_url'].toString().isNotEmpty) {
          // ✅ 有回放 → 跳转视频播放页（回放web）
          final playbackUrl = data['playback_url'].toString();
          debugPrint('📹 [课程跳转] 有回放，跳转到视频播放页（回放web）');
          debugPrint('📹 [课程跳转] playback_url: $playbackUrl');
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LivePlayerPage(
                lessonId: lessonId,
                liveUrl: playbackUrl,
                lessonName: lessonName,
              ),
            ),
          );
        } else if (data['live_url'] != null && data['live_url'].toString().isNotEmpty) {
          // ✅ 无回放 → 跳转直播web页面
          // 添加小程序同样的参数: &enterH5=true&dsp=1&disable_ppt_animate=1
          final liveUrl = data['live_url'].toString();
          final fullLiveUrl = liveUrl.contains('?')
              ? '$liveUrl&enterH5=true&dsp=1&disable_ppt_animate=1'
              : '$liveUrl?enterH5=true&dsp=1&disable_ppt_animate=1';
          
          debugPrint('📺 [课程跳转] 无回放，跳转到直播web页面');
          debugPrint('📺 [课程跳转] live_url: $fullLiveUrl');

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LivePlayerPage(
                lessonId: lessonId,
                liveUrl: fullLiveUrl,
                lessonName: lessonName,
              ),
            ),
          );
        } else {
          // ❌ 无数据
          throw Exception('直播地址和回放地址均为空');
        }
        return;
      }

      // ❌ 其他类型不处理
      EasyLoading.dismiss();
      debugPrint('⚠️ [课程跳转] 未知课程类型，teaching_type: $teachingType');
      
    } on DioException catch (e) {
      EasyLoading.dismiss();
      // ✅ 使用拦截器已处理好的用户友好错误信息
      final errorMsg = e.error?.toString() ?? '加载失败，请稍后重试';
      debugPrint('❌ [课程跳转] 跳转失败: $errorMsg');
      
      EasyLoading.showError(errorMsg);
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('❌ [课程跳转] 未预期错误: $e');
      
      EasyLoading.showError('加载失败，请稍后重试');
    }
  }

  /// 跳转到直播页面（直接使用lessonId，自动获取live_url）
  /// 
  /// 参数:
  /// - context: BuildContext
  /// - lessonId: 课节ID
  /// 
  /// 说明:
  /// - LivePlayerPage会自动调用 /c/study/learning/live 接口获取 live_url
  /// - 无需手动传入 liveUrl 参数
  static Future<void> navigateToLive({
    required BuildContext context,
    required String lessonId,
  }) async {
    debugPrint('📺 [课程跳转] 跳转到直播页（自动获取live_url）');
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivePlayerPage(
          lessonId: lessonId,
          // ✅ 不传 liveUrl，让 LivePlayerPage 自己调用接口获取
        ),
      ),
    );
  }
  
  /// 跳转到直播页面（使用已知的live_url）
  /// 
  /// 参数:
  /// - context: BuildContext
  /// - lessonId: 课节ID
  /// - liveUrl: 直播URL
  /// 
  /// 说明:
  /// - 如果已经有 live_url，可以直接传入，避免重复请求
  static Future<void> navigateToLiveWithUrl({
    required BuildContext context,
    required String lessonId,
    required String liveUrl,
  }) async {
    debugPrint('📺 [课程跳转] 跳转到直播页（使用传入的live_url）');
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivePlayerPage(
          lessonId: lessonId,
          liveUrl: liveUrl, // ✅ 传入已有的 liveUrl
        ),
      ),
    );
  }

  /// 跳转到视频播放页面（直接使用已知的lessonId）
  /// 
  /// 参数:
  /// - context: BuildContext
  /// - lessonId: 课节ID
  static Future<void> navigateToVideo({
    required BuildContext context,
    required String lessonId,
  }) async {
    debugPrint('📹 [课程跳转] 直接跳转到视频播放页');
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoIndexPage(
          lessonId: lessonId,
        ),
      ),
    );
  }
}
