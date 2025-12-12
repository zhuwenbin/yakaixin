// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wrong_question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WrongQuestionGroupResponseImpl _$$WrongQuestionGroupResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$WrongQuestionGroupResponseImpl(
      questionType: json['question_type'] as String?,
      questionTypeName: json['question_type_name'] as String?,
      questionNum: json['question_num'] as String?,
      getScore: json['get_score'] as String?,
      sumScore: json['sum_score'] as String?,
      scoringAverage: json['scoring_average'] as String?,
      avgTakeTime: json['avg_take_time'] as String?,
      questionList: (json['question_list'] as List<dynamic>?)
              ?.map(
                  (e) => WrongQuestionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$WrongQuestionGroupResponseImplToJson(
        _$WrongQuestionGroupResponseImpl instance) =>
    <String, dynamic>{
      'question_type': instance.questionType,
      'question_type_name': instance.questionTypeName,
      'question_num': instance.questionNum,
      'get_score': instance.getScore,
      'sum_score': instance.sumScore,
      'scoring_average': instance.scoringAverage,
      'avg_take_time': instance.avgTakeTime,
      'question_list': instance.questionList,
    };

_$WrongQuestionModelImpl _$$WrongQuestionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$WrongQuestionModelImpl(
      id: json['id'] as String,
      questionId: json['question_id'] as String?,
      version: json['version'] as String?,
      type: json['type'],
      typeName: json['type_name'] as String?,
      level: json['level'],
      sort: json['sort'] as String?,
      thematicStem: json['thematic_stem'] as String?,
      stemList: (json['stem_list'] as List<dynamic>?)
          ?.map((e) => QuestionStemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      parse: json['parse'] as String?,
      knowledgeIdsName: json['knowledge_ids_name'] as String?,
      chapterIdsName: json['chapter_ids_name'] as String?,
      isAllowAnswerDisorder: json['is_allow_answer_disorder'] as String?,
      resourceInfo: json['resource_info'] as String?,
      answerQuestionVersionId: json['answer_question_version_id'] as String?,
      wrongAnswerBookId: json['wrong_answer_book_id'] as String?,
      isMark: json['is_mark'],
      isFallibility: json['is_fallibility'],
      tags: json['tags'] as String?,
      createdAtVal: json['created_at_val'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$$WrongQuestionModelImplToJson(
        _$WrongQuestionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question_id': instance.questionId,
      'version': instance.version,
      'type': instance.type,
      'type_name': instance.typeName,
      'level': instance.level,
      'sort': instance.sort,
      'thematic_stem': instance.thematicStem,
      'stem_list': instance.stemList,
      'parse': instance.parse,
      'knowledge_ids_name': instance.knowledgeIdsName,
      'chapter_ids_name': instance.chapterIdsName,
      'is_allow_answer_disorder': instance.isAllowAnswerDisorder,
      'resource_info': instance.resourceInfo,
      'answer_question_version_id': instance.answerQuestionVersionId,
      'wrong_answer_book_id': instance.wrongAnswerBookId,
      'is_mark': instance.isMark,
      'is_fallibility': instance.isFallibility,
      'tags': instance.tags,
      'created_at_val': instance.createdAtVal,
      'created_at': instance.createdAt,
    };

_$QuestionStemModelImpl _$$QuestionStemModelImplFromJson(
        Map<String, dynamic> json) =>
    _$QuestionStemModelImpl(
      id: json['id'] as String,
      questionVersionId: json['question_version_id'],
      sort: json['sort'] as String?,
      content: json['content'] as String?,
      option: json['option'] as String?,
      answer: json['answer'] as String?,
      parse: json['parse'] as String?,
      chapterNames: json['chapter_names'] as String?,
      knowledgeNames: json['knowledge_names'] as String?,
      subAnswer: json['sub_answer'] as String?,
      answerStatus: json['answer_status'] as String?,
      getScore: json['get_score'] as String?,
      taskTime: json['task_time'] as String?,
    );

Map<String, dynamic> _$$QuestionStemModelImplToJson(
        _$QuestionStemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question_version_id': instance.questionVersionId,
      'sort': instance.sort,
      'content': instance.content,
      'option': instance.option,
      'answer': instance.answer,
      'parse': instance.parse,
      'chapter_names': instance.chapterNames,
      'knowledge_names': instance.knowledgeNames,
      'sub_answer': instance.subAnswer,
      'answer_status': instance.answerStatus,
      'get_score': instance.getScore,
      'task_time': instance.taskTime,
    };
