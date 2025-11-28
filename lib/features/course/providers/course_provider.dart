import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/lesson_model.dart';
import '../models/course_model.dart';
import '../services/course_service.dart';

part 'course_provider.freezed.dart';
part 'course_provider.g.dart';

/// 课程页面状态
@freezed
class CourseState with _$CourseState {
  const factory CourseState({
    @Default(false) bool isLoading,
    @Default(false) bool isCourseListLoading,
    @Default([]) List<String> dotDates,
    LessonsData? lessonsData,
    @Default([]) List<CourseModel> courseList,
    @Default(true) bool showPlan,
    String? error,
  }) = _CourseState;
}

/// 课程页面 ViewModel
@riverpod
class CourseNotifier extends _$CourseNotifier {
  @override
  CourseState build() {
    return const CourseState();
  }

  CourseService get _service => ref.read(courseServiceProvider);

  /// 初始化加载所有数据
  Future<void> loadInitialData(DateTime selectedDate, String teachingType) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await Future.wait([
        _loadCalendar(),
        loadDateLessons(selectedDate),
        loadDateCourse(selectedDate, teachingType),
        _loadConfig(),
      ]);

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 获取学习日历(打卡日期) - 获取前后3个月的数据
  Future<void> _loadCalendar() async {
    try {
      final now = DateTime.now();
      final prevMonthFirstDay = DateTime(now.year, now.month - 1, 1);
      final nextMonthLastDay = DateTime(now.year, now.month + 2, 0);

      final dotDates = await _service.getCalendar(
        startDate: _formatDate(prevMonthFirstDay),
        endDate: _formatDate(nextMonthLastDay),
      );

      state = state.copyWith(dotDates: dotDates);
    } catch (e) {
      // 日历加载失败不影响主流程
    }
  }

  /// 获取指定日期的课节
  Future<void> loadDateLessons(DateTime date) async {
    try {
      final lessonsData = await _service.getDateLessons(_formatDate(date));
      state = state.copyWith(lessonsData: lessonsData);
    } catch (e) {
      state = state.copyWith(lessonsData: null);
    }
  }

  /// 获取学习计划课程
  Future<void> loadDateCourse(DateTime date, String teachingType) async {
    state = state.copyWith(isCourseListLoading: true);

    try {
      final courseList = await _service.getDateCourse(
        date: _formatDate(date),
        teachingType: teachingType,
      );

      state = state.copyWith(
        courseList: courseList,
        isCourseListLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        courseList: [],
        isCourseListLoading: false,
      );
    }
  }

  /// 获取配置(showPlan开关)
  Future<void> _loadConfig() async {
    try {
      final showPlan = await _service.getShowPlanConfig();
      state = state.copyWith(showPlan: showPlan);
    } catch (e) {
      // 配置加载失败使用默认值
    }
  }

  /// 刷新日历数据(用于月份切换时)
  Future<void> refreshCalendar() async {
    await _loadCalendar();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
