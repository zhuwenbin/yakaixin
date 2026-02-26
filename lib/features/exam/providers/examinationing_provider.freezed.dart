// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'examinationing_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ExaminationingState {
  /// 试题列表
  List<QuestionModel> get questions => throw _privateConstructorUsedError;

  /// 考试信息
  ExamInfoModel? get examInfo => throw _privateConstructorUsedError;

  /// 当前题目索引
  int get currentIndex => throw _privateConstructorUsedError;

  /// 剩余时间（秒）
  int get remainingTime => throw _privateConstructorUsedError;

  /// 初始剩余时间（秒），答题/背题切换时重置用
  int get initialRemainingTime => throw _privateConstructorUsedError;

  /// 是否正在加载
  bool get isLoading => throw _privateConstructorUsedError;

  /// 错误信息
  String? get error => throw _privateConstructorUsedError;

  /// 是否已交卷
  bool get isSubmitted => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ExaminationingStateCopyWith<ExaminationingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExaminationingStateCopyWith<$Res> {
  factory $ExaminationingStateCopyWith(
          ExaminationingState value, $Res Function(ExaminationingState) then) =
      _$ExaminationingStateCopyWithImpl<$Res, ExaminationingState>;
  @useResult
  $Res call(
      {List<QuestionModel> questions,
      ExamInfoModel? examInfo,
      int currentIndex,
      int remainingTime,
      int initialRemainingTime,
      bool isLoading,
      String? error,
      bool isSubmitted});

  $ExamInfoModelCopyWith<$Res>? get examInfo;
}

/// @nodoc
class _$ExaminationingStateCopyWithImpl<$Res, $Val extends ExaminationingState>
    implements $ExaminationingStateCopyWith<$Res> {
  _$ExaminationingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questions = null,
    Object? examInfo = freezed,
    Object? currentIndex = null,
    Object? remainingTime = null,
    Object? initialRemainingTime = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? isSubmitted = null,
  }) {
    return _then(_value.copyWith(
      questions: null == questions
          ? _value.questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<QuestionModel>,
      examInfo: freezed == examInfo
          ? _value.examInfo
          : examInfo // ignore: cast_nullable_to_non_nullable
              as ExamInfoModel?,
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      remainingTime: null == remainingTime
          ? _value.remainingTime
          : remainingTime // ignore: cast_nullable_to_non_nullable
              as int,
      initialRemainingTime: null == initialRemainingTime
          ? _value.initialRemainingTime
          : initialRemainingTime // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      isSubmitted: null == isSubmitted
          ? _value.isSubmitted
          : isSubmitted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ExamInfoModelCopyWith<$Res>? get examInfo {
    if (_value.examInfo == null) {
      return null;
    }

    return $ExamInfoModelCopyWith<$Res>(_value.examInfo!, (value) {
      return _then(_value.copyWith(examInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ExaminationingStateImplCopyWith<$Res>
    implements $ExaminationingStateCopyWith<$Res> {
  factory _$$ExaminationingStateImplCopyWith(_$ExaminationingStateImpl value,
          $Res Function(_$ExaminationingStateImpl) then) =
      __$$ExaminationingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<QuestionModel> questions,
      ExamInfoModel? examInfo,
      int currentIndex,
      int remainingTime,
      int initialRemainingTime,
      bool isLoading,
      String? error,
      bool isSubmitted});

  @override
  $ExamInfoModelCopyWith<$Res>? get examInfo;
}

/// @nodoc
class __$$ExaminationingStateImplCopyWithImpl<$Res>
    extends _$ExaminationingStateCopyWithImpl<$Res, _$ExaminationingStateImpl>
    implements _$$ExaminationingStateImplCopyWith<$Res> {
  __$$ExaminationingStateImplCopyWithImpl(_$ExaminationingStateImpl _value,
      $Res Function(_$ExaminationingStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questions = null,
    Object? examInfo = freezed,
    Object? currentIndex = null,
    Object? remainingTime = null,
    Object? initialRemainingTime = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? isSubmitted = null,
  }) {
    return _then(_$ExaminationingStateImpl(
      questions: null == questions
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<QuestionModel>,
      examInfo: freezed == examInfo
          ? _value.examInfo
          : examInfo // ignore: cast_nullable_to_non_nullable
              as ExamInfoModel?,
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      remainingTime: null == remainingTime
          ? _value.remainingTime
          : remainingTime // ignore: cast_nullable_to_non_nullable
              as int,
      initialRemainingTime: null == initialRemainingTime
          ? _value.initialRemainingTime
          : initialRemainingTime // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      isSubmitted: null == isSubmitted
          ? _value.isSubmitted
          : isSubmitted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ExaminationingStateImpl implements _ExaminationingState {
  const _$ExaminationingStateImpl(
      {final List<QuestionModel> questions = const [],
      this.examInfo,
      this.currentIndex = 0,
      this.remainingTime = 0,
      this.initialRemainingTime = 0,
      this.isLoading = false,
      this.error,
      this.isSubmitted = false})
      : _questions = questions;

  /// 试题列表
  final List<QuestionModel> _questions;

  /// 试题列表
  @override
  @JsonKey()
  List<QuestionModel> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  /// 考试信息
  @override
  final ExamInfoModel? examInfo;

  /// 当前题目索引
  @override
  @JsonKey()
  final int currentIndex;

  /// 剩余时间（秒）
  @override
  @JsonKey()
  final int remainingTime;

  /// 初始剩余时间（秒），答题/背题切换时重置用
  @override
  @JsonKey()
  final int initialRemainingTime;

  /// 是否正在加载
  @override
  @JsonKey()
  final bool isLoading;

  /// 错误信息
  @override
  final String? error;

  /// 是否已交卷
  @override
  @JsonKey()
  final bool isSubmitted;

  @override
  String toString() {
    return 'ExaminationingState(questions: $questions, examInfo: $examInfo, currentIndex: $currentIndex, remainingTime: $remainingTime, initialRemainingTime: $initialRemainingTime, isLoading: $isLoading, error: $error, isSubmitted: $isSubmitted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExaminationingStateImpl &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions) &&
            (identical(other.examInfo, examInfo) ||
                other.examInfo == examInfo) &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            (identical(other.remainingTime, remainingTime) ||
                other.remainingTime == remainingTime) &&
            (identical(other.initialRemainingTime, initialRemainingTime) ||
                other.initialRemainingTime == initialRemainingTime) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.isSubmitted, isSubmitted) ||
                other.isSubmitted == isSubmitted));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_questions),
      examInfo,
      currentIndex,
      remainingTime,
      initialRemainingTime,
      isLoading,
      error,
      isSubmitted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExaminationingStateImplCopyWith<_$ExaminationingStateImpl> get copyWith =>
      __$$ExaminationingStateImplCopyWithImpl<_$ExaminationingStateImpl>(
          this, _$identity);
}

abstract class _ExaminationingState implements ExaminationingState {
  const factory _ExaminationingState(
      {final List<QuestionModel> questions,
      final ExamInfoModel? examInfo,
      final int currentIndex,
      final int remainingTime,
      final int initialRemainingTime,
      final bool isLoading,
      final String? error,
      final bool isSubmitted}) = _$ExaminationingStateImpl;

  @override

  /// 试题列表
  List<QuestionModel> get questions;
  @override

  /// 考试信息
  ExamInfoModel? get examInfo;
  @override

  /// 当前题目索引
  int get currentIndex;
  @override

  /// 剩余时间（秒）
  int get remainingTime;
  @override

  /// 初始剩余时间（秒），答题/背题切换时重置用
  int get initialRemainingTime;
  @override

  /// 是否正在加载
  bool get isLoading;
  @override

  /// 错误信息
  String? get error;
  @override

  /// 是否已交卷
  bool get isSubmitted;
  @override
  @JsonKey(ignore: true)
  _$$ExaminationingStateImplCopyWith<_$ExaminationingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
