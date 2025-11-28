// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PayModeListRequest _$PayModeListRequestFromJson(Map<String, dynamic> json) {
  return _PayModeListRequest.fromJson(json);
}

/// @nodoc
mixin _$PayModeListRequest {
  @JsonKey(name: 'account_use')
  int get accountUse => throw _privateConstructorUsedError; // 1:收款 2:付款
  @JsonKey(name: 'is_match')
  int get isMatch => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_usable')
  int get isUsable => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_type')
  int get accountType => throw _privateConstructorUsedError; // 1:线上支付 2:线下支付
  @JsonKey(name: 'order_id')
  String get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'goods_ids')
  String get goodsIds => throw _privateConstructorUsedError;
  @JsonKey(name: 'merchant_id')
  String get merchantId => throw _privateConstructorUsedError;
  @JsonKey(name: 'brand_id')
  String get brandId => throw _privateConstructorUsedError;
  @JsonKey(name: 'collection_scene')
  int get collectionScene => throw _privateConstructorUsedError;
  @JsonKey(name: 'collection_terminal')
  int get collectionTerminal => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PayModeListRequestCopyWith<PayModeListRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PayModeListRequestCopyWith<$Res> {
  factory $PayModeListRequestCopyWith(
          PayModeListRequest value, $Res Function(PayModeListRequest) then) =
      _$PayModeListRequestCopyWithImpl<$Res, PayModeListRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'account_use') int accountUse,
      @JsonKey(name: 'is_match') int isMatch,
      @JsonKey(name: 'is_usable') int isUsable,
      int page,
      int size,
      @JsonKey(name: 'account_type') int accountType,
      @JsonKey(name: 'order_id') String orderId,
      @JsonKey(name: 'goods_ids') String goodsIds,
      @JsonKey(name: 'merchant_id') String merchantId,
      @JsonKey(name: 'brand_id') String brandId,
      @JsonKey(name: 'collection_scene') int collectionScene,
      @JsonKey(name: 'collection_terminal') int collectionTerminal});
}

/// @nodoc
class _$PayModeListRequestCopyWithImpl<$Res, $Val extends PayModeListRequest>
    implements $PayModeListRequestCopyWith<$Res> {
  _$PayModeListRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountUse = null,
    Object? isMatch = null,
    Object? isUsable = null,
    Object? page = null,
    Object? size = null,
    Object? accountType = null,
    Object? orderId = null,
    Object? goodsIds = null,
    Object? merchantId = null,
    Object? brandId = null,
    Object? collectionScene = null,
    Object? collectionTerminal = null,
  }) {
    return _then(_value.copyWith(
      accountUse: null == accountUse
          ? _value.accountUse
          : accountUse // ignore: cast_nullable_to_non_nullable
              as int,
      isMatch: null == isMatch
          ? _value.isMatch
          : isMatch // ignore: cast_nullable_to_non_nullable
              as int,
      isUsable: null == isUsable
          ? _value.isUsable
          : isUsable // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      accountType: null == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as int,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      goodsIds: null == goodsIds
          ? _value.goodsIds
          : goodsIds // ignore: cast_nullable_to_non_nullable
              as String,
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      brandId: null == brandId
          ? _value.brandId
          : brandId // ignore: cast_nullable_to_non_nullable
              as String,
      collectionScene: null == collectionScene
          ? _value.collectionScene
          : collectionScene // ignore: cast_nullable_to_non_nullable
              as int,
      collectionTerminal: null == collectionTerminal
          ? _value.collectionTerminal
          : collectionTerminal // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PayModeListRequestImplCopyWith<$Res>
    implements $PayModeListRequestCopyWith<$Res> {
  factory _$$PayModeListRequestImplCopyWith(_$PayModeListRequestImpl value,
          $Res Function(_$PayModeListRequestImpl) then) =
      __$$PayModeListRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'account_use') int accountUse,
      @JsonKey(name: 'is_match') int isMatch,
      @JsonKey(name: 'is_usable') int isUsable,
      int page,
      int size,
      @JsonKey(name: 'account_type') int accountType,
      @JsonKey(name: 'order_id') String orderId,
      @JsonKey(name: 'goods_ids') String goodsIds,
      @JsonKey(name: 'merchant_id') String merchantId,
      @JsonKey(name: 'brand_id') String brandId,
      @JsonKey(name: 'collection_scene') int collectionScene,
      @JsonKey(name: 'collection_terminal') int collectionTerminal});
}

/// @nodoc
class __$$PayModeListRequestImplCopyWithImpl<$Res>
    extends _$PayModeListRequestCopyWithImpl<$Res, _$PayModeListRequestImpl>
    implements _$$PayModeListRequestImplCopyWith<$Res> {
  __$$PayModeListRequestImplCopyWithImpl(_$PayModeListRequestImpl _value,
      $Res Function(_$PayModeListRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountUse = null,
    Object? isMatch = null,
    Object? isUsable = null,
    Object? page = null,
    Object? size = null,
    Object? accountType = null,
    Object? orderId = null,
    Object? goodsIds = null,
    Object? merchantId = null,
    Object? brandId = null,
    Object? collectionScene = null,
    Object? collectionTerminal = null,
  }) {
    return _then(_$PayModeListRequestImpl(
      accountUse: null == accountUse
          ? _value.accountUse
          : accountUse // ignore: cast_nullable_to_non_nullable
              as int,
      isMatch: null == isMatch
          ? _value.isMatch
          : isMatch // ignore: cast_nullable_to_non_nullable
              as int,
      isUsable: null == isUsable
          ? _value.isUsable
          : isUsable // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      accountType: null == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as int,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      goodsIds: null == goodsIds
          ? _value.goodsIds
          : goodsIds // ignore: cast_nullable_to_non_nullable
              as String,
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      brandId: null == brandId
          ? _value.brandId
          : brandId // ignore: cast_nullable_to_non_nullable
              as String,
      collectionScene: null == collectionScene
          ? _value.collectionScene
          : collectionScene // ignore: cast_nullable_to_non_nullable
              as int,
      collectionTerminal: null == collectionTerminal
          ? _value.collectionTerminal
          : collectionTerminal // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PayModeListRequestImpl implements _PayModeListRequest {
  const _$PayModeListRequestImpl(
      {@JsonKey(name: 'account_use') required this.accountUse,
      @JsonKey(name: 'is_match') required this.isMatch,
      @JsonKey(name: 'is_usable') required this.isUsable,
      required this.page,
      required this.size,
      @JsonKey(name: 'account_type') required this.accountType,
      @JsonKey(name: 'order_id') required this.orderId,
      @JsonKey(name: 'goods_ids') required this.goodsIds,
      @JsonKey(name: 'merchant_id') required this.merchantId,
      @JsonKey(name: 'brand_id') required this.brandId,
      @JsonKey(name: 'collection_scene') required this.collectionScene,
      @JsonKey(name: 'collection_terminal') required this.collectionTerminal});

  factory _$PayModeListRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PayModeListRequestImplFromJson(json);

  @override
  @JsonKey(name: 'account_use')
  final int accountUse;
// 1:收款 2:付款
  @override
  @JsonKey(name: 'is_match')
  final int isMatch;
  @override
  @JsonKey(name: 'is_usable')
  final int isUsable;
  @override
  final int page;
  @override
  final int size;
  @override
  @JsonKey(name: 'account_type')
  final int accountType;
// 1:线上支付 2:线下支付
  @override
  @JsonKey(name: 'order_id')
  final String orderId;
  @override
  @JsonKey(name: 'goods_ids')
  final String goodsIds;
  @override
  @JsonKey(name: 'merchant_id')
  final String merchantId;
  @override
  @JsonKey(name: 'brand_id')
  final String brandId;
  @override
  @JsonKey(name: 'collection_scene')
  final int collectionScene;
  @override
  @JsonKey(name: 'collection_terminal')
  final int collectionTerminal;

  @override
  String toString() {
    return 'PayModeListRequest(accountUse: $accountUse, isMatch: $isMatch, isUsable: $isUsable, page: $page, size: $size, accountType: $accountType, orderId: $orderId, goodsIds: $goodsIds, merchantId: $merchantId, brandId: $brandId, collectionScene: $collectionScene, collectionTerminal: $collectionTerminal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PayModeListRequestImpl &&
            (identical(other.accountUse, accountUse) ||
                other.accountUse == accountUse) &&
            (identical(other.isMatch, isMatch) || other.isMatch == isMatch) &&
            (identical(other.isUsable, isUsable) ||
                other.isUsable == isUsable) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.accountType, accountType) ||
                other.accountType == accountType) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.goodsIds, goodsIds) ||
                other.goodsIds == goodsIds) &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId) &&
            (identical(other.brandId, brandId) || other.brandId == brandId) &&
            (identical(other.collectionScene, collectionScene) ||
                other.collectionScene == collectionScene) &&
            (identical(other.collectionTerminal, collectionTerminal) ||
                other.collectionTerminal == collectionTerminal));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      accountUse,
      isMatch,
      isUsable,
      page,
      size,
      accountType,
      orderId,
      goodsIds,
      merchantId,
      brandId,
      collectionScene,
      collectionTerminal);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PayModeListRequestImplCopyWith<_$PayModeListRequestImpl> get copyWith =>
      __$$PayModeListRequestImplCopyWithImpl<_$PayModeListRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PayModeListRequestImplToJson(
      this,
    );
  }
}

abstract class _PayModeListRequest implements PayModeListRequest {
  const factory _PayModeListRequest(
      {@JsonKey(name: 'account_use') required final int accountUse,
      @JsonKey(name: 'is_match') required final int isMatch,
      @JsonKey(name: 'is_usable') required final int isUsable,
      required final int page,
      required final int size,
      @JsonKey(name: 'account_type') required final int accountType,
      @JsonKey(name: 'order_id') required final String orderId,
      @JsonKey(name: 'goods_ids') required final String goodsIds,
      @JsonKey(name: 'merchant_id') required final String merchantId,
      @JsonKey(name: 'brand_id') required final String brandId,
      @JsonKey(name: 'collection_scene') required final int collectionScene,
      @JsonKey(name: 'collection_terminal')
      required final int collectionTerminal}) = _$PayModeListRequestImpl;

  factory _PayModeListRequest.fromJson(Map<String, dynamic> json) =
      _$PayModeListRequestImpl.fromJson;

  @override
  @JsonKey(name: 'account_use')
  int get accountUse;
  @override // 1:收款 2:付款
  @JsonKey(name: 'is_match')
  int get isMatch;
  @override
  @JsonKey(name: 'is_usable')
  int get isUsable;
  @override
  int get page;
  @override
  int get size;
  @override
  @JsonKey(name: 'account_type')
  int get accountType;
  @override // 1:线上支付 2:线下支付
  @JsonKey(name: 'order_id')
  String get orderId;
  @override
  @JsonKey(name: 'goods_ids')
  String get goodsIds;
  @override
  @JsonKey(name: 'merchant_id')
  String get merchantId;
  @override
  @JsonKey(name: 'brand_id')
  String get brandId;
  @override
  @JsonKey(name: 'collection_scene')
  int get collectionScene;
  @override
  @JsonKey(name: 'collection_terminal')
  int get collectionTerminal;
  @override
  @JsonKey(ignore: true)
  _$$PayModeListRequestImplCopyWith<_$PayModeListRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PayModeItem _$PayModeItemFromJson(Map<String, dynamic> json) {
  return _PayModeItem.fromJson(json);
}

/// @nodoc
mixin _$PayModeItem {
  String get id => throw _privateConstructorUsedError; // 财务主体ID
  @JsonKey(name: 'pay_method')
  String? get payMethod => throw _privateConstructorUsedError; // 支付方式: 6=微信支付
  @JsonKey(name: 'wechat_pay_app_id')
  String? get wechatPayAppId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PayModeItemCopyWith<PayModeItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PayModeItemCopyWith<$Res> {
  factory $PayModeItemCopyWith(
          PayModeItem value, $Res Function(PayModeItem) then) =
      _$PayModeItemCopyWithImpl<$Res, PayModeItem>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'pay_method') String? payMethod,
      @JsonKey(name: 'wechat_pay_app_id') String? wechatPayAppId});
}

/// @nodoc
class _$PayModeItemCopyWithImpl<$Res, $Val extends PayModeItem>
    implements $PayModeItemCopyWith<$Res> {
  _$PayModeItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? payMethod = freezed,
    Object? wechatPayAppId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      payMethod: freezed == payMethod
          ? _value.payMethod
          : payMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      wechatPayAppId: freezed == wechatPayAppId
          ? _value.wechatPayAppId
          : wechatPayAppId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PayModeItemImplCopyWith<$Res>
    implements $PayModeItemCopyWith<$Res> {
  factory _$$PayModeItemImplCopyWith(
          _$PayModeItemImpl value, $Res Function(_$PayModeItemImpl) then) =
      __$$PayModeItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'pay_method') String? payMethod,
      @JsonKey(name: 'wechat_pay_app_id') String? wechatPayAppId});
}

/// @nodoc
class __$$PayModeItemImplCopyWithImpl<$Res>
    extends _$PayModeItemCopyWithImpl<$Res, _$PayModeItemImpl>
    implements _$$PayModeItemImplCopyWith<$Res> {
  __$$PayModeItemImplCopyWithImpl(
      _$PayModeItemImpl _value, $Res Function(_$PayModeItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? payMethod = freezed,
    Object? wechatPayAppId = freezed,
  }) {
    return _then(_$PayModeItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      payMethod: freezed == payMethod
          ? _value.payMethod
          : payMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      wechatPayAppId: freezed == wechatPayAppId
          ? _value.wechatPayAppId
          : wechatPayAppId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PayModeItemImpl implements _PayModeItem {
  const _$PayModeItemImpl(
      {required this.id,
      @JsonKey(name: 'pay_method') this.payMethod,
      @JsonKey(name: 'wechat_pay_app_id') this.wechatPayAppId});

  factory _$PayModeItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PayModeItemImplFromJson(json);

  @override
  final String id;
// 财务主体ID
  @override
  @JsonKey(name: 'pay_method')
  final String? payMethod;
// 支付方式: 6=微信支付
  @override
  @JsonKey(name: 'wechat_pay_app_id')
  final String? wechatPayAppId;

  @override
  String toString() {
    return 'PayModeItem(id: $id, payMethod: $payMethod, wechatPayAppId: $wechatPayAppId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PayModeItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.payMethod, payMethod) ||
                other.payMethod == payMethod) &&
            (identical(other.wechatPayAppId, wechatPayAppId) ||
                other.wechatPayAppId == wechatPayAppId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, payMethod, wechatPayAppId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PayModeItemImplCopyWith<_$PayModeItemImpl> get copyWith =>
      __$$PayModeItemImplCopyWithImpl<_$PayModeItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PayModeItemImplToJson(
      this,
    );
  }
}

abstract class _PayModeItem implements PayModeItem {
  const factory _PayModeItem(
          {required final String id,
          @JsonKey(name: 'pay_method') final String? payMethod,
          @JsonKey(name: 'wechat_pay_app_id') final String? wechatPayAppId}) =
      _$PayModeItemImpl;

  factory _PayModeItem.fromJson(Map<String, dynamic> json) =
      _$PayModeItemImpl.fromJson;

  @override
  String get id;
  @override // 财务主体ID
  @JsonKey(name: 'pay_method')
  String? get payMethod;
  @override // 支付方式: 6=微信支付
  @JsonKey(name: 'wechat_pay_app_id')
  String? get wechatPayAppId;
  @override
  @JsonKey(ignore: true)
  _$$PayModeItemImplCopyWith<_$PayModeItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WechatPayRequest _$WechatPayRequestFromJson(Map<String, dynamic> json) {
  return _WechatPayRequest.fromJson(json);
}

/// @nodoc
mixin _$WechatPayRequest {
  @JsonKey(name: 'flow_id')
  String get flowId => throw _privateConstructorUsedError;
  @JsonKey(name: 'wechat_app_id')
  String get wechatAppId => throw _privateConstructorUsedError;
  @JsonKey(name: 'open_id')
  String get openId => throw _privateConstructorUsedError;
  @JsonKey(name: 'finance_body_id')
  String get financeBodyId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WechatPayRequestCopyWith<WechatPayRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WechatPayRequestCopyWith<$Res> {
  factory $WechatPayRequestCopyWith(
          WechatPayRequest value, $Res Function(WechatPayRequest) then) =
      _$WechatPayRequestCopyWithImpl<$Res, WechatPayRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'flow_id') String flowId,
      @JsonKey(name: 'wechat_app_id') String wechatAppId,
      @JsonKey(name: 'open_id') String openId,
      @JsonKey(name: 'finance_body_id') String financeBodyId});
}

/// @nodoc
class _$WechatPayRequestCopyWithImpl<$Res, $Val extends WechatPayRequest>
    implements $WechatPayRequestCopyWith<$Res> {
  _$WechatPayRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flowId = null,
    Object? wechatAppId = null,
    Object? openId = null,
    Object? financeBodyId = null,
  }) {
    return _then(_value.copyWith(
      flowId: null == flowId
          ? _value.flowId
          : flowId // ignore: cast_nullable_to_non_nullable
              as String,
      wechatAppId: null == wechatAppId
          ? _value.wechatAppId
          : wechatAppId // ignore: cast_nullable_to_non_nullable
              as String,
      openId: null == openId
          ? _value.openId
          : openId // ignore: cast_nullable_to_non_nullable
              as String,
      financeBodyId: null == financeBodyId
          ? _value.financeBodyId
          : financeBodyId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WechatPayRequestImplCopyWith<$Res>
    implements $WechatPayRequestCopyWith<$Res> {
  factory _$$WechatPayRequestImplCopyWith(_$WechatPayRequestImpl value,
          $Res Function(_$WechatPayRequestImpl) then) =
      __$$WechatPayRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'flow_id') String flowId,
      @JsonKey(name: 'wechat_app_id') String wechatAppId,
      @JsonKey(name: 'open_id') String openId,
      @JsonKey(name: 'finance_body_id') String financeBodyId});
}

/// @nodoc
class __$$WechatPayRequestImplCopyWithImpl<$Res>
    extends _$WechatPayRequestCopyWithImpl<$Res, _$WechatPayRequestImpl>
    implements _$$WechatPayRequestImplCopyWith<$Res> {
  __$$WechatPayRequestImplCopyWithImpl(_$WechatPayRequestImpl _value,
      $Res Function(_$WechatPayRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flowId = null,
    Object? wechatAppId = null,
    Object? openId = null,
    Object? financeBodyId = null,
  }) {
    return _then(_$WechatPayRequestImpl(
      flowId: null == flowId
          ? _value.flowId
          : flowId // ignore: cast_nullable_to_non_nullable
              as String,
      wechatAppId: null == wechatAppId
          ? _value.wechatAppId
          : wechatAppId // ignore: cast_nullable_to_non_nullable
              as String,
      openId: null == openId
          ? _value.openId
          : openId // ignore: cast_nullable_to_non_nullable
              as String,
      financeBodyId: null == financeBodyId
          ? _value.financeBodyId
          : financeBodyId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WechatPayRequestImpl implements _WechatPayRequest {
  const _$WechatPayRequestImpl(
      {@JsonKey(name: 'flow_id') required this.flowId,
      @JsonKey(name: 'wechat_app_id') required this.wechatAppId,
      @JsonKey(name: 'open_id') required this.openId,
      @JsonKey(name: 'finance_body_id') required this.financeBodyId});

  factory _$WechatPayRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$WechatPayRequestImplFromJson(json);

  @override
  @JsonKey(name: 'flow_id')
  final String flowId;
  @override
  @JsonKey(name: 'wechat_app_id')
  final String wechatAppId;
  @override
  @JsonKey(name: 'open_id')
  final String openId;
  @override
  @JsonKey(name: 'finance_body_id')
  final String financeBodyId;

  @override
  String toString() {
    return 'WechatPayRequest(flowId: $flowId, wechatAppId: $wechatAppId, openId: $openId, financeBodyId: $financeBodyId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WechatPayRequestImpl &&
            (identical(other.flowId, flowId) || other.flowId == flowId) &&
            (identical(other.wechatAppId, wechatAppId) ||
                other.wechatAppId == wechatAppId) &&
            (identical(other.openId, openId) || other.openId == openId) &&
            (identical(other.financeBodyId, financeBodyId) ||
                other.financeBodyId == financeBodyId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, flowId, wechatAppId, openId, financeBodyId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WechatPayRequestImplCopyWith<_$WechatPayRequestImpl> get copyWith =>
      __$$WechatPayRequestImplCopyWithImpl<_$WechatPayRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WechatPayRequestImplToJson(
      this,
    );
  }
}

abstract class _WechatPayRequest implements WechatPayRequest {
  const factory _WechatPayRequest(
      {@JsonKey(name: 'flow_id') required final String flowId,
      @JsonKey(name: 'wechat_app_id') required final String wechatAppId,
      @JsonKey(name: 'open_id') required final String openId,
      @JsonKey(name: 'finance_body_id')
      required final String financeBodyId}) = _$WechatPayRequestImpl;

  factory _WechatPayRequest.fromJson(Map<String, dynamic> json) =
      _$WechatPayRequestImpl.fromJson;

  @override
  @JsonKey(name: 'flow_id')
  String get flowId;
  @override
  @JsonKey(name: 'wechat_app_id')
  String get wechatAppId;
  @override
  @JsonKey(name: 'open_id')
  String get openId;
  @override
  @JsonKey(name: 'finance_body_id')
  String get financeBodyId;
  @override
  @JsonKey(ignore: true)
  _$$WechatPayRequestImplCopyWith<_$WechatPayRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WechatPayResponse _$WechatPayResponseFromJson(Map<String, dynamic> json) {
  return _WechatPayResponse.fromJson(json);
}

/// @nodoc
mixin _$WechatPayResponse {
  @JsonKey(name: 'time_stamp')
  String get timeStamp => throw _privateConstructorUsedError;
  @JsonKey(name: 'nonce_str')
  String get nonceStr => throw _privateConstructorUsedError;
  @JsonKey(name: 'sign_type')
  String get signType => throw _privateConstructorUsedError;
  @JsonKey(name: 'pay_sign')
  String get paySign => throw _privateConstructorUsedError;
  String get package => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WechatPayResponseCopyWith<WechatPayResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WechatPayResponseCopyWith<$Res> {
  factory $WechatPayResponseCopyWith(
          WechatPayResponse value, $Res Function(WechatPayResponse) then) =
      _$WechatPayResponseCopyWithImpl<$Res, WechatPayResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'time_stamp') String timeStamp,
      @JsonKey(name: 'nonce_str') String nonceStr,
      @JsonKey(name: 'sign_type') String signType,
      @JsonKey(name: 'pay_sign') String paySign,
      String package});
}

/// @nodoc
class _$WechatPayResponseCopyWithImpl<$Res, $Val extends WechatPayResponse>
    implements $WechatPayResponseCopyWith<$Res> {
  _$WechatPayResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timeStamp = null,
    Object? nonceStr = null,
    Object? signType = null,
    Object? paySign = null,
    Object? package = null,
  }) {
    return _then(_value.copyWith(
      timeStamp: null == timeStamp
          ? _value.timeStamp
          : timeStamp // ignore: cast_nullable_to_non_nullable
              as String,
      nonceStr: null == nonceStr
          ? _value.nonceStr
          : nonceStr // ignore: cast_nullable_to_non_nullable
              as String,
      signType: null == signType
          ? _value.signType
          : signType // ignore: cast_nullable_to_non_nullable
              as String,
      paySign: null == paySign
          ? _value.paySign
          : paySign // ignore: cast_nullable_to_non_nullable
              as String,
      package: null == package
          ? _value.package
          : package // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WechatPayResponseImplCopyWith<$Res>
    implements $WechatPayResponseCopyWith<$Res> {
  factory _$$WechatPayResponseImplCopyWith(_$WechatPayResponseImpl value,
          $Res Function(_$WechatPayResponseImpl) then) =
      __$$WechatPayResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'time_stamp') String timeStamp,
      @JsonKey(name: 'nonce_str') String nonceStr,
      @JsonKey(name: 'sign_type') String signType,
      @JsonKey(name: 'pay_sign') String paySign,
      String package});
}

/// @nodoc
class __$$WechatPayResponseImplCopyWithImpl<$Res>
    extends _$WechatPayResponseCopyWithImpl<$Res, _$WechatPayResponseImpl>
    implements _$$WechatPayResponseImplCopyWith<$Res> {
  __$$WechatPayResponseImplCopyWithImpl(_$WechatPayResponseImpl _value,
      $Res Function(_$WechatPayResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timeStamp = null,
    Object? nonceStr = null,
    Object? signType = null,
    Object? paySign = null,
    Object? package = null,
  }) {
    return _then(_$WechatPayResponseImpl(
      timeStamp: null == timeStamp
          ? _value.timeStamp
          : timeStamp // ignore: cast_nullable_to_non_nullable
              as String,
      nonceStr: null == nonceStr
          ? _value.nonceStr
          : nonceStr // ignore: cast_nullable_to_non_nullable
              as String,
      signType: null == signType
          ? _value.signType
          : signType // ignore: cast_nullable_to_non_nullable
              as String,
      paySign: null == paySign
          ? _value.paySign
          : paySign // ignore: cast_nullable_to_non_nullable
              as String,
      package: null == package
          ? _value.package
          : package // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WechatPayResponseImpl implements _WechatPayResponse {
  const _$WechatPayResponseImpl(
      {@JsonKey(name: 'time_stamp') required this.timeStamp,
      @JsonKey(name: 'nonce_str') required this.nonceStr,
      @JsonKey(name: 'sign_type') required this.signType,
      @JsonKey(name: 'pay_sign') required this.paySign,
      required this.package});

  factory _$WechatPayResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$WechatPayResponseImplFromJson(json);

  @override
  @JsonKey(name: 'time_stamp')
  final String timeStamp;
  @override
  @JsonKey(name: 'nonce_str')
  final String nonceStr;
  @override
  @JsonKey(name: 'sign_type')
  final String signType;
  @override
  @JsonKey(name: 'pay_sign')
  final String paySign;
  @override
  final String package;

  @override
  String toString() {
    return 'WechatPayResponse(timeStamp: $timeStamp, nonceStr: $nonceStr, signType: $signType, paySign: $paySign, package: $package)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WechatPayResponseImpl &&
            (identical(other.timeStamp, timeStamp) ||
                other.timeStamp == timeStamp) &&
            (identical(other.nonceStr, nonceStr) ||
                other.nonceStr == nonceStr) &&
            (identical(other.signType, signType) ||
                other.signType == signType) &&
            (identical(other.paySign, paySign) || other.paySign == paySign) &&
            (identical(other.package, package) || other.package == package));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, timeStamp, nonceStr, signType, paySign, package);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WechatPayResponseImplCopyWith<_$WechatPayResponseImpl> get copyWith =>
      __$$WechatPayResponseImplCopyWithImpl<_$WechatPayResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WechatPayResponseImplToJson(
      this,
    );
  }
}

abstract class _WechatPayResponse implements WechatPayResponse {
  const factory _WechatPayResponse(
      {@JsonKey(name: 'time_stamp') required final String timeStamp,
      @JsonKey(name: 'nonce_str') required final String nonceStr,
      @JsonKey(name: 'sign_type') required final String signType,
      @JsonKey(name: 'pay_sign') required final String paySign,
      required final String package}) = _$WechatPayResponseImpl;

  factory _WechatPayResponse.fromJson(Map<String, dynamic> json) =
      _$WechatPayResponseImpl.fromJson;

  @override
  @JsonKey(name: 'time_stamp')
  String get timeStamp;
  @override
  @JsonKey(name: 'nonce_str')
  String get nonceStr;
  @override
  @JsonKey(name: 'sign_type')
  String get signType;
  @override
  @JsonKey(name: 'pay_sign')
  String get paySign;
  @override
  String get package;
  @override
  @JsonKey(ignore: true)
  _$$WechatPayResponseImplCopyWith<_$WechatPayResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
