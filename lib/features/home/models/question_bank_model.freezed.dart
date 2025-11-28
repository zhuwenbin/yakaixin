// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_bank_model.dart';

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
  @IntConverter()
  @JsonKey(name: 'checkin_num')
  int get checkinNum => throw _privateConstructorUsedError;
  @IntConverter()
  @JsonKey(name: 'total_num')
  int get totalNum => throw _privateConstructorUsedError;
  @StringConverter()
  @JsonKey(name: 'correct_rate')
  String get correctRate => throw _privateConstructorUsedError;
  @IntConverter()
  @JsonKey(name: 'is_checkin')
  int get isCheckin => throw _privateConstructorUsedError;
  @IntConverter()
  @JsonKey(name: 'done_num')
  int get doneNum => throw _privateConstructorUsedError;
  @IntConverter()
  @JsonKey(name: 'study_days')
  int get studyDays => throw _privateConstructorUsedError;

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
      {@IntConverter() @JsonKey(name: 'checkin_num') int checkinNum,
      @IntConverter() @JsonKey(name: 'total_num') int totalNum,
      @StringConverter() @JsonKey(name: 'correct_rate') String correctRate,
      @IntConverter() @JsonKey(name: 'is_checkin') int isCheckin,
      @IntConverter() @JsonKey(name: 'done_num') int doneNum,
      @IntConverter() @JsonKey(name: 'study_days') int studyDays});
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
    Object? checkinNum = null,
    Object? totalNum = null,
    Object? correctRate = null,
    Object? isCheckin = null,
    Object? doneNum = null,
    Object? studyDays = null,
  }) {
    return _then(_value.copyWith(
      checkinNum: null == checkinNum
          ? _value.checkinNum
          : checkinNum // ignore: cast_nullable_to_non_nullable
              as int,
      totalNum: null == totalNum
          ? _value.totalNum
          : totalNum // ignore: cast_nullable_to_non_nullable
              as int,
      correctRate: null == correctRate
          ? _value.correctRate
          : correctRate // ignore: cast_nullable_to_non_nullable
              as String,
      isCheckin: null == isCheckin
          ? _value.isCheckin
          : isCheckin // ignore: cast_nullable_to_non_nullable
              as int,
      doneNum: null == doneNum
          ? _value.doneNum
          : doneNum // ignore: cast_nullable_to_non_nullable
              as int,
      studyDays: null == studyDays
          ? _value.studyDays
          : studyDays // ignore: cast_nullable_to_non_nullable
              as int,
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
      {@IntConverter() @JsonKey(name: 'checkin_num') int checkinNum,
      @IntConverter() @JsonKey(name: 'total_num') int totalNum,
      @StringConverter() @JsonKey(name: 'correct_rate') String correctRate,
      @IntConverter() @JsonKey(name: 'is_checkin') int isCheckin,
      @IntConverter() @JsonKey(name: 'done_num') int doneNum,
      @IntConverter() @JsonKey(name: 'study_days') int studyDays});
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
    Object? checkinNum = null,
    Object? totalNum = null,
    Object? correctRate = null,
    Object? isCheckin = null,
    Object? doneNum = null,
    Object? studyDays = null,
  }) {
    return _then(_$LearningDataModelImpl(
      checkinNum: null == checkinNum
          ? _value.checkinNum
          : checkinNum // ignore: cast_nullable_to_non_nullable
              as int,
      totalNum: null == totalNum
          ? _value.totalNum
          : totalNum // ignore: cast_nullable_to_non_nullable
              as int,
      correctRate: null == correctRate
          ? _value.correctRate
          : correctRate // ignore: cast_nullable_to_non_nullable
              as String,
      isCheckin: null == isCheckin
          ? _value.isCheckin
          : isCheckin // ignore: cast_nullable_to_non_nullable
              as int,
      doneNum: null == doneNum
          ? _value.doneNum
          : doneNum // ignore: cast_nullable_to_non_nullable
              as int,
      studyDays: null == studyDays
          ? _value.studyDays
          : studyDays // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LearningDataModelImpl implements _LearningDataModel {
  const _$LearningDataModelImpl(
      {@IntConverter() @JsonKey(name: 'checkin_num') this.checkinNum = 0,
      @IntConverter() @JsonKey(name: 'total_num') this.totalNum = 0,
      @StringConverter() @JsonKey(name: 'correct_rate') this.correctRate = '0',
      @IntConverter() @JsonKey(name: 'is_checkin') this.isCheckin = 0,
      @IntConverter() @JsonKey(name: 'done_num') this.doneNum = 0,
      @IntConverter() @JsonKey(name: 'study_days') this.studyDays = 0});

  factory _$LearningDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LearningDataModelImplFromJson(json);

  @override
  @IntConverter()
  @JsonKey(name: 'checkin_num')
  final int checkinNum;
  @override
  @IntConverter()
  @JsonKey(name: 'total_num')
  final int totalNum;
  @override
  @StringConverter()
  @JsonKey(name: 'correct_rate')
  final String correctRate;
  @override
  @IntConverter()
  @JsonKey(name: 'is_checkin')
  final int isCheckin;
  @override
  @IntConverter()
  @JsonKey(name: 'done_num')
  final int doneNum;
  @override
  @IntConverter()
  @JsonKey(name: 'study_days')
  final int studyDays;

  @override
  String toString() {
    return 'LearningDataModel(checkinNum: $checkinNum, totalNum: $totalNum, correctRate: $correctRate, isCheckin: $isCheckin, doneNum: $doneNum, studyDays: $studyDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningDataModelImpl &&
            (identical(other.checkinNum, checkinNum) ||
                other.checkinNum == checkinNum) &&
            (identical(other.totalNum, totalNum) ||
                other.totalNum == totalNum) &&
            (identical(other.correctRate, correctRate) ||
                other.correctRate == correctRate) &&
            (identical(other.isCheckin, isCheckin) ||
                other.isCheckin == isCheckin) &&
            (identical(other.doneNum, doneNum) || other.doneNum == doneNum) &&
            (identical(other.studyDays, studyDays) ||
                other.studyDays == studyDays));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, checkinNum, totalNum,
      correctRate, isCheckin, doneNum, studyDays);

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
          {@IntConverter() @JsonKey(name: 'checkin_num') final int checkinNum,
          @IntConverter() @JsonKey(name: 'total_num') final int totalNum,
          @StringConverter()
          @JsonKey(name: 'correct_rate')
          final String correctRate,
          @IntConverter() @JsonKey(name: 'is_checkin') final int isCheckin,
          @IntConverter() @JsonKey(name: 'done_num') final int doneNum,
          @IntConverter() @JsonKey(name: 'study_days') final int studyDays}) =
      _$LearningDataModelImpl;

  factory _LearningDataModel.fromJson(Map<String, dynamic> json) =
      _$LearningDataModelImpl.fromJson;

  @override
  @IntConverter()
  @JsonKey(name: 'checkin_num')
  int get checkinNum;
  @override
  @IntConverter()
  @JsonKey(name: 'total_num')
  int get totalNum;
  @override
  @StringConverter()
  @JsonKey(name: 'correct_rate')
  String get correctRate;
  @override
  @IntConverter()
  @JsonKey(name: 'is_checkin')
  int get isCheckin;
  @override
  @IntConverter()
  @JsonKey(name: 'done_num')
  int get doneNum;
  @override
  @IntConverter()
  @JsonKey(name: 'study_days')
  int get studyDays;
  @override
  @JsonKey(ignore: true)
  _$$LearningDataModelImplCopyWith<_$LearningDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChapterModel _$ChapterModelFromJson(Map<String, dynamic> json) {
  return _ChapterModel.fromJson(json);
}

/// @nodoc
mixin _$ChapterModel {
  @StringConverter()
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @StringConverter()
  @JsonKey(name: 'sectionname')
  String get sectionName => throw _privateConstructorUsedError;
  @IntConverter()
  @JsonKey(name: 'question_number')
  int get questionNumber => throw _privateConstructorUsedError;
  @IntConverter()
  @JsonKey(name: 'do_question_num')
  int get doQuestionNum => throw _privateConstructorUsedError;
  @DoubleConverter()
  @JsonKey(name: 'correct_rate')
  double get correctRate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChapterModelCopyWith<ChapterModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChapterModelCopyWith<$Res> {
  factory $ChapterModelCopyWith(
          ChapterModel value, $Res Function(ChapterModel) then) =
      _$ChapterModelCopyWithImpl<$Res, ChapterModel>;
  @useResult
  $Res call(
      {@StringConverter() @JsonKey(name: 'id') String id,
      @StringConverter() @JsonKey(name: 'sectionname') String sectionName,
      @IntConverter() @JsonKey(name: 'question_number') int questionNumber,
      @IntConverter() @JsonKey(name: 'do_question_num') int doQuestionNum,
      @DoubleConverter() @JsonKey(name: 'correct_rate') double correctRate});
}

/// @nodoc
class _$ChapterModelCopyWithImpl<$Res, $Val extends ChapterModel>
    implements $ChapterModelCopyWith<$Res> {
  _$ChapterModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sectionName = null,
    Object? questionNumber = null,
    Object? doQuestionNum = null,
    Object? correctRate = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sectionName: null == sectionName
          ? _value.sectionName
          : sectionName // ignore: cast_nullable_to_non_nullable
              as String,
      questionNumber: null == questionNumber
          ? _value.questionNumber
          : questionNumber // ignore: cast_nullable_to_non_nullable
              as int,
      doQuestionNum: null == doQuestionNum
          ? _value.doQuestionNum
          : doQuestionNum // ignore: cast_nullable_to_non_nullable
              as int,
      correctRate: null == correctRate
          ? _value.correctRate
          : correctRate // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChapterModelImplCopyWith<$Res>
    implements $ChapterModelCopyWith<$Res> {
  factory _$$ChapterModelImplCopyWith(
          _$ChapterModelImpl value, $Res Function(_$ChapterModelImpl) then) =
      __$$ChapterModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@StringConverter() @JsonKey(name: 'id') String id,
      @StringConverter() @JsonKey(name: 'sectionname') String sectionName,
      @IntConverter() @JsonKey(name: 'question_number') int questionNumber,
      @IntConverter() @JsonKey(name: 'do_question_num') int doQuestionNum,
      @DoubleConverter() @JsonKey(name: 'correct_rate') double correctRate});
}

/// @nodoc
class __$$ChapterModelImplCopyWithImpl<$Res>
    extends _$ChapterModelCopyWithImpl<$Res, _$ChapterModelImpl>
    implements _$$ChapterModelImplCopyWith<$Res> {
  __$$ChapterModelImplCopyWithImpl(
      _$ChapterModelImpl _value, $Res Function(_$ChapterModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sectionName = null,
    Object? questionNumber = null,
    Object? doQuestionNum = null,
    Object? correctRate = null,
  }) {
    return _then(_$ChapterModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sectionName: null == sectionName
          ? _value.sectionName
          : sectionName // ignore: cast_nullable_to_non_nullable
              as String,
      questionNumber: null == questionNumber
          ? _value.questionNumber
          : questionNumber // ignore: cast_nullable_to_non_nullable
              as int,
      doQuestionNum: null == doQuestionNum
          ? _value.doQuestionNum
          : doQuestionNum // ignore: cast_nullable_to_non_nullable
              as int,
      correctRate: null == correctRate
          ? _value.correctRate
          : correctRate // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChapterModelImpl implements _ChapterModel {
  const _$ChapterModelImpl(
      {@StringConverter() @JsonKey(name: 'id') this.id = '',
      @StringConverter() @JsonKey(name: 'sectionname') this.sectionName = '',
      @IntConverter() @JsonKey(name: 'question_number') this.questionNumber = 0,
      @IntConverter() @JsonKey(name: 'do_question_num') this.doQuestionNum = 0,
      @DoubleConverter()
      @JsonKey(name: 'correct_rate')
      this.correctRate = 0.0});

  factory _$ChapterModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChapterModelImplFromJson(json);

  @override
  @StringConverter()
  @JsonKey(name: 'id')
  final String id;
  @override
  @StringConverter()
  @JsonKey(name: 'sectionname')
  final String sectionName;
  @override
  @IntConverter()
  @JsonKey(name: 'question_number')
  final int questionNumber;
  @override
  @IntConverter()
  @JsonKey(name: 'do_question_num')
  final int doQuestionNum;
  @override
  @DoubleConverter()
  @JsonKey(name: 'correct_rate')
  final double correctRate;

  @override
  String toString() {
    return 'ChapterModel(id: $id, sectionName: $sectionName, questionNumber: $questionNumber, doQuestionNum: $doQuestionNum, correctRate: $correctRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChapterModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sectionName, sectionName) ||
                other.sectionName == sectionName) &&
            (identical(other.questionNumber, questionNumber) ||
                other.questionNumber == questionNumber) &&
            (identical(other.doQuestionNum, doQuestionNum) ||
                other.doQuestionNum == doQuestionNum) &&
            (identical(other.correctRate, correctRate) ||
                other.correctRate == correctRate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, sectionName, questionNumber, doQuestionNum, correctRate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChapterModelImplCopyWith<_$ChapterModelImpl> get copyWith =>
      __$$ChapterModelImplCopyWithImpl<_$ChapterModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChapterModelImplToJson(
      this,
    );
  }
}

abstract class _ChapterModel implements ChapterModel {
  const factory _ChapterModel(
      {@StringConverter() @JsonKey(name: 'id') final String id,
      @StringConverter() @JsonKey(name: 'sectionname') final String sectionName,
      @IntConverter()
      @JsonKey(name: 'question_number')
      final int questionNumber,
      @IntConverter() @JsonKey(name: 'do_question_num') final int doQuestionNum,
      @DoubleConverter()
      @JsonKey(name: 'correct_rate')
      final double correctRate}) = _$ChapterModelImpl;

  factory _ChapterModel.fromJson(Map<String, dynamic> json) =
      _$ChapterModelImpl.fromJson;

  @override
  @StringConverter()
  @JsonKey(name: 'id')
  String get id;
  @override
  @StringConverter()
  @JsonKey(name: 'sectionname')
  String get sectionName;
  @override
  @IntConverter()
  @JsonKey(name: 'question_number')
  int get questionNumber;
  @override
  @IntConverter()
  @JsonKey(name: 'do_question_num')
  int get doQuestionNum;
  @override
  @DoubleConverter()
  @JsonKey(name: 'correct_rate')
  double get correctRate;
  @override
  @JsonKey(ignore: true)
  _$$ChapterModelImplCopyWith<_$ChapterModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PurchasedGoodsModel _$PurchasedGoodsModelFromJson(Map<String, dynamic> json) {
  return _PurchasedGoodsModel.fromJson(json);
}

/// @nodoc
mixin _$PurchasedGoodsModel {
  @StringConverter()
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @StringConverter()
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @StringConverter()
  @JsonKey(name: 'material_cover_path')
  String get materialCoverPath => throw _privateConstructorUsedError;
  @IntConverter()
  @JsonKey(name: 'question_count')
  int get questionCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PurchasedGoodsModelCopyWith<PurchasedGoodsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchasedGoodsModelCopyWith<$Res> {
  factory $PurchasedGoodsModelCopyWith(
          PurchasedGoodsModel value, $Res Function(PurchasedGoodsModel) then) =
      _$PurchasedGoodsModelCopyWithImpl<$Res, PurchasedGoodsModel>;
  @useResult
  $Res call(
      {@StringConverter() @JsonKey(name: 'id') String id,
      @StringConverter() @JsonKey(name: 'name') String name,
      @StringConverter()
      @JsonKey(name: 'material_cover_path')
      String materialCoverPath,
      @IntConverter() @JsonKey(name: 'question_count') int questionCount});
}

/// @nodoc
class _$PurchasedGoodsModelCopyWithImpl<$Res, $Val extends PurchasedGoodsModel>
    implements $PurchasedGoodsModelCopyWith<$Res> {
  _$PurchasedGoodsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? materialCoverPath = null,
    Object? questionCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      materialCoverPath: null == materialCoverPath
          ? _value.materialCoverPath
          : materialCoverPath // ignore: cast_nullable_to_non_nullable
              as String,
      questionCount: null == questionCount
          ? _value.questionCount
          : questionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PurchasedGoodsModelImplCopyWith<$Res>
    implements $PurchasedGoodsModelCopyWith<$Res> {
  factory _$$PurchasedGoodsModelImplCopyWith(_$PurchasedGoodsModelImpl value,
          $Res Function(_$PurchasedGoodsModelImpl) then) =
      __$$PurchasedGoodsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@StringConverter() @JsonKey(name: 'id') String id,
      @StringConverter() @JsonKey(name: 'name') String name,
      @StringConverter()
      @JsonKey(name: 'material_cover_path')
      String materialCoverPath,
      @IntConverter() @JsonKey(name: 'question_count') int questionCount});
}

/// @nodoc
class __$$PurchasedGoodsModelImplCopyWithImpl<$Res>
    extends _$PurchasedGoodsModelCopyWithImpl<$Res, _$PurchasedGoodsModelImpl>
    implements _$$PurchasedGoodsModelImplCopyWith<$Res> {
  __$$PurchasedGoodsModelImplCopyWithImpl(_$PurchasedGoodsModelImpl _value,
      $Res Function(_$PurchasedGoodsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? materialCoverPath = null,
    Object? questionCount = null,
  }) {
    return _then(_$PurchasedGoodsModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      materialCoverPath: null == materialCoverPath
          ? _value.materialCoverPath
          : materialCoverPath // ignore: cast_nullable_to_non_nullable
              as String,
      questionCount: null == questionCount
          ? _value.questionCount
          : questionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchasedGoodsModelImpl implements _PurchasedGoodsModel {
  const _$PurchasedGoodsModelImpl(
      {@StringConverter() @JsonKey(name: 'id') this.id = '',
      @StringConverter() @JsonKey(name: 'name') this.name = '',
      @StringConverter()
      @JsonKey(name: 'material_cover_path')
      this.materialCoverPath = '',
      @IntConverter() @JsonKey(name: 'question_count') this.questionCount = 0});

  factory _$PurchasedGoodsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchasedGoodsModelImplFromJson(json);

  @override
  @StringConverter()
  @JsonKey(name: 'id')
  final String id;
  @override
  @StringConverter()
  @JsonKey(name: 'name')
  final String name;
  @override
  @StringConverter()
  @JsonKey(name: 'material_cover_path')
  final String materialCoverPath;
  @override
  @IntConverter()
  @JsonKey(name: 'question_count')
  final int questionCount;

  @override
  String toString() {
    return 'PurchasedGoodsModel(id: $id, name: $name, materialCoverPath: $materialCoverPath, questionCount: $questionCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchasedGoodsModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.materialCoverPath, materialCoverPath) ||
                other.materialCoverPath == materialCoverPath) &&
            (identical(other.questionCount, questionCount) ||
                other.questionCount == questionCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, materialCoverPath, questionCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchasedGoodsModelImplCopyWith<_$PurchasedGoodsModelImpl> get copyWith =>
      __$$PurchasedGoodsModelImplCopyWithImpl<_$PurchasedGoodsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchasedGoodsModelImplToJson(
      this,
    );
  }
}

abstract class _PurchasedGoodsModel implements PurchasedGoodsModel {
  const factory _PurchasedGoodsModel(
      {@StringConverter() @JsonKey(name: 'id') final String id,
      @StringConverter() @JsonKey(name: 'name') final String name,
      @StringConverter()
      @JsonKey(name: 'material_cover_path')
      final String materialCoverPath,
      @IntConverter()
      @JsonKey(name: 'question_count')
      final int questionCount}) = _$PurchasedGoodsModelImpl;

  factory _PurchasedGoodsModel.fromJson(Map<String, dynamic> json) =
      _$PurchasedGoodsModelImpl.fromJson;

  @override
  @StringConverter()
  @JsonKey(name: 'id')
  String get id;
  @override
  @StringConverter()
  @JsonKey(name: 'name')
  String get name;
  @override
  @StringConverter()
  @JsonKey(name: 'material_cover_path')
  String get materialCoverPath;
  @override
  @IntConverter()
  @JsonKey(name: 'question_count')
  int get questionCount;
  @override
  @JsonKey(ignore: true)
  _$$PurchasedGoodsModelImplCopyWith<_$PurchasedGoodsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyPracticeModel _$DailyPracticeModelFromJson(Map<String, dynamic> json) {
  return _DailyPracticeModel.fromJson(json);
}

/// @nodoc
mixin _$DailyPracticeModel {
  @StringConverter()
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @StringConverter()
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @IntConverter()
  @JsonKey(name: 'total_questions')
  int get totalQuestions => throw _privateConstructorUsedError;
  @IntConverter()
  @JsonKey(name: 'done_questions')
  int get doneQuestions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DailyPracticeModelCopyWith<DailyPracticeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyPracticeModelCopyWith<$Res> {
  factory $DailyPracticeModelCopyWith(
          DailyPracticeModel value, $Res Function(DailyPracticeModel) then) =
      _$DailyPracticeModelCopyWithImpl<$Res, DailyPracticeModel>;
  @useResult
  $Res call(
      {@StringConverter() @JsonKey(name: 'id') String id,
      @StringConverter() @JsonKey(name: 'name') String name,
      @IntConverter() @JsonKey(name: 'total_questions') int totalQuestions,
      @IntConverter() @JsonKey(name: 'done_questions') int doneQuestions});
}

/// @nodoc
class _$DailyPracticeModelCopyWithImpl<$Res, $Val extends DailyPracticeModel>
    implements $DailyPracticeModelCopyWith<$Res> {
  _$DailyPracticeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? totalQuestions = null,
    Object? doneQuestions = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      doneQuestions: null == doneQuestions
          ? _value.doneQuestions
          : doneQuestions // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyPracticeModelImplCopyWith<$Res>
    implements $DailyPracticeModelCopyWith<$Res> {
  factory _$$DailyPracticeModelImplCopyWith(_$DailyPracticeModelImpl value,
          $Res Function(_$DailyPracticeModelImpl) then) =
      __$$DailyPracticeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@StringConverter() @JsonKey(name: 'id') String id,
      @StringConverter() @JsonKey(name: 'name') String name,
      @IntConverter() @JsonKey(name: 'total_questions') int totalQuestions,
      @IntConverter() @JsonKey(name: 'done_questions') int doneQuestions});
}

/// @nodoc
class __$$DailyPracticeModelImplCopyWithImpl<$Res>
    extends _$DailyPracticeModelCopyWithImpl<$Res, _$DailyPracticeModelImpl>
    implements _$$DailyPracticeModelImplCopyWith<$Res> {
  __$$DailyPracticeModelImplCopyWithImpl(_$DailyPracticeModelImpl _value,
      $Res Function(_$DailyPracticeModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? totalQuestions = null,
    Object? doneQuestions = null,
  }) {
    return _then(_$DailyPracticeModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      doneQuestions: null == doneQuestions
          ? _value.doneQuestions
          : doneQuestions // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyPracticeModelImpl implements _DailyPracticeModel {
  const _$DailyPracticeModelImpl(
      {@StringConverter() @JsonKey(name: 'id') this.id = '',
      @StringConverter() @JsonKey(name: 'name') this.name = '每日30题',
      @IntConverter()
      @JsonKey(name: 'total_questions')
      this.totalQuestions = 30,
      @IntConverter() @JsonKey(name: 'done_questions') this.doneQuestions = 0});

  factory _$DailyPracticeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyPracticeModelImplFromJson(json);

  @override
  @StringConverter()
  @JsonKey(name: 'id')
  final String id;
  @override
  @StringConverter()
  @JsonKey(name: 'name')
  final String name;
  @override
  @IntConverter()
  @JsonKey(name: 'total_questions')
  final int totalQuestions;
  @override
  @IntConverter()
  @JsonKey(name: 'done_questions')
  final int doneQuestions;

  @override
  String toString() {
    return 'DailyPracticeModel(id: $id, name: $name, totalQuestions: $totalQuestions, doneQuestions: $doneQuestions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyPracticeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.doneQuestions, doneQuestions) ||
                other.doneQuestions == doneQuestions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, totalQuestions, doneQuestions);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyPracticeModelImplCopyWith<_$DailyPracticeModelImpl> get copyWith =>
      __$$DailyPracticeModelImplCopyWithImpl<_$DailyPracticeModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyPracticeModelImplToJson(
      this,
    );
  }
}

abstract class _DailyPracticeModel implements DailyPracticeModel {
  const factory _DailyPracticeModel(
      {@StringConverter() @JsonKey(name: 'id') final String id,
      @StringConverter() @JsonKey(name: 'name') final String name,
      @IntConverter()
      @JsonKey(name: 'total_questions')
      final int totalQuestions,
      @IntConverter()
      @JsonKey(name: 'done_questions')
      final int doneQuestions}) = _$DailyPracticeModelImpl;

  factory _DailyPracticeModel.fromJson(Map<String, dynamic> json) =
      _$DailyPracticeModelImpl.fromJson;

  @override
  @StringConverter()
  @JsonKey(name: 'id')
  String get id;
  @override
  @StringConverter()
  @JsonKey(name: 'name')
  String get name;
  @override
  @IntConverter()
  @JsonKey(name: 'total_questions')
  int get totalQuestions;
  @override
  @IntConverter()
  @JsonKey(name: 'done_questions')
  int get doneQuestions;
  @override
  @JsonKey(ignore: true)
  _$$DailyPracticeModelImplCopyWith<_$DailyPracticeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SkillMockModel _$SkillMockModelFromJson(Map<String, dynamic> json) {
  return _SkillMockModel.fromJson(json);
}

/// @nodoc
mixin _$SkillMockModel {
  @StringConverter()
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @StringConverter()
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @StringConverter()
  @JsonKey(name: 'description')
  String get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SkillMockModelCopyWith<SkillMockModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkillMockModelCopyWith<$Res> {
  factory $SkillMockModelCopyWith(
          SkillMockModel value, $Res Function(SkillMockModel) then) =
      _$SkillMockModelCopyWithImpl<$Res, SkillMockModel>;
  @useResult
  $Res call(
      {@StringConverter() @JsonKey(name: 'id') String id,
      @StringConverter() @JsonKey(name: 'name') String name,
      @StringConverter() @JsonKey(name: 'description') String description});
}

/// @nodoc
class _$SkillMockModelCopyWithImpl<$Res, $Val extends SkillMockModel>
    implements $SkillMockModelCopyWith<$Res> {
  _$SkillMockModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SkillMockModelImplCopyWith<$Res>
    implements $SkillMockModelCopyWith<$Res> {
  factory _$$SkillMockModelImplCopyWith(_$SkillMockModelImpl value,
          $Res Function(_$SkillMockModelImpl) then) =
      __$$SkillMockModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@StringConverter() @JsonKey(name: 'id') String id,
      @StringConverter() @JsonKey(name: 'name') String name,
      @StringConverter() @JsonKey(name: 'description') String description});
}

/// @nodoc
class __$$SkillMockModelImplCopyWithImpl<$Res>
    extends _$SkillMockModelCopyWithImpl<$Res, _$SkillMockModelImpl>
    implements _$$SkillMockModelImplCopyWith<$Res> {
  __$$SkillMockModelImplCopyWithImpl(
      _$SkillMockModelImpl _value, $Res Function(_$SkillMockModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
  }) {
    return _then(_$SkillMockModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SkillMockModelImpl implements _SkillMockModel {
  const _$SkillMockModelImpl(
      {@StringConverter() @JsonKey(name: 'id') this.id = '',
      @StringConverter() @JsonKey(name: 'name') this.name = '技能模拟',
      @StringConverter() @JsonKey(name: 'description') this.description = ''});

  factory _$SkillMockModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SkillMockModelImplFromJson(json);

  @override
  @StringConverter()
  @JsonKey(name: 'id')
  final String id;
  @override
  @StringConverter()
  @JsonKey(name: 'name')
  final String name;
  @override
  @StringConverter()
  @JsonKey(name: 'description')
  final String description;

  @override
  String toString() {
    return 'SkillMockModel(id: $id, name: $name, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkillMockModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SkillMockModelImplCopyWith<_$SkillMockModelImpl> get copyWith =>
      __$$SkillMockModelImplCopyWithImpl<_$SkillMockModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SkillMockModelImplToJson(
      this,
    );
  }
}

abstract class _SkillMockModel implements SkillMockModel {
  const factory _SkillMockModel(
      {@StringConverter() @JsonKey(name: 'id') final String id,
      @StringConverter() @JsonKey(name: 'name') final String name,
      @StringConverter()
      @JsonKey(name: 'description')
      final String description}) = _$SkillMockModelImpl;

  factory _SkillMockModel.fromJson(Map<String, dynamic> json) =
      _$SkillMockModelImpl.fromJson;

  @override
  @StringConverter()
  @JsonKey(name: 'id')
  String get id;
  @override
  @StringConverter()
  @JsonKey(name: 'name')
  String get name;
  @override
  @StringConverter()
  @JsonKey(name: 'description')
  String get description;
  @override
  @JsonKey(ignore: true)
  _$$SkillMockModelImplCopyWith<_$SkillMockModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
