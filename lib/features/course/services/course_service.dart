import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_client.dart';
import '../models/lesson_model.dart';
import '../models/course_model.dart';

part 'course_service.g.dart';

/// 课程服务 - 负责课程相关的网络请求
@riverpod
CourseService courseService(CourseServiceRef ref) {
  final dio = ref.read(dioClientProvider);
  return CourseService(dio);
}

class CourseService {
  final DioClient _dio;

  CourseService(this._dio);

  /// 获取学习日历(打卡日期)
  Future<List<String>> getCalendar({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await _dio.get(
        '/c/study/learning/calendar',
        queryParameters: {
          'start_date': startDate,
          'end_date': endDate,
        },
      );

      if (response.data['code'] == 100000) {
        final List<dynamic> data = response.data['data'] as List;
        // 只保留 status == '1' 的日期
        return data
            .where((item) => item['status'] == '1')
            .map<String>((item) => item['date'] as String)
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('获取日历失败: $e');
    }
  }

  /// 获取指定日期的课节
  Future<LessonsData?> getDateLessons(String date) async {
    try {
      final response = await _dio.get(
        '/c/study/learning/lesson',
        queryParameters: {'date': date},
      );

      if (response.data['code'] == 100000 && response.data['data'] != null) {
        return LessonsData.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('获取课节失败: $e');
    }
  }

  /// 获取学习计划课程
  Future<List<CourseModel>> getDateCourse({
    required String date,
    String teachingType = '',
  }) async {
    try {
      final response = await _dio.get(
        '/c/study/learning/plan',
        queryParameters: {
          'teaching_type': teachingType,
          'date': date,
        },
      );

      if (response.data['code'] == 100000) {
        final List<dynamic> data = response.data['data'] as List;
        return data
            .map((item) => CourseModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('获取课程失败: $e');
    }
  }

  /// 获取配置(showPlan开关)
  Future<bool> getShowPlanConfig() async {
    try {
      final response = await _dio.get(
        '/c/config/common',
        queryParameters: {'code': 'PUBLISH'},
      );

      if (response.data['code'] == 100000) {
        final int value = int.tryParse(response.data['data']?.toString() ?? '2') ?? 2;
        return value == 2; // 2: 显示, 1: 隐藏
      }
      return true;
    } catch (e) {
      throw Exception('获取配置失败: $e');
    }
  }
}
