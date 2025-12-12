// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wechat_pay_params_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WechatPayParamsModel _$WechatPayParamsModelFromJson(Map<String, dynamic> json) {
  return _WechatPayParamsModel.fromJson(json);
}

/// @nodoc
mixin _$WechatPayParamsModel {
  /// 微信应用ID
  @JsonKey(name: 'app_id')
  String get appId => throw _privateConstructorUsedError;

  /// 商户号
  @JsonKey(name: 'partner_id')
  String get partnerId => throw _privateConstructorUsedError;

  /// 预支付交易会话ID
  @JsonKey(name: 'prepay_id')
  String get prepayId => throw _privateConstructorUsedError;

  /// 扩展字段
  @JsonKey(name: 'package')
  String get package => throw _privateConstructorUsedError;

  /// 随机字符串
  @JsonKey(name: 'nonce_str')
  String get nonceStr => throw _privateConstructorUsedError;

  /// 时间戳
  @JsonKey(name: 'time_stamp')
  String get timeStamp => throw _privateConstructorUsedError;

  /// 签名
  String get sign => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WechatPayParamsModelCopyWith<WechatPayParamsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WechatPayParamsModelCopyWith<$Res> {
  factory $WechatPayParamsModelCopyWith(WechatPayParamsModel value,
          $Res Function(WechatPayParamsModel) then) =
      _$WechatPayParamsModelCopyWithImpl<$Res, WechatPayParamsModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'app_id') String appId,
      @JsonKey(name: 'partner_id') String partnerId,
      @JsonKey(name: 'prepay_id') String prepayId,
      @JsonKey(name: 'package') String package,
      @JsonKey(name: 'nonce_str') String nonceStr,
      @JsonKey(name: 'time_stamp') String timeStamp,
      String sign});
}

/// @nodoc
class _$WechatPayParamsModelCopyWithImpl<$Res,
        $Val extends WechatPayParamsModel>
    implements $WechatPayParamsModelCopyWith<$Res> {
  _$WechatPayParamsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appId = null,
    Object? partnerId = null,
    Object? prepayId = null,
    Object? package = null,
    Object? nonceStr = null,
    Object? timeStamp = null,
    Object? sign = null,
  }) {
    return _then(_value.copyWith(
      appId: null == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String,
      partnerId: null == partnerId
          ? _value.partnerId
          : partnerId // ignore: cast_nullable_to_non_nullable
              as String,
      prepayId: null == prepayId
          ? _value.prepayId
          : prepayId // ignore: cast_nullable_to_non_nullable
              as String,
      package: null == package
          ? _value.package
          : package // ignore: cast_nullable_to_non_nullable
              as String,
      nonceStr: null == nonceStr
          ? _value.nonceStr
          : nonceStr // ignore: cast_nullable_to_non_nullable
              as String,
      timeStamp: null == timeStamp
          ? _value.timeStamp
          : timeStamp // ignore: cast_nullable_to_non_nullable
              as String,
      sign: null == sign
          ? _value.sign
          : sign // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WechatPayParamsModelImplCopyWith<$Res>
    implements $WechatPayParamsModelCopyWith<$Res> {
  factory _$$WechatPayParamsModelImplCopyWith(_$WechatPayParamsModelImpl value,
          $Res Function(_$WechatPayParamsModelImpl) then) =
      __$$WechatPayParamsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'app_id') String appId,
      @JsonKey(name: 'partner_id') String partnerId,
      @JsonKey(name: 'prepay_id') String prepayId,
      @JsonKey(name: 'package') String package,
      @JsonKey(name: 'nonce_str') String nonceStr,
      @JsonKey(name: 'time_stamp') String timeStamp,
      String sign});
}

/// @nodoc
class __$$WechatPayParamsModelImplCopyWithImpl<$Res>
    extends _$WechatPayParamsModelCopyWithImpl<$Res, _$WechatPayParamsModelImpl>
    implements _$$WechatPayParamsModelImplCopyWith<$Res> {
  __$$WechatPayParamsModelImplCopyWithImpl(_$WechatPayParamsModelImpl _value,
      $Res Function(_$WechatPayParamsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appId = null,
    Object? partnerId = null,
    Object? prepayId = null,
    Object? package = null,
    Object? nonceStr = null,
    Object? timeStamp = null,
    Object? sign = null,
  }) {
    return _then(_$WechatPayParamsModelImpl(
      appId: null == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String,
      partnerId: null == partnerId
          ? _value.partnerId
          : partnerId // ignore: cast_nullable_to_non_nullable
              as String,
      prepayId: null == prepayId
          ? _value.prepayId
          : prepayId // ignore: cast_nullable_to_non_nullable
              as String,
      package: null == package
          ? _value.package
          : package // ignore: cast_nullable_to_non_nullable
              as String,
      nonceStr: null == nonceStr
          ? _value.nonceStr
          : nonceStr // ignore: cast_nullable_to_non_nullable
              as String,
      timeStamp: null == timeStamp
          ? _value.timeStamp
          : timeStamp // ignore: cast_nullable_to_non_nullable
              as String,
      sign: null == sign
          ? _value.sign
          : sign // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WechatPayParamsModelImpl implements _WechatPayParamsModel {
  const _$WechatPayParamsModelImpl(
      {@JsonKey(name: 'app_id') required this.appId,
      @JsonKey(name: 'partner_id') required this.partnerId,
      @JsonKey(name: 'prepay_id') required this.prepayId,
      @JsonKey(name: 'package') this.package = 'Sign=WXPay',
      @JsonKey(name: 'nonce_str') required this.nonceStr,
      @JsonKey(name: 'time_stamp') required this.timeStamp,
      required this.sign});

  factory _$WechatPayParamsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WechatPayParamsModelImplFromJson(json);

  /// 微信应用ID
  @override
  @JsonKey(name: 'app_id')
  final String appId;

  /// 商户号
  @override
  @JsonKey(name: 'partner_id')
  final String partnerId;

  /// 预支付交易会话ID
  @override
  @JsonKey(name: 'prepay_id')
  final String prepayId;

  /// 扩展字段
  @override
  @JsonKey(name: 'package')
  final String package;

  /// 随机字符串
  @override
  @JsonKey(name: 'nonce_str')
  final String nonceStr;

  /// 时间戳
  @override
  @JsonKey(name: 'time_stamp')
  final String timeStamp;

  /// 签名
  @override
  final String sign;

  @override
  String toString() {
    return 'WechatPayParamsModel(appId: $appId, partnerId: $partnerId, prepayId: $prepayId, package: $package, nonceStr: $nonceStr, timeStamp: $timeStamp, sign: $sign)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WechatPayParamsModelImpl &&
            (identical(other.appId, appId) || other.appId == appId) &&
            (identical(other.partnerId, partnerId) ||
                other.partnerId == partnerId) &&
            (identical(other.prepayId, prepayId) ||
                other.prepayId == prepayId) &&
            (identical(other.package, package) || other.package == package) &&
            (identical(other.nonceStr, nonceStr) ||
                other.nonceStr == nonceStr) &&
            (identical(other.timeStamp, timeStamp) ||
                other.timeStamp == timeStamp) &&
            (identical(other.sign, sign) || other.sign == sign));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, appId, partnerId, prepayId,
      package, nonceStr, timeStamp, sign);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WechatPayParamsModelImplCopyWith<_$WechatPayParamsModelImpl>
      get copyWith =>
          __$$WechatPayParamsModelImplCopyWithImpl<_$WechatPayParamsModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WechatPayParamsModelImplToJson(
      this,
    );
  }
}

abstract class _WechatPayParamsModel implements WechatPayParamsModel {
  const factory _WechatPayParamsModel(
      {@JsonKey(name: 'app_id') required final String appId,
      @JsonKey(name: 'partner_id') required final String partnerId,
      @JsonKey(name: 'prepay_id') required final String prepayId,
      @JsonKey(name: 'package') final String package,
      @JsonKey(name: 'nonce_str') required final String nonceStr,
      @JsonKey(name: 'time_stamp') required final String timeStamp,
      required final String sign}) = _$WechatPayParamsModelImpl;

  factory _WechatPayParamsModel.fromJson(Map<String, dynamic> json) =
      _$WechatPayParamsModelImpl.fromJson;

  @override

  /// 微信应用ID
  @JsonKey(name: 'app_id')
  String get appId;
  @override

  /// 商户号
  @JsonKey(name: 'partner_id')
  String get partnerId;
  @override

  /// 预支付交易会话ID
  @JsonKey(name: 'prepay_id')
  String get prepayId;
  @override

  /// 扩展字段
  @JsonKey(name: 'package')
  String get package;
  @override

  /// 随机字符串
  @JsonKey(name: 'nonce_str')
  String get nonceStr;
  @override

  /// 时间戳
  @JsonKey(name: 'time_stamp')
  String get timeStamp;
  @override

  /// 签名
  String get sign;
  @override
  @JsonKey(ignore: true)
  _$$WechatPayParamsModelImplCopyWith<_$WechatPayParamsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
