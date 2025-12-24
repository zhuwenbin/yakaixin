import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../models/learning_data_model.dart';
import '../models/score_report_model.dart';
import '../services/report_service.dart';
import '../../../core/utils/error_message_mapper.dart';

part 'report_provider.freezed.dart';
part 'report_provider.g.dart';

/// 学习数据State
@freezed
class LearningDataState with _$LearningDataState {
  const factory LearningDataState({
    LearningDataModel? data,
    @Default(false) bool isLoading,
    String? error,
    @Default(1) int questionNumType, // 1-最近一周, 2-按月查看
    @Default(1) int questionHourType, // 1-最近一周, 2-按月查看
  }) = _LearningDataState;
}

/// 成绩报告State
@freezed
class ScoreReportState with _$ScoreReportState {
  const factory ScoreReportState({
    @Default([]) List<ScoreReportModel> reports,
    @Default(false) bool isLoading,
    String? error,
    @Default('') String searchKeyword,
  }) = _ScoreReportState;
}

// ==================== Provider ====================

/// ReportService Provider
@riverpod
ReportService reportService(ReportServiceRef ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ReportService(dioClient);
}

/// 学习数据Provider
/// 对应小程序: report.vue 学习数据Tab
@riverpod
class LearningData extends _$LearningData {
  @override
  LearningDataState build() => const LearningDataState();

  /// 加载学习数据
  /// 对应小程序: getServerData()
  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final service = ref.read(reportServiceProvider);
      final data = await service.getLearningData();

      state = state.copyWith(
        data: data,
        isLoading: false,
      );
    } on DioException catch (e) {
      // ✅ 使用拦截器已处理好的用户友好错误信息
      final errorMsg = e.error?.toString() ?? '加载失败，请稍后重试';
      state = state.copyWith(
        isLoading: false,
        error: errorMsg,
      );
    } catch (e) {
      // ✅ 兜底：未预期的错误
      state = state.copyWith(
        isLoading: false,
        error: '加载失败，请稍后重试',
      );
    }
  }

  /// 切换刷题量图表类型
  /// 对应小程序: question_num_type watch
  void setQuestionNumType(int type) {
    state = state.copyWith(questionNumType: type);
  }

  /// 切换学习时长图表类型
  /// 对应小程序: question_hour_type watch
  void setQuestionHourType(int type) {
    state = state.copyWith(questionHourType: type);
  }

  /// 获取刷题量图表数据
  /// 对应小程序: getEchartsData() 中的 questionTypeData 部分
  List<DailyQuestionModel> getQuestionData() {
    if (state.data == null) return [];

    if (state.questionNumType == 1) {
      return state.data!.toWeekDoQuestionNum;
    } else {
      return state.data!.toMonthDoQuestionNum;
    }
  }

  /// 获取学习时长图表数据
  /// 对应小程序: getEchartsData() 中的 chartData 部分
  List<DailyLearnTimeModel> getLearnTimeData() {
    if (state.data == null) return [];

    if (state.questionHourType == 1) {
      return state.data!.toWeekLearnTime;
    } else {
      return state.data!.toMonthLearnTime;
    }
  }
}

/// 成绩报告Provider
/// 对应小程序: report.vue 成绩报告Tab
@riverpod
class ScoreReportNotifier extends _$ScoreReportNotifier {
  @override
  ScoreReportState build() => const ScoreReportState();

  /// 加载成绩报告列表
  /// 对应小程序: getExam()
  Future<void> load({String? examinationName}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final service = ref.read(reportServiceProvider);
      final reports = await service.getScoreReporting(
        examinationName: examinationName,
      );

      state = state.copyWith(
        reports: reports,
        isLoading: false,
      );
    } on DioException catch (e) {
      // ✅ 使用拦截器已处理好的用户友好错误信息
      final errorMsg = e.error?.toString() ?? '加载失败，请稍后重试';
      state = state.copyWith(
        isLoading: false,
        error: errorMsg,
      );
    } catch (e) {
      // ✅ 兜底：未预期的错误
      state = state.copyWith(
        isLoading: false,
        error: '加载失败，请稍后重试',
      );
    }
  }

  /// 搜索
  /// 对应小程序: examination_name input + getExam()
  Future<void> search(String keyword) async {
    state = state.copyWith(searchKeyword: keyword);
    await load(examinationName: keyword.isNotEmpty ? keyword : null);
  }
}
