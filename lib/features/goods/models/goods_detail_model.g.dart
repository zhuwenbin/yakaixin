// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoodsDetailModelImpl _$$GoodsDetailModelImplFromJson(
        Map<String, dynamic> json) =>
    _$GoodsDetailModelImpl(
      goodsId: json['id'],
      name: json['name'] as String?,
      type: json['type'],
      materialCoverPath: json['material_cover_path'] as String?,
      materialIntroPath: json['material_intro_path'] as String?,
      longImgPath: json['long_img_path'] as String?,
      permissionStatus: json['permission_status'] as String?,
      professionalId: json['professional_id'] as String?,
      professionalIdName: json['professional_id_name'] as String?,
      year: json['year'] as String?,
      examTitle: json['exam_title'] as String?,
      detailsType: json['details_type'],
      dataType: json['data_type'],
      salePrice: json['sale_price'],
      originalPrice: json['original_price'],
      prices: (json['prices'] as List<dynamic>?)
              ?.map((e) => GoodsPriceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tikuGoodsDetails: json['tiku_goods_details'] == null
          ? null
          : TikuGoodsDetails.fromJson(
              json['tiku_goods_details'] as Map<String, dynamic>),
      teachingSystem: json['teaching_system'] == null
          ? null
          : TeachingSystem.fromJson(
              json['teaching_system'] as Map<String, dynamic>),
      paperStatistics: json['paper_statistics'] == null
          ? null
          : PaperStatistics.fromJson(
              json['paper_statistics'] as Map<String, dynamic>),
      recitationQuestionModel: json['recitation_question_model'],
      permissionOrderId: json['permission_order_id'],
      detailPackageGoods: (json['detail_package_goods'] as List<dynamic>?)
          ?.map((e) => PackageGoodsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      mkgoodsStatistics: json['mkgoods_statistics'] == null
          ? null
          : MockGoodsStatistics.fromJson(
              json['mkgoods_statistics'] as Map<String, dynamic>),
      confirmationPageData: json['confirmation_page_data'] as String?,
    );

Map<String, dynamic> _$$GoodsDetailModelImplToJson(
        _$GoodsDetailModelImpl instance) =>
    <String, dynamic>{
      'id': instance.goodsId,
      'name': instance.name,
      'type': instance.type,
      'material_cover_path': instance.materialCoverPath,
      'material_intro_path': instance.materialIntroPath,
      'long_img_path': instance.longImgPath,
      'permission_status': instance.permissionStatus,
      'professional_id': instance.professionalId,
      'professional_id_name': instance.professionalIdName,
      'year': instance.year,
      'exam_title': instance.examTitle,
      'details_type': instance.detailsType,
      'data_type': instance.dataType,
      'sale_price': instance.salePrice,
      'original_price': instance.originalPrice,
      'prices': instance.prices,
      'tiku_goods_details': instance.tikuGoodsDetails,
      'teaching_system': instance.teachingSystem,
      'paper_statistics': instance.paperStatistics,
      'recitation_question_model': instance.recitationQuestionModel,
      'permission_order_id': instance.permissionOrderId,
      'detail_package_goods': instance.detailPackageGoods,
      'mkgoods_statistics': instance.mkgoodsStatistics,
      'confirmation_page_data': instance.confirmationPageData,
    };

_$GoodsPriceModelImpl _$$GoodsPriceModelImplFromJson(
        Map<String, dynamic> json) =>
    _$GoodsPriceModelImpl(
      goodsMonthsPriceId: json['goods_months_price_id'] as String?,
      month: json['month'],
      salePrice: json['sale_price'] as String?,
      originalPrice: json['original_price'] as String?,
      days: json['days'] as String?,
    );

Map<String, dynamic> _$$GoodsPriceModelImplToJson(
        _$GoodsPriceModelImpl instance) =>
    <String, dynamic>{
      'goods_months_price_id': instance.goodsMonthsPriceId,
      'month': instance.month,
      'sale_price': instance.salePrice,
      'original_price': instance.originalPrice,
      'days': instance.days,
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

_$TeachingSystemImpl _$$TeachingSystemImplFromJson(Map<String, dynamic> json) =>
    _$TeachingSystemImpl(
      systemIdName: json['system_id_name'] as String?,
    );

Map<String, dynamic> _$$TeachingSystemImplToJson(
        _$TeachingSystemImpl instance) =>
    <String, dynamic>{
      'system_id_name': instance.systemIdName,
    };

_$PaperStatisticsImpl _$$PaperStatisticsImplFromJson(
        Map<String, dynamic> json) =>
    _$PaperStatisticsImpl(
      doCount: json['do_count'],
      totalAccuracyRate: json['total_accuracy_rate'],
    );

Map<String, dynamic> _$$PaperStatisticsImplToJson(
        _$PaperStatisticsImpl instance) =>
    <String, dynamic>{
      'do_count': instance.doCount,
      'total_accuracy_rate': instance.totalAccuracyRate,
    };

_$PackageGoodsModelImpl _$$PackageGoodsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PackageGoodsModelImpl(
      id: json['id'],
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$PackageGoodsModelImplToJson(
        _$PackageGoodsModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

_$MockGoodsStatisticsImpl _$$MockGoodsStatisticsImplFromJson(
        Map<String, dynamic> json) =>
    _$MockGoodsStatisticsImpl(
      examDuration: json['exam_duration'],
      fullMarkScore: json['full_mark_score'],
      typeCountMap: json['type_count_map'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$MockGoodsStatisticsImplToJson(
        _$MockGoodsStatisticsImpl instance) =>
    <String, dynamic>{
      'exam_duration': instance.examDuration,
      'full_mark_score': instance.fullMarkScore,
      'type_count_map': instance.typeCountMap,
    };
