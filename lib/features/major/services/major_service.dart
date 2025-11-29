import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../models/major_model.dart';

/// 专业服务
/// 对应小程序: api/index.js Line 299-322
class MajorService {
  final DioClient _dioClient;

  MajorService(this._dioClient);

  /// 获取专业列表
  /// 对应小程序: getMajor (select-major.vue Line 74-89)
  /// 接口: GET /c/teaching/mapping/tree
  /// 参数:
  ///   - code: 'professional' (固定值)
  ///   - is_auth: 2 (固定值)
  ///   - is_usable: 1 (固定值)
  ///   - is_standard: 0 (固定值)
  ///   - professional_ids: '' (固定值)
  Future<MajorListResponse> getMajorList() async {
    final response = await _dioClient.get(
      '/c/teaching/mapping/tree',
      queryParameters: {
        'code': 'professional',
        'is_auth': 2,
        'is_usable': 1,
        'is_standard': 0,
        'professional_ids': '',
      },
    );

    return MajorListResponse.fromJson(response.data);
  }

  /// 选择/切换专业
  /// 对应小程序: checkMajor (select-major.vue Line 102-117)
  /// 接口: PUT /c/student
  /// 参数:
  ///   - id: student_id (学生ID)
  ///   - major_id: 选择的专业ID
  Future<void> selectMajor({
    required String studentId,
    required String majorId,
  }) async {
    await _dioClient.put(
      '/c/student',
      data: {
        'id': studentId,
        'major_id': majorId,
      },
    );
  }
}

/// Provider
final majorServiceProvider = Provider<MajorService>((ref) {
  final dioClient = ref.read(dioClientProvider);
  return MajorService(dioClient);
});
