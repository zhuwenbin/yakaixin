import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

/// 订单模型
/// 对应小程序: orderList接口返回的订单数据
@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'order_id') String? orderId,
    @JsonKey(name: 'order_no') required String orderNo,
    @JsonKey(name: 'goods_id') String? goodsId,
    @JsonKey(name: 'goods_name') required String goodsName,
    @JsonKey(name: 'goods_type') String? goodsType,
    @JsonKey(name: 'status') required String status, // 1:待支付 2:已完成 3:待补缴 4:已取消 5:退费中 6:已退费
    @JsonKey(name: 'status_name') required String statusName,
    @JsonKey(name: 'payable_amount') required String payableAmount,
    @JsonKey(name: 'countdown') int? countdown, // 倒计时秒数
    @JsonKey(name: 'flow_id') String? flowId,
    @JsonKey(name: 'professional_id_name') String? professionalIdName,
    @JsonKey(name: 'months') int? months,
    @JsonKey(name: 'tiku_goods_details') Map<String, dynamic>? tikuGoodsDetails,
    @JsonKey(name: 'teaching_system') Map<String, dynamic>? teachingSystem,
    // 前端计算字段
    String? numText,
    String? monthText,
    String? tips,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}

/// 订单列表响应
@freezed
class OrderListResponse with _$OrderListResponse {
  const factory OrderListResponse({
    required List<OrderModel> list,
    @Default(0) int total,
  }) = _OrderListResponse;

  factory OrderListResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderListResponseFromJson(json);
}
