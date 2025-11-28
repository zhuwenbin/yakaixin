// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$OrderState {
  bool get isCreatingOrder => throw _privateConstructorUsedError; // 创建订单中
  bool get isLoadingPayModes => throw _privateConstructorUsedError; // 加载支付方式中
  bool get isPaying => throw _privateConstructorUsedError; // 支付中
  String? get orderId => throw _privateConstructorUsedError;
  String? get flowId => throw _privateConstructorUsedError;
  List<Map<String, dynamic>>? get payModes =>
      throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrderStateCopyWith<OrderState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderStateCopyWith<$Res> {
  factory $OrderStateCopyWith(
          OrderState value, $Res Function(OrderState) then) =
      _$OrderStateCopyWithImpl<$Res, OrderState>;
  @useResult
  $Res call(
      {bool isCreatingOrder,
      bool isLoadingPayModes,
      bool isPaying,
      String? orderId,
      String? flowId,
      List<Map<String, dynamic>>? payModes,
      String? error});
}

/// @nodoc
class _$OrderStateCopyWithImpl<$Res, $Val extends OrderState>
    implements $OrderStateCopyWith<$Res> {
  _$OrderStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCreatingOrder = null,
    Object? isLoadingPayModes = null,
    Object? isPaying = null,
    Object? orderId = freezed,
    Object? flowId = freezed,
    Object? payModes = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isCreatingOrder: null == isCreatingOrder
          ? _value.isCreatingOrder
          : isCreatingOrder // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingPayModes: null == isLoadingPayModes
          ? _value.isLoadingPayModes
          : isLoadingPayModes // ignore: cast_nullable_to_non_nullable
              as bool,
      isPaying: null == isPaying
          ? _value.isPaying
          : isPaying // ignore: cast_nullable_to_non_nullable
              as bool,
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      flowId: freezed == flowId
          ? _value.flowId
          : flowId // ignore: cast_nullable_to_non_nullable
              as String?,
      payModes: freezed == payModes
          ? _value.payModes
          : payModes // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderStateImplCopyWith<$Res>
    implements $OrderStateCopyWith<$Res> {
  factory _$$OrderStateImplCopyWith(
          _$OrderStateImpl value, $Res Function(_$OrderStateImpl) then) =
      __$$OrderStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isCreatingOrder,
      bool isLoadingPayModes,
      bool isPaying,
      String? orderId,
      String? flowId,
      List<Map<String, dynamic>>? payModes,
      String? error});
}

/// @nodoc
class __$$OrderStateImplCopyWithImpl<$Res>
    extends _$OrderStateCopyWithImpl<$Res, _$OrderStateImpl>
    implements _$$OrderStateImplCopyWith<$Res> {
  __$$OrderStateImplCopyWithImpl(
      _$OrderStateImpl _value, $Res Function(_$OrderStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCreatingOrder = null,
    Object? isLoadingPayModes = null,
    Object? isPaying = null,
    Object? orderId = freezed,
    Object? flowId = freezed,
    Object? payModes = freezed,
    Object? error = freezed,
  }) {
    return _then(_$OrderStateImpl(
      isCreatingOrder: null == isCreatingOrder
          ? _value.isCreatingOrder
          : isCreatingOrder // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingPayModes: null == isLoadingPayModes
          ? _value.isLoadingPayModes
          : isLoadingPayModes // ignore: cast_nullable_to_non_nullable
              as bool,
      isPaying: null == isPaying
          ? _value.isPaying
          : isPaying // ignore: cast_nullable_to_non_nullable
              as bool,
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      flowId: freezed == flowId
          ? _value.flowId
          : flowId // ignore: cast_nullable_to_non_nullable
              as String?,
      payModes: freezed == payModes
          ? _value._payModes
          : payModes // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$OrderStateImpl implements _OrderState {
  const _$OrderStateImpl(
      {this.isCreatingOrder = false,
      this.isLoadingPayModes = false,
      this.isPaying = false,
      this.orderId,
      this.flowId,
      final List<Map<String, dynamic>>? payModes,
      this.error})
      : _payModes = payModes;

  @override
  @JsonKey()
  final bool isCreatingOrder;
// 创建订单中
  @override
  @JsonKey()
  final bool isLoadingPayModes;
// 加载支付方式中
  @override
  @JsonKey()
  final bool isPaying;
// 支付中
  @override
  final String? orderId;
  @override
  final String? flowId;
  final List<Map<String, dynamic>>? _payModes;
  @override
  List<Map<String, dynamic>>? get payModes {
    final value = _payModes;
    if (value == null) return null;
    if (_payModes is EqualUnmodifiableListView) return _payModes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? error;

  @override
  String toString() {
    return 'OrderState(isCreatingOrder: $isCreatingOrder, isLoadingPayModes: $isLoadingPayModes, isPaying: $isPaying, orderId: $orderId, flowId: $flowId, payModes: $payModes, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderStateImpl &&
            (identical(other.isCreatingOrder, isCreatingOrder) ||
                other.isCreatingOrder == isCreatingOrder) &&
            (identical(other.isLoadingPayModes, isLoadingPayModes) ||
                other.isLoadingPayModes == isLoadingPayModes) &&
            (identical(other.isPaying, isPaying) ||
                other.isPaying == isPaying) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.flowId, flowId) || other.flowId == flowId) &&
            const DeepCollectionEquality().equals(other._payModes, _payModes) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isCreatingOrder,
      isLoadingPayModes,
      isPaying,
      orderId,
      flowId,
      const DeepCollectionEquality().hash(_payModes),
      error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderStateImplCopyWith<_$OrderStateImpl> get copyWith =>
      __$$OrderStateImplCopyWithImpl<_$OrderStateImpl>(this, _$identity);
}

abstract class _OrderState implements OrderState {
  const factory _OrderState(
      {final bool isCreatingOrder,
      final bool isLoadingPayModes,
      final bool isPaying,
      final String? orderId,
      final String? flowId,
      final List<Map<String, dynamic>>? payModes,
      final String? error}) = _$OrderStateImpl;

  @override
  bool get isCreatingOrder;
  @override // 创建订单中
  bool get isLoadingPayModes;
  @override // 加载支付方式中
  bool get isPaying;
  @override // 支付中
  String? get orderId;
  @override
  String? get flowId;
  @override
  List<Map<String, dynamic>>? get payModes;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$OrderStateImplCopyWith<_$OrderStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CreateOrderResult {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String orderId, String flowId) needPayment,
    required TResult Function(String orderId) freeOrder,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String orderId, String flowId)? needPayment,
    TResult? Function(String orderId)? freeOrder,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String orderId, String flowId)? needPayment,
    TResult Function(String orderId)? freeOrder,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NeedPayment value) needPayment,
    required TResult Function(_FreeOrder value) freeOrder,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NeedPayment value)? needPayment,
    TResult? Function(_FreeOrder value)? freeOrder,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NeedPayment value)? needPayment,
    TResult Function(_FreeOrder value)? freeOrder,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateOrderResultCopyWith<$Res> {
  factory $CreateOrderResultCopyWith(
          CreateOrderResult value, $Res Function(CreateOrderResult) then) =
      _$CreateOrderResultCopyWithImpl<$Res, CreateOrderResult>;
}

/// @nodoc
class _$CreateOrderResultCopyWithImpl<$Res, $Val extends CreateOrderResult>
    implements $CreateOrderResultCopyWith<$Res> {
  _$CreateOrderResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$NeedPaymentImplCopyWith<$Res> {
  factory _$$NeedPaymentImplCopyWith(
          _$NeedPaymentImpl value, $Res Function(_$NeedPaymentImpl) then) =
      __$$NeedPaymentImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String orderId, String flowId});
}

/// @nodoc
class __$$NeedPaymentImplCopyWithImpl<$Res>
    extends _$CreateOrderResultCopyWithImpl<$Res, _$NeedPaymentImpl>
    implements _$$NeedPaymentImplCopyWith<$Res> {
  __$$NeedPaymentImplCopyWithImpl(
      _$NeedPaymentImpl _value, $Res Function(_$NeedPaymentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? flowId = null,
  }) {
    return _then(_$NeedPaymentImpl(
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

class _$NeedPaymentImpl implements _NeedPayment {
  const _$NeedPaymentImpl({required this.orderId, required this.flowId});

  @override
  final String orderId;
  @override
  final String flowId;

  @override
  String toString() {
    return 'CreateOrderResult.needPayment(orderId: $orderId, flowId: $flowId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NeedPaymentImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.flowId, flowId) || other.flowId == flowId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, orderId, flowId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NeedPaymentImplCopyWith<_$NeedPaymentImpl> get copyWith =>
      __$$NeedPaymentImplCopyWithImpl<_$NeedPaymentImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String orderId, String flowId) needPayment,
    required TResult Function(String orderId) freeOrder,
    required TResult Function(String message) error,
  }) {
    return needPayment(orderId, flowId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String orderId, String flowId)? needPayment,
    TResult? Function(String orderId)? freeOrder,
    TResult? Function(String message)? error,
  }) {
    return needPayment?.call(orderId, flowId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String orderId, String flowId)? needPayment,
    TResult Function(String orderId)? freeOrder,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (needPayment != null) {
      return needPayment(orderId, flowId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NeedPayment value) needPayment,
    required TResult Function(_FreeOrder value) freeOrder,
    required TResult Function(_Error value) error,
  }) {
    return needPayment(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NeedPayment value)? needPayment,
    TResult? Function(_FreeOrder value)? freeOrder,
    TResult? Function(_Error value)? error,
  }) {
    return needPayment?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NeedPayment value)? needPayment,
    TResult Function(_FreeOrder value)? freeOrder,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (needPayment != null) {
      return needPayment(this);
    }
    return orElse();
  }
}

abstract class _NeedPayment implements CreateOrderResult {
  const factory _NeedPayment(
      {required final String orderId,
      required final String flowId}) = _$NeedPaymentImpl;

  String get orderId;
  String get flowId;
  @JsonKey(ignore: true)
  _$$NeedPaymentImplCopyWith<_$NeedPaymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FreeOrderImplCopyWith<$Res> {
  factory _$$FreeOrderImplCopyWith(
          _$FreeOrderImpl value, $Res Function(_$FreeOrderImpl) then) =
      __$$FreeOrderImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String orderId});
}

/// @nodoc
class __$$FreeOrderImplCopyWithImpl<$Res>
    extends _$CreateOrderResultCopyWithImpl<$Res, _$FreeOrderImpl>
    implements _$$FreeOrderImplCopyWith<$Res> {
  __$$FreeOrderImplCopyWithImpl(
      _$FreeOrderImpl _value, $Res Function(_$FreeOrderImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
  }) {
    return _then(_$FreeOrderImpl(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FreeOrderImpl implements _FreeOrder {
  const _$FreeOrderImpl({required this.orderId});

  @override
  final String orderId;

  @override
  String toString() {
    return 'CreateOrderResult.freeOrder(orderId: $orderId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FreeOrderImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, orderId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FreeOrderImplCopyWith<_$FreeOrderImpl> get copyWith =>
      __$$FreeOrderImplCopyWithImpl<_$FreeOrderImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String orderId, String flowId) needPayment,
    required TResult Function(String orderId) freeOrder,
    required TResult Function(String message) error,
  }) {
    return freeOrder(orderId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String orderId, String flowId)? needPayment,
    TResult? Function(String orderId)? freeOrder,
    TResult? Function(String message)? error,
  }) {
    return freeOrder?.call(orderId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String orderId, String flowId)? needPayment,
    TResult Function(String orderId)? freeOrder,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (freeOrder != null) {
      return freeOrder(orderId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NeedPayment value) needPayment,
    required TResult Function(_FreeOrder value) freeOrder,
    required TResult Function(_Error value) error,
  }) {
    return freeOrder(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NeedPayment value)? needPayment,
    TResult? Function(_FreeOrder value)? freeOrder,
    TResult? Function(_Error value)? error,
  }) {
    return freeOrder?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NeedPayment value)? needPayment,
    TResult Function(_FreeOrder value)? freeOrder,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (freeOrder != null) {
      return freeOrder(this);
    }
    return orElse();
  }
}

abstract class _FreeOrder implements CreateOrderResult {
  const factory _FreeOrder({required final String orderId}) = _$FreeOrderImpl;

  String get orderId;
  @JsonKey(ignore: true)
  _$$FreeOrderImplCopyWith<_$FreeOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$CreateOrderResultCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'CreateOrderResult.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String orderId, String flowId) needPayment,
    required TResult Function(String orderId) freeOrder,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String orderId, String flowId)? needPayment,
    TResult? Function(String orderId)? freeOrder,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String orderId, String flowId)? needPayment,
    TResult Function(String orderId)? freeOrder,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NeedPayment value) needPayment,
    required TResult Function(_FreeOrder value) freeOrder,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NeedPayment value)? needPayment,
    TResult? Function(_FreeOrder value)? freeOrder,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NeedPayment value)? needPayment,
    TResult Function(_FreeOrder value)? freeOrder,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements CreateOrderResult {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
