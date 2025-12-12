// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'live_url_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LiveUrlResponse _$LiveUrlResponseFromJson(Map<String, dynamic> json) {
  return _LiveUrlResponse.fromJson(json);
}

/// @nodoc
mixin _$LiveUrlResponse {
  /// 直播地址 (有值表示直播进行中或未开始)
  @JsonKey(name: 'live_url')
  String? get liveUrl => throw _privateConstructorUsedError;

  /// 回放地址 (有值表示直播已结束，可观看回放)
  @JsonKey(name: 'playback_url')
  String? get playbackUrl => throw _privateConstructorUsedError;

  /// 商品ID
  @JsonKey(name: 'goods_id')
  String? get goodsId => throw _privateConstructorUsedError;

  /// 课节ID
  @JsonKey(name: 'lesson_id')
  String? get lessonId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LiveUrlResponseCopyWith<LiveUrlResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LiveUrlResponseCopyWith<$Res> {
  factory $LiveUrlResponseCopyWith(
          LiveUrlResponse value, $Res Function(LiveUrlResponse) then) =
      _$LiveUrlResponseCopyWithImpl<$Res, LiveUrlResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'live_url') String? liveUrl,
      @JsonKey(name: 'playback_url') String? playbackUrl,
      @JsonKey(name: 'goods_id') String? goodsId,
      @JsonKey(name: 'lesson_id') String? lessonId});
}

/// @nodoc
class _$LiveUrlResponseCopyWithImpl<$Res, $Val extends LiveUrlResponse>
    implements $LiveUrlResponseCopyWith<$Res> {
  _$LiveUrlResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? liveUrl = freezed,
    Object? playbackUrl = freezed,
    Object? goodsId = freezed,
    Object? lessonId = freezed,
  }) {
    return _then(_value.copyWith(
      liveUrl: freezed == liveUrl
          ? _value.liveUrl
          : liveUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      playbackUrl: freezed == playbackUrl
          ? _value.playbackUrl
          : playbackUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      goodsId: freezed == goodsId
          ? _value.goodsId
          : goodsId // ignore: cast_nullable_to_non_nullable
              as String?,
      lessonId: freezed == lessonId
          ? _value.lessonId
          : lessonId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LiveUrlResponseImplCopyWith<$Res>
    implements $LiveUrlResponseCopyWith<$Res> {
  factory _$$LiveUrlResponseImplCopyWith(_$LiveUrlResponseImpl value,
          $Res Function(_$LiveUrlResponseImpl) then) =
      __$$LiveUrlResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'live_url') String? liveUrl,
      @JsonKey(name: 'playback_url') String? playbackUrl,
      @JsonKey(name: 'goods_id') String? goodsId,
      @JsonKey(name: 'lesson_id') String? lessonId});
}

/// @nodoc
class __$$LiveUrlResponseImplCopyWithImpl<$Res>
    extends _$LiveUrlResponseCopyWithImpl<$Res, _$LiveUrlResponseImpl>
    implements _$$LiveUrlResponseImplCopyWith<$Res> {
  __$$LiveUrlResponseImplCopyWithImpl(
      _$LiveUrlResponseImpl _value, $Res Function(_$LiveUrlResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? liveUrl = freezed,
    Object? playbackUrl = freezed,
    Object? goodsId = freezed,
    Object? lessonId = freezed,
  }) {
    return _then(_$LiveUrlResponseImpl(
      liveUrl: freezed == liveUrl
          ? _value.liveUrl
          : liveUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      playbackUrl: freezed == playbackUrl
          ? _value.playbackUrl
          : playbackUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      goodsId: freezed == goodsId
          ? _value.goodsId
          : goodsId // ignore: cast_nullable_to_non_nullable
              as String?,
      lessonId: freezed == lessonId
          ? _value.lessonId
          : lessonId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LiveUrlResponseImpl implements _LiveUrlResponse {
  const _$LiveUrlResponseImpl(
      {@JsonKey(name: 'live_url') this.liveUrl,
      @JsonKey(name: 'playback_url') this.playbackUrl,
      @JsonKey(name: 'goods_id') this.goodsId,
      @JsonKey(name: 'lesson_id') this.lessonId});

  factory _$LiveUrlResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LiveUrlResponseImplFromJson(json);

  /// 直播地址 (有值表示直播进行中或未开始)
  @override
  @JsonKey(name: 'live_url')
  final String? liveUrl;

  /// 回放地址 (有值表示直播已结束，可观看回放)
  @override
  @JsonKey(name: 'playback_url')
  final String? playbackUrl;

  /// 商品ID
  @override
  @JsonKey(name: 'goods_id')
  final String? goodsId;

  /// 课节ID
  @override
  @JsonKey(name: 'lesson_id')
  final String? lessonId;

  @override
  String toString() {
    return 'LiveUrlResponse(liveUrl: $liveUrl, playbackUrl: $playbackUrl, goodsId: $goodsId, lessonId: $lessonId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LiveUrlResponseImpl &&
            (identical(other.liveUrl, liveUrl) || other.liveUrl == liveUrl) &&
            (identical(other.playbackUrl, playbackUrl) ||
                other.playbackUrl == playbackUrl) &&
            (identical(other.goodsId, goodsId) || other.goodsId == goodsId) &&
            (identical(other.lessonId, lessonId) ||
                other.lessonId == lessonId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, liveUrl, playbackUrl, goodsId, lessonId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LiveUrlResponseImplCopyWith<_$LiveUrlResponseImpl> get copyWith =>
      __$$LiveUrlResponseImplCopyWithImpl<_$LiveUrlResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LiveUrlResponseImplToJson(
      this,
    );
  }
}

abstract class _LiveUrlResponse implements LiveUrlResponse {
  const factory _LiveUrlResponse(
          {@JsonKey(name: 'live_url') final String? liveUrl,
          @JsonKey(name: 'playback_url') final String? playbackUrl,
          @JsonKey(name: 'goods_id') final String? goodsId,
          @JsonKey(name: 'lesson_id') final String? lessonId}) =
      _$LiveUrlResponseImpl;

  factory _LiveUrlResponse.fromJson(Map<String, dynamic> json) =
      _$LiveUrlResponseImpl.fromJson;

  @override

  /// 直播地址 (有值表示直播进行中或未开始)
  @JsonKey(name: 'live_url')
  String? get liveUrl;
  @override

  /// 回放地址 (有值表示直播已结束，可观看回放)
  @JsonKey(name: 'playback_url')
  String? get playbackUrl;
  @override

  /// 商品ID
  @JsonKey(name: 'goods_id')
  String? get goodsId;
  @override

  /// 课节ID
  @JsonKey(name: 'lesson_id')
  String? get lessonId;
  @override
  @JsonKey(ignore: true)
  _$$LiveUrlResponseImplCopyWith<_$LiveUrlResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
