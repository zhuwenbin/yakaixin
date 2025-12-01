// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'simulated_exam_room_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SimulatedExamRoomState {
  GoodsDetailModel? get goodsDetail => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SimulatedExamRoomStateCopyWith<SimulatedExamRoomState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SimulatedExamRoomStateCopyWith<$Res> {
  factory $SimulatedExamRoomStateCopyWith(SimulatedExamRoomState value,
          $Res Function(SimulatedExamRoomState) then) =
      _$SimulatedExamRoomStateCopyWithImpl<$Res, SimulatedExamRoomState>;
  @useResult
  $Res call({GoodsDetailModel? goodsDetail, bool isLoading, String? error});

  $GoodsDetailModelCopyWith<$Res>? get goodsDetail;
}

/// @nodoc
class _$SimulatedExamRoomStateCopyWithImpl<$Res,
        $Val extends SimulatedExamRoomState>
    implements $SimulatedExamRoomStateCopyWith<$Res> {
  _$SimulatedExamRoomStateCopyWithImpl(this._value, this._then);

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
abstract class _$$SimulatedExamRoomStateImplCopyWith<$Res>
    implements $SimulatedExamRoomStateCopyWith<$Res> {
  factory _$$SimulatedExamRoomStateImplCopyWith(
          _$SimulatedExamRoomStateImpl value,
          $Res Function(_$SimulatedExamRoomStateImpl) then) =
      __$$SimulatedExamRoomStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({GoodsDetailModel? goodsDetail, bool isLoading, String? error});

  @override
  $GoodsDetailModelCopyWith<$Res>? get goodsDetail;
}

/// @nodoc
class __$$SimulatedExamRoomStateImplCopyWithImpl<$Res>
    extends _$SimulatedExamRoomStateCopyWithImpl<$Res,
        _$SimulatedExamRoomStateImpl>
    implements _$$SimulatedExamRoomStateImplCopyWith<$Res> {
  __$$SimulatedExamRoomStateImplCopyWithImpl(
      _$SimulatedExamRoomStateImpl _value,
      $Res Function(_$SimulatedExamRoomStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goodsDetail = freezed,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$SimulatedExamRoomStateImpl(
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
    ));
  }
}

/// @nodoc

class _$SimulatedExamRoomStateImpl implements _SimulatedExamRoomState {
  const _$SimulatedExamRoomStateImpl(
      {this.goodsDetail, this.isLoading = false, this.error});

  @override
  final GoodsDetailModel? goodsDetail;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'SimulatedExamRoomState(goodsDetail: $goodsDetail, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SimulatedExamRoomStateImpl &&
            (identical(other.goodsDetail, goodsDetail) ||
                other.goodsDetail == goodsDetail) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, goodsDetail, isLoading, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SimulatedExamRoomStateImplCopyWith<_$SimulatedExamRoomStateImpl>
      get copyWith => __$$SimulatedExamRoomStateImplCopyWithImpl<
          _$SimulatedExamRoomStateImpl>(this, _$identity);
}

abstract class _SimulatedExamRoomState implements SimulatedExamRoomState {
  const factory _SimulatedExamRoomState(
      {final GoodsDetailModel? goodsDetail,
      final bool isLoading,
      final String? error}) = _$SimulatedExamRoomStateImpl;

  @override
  GoodsDetailModel? get goodsDetail;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$SimulatedExamRoomStateImplCopyWith<_$SimulatedExamRoomStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
