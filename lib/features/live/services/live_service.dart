import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_client.dart';
import '../models/live_url_model.dart';

part 'live_service.g.dart';

/// 直播服务 - 负责直播相关的网络请求
@riverpod
LiveService liveService(LiveServiceRef ref) {
  final dio = ref.read(dioClientProvider);
  return LiveService(dio);
}

class LiveService {
  final DioClient _dio;

  LiveService(this._dio);

  /// 获取直播/回放地址
  /// 对应小程序API: liveUrl()
  Future<LiveUrlResponse> getLiveUrl({
    required String lessonId,
  }) async {
    try {
      final response = await _dio.get(
        '/c/study/learning/live',
        queryParameters: {
          'lesson_id': lessonId,
        },
      );

      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取直播地址失败');
      }

      final data = response.data['data'];
      if (data == null) {
        throw Exception('直播数据为空');
      }

      return LiveUrlResponse.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('获取直播地址失败: $e');
    }
  }

  /// 添加学习数据(学习打卡)
  /// 对应小程序API: addStudyData()
  Future<void> addStudyData({
    required String lessonId,
    required String goodsId,
    required String orderId,
    String? goodsPid,
  }) async {
    try {
      final response = await _dio.post(
        '/c/live/data/add',
        data: {
          'lesson_id': lessonId,
          'goods_id': goodsId,
          'order_id': orderId,
          if (goodsPid != null) 'goods_pid': goodsPid,
        },
      );

      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '添加学习数据失败');
      }
    } catch (e) {
      // 学习打卡失败不影响直播观看，只记录日志
      print('添加学习数据失败: $e');
    }
  }
}
