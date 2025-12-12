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

_$ChapterExerciseModelImpl _$$ChapterExerciseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ChapterExerciseModelImpl(
      id: json['id'] == null
          ? ''
          : const StringConverter().fromJson(json['id']),
      name: json['name'] == null
          ? '章节练习'
          : const StringConverter().fromJson(json['name']),
      permissionStatus: json['permission_status'] == null
          ? '2'
          : const StringConverter().fromJson(json['permission_status']),
      questionNumber: json['question_num'] == null
          ? 0
          : const IntConverter().fromJson(json['question_num']),
      doQuestionNum: json['do_question_num'] == null
          ? 0
          : const IntConverter().fromJson(json['do_question_num']),
      year: json['year'] == null
          ? ''
          : const StringConverter().fromJson(json['year']),
      professionalId: json['professional_id'] == null
          ? ''
          : const StringConverter().fromJson(json['professional_id']),
    );

Map<String, dynamic> _$$ChapterExerciseModelImplToJson(
        _$ChapterExerciseModelImpl instance) =>
    <String, dynamic>{
      'id': const StringConverter().toJson(instance.id),
      'name': const StringConverter().toJson(instance.name),
      'permission_status':
          const StringConverter().toJson(instance.permissionStatus),
      'question_num': const IntConverter().toJson(instance.questionNumber),
      'do_question_num': const IntConverter().toJson(instance.doQuestionNum),
      'year': const StringConverter().toJson(instance.year),
      'professional_id':
          const StringConverter().toJson(instance.professionalId),
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
      type: json['type'] == null
          ? ''
          : const StringConverter().fromJson(json['type']),
      detailsType: json['details_type'] == null
          ? ''
          : const StringConverter().fromJson(json['details_type']),
      dataType: json['data_type'] == null
          ? ''
          : const StringConverter().fromJson(json['data_type']),
      permissionStatus: json['permission_status'] == null
          ? '1'
          : const StringConverter().fromJson(json['permission_status']),
      recitationQuestionModel: json['recitation_question_model'] == null
          ? ''
          : const StringConverter().fromJson(json['recitation_question_model']),
      professionalId: json['professional_id'] == null
          ? ''
          : const StringConverter().fromJson(json['professional_id']),
      validityStartDate:
          const StringConverter().fromJson(json['validity_start_date']),
      validityEndDate:
          const StringConverter().fromJson(json['validity_end_date']),
      createdAt: const StringConverter().fromJson(json['created_at']),
      numText: const StringConverter().fromJson(json['num_text']),
      tikuGoodsDetails: json['tiku_goods_details'] == null
          ? null
          : TikuGoodsDetailsModel.fromJson(
              json['tiku_goods_details'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PurchasedGoodsModelImplToJson(
        _$PurchasedGoodsModelImpl instance) =>
    <String, dynamic>{
      'id': const StringConverter().toJson(instance.id),
      'name': const StringConverter().toJson(instance.name),
      'material_cover_path':
          const StringConverter().toJson(instance.materialCoverPath),
      'question_count': const IntConverter().toJson(instance.questionCount),
      'type': const StringConverter().toJson(instance.type),
      'details_type': const StringConverter().toJson(instance.detailsType),
      'data_type': const StringConverter().toJson(instance.dataType),
      'permission_status':
          const StringConverter().toJson(instance.permissionStatus),
      'recitation_question_model':
          const StringConverter().toJson(instance.recitationQuestionModel),
      'professional_id':
          const StringConverter().toJson(instance.professionalId),
      'validity_start_date': _$JsonConverterToJson<dynamic, String>(
          instance.validityStartDate, const StringConverter().toJson),
      'validity_end_date': _$JsonConverterToJson<dynamic, String>(
          instance.validityEndDate, const StringConverter().toJson),
      'created_at': _$JsonConverterToJson<dynamic, String>(
          instance.createdAt, const StringConverter().toJson),
      'num_text': _$JsonConverterToJson<dynamic, String>(
          instance.numText, const StringConverter().toJson),
      'tiku_goods_details': instance.tikuGoodsDetails,
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

_$TikuGoodsDetailsModelImpl _$$TikuGoodsDetailsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TikuGoodsDetailsModelImpl(
      questionNum: json['question_num'] == null
          ? 0
          : const IntConverter().fromJson(json['question_num']),
      paperNum: json['paper_num'] == null
          ? 0
          : const IntConverter().fromJson(json['paper_num']),
      examRoundNum: json['exam_round_num'] == null
          ? 0
          : const IntConverter().fromJson(json['exam_round_num']),
      examTime: json['exam_time'] == null
          ? ''
          : const StringConverter().fromJson(json['exam_time']),
    );

Map<String, dynamic> _$$TikuGoodsDetailsModelImplToJson(
        _$TikuGoodsDetailsModelImpl instance) =>
    <String, dynamic>{
      'question_num': const IntConverter().toJson(instance.questionNum),
      'paper_num': const IntConverter().toJson(instance.paperNum),
      'exam_round_num': const IntConverter().toJson(instance.examRoundNum),
      'exam_time': const StringConverter().toJson(instance.examTime),
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
      permissionStatus: json['permission_status'] == null
          ? '2'
          : const StringConverter().fromJson(json['permission_status']),
      questionNumber: json['question_num'] == null
          ? 30
          : const IntConverter().fromJson(json['question_num']),
      totalQuestions: json['total_questions'] == null
          ? 30
          : const IntConverter().fromJson(json['total_questions']),
      doneQuestions: json['done_questions'] == null
          ? 0
          : const IntConverter().fromJson(json['done_questions']),
      year: json['year'] == null
          ? ''
          : const StringConverter().fromJson(json['year']),
      professionalId: json['professional_id'] == null
          ? ''
          : const StringConverter().fromJson(json['professional_id']),
    );

Map<String, dynamic> _$$DailyPracticeModelImplToJson(
        _$DailyPracticeModelImpl instance) =>
    <String, dynamic>{
      'id': const StringConverter().toJson(instance.id),
      'name': const StringConverter().toJson(instance.name),
      'permission_status':
          const StringConverter().toJson(instance.permissionStatus),
      'question_num': const IntConverter().toJson(instance.questionNumber),
      'total_questions': const IntConverter().toJson(instance.totalQuestions),
      'done_questions': const IntConverter().toJson(instance.doneQuestions),
      'year': const StringConverter().toJson(instance.year),
      'professional_id':
          const StringConverter().toJson(instance.professionalId),
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
