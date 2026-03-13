import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yakaixin_app/core/network/dio_client.dart';
import 'package:yakaixin_app/features/exam/models/question_model.dart';
import 'package:yakaixin_app/features/exam/services/exam_service.dart';

part 'examinationing_provider.freezed.dart';
part 'examinationing_provider.g.dart';

/// 答题页面状态
@freezed
class ExaminationingState with _$ExaminationingState {
  const factory ExaminationingState({
    /// 试题列表
    @Default([]) List<QuestionModel> questions,

    /// 考试信息
    ExamInfoModel? examInfo,

    /// 当前题目索引
    @Default(0) int currentIndex,

    /// 剩余时间（秒）
    @Default(0) int remainingTime,

    /// 初始剩余时间（秒），答题/背题切换时重置用
    @Default(0) int initialRemainingTime,

    /// 是否正在加载
    @Default(false) bool isLoading,

    /// 错误信息
    String? error,

    /// 是否已交卷
    @Default(false) bool isSubmitted,
  }) = _ExaminationingState;
}

/// 答题页面Provider
///
/// 对应小程序: examinationing.vue
/// 提供试题加载、答题、交卷等功能
@riverpod
class ExaminationingNotifier extends _$ExaminationingNotifier {
  late Timer? _timer;

  @override
  ExaminationingState build() {
    _timer = null;
    return const ExaminationingState();
  }

  /// 加载试题
  /// 对应小程序: examinationing.vue（正式考）/ answertest/answer.vue（课前测/课后测 type=8）
  Future<void> loadQuestions({
    required String examinationId,
    required String examinationSessionId,
    required String professionalId,
    required String paperVersionId,
    required String type,
    int? timeLimit, // ✅ 添加可选的考试时长参数（秒）
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final examService = ref.read(examServiceProvider);
      final List<QuestionModel> questions;
      final bool isEvaluation = type.isEmpty || type == '8';

      if (isEvaluation) {
        // 课前测/课后测等：GET /c/tiku/question/getquestionlist?paper_version_id&type=8
        questions = await examService.getQuestionListForEvaluation(
          paperVersionId: paperVersionId,
        );
      } else {
        // 正式考试/模拟考：GET /c/tiku/chapter/getquestionlist
        questions = await examService.getQuestionList(
          examinationId: examinationId,
          examinationSessionId: examinationSessionId,
          professionalId: professionalId,
          paperVersionId: paperVersionId,
          type: type,
        );
      }

      // 2. 一拆多题：多子题拆成多条展示，一题一页
      final expandedQuestions = _expandQuestions(questions);
      final processedQuestions = _processQuestions(expandedQuestions);

      int remainingTime = 0;
      ExamInfoModel? examInfo;

      if (!isEvaluation) {
        examInfo = await examService.getStudentExamInfo(
          examId: examinationId,
          examRoundId: examinationSessionId,
        );
        remainingTime = _calculateRemainingTime(examInfo, timeLimit);
      }

      state = state.copyWith(
        questions: processedQuestions,
        examInfo: examInfo,
        remainingTime: remainingTime,
        initialRemainingTime: remainingTime,
        isLoading: false,
      );

      if (remainingTime > 0) {
        _startTimer();
      }
    } on DioException catch (e) {
      // ✅ 使用拦截器已处理好的用户友好错误信息
      final errorMsg = e.error?.toString() ?? '加载试题失败，请稍后重试';
      state = state.copyWith(isLoading: false, error: errorMsg);
    } catch (e) {
      // ✅ 兜底：未预期的错误
      state = state.copyWith(isLoading: false, error: '加载试题失败，请稍后重试');
    }
  }

  /// 一拆多题：将 stem_list 多于一条的题目拆成多条，每条只含一个子题，便于一题一页滑动
  /// 提交时按相同 id 合并回一条（见 submitAnswers 中的合并逻辑）
  List<QuestionModel> _expandQuestions(List<QuestionModel> questions) {
    final List<QuestionModel> result = [];
    for (final q in questions) {
      if (q.stemList.isEmpty) continue;
      if (q.stemList.length == 1) {
        result.add(q);
        continue;
      }
      for (int j = 0; j < q.stemList.length; j++) {
        result.add(q.copyWith(stemList: [q.stemList[j]]));
      }
    }
    return result;
  }

  /// 处理试题，添加题号
  List<QuestionModel> _processQuestions(List<QuestionModel> questions) {
    int questionNumber = 1;
    return questions.map((question) {
      return question.copyWith(questionNumber: questionNumber++);
    }).toList();
  }

  /// 计算剩余时间（秒）
  /// 对应小程序: examinationing.vue Line 566-590
  ///
  /// ✅ 修复逻辑：
  /// 1. 优先使用 API 返回的 endTime - currentTime
  /// 2. 如果 endTime 为空，使用传入的 timeLimit（对应小程序 Line 536: this.time = e.time * 1）
  int _calculateRemainingTime(ExamInfoModel examInfo, int? timeLimit) {
    // 1. 尝试使用 API 返回的时间
    if (examInfo.endTime != null &&
        examInfo.endTime!.isNotEmpty &&
        examInfo.currentTime != null &&
        examInfo.currentTime!.isNotEmpty) {
      try {
        print(
          '🕒 [倾计时] endTime: ${examInfo.endTime}, currentTime: ${examInfo.currentTime}',
        );
        final endTime = DateTime.parse(examInfo.endTime!);
        final currentTime = DateTime.parse(examInfo.currentTime!);

        final diff = endTime.difference(currentTime);
        final seconds = diff.inSeconds > 0 ? diff.inSeconds : 0;
        print('✅ [倾计时] 使用API时间，剩余时间: $seconds 秒 (${diff.inMinutes} 分钟)');
        return seconds;
      } catch (e) {
        print('❌ [倾计时] 解析时间错误: $e');
        // 继续尝试 fallback
      }
    }

    // 2. Fallback: 使用传入的考试时长（对应小程序逻辑）
    if (timeLimit != null && timeLimit > 0) {
      print(
        '✅ [倾计时] API未返回有效时间，使用传入的 timeLimit: $timeLimit 秒 (${timeLimit ~/ 60} 分钟)',
      );
      return timeLimit;
    }

    // 3. 最后尝试使用 duration 字段
    if (examInfo.duration != null) {
      try {
        final duration = int.parse(examInfo.duration.toString());
        if (duration > 0) {
          print('✅ [倾计时] 使用 duration 字段: $duration 秒');
          return duration;
        }
      } catch (e) {
        print('⚠️ [倾计时] duration 解析失败: $e');
      }
    }

    print('⚠️ [倾计时] 所有方法都无法获取有效时间，返回0');
    return 0;
  }

  /// 启动倒计时
  /// 对应小程序: examinationing.vue Line 213-252
  void _startTimer() {
    _timer?.cancel();

    print('🚀 [倒计时] 启动倒计时，当前剩余: ${state.remainingTime} 秒');

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingTime > 0 && !state.isSubmitted) {
        state = state.copyWith(remainingTime: state.remainingTime - 1);
        // 每10秒打印一次，避免日志过多
        if (state.remainingTime % 10 == 0) {
          print('⏱️ [倒计时] 剩余: ${state.remainingTime} 秒');
        }
      } else {
        print(
          '⏹️ [倒计时] 停止，剩余: ${state.remainingTime} 秒, 已交卷: ${state.isSubmitted}',
        );
        timer.cancel();
      }
    });
  }

  /// 重置剩余时间为初始值（答题/背题切换时调用）
  /// 必须先取消旧定时器再更新状态并重新启动，否则上一个倒计时会继续跑
  void resetRemainingTime() {
    final initial = state.initialRemainingTime;
    if (initial > 0) {
      _timer?.cancel();
      state = state.copyWith(remainingTime: initial);
      _startTimer();
    }
  }

  /// 切换到指定题目
  /// 对应小程序: answer-sheet.vue 答题卡点击事件
  void goToQuestion(int index) {
    if (index >= 0 && index < state.questions.length) {
      state = state.copyWith(currentIndex: index);
    }
  }

  /// 下一题
  void nextQuestion() {
    if (state.currentIndex < state.questions.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }

  /// 上一题
  void previousQuestion() {
    if (state.currentIndex > 0) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }

  /// 选择答案（单选/多选/判断）
  /// 对应小程序: question-answer.vue 选项点击事件
  void selectAnswer(List<String> selectedOptions) {
    final updatedQuestions = [...state.questions];
    final currentQuestion = updatedQuestions[state.currentIndex];

    // 更新子题的选中答案
    final updatedStemList = currentQuestion.stemList.map((stem) {
      return stem.copyWith(selected: selectedOptions);
    }).toList();

    // 更新题目
    updatedQuestions[state.currentIndex] = currentQuestion.copyWith(
      stemList: updatedStemList,
      userOption: selectedOptions.join(','),
    );

    state = state.copyWith(questions: updatedQuestions);
  }

  /// 标疑
  /// 对应小程序: examinationing.vue Line 525-542
  void toggleDoubt() {
    final updatedQuestions = [...state.questions];
    final currentQuestion = updatedQuestions[state.currentIndex];

    updatedQuestions[state.currentIndex] = currentQuestion.copyWith(
      doubt: !currentQuestion.doubt,
    );

    state = state.copyWith(questions: updatedQuestions);
  }

  /// 检查是否所有题目都已答
  bool get isAllAnswered {
    return state.questions.every(
      (q) => q.userOption != null && q.userOption!.isNotEmpty,
    );
  }

  /// 获取未答题数量
  int get unansweredCount {
    return state.questions
        .where((q) => q.userOption == null || q.userOption!.isEmpty)
        .length;
  }

  /// 提交答案（交卷）
  /// 对应小程序: examinationing.vue / answertest/answer.vue postAnswer
  Future<void> submitAnswers({
    required String goodsId,
    required String orderId,
    required String productId,
    required String professionalId,
    required String type,
    required String userId,
    required String studentId,
    required int totalTime,
    String? evaluationTypeId, // 测评交卷必传
    String? orderDetailId,
    String? teachingSystemRelationId, // system_id
  }) async {
    if (state.isSubmitted) {
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // 1. 计算耗时（对应小程序 Line 410: parseInt(this.examTime - this.time)）
      final costTime = totalTime - state.remainingTime;
      final finalCostTime = costTime > 0 ? costTime : 1; // ✅ 对应小程序 Line 411-413

      // 2. 构建答案数据（对应小程序 Line 417-431 / test.vue Line 404-419）
      // ⚠️ 一拆多题后：同一 id 可能有多条（多个子题），需合并成一条再提交
      final List<Map<String, dynamic>> questionInfo = [];
      for (final question in state.questions) {
        final questionId = question.id;
        final userOption = question.stemList.map((stem) {
          final answer = stem.selected.map((item) {
            if (question.type == '8' ||
                question.type == '9' ||
                question.type == '10') {
              return item.replaceAll('\n', '<br/>');
            }
            return item.toString();
          }).toList();
          return {
            'sub_question_id': stem.id,
            'answer': answer,
          };
        }).toList();

        if (questionInfo.isNotEmpty && questionInfo.last['question_id'] == questionId) {
          (questionInfo.last['user_option'] as List).addAll(userOption);
        } else {
          questionInfo.add({
            'question_id': questionId,
            'user_option': userOption,
          });
        }
      }

      // 3. 提交答案（包含所有必填参数）
      final examService = ref.read(examServiceProvider);

      // ✅ 调试日志：打印 question_info JSON 格式（分段打印避免截断）
      final questionInfoJson = jsonEncode(questionInfo);
      print('📋 [question_info] 题目总数: ${questionInfo.length}');
      print('📋 [question_info] JSON长度: ${questionInfoJson.length} 字符');

      // 打印前3个问题的详细格式
      for (int i = 0; i < questionInfo.length && i < 3; i++) {
        print('📋 [question_info] 第${i + 1}题:');
        print(jsonEncode(questionInfo[i]));
      }

      // 如果超过3题，只打印最后一题
      if (questionInfo.length > 3) {
        print('📋 [question_info] ... 中间省略 ${questionInfo.length - 4} 题 ...');
        print('📋 [question_info] 最后一题:');
        print(jsonEncode(questionInfo.last));
      }

      await examService.submitAnswer(
        productId: productId,
        professionalId: professionalId,
        costTime: finalCostTime,
        type: type,
        questionInfo: questionInfoJson,
        goodsId: goodsId,
        orderId: orderId,
        userId: userId,
        studentId: studentId,
        evaluationTypeId: evaluationTypeId,
        orderDetailId: orderDetailId,
        teachingSystemRelationId: teachingSystemRelationId,
      );

      // 4. 停止计时器
      _timer?.cancel();

      state = state.copyWith(isSubmitted: true, isLoading: false);
    } on DioException catch (e) {
      // ✅ 使用拦截器已处理好的用户友好错误信息
      final errorMsg = e.error?.toString() ?? '提交失败，请稍后重试';
      state = state.copyWith(isLoading: false, error: errorMsg);

      // ✅ 2秒后自动清除错误状态，防止反复弹出
      Future.delayed(const Duration(seconds: 2), () {
        if (state.error == errorMsg) {
          state = state.copyWith(error: null);
        }
      });
    } catch (e) {
      // ✅ 兜底：未预期的错误
      const errorMsg = '提交失败，请稍后重试';
      state = state.copyWith(isLoading: false, error: errorMsg);

      // ✅ 2秒后自动清除错误状态，防止反复弹出
      Future.delayed(const Duration(seconds: 2), () {
        if (state.error == errorMsg) {
          state = state.copyWith(error: null);
        }
      });
    }
  }

  /// 释放资源
  void dispose() {
    _timer?.cancel();
  }
}

/// ExamService Provider
final examServiceProvider = Provider<ExamService>((ref) {
  return ExamService(ref.read(dioClientProvider));
});
