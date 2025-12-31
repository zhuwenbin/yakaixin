// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_info_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExamInfoDetailModelImpl _$$ExamInfoDetailModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ExamInfoDetailModelImpl(
      mockExam:
          MockExamModel.fromJson(json['mock_exam'] as Map<String, dynamic>),
      examRounds: (json['mock_exam_details'] as List<dynamic>)
          .map((e) => ExamRoundModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      signUpCount: json['sign_up_count'] as String? ?? '0',
      mockStatus: json['mock_status'] as String? ?? '',
      mockStatusName: json['mock_status_name'] as String? ?? '',
      mockList: (json['mock_list'] as List<dynamic>?)
              ?.map((e) =>
                  MockExamListItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ExamInfoDetailModelImplToJson(
        _$ExamInfoDetailModelImpl instance) =>
    <String, dynamic>{
      'mock_exam': instance.mockExam,
      'mock_exam_details': instance.examRounds,
      'sign_up_count': instance.signUpCount,
      'mock_status': instance.mockStatus,
      'mock_status_name': instance.mockStatusName,
      'mock_list': instance.mockList,
    };

_$MockExamModelImpl _$$MockExamModelImplFromJson(Map<String, dynamic> json) =>
    _$MockExamModelImpl(
      id: json['id'] as String,
      professionalId: json['professional_id'] as String? ?? '',
      startTime: json['start_time'] as String? ?? '',
      endTime: json['end_time'] as String? ?? '',
      mockName: json['mock_name'] as String? ?? '',
    );

Map<String, dynamic> _$$MockExamModelImplToJson(_$MockExamModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'professional_id': instance.professionalId,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'mock_name': instance.mockName,
    };

_$ExamRoundModelImpl _$$ExamRoundModelImplFromJson(Map<String, dynamic> json) =>
    _$ExamRoundModelImpl(
      id: json['id'] as String,
      mockId: json['mock_id'] as String? ?? '',
      examRoundName: json['exam_round_name'] as String? ?? '',
      startTime: json['start_time'] as String? ?? '',
      endTime: json['end_time'] as String? ?? '',
      status: json['status'] as String? ?? '',
      statusName: json['status_name'] as String? ?? '',
      btnIsEnable: json['btn_is_enable'] as String? ?? '1',
      examPaperId: json['exam_paper_id'] as String? ?? '',
      subjectName: json['subject_name'] as String? ?? '',
    );

Map<String, dynamic> _$$ExamRoundModelImplToJson(
        _$ExamRoundModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mock_id': instance.mockId,
      'exam_round_name': instance.examRoundName,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'status': instance.status,
      'status_name': instance.statusName,
      'btn_is_enable': instance.btnIsEnable,
      'exam_paper_id': instance.examPaperId,
      'subject_name': instance.subjectName,
    };

_$MockExamListItemModelImpl _$$MockExamListItemModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MockExamListItemModelImpl(
      id: json['id'] as String,
      mockName: json['mock_name'] as String? ?? '',
      startTime: json['start_time'] as String? ?? '',
    );

Map<String, dynamic> _$$MockExamListItemModelImplToJson(
        _$MockExamListItemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mock_name': instance.mockName,
      'start_time': instance.startTime,
    };
