// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CollectionState {
// 分组后的收藏列表 (按题型分组)
  Map<String, CollectionGroupModel> get groupedQuestions =>
      throw _privateConstructorUsedError; // 全部收藏题目列表
  List<CollectionQuestionModel> get allQuestions =>
      throw _privateConstructorUsedError; // 加载状态
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isLoadingMore => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError; // 错误信息
  String? get error => throw _privateConstructorUsedError; // 分页信息
  int get currentPage => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError; // 筛选条件
  String get timeRange =>
      throw _privateConstructorUsedError; // '0'-全部, '1'-近3天, '2'-一周内, '3'-一月内, '4'-自定义
  String? get questionType => throw _privateConstructorUsedError; // 题型
  String? get startDate => throw _privateConstructorUsedError; // 开始日期
  String? get endDate => throw _privateConstructorUsedError; // 结束日期
// UI辅助字段
  String? get timeRangeName => throw _privateConstructorUsedError; // 时间范围名称
  String? get questionTypeName => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CollectionStateCopyWith<CollectionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollectionStateCopyWith<$Res> {
  factory $CollectionStateCopyWith(
          CollectionState value, $Res Function(CollectionState) then) =
      _$CollectionStateCopyWithImpl<$Res, CollectionState>;
  @useResult
  $Res call(
      {Map<String, CollectionGroupModel> groupedQuestions,
      List<CollectionQuestionModel> allQuestions,
      bool isLoading,
      bool isLoadingMore,
      bool hasMore,
      String? error,
      int currentPage,
      int total,
      String timeRange,
      String? questionType,
      String? startDate,
      String? endDate,
      String? timeRangeName,
      String? questionTypeName});
}

/// @nodoc
class _$CollectionStateCopyWithImpl<$Res, $Val extends CollectionState>
    implements $CollectionStateCopyWith<$Res> {
  _$CollectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupedQuestions = null,
    Object? allQuestions = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? hasMore = null,
    Object? error = freezed,
    Object? currentPage = null,
    Object? total = null,
    Object? timeRange = null,
    Object? questionType = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? timeRangeName = freezed,
    Object? questionTypeName = freezed,
  }) {
    return _then(_value.copyWith(
      groupedQuestions: null == groupedQuestions
          ? _value.groupedQuestions
          : groupedQuestions // ignore: cast_nullable_to_non_nullable
              as Map<String, CollectionGroupModel>,
      allQuestions: null == allQuestions
          ? _value.allQuestions
          : allQuestions // ignore: cast_nullable_to_non_nullable
              as List<CollectionQuestionModel>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      timeRange: null == timeRange
          ? _value.timeRange
          : timeRange // ignore: cast_nullable_to_non_nullable
              as String,
      questionType: freezed == questionType
          ? _value.questionType
          : questionType // ignore: cast_nullable_to_non_nullable
              as String?,
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
      questionTypeName: freezed == questionTypeName
          ? _value.questionTypeName
          : questionTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CollectionStateImplCopyWith<$Res>
    implements $CollectionStateCopyWith<$Res> {
  factory _$$CollectionStateImplCopyWith(_$CollectionStateImpl value,
          $Res Function(_$CollectionStateImpl) then) =
      __$$CollectionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, CollectionGroupModel> groupedQuestions,
      List<CollectionQuestionModel> allQuestions,
      bool isLoading,
      bool isLoadingMore,
      bool hasMore,
      String? error,
      int currentPage,
      int total,
      String timeRange,
      String? questionType,
      String? startDate,
      String? endDate,
      String? timeRangeName,
      String? questionTypeName});
}

/// @nodoc
class __$$CollectionStateImplCopyWithImpl<$Res>
    extends _$CollectionStateCopyWithImpl<$Res, _$CollectionStateImpl>
    implements _$$CollectionStateImplCopyWith<$Res> {
  __$$CollectionStateImplCopyWithImpl(
      _$CollectionStateImpl _value, $Res Function(_$CollectionStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupedQuestions = null,
    Object? allQuestions = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? hasMore = null,
    Object? error = freezed,
    Object? currentPage = null,
    Object? total = null,
    Object? timeRange = null,
    Object? questionType = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? timeRangeName = freezed,
    Object? questionTypeName = freezed,
  }) {
    return _then(_$CollectionStateImpl(
      groupedQuestions: null == groupedQuestions
          ? _value._groupedQuestions
          : groupedQuestions // ignore: cast_nullable_to_non_nullable
              as Map<String, CollectionGroupModel>,
      allQuestions: null == allQuestions
          ? _value._allQuestions
          : allQuestions // ignore: cast_nullable_to_non_nullable
              as List<CollectionQuestionModel>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      timeRange: null == timeRange
          ? _value.timeRange
          : timeRange // ignore: cast_nullable_to_non_nullable
              as String,
      questionType: freezed == questionType
          ? _value.questionType
          : questionType // ignore: cast_nullable_to_non_nullable
              as String?,
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
      questionTypeName: freezed == questionTypeName
          ? _value.questionTypeName
          : questionTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CollectionStateImpl implements _CollectionState {
  const _$CollectionStateImpl(
      {final Map<String, CollectionGroupModel> groupedQuestions = const {},
      final List<CollectionQuestionModel> allQuestions = const [],
      this.isLoading = false,
      this.isLoadingMore = false,
      this.hasMore = false,
      this.error,
      this.currentPage = 1,
      this.total = 0,
      this.timeRange = '0',
      this.questionType,
      this.startDate,
      this.endDate,
      this.timeRangeName,
      this.questionTypeName})
      : _groupedQuestions = groupedQuestions,
        _allQuestions = allQuestions;

// 分组后的收藏列表 (按题型分组)
  final Map<String, CollectionGroupModel> _groupedQuestions;
// 分组后的收藏列表 (按题型分组)
  @override
  @JsonKey()
  Map<String, CollectionGroupModel> get groupedQuestions {
    if (_groupedQuestions is EqualUnmodifiableMapView) return _groupedQuestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_groupedQuestions);
  }

// 全部收藏题目列表
  final List<CollectionQuestionModel> _allQuestions;
// 全部收藏题目列表
  @override
  @JsonKey()
  List<CollectionQuestionModel> get allQuestions {
    if (_allQuestions is EqualUnmodifiableListView) return _allQuestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allQuestions);
  }

// 加载状态
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isLoadingMore;
  @override
  @JsonKey()
  final bool hasMore;
// 错误信息
  @override
  final String? error;
// 分页信息
  @override
  @JsonKey()
  final int currentPage;
  @override
  @JsonKey()
  final int total;
// 筛选条件
  @override
  @JsonKey()
  final String timeRange;
// '0'-全部, '1'-近3天, '2'-一周内, '3'-一月内, '4'-自定义
  @override
  final String? questionType;
// 题型
  @override
  final String? startDate;
// 开始日期
  @override
  final String? endDate;
// 结束日期
// UI辅助字段
  @override
  final String? timeRangeName;
// 时间范围名称
  @override
  final String? questionTypeName;

  @override
  String toString() {
    return 'CollectionState(groupedQuestions: $groupedQuestions, allQuestions: $allQuestions, isLoading: $isLoading, isLoadingMore: $isLoadingMore, hasMore: $hasMore, error: $error, currentPage: $currentPage, total: $total, timeRange: $timeRange, questionType: $questionType, startDate: $startDate, endDate: $endDate, timeRangeName: $timeRangeName, questionTypeName: $questionTypeName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectionStateImpl &&
            const DeepCollectionEquality()
                .equals(other._groupedQuestions, _groupedQuestions) &&
            const DeepCollectionEquality()
                .equals(other._allQuestions, _allQuestions) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.timeRange, timeRange) ||
                other.timeRange == timeRange) &&
            (identical(other.questionType, questionType) ||
                other.questionType == questionType) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.timeRangeName, timeRangeName) ||
                other.timeRangeName == timeRangeName) &&
            (identical(other.questionTypeName, questionTypeName) ||
                other.questionTypeName == questionTypeName));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_groupedQuestions),
      const DeepCollectionEquality().hash(_allQuestions),
      isLoading,
      isLoadingMore,
      hasMore,
      error,
      currentPage,
      total,
      timeRange,
      questionType,
      startDate,
      endDate,
      timeRangeName,
      questionTypeName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CollectionStateImplCopyWith<_$CollectionStateImpl> get copyWith =>
      __$$CollectionStateImplCopyWithImpl<_$CollectionStateImpl>(
          this, _$identity);
}

abstract class _CollectionState implements CollectionState {
  const factory _CollectionState(
      {final Map<String, CollectionGroupModel> groupedQuestions,
      final List<CollectionQuestionModel> allQuestions,
      final bool isLoading,
      final bool isLoadingMore,
      final bool hasMore,
      final String? error,
      final int currentPage,
      final int total,
      final String timeRange,
      final String? questionType,
      final String? startDate,
      final String? endDate,
      final String? timeRangeName,
      final String? questionTypeName}) = _$CollectionStateImpl;

  @override // 分组后的收藏列表 (按题型分组)
  Map<String, CollectionGroupModel> get groupedQuestions;
  @override // 全部收藏题目列表
  List<CollectionQuestionModel> get allQuestions;
  @override // 加载状态
  bool get isLoading;
  @override
  bool get isLoadingMore;
  @override
  bool get hasMore;
  @override // 错误信息
  String? get error;
  @override // 分页信息
  int get currentPage;
  @override
  int get total;
  @override // 筛选条件
  String get timeRange;
  @override // '0'-全部, '1'-近3天, '2'-一周内, '3'-一月内, '4'-自定义
  String? get questionType;
  @override // 题型
  String? get startDate;
  @override // 开始日期
  String? get endDate;
  @override // 结束日期
// UI辅助字段
  String? get timeRangeName;
  @override // 时间范围名称
  String? get questionTypeName;
  @override
  @JsonKey(ignore: true)
  _$$CollectionStateImplCopyWith<_$CollectionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
