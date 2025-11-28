// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_order_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateOrderRequest _$CreateOrderRequestFromJson(Map<String, dynamic> json) {
  return _CreateOrderRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateOrderRequest {
  @JsonKey(name: 'business_scene')
  int get businessScene => throw _privateConstructorUsedError; // 业务场景: 1=课程
  List<OrderGoodsItem> get goods => throw _privateConstructorUsedError; // 商品列表
  @JsonKey(name: 'deposit_amount')
  double get depositAmount => throw _privateConstructorUsedError; // 定金
  @JsonKey(name: 'payable_amount')
  double get payableAmount => throw _privateConstructorUsedError; // 应付金额
  @JsonKey(name: 'real_amount')
  double get realAmount => throw _privateConstructorUsedError; // 实付金额
  String get remark => throw _privateConstructorUsedError; // 备注
  @JsonKey(name: 'student_adddatas_id')
  String get studentAdddatasId => throw _privateConstructorUsedError;
  @JsonKey(name: 'student_id')
  String get studentId => throw _privateConstructorUsedError; // 学生ID
  @JsonKey(name: 'total_amount')
  double get totalAmount => throw _privateConstructorUsedError; // 总金额
  @JsonKey(name: 'app_id')
  String get appId => throw _privateConstructorUsedError; // 微信AppID
  @JsonKey(name: 'pay_method')
  String get payMethod => throw _privateConstructorUsedError; // 支付方式
  @JsonKey(name: 'order_type')
  int get orderType => throw _privateConstructorUsedError; // 订单类型: 10=课程
  @JsonKey(name: 'discount_amount')
  double get discountAmount => throw _privateConstructorUsedError; // 优惠金额
  @JsonKey(name: 'coupons_ids')
  List<String> get couponsIds => throw _privateConstructorUsedError; // 优惠券IDs
  @JsonKey(name: 'employee_id')
  String get employeeId => throw _privateConstructorUsedError; // 员工ID
  @JsonKey(name: 'delivery_type')
  int get deliveryType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateOrderRequestCopyWith<CreateOrderRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateOrderRequestCopyWith<$Res> {
  factory $CreateOrderRequestCopyWith(
          CreateOrderRequest value, $Res Function(CreateOrderRequest) then) =
      _$CreateOrderRequestCopyWithImpl<$Res, CreateOrderRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'business_scene') int businessScene,
      List<OrderGoodsItem> goods,
      @JsonKey(name: 'deposit_amount') double depositAmount,
      @JsonKey(name: 'payable_amount') double payableAmount,
      @JsonKey(name: 'real_amount') double realAmount,
      String remark,
      @JsonKey(name: 'student_adddatas_id') String studentAdddatasId,
      @JsonKey(name: 'student_id') String studentId,
      @JsonKey(name: 'total_amount') double totalAmount,
      @JsonKey(name: 'app_id') String appId,
      @JsonKey(name: 'pay_method') String payMethod,
      @JsonKey(name: 'order_type') int orderType,
      @JsonKey(name: 'discount_amount') double discountAmount,
      @JsonKey(name: 'coupons_ids') List<String> couponsIds,
      @JsonKey(name: 'employee_id') String employeeId,
      @JsonKey(name: 'delivery_type') int deliveryType});
}

/// @nodoc
class _$CreateOrderRequestCopyWithImpl<$Res, $Val extends CreateOrderRequest>
    implements $CreateOrderRequestCopyWith<$Res> {
  _$CreateOrderRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? businessScene = null,
    Object? goods = null,
    Object? depositAmount = null,
    Object? payableAmount = null,
    Object? realAmount = null,
    Object? remark = null,
    Object? studentAdddatasId = null,
    Object? studentId = null,
    Object? totalAmount = null,
    Object? appId = null,
    Object? payMethod = null,
    Object? orderType = null,
    Object? discountAmount = null,
    Object? couponsIds = null,
    Object? employeeId = null,
    Object? deliveryType = null,
  }) {
    return _then(_value.copyWith(
      businessScene: null == businessScene
          ? _value.businessScene
          : businessScene // ignore: cast_nullable_to_non_nullable
              as int,
      goods: null == goods
          ? _value.goods
          : goods // ignore: cast_nullable_to_non_nullable
              as List<OrderGoodsItem>,
      depositAmount: null == depositAmount
          ? _value.depositAmount
          : depositAmount // ignore: cast_nullable_to_non_nullable
              as double,
      payableAmount: null == payableAmount
          ? _value.payableAmount
          : payableAmount // ignore: cast_nullable_to_non_nullable
              as double,
      realAmount: null == realAmount
          ? _value.realAmount
          : realAmount // ignore: cast_nullable_to_non_nullable
              as double,
      remark: null == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String,
      studentAdddatasId: null == studentAdddatasId
          ? _value.studentAdddatasId
          : studentAdddatasId // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      appId: null == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String,
      payMethod: null == payMethod
          ? _value.payMethod
          : payMethod // ignore: cast_nullable_to_non_nullable
              as String,
      orderType: null == orderType
          ? _value.orderType
          : orderType // ignore: cast_nullable_to_non_nullable
              as int,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
      couponsIds: null == couponsIds
          ? _value.couponsIds
          : couponsIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryType: null == deliveryType
          ? _value.deliveryType
          : deliveryType // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateOrderRequestImplCopyWith<$Res>
    implements $CreateOrderRequestCopyWith<$Res> {
  factory _$$CreateOrderRequestImplCopyWith(_$CreateOrderRequestImpl value,
          $Res Function(_$CreateOrderRequestImpl) then) =
      __$$CreateOrderRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'business_scene') int businessScene,
      List<OrderGoodsItem> goods,
      @JsonKey(name: 'deposit_amount') double depositAmount,
      @JsonKey(name: 'payable_amount') double payableAmount,
      @JsonKey(name: 'real_amount') double realAmount,
      String remark,
      @JsonKey(name: 'student_adddatas_id') String studentAdddatasId,
      @JsonKey(name: 'student_id') String studentId,
      @JsonKey(name: 'total_amount') double totalAmount,
      @JsonKey(name: 'app_id') String appId,
      @JsonKey(name: 'pay_method') String payMethod,
      @JsonKey(name: 'order_type') int orderType,
      @JsonKey(name: 'discount_amount') double discountAmount,
      @JsonKey(name: 'coupons_ids') List<String> couponsIds,
      @JsonKey(name: 'employee_id') String employeeId,
      @JsonKey(name: 'delivery_type') int deliveryType});
}

/// @nodoc
class __$$CreateOrderRequestImplCopyWithImpl<$Res>
    extends _$CreateOrderRequestCopyWithImpl<$Res, _$CreateOrderRequestImpl>
    implements _$$CreateOrderRequestImplCopyWith<$Res> {
  __$$CreateOrderRequestImplCopyWithImpl(_$CreateOrderRequestImpl _value,
      $Res Function(_$CreateOrderRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? businessScene = null,
    Object? goods = null,
    Object? depositAmount = null,
    Object? payableAmount = null,
    Object? realAmount = null,
    Object? remark = null,
    Object? studentAdddatasId = null,
    Object? studentId = null,
    Object? totalAmount = null,
    Object? appId = null,
    Object? payMethod = null,
    Object? orderType = null,
    Object? discountAmount = null,
    Object? couponsIds = null,
    Object? employeeId = null,
    Object? deliveryType = null,
  }) {
    return _then(_$CreateOrderRequestImpl(
      businessScene: null == businessScene
          ? _value.businessScene
          : businessScene // ignore: cast_nullable_to_non_nullable
              as int,
      goods: null == goods
          ? _value._goods
          : goods // ignore: cast_nullable_to_non_nullable
              as List<OrderGoodsItem>,
      depositAmount: null == depositAmount
          ? _value.depositAmount
          : depositAmount // ignore: cast_nullable_to_non_nullable
              as double,
      payableAmount: null == payableAmount
          ? _value.payableAmount
          : payableAmount // ignore: cast_nullable_to_non_nullable
              as double,
      realAmount: null == realAmount
          ? _value.realAmount
          : realAmount // ignore: cast_nullable_to_non_nullable
              as double,
      remark: null == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String,
      studentAdddatasId: null == studentAdddatasId
          ? _value.studentAdddatasId
          : studentAdddatasId // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      appId: null == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String,
      payMethod: null == payMethod
          ? _value.payMethod
          : payMethod // ignore: cast_nullable_to_non_nullable
              as String,
      orderType: null == orderType
          ? _value.orderType
          : orderType // ignore: cast_nullable_to_non_nullable
              as int,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
      couponsIds: null == couponsIds
          ? _value._couponsIds
          : couponsIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryType: null == deliveryType
          ? _value.deliveryType
          : deliveryType // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateOrderRequestImpl implements _CreateOrderRequest {
  const _$CreateOrderRequestImpl(
      {@JsonKey(name: 'business_scene') required this.businessScene,
      required final List<OrderGoodsItem> goods,
      @JsonKey(name: 'deposit_amount') required this.depositAmount,
      @JsonKey(name: 'payable_amount') required this.payableAmount,
      @JsonKey(name: 'real_amount') required this.realAmount,
      required this.remark,
      @JsonKey(name: 'student_adddatas_id') required this.studentAdddatasId,
      @JsonKey(name: 'student_id') required this.studentId,
      @JsonKey(name: 'total_amount') required this.totalAmount,
      @JsonKey(name: 'app_id') required this.appId,
      @JsonKey(name: 'pay_method') required this.payMethod,
      @JsonKey(name: 'order_type') required this.orderType,
      @JsonKey(name: 'discount_amount') required this.discountAmount,
      @JsonKey(name: 'coupons_ids') required final List<String> couponsIds,
      @JsonKey(name: 'employee_id') required this.employeeId,
      @JsonKey(name: 'delivery_type') required this.deliveryType})
      : _goods = goods,
        _couponsIds = couponsIds;

  factory _$CreateOrderRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateOrderRequestImplFromJson(json);

  @override
  @JsonKey(name: 'business_scene')
  final int businessScene;
// 业务场景: 1=课程
  final List<OrderGoodsItem> _goods;
// 业务场景: 1=课程
  @override
  List<OrderGoodsItem> get goods {
    if (_goods is EqualUnmodifiableListView) return _goods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_goods);
  }

// 商品列表
  @override
  @JsonKey(name: 'deposit_amount')
  final double depositAmount;
// 定金
  @override
  @JsonKey(name: 'payable_amount')
  final double payableAmount;
// 应付金额
  @override
  @JsonKey(name: 'real_amount')
  final double realAmount;
// 实付金额
  @override
  final String remark;
// 备注
  @override
  @JsonKey(name: 'student_adddatas_id')
  final String studentAdddatasId;
  @override
  @JsonKey(name: 'student_id')
  final String studentId;
// 学生ID
  @override
  @JsonKey(name: 'total_amount')
  final double totalAmount;
// 总金额
  @override
  @JsonKey(name: 'app_id')
  final String appId;
// 微信AppID
  @override
  @JsonKey(name: 'pay_method')
  final String payMethod;
// 支付方式
  @override
  @JsonKey(name: 'order_type')
  final int orderType;
// 订单类型: 10=课程
  @override
  @JsonKey(name: 'discount_amount')
  final double discountAmount;
// 优惠金额
  final List<String> _couponsIds;
// 优惠金额
  @override
  @JsonKey(name: 'coupons_ids')
  List<String> get couponsIds {
    if (_couponsIds is EqualUnmodifiableListView) return _couponsIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_couponsIds);
  }

// 优惠券IDs
  @override
  @JsonKey(name: 'employee_id')
  final String employeeId;
// 员工ID
  @override
  @JsonKey(name: 'delivery_type')
  final int deliveryType;

  @override
  String toString() {
    return 'CreateOrderRequest(businessScene: $businessScene, goods: $goods, depositAmount: $depositAmount, payableAmount: $payableAmount, realAmount: $realAmount, remark: $remark, studentAdddatasId: $studentAdddatasId, studentId: $studentId, totalAmount: $totalAmount, appId: $appId, payMethod: $payMethod, orderType: $orderType, discountAmount: $discountAmount, couponsIds: $couponsIds, employeeId: $employeeId, deliveryType: $deliveryType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateOrderRequestImpl &&
            (identical(other.businessScene, businessScene) ||
                other.businessScene == businessScene) &&
            const DeepCollectionEquality().equals(other._goods, _goods) &&
            (identical(other.depositAmount, depositAmount) ||
                other.depositAmount == depositAmount) &&
            (identical(other.payableAmount, payableAmount) ||
                other.payableAmount == payableAmount) &&
            (identical(other.realAmount, realAmount) ||
                other.realAmount == realAmount) &&
            (identical(other.remark, remark) || other.remark == remark) &&
            (identical(other.studentAdddatasId, studentAdddatasId) ||
                other.studentAdddatasId == studentAdddatasId) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.appId, appId) || other.appId == appId) &&
            (identical(other.payMethod, payMethod) ||
                other.payMethod == payMethod) &&
            (identical(other.orderType, orderType) ||
                other.orderType == orderType) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            const DeepCollectionEquality()
                .equals(other._couponsIds, _couponsIds) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.deliveryType, deliveryType) ||
                other.deliveryType == deliveryType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      businessScene,
      const DeepCollectionEquality().hash(_goods),
      depositAmount,
      payableAmount,
      realAmount,
      remark,
      studentAdddatasId,
      studentId,
      totalAmount,
      appId,
      payMethod,
      orderType,
      discountAmount,
      const DeepCollectionEquality().hash(_couponsIds),
      employeeId,
      deliveryType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateOrderRequestImplCopyWith<_$CreateOrderRequestImpl> get copyWith =>
      __$$CreateOrderRequestImplCopyWithImpl<_$CreateOrderRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateOrderRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateOrderRequest implements CreateOrderRequest {
  const factory _CreateOrderRequest(
      {@JsonKey(name: 'business_scene') required final int businessScene,
      required final List<OrderGoodsItem> goods,
      @JsonKey(name: 'deposit_amount') required final double depositAmount,
      @JsonKey(name: 'payable_amount') required final double payableAmount,
      @JsonKey(name: 'real_amount') required final double realAmount,
      required final String remark,
      @JsonKey(name: 'student_adddatas_id')
      required final String studentAdddatasId,
      @JsonKey(name: 'student_id') required final String studentId,
      @JsonKey(name: 'total_amount') required final double totalAmount,
      @JsonKey(name: 'app_id') required final String appId,
      @JsonKey(name: 'pay_method') required final String payMethod,
      @JsonKey(name: 'order_type') required final int orderType,
      @JsonKey(name: 'discount_amount') required final double discountAmount,
      @JsonKey(name: 'coupons_ids') required final List<String> couponsIds,
      @JsonKey(name: 'employee_id') required final String employeeId,
      @JsonKey(name: 'delivery_type')
      required final int deliveryType}) = _$CreateOrderRequestImpl;

  factory _CreateOrderRequest.fromJson(Map<String, dynamic> json) =
      _$CreateOrderRequestImpl.fromJson;

  @override
  @JsonKey(name: 'business_scene')
  int get businessScene;
  @override // 业务场景: 1=课程
  List<OrderGoodsItem> get goods;
  @override // 商品列表
  @JsonKey(name: 'deposit_amount')
  double get depositAmount;
  @override // 定金
  @JsonKey(name: 'payable_amount')
  double get payableAmount;
  @override // 应付金额
  @JsonKey(name: 'real_amount')
  double get realAmount;
  @override // 实付金额
  String get remark;
  @override // 备注
  @JsonKey(name: 'student_adddatas_id')
  String get studentAdddatasId;
  @override
  @JsonKey(name: 'student_id')
  String get studentId;
  @override // 学生ID
  @JsonKey(name: 'total_amount')
  double get totalAmount;
  @override // 总金额
  @JsonKey(name: 'app_id')
  String get appId;
  @override // 微信AppID
  @JsonKey(name: 'pay_method')
  String get payMethod;
  @override // 支付方式
  @JsonKey(name: 'order_type')
  int get orderType;
  @override // 订单类型: 10=课程
  @JsonKey(name: 'discount_amount')
  double get discountAmount;
  @override // 优惠金额
  @JsonKey(name: 'coupons_ids')
  List<String> get couponsIds;
  @override // 优惠券IDs
  @JsonKey(name: 'employee_id')
  String get employeeId;
  @override // 员工ID
  @JsonKey(name: 'delivery_type')
  int get deliveryType;
  @override
  @JsonKey(ignore: true)
  _$$CreateOrderRequestImplCopyWith<_$CreateOrderRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderGoodsItem _$OrderGoodsItemFromJson(Map<String, dynamic> json) {
  return _OrderGoodsItem.fromJson(json);
}

/// @nodoc
mixin _$OrderGoodsItem {
  @JsonKey(name: 'goods_id')
  String get goodsId => throw _privateConstructorUsedError;
  @JsonKey(name: 'goods_months_price_id')
  String get goodsMonthsPriceId => throw _privateConstructorUsedError;
  String get months => throw _privateConstructorUsedError;
  @JsonKey(name: 'class_campus_id')
  String get classCampusId => throw _privateConstructorUsedError;
  @JsonKey(name: 'class_city_id')
  String get classCityId => throw _privateConstructorUsedError;
  @JsonKey(name: 'goods_num')
  String get goodsNum => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderGoodsItemCopyWith<OrderGoodsItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderGoodsItemCopyWith<$Res> {
  factory $OrderGoodsItemCopyWith(
          OrderGoodsItem value, $Res Function(OrderGoodsItem) then) =
      _$OrderGoodsItemCopyWithImpl<$Res, OrderGoodsItem>;
  @useResult
  $Res call(
      {@JsonKey(name: 'goods_id') String goodsId,
      @JsonKey(name: 'goods_months_price_id') String goodsMonthsPriceId,
      String months,
      @JsonKey(name: 'class_campus_id') String classCampusId,
      @JsonKey(name: 'class_city_id') String classCityId,
      @JsonKey(name: 'goods_num') String goodsNum});
}

/// @nodoc
class _$OrderGoodsItemCopyWithImpl<$Res, $Val extends OrderGoodsItem>
    implements $OrderGoodsItemCopyWith<$Res> {
  _$OrderGoodsItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goodsId = null,
    Object? goodsMonthsPriceId = null,
    Object? months = null,
    Object? classCampusId = null,
    Object? classCityId = null,
    Object? goodsNum = null,
  }) {
    return _then(_value.copyWith(
      goodsId: null == goodsId
          ? _value.goodsId
          : goodsId // ignore: cast_nullable_to_non_nullable
              as String,
      goodsMonthsPriceId: null == goodsMonthsPriceId
          ? _value.goodsMonthsPriceId
          : goodsMonthsPriceId // ignore: cast_nullable_to_non_nullable
              as String,
      months: null == months
          ? _value.months
          : months // ignore: cast_nullable_to_non_nullable
              as String,
      classCampusId: null == classCampusId
          ? _value.classCampusId
          : classCampusId // ignore: cast_nullable_to_non_nullable
              as String,
      classCityId: null == classCityId
          ? _value.classCityId
          : classCityId // ignore: cast_nullable_to_non_nullable
              as String,
      goodsNum: null == goodsNum
          ? _value.goodsNum
          : goodsNum // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderGoodsItemImplCopyWith<$Res>
    implements $OrderGoodsItemCopyWith<$Res> {
  factory _$$OrderGoodsItemImplCopyWith(_$OrderGoodsItemImpl value,
          $Res Function(_$OrderGoodsItemImpl) then) =
      __$$OrderGoodsItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'goods_id') String goodsId,
      @JsonKey(name: 'goods_months_price_id') String goodsMonthsPriceId,
      String months,
      @JsonKey(name: 'class_campus_id') String classCampusId,
      @JsonKey(name: 'class_city_id') String classCityId,
      @JsonKey(name: 'goods_num') String goodsNum});
}

/// @nodoc
class __$$OrderGoodsItemImplCopyWithImpl<$Res>
    extends _$OrderGoodsItemCopyWithImpl<$Res, _$OrderGoodsItemImpl>
    implements _$$OrderGoodsItemImplCopyWith<$Res> {
  __$$OrderGoodsItemImplCopyWithImpl(
      _$OrderGoodsItemImpl _value, $Res Function(_$OrderGoodsItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goodsId = null,
    Object? goodsMonthsPriceId = null,
    Object? months = null,
    Object? classCampusId = null,
    Object? classCityId = null,
    Object? goodsNum = null,
  }) {
    return _then(_$OrderGoodsItemImpl(
      goodsId: null == goodsId
          ? _value.goodsId
          : goodsId // ignore: cast_nullable_to_non_nullable
              as String,
      goodsMonthsPriceId: null == goodsMonthsPriceId
          ? _value.goodsMonthsPriceId
          : goodsMonthsPriceId // ignore: cast_nullable_to_non_nullable
              as String,
      months: null == months
          ? _value.months
          : months // ignore: cast_nullable_to_non_nullable
              as String,
      classCampusId: null == classCampusId
          ? _value.classCampusId
          : classCampusId // ignore: cast_nullable_to_non_nullable
              as String,
      classCityId: null == classCityId
          ? _value.classCityId
          : classCityId // ignore: cast_nullable_to_non_nullable
              as String,
      goodsNum: null == goodsNum
          ? _value.goodsNum
          : goodsNum // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderGoodsItemImpl implements _OrderGoodsItem {
  const _$OrderGoodsItemImpl(
      {@JsonKey(name: 'goods_id') required this.goodsId,
      @JsonKey(name: 'goods_months_price_id') required this.goodsMonthsPriceId,
      required this.months,
      @JsonKey(name: 'class_campus_id') required this.classCampusId,
      @JsonKey(name: 'class_city_id') required this.classCityId,
      @JsonKey(name: 'goods_num') required this.goodsNum});

  factory _$OrderGoodsItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderGoodsItemImplFromJson(json);

  @override
  @JsonKey(name: 'goods_id')
  final String goodsId;
  @override
  @JsonKey(name: 'goods_months_price_id')
  final String goodsMonthsPriceId;
  @override
  final String months;
  @override
  @JsonKey(name: 'class_campus_id')
  final String classCampusId;
  @override
  @JsonKey(name: 'class_city_id')
  final String classCityId;
  @override
  @JsonKey(name: 'goods_num')
  final String goodsNum;

  @override
  String toString() {
    return 'OrderGoodsItem(goodsId: $goodsId, goodsMonthsPriceId: $goodsMonthsPriceId, months: $months, classCampusId: $classCampusId, classCityId: $classCityId, goodsNum: $goodsNum)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderGoodsItemImpl &&
            (identical(other.goodsId, goodsId) || other.goodsId == goodsId) &&
            (identical(other.goodsMonthsPriceId, goodsMonthsPriceId) ||
                other.goodsMonthsPriceId == goodsMonthsPriceId) &&
            (identical(other.months, months) || other.months == months) &&
            (identical(other.classCampusId, classCampusId) ||
                other.classCampusId == classCampusId) &&
            (identical(other.classCityId, classCityId) ||
                other.classCityId == classCityId) &&
            (identical(other.goodsNum, goodsNum) ||
                other.goodsNum == goodsNum));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, goodsId, goodsMonthsPriceId,
      months, classCampusId, classCityId, goodsNum);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderGoodsItemImplCopyWith<_$OrderGoodsItemImpl> get copyWith =>
      __$$OrderGoodsItemImplCopyWithImpl<_$OrderGoodsItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderGoodsItemImplToJson(
      this,
    );
  }
}

abstract class _OrderGoodsItem implements OrderGoodsItem {
  const factory _OrderGoodsItem(
          {@JsonKey(name: 'goods_id') required final String goodsId,
          @JsonKey(name: 'goods_months_price_id')
          required final String goodsMonthsPriceId,
          required final String months,
          @JsonKey(name: 'class_campus_id') required final String classCampusId,
          @JsonKey(name: 'class_city_id') required final String classCityId,
          @JsonKey(name: 'goods_num') required final String goodsNum}) =
      _$OrderGoodsItemImpl;

  factory _OrderGoodsItem.fromJson(Map<String, dynamic> json) =
      _$OrderGoodsItemImpl.fromJson;

  @override
  @JsonKey(name: 'goods_id')
  String get goodsId;
  @override
  @JsonKey(name: 'goods_months_price_id')
  String get goodsMonthsPriceId;
  @override
  String get months;
  @override
  @JsonKey(name: 'class_campus_id')
  String get classCampusId;
  @override
  @JsonKey(name: 'class_city_id')
  String get classCityId;
  @override
  @JsonKey(name: 'goods_num')
  String get goodsNum;
  @override
  @JsonKey(ignore: true)
  _$$OrderGoodsItemImplCopyWith<_$OrderGoodsItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateOrderResponse _$CreateOrderResponseFromJson(Map<String, dynamic> json) {
  return _CreateOrderResponse.fromJson(json);
}

/// @nodoc
mixin _$CreateOrderResponse {
  @JsonKey(name: 'order_id')
  String get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'flow_id')
  String get flowId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateOrderResponseCopyWith<CreateOrderResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateOrderResponseCopyWith<$Res> {
  factory $CreateOrderResponseCopyWith(
          CreateOrderResponse value, $Res Function(CreateOrderResponse) then) =
      _$CreateOrderResponseCopyWithImpl<$Res, CreateOrderResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'order_id') String orderId,
      @JsonKey(name: 'flow_id') String flowId});
}

/// @nodoc
class _$CreateOrderResponseCopyWithImpl<$Res, $Val extends CreateOrderResponse>
    implements $CreateOrderResponseCopyWith<$Res> {
  _$CreateOrderResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? flowId = null,
  }) {
    return _then(_value.copyWith(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      flowId: null == flowId
          ? _value.flowId
          : flowId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateOrderResponseImplCopyWith<$Res>
    implements $CreateOrderResponseCopyWith<$Res> {
  factory _$$CreateOrderResponseImplCopyWith(_$CreateOrderResponseImpl value,
          $Res Function(_$CreateOrderResponseImpl) then) =
      __$$CreateOrderResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'order_id') String orderId,
      @JsonKey(name: 'flow_id') String flowId});
}

/// @nodoc
class __$$CreateOrderResponseImplCopyWithImpl<$Res>
    extends _$CreateOrderResponseCopyWithImpl<$Res, _$CreateOrderResponseImpl>
    implements _$$CreateOrderResponseImplCopyWith<$Res> {
  __$$CreateOrderResponseImplCopyWithImpl(_$CreateOrderResponseImpl _value,
      $Res Function(_$CreateOrderResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? flowId = null,
  }) {
    return _then(_$CreateOrderResponseImpl(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      flowId: null == flowId
          ? _value.flowId
          : flowId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateOrderResponseImpl implements _CreateOrderResponse {
  const _$CreateOrderResponseImpl(
      {@JsonKey(name: 'order_id') required this.orderId,
      @JsonKey(name: 'flow_id') required this.flowId});

  factory _$CreateOrderResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateOrderResponseImplFromJson(json);

  @override
  @JsonKey(name: 'order_id')
  final String orderId;
  @override
  @JsonKey(name: 'flow_id')
  final String flowId;

  @override
  String toString() {
    return 'CreateOrderResponse(orderId: $orderId, flowId: $flowId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateOrderResponseImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.flowId, flowId) || other.flowId == flowId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, orderId, flowId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateOrderResponseImplCopyWith<_$CreateOrderResponseImpl> get copyWith =>
      __$$CreateOrderResponseImplCopyWithImpl<_$CreateOrderResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateOrderResponseImplToJson(
      this,
    );
  }
}

abstract class _CreateOrderResponse implements CreateOrderResponse {
  const factory _CreateOrderResponse(
          {@JsonKey(name: 'order_id') required final String orderId,
          @JsonKey(name: 'flow_id') required final String flowId}) =
      _$CreateOrderResponseImpl;

  factory _CreateOrderResponse.fromJson(Map<String, dynamic> json) =
      _$CreateOrderResponseImpl.fromJson;

  @override
  @JsonKey(name: 'order_id')
  String get orderId;
  @override
  @JsonKey(name: 'flow_id')
  String get flowId;
  @override
  @JsonKey(ignore: true)
  _$$CreateOrderResponseImplCopyWith<_$CreateOrderResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
