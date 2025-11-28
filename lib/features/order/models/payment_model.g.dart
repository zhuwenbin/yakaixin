// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PayModeListRequestImpl _$$PayModeListRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$PayModeListRequestImpl(
      accountUse: (json['account_use'] as num).toInt(),
      isMatch: (json['is_match'] as num).toInt(),
      isUsable: (json['is_usable'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      accountType: (json['account_type'] as num).toInt(),
      orderId: json['order_id'] as String,
      goodsIds: json['goods_ids'] as String,
      merchantId: json['merchant_id'] as String,
      brandId: json['brand_id'] as String,
      collectionScene: (json['collection_scene'] as num).toInt(),
      collectionTerminal: (json['collection_terminal'] as num).toInt(),
    );

Map<String, dynamic> _$$PayModeListRequestImplToJson(
        _$PayModeListRequestImpl instance) =>
    <String, dynamic>{
      'account_use': instance.accountUse,
      'is_match': instance.isMatch,
      'is_usable': instance.isUsable,
      'page': instance.page,
      'size': instance.size,
      'account_type': instance.accountType,
      'order_id': instance.orderId,
      'goods_ids': instance.goodsIds,
      'merchant_id': instance.merchantId,
      'brand_id': instance.brandId,
      'collection_scene': instance.collectionScene,
      'collection_terminal': instance.collectionTerminal,
    };

_$PayModeItemImpl _$$PayModeItemImplFromJson(Map<String, dynamic> json) =>
    _$PayModeItemImpl(
      id: json['id'] as String,
      payMethod: json['pay_method'] as String?,
      wechatPayAppId: json['wechat_pay_app_id'] as String?,
    );

Map<String, dynamic> _$$PayModeItemImplToJson(_$PayModeItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pay_method': instance.payMethod,
      'wechat_pay_app_id': instance.wechatPayAppId,
    };

_$WechatPayRequestImpl _$$WechatPayRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$WechatPayRequestImpl(
      flowId: json['flow_id'] as String,
      wechatAppId: json['wechat_app_id'] as String,
      openId: json['open_id'] as String,
      financeBodyId: json['finance_body_id'] as String,
    );

Map<String, dynamic> _$$WechatPayRequestImplToJson(
        _$WechatPayRequestImpl instance) =>
    <String, dynamic>{
      'flow_id': instance.flowId,
      'wechat_app_id': instance.wechatAppId,
      'open_id': instance.openId,
      'finance_body_id': instance.financeBodyId,
    };

_$WechatPayResponseImpl _$$WechatPayResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$WechatPayResponseImpl(
      timeStamp: json['time_stamp'] as String,
      nonceStr: json['nonce_str'] as String,
      signType: json['sign_type'] as String,
      paySign: json['pay_sign'] as String,
      package: json['package'] as String,
    );

Map<String, dynamic> _$$WechatPayResponseImplToJson(
        _$WechatPayResponseImpl instance) =>
    <String, dynamic>{
      'time_stamp': instance.timeStamp,
      'nonce_str': instance.nonceStr,
      'sign_type': instance.signType,
      'pay_sign': instance.paySign,
      'package': instance.package,
    };
