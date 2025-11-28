// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateOrderRequestImpl _$$CreateOrderRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateOrderRequestImpl(
      businessScene: (json['business_scene'] as num).toInt(),
      goods: (json['goods'] as List<dynamic>)
          .map((e) => OrderGoodsItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      depositAmount: (json['deposit_amount'] as num).toDouble(),
      payableAmount: (json['payable_amount'] as num).toDouble(),
      realAmount: (json['real_amount'] as num).toDouble(),
      remark: json['remark'] as String,
      studentAdddatasId: json['student_adddatas_id'] as String,
      studentId: json['student_id'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      appId: json['app_id'] as String,
      payMethod: json['pay_method'] as String,
      orderType: (json['order_type'] as num).toInt(),
      discountAmount: (json['discount_amount'] as num).toDouble(),
      couponsIds: (json['coupons_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      employeeId: json['employee_id'] as String,
      deliveryType: (json['delivery_type'] as num).toInt(),
    );

Map<String, dynamic> _$$CreateOrderRequestImplToJson(
        _$CreateOrderRequestImpl instance) =>
    <String, dynamic>{
      'business_scene': instance.businessScene,
      'goods': instance.goods,
      'deposit_amount': instance.depositAmount,
      'payable_amount': instance.payableAmount,
      'real_amount': instance.realAmount,
      'remark': instance.remark,
      'student_adddatas_id': instance.studentAdddatasId,
      'student_id': instance.studentId,
      'total_amount': instance.totalAmount,
      'app_id': instance.appId,
      'pay_method': instance.payMethod,
      'order_type': instance.orderType,
      'discount_amount': instance.discountAmount,
      'coupons_ids': instance.couponsIds,
      'employee_id': instance.employeeId,
      'delivery_type': instance.deliveryType,
    };

_$OrderGoodsItemImpl _$$OrderGoodsItemImplFromJson(Map<String, dynamic> json) =>
    _$OrderGoodsItemImpl(
      goodsId: json['goods_id'] as String,
      goodsMonthsPriceId: json['goods_months_price_id'] as String,
      months: json['months'] as String,
      classCampusId: json['class_campus_id'] as String,
      classCityId: json['class_city_id'] as String,
      goodsNum: json['goods_num'] as String,
    );

Map<String, dynamic> _$$OrderGoodsItemImplToJson(
        _$OrderGoodsItemImpl instance) =>
    <String, dynamic>{
      'goods_id': instance.goodsId,
      'goods_months_price_id': instance.goodsMonthsPriceId,
      'months': instance.months,
      'class_campus_id': instance.classCampusId,
      'class_city_id': instance.classCityId,
      'goods_num': instance.goodsNum,
    };

_$CreateOrderResponseImpl _$$CreateOrderResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateOrderResponseImpl(
      orderId: json['order_id'] as String,
      flowId: json['flow_id'] as String,
    );

Map<String, dynamic> _$$CreateOrderResponseImplToJson(
        _$CreateOrderResponseImpl instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'flow_id': instance.flowId,
    };
