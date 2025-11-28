import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_order_request.freezed.dart';
part 'create_order_request.g.dart';

/// 创建订单请求参数
/// 对应小程序: getOrderV2 (courseDetail.vue Line 417-453)
@freezed
class CreateOrderRequest with _$CreateOrderRequest {
  const factory CreateOrderRequest({
    @JsonKey(name: 'business_scene') required int businessScene, // 业务场景: 1=课程
    required List<OrderGoodsItem> goods, // 商品列表
    @JsonKey(name: 'deposit_amount') required double depositAmount, // 定金
    @JsonKey(name: 'payable_amount') required double payableAmount, // 应付金额
    @JsonKey(name: 'real_amount') required double realAmount, // 实付金额
    required String remark, // 备注
    @JsonKey(name: 'student_adddatas_id') required String studentAdddatasId,
    @JsonKey(name: 'student_id') required String studentId, // 学生ID
    @JsonKey(name: 'total_amount') required double totalAmount, // 总金额
    @JsonKey(name: 'app_id') required String appId, // 微信AppID
    @JsonKey(name: 'pay_method') required String payMethod, // 支付方式
    @JsonKey(name: 'order_type') required int orderType, // 订单类型: 10=课程
    @JsonKey(name: 'discount_amount') required double discountAmount, // 优惠金额
    @JsonKey(name: 'coupons_ids') required List<String> couponsIds, // 优惠券IDs
    @JsonKey(name: 'employee_id') required String employeeId, // 员工ID
    @JsonKey(name: 'delivery_type') required int deliveryType, // 配送方式: 1=总部邮寄
  }) = _CreateOrderRequest;

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestFromJson(json);
}

/// 订单商品项
/// 对应小程序: goods 数组项 (Line 424-433)
@freezed
class OrderGoodsItem with _$OrderGoodsItem {
  const factory OrderGoodsItem({
    @JsonKey(name: 'goods_id') required String goodsId,
    @JsonKey(name: 'goods_months_price_id') required String goodsMonthsPriceId,
    required String months,
    @JsonKey(name: 'class_campus_id') required String classCampusId,
    @JsonKey(name: 'class_city_id') required String classCityId,
    @JsonKey(name: 'goods_num') required String goodsNum,
  }) = _OrderGoodsItem;

  factory OrderGoodsItem.fromJson(Map<String, dynamic> json) =>
      _$OrderGoodsItemFromJson(json);
}

/// 创建订单响应
/// 对应小程序: getOrderV2 返回值 (Line 456)
@freezed
class CreateOrderResponse with _$CreateOrderResponse {
  const factory CreateOrderResponse({
    @JsonKey(name: 'order_id') required String orderId,
    @JsonKey(name: 'flow_id') required String flowId,
  }) = _CreateOrderResponse;

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderResponseFromJson(json);
}
