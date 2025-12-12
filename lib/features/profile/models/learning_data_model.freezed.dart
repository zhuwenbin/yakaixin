// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_data_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LearningDataModel _$LearningDataModelFromJson(Map<String, dynamic> json) {
  return _LearningDataModel.fromJson(json);
}

/// @nodoc
mixin _$LearningDataModel {
  /// 正确率(%)
  @JsonKey(name: 'correct_rate')
  String? get correctRate => throw _privateConstructorUsedError;

  /// 易错知识点列表
  @JsonKey(name: 'knowledge_err_list')
  List<KnowledgeErrorModel> get knowledgeErrList =>
      throw _privateConstructorUsedError;

  /// 学习知识点数量
  @JsonKey(name: 'knowledge_num')
  dynamic get knowledgeNum => throw _privateConstructorUsedError;

  /// 学习时长(小时)
  @JsonKey(name: 'learn_time')
  String? get learnTime => throw _privateConstructorUsedError;

  /// 本月刷题量数据
  @JsonKey(name: 'to_month_do_question_num')
  List<DailyQuestionModel> get toMonthDoQuestionNum =>
      throw _privateConstructorUsedError;

  /// 本月学习时长数据
  @JsonKey(name: 'to_month_learn_time')
  List<DailyLearnTimeModel> get toMonthLearnTime =>
      throw _privateConstructorUsedError;

  /// 一周刷题量数据
  @JsonKey(name: 'to_week_do_question_num')
  List<DailyQuestionModel> get toWeekDoQuestionNum =>
      throw _privateConstructorUsedError;

  /// 一周学习时长数据
  @JsonKey(name: 'to_week_learn_time')
  List<DailyLearnTimeModel> get toWeekLearnTime =>
      throw _privateConstructorUsedError;

  /// 今日学习时长
  @JsonKey(name: 'today_learn_time')
  String? get todayLearnTime => throw _privateConstructorUsedError;

  /// 今日刷题量
  @JsonKey(name: 'today_total_num')
  dynamic get todayTotalNum => throw _privateConstructorUsedError;

  /// 总刷题量
  @JsonKey(name: 'total_num')
  dynamic get totalNum => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LearningDataModelCopyWith<LearningDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningDataModelCopyWith<$Res> {
  factory $LearningDataModelCopyWith(
          LearningDataModel value, $Res Function(LearningDataModel) then) =
      _$LearningDataModelCopyWithImpl<$Res, LearningDataModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'correct_rate') String? correctRate,
      @JsonKey(name: 'knowledge_err_list')
      List<KnowledgeErrorModel> knowledgeErrList,
      @JsonKey(name: 'knowledge_num') dynamic knowledgeNum,
      @JsonKey(name: 'learn_time') String? learnTime,
      @JsonKey(name: 'to_month_do_question_num')
      List<DailyQuestionModel> toMonthDoQuestionNum,
      @JsonKey(name: 'to_month_learn_time')
      List<DailyLearnTimeModel> toMonthLearnTime,
      @JsonKey(name: 'to_week_do_question_num')
      List<DailyQuestionModel> toWeekDoQuestionNum,
      @JsonKey(name: 'to_week_learn_time')
      List<DailyLearnTimeModel> toWeekLearnTime,
      @JsonKey(name: 'today_learn_time') String? todayLearnTime,
      @JsonKey(name: 'today_total_num') dynamic todayTotalNum,
      @JsonKey(name: 'total_num') dynamic totalNum});
}

/// @nodoc
class _$LearningDataModelCopyWithImpl<$Res, $Val extends LearningDataModel>
    implements $LearningDataModelCopyWith<$Res> {
  _$LearningDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? correctRate = freezed,
    Object? knowledgeErrList = null,
    Object? knowledgeNum = freezed,
    Object? learnTime = freezed,
    Object? toMonthDoQuestionNum = null,
    Object? toMonthLearnTime = null,
    Object? toWeekDoQuestionNum = null,
    Object? toWeekLearnTime = null,
    Object? todayLearnTime = freezed,
    Object? todayTotalNum = freezed,
    Object? totalNum = freezed,
  }) {
    return _then(_value.copyWith(
      correctRate: freezed == correctRate
          ? _value.correctRate
          : correctRate // ignore: cast_nullable_to_non_nullable
              as String?,
      knowledgeErrList: null == knowledgeErrList
          ? _value.knowledgeErrList
          : knowledgeErrList // ignore: cast_nullable_to_non_nullable
              as List<KnowledgeErrorModel>,
      knowledgeNum: freezed == knowledgeNum
          ? _value.knowledgeNum
          : knowledgeNum // ignore: cast_nullable_to_non_nullable
              as dynamic,
      learnTime: freezed == learnTime
          ? _value.learnTime
          : learnTime // ignore: cast_nullable_to_non_nullable
              as String?,
      toMonthDoQuestionNum: null == toMonthDoQuestionNum
          ? _value.toMonthDoQuestionNum
          : toMonthDoQuestionNum // ignore: cast_nullable_to_non_nullable
              as List<DailyQuestionModel>,
      toMonthLearnTime: null == toMonthLearnTime
          ? _value.toMonthLearnTime
          : toMonthLearnTime // ignore: cast_nullable_to_non_nullable
              as List<DailyLearnTimeModel>,
      toWeekDoQuestionNum: null == toWeekDoQuestionNum
          ? _value.toWeekDoQuestionNum
          : toWeekDoQuestionNum // ignore: cast_nullable_to_non_nullable
              as List<DailyQuestionModel>,
      toWeekLearnTime: null == toWeekLearnTime
          ? _value.toWeekLearnTime
          : toWeekLearnTime // ignore: cast_nullable_to_non_nullable
              as List<DailyLearnTimeModel>,
      todayLearnTime: freezed == todayLearnTime
          ? _value.todayLearnTime
          : todayLearnTime // ignore: cast_nullable_to_non_nullable
              as String?,
      todayTotalNum: freezed == todayTotalNum
          ? _value.todayTotalNum
          : todayTotalNum // ignore: cast_nullable_to_non_nullable
              as dynamic,
      totalNum: freezed == totalNum
          ? _value.totalNum
          : totalNum // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LearningDataModelImplCopyWith<$Res>
    implements $LearningDataModelCopyWith<$Res> {
  factory _$$LearningDataModelImplCopyWith(_$LearningDataModelImpl value,
          $Res Function(_$LearningDataModelImpl) then) =
      __$$LearningDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'correct_rate') String? correctRate,
      @JsonKey(name: 'knowledge_err_list')
      List<KnowledgeErrorModel> knowledgeErrList,
      @JsonKey(name: 'knowledge_num') dynamic knowledgeNum,
      @JsonKey(name: 'learn_time') String? learnTime,
      @JsonKey(name: 'to_month_do_question_num')
      List<DailyQuestionModel> toMonthDoQuestionNum,
      @JsonKey(name: 'to_month_learn_time')
      List<DailyLearnTimeModel> toMonthLearnTime,
      @JsonKey(name: 'to_week_do_question_num')
      List<DailyQuestionModel> toWeekDoQuestionNum,
      @JsonKey(name: 'to_week_learn_time')
      List<DailyLearnTimeModel> toWeekLearnTime,
      @JsonKey(name: 'today_learn_time') String? todayLearnTime,
      @JsonKey(name: 'today_total_num') dynamic todayTotalNum,
      @JsonKey(name: 'total_num') dynamic totalNum});
}

/// @nodoc
class __$$LearningDataModelImplCopyWithImpl<$Res>
    extends _$LearningDataModelCopyWithImpl<$Res, _$LearningDataModelImpl>
    implements _$$LearningDataModelImplCopyWith<$Res> {
  __$$LearningDataModelImplCopyWithImpl(_$LearningDataModelImpl _value,
      $Res Function(_$LearningDataModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? correctRate = freezed,
    Object? knowledgeErrList = null,
    Object? knowledgeNum = freezed,
    Object? learnTime = freezed,
    Object? toMonthDoQuestionNum = null,
    Object? toMonthLearnTime = null,
    Object? toWeekDoQuestionNum = null,
    Object? toWeekLearnTime = null,
    Object? todayLearnTime = freezed,
    Object? todayTotalNum = freezed,
    Object? totalNum = freezed,
  }) {
    return _then(_$LearningDataModelImpl(
      correctRate: freezed == correctRate
          ? _value.correctRate
          : correctRate // ignore: cast_nullable_to_non_nullable
              as String?,
      knowledgeErrList: null == knowledgeErrList
          ? _value._knowledgeErrList
          : knowledgeErrList // ignore: cast_nullable_to_non_nullable
              as List<KnowledgeErrorModel>,
      knowledgeNum: freezed == knowledgeNum
          ? _value.knowledgeNum
          : knowledgeNum // ignore: cast_nullable_to_non_nullable
              as dynamic,
      learnTime: freezed == learnTime
          ? _value.learnTime
          : learnTime // ignore: cast_nullable_to_non_nullable
              as String?,
      toMonthDoQuestionNum: null == toMonthDoQuestionNum
          ? _value._toMonthDoQuestionNum
          : toMonthDoQuestionNum // ignore: cast_nullable_to_non_nullable
              as List<DailyQuestionModel>,
      toMonthLearnTime: null == toMonthLearnTime
          ? _value._toMonthLearnTime
          : toMonthLearnTime // ignore: cast_nullable_to_non_nullable
              as List<DailyLearnTimeModel>,
      toWeekDoQuestionNum: null == toWeekDoQuestionNum
          ? _value._toWeekDoQuestionNum
          : toWeekDoQuestionNum // ignore: cast_nullable_to_non_nullable
              as List<DailyQuestionModel>,
      toWeekLearnTime: null == toWeekLearnTime
          ? _value._toWeekLearnTime
          : toWeekLearnTime // ignore: cast_nullable_to_non_nullable
              as List<DailyLearnTimeModel>,
      todayLearnTime: freezed == todayLearnTime
          ? _value.todayLearnTime
          : todayLearnTime // ignore: cast_nullable_to_non_nullable
              as String?,
      todayTotalNum: freezed == todayTotalNum
          ? _value.todayTotalNum
          : todayTotalNum // ignore: cast_nullable_to_non_nullable
              as dynamic,
      totalNum: freezed == totalNum
          ? _value.totalNum
          : totalNum // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LearningDataModelImpl implements _LearningDataModel {
  const _$LearningDataModelImpl(
      {@JsonKey(name: 'correct_rate') this.correctRate,
      @JsonKey(name: 'knowledge_err_list')
      final List<KnowledgeErrorModel> knowledgeErrList = const [],
      @JsonKey(name: 'knowledge_num') this.knowledgeNum,
      @JsonKey(name: 'learn_time') this.learnTime,
      @JsonKey(name: 'to_month_do_question_num')
      final List<DailyQuestionModel> toMonthDoQuestionNum = const [],
      @JsonKey(name: 'to_month_learn_time')
      final List<DailyLearnTimeModel> toMonthLearnTime = const [],
      @JsonKey(name: 'to_week_do_question_num')
      final List<DailyQuestionModel> toWeekDoQuestionNum = const [],
      @JsonKey(name: 'to_week_learn_time')
      final List<DailyLearnTimeModel> toWeekLearnTime = const [],
      @JsonKey(name: 'today_learn_time') this.todayLearnTime,
      @JsonKey(name: 'today_total_num') this.todayTotalNum,
      @JsonKey(name: 'total_num') this.totalNum})
      : _knowledgeErrList = knowledgeErrList,
        _toMonthDoQuestionNum = toMonthDoQuestionNum,
        _toMonthLearnTime = toMonthLearnTime,
        _toWeekDoQuestionNum = toWeekDoQuestionNum,
        _toWeekLearnTime = toWeekLearnTime;

  factory _$LearningDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LearningDataModelImplFromJson(json);

  /// 正确率(%)
  @override
  @JsonKey(name: 'correct_rate')
  final String? correctRate;

  /// 易错知识点列表
  final List<KnowledgeErrorModel> _knowledgeErrList;

  /// 易错知识点列表
  @override
  @JsonKey(name: 'knowledge_err_list')
  List<KnowledgeErrorModel> get knowledgeErrList {
    if (_knowledgeErrList is EqualUnmodifiableListView)
      return _knowledgeErrList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_knowledgeErrList);
  }

  /// 学习知识点数量
  @override
  @JsonKey(name: 'knowledge_num')
  final dynamic knowledgeNum;

  /// 学习时长(小时)
  @override
  @JsonKey(name: 'learn_time')
  final String? learnTime;

  /// 本月刷题量数据
  final List<DailyQuestionModel> _toMonthDoQuestionNum;

  /// 本月刷题量数据
  @override
  @JsonKey(name: 'to_month_do_question_num')
  List<DailyQuestionModel> get toMonthDoQuestionNum {
    if (_toMonthDoQuestionNum is EqualUnmodifiableListView)
      return _toMonthDoQuestionNum;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_toMonthDoQuestionNum);
  }

  /// 本月学习时长数据
  final List<DailyLearnTimeModel> _toMonthLearnTime;

  /// 本月学习时长数据
  @override
  @JsonKey(name: 'to_month_learn_time')
  List<DailyLearnTimeModel> get toMonthLearnTime {
    if (_toMonthLearnTime is EqualUnmodifiableListView)
      return _toMonthLearnTime;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_toMonthLearnTime);
  }

  /// 一周刷题量数据
  final List<DailyQuestionModel> _toWeekDoQuestionNum;

  /// 一周刷题量数据
  @override
  @JsonKey(name: 'to_week_do_question_num')
  List<DailyQuestionModel> get toWeekDoQuestionNum {
    if (_toWeekDoQuestionNum is EqualUnmodifiableListView)
      return _toWeekDoQuestionNum;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_toWeekDoQuestionNum);
  }

  /// 一周学习时长数据
  final List<DailyLearnTimeModel> _toWeekLearnTime;

  /// 一周学习时长数据
  @override
  @JsonKey(name: 'to_week_learn_time')
  List<DailyLearnTimeModel> get toWeekLearnTime {
    if (_toWeekLearnTime is EqualUnmodifiableListView) return _toWeekLearnTime;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_toWeekLearnTime);
  }

  /// 今日学习时长
  @override
  @JsonKey(name: 'today_learn_time')
  final String? todayLearnTime;

  /// 今日刷题量
  @override
  @JsonKey(name: 'today_total_num')
  final dynamic todayTotalNum;

  /// 总刷题量
  @override
  @JsonKey(name: 'total_num')
  final dynamic totalNum;

  @override
  String toString() {
    return 'LearningDataModel(correctRate: $correctRate, knowledgeErrList: $knowledgeErrList, knowledgeNum: $knowledgeNum, learnTime: $learnTime, toMonthDoQuestionNum: $toMonthDoQuestionNum, toMonthLearnTime: $toMonthLearnTime, toWeekDoQuestionNum: $toWeekDoQuestionNum, toWeekLearnTime: $toWeekLearnTime, todayLearnTime: $todayLearnTime, todayTotalNum: $todayTotalNum, totalNum: $totalNum)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningDataModelImpl &&
            (identical(other.correctRate, correctRate) ||
                other.correctRate == correctRate) &&
            const DeepCollectionEquality()
                .equals(other._knowledgeErrList, _knowledgeErrList) &&
            const DeepCollectionEquality()
                .equals(other.knowledgeNum, knowledgeNum) &&
            (identical(other.learnTime, learnTime) ||
                other.learnTime == learnTime) &&
            const DeepCollectionEquality()
                .equals(other._toMonthDoQuestionNum, _toMonthDoQuestionNum) &&
            const DeepCollectionEquality()
                .equals(other._toMonthLearnTime, _toMonthLearnTime) &&
            const DeepCollectionEquality()
                .equals(other._toWeekDoQuestionNum, _toWeekDoQuestionNum) &&
            const DeepCollectionEquality()
                .equals(other._toWeekLearnTime, _toWeekLearnTime) &&
            (identical(other.todayLearnTime, todayLearnTime) ||
                other.todayLearnTime == todayLearnTime) &&
            const DeepCollectionEquality()
                .equals(other.todayTotalNum, todayTotalNum) &&
            const DeepCollectionEquality().equals(other.totalNum, totalNum));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      correctRate,
      const DeepCollectionEquality().hash(_knowledgeErrList),
      const DeepCollectionEquality().hash(knowledgeNum),
      learnTime,
      const DeepCollectionEquality().hash(_toMonthDoQuestionNum),
      const DeepCollectionEquality().hash(_toMonthLearnTime),
      const DeepCollectionEquality().hash(_toWeekDoQuestionNum),
      const DeepCollectionEquality().hash(_toWeekLearnTime),
      todayLearnTime,
      const DeepCollectionEquality().hash(todayTotalNum),
      const DeepCollectionEquality().hash(totalNum));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningDataModelImplCopyWith<_$LearningDataModelImpl> get copyWith =>
      __$$LearningDataModelImplCopyWithImpl<_$LearningDataModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LearningDataModelImplToJson(
      this,
    );
  }
}

abstract class _LearningDataModel implements LearningDataModel {
  const factory _LearningDataModel(
          {@JsonKey(name: 'correct_rate') final String? correctRate,
          @JsonKey(name: 'knowledge_err_list')
          final List<KnowledgeErrorModel> knowledgeErrList,
          @JsonKey(name: 'knowledge_num') final dynamic knowledgeNum,
          @JsonKey(name: 'learn_time') final String? learnTime,
          @JsonKey(name: 'to_month_do_question_num')
          final List<DailyQuestionModel> toMonthDoQuestionNum,
          @JsonKey(name: 'to_month_learn_time')
          final List<DailyLearnTimeModel> toMonthLearnTime,
          @JsonKey(name: 'to_week_do_question_num')
          final List<DailyQuestionModel> toWeekDoQuestionNum,
          @JsonKey(name: 'to_week_learn_time')
          final List<DailyLearnTimeModel> toWeekLearnTime,
          @JsonKey(name: 'today_learn_time') final String? todayLearnTime,
          @JsonKey(name: 'today_total_num') final dynamic todayTotalNum,
          @JsonKey(name: 'total_num') final dynamic totalNum}) =
      _$LearningDataModelImpl;

  factory _LearningDataModel.fromJson(Map<String, dynamic> json) =
      _$LearningDataModelImpl.fromJson;

  @override

  /// 正确率(%)
  @JsonKey(name: 'correct_rate')
  String? get correctRate;
  @override

  /// 易错知识点列表
  @JsonKey(name: 'knowledge_err_list')
  List<KnowledgeErrorModel> get knowledgeErrList;
  @override

  /// 学习知识点数量
  @JsonKey(name: 'knowledge_num')
  dynamic get knowledgeNum;
  @override

  /// 学习时长(小时)
  @JsonKey(name: 'learn_time')
  String? get learnTime;
  @override

  /// 本月刷题量数据
  @JsonKey(name: 'to_month_do_question_num')
  List<DailyQuestionModel> get toMonthDoQuestionNum;
  @override

  /// 本月学习时长数据
  @JsonKey(name: 'to_month_learn_time')
  List<DailyLearnTimeModel> get toMonthLearnTime;
  @override

  /// 一周刷题量数据
  @JsonKey(name: 'to_week_do_question_num')
  List<DailyQuestionModel> get toWeekDoQuestionNum;
  @override

  /// 一周学习时长数据
  @JsonKey(name: 'to_week_learn_time')
  List<DailyLearnTimeModel> get toWeekLearnTime;
  @override

  /// 今日学习时长
  @JsonKey(name: 'today_learn_time')
  String? get todayLearnTime;
  @override

  /// 今日刷题量
  @JsonKey(name: 'today_total_num')
  dynamic get todayTotalNum;
  @override

  /// 总刷题量
  @JsonKey(name: 'total_num')
  dynamic get totalNum;
  @override
  @JsonKey(ignore: true)
  _$$LearningDataModelImplCopyWith<_$LearningDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

KnowledgeErrorModel _$KnowledgeErrorModelFromJson(Map<String, dynamic> json) {
  return _KnowledgeErrorModel.fromJson(json);
}

/// @nodoc
mixin _$KnowledgeErrorModel {
  /// 错误次数
  @JsonKey(name: 'fault_sum')
  dynamic get faultSum => throw _privateConstructorUsedError;

  /// 知识点ID
  @JsonKey(name: 'knowledge_id')
  String? get knowledgeId => throw _privateConstructorUsedError;

  /// 知识点名称
  @JsonKey(name: 'knowledge_id_name')
  String? get knowledgeIdName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $KnowledgeErrorModelCopyWith<KnowledgeErrorModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KnowledgeErrorModelCopyWith<$Res> {
  factory $KnowledgeErrorModelCopyWith(
          KnowledgeErrorModel value, $Res Function(KnowledgeErrorModel) then) =
      _$KnowledgeErrorModelCopyWithImpl<$Res, KnowledgeErrorModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'fault_sum') dynamic faultSum,
      @JsonKey(name: 'knowledge_id') String? knowledgeId,
      @JsonKey(name: 'knowledge_id_name') String? knowledgeIdName});
}

/// @nodoc
class _$KnowledgeErrorModelCopyWithImpl<$Res, $Val extends KnowledgeErrorModel>
    implements $KnowledgeErrorModelCopyWith<$Res> {
  _$KnowledgeErrorModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? faultSum = freezed,
    Object? knowledgeId = freezed,
    Object? knowledgeIdName = freezed,
  }) {
    return _then(_value.copyWith(
      faultSum: freezed == faultSum
          ? _value.faultSum
          : faultSum // ignore: cast_nullable_to_non_nullable
              as dynamic,
      knowledgeId: freezed == knowledgeId
          ? _value.knowledgeId
          : knowledgeId // ignore: cast_nullable_to_non_nullable
              as String?,
      knowledgeIdName: freezed == knowledgeIdName
          ? _value.knowledgeIdName
          : knowledgeIdName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KnowledgeErrorModelImplCopyWith<$Res>
    implements $KnowledgeErrorModelCopyWith<$Res> {
  factory _$$KnowledgeErrorModelImplCopyWith(_$KnowledgeErrorModelImpl value,
          $Res Function(_$KnowledgeErrorModelImpl) then) =
      __$$KnowledgeErrorModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'fault_sum') dynamic faultSum,
      @JsonKey(name: 'knowledge_id') String? knowledgeId,
      @JsonKey(name: 'knowledge_id_name') String? knowledgeIdName});
}

/// @nodoc
class __$$KnowledgeErrorModelImplCopyWithImpl<$Res>
    extends _$KnowledgeErrorModelCopyWithImpl<$Res, _$KnowledgeErrorModelImpl>
    implements _$$KnowledgeErrorModelImplCopyWith<$Res> {
  __$$KnowledgeErrorModelImplCopyWithImpl(_$KnowledgeErrorModelImpl _value,
      $Res Function(_$KnowledgeErrorModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? faultSum = freezed,
    Object? knowledgeId = freezed,
    Object? knowledgeIdName = freezed,
  }) {
    return _then(_$KnowledgeErrorModelImpl(
      faultSum: freezed == faultSum
          ? _value.faultSum
          : faultSum // ignore: cast_nullable_to_non_nullable
              as dynamic,
      knowledgeId: freezed == knowledgeId
          ? _value.knowledgeId
          : knowledgeId // ignore: cast_nullable_to_non_nullable
              as String?,
      knowledgeIdName: freezed == knowledgeIdName
          ? _value.knowledgeIdName
          : knowledgeIdName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KnowledgeErrorModelImpl implements _KnowledgeErrorModel {
  const _$KnowledgeErrorModelImpl(
      {@JsonKey(name: 'fault_sum') this.faultSum,
      @JsonKey(name: 'knowledge_id') this.knowledgeId,
      @JsonKey(name: 'knowledge_id_name') this.knowledgeIdName});

  factory _$KnowledgeErrorModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$KnowledgeErrorModelImplFromJson(json);

  /// 错误次数
  @override
  @JsonKey(name: 'fault_sum')
  final dynamic faultSum;

  /// 知识点ID
  @override
  @JsonKey(name: 'knowledge_id')
  final String? knowledgeId;

  /// 知识点名称
  @override
  @JsonKey(name: 'knowledge_id_name')
  final String? knowledgeIdName;

  @override
  String toString() {
    return 'KnowledgeErrorModel(faultSum: $faultSum, knowledgeId: $knowledgeId, knowledgeIdName: $knowledgeIdName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KnowledgeErrorModelImpl &&
            const DeepCollectionEquality().equals(other.faultSum, faultSum) &&
            (identical(other.knowledgeId, knowledgeId) ||
                other.knowledgeId == knowledgeId) &&
            (identical(other.knowledgeIdName, knowledgeIdName) ||
                other.knowledgeIdName == knowledgeIdName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(faultSum),
      knowledgeId,
      knowledgeIdName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$KnowledgeErrorModelImplCopyWith<_$KnowledgeErrorModelImpl> get copyWith =>
      __$$KnowledgeErrorModelImplCopyWithImpl<_$KnowledgeErrorModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KnowledgeErrorModelImplToJson(
      this,
    );
  }
}

abstract class _KnowledgeErrorModel implements KnowledgeErrorModel {
  const factory _KnowledgeErrorModel(
          {@JsonKey(name: 'fault_sum') final dynamic faultSum,
          @JsonKey(name: 'knowledge_id') final String? knowledgeId,
          @JsonKey(name: 'knowledge_id_name') final String? knowledgeIdName}) =
      _$KnowledgeErrorModelImpl;

  factory _KnowledgeErrorModel.fromJson(Map<String, dynamic> json) =
      _$KnowledgeErrorModelImpl.fromJson;

  @override

  /// 错误次数
  @JsonKey(name: 'fault_sum')
  dynamic get faultSum;
  @override

  /// 知识点ID
  @JsonKey(name: 'knowledge_id')
  String? get knowledgeId;
  @override

  /// 知识点名称
  @JsonKey(name: 'knowledge_id_name')
  String? get knowledgeIdName;
  @override
  @JsonKey(ignore: true)
  _$$KnowledgeErrorModelImplCopyWith<_$KnowledgeErrorModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyQuestionModel _$DailyQuestionModelFromJson(Map<String, dynamic> json) {
  return _DailyQuestionModel.fromJson(json);
}

/// @nodoc
mixin _$DailyQuestionModel {
  /// 日期 (如: "01-20")
  String? get date => throw _privateConstructorUsedError;

  /// 数量
  dynamic get num => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DailyQuestionModelCopyWith<DailyQuestionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyQuestionModelCopyWith<$Res> {
  factory $DailyQuestionModelCopyWith(
          DailyQuestionModel value, $Res Function(DailyQuestionModel) then) =
      _$DailyQuestionModelCopyWithImpl<$Res, DailyQuestionModel>;
  @useResult
  $Res call({String? date, dynamic num});
}

/// @nodoc
class _$DailyQuestionModelCopyWithImpl<$Res, $Val extends DailyQuestionModel>
    implements $DailyQuestionModelCopyWith<$Res> {
  _$DailyQuestionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = freezed,
    Object? num = freezed,
  }) {
    return _then(_value.copyWith(
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      num: freezed == num
          ? _value.num
          : num // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyQuestionModelImplCopyWith<$Res>
    implements $DailyQuestionModelCopyWith<$Res> {
  factory _$$DailyQuestionModelImplCopyWith(_$DailyQuestionModelImpl value,
          $Res Function(_$DailyQuestionModelImpl) then) =
      __$$DailyQuestionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? date, dynamic num});
}

/// @nodoc
class __$$DailyQuestionModelImplCopyWithImpl<$Res>
    extends _$DailyQuestionModelCopyWithImpl<$Res, _$DailyQuestionModelImpl>
    implements _$$DailyQuestionModelImplCopyWith<$Res> {
  __$$DailyQuestionModelImplCopyWithImpl(_$DailyQuestionModelImpl _value,
      $Res Function(_$DailyQuestionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = freezed,
    Object? num = freezed,
  }) {
    return _then(_$DailyQuestionModelImpl(
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      num: freezed == num
          ? _value.num
          : num // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyQuestionModelImpl implements _DailyQuestionModel {
  const _$DailyQuestionModelImpl({this.date, this.num});

  factory _$DailyQuestionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyQuestionModelImplFromJson(json);

  /// 日期 (如: "01-20")
  @override
  final String? date;

  /// 数量
  @override
  final dynamic num;

  @override
  String toString() {
    return 'DailyQuestionModel(date: $date, num: $num)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyQuestionModelImpl &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other.num, num));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, date, const DeepCollectionEquality().hash(num));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyQuestionModelImplCopyWith<_$DailyQuestionModelImpl> get copyWith =>
      __$$DailyQuestionModelImplCopyWithImpl<_$DailyQuestionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyQuestionModelImplToJson(
      this,
    );
  }
}

abstract class _DailyQuestionModel implements DailyQuestionModel {
  const factory _DailyQuestionModel({final String? date, final dynamic num}) =
      _$DailyQuestionModelImpl;

  factory _DailyQuestionModel.fromJson(Map<String, dynamic> json) =
      _$DailyQuestionModelImpl.fromJson;

  @override

  /// 日期 (如: "01-20")
  String? get date;
  @override

  /// 数量
  dynamic get num;
  @override
  @JsonKey(ignore: true)
  _$$DailyQuestionModelImplCopyWith<_$DailyQuestionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyLearnTimeModel _$DailyLearnTimeModelFromJson(Map<String, dynamic> json) {
  return _DailyLearnTimeModel.fromJson(json);
}

/// @nodoc
mixin _$DailyLearnTimeModel {
  /// 日期
  String? get date => throw _privateConstructorUsedError;

  /// 学习时长(小时)
  @JsonKey(name: 'learn_time')
  dynamic get learnTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DailyLearnTimeModelCopyWith<DailyLearnTimeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyLearnTimeModelCopyWith<$Res> {
  factory $DailyLearnTimeModelCopyWith(
          DailyLearnTimeModel value, $Res Function(DailyLearnTimeModel) then) =
      _$DailyLearnTimeModelCopyWithImpl<$Res, DailyLearnTimeModel>;
  @useResult
  $Res call({String? date, @JsonKey(name: 'learn_time') dynamic learnTime});
}

/// @nodoc
class _$DailyLearnTimeModelCopyWithImpl<$Res, $Val extends DailyLearnTimeModel>
    implements $DailyLearnTimeModelCopyWith<$Res> {
  _$DailyLearnTimeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = freezed,
    Object? learnTime = freezed,
  }) {
    return _then(_value.copyWith(
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      learnTime: freezed == learnTime
          ? _value.learnTime
          : learnTime // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyLearnTimeModelImplCopyWith<$Res>
    implements $DailyLearnTimeModelCopyWith<$Res> {
  factory _$$DailyLearnTimeModelImplCopyWith(_$DailyLearnTimeModelImpl value,
          $Res Function(_$DailyLearnTimeModelImpl) then) =
      __$$DailyLearnTimeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? date, @JsonKey(name: 'learn_time') dynamic learnTime});
}

/// @nodoc
class __$$DailyLearnTimeModelImplCopyWithImpl<$Res>
    extends _$DailyLearnTimeModelCopyWithImpl<$Res, _$DailyLearnTimeModelImpl>
    implements _$$DailyLearnTimeModelImplCopyWith<$Res> {
  __$$DailyLearnTimeModelImplCopyWithImpl(_$DailyLearnTimeModelImpl _value,
      $Res Function(_$DailyLearnTimeModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = freezed,
    Object? learnTime = freezed,
  }) {
    return _then(_$DailyLearnTimeModelImpl(
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      learnTime: freezed == learnTime
          ? _value.learnTime
          : learnTime // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyLearnTimeModelImpl implements _DailyLearnTimeModel {
  const _$DailyLearnTimeModelImpl(
      {this.date, @JsonKey(name: 'learn_time') this.learnTime});

  factory _$DailyLearnTimeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyLearnTimeModelImplFromJson(json);

  /// 日期
  @override
  final String? date;

  /// 学习时长(小时)
  @override
  @JsonKey(name: 'learn_time')
  final dynamic learnTime;

  @override
  String toString() {
    return 'DailyLearnTimeModel(date: $date, learnTime: $learnTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyLearnTimeModelImpl &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other.learnTime, learnTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, date, const DeepCollectionEquality().hash(learnTime));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyLearnTimeModelImplCopyWith<_$DailyLearnTimeModelImpl> get copyWith =>
      __$$DailyLearnTimeModelImplCopyWithImpl<_$DailyLearnTimeModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyLearnTimeModelImplToJson(
      this,
    );
  }
}

abstract class _DailyLearnTimeModel implements DailyLearnTimeModel {
  const factory _DailyLearnTimeModel(
          {final String? date,
          @JsonKey(name: 'learn_time') final dynamic learnTime}) =
      _$DailyLearnTimeModelImpl;

  factory _DailyLearnTimeModel.fromJson(Map<String, dynamic> json) =
      _$DailyLearnTimeModelImpl.fromJson;

  @override

  /// 日期
  String? get date;
  @override

  /// 学习时长(小时)
  @JsonKey(name: 'learn_time')
  dynamic get learnTime;
  @override
  @JsonKey(ignore: true)
  _$$DailyLearnTimeModelImplCopyWith<_$DailyLearnTimeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
