import '../../../core/network/dio_client.dart';
import '../models/learning_data_model.dart';
import '../models/score_report_model.dart';

/// 报告中心Service
/// 对应小程序: src/modules/jintiku/api/userInfo.js
class ReportService {
  final DioClient _dioClient;

  ReportService(this._dioClient);

  /// 获取学习数据
  /// 对应小程序: getLearningData
  /// 接口: GET /c/tiku/exam/learning/data
  Future<LearningDataModel> getLearningData() async {
    try {
      final response = await _dioClient.get('/c/tiku/exam/learning/data');

      // 检查响应码
      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取学习数据失败');
      }

      final data = response.data['data'];
      if (data == null) {
        throw Exception('学习数据为空');
      }

      return LearningDataModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('获取学习数据失败: $e');
    }
  }

  /// 获取成绩报告列表
  /// 对应小程序: getScorereporting
  /// 接口: GET /c/tiku/exam/scorereporting/list
  /// @param examinationName 考试名称(可选)
  Future<List<ScoreReportModel>> getScoreReporting({
    String? examinationName,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (examinationName != null && examinationName.isNotEmpty) {
        queryParams['examination_name'] = examinationName;
      }

      final response = await _dioClient.get(
        '/c/tiku/exam/scorereporting/list',
        queryParameters: queryParams,
      );

      // 检查响应码
      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取成绩报告失败');
      }

      final data = response.data['data'];
      if (data == null) {
        return [];
      }

      if (data is! List) {
        throw Exception('成绩报告数据格式错误');
      }

      return data
          .map((item) =>
              ScoreReportModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('获取成绩报告失败: $e');
    }
  }
}
