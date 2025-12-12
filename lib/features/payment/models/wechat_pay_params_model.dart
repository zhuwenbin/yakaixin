import 'package:freezed_annotation/freezed_annotation.dart';

part 'wechat_pay_params_model.freezed.dart';
part 'wechat_pay_params_model.g.dart';

/// 微信支付参数Model
/// 用于APP端微信支付
@freezed
class WechatPayParamsModel with _$WechatPayParamsModel {
  const factory WechatPayParamsModel({
    /// 微信应用ID
    @JsonKey(name: 'app_id') required String appId,
    
    /// 商户号
    @JsonKey(name: 'partner_id') required String partnerId,
    
    /// 预支付交易会话ID
    @JsonKey(name: 'prepay_id') required String prepayId,
    
    /// 扩展字段
    @JsonKey(name: 'package') @Default('Sign=WXPay') String package,
    
    /// 随机字符串
    @JsonKey(name: 'nonce_str') required String nonceStr,
    
    /// 时间戳
    @JsonKey(name: 'time_stamp') required String timeStamp,
    
    /// 签名
    required String sign,
  }) = _WechatPayParamsModel;

  factory WechatPayParamsModel.fromJson(Map<String, dynamic> json) =>
      _$WechatPayParamsModelFromJson(json);
}
