import '../../../core/network/dio_client.dart';
import '../models/course_detail_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 学习课程详情 Service
/// 对应小程序 API: study.courseDetail, study.courseDetailLessons, study.courseDetailRecently
class CourseDetailService {
  final DioClient _dioClient;

  CourseDetailService(this._dioClient);

  /// 获取课程详情
  /// API: /c/study/learning/series
  /// 对应小程序: study.courseDetail
  Future<CourseDetailModel> getCourseDetail({
    required String goodsId,
    required String orderId,
    String? goodsPid,
    int page = 1,
    int size = 20,
  }) async {
    try {
      final response = await _dioClient.get(
        '/c/study/learning/series',
        queryParameters: {
          'goods_id': goodsId,
          'goods_pid': goodsPid ?? '0',
          'order_id': orderId,
          'page': page,
          'size': size,
        },
      );

      print('\n========== 📚 [课程详情] API响应 ==========');
      print('📋 请求参数:');
      print('  - goodsId: $goodsId');
      print('  - orderId: $orderId');
      print('  - goodsPid: $goodsPid');
      print('📦 响应数据: ${response.data}');
      print('=========================================\n');

      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取课程详情失败');
      }

      final data = response.data['data'];
      if (data == null || data['list'] == null || data['list'].isEmpty) {
        throw Exception('课程详情数据为空');
      }

      return CourseDetailModel.fromJson(
        data['list'][0] as Map<String, dynamic>,
      );
    } catch (e) {
      print('❌ [课程详情] 加载失败: $e');
      rethrow;
    }
  }

  /// 获取课程课节列表
  /// API: /c/study/learning/series/goods
  /// 对应小程序: study.courseDetailLessons
  Future<List<CourseClassModel>> getCourseDetailLessons({
    required String goodsId,
    required String orderId,
    String? goodsPid,
    int page = 1,
    int size = 100,
  }) async {
    try {
      final response = await _dioClient.get(
        '/c/study/learning/series/goods',
        queryParameters: {
          'goods_id': goodsId,
          'goods_pid': goodsPid ?? '0',
          'order_id': orderId,
          'page': page,
          'size': size,
        },
      );

      print('\n========== 📋 [课程课节列表] API响应 ==========');
      print('📦 响应数据: ${response.data}');
      print('=========================================\n');

      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取课节列表失败');
      }

      final data = response.data['data'];
      if (data == null) {
        return [];
      }

      // ✅ 修复：API返回的data直接是数组，不是 {list: [...]}
      List list;
      if (data is List) {
        list = data;
      } else if (data is Map && data['list'] != null) {
        list = data['list'] as List;
      } else {
        return [];
      }

      // ✅ 安全解析每个班级数据
      final result = <CourseClassModel>[];
      for (var i = 0; i < list.length; i++) {
        try {
          final item = list[i];
          if (item is Map<String, dynamic>) {
            result.add(CourseClassModel.fromJson(item));
          }
        } catch (e, stackTrace) {
          print('❌ 解析班级数据失败 (索引 $i): $e');
          print('数据: ${list[i]}');
          print('堆栈: $stackTrace');
          // 继续解析下一个
        }
      }
      return result;
    } catch (e) {
      print('❌ [课程课节列表] 加载失败: $e');
      return [];
    }
  }

  /// 获取最近学习记录
  /// API: /c/study/learning/series/recent
  /// 对应小程序: study.courseDetailRecently
  Future<RecentlyDataModel?> getCourseDetailRecently({
    required String goodsId,
    required String orderId,
    String? goodsPid,
  }) async {
    try {
      final response = await _dioClient.get(
        '/c/study/learning/series/recent',
        queryParameters: {
          'goods_id': goodsId,
          'goods_pid': goodsPid ?? '0',
          'order_id': orderId,
        },
      );

      print('\n========== 🕐 [最近学习] API响应 ==========');
      print('📦 响应数据: ${response.data}');
      print('=========================================\n');

      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取最近学习失败');
      }

      final data = response.data['data'];
      if (data == null || data['lesson_id'] == null) {
        return null;
      }

      return RecentlyDataModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      print('❌ [最近学习] 加载失败: $e');
      return null;
    }
  }
}

/// Provider
final courseDetailServiceProvider = Provider<CourseDetailService>((ref) {
  return CourseDetailService(ref.read(dioClientProvider));
});
