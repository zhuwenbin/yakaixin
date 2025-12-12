// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LearningDataState {
  LearningDataModel? get data => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  int get questionNumType =>
      throw _privateConstructorUsedError; // 1-最近一周, 2-按月查看
  int get questionHourType => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LearningDataStateCopyWith<LearningDataState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningDataStateCopyWith<$Res> {
  factory $LearningDataStateCopyWith(
          LearningDataState value, $Res Function(LearningDataState) then) =
      _$LearningDataStateCopyWithImpl<$Res, LearningDataState>;
  @useResult
  $Res call(
      {LearningDataModel? data,
      bool isLoading,
      String? error,
      int questionNumType,
      int questionHourType});

  $LearningDataModelCopyWith<$Res>? get data;
}

/// @nodoc
class _$LearningDataStateCopyWithImpl<$Res, $Val extends LearningDataState>
    implements $LearningDataStateCopyWith<$Res> {
  _$LearningDataStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? isLoading = null,
    Object? error = freezed,
    Object? questionNumType = null,
    Object? questionHourType = null,
  }) {
    return _then(_value.copyWith(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as LearningDataModel?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      questionNumType: null == questionNumType
          ? _value.questionNumType
          : questionNumType // ignore: cast_nullable_to_non_nullable
              as int,
      questionHourType: null == questionHourType
          ? _value.questionHourType
          : questionHourType // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LearningDataModelCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $LearningDataModelCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LearningDataStateImplCopyWith<$Res>
    implements $LearningDataStateCopyWith<$Res> {
  factory _$$LearningDataStateImplCopyWith(_$LearningDataStateImpl value,
          $Res Function(_$LearningDataStateImpl) then) =
      __$$LearningDataStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {LearningDataModel? data,
      bool isLoading,
      String? error,
      int questionNumType,
      int questionHourType});

  @override
  $LearningDataModelCopyWith<$Res>? get data;
}

/// @nodoc
class __$$LearningDataStateImplCopyWithImpl<$Res>
    extends _$LearningDataStateCopyWithImpl<$Res, _$LearningDataStateImpl>
    implements _$$LearningDataStateImplCopyWith<$Res> {
  __$$LearningDataStateImplCopyWithImpl(_$LearningDataStateImpl _value,
      $Res Function(_$LearningDataStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? isLoading = null,
    Object? error = freezed,
    Object? questionNumType = null,
    Object? questionHourType = null,
  }) {
    return _then(_$LearningDataStateImpl(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as LearningDataModel?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      questionNumType: null == questionNumType
          ? _value.questionNumType
          : questionNumType // ignore: cast_nullable_to_non_nullable
              as int,
      questionHourType: null == questionHourType
          ? _value.questionHourType
          : questionHourType // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$LearningDataStateImpl implements _LearningDataState {
  const _$LearningDataStateImpl(
      {this.data,
      this.isLoading = false,
      this.error,
      this.questionNumType = 1,
      this.questionHourType = 1});

  @override
  final LearningDataModel? data;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
  @override
  @JsonKey()
  final int questionNumType;
// 1-最近一周, 2-按月查看
  @override
  @JsonKey()
  final int questionHourType;

  @override
  String toString() {
    return 'LearningDataState(data: $data, isLoading: $isLoading, error: $error, questionNumType: $questionNumType, questionHourType: $questionHourType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningDataStateImpl &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.questionNumType, questionNumType) ||
                other.questionNumType == questionNumType) &&
            (identical(other.questionHourType, questionHourType) ||
                other.questionHourType == questionHourType));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, data, isLoading, error, questionNumType, questionHourType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningDataStateImplCopyWith<_$LearningDataStateImpl> get copyWith =>
      __$$LearningDataStateImplCopyWithImpl<_$LearningDataStateImpl>(
          this, _$identity);
}

abstract class _LearningDataState implements LearningDataState {
  const factory _LearningDataState(
      {final LearningDataModel? data,
      final bool isLoading,
      final String? error,
      final int questionNumType,
      final int questionHourType}) = _$LearningDataStateImpl;

  @override
  LearningDataModel? get data;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  int get questionNumType;
  @override // 1-最近一周, 2-按月查看
  int get questionHourType;
  @override
  @JsonKey(ignore: true)
  _$$LearningDataStateImplCopyWith<_$LearningDataStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ScoreReportState {
  List<ScoreReportModel> get reports => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String get searchKeyword => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ScoreReportStateCopyWith<ScoreReportState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScoreReportStateCopyWith<$Res> {
  factory $ScoreReportStateCopyWith(
          ScoreReportState value, $Res Function(ScoreReportState) then) =
      _$ScoreReportStateCopyWithImpl<$Res, ScoreReportState>;
  @useResult
  $Res call(
      {List<ScoreReportModel> reports,
      bool isLoading,
      String? error,
      String searchKeyword});
}

/// @nodoc
class _$ScoreReportStateCopyWithImpl<$Res, $Val extends ScoreReportState>
    implements $ScoreReportStateCopyWith<$Res> {
  _$ScoreReportStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reports = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? searchKeyword = null,
  }) {
    return _then(_value.copyWith(
      reports: null == reports
          ? _value.reports
          : reports // ignore: cast_nullable_to_non_nullable
              as List<ScoreReportModel>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      searchKeyword: null == searchKeyword
          ? _value.searchKeyword
          : searchKeyword // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScoreReportStateImplCopyWith<$Res>
    implements $ScoreReportStateCopyWith<$Res> {
  factory _$$ScoreReportStateImplCopyWith(_$ScoreReportStateImpl value,
          $Res Function(_$ScoreReportStateImpl) then) =
      __$$ScoreReportStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ScoreReportModel> reports,
      bool isLoading,
      String? error,
      String searchKeyword});
}

/// @nodoc
class __$$ScoreReportStateImplCopyWithImpl<$Res>
    extends _$ScoreReportStateCopyWithImpl<$Res, _$ScoreReportStateImpl>
    implements _$$ScoreReportStateImplCopyWith<$Res> {
  __$$ScoreReportStateImplCopyWithImpl(_$ScoreReportStateImpl _value,
      $Res Function(_$ScoreReportStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reports = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? searchKeyword = null,
  }) {
    return _then(_$ScoreReportStateImpl(
      reports: null == reports
          ? _value._reports
          : reports // ignore: cast_nullable_to_non_nullable
              as List<ScoreReportModel>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      searchKeyword: null == searchKeyword
          ? _value.searchKeyword
          : searchKeyword // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ScoreReportStateImpl implements _ScoreReportState {
  const _$ScoreReportStateImpl(
      {final List<ScoreReportModel> reports = const [],
      this.isLoading = false,
      this.error,
      this.searchKeyword = ''})
      : _reports = reports;

  final List<ScoreReportModel> _reports;
  @override
  @JsonKey()
  List<ScoreReportModel> get reports {
    if (_reports is EqualUnmodifiableListView) return _reports;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reports);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
  @override
  @JsonKey()
  final String searchKeyword;

  @override
  String toString() {
    return 'ScoreReportState(reports: $reports, isLoading: $isLoading, error: $error, searchKeyword: $searchKeyword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScoreReportStateImpl &&
            const DeepCollectionEquality().equals(other._reports, _reports) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.searchKeyword, searchKeyword) ||
                other.searchKeyword == searchKeyword));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_reports),
      isLoading,
      error,
      searchKeyword);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScoreReportStateImplCopyWith<_$ScoreReportStateImpl> get copyWith =>
      __$$ScoreReportStateImplCopyWithImpl<_$ScoreReportStateImpl>(
          this, _$identity);
}

abstract class _ScoreReportState implements ScoreReportState {
  const factory _ScoreReportState(
      {final List<ScoreReportModel> reports,
      final bool isLoading,
      final String? error,
      final String searchKeyword}) = _$ScoreReportStateImpl;

  @override
  List<ScoreReportModel> get reports;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  String get searchKeyword;
  @override
  @JsonKey(ignore: true)
  _$$ScoreReportStateImplCopyWith<_$ScoreReportStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
