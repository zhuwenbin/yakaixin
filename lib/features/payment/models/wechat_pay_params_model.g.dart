// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wechat_pay_params_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WechatPayParamsModelImpl _$$WechatPayParamsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$WechatPayParamsModelImpl(
      appId: json['app_id'] as String,
      partnerId: json['partner_id'] as String,
      prepayId: json['prepay_id'] as String,
      package: json['package'] as String? ?? 'Sign=WXPay',
      nonceStr: json['nonce_str'] as String,
      timeStamp: json['time_stamp'] as String,
      sign: json['sign'] as String,
    );

Map<String, dynamic> _$$WechatPayParamsModelImplToJson(
        _$WechatPayParamsModelImpl instance) =>
    <String, dynamic>{
      'app_id': instance.appId,
      'partner_id': instance.partnerId,
      'prepay_id': instance.prepayId,
      'package': instance.package,
      'nonce_str': instance.nonceStr,
      'time_stamp': instance.timeStamp,
      'sign': instance.sign,
    };
