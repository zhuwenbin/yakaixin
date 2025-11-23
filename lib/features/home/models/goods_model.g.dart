// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoodsModelImpl _$$GoodsModelImplFromJson(Map<String, dynamic> json) =>
    _$GoodsModelImpl(
      goodsId: json['id'],
      goodsName: json['name'] as String?,
      coverImg: json['material_cover_path'] as String?,
      type: json['type'],
      typeName: json['type_name'] as String?,
      detailsType: json['details_type'] as String?,
      price: json['sale_price'],
      originalPrice: json['original_price'],
      permissionStatus: json['permission_status'] as String?,
      isHomepageRecommend: json['is_homepage_recommend'],
      teachingType: json['teaching_type'],
      teachingTypeName: json['teaching_type_name'] as String?,
      businessType: json['business_type'],
      isRecommend: json['is_recommend'],
      teacherData: (json['teacher_data'] as List<dynamic>?)
          ?.map((e) => TeacherModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      questionNumber: json['question_number'] as String?,
      totalClassHour: json['total_class_hour'] as String?,
      validityType: json['validity_type'] as String?,
      validityDay: json['validity_day'] as String?,
    );

Map<String, dynamic> _$$GoodsModelImplToJson(_$GoodsModelImpl instance) =>
    <String, dynamic>{
      'id': instance.goodsId,
      'name': instance.goodsName,
      'material_cover_path': instance.coverImg,
      'type': instance.type,
      'type_name': instance.typeName,
      'details_type': instance.detailsType,
      'sale_price': instance.price,
      'original_price': instance.originalPrice,
      'permission_status': instance.permissionStatus,
      'is_homepage_recommend': instance.isHomepageRecommend,
      'teaching_type': instance.teachingType,
      'teaching_type_name': instance.teachingTypeName,
      'business_type': instance.businessType,
      'is_recommend': instance.isRecommend,
      'teacher_data': instance.teacherData,
      'question_number': instance.questionNumber,
      'total_class_hour': instance.totalClassHour,
      'validity_type': instance.validityType,
      'validity_day': instance.validityDay,
    };

_$TeacherModelImpl _$$TeacherModelImplFromJson(Map<String, dynamic> json) =>
    _$TeacherModelImpl(
      teacherId: json['teacher_id'] as String?,
      teacherName: json['teacher_name'] as String?,
      avatar: json['avatar'] as String?,
      introduction: json['introduction'] as String?,
    );

Map<String, dynamic> _$$TeacherModelImplToJson(_$TeacherModelImpl instance) =>
    <String, dynamic>{
      'teacher_id': instance.teacherId,
      'teacher_name': instance.teacherName,
      'avatar': instance.avatar,
      'introduction': instance.introduction,
    };

_$GoodsListResponseImpl _$$GoodsListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GoodsListResponseImpl(
      list: (json['list'] as List<dynamic>)
          .map((e) => GoodsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$GoodsListResponseImplToJson(
        _$GoodsListResponseImpl instance) =>
    <String, dynamic>{
      'list': instance.list,
      'total': instance.total,
    };
