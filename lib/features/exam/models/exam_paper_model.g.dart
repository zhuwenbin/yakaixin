// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_paper_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExamGoodsInfoImpl _$$ExamGoodsInfoImplFromJson(Map<String, dynamic> json) =>
    _$ExamGoodsInfoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      year: json['year'] as String? ?? '',
      materialIntroPath: json['material_intro_path'] as String? ?? '',
      numText: json['num_text'] as String? ?? '',
      type: (json['type'] as num?)?.toInt() ?? 8,
      professionalId: json['professional_id'] as String? ?? '',
      permissionOrderId: json['permission_order_id'] as String? ?? '',
      permissionStatus: json['permission_status'] as String? ?? '0',
      dataType: json['data_type'] as String? ?? '1',
      tikuGoodsDetails: ExamGoodsDetail.fromJson(
          json['tiku_goods_details'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ExamGoodsInfoImplToJson(_$ExamGoodsInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'year': instance.year,
      'material_intro_path': instance.materialIntroPath,
      'num_text': instance.numText,
      'type': instance.type,
      'professional_id': instance.professionalId,
      'permission_order_id': instance.permissionOrderId,
      'permission_status': instance.permissionStatus,
      'data_type': instance.dataType,
      'tiku_goods_details': instance.tikuGoodsDetails,
    };

_$ExamGoodsDetailImpl _$$ExamGoodsDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$ExamGoodsDetailImpl(
      questionNum: (json['question_num'] as num?)?.toInt() ?? 0,
      paperNum: (json['paper_num'] as num?)?.toInt() ?? 0,
      examRoundNum: (json['exam_round_num'] as num?)?.toInt() ?? 0,
      examTime: json['exam_time'] as String? ?? '',
    );

Map<String, dynamic> _$$ExamGoodsDetailImplToJson(
        _$ExamGoodsDetailImpl instance) =>
    <String, dynamic>{
      'question_num': instance.questionNum,
      'paper_num': instance.paperNum,
      'exam_round_num': instance.examRoundNum,
      'exam_time': instance.examTime,
    };

_$ExamPaperImpl _$$ExamPaperImplFromJson(Map<String, dynamic> json) =>
    _$ExamPaperImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      paperExerciseId: json['paper_exercise_id'] as String? ?? '0',
    );

Map<String, dynamic> _$$ExamPaperImplToJson(_$ExamPaperImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'paper_exercise_id': instance.paperExerciseId,
    };

_$ChapterPaperGroupImpl _$$ChapterPaperGroupImplFromJson(
        Map<String, dynamic> json) =>
    _$ChapterPaperGroupImpl(
      name: json['name'] as String,
      list: (json['list'] as List<dynamic>?)
              ?.map((e) => ExamPaper.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ChapterPaperGroupImplToJson(
        _$ChapterPaperGroupImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'list': instance.list,
    };
