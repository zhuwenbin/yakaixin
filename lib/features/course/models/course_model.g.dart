// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourseModelImpl _$$CourseModelImplFromJson(Map<String, dynamic> json) =>
    _$CourseModelImpl(
      goodsId: json['goods_id'] as String?,
      goodsName: json['goods_name'] as String?,
      goodsPid: json['goods_pid'] as String?,
      goodsPidName: json['goods_pid_name'] as String?,
      orderId: json['order_id'] as String?,
      teachingTypeName: json['teaching_type_name'] as String?,
      classInfo: json['class'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$CourseModelImplToJson(_$CourseModelImpl instance) =>
    <String, dynamic>{
      'goods_id': instance.goodsId,
      'goods_name': instance.goodsName,
      'goods_pid': instance.goodsPid,
      'goods_pid_name': instance.goodsPidName,
      'order_id': instance.orderId,
      'teaching_type_name': instance.teachingTypeName,
      'class': instance.classInfo,
    };
