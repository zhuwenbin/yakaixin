// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LearningDataModelImpl _$$LearningDataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LearningDataModelImpl(
      correctRate: json['correct_rate'] as String?,
      knowledgeErrList: (json['knowledge_err_list'] as List<dynamic>?)
              ?.map((e) =>
                  KnowledgeErrorModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      knowledgeNum: json['knowledge_num'],
      learnTime: json['learn_time'] as String?,
      toMonthDoQuestionNum: (json['to_month_do_question_num'] as List<dynamic>?)
              ?.map(
                  (e) => DailyQuestionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      toMonthLearnTime: (json['to_month_learn_time'] as List<dynamic>?)
              ?.map((e) =>
                  DailyLearnTimeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      toWeekDoQuestionNum: (json['to_week_do_question_num'] as List<dynamic>?)
              ?.map(
                  (e) => DailyQuestionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      toWeekLearnTime: (json['to_week_learn_time'] as List<dynamic>?)
              ?.map((e) =>
                  DailyLearnTimeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      todayLearnTime: json['today_learn_time'] as String?,
      todayTotalNum: json['today_total_num'],
      totalNum: json['total_num'],
    );

Map<String, dynamic> _$$LearningDataModelImplToJson(
        _$LearningDataModelImpl instance) =>
    <String, dynamic>{
      'correct_rate': instance.correctRate,
      'knowledge_err_list': instance.knowledgeErrList,
      'knowledge_num': instance.knowledgeNum,
      'learn_time': instance.learnTime,
      'to_month_do_question_num': instance.toMonthDoQuestionNum,
      'to_month_learn_time': instance.toMonthLearnTime,
      'to_week_do_question_num': instance.toWeekDoQuestionNum,
      'to_week_learn_time': instance.toWeekLearnTime,
      'today_learn_time': instance.todayLearnTime,
      'today_total_num': instance.todayTotalNum,
      'total_num': instance.totalNum,
    };

_$KnowledgeErrorModelImpl _$$KnowledgeErrorModelImplFromJson(
        Map<String, dynamic> json) =>
    _$KnowledgeErrorModelImpl(
      faultSum: json['fault_sum'],
      knowledgeId: json['knowledge_id'] as String?,
      knowledgeIdName: json['knowledge_id_name'] as String?,
    );

Map<String, dynamic> _$$KnowledgeErrorModelImplToJson(
        _$KnowledgeErrorModelImpl instance) =>
    <String, dynamic>{
      'fault_sum': instance.faultSum,
      'knowledge_id': instance.knowledgeId,
      'knowledge_id_name': instance.knowledgeIdName,
    };

_$DailyQuestionModelImpl _$$DailyQuestionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DailyQuestionModelImpl(
      date: json['date'] as String?,
      num: json['num'],
    );

Map<String, dynamic> _$$DailyQuestionModelImplToJson(
        _$DailyQuestionModelImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'num': instance.num,
    };

_$DailyLearnTimeModelImpl _$$DailyLearnTimeModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DailyLearnTimeModelImpl(
      date: json['date'] as String?,
      learnTime: json['learn_time'],
    );

Map<String, dynamic> _$$DailyLearnTimeModelImplToJson(
        _$DailyLearnTimeModelImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'learn_time': instance.learnTime,
    };
