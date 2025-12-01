import '../../../core/network/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 我的课程 Service
/// 对应小程序 API: /c/study/learning/series (myCourse)
class MyCourseService {
  final DioClient _dioClient;

  MyCourseService(this._dioClient);

  /// 获取我的课程列表
  /// API: GET /c/study/learning/series
  /// 对应小程序: study.myCourse
  ///
  /// 参数:
  /// - teaching_type: 授课方式 (3=录播课, 1=直播课)
  /// - page: 页码
  /// - size: 每页数量
  Future<Map<String, dynamic>> getMyCourseList({
    required String teachingType,
    int page = 1,
    int size = 10,
  }) async {
    try {
      final response = await _dioClient.get(
        '/c/study/learning/series',
        queryParameters: {
          'teaching_type': teachingType,
          'page': page,
          'size': size,
        },
      );

      print('\n========== 📚 [我的课程] API响应 ==========');
      print('📋 请求参数:');
      print('   - teaching_type: $teachingType');
      print('   - page: $page');
      print('   - size: $size');
      print('📦 响应码: ${response.data['code']}');
      print(
        '📊 数据条数: ${(response.data['data']?['list'] as List?)?.length ?? 0}',
      );
      print('=========================================\n');

      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取我的课程失败');
      }

      final data = response.data['data'];
      if (data == null) {
        return {'list': [], 'total': 0};
      }

      return {
        'list': (data['list'] as List?)?.cast<Map<String, dynamic>>() ?? [],
        'total': data['total'] ?? 0,
      };
    } catch (e) {
      print('❌ [我的课程] 加载失败: $e');
      rethrow;
    }
  }
}

final myCourseServiceProvider = Provider<MyCourseService>((ref) {
  return MyCourseService(ref.read(dioClientProvider));
});
