import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';  // ✅ 添加 Riverpod
import 'package:yakaixin_app/core/network/dio_client.dart';
import 'package:yakaixin_app/features/exam/models/paper_model.dart';
import 'package:yakaixin_app/features/exam/models/question_model.dart';
import 'package:yakaixin_app/features/home/models/goods_model.dart';
import 'package:yakaixin_app/features/model_exam/models/exam_info_detail_model.dart';

/// 考试服务
/// 对应小程序: pages/test/exam.vue 的 API 调用
class ExamService {
  final DioClient _dioClient;

  ExamService(this._dioClient);

  /// 获取商品详情
  /// 对应小程序: getGoodsDetail Line 162-207
  /// ⚠️ 修复：使用正确的接口路径 /c/goods/v2/detail (对应小程序 Line 892)
  Future<GoodsModel> getGoodsDetail({required String goodsId}) async {
    try {
      final response = await _dioClient.get(
        '/c/goods/v2/detail', // ✅ 修复：使用 detail 接口
        queryParameters: {'goods_id': goodsId},
      );

      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取商品详情失败');
      }

      final data = response.data['data'];
      if (data == null) {
        throw Exception('商品数据为空');
      }

      return GoodsModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('获取商品详情失败: $e');
    }
  }

  /// 获取试卷列表
  /// 对应小程序: paper API Line 979-985
  /// 对应小程序调用: Line 154-160 (data_type == '1')
  Future<List<PaperModel>> getPaperList({
    required String goodsId,
    required String orderId,
  }) async {
    try {
      final response = await _dioClient.get(
        '/c/goods/v2/paper',
        queryParameters: {'id': goodsId, 'order_id': orderId},
      );

      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取试卷列表失败');
      }

      final data = response.data['data'];
      if (data == null || data is! List) {
        return [];
      }

      return (data as List).map((item) => PaperModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception('获取试卷列表失败: $e');
    }
  }

  /// 获取章节试卷列表
  /// 对应小程序: chapterpaper API Line 994-1000
  /// 对应小程序调用: Line 146-152 (data_type == '3')
  Future<List<ChapterPaperModel>> getChapterPaperList({
    required String goodsId,
    required String orderId,
  }) async {
    try {
      final response = await _dioClient.get(
        '/c/goods/v2/chapter',
        queryParameters: {'id': goodsId, 'order_id': orderId},
      );

      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取章节试卷失败');
      }

      final data = response.data['data'];
      if (data == null || data is! List) {
        return [];
      }

      return (data as List)
          .map((item) => ChapterPaperModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('获取章节试卷失败: $e');
    }
  }

  /// 获取测评试题列表（课前测/课后测等）
  /// 对应小程序: answertest/answer.vue getList() → getQuestionList({ paper_version_id, type: "8" })
  /// 接口: GET /c/tiku/question/getquestionlist
  Future<List<QuestionModel>> getQuestionListForEvaluation({
    required String paperVersionId,
  }) async {
    try {
      final response = await _dioClient.get(
        '/c/tiku/question/getquestionlist',
        queryParameters: {
          'paper_version_id': paperVersionId,
          'type': '8',
        },
      );

      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取试题列表失败');
      }

      final data = response.data['data'];
      if (data == null) {
        throw Exception('试题数据为空');
      }

      final sectionInfo = data['section_info'];
      if (sectionInfo == null || sectionInfo is! List) {
        return [];
      }

      return (sectionInfo as List).map((item) {
        final questionData = item as Map<String, dynamic>;
        if (!questionData.containsKey('question_id')) {
          questionData['question_id'] = questionData['id'];
        }
        return QuestionModel.fromJson(questionData);
      }).toList();
    } catch (e) {
      throw Exception('获取试题列表失败: $e');
    }
  }

  /// 获取试题列表（正式考试/模拟考）
  /// 对应小程序接口: /c/tiku/chapter/getquestionlist
  /// 对应小程序调用: examinationing.vue Line 519-522
  ///
  /// 参数说明:
  /// - examination_id: 考试ID
  /// - examination_session_id: 考试会话ID
  /// - professional_id: 专业ID
  /// - paper_version_id: 试卷版本ID
  /// - type: 类型 (7-正式考试)
  Future<List<QuestionModel>> getQuestionList({
    required String examinationId,
    required String examinationSessionId,
    required String professionalId,
    required String paperVersionId,
    required String type,
  }) async {
    try {
      final response = await _dioClient.get(
        '/c/tiku/chapter/getquestionlist',
        queryParameters: {
          'examination_id': examinationId,
          'examination_session_id': examinationSessionId,
          'professional_id': professionalId,
          'paper_version_id': paperVersionId,
          'type': type,
        },
      );

      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取试题列表失败');
      }

      final data = response.data['data'];
      if (data == null) {
        throw Exception('试题数据为空');
      }

      // 解析 section_info 列表
      final sectionInfo = data['section_info'];
      if (sectionInfo == null || sectionInfo is! List) {
        return [];
      }

      // ✅ 关键修复：像小程序一样添加 question_id 字段
      // 对应小程序 answer.vue Line 408-411: question_id: question_list[i].id
      return (sectionInfo as List).map((item) {
        final questionData = item as Map<String, dynamic>;
        // ✅ 如果没有 question_id，则从 id 复制
        if (!questionData.containsKey('question_id')) {
          questionData['question_id'] = questionData['id'];
        }
        return QuestionModel.fromJson(questionData);
      }).toList();
    } catch (e) {
      throw Exception('获取试题列表失败: $e');
    }
  }

  /// 获取学生考试信息
  /// 对应小程序接口: /c/tiku/mockexam/getstudentexaminfo
  /// 对应小程序调用: examinationing.vue Line 561-565
  ///
  /// 用于获取考试时间、状态等信息
  Future<ExamInfoModel> getStudentExamInfo({
    required String examId,
    required String examRoundId,
  }) async {
    try {
      final response = await _dioClient.get(
        '/c/tiku/mockexam/getstudentexaminfo',
        queryParameters: {'exam_id': examId, 'exam_round_id': examRoundId},
      );

      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取考试信息失败');
      }

      final data = response.data['data'];
      if (data == null) {
        throw Exception('考试信息为空');
      }

      return ExamInfoModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('获取考试信息失败: $e');
    }
  }

  /// 收藏题目
  /// 对应小程序: bottom-utils.vue Line 159-178
  /// 对应接口: /c/tiku/question/practice/collect
  /// 
  /// 参数说明:
  /// - questionVersionId: 题目版本ID (question_version_id)
  /// - status: 收藏状态 ('1'-收藏, '2'-取消收藏)
  /// - type: 类型 ('1'-收藏)
  Future<void> collectQuestion({
    required String questionVersionId,
    required String status,
  }) async {
    try {
      final response = await _dioClient.get(
        '/c/tiku/question/practice/collect',
        queryParameters: {
          'question_version_id': questionVersionId,
          'status': status,
          'type': '1',
        },
      );

      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '收藏操作失败');
      }

      print('✅ 收藏操作成功: status=$status');
    } catch (e) {
      throw Exception('收藏操作失败: $e');
    }
  }

  /// 纠错
  /// 对应小程序: error-correction.vue Line 123-135
  /// 对应接口: /c/tiku/question/correction
  /// 
  /// 参数说明:
  /// - description: 错误描述
  /// - errType: 错误类型 ('1'-题干, '2'-答案, '3'-解析, '4'-知识点, '5'-其他)
  /// - filePath: 图片路径列表
  /// - questionId: 题目ID
  /// - questionVersionId: 题目版本ID
  /// - version: 版本号
  Future<void> submitCorrection({
    required String description,
    required String errType,
    required List<String> filePath,
    required String questionId,
    required String questionVersionId,
    required String version,
  }) async {
    try {
      print('\n========== 📤 提交纠错请求 ==========');
      print('📍 接口: POST /c/tiku/question/correction');
      print('📦 参数:');
      print('   - description: $description');
      print('   - err_type: $errType');
      print('   - file_path: $filePath');
      print('   - question_id: $questionId');
      print('   - question_version_id: $questionVersionId');
      print('   - version: $version');
      print('=====================================\n');
      
      final response = await _dioClient.post(
        '/c/tiku/question/correction',
        data: {
          'description': description,
          'err_type': errType,
          'file_path': filePath,
          'question_id': questionId,
          'question_version_id': questionVersionId,
          'version': version,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      print('\n========== 📥 纠错响应 ==========');
      print('📦 响应数据: ${response.data}');
      print('📊 状态码: ${response.statusCode}');
      print('⏱️ 响应头: ${response.headers}');
      print('===============================\n');

      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '提交纠错失败');
      }

      print('✅ 提交纠错成功');
    } catch (e) {
      print('\n❌ 纠错异常: $e\n');
      throw Exception('提交纠错失败: $e');
    }
  }

  /// 提交答案（交卷）
  /// 对应小程序接口: /c/tiku/question/answer
  /// 对应小程序调用: examinationing.vue Line 434-450
  ///
  /// 参数说明（参照抓包curl）：
  /// - productId: 产品ID（即 paper_version_id）
  /// - type: 类型（8-课前测/课后测等测评）
  /// - evaluationTypeId/orderDetailId/teachingSystemRelationId: 测评交卷必传（与小程序 postAnswer 一致）
  Future<void> submitAnswer({
    required String productId,
    required String professionalId,
    required int costTime,
    required String type,
    required String questionInfo,
    required String goodsId,
    required String orderId,
    required String userId,
    required String studentId,
    String? teachingSystemPackageId,
    String? evaluationTypeId, // 测评交卷：evaluation_type_id
    String? orderDetailId, // 测评交卷：order_detail_id、sub_order_id
    String? teachingSystemRelationId, // 测评交卷：teaching_system_relation_id (system_id)
  }) async {
    try {
      final Map<String, dynamic> data = {
        'product_id': productId,
        'professional_id': professionalId,
        'cost_time': costTime,
        'type': type,
        'question_info': questionInfo,
        'goods_id': goodsId,
        'order_id': orderId,
        'user_id': userId,
        'student_id': studentId,
      };

      if (teachingSystemPackageId != null &&
          teachingSystemPackageId.isNotEmpty) {
        data['teaching_system_package_id'] = teachingSystemPackageId;
      }
      if (evaluationTypeId != null && evaluationTypeId.isNotEmpty) {
        data['evaluation_type_id'] = evaluationTypeId;
      }
      if (orderDetailId != null && orderDetailId.isNotEmpty) {
        data['order_detail_id'] = orderDetailId;
        data['sub_order_id'] = orderDetailId;
      }
      if (teachingSystemRelationId != null &&
          teachingSystemRelationId.isNotEmpty) {
        data['teaching_system_relation_id'] = teachingSystemRelationId;
      }
      
      final response = await _dioClient.post(
        '/c/tiku/question/answer',
        data: data,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      print('\n========== 提交答案响应 ==========');
      print('📥 响应: ${response.data}');
      print('================================\n');

      if (response.data['code'] != 100000) {
        final errorMsg = response.data['msg']?.first ?? '提交答案失败';
        print('❌ 提交失败: code=${response.data['code']}, msg=$errorMsg');
        throw Exception(errorMsg);
      }

      print('✅ 提交成功！');
    } catch (e) {
      print('❌ 提交答案异常: $e');
      throw Exception('提交答案失败: $e');
    }
  }

  /// 获取模考详情
  /// 对应小程序: getExaminfoDetail (api/index.js Line 939-945)
  /// 对应接口: GET /c/tiku/mockexam/examinfo
  /// 对应小程序调用: examInfo.vue Line 210-232
  Future<ExamInfoDetailModel> getExaminfoDetail({
    required String productId,
    String? mockExamId,
    String? professionalId,
  }) async {
    try {
      print('📡 [获取模考详情] 请求参数: product_id=$productId, mock_exam_id=$mockExamId, professional_id=$professionalId');
      
      final response = await _dioClient.get(
        '/c/tiku/mockexam/examinfo',
        queryParameters: {
          'product_id': productId,
          if (mockExamId != null) 'mock_exam_id': mockExamId,
          if (professionalId != null && professionalId.isNotEmpty) 'professional_id': professionalId,
        },
      );

      print('📡 [获取模考详情] 响应: ${response.data}');

      if (response.data['code'] != 100000) {
        final errorMsg = response.data['msg']?.first ?? '获取模考详情失败';
        print('❌ [获取模考详情] 失败: $errorMsg');
        throw Exception(errorMsg);
      }

      final data = response.data['data'];
      if (data == null) {
        throw Exception('模考详情数据为空');
      }

      if (data['mock_exam_details'] == null) {
        throw Exception('该场模考暂无任何数据！');
      }

      print('✅ [获取模考详情] 成功');
      return ExamInfoDetailModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      print('❌ [获取模考详情] 网络错误: ${e.message}');
      throw Exception('网络请求失败: ${e.message}');
    } catch (e) {
      print('❌ [获取模考详情] 错误: $e');
      throw Exception('获取模考详情失败: $e');
    }
  }

  /// 模考报名
  /// 对应小程序: mockexamSignup (api/index.js Line 947-953)
  /// 对应接口: POST /c/tiku/mockexam/signup
  /// 对应小程序调用: examInfo.vue Line 136-142
  Future<void> mockexamSignup({
    required String examId,
  }) async {
    try {
      print('📡 [模考报名] 请求参数: exam_id=$examId');
      
      final response = await _dioClient.post(
        '/c/tiku/mockexam/signup',
        data: {
          'exam_id': examId,
        },
      );

      print('📡 [模考报名] 响应: ${response.data}');

      if (response.data['code'] != 100000) {
        final errorMsg = response.data['msg']?.first ?? '报名失败';
        print('❌ [模考报名] 失败: $errorMsg');
        throw Exception(errorMsg);
      }

      print('✅ [模考报名] 成功');
    } on DioException catch (e) {
      print('❌ [模考报名] 网络错误: ${e.message}');
      throw Exception('网络请求失败: ${e.message}');
    } catch (e) {
      print('❌ [模考报名] 错误: $e');
      throw Exception('报名失败: $e');
    }
  }

  /// 补考报名
  /// 对应小程序: makeupSignup (api/index.js Line 955-961)
  /// 对应接口: POST /c/tiku/mockexam/makeup
  /// 对应小程序调用: examInfo.vue Line 148-152 (已注释)
  Future<void> makeupSignup({
    required String examRoundId,
  }) async {
    try {
      print('📡 [补考报名] 请求参数: exam_round_id=$examRoundId');
      
      final response = await _dioClient.post(
        '/c/tiku/mockexam/makeup',
        data: {
          'exam_round_id': examRoundId,
        },
      );

      print('📡 [补考报名] 响应: ${response.data}');

      if (response.data['code'] != 100000) {
        final errorMsg = response.data['msg']?.first ?? '补考报名失败';
        print('❌ [补考报名] 失败: $errorMsg');
        throw Exception(errorMsg);
      }

      print('✅ [补考报名] 成功');
    } on DioException catch (e) {
      print('❌ [补考报名] 网络错误: ${e.message}');
      throw Exception('网络请求失败: ${e.message}');
    } catch (e) {
      print('❌ [补考报名] 错误: $e');
      throw Exception('补考报名失败: $e');
    }
  }
}

/// ExamService Provider
/// ✅ 章节练习、试卷考试、模拟考试统一使用 ExamService.submitAnswer()
final examServiceProvider = Provider<ExamService>((ref) {
  return ExamService(ref.read(dioClientProvider));
});
