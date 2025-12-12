// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'score_report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ScoreReportModel _$ScoreReportModelFromJson(Map<String, dynamic> json) {
  return _ScoreReportModel.fromJson(json);
}

/// @nodoc
mixin _$ScoreReportModel {
  /// 考试名称
  @JsonKey(name: 'examination_name')
  String? get examinationName => throw _privateConstructorUsedError;

  /// 交卷时间
  @JsonKey(name: 'hand_paper_time')
  String? get handPaperTime => throw _privateConstructorUsedError;

  /// 是否及格 (1-及格, 其他-不及格)
  @JsonKey(name: 'is_pass')
  String? get isPass => throw _privateConstructorUsedError;

  /// 试卷版本ID
  @JsonKey(name: 'paper_version_id')
  String? get paperVersionId => throw _privateConstructorUsedError;

  /// 排名
  dynamic get rank => throw _privateConstructorUsedError;

  /// 成绩
  dynamic get score => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScoreReportModelCopyWith<ScoreReportModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScoreReportModelCopyWith<$Res> {
  factory $ScoreReportModelCopyWith(
          ScoreReportModel value, $Res Function(ScoreReportModel) then) =
      _$ScoreReportModelCopyWithImpl<$Res, ScoreReportModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'examination_name') String? examinationName,
      @JsonKey(name: 'hand_paper_time') String? handPaperTime,
      @JsonKey(name: 'is_pass') String? isPass,
      @JsonKey(name: 'paper_version_id') String? paperVersionId,
      dynamic rank,
      dynamic score});
}

/// @nodoc
class _$ScoreReportModelCopyWithImpl<$Res, $Val extends ScoreReportModel>
    implements $ScoreReportModelCopyWith<$Res> {
  _$ScoreReportModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? examinationName = freezed,
    Object? handPaperTime = freezed,
    Object? isPass = freezed,
    Object? paperVersionId = freezed,
    Object? rank = freezed,
    Object? score = freezed,
  }) {
    return _then(_value.copyWith(
      examinationName: freezed == examinationName
          ? _value.examinationName
          : examinationName // ignore: cast_nullable_to_non_nullable
              as String?,
      handPaperTime: freezed == handPaperTime
          ? _value.handPaperTime
          : handPaperTime // ignore: cast_nullable_to_non_nullable
              as String?,
      isPass: freezed == isPass
          ? _value.isPass
          : isPass // ignore: cast_nullable_to_non_nullable
              as String?,
      paperVersionId: freezed == paperVersionId
          ? _value.paperVersionId
          : paperVersionId // ignore: cast_nullable_to_non_nullable
              as String?,
      rank: freezed == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as dynamic,
      score: freezed == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScoreReportModelImplCopyWith<$Res>
    implements $ScoreReportModelCopyWith<$Res> {
  factory _$$ScoreReportModelImplCopyWith(_$ScoreReportModelImpl value,
          $Res Function(_$ScoreReportModelImpl) then) =
      __$$ScoreReportModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'examination_name') String? examinationName,
      @JsonKey(name: 'hand_paper_time') String? handPaperTime,
      @JsonKey(name: 'is_pass') String? isPass,
      @JsonKey(name: 'paper_version_id') String? paperVersionId,
      dynamic rank,
      dynamic score});
}

/// @nodoc
class __$$ScoreReportModelImplCopyWithImpl<$Res>
    extends _$ScoreReportModelCopyWithImpl<$Res, _$ScoreReportModelImpl>
    implements _$$ScoreReportModelImplCopyWith<$Res> {
  __$$ScoreReportModelImplCopyWithImpl(_$ScoreReportModelImpl _value,
      $Res Function(_$ScoreReportModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? examinationName = freezed,
    Object? handPaperTime = freezed,
    Object? isPass = freezed,
    Object? paperVersionId = freezed,
    Object? rank = freezed,
    Object? score = freezed,
  }) {
    return _then(_$ScoreReportModelImpl(
      examinationName: freezed == examinationName
          ? _value.examinationName
          : examinationName // ignore: cast_nullable_to_non_nullable
              as String?,
      handPaperTime: freezed == handPaperTime
          ? _value.handPaperTime
          : handPaperTime // ignore: cast_nullable_to_non_nullable
              as String?,
      isPass: freezed == isPass
          ? _value.isPass
          : isPass // ignore: cast_nullable_to_non_nullable
              as String?,
      paperVersionId: freezed == paperVersionId
          ? _value.paperVersionId
          : paperVersionId // ignore: cast_nullable_to_non_nullable
              as String?,
      rank: freezed == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as dynamic,
      score: freezed == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScoreReportModelImpl implements _ScoreReportModel {
  const _$ScoreReportModelImpl(
      {@JsonKey(name: 'examination_name') this.examinationName,
      @JsonKey(name: 'hand_paper_time') this.handPaperTime,
      @JsonKey(name: 'is_pass') this.isPass,
      @JsonKey(name: 'paper_version_id') this.paperVersionId,
      this.rank,
      this.score});

  factory _$ScoreReportModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScoreReportModelImplFromJson(json);

  /// 考试名称
  @override
  @JsonKey(name: 'examination_name')
  final String? examinationName;

  /// 交卷时间
  @override
  @JsonKey(name: 'hand_paper_time')
  final String? handPaperTime;

  /// 是否及格 (1-及格, 其他-不及格)
  @override
  @JsonKey(name: 'is_pass')
  final String? isPass;

  /// 试卷版本ID
  @override
  @JsonKey(name: 'paper_version_id')
  final String? paperVersionId;

  /// 排名
  @override
  final dynamic rank;

  /// 成绩
  @override
  final dynamic score;

  @override
  String toString() {
    return 'ScoreReportModel(examinationName: $examinationName, handPaperTime: $handPaperTime, isPass: $isPass, paperVersionId: $paperVersionId, rank: $rank, score: $score)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScoreReportModelImpl &&
            (identical(other.examinationName, examinationName) ||
                other.examinationName == examinationName) &&
            (identical(other.handPaperTime, handPaperTime) ||
                other.handPaperTime == handPaperTime) &&
            (identical(other.isPass, isPass) || other.isPass == isPass) &&
            (identical(other.paperVersionId, paperVersionId) ||
                other.paperVersionId == paperVersionId) &&
            const DeepCollectionEquality().equals(other.rank, rank) &&
            const DeepCollectionEquality().equals(other.score, score));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      examinationName,
      handPaperTime,
      isPass,
      paperVersionId,
      const DeepCollectionEquality().hash(rank),
      const DeepCollectionEquality().hash(score));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScoreReportModelImplCopyWith<_$ScoreReportModelImpl> get copyWith =>
      __$$ScoreReportModelImplCopyWithImpl<_$ScoreReportModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScoreReportModelImplToJson(
      this,
    );
  }
}

abstract class _ScoreReportModel implements ScoreReportModel {
  const factory _ScoreReportModel(
      {@JsonKey(name: 'examination_name') final String? examinationName,
      @JsonKey(name: 'hand_paper_time') final String? handPaperTime,
      @JsonKey(name: 'is_pass') final String? isPass,
      @JsonKey(name: 'paper_version_id') final String? paperVersionId,
      final dynamic rank,
      final dynamic score}) = _$ScoreReportModelImpl;

  factory _ScoreReportModel.fromJson(Map<String, dynamic> json) =
      _$ScoreReportModelImpl.fromJson;

  @override

  /// 考试名称
  @JsonKey(name: 'examination_name')
  String? get examinationName;
  @override

  /// 交卷时间
  @JsonKey(name: 'hand_paper_time')
  String? get handPaperTime;
  @override

  /// 是否及格 (1-及格, 其他-不及格)
  @JsonKey(name: 'is_pass')
  String? get isPass;
  @override

  /// 试卷版本ID
  @JsonKey(name: 'paper_version_id')
  String? get paperVersionId;
  @override

  /// 排名
  dynamic get rank;
  @override

  /// 成绩
  dynamic get score;
  @override
  @JsonKey(ignore: true)
  _$$ScoreReportModelImplCopyWith<_$ScoreReportModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
