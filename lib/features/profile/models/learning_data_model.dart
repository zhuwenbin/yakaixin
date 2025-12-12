import 'package:freezed_annotation/freezed_annotation.dart';

part 'learning_data_model.freezed.dart';
part 'learning_data_model.g.dart';

/// 学习数据Model
/// 对应小程序: getLearningData 接口返回
/// 接口: GET /c/tiku/exam/learning/data
@freezed
class LearningDataModel with _$LearningDataModel {
  const factory LearningDataModel({
    /// 正确率(%)
    @JsonKey(name: 'correct_rate') String? correctRate,

    /// 易错知识点列表
    @JsonKey(name: 'knowledge_err_list')
    @Default([])
    List<KnowledgeErrorModel> knowledgeErrList,

    /// 学习知识点数量
    @JsonKey(name: 'knowledge_num') dynamic knowledgeNum,

    /// 学习时长(小时)
    @JsonKey(name: 'learn_time') String? learnTime,

    /// 本月刷题量数据
    @JsonKey(name: 'to_month_do_question_num')
    @Default([])
    List<DailyQuestionModel> toMonthDoQuestionNum,

    /// 本月学习时长数据
    @JsonKey(name: 'to_month_learn_time')
    @Default([])
    List<DailyLearnTimeModel> toMonthLearnTime,

    /// 一周刷题量数据
    @JsonKey(name: 'to_week_do_question_num')
    @Default([])
    List<DailyQuestionModel> toWeekDoQuestionNum,

    /// 一周学习时长数据
    @JsonKey(name: 'to_week_learn_time')
    @Default([])
    List<DailyLearnTimeModel> toWeekLearnTime,

    /// 今日学习时长
    @JsonKey(name: 'today_learn_time') String? todayLearnTime,

    /// 今日刷题量
    @JsonKey(name: 'today_total_num') dynamic todayTotalNum,

    /// 总刷题量
    @JsonKey(name: 'total_num') dynamic totalNum,
  }) = _LearningDataModel;

  factory LearningDataModel.fromJson(Map<String, dynamic> json) =>
      _$LearningDataModelFromJson(json);
}

/// 易错知识点
@freezed
class KnowledgeErrorModel with _$KnowledgeErrorModel {
  const factory KnowledgeErrorModel({
    /// 错误次数
    @JsonKey(name: 'fault_sum') dynamic faultSum,

    /// 知识点ID
    @JsonKey(name: 'knowledge_id') String? knowledgeId,

    /// 知识点名称
    @JsonKey(name: 'knowledge_id_name') String? knowledgeIdName,
  }) = _KnowledgeErrorModel;

  factory KnowledgeErrorModel.fromJson(Map<String, dynamic> json) =>
      _$KnowledgeErrorModelFromJson(json);
}

/// 每日刷题量
@freezed
class DailyQuestionModel with _$DailyQuestionModel {
  const factory DailyQuestionModel({
    /// 日期 (如: "01-20")
    String? date,

    /// 数量
    dynamic num,
  }) = _DailyQuestionModel;

  factory DailyQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$DailyQuestionModelFromJson(json);
}

/// 每日学习时长
@freezed
class DailyLearnTimeModel with _$DailyLearnTimeModel {
  const factory DailyLearnTimeModel({
    /// 日期
    String? date,

    /// 学习时长(小时)
    @JsonKey(name: 'learn_time') dynamic learnTime,
  }) = _DailyLearnTimeModel;

  factory DailyLearnTimeModel.fromJson(Map<String, dynamic> json) =>
      _$DailyLearnTimeModelFromJson(json);
}
