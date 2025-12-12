import 'package:dio/dio.dart';
import 'package:yakaixin_app/core/network/dio_client.dart';
import '../models/collection_question_model.dart';

/// 收藏服务
/// 对应小程序: api/collect.js
class CollectionService {
  final DioClient _dioClient;

  CollectionService(this._dioClient);

  /// 获取收藏列表
  /// 对应小程序: collect.js Line 6-12
  /// API: GET /c/tiku/question/practice/collect/list
  /// 
  /// 参数:
  /// - page: 页码 (默认1)
  /// - size: 每页数量 (默认10)
  /// - startDate: 开始日期 (可选)
  /// - endDate: 结束日期 (可选)
  /// - timeRange: 时间范围 ('0'-全部, '1'-近3天, '2'-一周内, '3'-一月内, '4'-自定义)
  /// - questionType: 题型 (可选, '1'-A1, '2'-A2, '3'-A3, '4'-A4, '5'-B1, '6'-B2, '7'-X)
  Future<CollectionListResponse> getCollectionList({
    int page = 1,
    int size = 10,
    String? startDate,
    String? endDate,
    String timeRange = '0',
    String? questionType,
  }) async {
    print('📚 [CollectionService] 获取收藏列表 - page: $page, size: $size, timeRange: $timeRange, questionType: $questionType');

    try {
      final queryParams = {
        'page': page.toString(),
        'size': size.toString(),
        'time_range': timeRange,
      };

      // 添加可选参数
      if (startDate != null && startDate.isNotEmpty) {
        queryParams['start_date'] = startDate;
      }
      if (endDate != null && endDate.isNotEmpty) {
        queryParams['end_date'] = endDate;
      }
      if (questionType != null && questionType.isNotEmpty) {
        queryParams['question_type'] = questionType;
      }

      final response = await _dioClient.get(
        '/c/tiku/question/practice/collect/list',
        queryParameters: queryParams,
      );

      if (response.data['code'] != 100000) {
        // 安全处理msg字段：可能是String或List
        final msg = response.data['msg'];
        final errorMsg = msg is List && msg.isNotEmpty 
            ? msg.first.toString() 
            : (msg?.toString() ?? '获取收藏列表失败');
        print('❌ [CollectionService] 获取失败: $errorMsg');
        throw Exception(errorMsg);
      }

      final data = response.data['data'];
      if (data == null) {
        print('⚠️ [CollectionService] 数据为空，返回空列表');
        return const CollectionListResponse(list: [], total: 0);
      }

      // ✅ 添加调试日志，查看原始数据类型
      print('🔍 [CollectionService] data 类型: ${data.runtimeType}');
      print('🔍 [CollectionService] list 类型: ${data['list']?.runtimeType}');
      
      try {
        final list = (data['list'] as List?)?.map((item) {
          print('🔍 [CollectionService] 单个item类型: ${item.runtimeType}');
          print('🔍 [CollectionService] item内容: $item');
          return CollectionQuestionModel.fromJson(item as Map<String, dynamic>);
        }).toList() ?? [];
        
        final total = data['total'] ?? 0;
        
        print('✅ [CollectionService] 获取成功 - 总数: $total, 本次: ${list.length}');
        return CollectionListResponse(list: list, total: total);
      } catch (e, stackTrace) {
        print('❌ [CollectionService] fromJson失败: $e');
        print('📍 [StackTrace] $stackTrace');
        rethrow;
      }
    } on DioException catch (e) {
      print('❌ [CollectionService] 网络请求失败: ${e.message}');
      throw Exception('网络请求失败: ${e.message}');
    } catch (e) {
      print('❌ [CollectionService] 获取收藏列表失败: $e');
      throw Exception('获取收藏列表失败: $e');
    }
  }

  /// 收藏/取消收藏题目
  /// 对应小程序: api/commen.js Line 22-28
  /// API: GET /c/tiku/question/practice/collect
  /// 
  /// 参数:
  /// - questionVersionId: 题目版本ID
  /// - status: 收藏状态 ('1'-收藏, '2'-取消收藏)
  /// - type: 类型 ('1'-收藏)
  Future<void> toggleCollect({
    required String questionVersionId,
    required String status,
  }) async {
    print('⭐ [CollectionService] ${status == '1' ? '收藏' : '取消收藏'}题目: $questionVersionId');

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
        // 安全处理msg字段：可能是String或List
        final msg = response.data['msg'];
        final errorMsg = msg is List && msg.isNotEmpty 
            ? msg.first.toString() 
            : (msg?.toString() ?? '操作失败');
        print('❌ [CollectionService] 操作失败: $errorMsg');
        throw Exception(errorMsg);
      }

      print('✅ [CollectionService] 操作成功');
    } on DioException catch (e) {
      print('❌ [CollectionService] 网络请求失败: ${e.message}');
      throw Exception('网络请求失败: ${e.message}');
    } catch (e) {
      print('❌ [CollectionService] 操作失败: $e');
      throw Exception('操作失败: $e');
    }
  }

  /// 获取题型列表
  /// 对应小程序: api/commen.js Line 41-47
  /// API: GET /c/tiku/question/type
  Future<List<Map<String, String>>> getQuestionTypes() async {
    print('📋 [CollectionService] 获取题型列表');

    try {
      final response = await _dioClient.get('/c/tiku/question/type');

      if (response.data['code'] != 100000) {
        // 安全处理msg字段：可能是String或List
        final msg = response.data['msg'];
        final errorMsg = msg is List && msg.isNotEmpty 
            ? msg.first.toString() 
            : (msg?.toString() ?? '获取题型列表失败');
        print('❌ [CollectionService] 获取失败: $errorMsg');
        throw Exception(errorMsg);
      }

      final data = response.data['data'] as List?;
      if (data == null) {
        print('⚠️ [CollectionService] 题型数据为空');
        return [];
      }

      final types = data.map((item) {
        return {
          'id': (item['type'] ?? '').toString(),
          'label': (item['type_name'] ?? '').toString(),
        };
      }).toList();

      print('✅ [CollectionService] 获取题型成功 - 数量: ${types.length}');
      return types;
    } on DioException catch (e) {
      print('❌ [CollectionService] 网络请求失败: ${e.message}');
      throw Exception('网络请求失败: ${e.message}');
    } catch (e) {
      print('❌ [CollectionService] 获取题型列表失败: $e');
      throw Exception('获取题型列表失败: $e');
    }
  }

  /// 提交题目纠错
  /// 对应小程序: error-correction.vue Line 123-135
  /// API: POST /c/tiku/question/correction
  /// 
  /// 参数:
  /// - questionVersionId: 题目版本ID
  /// - description: 错误描述
  /// - errType: 错误类型 ('1'-题干, '2'-答案, '3'-解析, '4'-知识点, '5'-其他)
  /// - filePath: 图片路径列表
  Future<void> submitCorrection({
    required String questionVersionId,
    required String description,
    required String errType,
    required List<String> filePath,
  }) async {
    print('📝 [CollectionService] 提交纠错: $questionVersionId');

    try {
      final response = await _dioClient.post(
        '/c/tiku/question/correction',
        data: {
          'question_version_id': questionVersionId,
          'description': description,
          'err_type': errType,
          'file_path': filePath,
          'version': '1', // 默认版本
        },
      );

      if (response.data['code'] != 100000) {
        final msg = response.data['msg'];
        final errorMsg = msg is List && msg.isNotEmpty 
            ? msg.first.toString() 
            : (msg?.toString() ?? '提交纠错失败');
        print('❌ [CollectionService] 纠错失败: $errorMsg');
        throw Exception(errorMsg);
      }

      print('✅ [CollectionService] 纠错提交成功');
    } on DioException catch (e) {
      print('❌ [CollectionService] 网络请求失败: ${e.message}');
      throw Exception('网络请求失败: ${e.message}');
    } catch (e) {
      print('❌ [CollectionService] 提交纠错失败: $e');
      throw Exception('提交纠错失败: $e');
    }
  }
}
