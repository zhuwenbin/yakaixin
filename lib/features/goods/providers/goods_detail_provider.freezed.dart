// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goods_detail_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GoodsDetailState {
  GoodsDetailModel? get goodsDetail => throw _privateConstructorUsedError;
  int get selectedPriceIndex => throw _privateConstructorUsedError; // 当前选择的价格索引
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GoodsDetailStateCopyWith<GoodsDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoodsDetailStateCopyWith<$Res> {
  factory $GoodsDetailStateCopyWith(
          GoodsDetailState value, $Res Function(GoodsDetailState) then) =
      _$GoodsDetailStateCopyWithImpl<$Res, GoodsDetailState>;
  @useResult
  $Res call(
      {GoodsDetailModel? goodsDetail,
      int selectedPriceIndex,
      bool isLoading,
      String? error});

  $GoodsDetailModelCopyWith<$Res>? get goodsDetail;
}

/// @nodoc
class _$GoodsDetailStateCopyWithImpl<$Res, $Val extends GoodsDetailState>
    implements $GoodsDetailStateCopyWith<$Res> {
  _$GoodsDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goodsDetail = freezed,
    Object? selectedPriceIndex = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      goodsDetail: freezed == goodsDetail
          ? _value.goodsDetail
          : goodsDetail // ignore: cast_nullable_to_non_nullable
              as GoodsDetailModel?,
      selectedPriceIndex: null == selectedPriceIndex
          ? _value.selectedPriceIndex
          : selectedPriceIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$GoodsDetailStateImplCopyWith<$Res>
    implements $GoodsDetailStateCopyWith<$Res> {
  factory _$$GoodsDetailStateImplCopyWith(_$GoodsDetailStateImpl value,
          $Res Function(_$GoodsDetailStateImpl) then) =
      __$$GoodsDetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {GoodsDetailModel? goodsDetail,
      int selectedPriceIndex,
      bool isLoading,
      String? error});

  @override
  $GoodsDetailModelCopyWith<$Res>? get goodsDetail;
}

/// @nodoc
class __$$GoodsDetailStateImplCopyWithImpl<$Res>
    extends _$GoodsDetailStateCopyWithImpl<$Res, _$GoodsDetailStateImpl>
    implements _$$GoodsDetailStateImplCopyWith<$Res> {
  __$$GoodsDetailStateImplCopyWithImpl(_$GoodsDetailStateImpl _value,
      $Res Function(_$GoodsDetailStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goodsDetail = freezed,
    Object? selectedPriceIndex = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$GoodsDetailStateImpl(
      goodsDetail: freezed == goodsDetail
          ? _value.goodsDetail
          : goodsDetail // ignore: cast_nullable_to_non_nullable
              as GoodsDetailModel?,
      selectedPriceIndex: null == selectedPriceIndex
          ? _value.selectedPriceIndex
          : selectedPriceIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$GoodsDetailStateImpl implements _GoodsDetailState {
  const _$GoodsDetailStateImpl(
      {this.goodsDetail,
      this.selectedPriceIndex = 0,
      this.isLoading = false,
      this.error});

  @override
  final GoodsDetailModel? goodsDetail;
  @override
  @JsonKey()
  final int selectedPriceIndex;
// 当前选择的价格索引
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'GoodsDetailState(goodsDetail: $goodsDetail, selectedPriceIndex: $selectedPriceIndex, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoodsDetailStateImpl &&
            (identical(other.goodsDetail, goodsDetail) ||
                other.goodsDetail == goodsDetail) &&
            (identical(other.selectedPriceIndex, selectedPriceIndex) ||
                other.selectedPriceIndex == selectedPriceIndex) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, goodsDetail, selectedPriceIndex, isLoading, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GoodsDetailStateImplCopyWith<_$GoodsDetailStateImpl> get copyWith =>
      __$$GoodsDetailStateImplCopyWithImpl<_$GoodsDetailStateImpl>(
          this, _$identity);
}

abstract class _GoodsDetailState implements GoodsDetailState {
  const factory _GoodsDetailState(
      {final GoodsDetailModel? goodsDetail,
      final int selectedPriceIndex,
      final bool isLoading,
      final String? error}) = _$GoodsDetailStateImpl;

  @override
  GoodsDetailModel? get goodsDetail;
  @override
  int get selectedPriceIndex;
  @override // 当前选择的价格索引
  bool get isLoading;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$GoodsDetailStateImplCopyWith<_$GoodsDetailStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
