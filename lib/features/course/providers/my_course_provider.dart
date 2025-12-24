import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/my_course_service.dart';

part 'my_course_provider.freezed.dart';
part 'my_course_provider.g.dart';

/// 我的课程状态
@freezed
class MyCourseState with _$MyCourseState {
  const factory MyCourseState({
    @Default([]) List<Map<String, dynamic>> courseList,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(1) int currentPage,
    @Default(0) int total,
    @Default('3')
    String teachingType, // 3=录播课, 1=直播课（对应小程序 teachingTypeTab.vue）
    String? error,
  }) = _MyCourseState;
}

@riverpod
class MyCourseNotifier extends _$MyCourseNotifier {
  @override
  MyCourseState build() => const MyCourseState();

  /// 加载课程列表
  /// 对应小程序: getData() Line 52-113
  Future<void> loadCourses({bool isLoadMore = false}) async {
    if (isLoadMore) {
      state = state.copyWith(isLoadingMore: true);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final service = ref.read(myCourseServiceProvider);
      final result = await service.getMyCourseList(
        teachingType: state.teachingType,
        page: isLoadMore ? state.currentPage + 1 : 1,
        size: 10,
      );

      final newList = result['list'] as List<Map<String, dynamic>>;
      final total = result['total'] as int;

      // ✅ 过滤教师（对应小程序 Line 64-90）
      final processedList = newList.map((item) {
        final classInfo = item['class'] as Map<String, dynamic>?;
        if (classInfo != null && classInfo['teacher'] != null) {
          final teachers = (classInfo['teacher'] as List)
              .where((t) => t['id'] != 0 && t['id'] != '0')
              .toList();

          return {
            ...item,
            'class': {...classInfo, 'teacher': teachers},
          };
        }
        return item;
      }).toList();

      if (isLoadMore) {
        state = state.copyWith(
          courseList: [...state.courseList, ...processedList],
          currentPage: state.currentPage + 1,
          total: total,
          isLoadingMore: false,
        );
      } else {
        state = state.copyWith(
          courseList: processedList,
          currentPage: 1,
          total: total,
          isLoading: false,
        );
      }
    } on DioException catch (e) {
      // ✅ 使用拦截器已处理好的用户友好错误信息
      final errorMsg = e.error?.toString() ?? '加载失败，请稍后重试';
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: errorMsg,
      );
    } catch (e) {
      // ✅ 兜底：未预期的错误
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: '加载失败，请稍后重试',
      );
    }
  }

  /// 切换授课方式
  /// 对应小程序: teachingChange() Line 142-147
  Future<void> changeTeachingType(String teachingType) async {
    state = state.copyWith(
      teachingType: teachingType,
      courseList: [],
      currentPage: 1,
    );
    await loadCourses();
  }

  /// 刷新
  Future<void> refresh() async {
    state = state.copyWith(courseList: [], currentPage: 1);
    await loadCourses();
  }
}
