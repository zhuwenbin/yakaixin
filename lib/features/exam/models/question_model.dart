import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_model.freezed.dart';
part 'question_model.g.dart';

/// 试题模型
/// 
/// 对应小程序接口: /c/tiku/chapter/getquestionlist
/// 数据来源: examinationing.vue Line 519-522
@freezed
class QuestionModel with _$QuestionModel {
  const factory QuestionModel({
    /// 题目版本ID（question_version_id）
    /// ⚠️ 关键：提交答案时使用此字段作为 question_id 参数
    /// 对应接口返回的 section_info[i].id （如 582238838496170019）
    @JsonKey(name: 'id') required String id,
    
    /// 题目引用ID（question_id）
    /// ⚠️ 注意：此字段只用于数据库关联，不用于提交答案
    /// 对应接口返回的 section_info[i].question_id （如 582238836886474787）
    @JsonKey(name: 'question_id') String? questionId,
    
    /// 练习ID
    @JsonKey(name: 'practice_id') String? practiceId,
    
    /// 专业ID
    @JsonKey(name: 'professional_id') String? professionalId,
    
    /// 章节ID
    @JsonKey(name: 'chapter_id') String? chapterId,
    
    /// 知识点IDs
    @JsonKey(name: 'knowledge_ids') List<String>? knowledgeIds,
    
    /// 知识点名称
    @JsonKey(name: 'knowledge_ids_name') List<String>? knowledgeIdsName,
    
    /// 题干（主题型题目）
    @JsonKey(name: 'thematic_stem') String? thematicStem,
    
    /// 题型 (1-单选, 2-多选, 3-判断, 8-填空, 9-简答, 10-论述)
    @JsonKey(name: 'type') required String type,
    
    /// 题型名称
    @JsonKey(name: 'type_name') String? typeName,
    
    /// 难度等级
    @JsonKey(name: 'level') String? level,
    
    /// 年份
    @JsonKey(name: 'year') String? year,
    
    /// 错误率
    @JsonKey(name: 'err_rate') String? errRate,
    
    /// 版本
    @JsonKey(name: 'version') String? version,
    
    /// 解析（HTML格式）
    @JsonKey(name: 'parse') String? parse,
    
    /// 子题列表
    @JsonKey(name: 'stem_list') required List<SubQuestionModel> stemList,
    
    /// 章节详情ID
    @JsonKey(name: 'chapter_detail_id') String? chapterDetailId,
    
    /// 是否已答
    @JsonKey(name: 'is_answer') String? isAnswer,
    
    /// 用户选项（逗号分隔，如 "1,2"）
    @JsonKey(name: 'user_option') String? userOption,
    
    /// 答题状态 (0-未答, 1-已答)
    @JsonKey(name: 'answer_status') String? answerStatus,
    
    /// 批改状态
    @JsonKey(name: 'check_status') String? checkStatus,
    
    /// 题目统计信息
    @JsonKey(name: 'question_statistics_info') QuestionStatisticsModel? questionStatisticsInfo,
    
    /// 是否标疑（Flutter本地字段，不从API返回）
    @Default(false) bool doubt,
    
    /// 题号（Flutter本地字段）
    @Default(0) int questionNumber,
  }) = _QuestionModel;

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);
}

/// 子题模型（单选/多选的具体题目）
@freezed
class SubQuestionModel with _$SubQuestionModel {
  const factory SubQuestionModel({
    /// 子题ID
    @JsonKey(name: 'id') required String id,
    
    /// 排序
    @JsonKey(name: 'sort') String? sort,
    
    /// 题干内容（HTML格式）
    @JsonKey(name: 'content') required String content,
    
    /// 选项（JSON字符串数组，如 '["选项A", "选项B"]'）
    @JsonKey(name: 'option') String? option,
    
    /// 正确答案（JSON字符串数组，如 '["1", "2"]'）
    @JsonKey(name: 'answer') String? answer,
    
    /// 题目版本ID
    @JsonKey(name: 'question_version_id') String? questionVersionId,
    
    /// 用户选择的答案（Flutter本地字段，List<String>）
    @Default([]) List<String> selected,
  }) = _SubQuestionModel;

  factory SubQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$SubQuestionModelFromJson(json);
}

/// 题目统计信息
@freezed
class QuestionStatisticsModel with _$QuestionStatisticsModel {
  const factory QuestionStatisticsModel({
    /// 做题数量
    @JsonKey(name: 'doQuestionNum') String? doQuestionNum,
    
    /// 正确率
    @JsonKey(name: 'accuracy') String? accuracy,
    
    /// 错误选项
    @JsonKey(name: 'errorOption') String? errorOption,
  }) = _QuestionStatisticsModel;

  factory QuestionStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionStatisticsModelFromJson(json);
}

/// 考试信息模型
/// 
/// 对应接口: /c/tiku/mockexam/getstudentexaminfo
@freezed
class ExamInfoModel with _$ExamInfoModel {
  const factory ExamInfoModel({
    /// 考试ID
    @JsonKey(name: 'exam_id') String? examId,
    
    /// 考试轮次ID
    @JsonKey(name: 'exam_round_id') String? examRoundId,
    
    /// 开始时间
    @JsonKey(name: 'start_time') String? startTime,
    
    /// 结束时间
    @JsonKey(name: 'end_time') String? endTime,
    
    /// 当前时间
    @JsonKey(name: 'current_time') String? currentTime,
    
    /// 考试状态
    @JsonKey(name: 'status') dynamic status,
    
    /// 考试时长（秒）
    @JsonKey(name: 'duration') dynamic duration,
  }) = _ExamInfoModel;

  factory ExamInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ExamInfoModelFromJson(json);
}
