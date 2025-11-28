// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_bank_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LearningDataModelImpl _$$LearningDataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LearningDataModelImpl(
      checkinNum: json['checkin_num'] == null
          ? 0
          : const IntConverter().fromJson(json['checkin_num']),
      totalNum: json['total_num'] == null
          ? 0
          : const IntConverter().fromJson(json['total_num']),
      correctRate: json['correct_rate'] == null
          ? '0'
          : const StringConverter().fromJson(json['correct_rate']),
      isCheckin: json['is_checkin'] == null
          ? 0
          : const IntConverter().fromJson(json['is_checkin']),
      doneNum: json['done_num'] == null
          ? 0
          : const IntConverter().fromJson(json['done_num']),
      studyDays: json['study_days'] == null
          ? 0
          : const IntConverter().fromJson(json['study_days']),
    );

Map<String, dynamic> _$$LearningDataModelImplToJson(
        _$LearningDataModelImpl instance) =>
    <String, dynamic>{
      'checkin_num': const IntConverter().toJson(instance.checkinNum),
      'total_num': const IntConverter().toJson(instance.totalNum),
      'correct_rate': const StringConverter().toJson(instance.correctRate),
      'is_checkin': const IntConverter().toJson(instance.isCheckin),
      'done_num': const IntConverter().toJson(instance.doneNum),
      'study_days': const IntConverter().toJson(instance.studyDays),
    };

_$ChapterModelImpl _$$ChapterModelImplFromJson(Map<String, dynamic> json) =>
    _$ChapterModelImpl(
      id: json['id'] == null
          ? ''
          : const StringConverter().fromJson(json['id']),
      sectionName: json['sectionname'] == null
          ? ''
          : const StringConverter().fromJson(json['sectionname']),
      questionNumber: json['question_number'] == null
          ? 0
          : const IntConverter().fromJson(json['question_number']),
      doQuestionNum: json['do_question_num'] == null
          ? 0
          : const IntConverter().fromJson(json['do_question_num']),
      correctRate: json['correct_rate'] == null
          ? 0.0
          : const DoubleConverter().fromJson(json['correct_rate']),
    );

Map<String, dynamic> _$$ChapterModelImplToJson(_$ChapterModelImpl instance) =>
    <String, dynamic>{
      'id': const StringConverter().toJson(instance.id),
      'sectionname': const StringConverter().toJson(instance.sectionName),
      'question_number': const IntConverter().toJson(instance.questionNumber),
      'do_question_num': const IntConverter().toJson(instance.doQuestionNum),
      'correct_rate': const DoubleConverter().toJson(instance.correctRate),
    };

_$PurchasedGoodsModelImpl _$$PurchasedGoodsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PurchasedGoodsModelImpl(
      id: json['id'] == null
          ? ''
          : const StringConverter().fromJson(json['id']),
      name: json['name'] == null
          ? ''
          : const StringConverter().fromJson(json['name']),
      materialCoverPath: json['material_cover_path'] == null
          ? ''
          : const StringConverter().fromJson(json['material_cover_path']),
      questionCount: json['question_count'] == null
          ? 0
          : const IntConverter().fromJson(json['question_count']),
    );

Map<String, dynamic> _$$PurchasedGoodsModelImplToJson(
        _$PurchasedGoodsModelImpl instance) =>
    <String, dynamic>{
      'id': const StringConverter().toJson(instance.id),
      'name': const StringConverter().toJson(instance.name),
      'material_cover_path':
          const StringConverter().toJson(instance.materialCoverPath),
      'question_count': const IntConverter().toJson(instance.questionCount),
    };

_$DailyPracticeModelImpl _$$DailyPracticeModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DailyPracticeModelImpl(
      id: json['id'] == null
          ? ''
          : const StringConverter().fromJson(json['id']),
      name: json['name'] == null
          ? '每日30题'
          : const StringConverter().fromJson(json['name']),
      totalQuestions: json['total_questions'] == null
          ? 30
          : const IntConverter().fromJson(json['total_questions']),
      doneQuestions: json['done_questions'] == null
          ? 0
          : const IntConverter().fromJson(json['done_questions']),
    );

Map<String, dynamic> _$$DailyPracticeModelImplToJson(
        _$DailyPracticeModelImpl instance) =>
    <String, dynamic>{
      'id': const StringConverter().toJson(instance.id),
      'name': const StringConverter().toJson(instance.name),
      'total_questions': const IntConverter().toJson(instance.totalQuestions),
      'done_questions': const IntConverter().toJson(instance.doneQuestions),
    };

_$SkillMockModelImpl _$$SkillMockModelImplFromJson(Map<String, dynamic> json) =>
    _$SkillMockModelImpl(
      id: json['id'] == null
          ? ''
          : const StringConverter().fromJson(json['id']),
      name: json['name'] == null
          ? '技能模拟'
          : const StringConverter().fromJson(json['name']),
      description: json['description'] == null
          ? ''
          : const StringConverter().fromJson(json['description']),
    );

Map<String, dynamic> _$$SkillMockModelImplToJson(
        _$SkillMockModelImpl instance) =>
    <String, dynamic>{
      'id': const StringConverter().toJson(instance.id),
      'name': const StringConverter().toJson(instance.name),
      'description': const StringConverter().toJson(instance.description),
    };
