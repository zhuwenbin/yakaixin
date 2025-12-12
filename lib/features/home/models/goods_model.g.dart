// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoodsModelImpl _$$GoodsModelImplFromJson(Map<String, dynamic> json) =>
    _$GoodsModelImpl(
      goodsId: json['id'],
      name: json['name'] as String?,
      materialCoverPath: json['material_cover_path'] as String?,
      materialIntroPath: json['material_intro_path'] as String?,
      type: json['type'],
      typeName: json['type_name'] as String?,
      detailsType: json['details_type'],
      dataType: json['data_type'],
      salePrice: json['sale_price'] as String?,
      originalPrice: json['original_price'],
      permissionStatus: json['permission_status'] as String?,
      isHomepageRecommend: json['is_homepage_recommend'],
      seckillCountdown: json['seckill_countdown'],
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
      validityStartDate: json['validity_start_date'] as String?,
      validityStartDateVal: json['validity_start_date_val'] as String?,
      validityEndDate: json['validity_end_date'] as String?,
      validityEndDateVal: json['validity_end_date_val'] as String?,
      serviceTypeName: json['service_type_name'] as String?,
      newTypeName: json['new_type_name'] as String?,
      studentNum: json['student_num'],
      shopType: json['shop_type'] as String?,
      recitationQuestionModel: json['recitation_question_model'],
      goodsMonthsPriceId: json['goods_months_price_id'] as String?,
      month: json['month'] as String?,
      professionalId: json['professional_id'],
      professionalIdName: json['professional_id_name'] as String?,
      year: json['year'] as String?,
      permissionOperationType: json['permission_operation_type'],
      tikuGoodsDetails: json['tiku_goods_details'] == null
          ? null
          : TikuGoodsDetails.fromJson(
              json['tiku_goods_details'] as Map<String, dynamic>),
      detailPackageGoods: (json['detail_package_goods'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      permissionOrderId: json['permission_order_id'],
    );

Map<String, dynamic> _$$GoodsModelImplToJson(_$GoodsModelImpl instance) =>
    <String, dynamic>{
      'id': instance.goodsId,
      'name': instance.name,
      'material_cover_path': instance.materialCoverPath,
      'material_intro_path': instance.materialIntroPath,
      'type': instance.type,
      'type_name': instance.typeName,
      'details_type': instance.detailsType,
      'data_type': instance.dataType,
      'sale_price': instance.salePrice,
      'original_price': instance.originalPrice,
      'permission_status': instance.permissionStatus,
      'is_homepage_recommend': instance.isHomepageRecommend,
      'seckill_countdown': instance.seckillCountdown,
      'teaching_type': instance.teachingType,
      'teaching_type_name': instance.teachingTypeName,
      'business_type': instance.businessType,
      'is_recommend': instance.isRecommend,
      'teacher_data': instance.teacherData,
      'question_number': instance.questionNumber,
      'total_class_hour': instance.totalClassHour,
      'validity_type': instance.validityType,
      'validity_day': instance.validityDay,
      'validity_start_date': instance.validityStartDate,
      'validity_start_date_val': instance.validityStartDateVal,
      'validity_end_date': instance.validityEndDate,
      'validity_end_date_val': instance.validityEndDateVal,
      'service_type_name': instance.serviceTypeName,
      'new_type_name': instance.newTypeName,
      'student_num': instance.studentNum,
      'shop_type': instance.shopType,
      'recitation_question_model': instance.recitationQuestionModel,
      'goods_months_price_id': instance.goodsMonthsPriceId,
      'month': instance.month,
      'professional_id': instance.professionalId,
      'professional_id_name': instance.professionalIdName,
      'year': instance.year,
      'permission_operation_type': instance.permissionOperationType,
      'tiku_goods_details': instance.tikuGoodsDetails,
      'detail_package_goods': instance.detailPackageGoods,
      'permission_order_id': instance.permissionOrderId,
    };

_$TikuGoodsDetailsImpl _$$TikuGoodsDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$TikuGoodsDetailsImpl(
      questionNum: json['question_num'],
      paperNum: json['paper_num'],
      examRoundNum: json['exam_round_num'],
      examTime: json['exam_time'] as String?,
    );

Map<String, dynamic> _$$TikuGoodsDetailsImplToJson(
        _$TikuGoodsDetailsImpl instance) =>
    <String, dynamic>{
      'question_num': instance.questionNum,
      'paper_num': instance.paperNum,
      'exam_round_num': instance.examRoundNum,
      'exam_time': instance.examTime,
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
      list: (json['list'] as List<dynamic>?)
              ?.map((e) => GoodsModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$GoodsListResponseImplToJson(
        _$GoodsListResponseImpl instance) =>
    <String, dynamic>{
      'list': instance.list,
      'total': instance.total,
    };
