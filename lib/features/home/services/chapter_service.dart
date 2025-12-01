import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../models/question_bank_model.dart';

/// 章节练习服务
/// 对应小程序: api/chapter.js, api/index.js
/// API: /c/tiku/chapter/list, /c/tiku/homepage/recommend/chapterpackage
class ChapterService {
  final DioClient _dioClient;

  ChapterService(this._dioClient);

  /// 获取章节列表
  /// API: GET /c/tiku/chapter/list
  Future<List<ChapterModel>> getChapterList({
    required String professionalId,
  }) async {
    try {
      final response = await _dioClient.get(
        '/c/tiku/chapter/list',
        queryParameters: {'professional_id': professionalId},
      );

      // 统一处理响应码
      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取章节列表失败');
      }

      final data = response.data['data'];
      if (data == null) {
        throw Exception('章节列表数据为空');
      }

      // ✅ 修复：小程序返回的是 section_info 字段
      final list = (data['section_info'] as List?) ?? [];
      return list
          .map((item) => ChapterModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('网络请求失败: ${e.message}');
    } catch (e) {
      throw Exception('获取章节列表失败: $e');
    }
  }

  /// 获取技能模拟数据
  /// API: GET /c/tiku/homepage/recommend/chapterpackage
  Future<SkillMockModel?> getSkillMock({required String professionalId}) async {
    try {
      final response = await _dioClient.get(
        '/c/tiku/homepage/recommend/chapterpackage',
        queryParameters: {
          'professional_id': professionalId,
          'position_identify': 'jinengmoni',
        },
      );

      // 统一处理响应码
      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取技能模拟失败');
      }

      final data = response.data['data'];
      if (data == null || data['id'] == 0 || data['id'] == '0') {
        return null; // 没有技能模拟数据
      }

      return SkillMockModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('网络请求失败: ${e.message}');
    } catch (e) {
      throw Exception('获取技能模拟失败: $e');
    }
  }
}

/// ChapterService Provider
final chapterServiceProvider = Provider<ChapterService>((ref) {
  return ChapterService(ref.read(dioClientProvider));
});
