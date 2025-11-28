// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_bank_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$QuestionBankState {
// 学习数据
  LearningDataModel? get learningData => throw _privateConstructorUsedError;
  bool get isLoadingLearning => throw _privateConstructorUsedError; // 章节数据
  List<ChapterModel> get chapters => throw _privateConstructorUsedError;
  bool get isLoadingChapters => throw _privateConstructorUsedError; // 已购商品
  List<PurchasedGoodsModel> get purchasedGoods =>
      throw _privateConstructorUsedError;
  bool get isLoadingPurchased => throw _privateConstructorUsedError; // 每日一测
  DailyPracticeModel? get dailyPractice =>
      throw _privateConstructorUsedError; // 技能模拟
  SkillMockModel? get skillMock => throw _privateConstructorUsedError; // 错误信息
  String? get error => throw _privateConstructorUsedError;
  ErrorType? get errorType => throw _privateConstructorUsedError; // 操作成功标志
  bool get checkInSuccess => throw _privateConstructorUsedError;
  String? get successMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $QuestionBankStateCopyWith<QuestionBankState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionBankStateCopyWith<$Res> {
  factory $QuestionBankStateCopyWith(
          QuestionBankState value, $Res Function(QuestionBankState) then) =
      _$QuestionBankStateCopyWithImpl<$Res, QuestionBankState>;
  @useResult
  $Res call(
      {LearningDataModel? learningData,
      bool isLoadingLearning,
      List<ChapterModel> chapters,
      bool isLoadingChapters,
      List<PurchasedGoodsModel> purchasedGoods,
      bool isLoadingPurchased,
      DailyPracticeModel? dailyPractice,
      SkillMockModel? skillMock,
      String? error,
      ErrorType? errorType,
      bool checkInSuccess,
      String? successMessage});

  $LearningDataModelCopyWith<$Res>? get learningData;
  $DailyPracticeModelCopyWith<$Res>? get dailyPractice;
  $SkillMockModelCopyWith<$Res>? get skillMock;
}

/// @nodoc
class _$QuestionBankStateCopyWithImpl<$Res, $Val extends QuestionBankState>
    implements $QuestionBankStateCopyWith<$Res> {
  _$QuestionBankStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? learningData = freezed,
    Object? isLoadingLearning = null,
    Object? chapters = null,
    Object? isLoadingChapters = null,
    Object? purchasedGoods = null,
    Object? isLoadingPurchased = null,
    Object? dailyPractice = freezed,
    Object? skillMock = freezed,
    Object? error = freezed,
    Object? errorType = freezed,
    Object? checkInSuccess = null,
    Object? successMessage = freezed,
  }) {
    return _then(_value.copyWith(
      learningData: freezed == learningData
          ? _value.learningData
          : learningData // ignore: cast_nullable_to_non_nullable
              as LearningDataModel?,
      isLoadingLearning: null == isLoadingLearning
          ? _value.isLoadingLearning
          : isLoadingLearning // ignore: cast_nullable_to_non_nullable
              as bool,
      chapters: null == chapters
          ? _value.chapters
          : chapters // ignore: cast_nullable_to_non_nullable
              as List<ChapterModel>,
      isLoadingChapters: null == isLoadingChapters
          ? _value.isLoadingChapters
          : isLoadingChapters // ignore: cast_nullable_to_non_nullable
              as bool,
      purchasedGoods: null == purchasedGoods
          ? _value.purchasedGoods
          : purchasedGoods // ignore: cast_nullable_to_non_nullable
              as List<PurchasedGoodsModel>,
      isLoadingPurchased: null == isLoadingPurchased
          ? _value.isLoadingPurchased
          : isLoadingPurchased // ignore: cast_nullable_to_non_nullable
              as bool,
      dailyPractice: freezed == dailyPractice
          ? _value.dailyPractice
          : dailyPractice // ignore: cast_nullable_to_non_nullable
              as DailyPracticeModel?,
      skillMock: freezed == skillMock
          ? _value.skillMock
          : skillMock // ignore: cast_nullable_to_non_nullable
              as SkillMockModel?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      errorType: freezed == errorType
          ? _value.errorType
          : errorType // ignore: cast_nullable_to_non_nullable
              as ErrorType?,
      checkInSuccess: null == checkInSuccess
          ? _value.checkInSuccess
          : checkInSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      successMessage: freezed == successMessage
          ? _value.successMessage
          : successMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LearningDataModelCopyWith<$Res>? get learningData {
    if (_value.learningData == null) {
      return null;
    }

    return $LearningDataModelCopyWith<$Res>(_value.learningData!, (value) {
      return _then(_value.copyWith(learningData: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DailyPracticeModelCopyWith<$Res>? get dailyPractice {
    if (_value.dailyPractice == null) {
      return null;
    }

    return $DailyPracticeModelCopyWith<$Res>(_value.dailyPractice!, (value) {
      return _then(_value.copyWith(dailyPractice: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SkillMockModelCopyWith<$Res>? get skillMock {
    if (_value.skillMock == null) {
      return null;
    }

    return $SkillMockModelCopyWith<$Res>(_value.skillMock!, (value) {
      return _then(_value.copyWith(skillMock: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuestionBankStateImplCopyWith<$Res>
    implements $QuestionBankStateCopyWith<$Res> {
  factory _$$QuestionBankStateImplCopyWith(_$QuestionBankStateImpl value,
          $Res Function(_$QuestionBankStateImpl) then) =
      __$$QuestionBankStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {LearningDataModel? learningData,
      bool isLoadingLearning,
      List<ChapterModel> chapters,
      bool isLoadingChapters,
      List<PurchasedGoodsModel> purchasedGoods,
      bool isLoadingPurchased,
      DailyPracticeModel? dailyPractice,
      SkillMockModel? skillMock,
      String? error,
      ErrorType? errorType,
      bool checkInSuccess,
      String? successMessage});

  @override
  $LearningDataModelCopyWith<$Res>? get learningData;
  @override
  $DailyPracticeModelCopyWith<$Res>? get dailyPractice;
  @override
  $SkillMockModelCopyWith<$Res>? get skillMock;
}

/// @nodoc
class __$$QuestionBankStateImplCopyWithImpl<$Res>
    extends _$QuestionBankStateCopyWithImpl<$Res, _$QuestionBankStateImpl>
    implements _$$QuestionBankStateImplCopyWith<$Res> {
  __$$QuestionBankStateImplCopyWithImpl(_$QuestionBankStateImpl _value,
      $Res Function(_$QuestionBankStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? learningData = freezed,
    Object? isLoadingLearning = null,
    Object? chapters = null,
    Object? isLoadingChapters = null,
    Object? purchasedGoods = null,
    Object? isLoadingPurchased = null,
    Object? dailyPractice = freezed,
    Object? skillMock = freezed,
    Object? error = freezed,
    Object? errorType = freezed,
    Object? checkInSuccess = null,
    Object? successMessage = freezed,
  }) {
    return _then(_$QuestionBankStateImpl(
      learningData: freezed == learningData
          ? _value.learningData
          : learningData // ignore: cast_nullable_to_non_nullable
              as LearningDataModel?,
      isLoadingLearning: null == isLoadingLearning
          ? _value.isLoadingLearning
          : isLoadingLearning // ignore: cast_nullable_to_non_nullable
              as bool,
      chapters: null == chapters
          ? _value._chapters
          : chapters // ignore: cast_nullable_to_non_nullable
              as List<ChapterModel>,
      isLoadingChapters: null == isLoadingChapters
          ? _value.isLoadingChapters
          : isLoadingChapters // ignore: cast_nullable_to_non_nullable
              as bool,
      purchasedGoods: null == purchasedGoods
          ? _value._purchasedGoods
          : purchasedGoods // ignore: cast_nullable_to_non_nullable
              as List<PurchasedGoodsModel>,
      isLoadingPurchased: null == isLoadingPurchased
          ? _value.isLoadingPurchased
          : isLoadingPurchased // ignore: cast_nullable_to_non_nullable
              as bool,
      dailyPractice: freezed == dailyPractice
          ? _value.dailyPractice
          : dailyPractice // ignore: cast_nullable_to_non_nullable
              as DailyPracticeModel?,
      skillMock: freezed == skillMock
          ? _value.skillMock
          : skillMock // ignore: cast_nullable_to_non_nullable
              as SkillMockModel?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      errorType: freezed == errorType
          ? _value.errorType
          : errorType // ignore: cast_nullable_to_non_nullable
              as ErrorType?,
      checkInSuccess: null == checkInSuccess
          ? _value.checkInSuccess
          : checkInSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      successMessage: freezed == successMessage
          ? _value.successMessage
          : successMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$QuestionBankStateImpl implements _QuestionBankState {
  const _$QuestionBankStateImpl(
      {this.learningData,
      this.isLoadingLearning = false,
      final List<ChapterModel> chapters = const [],
      this.isLoadingChapters = false,
      final List<PurchasedGoodsModel> purchasedGoods = const [],
      this.isLoadingPurchased = false,
      this.dailyPractice,
      this.skillMock,
      this.error,
      this.errorType,
      this.checkInSuccess = false,
      this.successMessage})
      : _chapters = chapters,
        _purchasedGoods = purchasedGoods;

// 学习数据
  @override
  final LearningDataModel? learningData;
  @override
  @JsonKey()
  final bool isLoadingLearning;
// 章节数据
  final List<ChapterModel> _chapters;
// 章节数据
  @override
  @JsonKey()
  List<ChapterModel> get chapters {
    if (_chapters is EqualUnmodifiableListView) return _chapters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_chapters);
  }

  @override
  @JsonKey()
  final bool isLoadingChapters;
// 已购商品
  final List<PurchasedGoodsModel> _purchasedGoods;
// 已购商品
  @override
  @JsonKey()
  List<PurchasedGoodsModel> get purchasedGoods {
    if (_purchasedGoods is EqualUnmodifiableListView) return _purchasedGoods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_purchasedGoods);
  }

  @override
  @JsonKey()
  final bool isLoadingPurchased;
// 每日一测
  @override
  final DailyPracticeModel? dailyPractice;
// 技能模拟
  @override
  final SkillMockModel? skillMock;
// 错误信息
  @override
  final String? error;
  @override
  final ErrorType? errorType;
// 操作成功标志
  @override
  @JsonKey()
  final bool checkInSuccess;
  @override
  final String? successMessage;

  @override
  String toString() {
    return 'QuestionBankState(learningData: $learningData, isLoadingLearning: $isLoadingLearning, chapters: $chapters, isLoadingChapters: $isLoadingChapters, purchasedGoods: $purchasedGoods, isLoadingPurchased: $isLoadingPurchased, dailyPractice: $dailyPractice, skillMock: $skillMock, error: $error, errorType: $errorType, checkInSuccess: $checkInSuccess, successMessage: $successMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionBankStateImpl &&
            (identical(other.learningData, learningData) ||
                other.learningData == learningData) &&
            (identical(other.isLoadingLearning, isLoadingLearning) ||
                other.isLoadingLearning == isLoadingLearning) &&
            const DeepCollectionEquality().equals(other._chapters, _chapters) &&
            (identical(other.isLoadingChapters, isLoadingChapters) ||
                other.isLoadingChapters == isLoadingChapters) &&
            const DeepCollectionEquality()
                .equals(other._purchasedGoods, _purchasedGoods) &&
            (identical(other.isLoadingPurchased, isLoadingPurchased) ||
                other.isLoadingPurchased == isLoadingPurchased) &&
            (identical(other.dailyPractice, dailyPractice) ||
                other.dailyPractice == dailyPractice) &&
            (identical(other.skillMock, skillMock) ||
                other.skillMock == skillMock) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.errorType, errorType) ||
                other.errorType == errorType) &&
            (identical(other.checkInSuccess, checkInSuccess) ||
                other.checkInSuccess == checkInSuccess) &&
            (identical(other.successMessage, successMessage) ||
                other.successMessage == successMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      learningData,
      isLoadingLearning,
      const DeepCollectionEquality().hash(_chapters),
      isLoadingChapters,
      const DeepCollectionEquality().hash(_purchasedGoods),
      isLoadingPurchased,
      dailyPractice,
      skillMock,
      error,
      errorType,
      checkInSuccess,
      successMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionBankStateImplCopyWith<_$QuestionBankStateImpl> get copyWith =>
      __$$QuestionBankStateImplCopyWithImpl<_$QuestionBankStateImpl>(
          this, _$identity);
}

abstract class _QuestionBankState implements QuestionBankState {
  const factory _QuestionBankState(
      {final LearningDataModel? learningData,
      final bool isLoadingLearning,
      final List<ChapterModel> chapters,
      final bool isLoadingChapters,
      final List<PurchasedGoodsModel> purchasedGoods,
      final bool isLoadingPurchased,
      final DailyPracticeModel? dailyPractice,
      final SkillMockModel? skillMock,
      final String? error,
      final ErrorType? errorType,
      final bool checkInSuccess,
      final String? successMessage}) = _$QuestionBankStateImpl;

  @override // 学习数据
  LearningDataModel? get learningData;
  @override
  bool get isLoadingLearning;
  @override // 章节数据
  List<ChapterModel> get chapters;
  @override
  bool get isLoadingChapters;
  @override // 已购商品
  List<PurchasedGoodsModel> get purchasedGoods;
  @override
  bool get isLoadingPurchased;
  @override // 每日一测
  DailyPracticeModel? get dailyPractice;
  @override // 技能模拟
  SkillMockModel? get skillMock;
  @override // 错误信息
  String? get error;
  @override
  ErrorType? get errorType;
  @override // 操作成功标志
  bool get checkInSuccess;
  @override
  String? get successMessage;
  @override
  @JsonKey(ignore: true)
  _$$QuestionBankStateImplCopyWith<_$QuestionBankStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
