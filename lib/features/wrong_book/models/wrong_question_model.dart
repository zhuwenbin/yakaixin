import 'package:freezed_annotation/freezed_annotation.dart';

part 'wrong_question_model.freezed.dart';
part 'wrong_question_model.g.dart';

/// 错题列表响应 - 外层分组
@freezed
class WrongQuestionGroupResponse with _$WrongQuestionGroupResponse {
  const factory WrongQuestionGroupResponse({
    @JsonKey(name: 'question_type') String? questionType,
    @JsonKey(name: 'question_type_name') String? questionTypeName,
    @JsonKey(name: 'question_num') String? questionNum,
    @JsonKey(name: 'get_score') String? getScore,
    @JsonKey(name: 'sum_score') String? sumScore,
    @JsonKey(name: 'scoring_average') String? scoringAverage,
    @JsonKey(name: 'avg_take_time') String? avgTakeTime,
    @JsonKey(name: 'question_list') @Default([]) List<WrongQuestionModel> questionList,
  }) = _WrongQuestionGroupResponse;

  factory WrongQuestionGroupResponse.fromJson(Map<String, dynamic> json) =>
      _$WrongQuestionGroupResponseFromJson(json);
}

/// 错题模型
/// 对应小程序: wrongQuestionBook/index.vue
@freezed
class WrongQuestionModel with _$WrongQuestionModel {
  const factory WrongQuestionModel({
    // ✅ 基础字段
    required String id,
    @JsonKey(name: 'question_id') String? questionId,
    @JsonKey(name: 'version') String? version,
    
    // ✅ 题目信息 - 使用 dynamic 处理不确定类型
    @JsonKey(name: 'type') dynamic type,
    @JsonKey(name: 'type_name') String? typeName,
    @JsonKey(name: 'level') dynamic level,
    @JsonKey(name: 'sort') String? sort,
    
    // ✅ 题干信息
    @JsonKey(name: 'thematic_stem') String? thematicStem,
    @JsonKey(name: 'stem_list') List<QuestionStemModel>? stemList,
    
    // ✅ 解析和知识点
    @JsonKey(name: 'parse') String? parse,
    @JsonKey(name: 'knowledge_ids_name') String? knowledgeIdsName,
    @JsonKey(name: 'chapter_ids_name') String? chapterIdsName,
    @JsonKey(name: 'is_allow_answer_disorder') String? isAllowAnswerDisorder,
    @JsonKey(name: 'resource_info') String? resourceInfo,
    
    // ✅ 错题本相关
    @JsonKey(name: 'answer_question_version_id') String? answerQuestionVersionId,
    @JsonKey(name: 'wrong_answer_book_id') String? wrongAnswerBookId,
    @JsonKey(name: 'is_mark') dynamic isMark,
    @JsonKey(name: 'is_fallibility') dynamic isFallibility,
    @JsonKey(name: 'tags') String? tags,
    @JsonKey(name: 'created_at_val') String? createdAtVal,
    
    // ✅ 时间字段
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _WrongQuestionModel;

  factory WrongQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$WrongQuestionModelFromJson(json);
}

/// 题干模型
@freezed
class QuestionStemModel with _$QuestionStemModel {
  const factory QuestionStemModel({
    required String id,
    @JsonKey(name: 'question_version_id') dynamic questionVersionId,
    @JsonKey(name: 'sort') String? sort,
    @JsonKey(name: 'content') String? content,
    @JsonKey(name: 'option') String? option,  // JSON数组字符串
    @JsonKey(name: 'answer') String? answer,  // JSON数组字符串 ["0"]
    @JsonKey(name: 'parse') String? parse,
    @JsonKey(name: 'chapter_names') String? chapterNames,
    @JsonKey(name: 'knowledge_names') String? knowledgeNames,
    @JsonKey(name: 'sub_answer') String? subAnswer,  // 用户答案
    @JsonKey(name: 'answer_status') String? answerStatus,
    @JsonKey(name: 'get_score') String? getScore,
    @JsonKey(name: 'task_time') String? taskTime,
  }) = _QuestionStemModel;

  factory QuestionStemModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionStemModelFromJson(json);
}

/// 错题列表响应模型
@freezed
class WrongQuestionListResponse with _$WrongQuestionListResponse {
  const factory WrongQuestionListResponse({
    @Default([]) List<WrongQuestionGroupResponse> groups,
  }) = _WrongQuestionListResponse;
}
