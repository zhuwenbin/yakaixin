// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionModelImpl _$$QuestionModelImplFromJson(Map<String, dynamic> json) =>
    _$QuestionModelImpl(
      id: json['id'] as String,
      questionId: json['question_id'] as String?,
      practiceId: json['practice_id'] as String?,
      professionalId: json['professional_id'] as String?,
      chapterId: json['chapter_id'] as String?,
      knowledgeIds: (json['knowledge_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      knowledgeIdsName: (json['knowledge_ids_name'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      thematicStem: json['thematic_stem'] as String?,
      type: json['type'] as String,
      typeName: json['type_name'] as String?,
      level: json['level'] as String?,
      year: json['year'] as String?,
      errRate: json['err_rate'] as String?,
      version: json['version'] as String?,
      parse: json['parse'] as String?,
      stemList: (json['stem_list'] as List<dynamic>)
          .map((e) => SubQuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      chapterDetailId: json['chapter_detail_id'] as String?,
      isAnswer: json['is_answer'] as String?,
      userOption: json['user_option'] as String?,
      answerStatus: json['answer_status'] as String?,
      checkStatus: json['check_status'] as String?,
      questionStatisticsInfo: json['question_statistics_info'] == null
          ? null
          : QuestionStatisticsModel.fromJson(
              json['question_statistics_info'] as Map<String, dynamic>),
      doubt: json['doubt'] as bool? ?? false,
      questionNumber: (json['questionNumber'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$QuestionModelImplToJson(_$QuestionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question_id': instance.questionId,
      'practice_id': instance.practiceId,
      'professional_id': instance.professionalId,
      'chapter_id': instance.chapterId,
      'knowledge_ids': instance.knowledgeIds,
      'knowledge_ids_name': instance.knowledgeIdsName,
      'thematic_stem': instance.thematicStem,
      'type': instance.type,
      'type_name': instance.typeName,
      'level': instance.level,
      'year': instance.year,
      'err_rate': instance.errRate,
      'version': instance.version,
      'parse': instance.parse,
      'stem_list': instance.stemList,
      'chapter_detail_id': instance.chapterDetailId,
      'is_answer': instance.isAnswer,
      'user_option': instance.userOption,
      'answer_status': instance.answerStatus,
      'check_status': instance.checkStatus,
      'question_statistics_info': instance.questionStatisticsInfo,
      'doubt': instance.doubt,
      'questionNumber': instance.questionNumber,
    };

_$SubQuestionModelImpl _$$SubQuestionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SubQuestionModelImpl(
      id: json['id'] as String,
      sort: json['sort'] as String?,
      content: json['content'] as String,
      option: json['option'] as String?,
      answer: json['answer'] as String?,
      questionVersionId: json['question_version_id'] as String?,
      selected: (json['selected'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SubQuestionModelImplToJson(
        _$SubQuestionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sort': instance.sort,
      'content': instance.content,
      'option': instance.option,
      'answer': instance.answer,
      'question_version_id': instance.questionVersionId,
      'selected': instance.selected,
    };

_$QuestionStatisticsModelImpl _$$QuestionStatisticsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$QuestionStatisticsModelImpl(
      doQuestionNum: json['doQuestionNum'] as String?,
      accuracy: json['accuracy'] as String?,
      errorOption: json['errorOption'] as String?,
    );

Map<String, dynamic> _$$QuestionStatisticsModelImplToJson(
        _$QuestionStatisticsModelImpl instance) =>
    <String, dynamic>{
      'doQuestionNum': instance.doQuestionNum,
      'accuracy': instance.accuracy,
      'errorOption': instance.errorOption,
    };

_$ExamInfoModelImpl _$$ExamInfoModelImplFromJson(Map<String, dynamic> json) =>
    _$ExamInfoModelImpl(
      examId: json['exam_id'] as String?,
      examRoundId: json['exam_round_id'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      currentTime: json['current_time'] as String?,
      status: json['status'],
      duration: json['duration'],
    );

Map<String, dynamic> _$$ExamInfoModelImplToJson(_$ExamInfoModelImpl instance) =>
    <String, dynamic>{
      'exam_id': instance.examId,
      'exam_round_id': instance.examRoundId,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'current_time': instance.currentTime,
      'status': instance.status,
      'duration': instance.duration,
    };
