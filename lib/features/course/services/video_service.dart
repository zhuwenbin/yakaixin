import '../../../core/network/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../goods/services/goods_service.dart';
import '../../goods/models/goods_detail_model.dart';

/// 视频播放 Service
/// 对应小程序 API: playbackPath, getHandout, chapterpaper
class VideoService {
  final DioClient _dioClient;
  final GoodsService _goodsService;

  VideoService(this._dioClient, this._goodsService);

  /// 获取录播地址
  /// API: /c/study/learning/playback
  /// 对应小程序: playbackPath
  Future<String> getPlaybackPath({required String lessonId}) async {
    try {
      final response = await _dioClient.get(
        '/c/study/learning/playback',
        queryParameters: {'lesson_id': lessonId},
      );

      print('\n========== 🎬 [录播地址] API响应 ==========');
      print('📋 请求参数: lesson_id=$lessonId');
      print('📦 响应数据: ${response.data}');
      print('=========================================\n');

      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取录播地址失败');
      }

      final data = response.data['data'];
      if (data == null || data['path'] == null) {
        throw Exception('录播地址为空');
      }

      return data['path'] as String;
    } catch (e) {
      print('❌ [录播地址] 加载失败: $e');
      rethrow;
    }
  }

  /// 获取讲义内容
  /// API: /c/study/learning/resource/handout
  /// 对应小程序: getHandout
  Future<String> getHandout({required String teachingSystemRelationId}) async {
    try {
      final response = await _dioClient.get(
        '/c/study/learning/resource/handout',
        queryParameters: {
          'teaching_system_relation_id': teachingSystemRelationId,
        },
      );

      print('\n========== 📄 [讲义内容] API响应 ==========');
      print('📋 请求参数: teaching_system_relation_id=$teachingSystemRelationId');
      print('📦 响应数据: ${response.data}');
      print('=========================================\n');

      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取讲义失败');
      }

      final data = response.data['data'];
      if (data == null || data['content'] == null) {
        return '';
      }

      return data['content'] as String;
    } catch (e) {
      print('❌ [讲义内容] 加载失败: $e');
      return '';
    }
  }

  /// 获取课程目录（章节列表）
  /// API: /c/goods/v2/chapter
  /// 对应小程序: chapterpaper
  Future<List<Map<String, dynamic>>> getChapterList({
    required String goodsId,
    required String studentId,
  }) async {
    try {
      final response = await _dioClient.get(
        '/c/goods/v2/chapter',
        queryParameters: {
          'goods_id': goodsId,
          'student_id': studentId,
          'no_professional_id': '1',  // ✅ 关键修复：对应小程序 newVideo.vue Line 332
        },
      );

      print('\n========== 📚 [课程目录] API响应 ==========');
      print('📋 请求参数: goods_id=$goodsId, student_id=$studentId');
      print('📦 响应数据: ${response.data}');
      print('=========================================\n');

      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取课程目录失败');
      }

      final data = response.data['data'];
      if (data == null) {
        return [];
      }

      // API返回的是数组
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      }

      return [];
    } catch (e) {
      print('❌ [课程目录] 加载失败: $e');
      return [];
    }
  }

  /// 获取商品详情
  /// API: /c/goods/v2/detail
  /// 对应小程序: getGoodsDetail
  /// ✅ 关键：视频播放页调用时需要传 userId + studentId
  Future<GoodsDetailModel> getGoodsDetail({
    required String goodsId,
    String? userId,      // ✅ 新增：对应小程序 user_id
    String? studentId,   // ✅ 新增：对应小程序 student_id
  }) async {
    return await _goodsService.getGoodsDetail(
      goodsId: goodsId,
      userId: userId,
      studentId: studentId,
    );
  }
}

/// Provider
final videoServiceProvider = Provider<VideoService>((ref) {
  return VideoService(
    ref.read(dioClientProvider),
    ref.read(goodsServiceProvider),
  );
});
