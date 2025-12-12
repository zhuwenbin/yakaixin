import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../models/wrong_question_model.dart';

/// 错题本Service
/// 对应小程序API: src/modules/jintiku/api/wrongQuestionBook.js
class WrongBookService {
  final DioClient _dioClient;

  WrongBookService(this._dioClient);

  /// 获取错题列表
  /// 对应小程序: getWronganswerbook (wrongQuestionBook/index.vue Line 284-292)
  /// 接口: GET /c/tiku/wronganswerbook
  /// 
  /// 参数说明:
  /// - data_type: 数据类型 (1-全部, 2-标记, 3-易错)
  /// - time_range: 时间范围 (0-全部, 1-近3天, 2-一周内, 3-一月内, 4-自定义)
  /// - start_date: 开始日期 (time_range=4时必需)
  /// - end_date: 结束日期 (time_range=4时必需)
  /// 
  /// ⚠️ 注意: api_interceptor会自动添加以下参数:
  /// - user_id, student_id (从Storage获取)
  /// - merchant_id, brand_id (固定值 408559575579495187, 408559632588540691)
  /// - professional_id (从Storage获取)
  Future<WrongQuestionListResponse> getWrongQuestions({
    required int dataType,
    String timeRange = '0',
    String? startDate,
    String? endDate,
  }) async {
    try {
      print('\n🔍 [WrongBookService] 获取错题列表');
      print('   data_type: $dataType (1=全部, 2=标记, 3=易错)');
      print('   time_range: $timeRange');
      if (startDate != null) print('   start_date: $startDate');
      if (endDate != null) print('   end_date: $endDate');
      
      final response = await _dioClient.get(
        '/c/tiku/wronganswerbook',
        queryParameters: {
          'data_type': dataType,
          'time_range': timeRange,
          if (startDate != null && startDate.isNotEmpty) 'start_date': startDate,
          if (endDate != null && endDate.isNotEmpty) 'end_date': endDate,
        },
      );
      
      print('✅ [WrongBookService] 请求成功，响应码: ${response.data['code']}');

      // ✅ 统一处理响应码
      if (response.data['code'] != 100000) {
        throw ApiException(response.data['msg']?.first ?? '获取错题失败');
      }

      final data = response.data['data'];
      if (data == null) {
        print('⚠️ [WrongBookService] 响应数据为空');
        return const WrongQuestionListResponse(groups: []);
      }

      // ✅ 解析外层分组数据
      if (data is List) {
        print('📦 [WrongBookService] 解析数据: 分组数=${data.length}');
        final groups = data.map((item) {
          return WrongQuestionGroupResponse.fromJson(item as Map<String, dynamic>);
        }).toList();
        
        // 打印每个分组的题目数量
        for (var i = 0; i < groups.length; i++) {
          print('   分组${i + 1}: ${groups[i].questionTypeName} (共${groups[i].questionNum}道题, 实际数据${groups[i].questionList.length}条)');
        }
        
        return WrongQuestionListResponse(groups: groups);
      }

      print('⚠️ [WrongBookService] 响应数据格式错误: ${data.runtimeType}');
      return const WrongQuestionListResponse(groups: []);
    } on DioException catch (e) {
      throw NetworkException('网络请求失败: ${e.message}');
    } catch (e) {
      throw UnknownException('未知错误: $e');
    }
  }

  /// 标记/取消标记错题
  /// 对应小程序: wronganswerbookMark
  /// 接口: POST /c/tiku/wronganswerbook/mark
  /// 
  /// 参数:
  /// - action_type: 操作类型 (1-标记, 2-取消标记)
  /// - mark_tab: 标记类型 (逗号分隔, 如 "1,2,3")
  /// - wrong_answer_book_id: 错题本ID
  Future<void> markWrongQuestion({
    required String actionType,
    required String markTab,
    required String wrongAnswerBookId,
  }) async {
    try {
      final response = await _dioClient.post(
        '/c/tiku/wronganswerbook/mark',
        options: Options(
          contentType: Headers.jsonContentType,
        ),
        data: {
          'action_type': actionType,
          'mark_tab': markTab,
          'wrong_answer_book_id': wrongAnswerBookId,
        },
      );

      if (response.data['code'] != 100000) {
        throw ApiException(response.data['msg']?.first ?? '标记失败');
      }
    } on DioException catch (e) {
      throw NetworkException('网络请求失败: ${e.message}');
    } catch (e) {
      throw UnknownException('未知错误: $e');
    }
  }

  /// 移出错题
  /// 对应小程序: wronganswerbookRemove
  /// 接口: POST /c/tiku/wronganswerbook/remove
  /// 
  /// 参数:
  /// - wrong_answer_book_id: 错题本ID
  Future<void> removeWrongQuestion({
    required String wrongAnswerBookId,
  }) async {
    try {
      final response = await _dioClient.post(
        '/c/tiku/wronganswerbook/remove',
        // ✅ 设置Content-Type为JSON（参照小程序Line 30-31）
        options: Options(
          contentType: Headers.jsonContentType,
        ),
        data: {
          'wrong_answer_book_id': wrongAnswerBookId,
        },
      );

      if (response.data['code'] != 100000) {
        throw ApiException(response.data['msg']?.first ?? '移出失败');
      }
    } on DioException catch (e) {
      throw NetworkException('网络请求失败: ${e.message}');
    } catch (e) {
      throw UnknownException('未知错误: $e');
    }
  }

  /// 题目纠错
  /// 对应小程序: correction (commen.js Line 30-38)
  /// API: POST /c/tiku/question/correction
  /// 
  /// 参数说明:
  /// - description: 错误描述
  /// - errType: 错误类型 ('1'-题干, '2'-答案, '3'-解析, '4'-知识点, '5'-其他)
  /// - filePath: 图片路径列表
  /// - questionId: 题目ID
  /// - questionVersionId: 题目版本ID
  /// - version: 版本号
  Future<void> submitCorrection({
    required String questionId,
    required String questionVersionId,
    required String version,
    required String description,
    required String errType,
    required List<String> filePath,
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
        options: Options(
          contentType: Headers.jsonContentType,
        ),
        data: {
          'description': description,
          'err_type': errType,
          'file_path': filePath,
          'question_id': questionId,
          'question_version_id': questionVersionId,
          'version': version,
        },
      );

      if (response.data['code'] != 100000) {
        final msg = response.data['msg'];
        final errorMsg = msg is List && msg.isNotEmpty 
            ? msg.first.toString() 
            : (msg?.toString() ?? '提交纠错失败');
        print('❌ [WrongBookService] 纠错失败: $errorMsg');
        throw ApiException(errorMsg);
      }

      print('✅ [WrongBookService] 纠错提交成功');
    } on DioException catch (e) {
      throw NetworkException('网络请求失败: ${e.message}');
    } catch (e) {
      throw UnknownException('提交纠错失败: $e');
    }
  }
}

/// 异常类
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => message;
}

class UnknownException implements Exception {
  final String message;
  UnknownException(this.message);

  @override
  String toString() => message;
}

/// Provider 暴露 Service
final wrongBookServiceProvider = Provider<WrongBookService>((ref) {
  return WrongBookService(ref.read(dioClientProvider));
});
