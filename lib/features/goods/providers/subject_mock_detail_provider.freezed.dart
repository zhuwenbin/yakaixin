// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subject_mock_detail_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SubjectMockDetailState {
  GoodsDetailModel? get goodsDetail => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  int get activePriceIndex => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SubjectMockDetailStateCopyWith<SubjectMockDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubjectMockDetailStateCopyWith<$Res> {
  factory $SubjectMockDetailStateCopyWith(SubjectMockDetailState value,
          $Res Function(SubjectMockDetailState) then) =
      _$SubjectMockDetailStateCopyWithImpl<$Res, SubjectMockDetailState>;
  @useResult
  $Res call(
      {GoodsDetailModel? goodsDetail,
      bool isLoading,
      String? error,
      int activePriceIndex});

  $GoodsDetailModelCopyWith<$Res>? get goodsDetail;
}

/// @nodoc
class _$SubjectMockDetailStateCopyWithImpl<$Res,
        $Val extends SubjectMockDetailState>
    implements $SubjectMockDetailStateCopyWith<$Res> {
  _$SubjectMockDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goodsDetail = freezed,
    Object? isLoading = null,
    Object? error = freezed,
    Object? activePriceIndex = null,
  }) {
    return _then(_value.copyWith(
      goodsDetail: freezed == goodsDetail
          ? _value.goodsDetail
          : goodsDetail // ignore: cast_nullable_to_non_nullable
              as GoodsDetailModel?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      activePriceIndex: null == activePriceIndex
          ? _value.activePriceIndex
          : activePriceIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $GoodsDetailModelCopyWith<$Res>? get goodsDetail {
    if (_value.goodsDetail == null) {
      return null;
    }

    return $GoodsDetailModelCopyWith<$Res>(_value.goodsDetail!, (value) {
      return _then(_value.copyWith(goodsDetail: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SubjectMockDetailStateImplCopyWith<$Res>
    implements $SubjectMockDetailStateCopyWith<$Res> {
  factory _$$SubjectMockDetailStateImplCopyWith(
          _$SubjectMockDetailStateImpl value,
          $Res Function(_$SubjectMockDetailStateImpl) then) =
      __$$SubjectMockDetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {GoodsDetailModel? goodsDetail,
      bool isLoading,
      String? error,
      int activePriceIndex});

  @override
  $GoodsDetailModelCopyWith<$Res>? get goodsDetail;
}

/// @nodoc
class __$$SubjectMockDetailStateImplCopyWithImpl<$Res>
    extends _$SubjectMockDetailStateCopyWithImpl<$Res,
        _$SubjectMockDetailStateImpl>
    implements _$$SubjectMockDetailStateImplCopyWith<$Res> {
  __$$SubjectMockDetailStateImplCopyWithImpl(
      _$SubjectMockDetailStateImpl _value,
      $Res Function(_$SubjectMockDetailStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goodsDetail = freezed,
    Object? isLoading = null,
    Object? error = freezed,
    Object? activePriceIndex = null,
  }) {
    return _then(_$SubjectMockDetailStateImpl(
      goodsDetail: freezed == goodsDetail
          ? _value.goodsDetail
          : goodsDetail // ignore: cast_nullable_to_non_nullable
              as GoodsDetailModel?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      activePriceIndex: null == activePriceIndex
          ? _value.activePriceIndex
          : activePriceIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$SubjectMockDetailStateImpl implements _SubjectMockDetailState {
  const _$SubjectMockDetailStateImpl(
      {this.goodsDetail,
      this.isLoading = false,
      this.error,
      this.activePriceIndex = 0});

  @override
  final GoodsDetailModel? goodsDetail;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
  @override
  @JsonKey()
  final int activePriceIndex;

  @override
  String toString() {
    return 'SubjectMockDetailState(goodsDetail: $goodsDetail, isLoading: $isLoading, error: $error, activePriceIndex: $activePriceIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubjectMockDetailStateImpl &&
            (identical(other.goodsDetail, goodsDetail) ||
                other.goodsDetail == goodsDetail) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.activePriceIndex, activePriceIndex) ||
                other.activePriceIndex == activePriceIndex));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, goodsDetail, isLoading, error, activePriceIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SubjectMockDetailStateImplCopyWith<_$SubjectMockDetailStateImpl>
      get copyWith => __$$SubjectMockDetailStateImplCopyWithImpl<
          _$SubjectMockDetailStateImpl>(this, _$identity);
}

abstract class _SubjectMockDetailState implements SubjectMockDetailState {
  const factory _SubjectMockDetailState(
      {final GoodsDetailModel? goodsDetail,
      final bool isLoading,
      final String? error,
      final int activePriceIndex}) = _$SubjectMockDetailStateImpl;

  @override
  GoodsDetailModel? get goodsDetail;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  int get activePriceIndex;
  @override
  @JsonKey(ignore: true)
  _$$SubjectMockDetailStateImplCopyWith<_$SubjectMockDetailStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
