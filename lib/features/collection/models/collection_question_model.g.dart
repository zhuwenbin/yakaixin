// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CollectionQuestionModelImpl _$$CollectionQuestionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CollectionQuestionModelImpl(
      id: json['id'] as String,
      practiceId: json['practice_id'] as String?,
      professionalId: json['professional_id'] as String?,
      chapterId: json['chapter_id'] as String?,
      thematicStem: json['thematic_stem'] as String?,
      type: json['type'] as String,
      typeName: json['type_name'] as String?,
      level: json['level'] as String,
      year: json['year'] as String?,
      errRate: json['err_rate'] as String?,
      parse: json['parse'] as String?,
      knowledgeIds:
          const DynamicToStringListConverter().fromJson(json['knowledge_ids']),
      knowledgeIdsName: const DynamicToStringListConverter()
          .fromJson(json['knowledge_ids_name']),
      stemList: (json['stem_list'] as List<dynamic>)
          .map((e) => QuestionStemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] as String?,
      isCollect: json['is_collect'] as String?,
      isAnswer: json['is_answer'] as String?,
      userOption: json['user_option'] as String?,
      answerStatus: json['answer_status'] as String?,
      titleInfo:
          const DynamicToStringListConverter().fromJson(json['titleInfo']),
    );

Map<String, dynamic> _$$CollectionQuestionModelImplToJson(
        _$CollectionQuestionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'practice_id': instance.practiceId,
      'professional_id': instance.professionalId,
      'chapter_id': instance.chapterId,
      'thematic_stem': instance.thematicStem,
      'type': instance.type,
      'type_name': instance.typeName,
      'level': instance.level,
      'year': instance.year,
      'err_rate': instance.errRate,
      'parse': instance.parse,
      'knowledge_ids':
          const DynamicToStringListConverter().toJson(instance.knowledgeIds),
      'knowledge_ids_name': const DynamicToStringListConverter()
          .toJson(instance.knowledgeIdsName),
      'stem_list': instance.stemList,
      'created_at': instance.createdAt,
      'is_collect': instance.isCollect,
      'is_answer': instance.isAnswer,
      'user_option': instance.userOption,
      'answer_status': instance.answerStatus,
      'titleInfo':
          const DynamicToStringListConverter().toJson(instance.titleInfo),
    };

_$QuestionStemModelImpl _$$QuestionStemModelImplFromJson(
        Map<String, dynamic> json) =>
    _$QuestionStemModelImpl(
      id: json['id'] as String,
      sort: json['sort'] as String?,
      content: json['content'] as String?,
      option: json['option'] as String?,
      answer: json['answer'] as String?,
      questionVersionId: const DynamicToStringConverter()
          .fromJson(json['question_version_id']),
    );

Map<String, dynamic> _$$QuestionStemModelImplToJson(
        _$QuestionStemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sort': instance.sort,
      'content': instance.content,
      'option': instance.option,
      'answer': instance.answer,
      'question_version_id':
          const DynamicToStringConverter().toJson(instance.questionVersionId),
    };

_$CollectionListResponseImpl _$$CollectionListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CollectionListResponseImpl(
      list: (json['list'] as List<dynamic>)
          .map((e) =>
              CollectionQuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$$CollectionListResponseImplToJson(
        _$CollectionListResponseImpl instance) =>
    <String, dynamic>{
      'list': instance.list,
      'total': instance.total,
    };
