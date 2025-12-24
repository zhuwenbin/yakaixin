import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/course_detail_model.dart';
import '../services/course_detail_service.dart';

part 'course_detail_provider.freezed.dart';
part 'course_detail_provider.g.dart';

/// 学习课程详情状态
@freezed
class CourseDetailState with _$CourseDetailState {
  const factory CourseDetailState({
    CourseDetailModel? courseInfo,
    @Default([]) List<CourseClassModel> classList,
    RecentlyDataModel? recentlyData,
    @Default(true) bool isLoading,
    String? error,
  }) = _CourseDetailState;
}

/// 学习课程详情 Provider
@riverpod
class CourseDetailNotifier extends _$CourseDetailNotifier {
  @override
  CourseDetailState build() => const CourseDetailState();

  /// 加载所有数据
  Future<void> loadAllData({
    required String goodsId,
    required String orderId,
    String? goodsPid,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      print('\n========== 🚀 [课程详情页] 开始加载所有数据 ==========');
      print('📋 参数: goodsId=$goodsId, orderId=$orderId, goodsPid=$goodsPid');

      final service = ref.read(courseDetailServiceProvider);

      // 并行加载3个接口
      final results = await Future.wait([
        service.getCourseDetail(
          goodsId: goodsId,
          orderId: orderId,
          goodsPid: goodsPid,
        ),
        service.getCourseDetailLessons(
          goodsId: goodsId,
          orderId: orderId,
          goodsPid: goodsPid,
        ),
        service.getCourseDetailRecently(
          goodsId: goodsId,
          orderId: orderId,
          goodsPid: goodsPid,
        ),
      ]);

      final courseInfo = results[0] as CourseDetailModel;
      final classList = results[1] as List<CourseClassModel>;
      final recentlyData = results[2] as RecentlyDataModel?;

      print('✅ [课程详情页] 数据加载完成');
      print('  - 课程信息: ${courseInfo.goodsName}');
      print('  - 班级数量: ${classList.length}');
      print('  - 最近学习: ${recentlyData?.lessonName ?? "无"}');
      print('=========================================\n');

      state = state.copyWith(
        courseInfo: courseInfo,
        classList: classList,
        recentlyData: recentlyData,
        isLoading: false,
      );
    } on DioException catch (e) {
      print('❌ [课程详情页] 加载失败 (DioException): $e');
      // ✅ 使用拦截器已处理好的用户友好错误信息
      final errorMsg = e.error?.toString() ?? '加载课程失败';
      state = state.copyWith(isLoading: false, error: errorMsg);
    } catch (e, stackTrace) {
      print('❌ [课程详情页] 加载失败: $e');
      print('堆栈: $stackTrace');
      state = state.copyWith(isLoading: false, error: '加载课程失败，请稍后重试');
    }
  }

  /// 切换班级展开/折叠
  void toggleClassExpand(int index) {
    final updatedList = List<CourseClassModel>.from(state.classList);
    updatedList[index] = updatedList[index].copyWith(
      isClose: !updatedList[index].isClose,
    );
    state = state.copyWith(classList: updatedList);
  }
}
