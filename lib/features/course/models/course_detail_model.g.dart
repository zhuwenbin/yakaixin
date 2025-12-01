// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourseDetailModelImpl _$$CourseDetailModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CourseDetailModelImpl(
      goodsId: json['goods_id'] as String?,
      goodsName: json['goods_name'] as String?,
      businessType: json['business_type'],
      classInfo: json['class'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$CourseDetailModelImplToJson(
        _$CourseDetailModelImpl instance) =>
    <String, dynamic>{
      'goods_id': instance.goodsId,
      'goods_name': instance.goodsName,
      'business_type': instance.businessType,
      'class': instance.classInfo,
    };

_$CourseClassModelImpl _$$CourseClassModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CourseClassModelImpl(
      classId: json['class_id'] as String?,
      name: json['name'] as String?,
      teachingType: json['teaching_type'] as String?,
      teachingTypeName: json['teaching_type_name'] as String?,
      lessonNum: json['lesson_num'],
      lessonAttendanceNum: json['lesson_attendance_num'],
      address: json['address'] as String?,
      lessons: (json['lesson'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$$CourseClassModelImplToJson(
        _$CourseClassModelImpl instance) =>
    <String, dynamic>{
      'class_id': instance.classId,
      'name': instance.name,
      'teaching_type': instance.teachingType,
      'teaching_type_name': instance.teachingTypeName,
      'lesson_num': instance.lessonNum,
      'lesson_attendance_num': instance.lessonAttendanceNum,
      'address': instance.address,
      'lesson': instance.lessons,
    };

_$RecentlyDataModelImpl _$$RecentlyDataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RecentlyDataModelImpl(
      lessonId: json['lesson_id'] as String?,
      lessonName: json['lesson_name'] as String?,
    );

Map<String, dynamic> _$$RecentlyDataModelImplToJson(
        _$RecentlyDataModelImpl instance) =>
    <String, dynamic>{
      'lesson_id': instance.lessonId,
      'lesson_name': instance.lessonName,
    };
