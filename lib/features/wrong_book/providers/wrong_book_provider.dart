import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/utils/error_message_mapper.dart';
import '../models/wrong_question_model.dart';
import '../services/wrong_book_service.dart';

part 'wrong_book_provider.freezed.dart';
part 'wrong_book_provider.g.dart';

/// 错题本状态
@freezed
class WrongBookState with _$WrongBookState {
  const factory WrongBookState({
    // ✅ 三个Tab的数据
    @Default([]) List<WrongQuestionModel> allQuestions,      // 全部
    @Default([]) List<WrongQuestionModel> markedQuestions,   // 标记
    @Default([]) List<WrongQuestionModel> fallibleQuestions, // 易错
    
    // ✅ 加载状态
    @Default(false) bool isLoading,
    String? error,
    
    // ✅ 筛选条件
    @Default('0') String timeRange,     // 时间范围: 0-全部, 1-近3天, 2-一周内, 3-一月内
    String? startDate,                  // 自定义开始日期
    String? endDate,                    // 自定义结束日期
    String? timeRangeName,              // 时间范围名称（用于显示）
  }) = _WrongBookState;
}

/// 错题本Provider
@riverpod
class WrongBookNotifier extends _$WrongBookNotifier {
  @override
  WrongBookState build() => const WrongBookState();

  /// 加载错题列表
  /// 对应小程序: init() 方法
  Future<void> loadWrongQuestions() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final service = ref.read(wrongBookServiceProvider);

      // ✅ 并发请求三个类型的数据（对应小程序的逻辑）
      final results = await Future.wait([
        service.getWrongQuestions(
          dataType: 1, // 全部
          timeRange: state.timeRange,
          startDate: state.startDate,
          endDate: state.endDate,
        ),
        service.getWrongQuestions(
          dataType: 2, // 标记
          timeRange: state.timeRange,
          startDate: state.startDate,
          endDate: state.endDate,
        ),
        service.getWrongQuestions(
          dataType: 3, // 易错
          timeRange: state.timeRange,
          startDate: state.startDate,
          endDate: state.endDate,
        ),
      ]);

      state = state.copyWith(
        allQuestions: _flattenGroups(results[0].groups),
        markedQuestions: _flattenGroups(results[1].groups),
        fallibleQuestions: _flattenGroups(results[2].groups),
        isLoading: false,
      );
    } on DioException catch (e) {
      // ✅ 使用拦截器已处理好的用户友好错误信息
      final errorMsg = e.error?.toString() ?? '加载错题失败';
      state = state.copyWith(
        isLoading: false,
        error: errorMsg,
      );
    } catch (e) {
      // ✅ 兜底：未预期的错误
      state = state.copyWith(
        isLoading: false,
        error: '加载错题失败，请稍后重试',
      );
    }
  }

  /// 刷新指定类型的数据
  /// 对应小程序: searchFn() 方法
  Future<void> refreshTab(int dataType) async {
    try {
      final service = ref.read(wrongBookServiceProvider);
      final response = await service.getWrongQuestions(
        dataType: dataType,
        timeRange: state.timeRange,
        startDate: state.startDate,
        endDate: state.endDate,
      );

      switch (dataType) {
        case 1:
          state = state.copyWith(allQuestions: _flattenGroups(response.groups));
          break;
        case 2:
          state = state.copyWith(markedQuestions: _flattenGroups(response.groups));
          break;
        case 3:
          state = state.copyWith(fallibleQuestions: _flattenGroups(response.groups));
          break;
      }
    } on DioException catch (e) {
      // ✅ 使用拦截器已处理好的用户友好错误信息
      final errorMsg = e.error?.toString() ?? '刷新失败';
      state = state.copyWith(error: errorMsg);
    } catch (e) {
      // ✅ 兜底：未预期的错误
      state = state.copyWith(error: '刷新失败，请稍后重试');
    }
  }

  /// 更新筛选条件
  /// 对应小程序: success(e) 方法
  void updateFilter({
    String? timeRange,
    String? timeRangeName,
    String? startDate,
    String? endDate,
  }) {
    state = state.copyWith(
      timeRange: timeRange ?? state.timeRange,
      timeRangeName: timeRangeName ?? state.timeRangeName,
      startDate: startDate,
      endDate: endDate,
    );

    // 更新筛选条件后，重新加载数据
    loadWrongQuestions();
  }

  /// 标记/取消标记错题
  /// 对应小程序: onMarkClick 和 onSuccessClick
  Future<void> toggleMark({
    required String wrongAnswerBookId,
    required bool isMarked,
    String? markTab,
  }) async {
    try {
      final service = ref.read(wrongBookServiceProvider);
      
      await service.markWrongQuestion(
        actionType: isMarked ? '2' : '1',  // 1-标记, 2-取消标记
        markTab: markTab ?? '1',
        wrongAnswerBookId: wrongAnswerBookId,
      );

      // ✅ 更新本地状态（包括tags字段）
      _updateQuestionMarkStatus(
        wrongAnswerBookId,
        isMarked,
        markTab: markTab,
      );
    } on DioException catch (e) {
      // ✅ 使用拦截器已处理好的用户友好错误信息
      final errorMsg = e.error?.toString() ?? '标记操作失败';
      state = state.copyWith(error: errorMsg);
      rethrow;
    } catch (e) {
      // ✅ 兜底：未预期的错误
      state = state.copyWith(error: '标记操作失败');
      rethrow;
    }
  }

  /// 移出错题
  /// 对应小程序: onRemoveClick
  Future<void> removeQuestion({
    required String wrongAnswerBookId,
  }) async {
    try {
      final service = ref.read(wrongBookServiceProvider);
      
      await service.removeWrongQuestion(
        wrongAnswerBookId: wrongAnswerBookId,
      );

      // 从本地移除
      _removeQuestionFromLists(wrongAnswerBookId);
    } on DioException catch (e) {
      // ✅ 使用拦截器已处理好的用户友好错误信息
      final errorMsg = e.error?.toString() ?? '移除失败';
      state = state.copyWith(error: errorMsg);
      rethrow;
    } catch (e) {
      // ✅ 兜底：未预期的错误
      state = state.copyWith(error: '移除失败，请稍后重试');
      rethrow;
    }
  }

  /// 更新题目的标记状态
  void _updateQuestionMarkStatus(
    String wrongAnswerBookId,
    bool isMarked, {
    String? markTab,
  }) {
    final newMarkValue = isMarked ? '2' : '1';
    // ✅ 标记时更新tags，取消标记时清空tags
    final newTags = isMarked ? null : markTab;
    
    state = state.copyWith(
      allQuestions: state.allQuestions.map((q) {
        if (q.wrongAnswerBookId == wrongAnswerBookId) {
          return q.copyWith(
            isMark: newMarkValue,
            tags: newTags,  // ✅ 更新标签
          );
        }
        return q;
      }).toList(),
      markedQuestions: state.markedQuestions.map((q) {
        if (q.wrongAnswerBookId == wrongAnswerBookId) {
          return q.copyWith(
            isMark: newMarkValue,
            tags: newTags,  // ✅ 更新标签
          );
        }
        return q;
      }).toList(),
      fallibleQuestions: state.fallibleQuestions.map((q) {
        if (q.wrongAnswerBookId == wrongAnswerBookId) {
          return q.copyWith(
            isMark: newMarkValue,
            tags: newTags,  // ✅ 更新标签
          );
        }
        return q;
      }).toList(),
    );
  }

  /// 从所有列表中移除题目
  void _removeQuestionFromLists(String wrongAnswerBookId) {
    state = state.copyWith(
      allQuestions: state.allQuestions
          .where((q) => q.wrongAnswerBookId != wrongAnswerBookId)
          .toList(),
      markedQuestions: state.markedQuestions
          .where((q) => q.wrongAnswerBookId != wrongAnswerBookId)
          .toList(),
      fallibleQuestions: state.fallibleQuestions
          .where((q) => q.wrongAnswerBookId != wrongAnswerBookId)
          .toList(),
    );
  }

  /// 提交题目纠错
  /// 对应小程序: error-correction.vue Line 123-135
  Future<void> submitErrorCorrection({
    required String questionId,
    required String questionVersionId,
    required String version,
    required String errorType,
    required String errorContent,
    required List<String> filePath,
  }) async {
    try {
      final service = ref.read(wrongBookServiceProvider);
      await service.submitCorrection(
        questionId: questionId,
        questionVersionId: questionVersionId,
        version: version,
        description: errorContent,
        errType: errorType,
        filePath: filePath,
      );
      
      print('✅ [WrongBookNotifier] 纠错提交成功');
    } catch (e) {
      print('❌ [WrongBookNotifier] 纠错提交失败: $e');
      rethrow;
    }
  }

  /// 将分组数据展开为错题列表
  List<WrongQuestionModel> _flattenGroups(List<WrongQuestionGroupResponse> groups) {
    final List<WrongQuestionModel> questions = [];
    for (final group in groups) {
      questions.addAll(group.questionList);
    }
    return questions;
  }
}
