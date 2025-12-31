// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam_info_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ExamInfoState {
  ExamInfoDetailModel? get detail => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get productId =>
      throw _privateConstructorUsedError; // 保存原始 productId，用于重新加载
  String? get selectedMockExamId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ExamInfoStateCopyWith<ExamInfoState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExamInfoStateCopyWith<$Res> {
  factory $ExamInfoStateCopyWith(
          ExamInfoState value, $Res Function(ExamInfoState) then) =
      _$ExamInfoStateCopyWithImpl<$Res, ExamInfoState>;
  @useResult
  $Res call(
      {ExamInfoDetailModel? detail,
      bool isLoading,
      String? error,
      String? productId,
      String? selectedMockExamId});

  $ExamInfoDetailModelCopyWith<$Res>? get detail;
}

/// @nodoc
class _$ExamInfoStateCopyWithImpl<$Res, $Val extends ExamInfoState>
    implements $ExamInfoStateCopyWith<$Res> {
  _$ExamInfoStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? detail = freezed,
    Object? isLoading = null,
    Object? error = freezed,
    Object? productId = freezed,
    Object? selectedMockExamId = freezed,
  }) {
    return _then(_value.copyWith(
      detail: freezed == detail
          ? _value.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as ExamInfoDetailModel?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedMockExamId: freezed == selectedMockExamId
          ? _value.selectedMockExamId
          : selectedMockExamId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ExamInfoDetailModelCopyWith<$Res>? get detail {
    if (_value.detail == null) {
      return null;
    }

    return $ExamInfoDetailModelCopyWith<$Res>(_value.detail!, (value) {
      return _then(_value.copyWith(detail: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ExamInfoStateImplCopyWith<$Res>
    implements $ExamInfoStateCopyWith<$Res> {
  factory _$$ExamInfoStateImplCopyWith(
          _$ExamInfoStateImpl value, $Res Function(_$ExamInfoStateImpl) then) =
      __$$ExamInfoStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ExamInfoDetailModel? detail,
      bool isLoading,
      String? error,
      String? productId,
      String? selectedMockExamId});

  @override
  $ExamInfoDetailModelCopyWith<$Res>? get detail;
}

/// @nodoc
class __$$ExamInfoStateImplCopyWithImpl<$Res>
    extends _$ExamInfoStateCopyWithImpl<$Res, _$ExamInfoStateImpl>
    implements _$$ExamInfoStateImplCopyWith<$Res> {
  __$$ExamInfoStateImplCopyWithImpl(
      _$ExamInfoStateImpl _value, $Res Function(_$ExamInfoStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? detail = freezed,
    Object? isLoading = null,
    Object? error = freezed,
    Object? productId = freezed,
    Object? selectedMockExamId = freezed,
  }) {
    return _then(_$ExamInfoStateImpl(
      detail: freezed == detail
          ? _value.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as ExamInfoDetailModel?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedMockExamId: freezed == selectedMockExamId
          ? _value.selectedMockExamId
          : selectedMockExamId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ExamInfoStateImpl implements _ExamInfoState {
  const _$ExamInfoStateImpl(
      {this.detail,
      this.isLoading = false,
      this.error,
      this.productId,
      this.selectedMockExamId});

  @override
  final ExamInfoDetailModel? detail;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
  @override
  final String? productId;
// 保存原始 productId，用于重新加载
  @override
  final String? selectedMockExamId;

  @override
  String toString() {
    return 'ExamInfoState(detail: $detail, isLoading: $isLoading, error: $error, productId: $productId, selectedMockExamId: $selectedMockExamId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExamInfoStateImpl &&
            (identical(other.detail, detail) || other.detail == detail) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.selectedMockExamId, selectedMockExamId) ||
                other.selectedMockExamId == selectedMockExamId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, detail, isLoading, error, productId, selectedMockExamId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExamInfoStateImplCopyWith<_$ExamInfoStateImpl> get copyWith =>
      __$$ExamInfoStateImplCopyWithImpl<_$ExamInfoStateImpl>(this, _$identity);
}

abstract class _ExamInfoState implements ExamInfoState {
  const factory _ExamInfoState(
      {final ExamInfoDetailModel? detail,
      final bool isLoading,
      final String? error,
      final String? productId,
      final String? selectedMockExamId}) = _$ExamInfoStateImpl;

  @override
  ExamInfoDetailModel? get detail;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  String? get productId;
  @override // 保存原始 productId，用于重新加载
  String? get selectedMockExamId;
  @override
  @JsonKey(ignore: true)
  _$$ExamInfoStateImplCopyWith<_$ExamInfoStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
