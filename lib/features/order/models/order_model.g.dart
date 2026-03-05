// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
      id: json['id'],
      orderId: json['order_id'],
      orderNo: json['order_no'] as String,
      goodsId: json['goods_id'],
      goodsName: json['goods_name'] as String,
      goodsType: json['goods_type'],
      status: json['status'] as String,
      statusName: json['status_name'] as String,
      payableAmount: json['payable_amount'] as String,
      countdown: json['countdown'],
      flowId: json['flow_id'],
      financeBodyId: json['finance_body_id'],
      professionalIdName: json['professional_id_name'] as String?,
      months: json['months'],
      tikuGoodsDetails: json['tiku_goods_details'] as Map<String, dynamic>?,
      teachingSystem: json['teaching_system'] as Map<String, dynamic>?,
      numText: json['numText'] as String?,
      monthText: json['monthText'] as String?,
      tips: json['tips'] as String?,
    );

Map<String, dynamic> _$$OrderModelImplToJson(_$OrderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'order_no': instance.orderNo,
      'goods_id': instance.goodsId,
      'goods_name': instance.goodsName,
      'goods_type': instance.goodsType,
      'status': instance.status,
      'status_name': instance.statusName,
      'payable_amount': instance.payableAmount,
      'countdown': instance.countdown,
      'flow_id': instance.flowId,
      'finance_body_id': instance.financeBodyId,
      'professional_id_name': instance.professionalIdName,
      'months': instance.months,
      'tiku_goods_details': instance.tikuGoodsDetails,
      'teaching_system': instance.teachingSystem,
      'numText': instance.numText,
      'monthText': instance.monthText,
      'tips': instance.tips,
    };

_$OrderListResponseImpl _$$OrderListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$OrderListResponseImpl(
      list: (json['list'] as List<dynamic>)
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$OrderListResponseImplToJson(
        _$OrderListResponseImpl instance) =>
    <String, dynamic>{
      'list': instance.list,
      'total': instance.total,
    };
