// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) {
  return _OrderModel.fromJson(json);
}

/// @nodoc
mixin _$OrderModel {
  @JsonKey(name: 'id')
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_id')
  String? get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_no')
  String get orderNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'goods_id')
  String? get goodsId => throw _privateConstructorUsedError;
  @JsonKey(name: 'goods_name')
  String get goodsName => throw _privateConstructorUsedError;
  @JsonKey(name: 'goods_type')
  String? get goodsType => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  String get status =>
      throw _privateConstructorUsedError; // 1:待支付 2:已完成 3:待补缴 4:已取消 5:退费中 6:已退费
  @JsonKey(name: 'status_name')
  String get statusName => throw _privateConstructorUsedError;
  @JsonKey(name: 'payable_amount')
  String get payableAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'countdown')
  int? get countdown => throw _privateConstructorUsedError; // 倒计时秒数
  @JsonKey(name: 'flow_id')
  String? get flowId => throw _privateConstructorUsedError;
  @JsonKey(name: 'professional_id_name')
  String? get professionalIdName => throw _privateConstructorUsedError;
  @JsonKey(name: 'months')
  int? get months => throw _privateConstructorUsedError;
  @JsonKey(name: 'tiku_goods_details')
  Map<String, dynamic>? get tikuGoodsDetails =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'teaching_system')
  Map<String, dynamic>? get teachingSystem =>
      throw _privateConstructorUsedError; // 前端计算字段
  String? get numText => throw _privateConstructorUsedError;
  String? get monthText => throw _privateConstructorUsedError;
  String? get tips => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderModelCopyWith<OrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderModelCopyWith<$Res> {
  factory $OrderModelCopyWith(
          OrderModel value, $Res Function(OrderModel) then) =
      _$OrderModelCopyWithImpl<$Res, OrderModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'order_id') String? orderId,
      @JsonKey(name: 'order_no') String orderNo,
      @JsonKey(name: 'goods_id') String? goodsId,
      @JsonKey(name: 'goods_name') String goodsName,
      @JsonKey(name: 'goods_type') String? goodsType,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'status_name') String statusName,
      @JsonKey(name: 'payable_amount') String payableAmount,
      @JsonKey(name: 'countdown') int? countdown,
      @JsonKey(name: 'flow_id') String? flowId,
      @JsonKey(name: 'professional_id_name') String? professionalIdName,
      @JsonKey(name: 'months') int? months,
      @JsonKey(name: 'tiku_goods_details')
      Map<String, dynamic>? tikuGoodsDetails,
      @JsonKey(name: 'teaching_system') Map<String, dynamic>? teachingSystem,
      String? numText,
      String? monthText,
      String? tips});
}

/// @nodoc
class _$OrderModelCopyWithImpl<$Res, $Val extends OrderModel>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orderId = freezed,
    Object? orderNo = null,
    Object? goodsId = freezed,
    Object? goodsName = null,
    Object? goodsType = freezed,
    Object? status = null,
    Object? statusName = null,
    Object? payableAmount = null,
    Object? countdown = freezed,
    Object? flowId = freezed,
    Object? professionalIdName = freezed,
    Object? months = freezed,
    Object? tikuGoodsDetails = freezed,
    Object? teachingSystem = freezed,
    Object? numText = freezed,
    Object? monthText = freezed,
    Object? tips = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      orderNo: null == orderNo
          ? _value.orderNo
          : orderNo // ignore: cast_nullable_to_non_nullable
              as String,
      goodsId: freezed == goodsId
          ? _value.goodsId
          : goodsId // ignore: cast_nullable_to_non_nullable
              as String?,
      goodsName: null == goodsName
          ? _value.goodsName
          : goodsName // ignore: cast_nullable_to_non_nullable
              as String,
      goodsType: freezed == goodsType
          ? _value.goodsType
          : goodsType // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      statusName: null == statusName
          ? _value.statusName
          : statusName // ignore: cast_nullable_to_non_nullable
              as String,
      payableAmount: null == payableAmount
          ? _value.payableAmount
          : payableAmount // ignore: cast_nullable_to_non_nullable
              as String,
      countdown: freezed == countdown
          ? _value.countdown
          : countdown // ignore: cast_nullable_to_non_nullable
              as int?,
      flowId: freezed == flowId
          ? _value.flowId
          : flowId // ignore: cast_nullable_to_non_nullable
              as String?,
      professionalIdName: freezed == professionalIdName
          ? _value.professionalIdName
          : professionalIdName // ignore: cast_nullable_to_non_nullable
              as String?,
      months: freezed == months
          ? _value.months
          : months // ignore: cast_nullable_to_non_nullable
              as int?,
      tikuGoodsDetails: freezed == tikuGoodsDetails
          ? _value.tikuGoodsDetails
          : tikuGoodsDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      teachingSystem: freezed == teachingSystem
          ? _value.teachingSystem
          : teachingSystem // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      numText: freezed == numText
          ? _value.numText
          : numText // ignore: cast_nullable_to_non_nullable
              as String?,
      monthText: freezed == monthText
          ? _value.monthText
          : monthText // ignore: cast_nullable_to_non_nullable
              as String?,
      tips: freezed == tips
          ? _value.tips
          : tips // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderModelImplCopyWith<$Res>
    implements $OrderModelCopyWith<$Res> {
  factory _$$OrderModelImplCopyWith(
          _$OrderModelImpl value, $Res Function(_$OrderModelImpl) then) =
      __$$OrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'order_id') String? orderId,
      @JsonKey(name: 'order_no') String orderNo,
      @JsonKey(name: 'goods_id') String? goodsId,
      @JsonKey(name: 'goods_name') String goodsName,
      @JsonKey(name: 'goods_type') String? goodsType,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'status_name') String statusName,
      @JsonKey(name: 'payable_amount') String payableAmount,
      @JsonKey(name: 'countdown') int? countdown,
      @JsonKey(name: 'flow_id') String? flowId,
      @JsonKey(name: 'professional_id_name') String? professionalIdName,
      @JsonKey(name: 'months') int? months,
      @JsonKey(name: 'tiku_goods_details')
      Map<String, dynamic>? tikuGoodsDetails,
      @JsonKey(name: 'teaching_system') Map<String, dynamic>? teachingSystem,
      String? numText,
      String? monthText,
      String? tips});
}

/// @nodoc
class __$$OrderModelImplCopyWithImpl<$Res>
    extends _$OrderModelCopyWithImpl<$Res, _$OrderModelImpl>
    implements _$$OrderModelImplCopyWith<$Res> {
  __$$OrderModelImplCopyWithImpl(
      _$OrderModelImpl _value, $Res Function(_$OrderModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orderId = freezed,
    Object? orderNo = null,
    Object? goodsId = freezed,
    Object? goodsName = null,
    Object? goodsType = freezed,
    Object? status = null,
    Object? statusName = null,
    Object? payableAmount = null,
    Object? countdown = freezed,
    Object? flowId = freezed,
    Object? professionalIdName = freezed,
    Object? months = freezed,
    Object? tikuGoodsDetails = freezed,
    Object? teachingSystem = freezed,
    Object? numText = freezed,
    Object? monthText = freezed,
    Object? tips = freezed,
  }) {
    return _then(_$OrderModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      orderNo: null == orderNo
          ? _value.orderNo
          : orderNo // ignore: cast_nullable_to_non_nullable
              as String,
      goodsId: freezed == goodsId
          ? _value.goodsId
          : goodsId // ignore: cast_nullable_to_non_nullable
              as String?,
      goodsName: null == goodsName
          ? _value.goodsName
          : goodsName // ignore: cast_nullable_to_non_nullable
              as String,
      goodsType: freezed == goodsType
          ? _value.goodsType
          : goodsType // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      statusName: null == statusName
          ? _value.statusName
          : statusName // ignore: cast_nullable_to_non_nullable
              as String,
      payableAmount: null == payableAmount
          ? _value.payableAmount
          : payableAmount // ignore: cast_nullable_to_non_nullable
              as String,
      countdown: freezed == countdown
          ? _value.countdown
          : countdown // ignore: cast_nullable_to_non_nullable
              as int?,
      flowId: freezed == flowId
          ? _value.flowId
          : flowId // ignore: cast_nullable_to_non_nullable
              as String?,
      professionalIdName: freezed == professionalIdName
          ? _value.professionalIdName
          : professionalIdName // ignore: cast_nullable_to_non_nullable
              as String?,
      months: freezed == months
          ? _value.months
          : months // ignore: cast_nullable_to_non_nullable
              as int?,
      tikuGoodsDetails: freezed == tikuGoodsDetails
          ? _value._tikuGoodsDetails
          : tikuGoodsDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      teachingSystem: freezed == teachingSystem
          ? _value._teachingSystem
          : teachingSystem // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      numText: freezed == numText
          ? _value.numText
          : numText // ignore: cast_nullable_to_non_nullable
              as String?,
      monthText: freezed == monthText
          ? _value.monthText
          : monthText // ignore: cast_nullable_to_non_nullable
              as String?,
      tips: freezed == tips
          ? _value.tips
          : tips // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderModelImpl implements _OrderModel {
  const _$OrderModelImpl(
      {@JsonKey(name: 'id') this.id,
      @JsonKey(name: 'order_id') this.orderId,
      @JsonKey(name: 'order_no') required this.orderNo,
      @JsonKey(name: 'goods_id') this.goodsId,
      @JsonKey(name: 'goods_name') required this.goodsName,
      @JsonKey(name: 'goods_type') this.goodsType,
      @JsonKey(name: 'status') required this.status,
      @JsonKey(name: 'status_name') required this.statusName,
      @JsonKey(name: 'payable_amount') required this.payableAmount,
      @JsonKey(name: 'countdown') this.countdown,
      @JsonKey(name: 'flow_id') this.flowId,
      @JsonKey(name: 'professional_id_name') this.professionalIdName,
      @JsonKey(name: 'months') this.months,
      @JsonKey(name: 'tiku_goods_details')
      final Map<String, dynamic>? tikuGoodsDetails,
      @JsonKey(name: 'teaching_system')
      final Map<String, dynamic>? teachingSystem,
      this.numText,
      this.monthText,
      this.tips})
      : _tikuGoodsDetails = tikuGoodsDetails,
        _teachingSystem = teachingSystem;

  factory _$OrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String? id;
  @override
  @JsonKey(name: 'order_id')
  final String? orderId;
  @override
  @JsonKey(name: 'order_no')
  final String orderNo;
  @override
  @JsonKey(name: 'goods_id')
  final String? goodsId;
  @override
  @JsonKey(name: 'goods_name')
  final String goodsName;
  @override
  @JsonKey(name: 'goods_type')
  final String? goodsType;
  @override
  @JsonKey(name: 'status')
  final String status;
// 1:待支付 2:已完成 3:待补缴 4:已取消 5:退费中 6:已退费
  @override
  @JsonKey(name: 'status_name')
  final String statusName;
  @override
  @JsonKey(name: 'payable_amount')
  final String payableAmount;
  @override
  @JsonKey(name: 'countdown')
  final int? countdown;
// 倒计时秒数
  @override
  @JsonKey(name: 'flow_id')
  final String? flowId;
  @override
  @JsonKey(name: 'professional_id_name')
  final String? professionalIdName;
  @override
  @JsonKey(name: 'months')
  final int? months;
  final Map<String, dynamic>? _tikuGoodsDetails;
  @override
  @JsonKey(name: 'tiku_goods_details')
  Map<String, dynamic>? get tikuGoodsDetails {
    final value = _tikuGoodsDetails;
    if (value == null) return null;
    if (_tikuGoodsDetails is EqualUnmodifiableMapView) return _tikuGoodsDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _teachingSystem;
  @override
  @JsonKey(name: 'teaching_system')
  Map<String, dynamic>? get teachingSystem {
    final value = _teachingSystem;
    if (value == null) return null;
    if (_teachingSystem is EqualUnmodifiableMapView) return _teachingSystem;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// 前端计算字段
  @override
  final String? numText;
  @override
  final String? monthText;
  @override
  final String? tips;

  @override
  String toString() {
    return 'OrderModel(id: $id, orderId: $orderId, orderNo: $orderNo, goodsId: $goodsId, goodsName: $goodsName, goodsType: $goodsType, status: $status, statusName: $statusName, payableAmount: $payableAmount, countdown: $countdown, flowId: $flowId, professionalIdName: $professionalIdName, months: $months, tikuGoodsDetails: $tikuGoodsDetails, teachingSystem: $teachingSystem, numText: $numText, monthText: $monthText, tips: $tips)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.orderNo, orderNo) || other.orderNo == orderNo) &&
            (identical(other.goodsId, goodsId) || other.goodsId == goodsId) &&
            (identical(other.goodsName, goodsName) ||
                other.goodsName == goodsName) &&
            (identical(other.goodsType, goodsType) ||
                other.goodsType == goodsType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusName, statusName) ||
                other.statusName == statusName) &&
            (identical(other.payableAmount, payableAmount) ||
                other.payableAmount == payableAmount) &&
            (identical(other.countdown, countdown) ||
                other.countdown == countdown) &&
            (identical(other.flowId, flowId) || other.flowId == flowId) &&
            (identical(other.professionalIdName, professionalIdName) ||
                other.professionalIdName == professionalIdName) &&
            (identical(other.months, months) || other.months == months) &&
            const DeepCollectionEquality()
                .equals(other._tikuGoodsDetails, _tikuGoodsDetails) &&
            const DeepCollectionEquality()
                .equals(other._teachingSystem, _teachingSystem) &&
            (identical(other.numText, numText) || other.numText == numText) &&
            (identical(other.monthText, monthText) ||
                other.monthText == monthText) &&
            (identical(other.tips, tips) || other.tips == tips));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orderId,
      orderNo,
      goodsId,
      goodsName,
      goodsType,
      status,
      statusName,
      payableAmount,
      countdown,
      flowId,
      professionalIdName,
      months,
      const DeepCollectionEquality().hash(_tikuGoodsDetails),
      const DeepCollectionEquality().hash(_teachingSystem),
      numText,
      monthText,
      tips);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      __$$OrderModelImplCopyWithImpl<_$OrderModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderModelImplToJson(
      this,
    );
  }
}

abstract class _OrderModel implements OrderModel {
  const factory _OrderModel(
      {@JsonKey(name: 'id') final String? id,
      @JsonKey(name: 'order_id') final String? orderId,
      @JsonKey(name: 'order_no') required final String orderNo,
      @JsonKey(name: 'goods_id') final String? goodsId,
      @JsonKey(name: 'goods_name') required final String goodsName,
      @JsonKey(name: 'goods_type') final String? goodsType,
      @JsonKey(name: 'status') required final String status,
      @JsonKey(name: 'status_name') required final String statusName,
      @JsonKey(name: 'payable_amount') required final String payableAmount,
      @JsonKey(name: 'countdown') final int? countdown,
      @JsonKey(name: 'flow_id') final String? flowId,
      @JsonKey(name: 'professional_id_name') final String? professionalIdName,
      @JsonKey(name: 'months') final int? months,
      @JsonKey(name: 'tiku_goods_details')
      final Map<String, dynamic>? tikuGoodsDetails,
      @JsonKey(name: 'teaching_system')
      final Map<String, dynamic>? teachingSystem,
      final String? numText,
      final String? monthText,
      final String? tips}) = _$OrderModelImpl;

  factory _OrderModel.fromJson(Map<String, dynamic> json) =
      _$OrderModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String? get id;
  @override
  @JsonKey(name: 'order_id')
  String? get orderId;
  @override
  @JsonKey(name: 'order_no')
  String get orderNo;
  @override
  @JsonKey(name: 'goods_id')
  String? get goodsId;
  @override
  @JsonKey(name: 'goods_name')
  String get goodsName;
  @override
  @JsonKey(name: 'goods_type')
  String? get goodsType;
  @override
  @JsonKey(name: 'status')
  String get status;
  @override // 1:待支付 2:已完成 3:待补缴 4:已取消 5:退费中 6:已退费
  @JsonKey(name: 'status_name')
  String get statusName;
  @override
  @JsonKey(name: 'payable_amount')
  String get payableAmount;
  @override
  @JsonKey(name: 'countdown')
  int? get countdown;
  @override // 倒计时秒数
  @JsonKey(name: 'flow_id')
  String? get flowId;
  @override
  @JsonKey(name: 'professional_id_name')
  String? get professionalIdName;
  @override
  @JsonKey(name: 'months')
  int? get months;
  @override
  @JsonKey(name: 'tiku_goods_details')
  Map<String, dynamic>? get tikuGoodsDetails;
  @override
  @JsonKey(name: 'teaching_system')
  Map<String, dynamic>? get teachingSystem;
  @override // 前端计算字段
  String? get numText;
  @override
  String? get monthText;
  @override
  String? get tips;
  @override
  @JsonKey(ignore: true)
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderListResponse _$OrderListResponseFromJson(Map<String, dynamic> json) {
  return _OrderListResponse.fromJson(json);
}

/// @nodoc
mixin _$OrderListResponse {
  List<OrderModel> get list => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderListResponseCopyWith<OrderListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderListResponseCopyWith<$Res> {
  factory $OrderListResponseCopyWith(
          OrderListResponse value, $Res Function(OrderListResponse) then) =
      _$OrderListResponseCopyWithImpl<$Res, OrderListResponse>;
  @useResult
  $Res call({List<OrderModel> list, int total});
}

/// @nodoc
class _$OrderListResponseCopyWithImpl<$Res, $Val extends OrderListResponse>
    implements $OrderListResponseCopyWith<$Res> {
  _$OrderListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      list: null == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<OrderModel>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderListResponseImplCopyWith<$Res>
    implements $OrderListResponseCopyWith<$Res> {
  factory _$$OrderListResponseImplCopyWith(_$OrderListResponseImpl value,
          $Res Function(_$OrderListResponseImpl) then) =
      __$$OrderListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<OrderModel> list, int total});
}

/// @nodoc
class __$$OrderListResponseImplCopyWithImpl<$Res>
    extends _$OrderListResponseCopyWithImpl<$Res, _$OrderListResponseImpl>
    implements _$$OrderListResponseImplCopyWith<$Res> {
  __$$OrderListResponseImplCopyWithImpl(_$OrderListResponseImpl _value,
      $Res Function(_$OrderListResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? total = null,
  }) {
    return _then(_$OrderListResponseImpl(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<OrderModel>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderListResponseImpl implements _OrderListResponse {
  const _$OrderListResponseImpl(
      {required final List<OrderModel> list, this.total = 0})
      : _list = list;

  factory _$OrderListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderListResponseImplFromJson(json);

  final List<OrderModel> _list;
  @override
  List<OrderModel> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  @JsonKey()
  final int total;

  @override
  String toString() {
    return 'OrderListResponse(list: $list, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderListResponseImpl &&
            const DeepCollectionEquality().equals(other._list, _list) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_list), total);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderListResponseImplCopyWith<_$OrderListResponseImpl> get copyWith =>
      __$$OrderListResponseImplCopyWithImpl<_$OrderListResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderListResponseImplToJson(
      this,
    );
  }
}

abstract class _OrderListResponse implements OrderListResponse {
  const factory _OrderListResponse(
      {required final List<OrderModel> list,
      final int total}) = _$OrderListResponseImpl;

  factory _OrderListResponse.fromJson(Map<String, dynamic> json) =
      _$OrderListResponseImpl.fromJson;

  @override
  List<OrderModel> get list;
  @override
  int get total;
  @override
  @JsonKey(ignore: true)
  _$$OrderListResponseImplCopyWith<_$OrderListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
