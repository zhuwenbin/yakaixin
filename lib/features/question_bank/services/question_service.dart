import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';

/// 题目服务
/// 对应小程序: api/commen.js
class QuestionService {
  final DioClient _dioClient;

  QuestionService(this._dioClient);

  /// 获取题目列表
  /// 对应小程序: getQuestionsList (Line 6-12)
  /// API: GET /c/tiku/question/getquestionlist
  Future<Map<String, dynamic>> getQuestionsList({
    required String knowledgeId,
    required String type,
    String? chapterId,
    String? teachingSystemPackageId,
    String? professionalId,
    String isLookBack = '2',
  }) async {
    print('🔍 [QuestionService] 开始获取题目列表');
    print('   - knowledgeId: $knowledgeId');
    print('   - type: $type');
    print('   - chapterId: $chapterId');
    
    try {
      final response = await _dioClient.get(
        '/c/tiku/question/getquestionlist',
        queryParameters: {
          'knowledge_id': knowledgeId,
          'type': type,
          if (chapterId != null) 'chapter_id': chapterId,
          if (teachingSystemPackageId != null) 
            'teaching_system_package_id': teachingSystemPackageId,
          if (professionalId != null) 'professional_id': professionalId,
          'is_look_back': isLookBack,
        },
      );

      print('📥 [QuestionService] 接口响应: code=${response.data['code']}');

      // 统一处理响应码
      if (response.data['code'] != 100000) {
        final errorMsg = response.data['msg']?.first ?? '获取题目失败';
        print('❌ [QuestionService] 接口返回错误: $errorMsg');
        throw Exception(errorMsg);
      }

      final data = response.data['data'];
      if (data == null) {
        print('⚠️ [QuestionService] 题目数据为空');
        return {
          'list': [],
          'total': 0,
        };
      }

      // 小程序使用 section_info 字段
      final sectionInfo = (data['section_info'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      final total = sectionInfo.length;
      
      print('✅ [QuestionService] 题目加载成功: ${sectionInfo.length}道题');
      print('✅ [QuestionService] product_id: ${data['product_id']}');
      
      return {
        'list': sectionInfo,
        'total': total,
        'product_id': data['product_id'],
      };
    } on DioException catch (e) {
      print('❌ [QuestionService] 网络请求失败: ${e.message}');
      throw Exception('网络请求失败: ${e.message}');
    } catch (e, stackTrace) {
      print('❌ [QuestionService] 未知错误: $e');
      print('❌ [QuestionService] 堆栈: $stackTrace');
      throw Exception('获取题目失败: $e');
    }
  }

  /// ⚠️ 提交答案功能已迁移到 ExamService.submitAnswer()
  /// 章节练习、试卷考试、模拟考试统一使用 ExamService.submitAnswer()
  /// 对应小程序接口: /c/tiku/question/answer (index.js Line 210-219)

  /// 收藏题目
  /// 对应小程序: collect (Line 22-28)
  /// API: GET /c/tiku/question/practice/collect
  Future<void> collectQuestion({
    required String questionId,
    required String isCollect, // '1'-收藏 '2'-取消收藏
  }) async {
    print('⭐ [QuestionService] ${isCollect == '1' ? '收藏' : '取消收藏'}题目: $questionId');
    
    try {
      final response = await _dioClient.get(
        '/c/tiku/question/practice/collect',
        queryParameters: {
          'question_id': questionId,
          'is_collect': isCollect,
        },
      );

      if (response.data['code'] != 100000) {
        final errorMsg = response.data['msg']?.first ?? '操作失败';
        print('❌ [QuestionService] 收藏失败: $errorMsg');
        throw Exception(errorMsg);
      }

      print('✅ [QuestionService] 收藏操作成功');
    } on DioException catch (e) {
      print('❌ [QuestionService] 网络请求失败: ${e.message}');
      throw Exception('网络请求失败: ${e.message}');
    } catch (e) {
      print('❌ [QuestionService] 收藏操作失败: $e');
      throw Exception('收藏操作失败: $e');
    }
  }

  /// 题目纠错
  /// 对应小程序: correction (Line 30-38)
  /// API: POST /c/tiku/question/correction
  Future<void> correctQuestion({
    required String questionId,
    required String content,
  }) async {
    print('📝 [QuestionService] 提交纠错: $questionId');
    
    try {
      final response = await _dioClient.post(
        '/c/tiku/question/correction',
        data: {
          'question_id': questionId,
          'content': content,
        },
      );

      if (response.data['code'] != 100000) {
        final errorMsg = response.data['msg']?.first ?? '提交纠错失败';
        print('❌ [QuestionService] 纠错失败: $errorMsg');
        throw Exception(errorMsg);
      }

      print('✅ [QuestionService] 纠错提交成功');
    } on DioException catch (e) {
      print('❌ [QuestionService] 网络请求失败: ${e.message}');
      throw Exception('网络请求失败: ${e.message}');
    } catch (e) {
      print('❌ [QuestionService] 纠错提交失败: $e');
      throw Exception('纠错提交失败: $e');
    }
  }
}

/// QuestionService Provider
final questionServiceProvider = Provider<QuestionService>((ref) {
  return QuestionService(ref.read(dioClientProvider));
});
