import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

/// 支付方式列表请求参数
/// 对应小程序: payModeListNew (courseDetail.vue Line 254-266)
@freezed
class PayModeListRequest with _$PayModeListRequest {
  const factory PayModeListRequest({
    @JsonKey(name: 'account_use') required int accountUse, // 1:收款 2:付款
    @JsonKey(name: 'is_match') required int isMatch,
    @JsonKey(name: 'is_usable') required int isUsable,
    required int page,
    required int size,
    @JsonKey(name: 'account_type') required int accountType, // 1:线上支付 2:线下支付
    @JsonKey(name: 'order_id') required String orderId,
    @JsonKey(name: 'goods_ids') required String goodsIds,
    @JsonKey(name: 'merchant_id') required String merchantId,
    @JsonKey(name: 'brand_id') required String brandId,
    @JsonKey(name: 'collection_scene') required int collectionScene,
    @JsonKey(name: 'collection_terminal') required int collectionTerminal, // 8=小程序
  }) = _PayModeListRequest;

  factory PayModeListRequest.fromJson(Map<String, dynamic> json) =>
      _$PayModeListRequestFromJson(json);
}

/// 支付方式项
/// 对应小程序: response.data.list 项 (Line 268-272)
@freezed
class PayModeItem with _$PayModeItem {
  const factory PayModeItem({
    required String id, // 财务主体ID
    @JsonKey(name: 'pay_method') String? payMethod, // 支付方式: 6=微信支付
    @JsonKey(name: 'wechat_pay_app_id') String? wechatPayAppId,
  }) = _PayModeItem;

  factory PayModeItem.fromJson(Map<String, dynamic> json) =>
      _$PayModeItemFromJson(json);
}

/// 微信支付请求参数
/// 对应小程序: wechatapplet (courseDetail.vue Line 284-290)
@freezed
class WechatPayRequest with _$WechatPayRequest {
  const factory WechatPayRequest({
    @JsonKey(name: 'flow_id') required String flowId,
    @JsonKey(name: 'wechat_app_id') required String wechatAppId,
    @JsonKey(name: 'open_id') required String openId,
    @JsonKey(name: 'finance_body_id') required String financeBodyId,
  }) = _WechatPayRequest;

  factory WechatPayRequest.fromJson(Map<String, dynamic> json) =>
      _$WechatPayRequestFromJson(json);
}

/// 微信支付响应
/// 对应小程序: wechatapplet 返回值 (Line 291-300)
@freezed
class WechatPayResponse with _$WechatPayResponse {
  const factory WechatPayResponse({
    @JsonKey(name: 'time_stamp') required String timeStamp,
    @JsonKey(name: 'nonce_str') required String nonceStr,
    @JsonKey(name: 'sign_type') required String signType,
    @JsonKey(name: 'pay_sign') required String paySign,
    required String package,
  }) = _WechatPayResponse;

  factory WechatPayResponse.fromJson(Map<String, dynamic> json) =>
      _$WechatPayResponseFromJson(json);
}
