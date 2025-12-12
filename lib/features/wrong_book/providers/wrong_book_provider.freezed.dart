// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wrong_book_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WrongBookState {
// ✅ 三个Tab的数据
  List<WrongQuestionModel> get allQuestions =>
      throw _privateConstructorUsedError; // 全部
  List<WrongQuestionModel> get markedQuestions =>
      throw _privateConstructorUsedError; // 标记
  List<WrongQuestionModel> get fallibleQuestions =>
      throw _privateConstructorUsedError; // 易错
// ✅ 加载状态
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError; // ✅ 筛选条件
  String get timeRange =>
      throw _privateConstructorUsedError; // 时间范围: 0-全部, 1-近3天, 2-一周内, 3-一月内
  String? get startDate => throw _privateConstructorUsedError; // 自定义开始日期
  String? get endDate => throw _privateConstructorUsedError; // 自定义结束日期
  String? get timeRangeName => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WrongBookStateCopyWith<WrongBookState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WrongBookStateCopyWith<$Res> {
  factory $WrongBookStateCopyWith(
          WrongBookState value, $Res Function(WrongBookState) then) =
      _$WrongBookStateCopyWithImpl<$Res, WrongBookState>;
  @useResult
  $Res call(
      {List<WrongQuestionModel> allQuestions,
      List<WrongQuestionModel> markedQuestions,
      List<WrongQuestionModel> fallibleQuestions,
      bool isLoading,
      String? error,
      String timeRange,
      String? startDate,
      String? endDate,
      String? timeRangeName});
}

/// @nodoc
class _$WrongBookStateCopyWithImpl<$Res, $Val extends WrongBookState>
    implements $WrongBookStateCopyWith<$Res> {
  _$WrongBookStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allQuestions = null,
    Object? markedQuestions = null,
    Object? fallibleQuestions = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? timeRange = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? timeRangeName = freezed,
  }) {
    return _then(_value.copyWith(
      allQuestions: null == allQuestions
          ? _value.allQuestions
          : allQuestions // ignore: cast_nullable_to_non_nullable
              as List<WrongQuestionModel>,
      markedQuestions: null == markedQuestions
          ? _value.markedQuestions
          : markedQuestions // ignore: cast_nullable_to_non_nullable
              as List<WrongQuestionModel>,
      fallibleQuestions: null == fallibleQuestions
          ? _value.fallibleQuestions
          : fallibleQuestions // ignore: cast_nullable_to_non_nullable
              as List<WrongQuestionModel>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      timeRange: null == timeRange
          ? _value.timeRange
          : timeRange // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String?,
      timeRangeName: freezed == timeRangeName
          ? _value.timeRangeName
          : timeRangeName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WrongBookStateImplCopyWith<$Res>
    implements $WrongBookStateCopyWith<$Res> {
  factory _$$WrongBookStateImplCopyWith(_$WrongBookStateImpl value,
          $Res Function(_$WrongBookStateImpl) then) =
      __$$WrongBookStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<WrongQuestionModel> allQuestions,
      List<WrongQuestionModel> markedQuestions,
      List<WrongQuestionModel> fallibleQuestions,
      bool isLoading,
      String? error,
      String timeRange,
      String? startDate,
      String? endDate,
      String? timeRangeName});
}

/// @nodoc
class __$$WrongBookStateImplCopyWithImpl<$Res>
    extends _$WrongBookStateCopyWithImpl<$Res, _$WrongBookStateImpl>
    implements _$$WrongBookStateImplCopyWith<$Res> {
  __$$WrongBookStateImplCopyWithImpl(
      _$WrongBookStateImpl _value, $Res Function(_$WrongBookStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allQuestions = null,
    Object? markedQuestions = null,
    Object? fallibleQuestions = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? timeRange = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? timeRangeName = freezed,
  }) {
    return _then(_$WrongBookStateImpl(
      allQuestions: null == allQuestions
          ? _value._allQuestions
          : allQuestions // ignore: cast_nullable_to_non_nullable
              as List<WrongQuestionModel>,
      markedQuestions: null == markedQuestions
          ? _value._markedQuestions
          : markedQuestions // ignore: cast_nullable_to_non_nullable
              as List<WrongQuestionModel>,
      fallibleQuestions: null == fallibleQuestions
          ? _value._fallibleQuestions
          : fallibleQuestions // ignore: cast_nullable_to_non_nullable
              as List<WrongQuestionModel>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      timeRange: null == timeRange
          ? _value.timeRange
          : timeRange // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String?,
      timeRangeName: freezed == timeRangeName
          ? _value.timeRangeName
          : timeRangeName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$WrongBookStateImpl implements _WrongBookState {
  const _$WrongBookStateImpl(
      {final List<WrongQuestionModel> allQuestions = const [],
      final List<WrongQuestionModel> markedQuestions = const [],
      final List<WrongQuestionModel> fallibleQuestions = const [],
      this.isLoading = false,
      this.error,
      this.timeRange = '0',
      this.startDate,
      this.endDate,
      this.timeRangeName})
      : _allQuestions = allQuestions,
        _markedQuestions = markedQuestions,
        _fallibleQuestions = fallibleQuestions;

// ✅ 三个Tab的数据
  final List<WrongQuestionModel> _allQuestions;
// ✅ 三个Tab的数据
  @override
  @JsonKey()
  List<WrongQuestionModel> get allQuestions {
    if (_allQuestions is EqualUnmodifiableListView) return _allQuestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allQuestions);
  }

// 全部
  final List<WrongQuestionModel> _markedQuestions;
// 全部
  @override
  @JsonKey()
  List<WrongQuestionModel> get markedQuestions {
    if (_markedQuestions is EqualUnmodifiableListView) return _markedQuestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_markedQuestions);
  }

// 标记
  final List<WrongQuestionModel> _fallibleQuestions;
// 标记
  @override
  @JsonKey()
  List<WrongQuestionModel> get fallibleQuestions {
    if (_fallibleQuestions is EqualUnmodifiableListView)
      return _fallibleQuestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fallibleQuestions);
  }

// 易错
// ✅ 加载状态
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
// ✅ 筛选条件
  @override
  @JsonKey()
  final String timeRange;
// 时间范围: 0-全部, 1-近3天, 2-一周内, 3-一月内
  @override
  final String? startDate;
// 自定义开始日期
  @override
  final String? endDate;
// 自定义结束日期
  @override
  final String? timeRangeName;

  @override
  String toString() {
    return 'WrongBookState(allQuestions: $allQuestions, markedQuestions: $markedQuestions, fallibleQuestions: $fallibleQuestions, isLoading: $isLoading, error: $error, timeRange: $timeRange, startDate: $startDate, endDate: $endDate, timeRangeName: $timeRangeName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WrongBookStateImpl &&
            const DeepCollectionEquality()
                .equals(other._allQuestions, _allQuestions) &&
            const DeepCollectionEquality()
                .equals(other._markedQuestions, _markedQuestions) &&
            const DeepCollectionEquality()
                .equals(other._fallibleQuestions, _fallibleQuestions) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.timeRange, timeRange) ||
                other.timeRange == timeRange) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.timeRangeName, timeRangeName) ||
                other.timeRangeName == timeRangeName));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_allQuestions),
      const DeepCollectionEquality().hash(_markedQuestions),
      const DeepCollectionEquality().hash(_fallibleQuestions),
      isLoading,
      error,
      timeRange,
      startDate,
      endDate,
      timeRangeName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WrongBookStateImplCopyWith<_$WrongBookStateImpl> get copyWith =>
      __$$WrongBookStateImplCopyWithImpl<_$WrongBookStateImpl>(
          this, _$identity);
}

abstract class _WrongBookState implements WrongBookState {
  const factory _WrongBookState(
      {final List<WrongQuestionModel> allQuestions,
      final List<WrongQuestionModel> markedQuestions,
      final List<WrongQuestionModel> fallibleQuestions,
      final bool isLoading,
      final String? error,
      final String timeRange,
      final String? startDate,
      final String? endDate,
      final String? timeRangeName}) = _$WrongBookStateImpl;

  @override // ✅ 三个Tab的数据
  List<WrongQuestionModel> get allQuestions;
  @override // 全部
  List<WrongQuestionModel> get markedQuestions;
  @override // 标记
  List<WrongQuestionModel> get fallibleQuestions;
  @override // 易错
// ✅ 加载状态
  bool get isLoading;
  @override
  String? get error;
  @override // ✅ 筛选条件
  String get timeRange;
  @override // 时间范围: 0-全部, 1-近3天, 2-一周内, 3-一月内
  String? get startDate;
  @override // 自定义开始日期
  String? get endDate;
  @override // 自定义结束日期
  String? get timeRangeName;
  @override
  @JsonKey(ignore: true)
  _$$WrongBookStateImplCopyWith<_$WrongBookStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
