import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../models/question_bank_model.dart';

/// 学习数据服务
/// 对应小程序: src/modules/jintiku/pages/index/index.vue
/// API: /c/tiku/exam/learning/data, /c/tiku/exam/checkin/data
class LearningService {
  final DioClient _dioClient;

  LearningService(this._dioClient);

  /// 获取学习数据
  /// 对应小程序 Line 323-360
  /// API: GET /c/tiku/exam/learning/data
  Future<LearningDataModel> getLearningData({
    required String professionalId,
    String? userId,
    String? studentId,
  }) async {
    try {
      final response = await _dioClient.get(
        '/c/tiku/exam/learning/data',
        queryParameters: {
          'professional_id': professionalId,
          if (userId != null) 'user_id': userId,
          if (studentId != null) 'student_id': studentId,
        },
      );

      // 统一处理响应码
      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取学习数据失败');
      }

      final data = response.data['data'];
      if (data == null) {
        throw Exception('学习数据为空');
      }

      return LearningDataModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('网络请求失败: ${e.message}');
    } catch (e) {
      throw Exception('获取学习数据失败: $e');
    }
  }

  /// 打卡
  /// 对应小程序 Line 302-322
  /// API: POST /c/tiku/exam/checkin/data
  Future<void> checkIn({required String professionalId}) async {
    try {
      final response = await _dioClient.post(
        '/c/tiku/exam/checkin/data',
        data: {'professional_id': professionalId},
        // ✅ 小程序指定了 Content-Type: application/json
        options: Options(contentType: Headers.jsonContentType),
      );

      // 统一处理响应码
      if (response.data['code'] != 100000) {
        final errorMsg = response.data['msg']?.first ?? '打卡失败';
        throw Exception(errorMsg);
      }
    } on DioException catch (e) {
      throw Exception('网络请求失败: ${e.message}');
    } catch (e) {
      throw Exception('打卡失败: $e');
    }
  }
}

/// LearningService Provider
final learningServiceProvider = Provider<LearningService>((ref) {
  return LearningService(ref.read(dioClientProvider));
});
