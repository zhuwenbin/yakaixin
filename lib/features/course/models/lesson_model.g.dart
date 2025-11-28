// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LessonModelImpl _$$LessonModelImplFromJson(Map<String, dynamic> json) =>
    _$LessonModelImpl(
      lessonId: json['lesson_id'] as String?,
      lessonNum: json['lesson_num'] as String?,
      lessonName: json['lesson_name'] as String?,
      startTime: json['start_time'] as String?,
      teachingTypeName: json['teaching_type_name'] as String?,
      resourceDocument: json['resource_document'] as List<dynamic>? ?? const [],
      evaluationType: (json['evaluation_type'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$LessonModelImplToJson(_$LessonModelImpl instance) =>
    <String, dynamic>{
      'lesson_id': instance.lessonId,
      'lesson_num': instance.lessonNum,
      'lesson_name': instance.lessonName,
      'start_time': instance.startTime,
      'teaching_type_name': instance.teachingTypeName,
      'resource_document': instance.resourceDocument,
      'evaluation_type': instance.evaluationType,
    };

_$LessonsDataImpl _$$LessonsDataImplFromJson(Map<String, dynamic> json) =>
    _$LessonsDataImpl(
      lessonNum: json['lesson_num'] as String?,
      lessonAttendanceNum: json['lesson_attendance_num'] as String?,
      lessonAttendance: (json['lesson_attendance'] as List<dynamic>?)
              ?.map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$LessonsDataImplToJson(_$LessonsDataImpl instance) =>
    <String, dynamic>{
      'lesson_num': instance.lessonNum,
      'lesson_attendance_num': instance.lessonAttendanceNum,
      'lesson_attendance': instance.lessonAttendance,
    };
