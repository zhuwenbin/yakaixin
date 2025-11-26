// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam_paper_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExamGoodsInfo _$ExamGoodsInfoFromJson(Map<String, dynamic> json) {
  return _ExamGoodsInfo.fromJson(json);
}

/// @nodoc
mixin _$ExamGoodsInfo {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get year => throw _privateConstructorUsedError;
  @JsonKey(name: 'material_intro_path')
  String get materialIntroPath => throw _privateConstructorUsedError;
  @JsonKey(name: 'num_text')
  String get numText => throw _privateConstructorUsedError;
  int get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'professional_id')
  String get professionalId => throw _privateConstructorUsedError;
  @JsonKey(name: 'permission_order_id')
  String get permissionOrderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'permission_status')
  String get permissionStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_type')
  String get dataType => throw _privateConstructorUsedError; // 1-普通试卷 3-章节试卷
  @JsonKey(name: 'tiku_goods_details')
  ExamGoodsDetail get tikuGoodsDetails => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExamGoodsInfoCopyWith<ExamGoodsInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExamGoodsInfoCopyWith<$Res> {
  factory $ExamGoodsInfoCopyWith(
          ExamGoodsInfo value, $Res Function(ExamGoodsInfo) then) =
      _$ExamGoodsInfoCopyWithImpl<$Res, ExamGoodsInfo>;
  @useResult
  $Res call(
      {String id,
      String name,
      String year,
      @JsonKey(name: 'material_intro_path') String materialIntroPath,
      @JsonKey(name: 'num_text') String numText,
      int type,
      @JsonKey(name: 'professional_id') String professionalId,
      @JsonKey(name: 'permission_order_id') String permissionOrderId,
      @JsonKey(name: 'permission_status') String permissionStatus,
      @JsonKey(name: 'data_type') String dataType,
      @JsonKey(name: 'tiku_goods_details') ExamGoodsDetail tikuGoodsDetails});

  $ExamGoodsDetailCopyWith<$Res> get tikuGoodsDetails;
}

/// @nodoc
class _$ExamGoodsInfoCopyWithImpl<$Res, $Val extends ExamGoodsInfo>
    implements $ExamGoodsInfoCopyWith<$Res> {
  _$ExamGoodsInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? year = null,
    Object? materialIntroPath = null,
    Object? numText = null,
    Object? type = null,
    Object? professionalId = null,
    Object? permissionOrderId = null,
    Object? permissionStatus = null,
    Object? dataType = null,
    Object? tikuGoodsDetails = null,
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
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as String,
      materialIntroPath: null == materialIntroPath
          ? _value.materialIntroPath
          : materialIntroPath // ignore: cast_nullable_to_non_nullable
              as String,
      numText: null == numText
          ? _value.numText
          : numText // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      professionalId: null == professionalId
          ? _value.professionalId
          : professionalId // ignore: cast_nullable_to_non_nullable
              as String,
      permissionOrderId: null == permissionOrderId
          ? _value.permissionOrderId
          : permissionOrderId // ignore: cast_nullable_to_non_nullable
              as String,
      permissionStatus: null == permissionStatus
          ? _value.permissionStatus
          : permissionStatus // ignore: cast_nullable_to_non_nullable
              as String,
      dataType: null == dataType
          ? _value.dataType
          : dataType // ignore: cast_nullable_to_non_nullable
              as String,
      tikuGoodsDetails: null == tikuGoodsDetails
          ? _value.tikuGoodsDetails
          : tikuGoodsDetails // ignore: cast_nullable_to_non_nullable
              as ExamGoodsDetail,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ExamGoodsDetailCopyWith<$Res> get tikuGoodsDetails {
    return $ExamGoodsDetailCopyWith<$Res>(_value.tikuGoodsDetails, (value) {
      return _then(_value.copyWith(tikuGoodsDetails: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ExamGoodsInfoImplCopyWith<$Res>
    implements $ExamGoodsInfoCopyWith<$Res> {
  factory _$$ExamGoodsInfoImplCopyWith(
          _$ExamGoodsInfoImpl value, $Res Function(_$ExamGoodsInfoImpl) then) =
      __$$ExamGoodsInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String year,
      @JsonKey(name: 'material_intro_path') String materialIntroPath,
      @JsonKey(name: 'num_text') String numText,
      int type,
      @JsonKey(name: 'professional_id') String professionalId,
      @JsonKey(name: 'permission_order_id') String permissionOrderId,
      @JsonKey(name: 'permission_status') String permissionStatus,
      @JsonKey(name: 'data_type') String dataType,
      @JsonKey(name: 'tiku_goods_details') ExamGoodsDetail tikuGoodsDetails});

  @override
  $ExamGoodsDetailCopyWith<$Res> get tikuGoodsDetails;
}

/// @nodoc
class __$$ExamGoodsInfoImplCopyWithImpl<$Res>
    extends _$ExamGoodsInfoCopyWithImpl<$Res, _$ExamGoodsInfoImpl>
    implements _$$ExamGoodsInfoImplCopyWith<$Res> {
  __$$ExamGoodsInfoImplCopyWithImpl(
      _$ExamGoodsInfoImpl _value, $Res Function(_$ExamGoodsInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? year = null,
    Object? materialIntroPath = null,
    Object? numText = null,
    Object? type = null,
    Object? professionalId = null,
    Object? permissionOrderId = null,
    Object? permissionStatus = null,
    Object? dataType = null,
    Object? tikuGoodsDetails = null,
  }) {
    return _then(_$ExamGoodsInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as String,
      materialIntroPath: null == materialIntroPath
          ? _value.materialIntroPath
          : materialIntroPath // ignore: cast_nullable_to_non_nullable
              as String,
      numText: null == numText
          ? _value.numText
          : numText // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      professionalId: null == professionalId
          ? _value.professionalId
          : professionalId // ignore: cast_nullable_to_non_nullable
              as String,
      permissionOrderId: null == permissionOrderId
          ? _value.permissionOrderId
          : permissionOrderId // ignore: cast_nullable_to_non_nullable
              as String,
      permissionStatus: null == permissionStatus
          ? _value.permissionStatus
          : permissionStatus // ignore: cast_nullable_to_non_nullable
              as String,
      dataType: null == dataType
          ? _value.dataType
          : dataType // ignore: cast_nullable_to_non_nullable
              as String,
      tikuGoodsDetails: null == tikuGoodsDetails
          ? _value.tikuGoodsDetails
          : tikuGoodsDetails // ignore: cast_nullable_to_non_nullable
              as ExamGoodsDetail,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExamGoodsInfoImpl implements _ExamGoodsInfo {
  const _$ExamGoodsInfoImpl(
      {required this.id,
      required this.name,
      this.year = '',
      @JsonKey(name: 'material_intro_path') this.materialIntroPath = '',
      @JsonKey(name: 'num_text') this.numText = '',
      this.type = 8,
      @JsonKey(name: 'professional_id') this.professionalId = '',
      @JsonKey(name: 'permission_order_id') this.permissionOrderId = '',
      @JsonKey(name: 'permission_status') this.permissionStatus = '0',
      @JsonKey(name: 'data_type') this.dataType = '1',
      @JsonKey(name: 'tiku_goods_details') required this.tikuGoodsDetails});

  factory _$ExamGoodsInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExamGoodsInfoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final String year;
  @override
  @JsonKey(name: 'material_intro_path')
  final String materialIntroPath;
  @override
  @JsonKey(name: 'num_text')
  final String numText;
  @override
  @JsonKey()
  final int type;
  @override
  @JsonKey(name: 'professional_id')
  final String professionalId;
  @override
  @JsonKey(name: 'permission_order_id')
  final String permissionOrderId;
  @override
  @JsonKey(name: 'permission_status')
  final String permissionStatus;
  @override
  @JsonKey(name: 'data_type')
  final String dataType;
// 1-普通试卷 3-章节试卷
  @override
  @JsonKey(name: 'tiku_goods_details')
  final ExamGoodsDetail tikuGoodsDetails;

  @override
  String toString() {
    return 'ExamGoodsInfo(id: $id, name: $name, year: $year, materialIntroPath: $materialIntroPath, numText: $numText, type: $type, professionalId: $professionalId, permissionOrderId: $permissionOrderId, permissionStatus: $permissionStatus, dataType: $dataType, tikuGoodsDetails: $tikuGoodsDetails)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExamGoodsInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.materialIntroPath, materialIntroPath) ||
                other.materialIntroPath == materialIntroPath) &&
            (identical(other.numText, numText) || other.numText == numText) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.professionalId, professionalId) ||
                other.professionalId == professionalId) &&
            (identical(other.permissionOrderId, permissionOrderId) ||
                other.permissionOrderId == permissionOrderId) &&
            (identical(other.permissionStatus, permissionStatus) ||
                other.permissionStatus == permissionStatus) &&
            (identical(other.dataType, dataType) ||
                other.dataType == dataType) &&
            (identical(other.tikuGoodsDetails, tikuGoodsDetails) ||
                other.tikuGoodsDetails == tikuGoodsDetails));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      year,
      materialIntroPath,
      numText,
      type,
      professionalId,
      permissionOrderId,
      permissionStatus,
      dataType,
      tikuGoodsDetails);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExamGoodsInfoImplCopyWith<_$ExamGoodsInfoImpl> get copyWith =>
      __$$ExamGoodsInfoImplCopyWithImpl<_$ExamGoodsInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExamGoodsInfoImplToJson(
      this,
    );
  }
}

abstract class _ExamGoodsInfo implements ExamGoodsInfo {
  const factory _ExamGoodsInfo(
      {required final String id,
      required final String name,
      final String year,
      @JsonKey(name: 'material_intro_path') final String materialIntroPath,
      @JsonKey(name: 'num_text') final String numText,
      final int type,
      @JsonKey(name: 'professional_id') final String professionalId,
      @JsonKey(name: 'permission_order_id') final String permissionOrderId,
      @JsonKey(name: 'permission_status') final String permissionStatus,
      @JsonKey(name: 'data_type') final String dataType,
      @JsonKey(name: 'tiku_goods_details')
      required final ExamGoodsDetail tikuGoodsDetails}) = _$ExamGoodsInfoImpl;

  factory _ExamGoodsInfo.fromJson(Map<String, dynamic> json) =
      _$ExamGoodsInfoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get year;
  @override
  @JsonKey(name: 'material_intro_path')
  String get materialIntroPath;
  @override
  @JsonKey(name: 'num_text')
  String get numText;
  @override
  int get type;
  @override
  @JsonKey(name: 'professional_id')
  String get professionalId;
  @override
  @JsonKey(name: 'permission_order_id')
  String get permissionOrderId;
  @override
  @JsonKey(name: 'permission_status')
  String get permissionStatus;
  @override
  @JsonKey(name: 'data_type')
  String get dataType;
  @override // 1-普通试卷 3-章节试卷
  @JsonKey(name: 'tiku_goods_details')
  ExamGoodsDetail get tikuGoodsDetails;
  @override
  @JsonKey(ignore: true)
  _$$ExamGoodsInfoImplCopyWith<_$ExamGoodsInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExamGoodsDetail _$ExamGoodsDetailFromJson(Map<String, dynamic> json) {
  return _ExamGoodsDetail.fromJson(json);
}

/// @nodoc
mixin _$ExamGoodsDetail {
  @JsonKey(name: 'question_num')
  int get questionNum => throw _privateConstructorUsedError;
  @JsonKey(name: 'paper_num')
  int get paperNum => throw _privateConstructorUsedError;
  @JsonKey(name: 'exam_round_num')
  int get examRoundNum => throw _privateConstructorUsedError;
  @JsonKey(name: 'exam_time')
  String get examTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExamGoodsDetailCopyWith<ExamGoodsDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExamGoodsDetailCopyWith<$Res> {
  factory $ExamGoodsDetailCopyWith(
          ExamGoodsDetail value, $Res Function(ExamGoodsDetail) then) =
      _$ExamGoodsDetailCopyWithImpl<$Res, ExamGoodsDetail>;
  @useResult
  $Res call(
      {@JsonKey(name: 'question_num') int questionNum,
      @JsonKey(name: 'paper_num') int paperNum,
      @JsonKey(name: 'exam_round_num') int examRoundNum,
      @JsonKey(name: 'exam_time') String examTime});
}

/// @nodoc
class _$ExamGoodsDetailCopyWithImpl<$Res, $Val extends ExamGoodsDetail>
    implements $ExamGoodsDetailCopyWith<$Res> {
  _$ExamGoodsDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionNum = null,
    Object? paperNum = null,
    Object? examRoundNum = null,
    Object? examTime = null,
  }) {
    return _then(_value.copyWith(
      questionNum: null == questionNum
          ? _value.questionNum
          : questionNum // ignore: cast_nullable_to_non_nullable
              as int,
      paperNum: null == paperNum
          ? _value.paperNum
          : paperNum // ignore: cast_nullable_to_non_nullable
              as int,
      examRoundNum: null == examRoundNum
          ? _value.examRoundNum
          : examRoundNum // ignore: cast_nullable_to_non_nullable
              as int,
      examTime: null == examTime
          ? _value.examTime
          : examTime // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExamGoodsDetailImplCopyWith<$Res>
    implements $ExamGoodsDetailCopyWith<$Res> {
  factory _$$ExamGoodsDetailImplCopyWith(_$ExamGoodsDetailImpl value,
          $Res Function(_$ExamGoodsDetailImpl) then) =
      __$$ExamGoodsDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'question_num') int questionNum,
      @JsonKey(name: 'paper_num') int paperNum,
      @JsonKey(name: 'exam_round_num') int examRoundNum,
      @JsonKey(name: 'exam_time') String examTime});
}

/// @nodoc
class __$$ExamGoodsDetailImplCopyWithImpl<$Res>
    extends _$ExamGoodsDetailCopyWithImpl<$Res, _$ExamGoodsDetailImpl>
    implements _$$ExamGoodsDetailImplCopyWith<$Res> {
  __$$ExamGoodsDetailImplCopyWithImpl(
      _$ExamGoodsDetailImpl _value, $Res Function(_$ExamGoodsDetailImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionNum = null,
    Object? paperNum = null,
    Object? examRoundNum = null,
    Object? examTime = null,
  }) {
    return _then(_$ExamGoodsDetailImpl(
      questionNum: null == questionNum
          ? _value.questionNum
          : questionNum // ignore: cast_nullable_to_non_nullable
              as int,
      paperNum: null == paperNum
          ? _value.paperNum
          : paperNum // ignore: cast_nullable_to_non_nullable
              as int,
      examRoundNum: null == examRoundNum
          ? _value.examRoundNum
          : examRoundNum // ignore: cast_nullable_to_non_nullable
              as int,
      examTime: null == examTime
          ? _value.examTime
          : examTime // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExamGoodsDetailImpl implements _ExamGoodsDetail {
  const _$ExamGoodsDetailImpl(
      {@JsonKey(name: 'question_num') this.questionNum = 0,
      @JsonKey(name: 'paper_num') this.paperNum = 0,
      @JsonKey(name: 'exam_round_num') this.examRoundNum = 0,
      @JsonKey(name: 'exam_time') this.examTime = ''});

  factory _$ExamGoodsDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExamGoodsDetailImplFromJson(json);

  @override
  @JsonKey(name: 'question_num')
  final int questionNum;
  @override
  @JsonKey(name: 'paper_num')
  final int paperNum;
  @override
  @JsonKey(name: 'exam_round_num')
  final int examRoundNum;
  @override
  @JsonKey(name: 'exam_time')
  final String examTime;

  @override
  String toString() {
    return 'ExamGoodsDetail(questionNum: $questionNum, paperNum: $paperNum, examRoundNum: $examRoundNum, examTime: $examTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExamGoodsDetailImpl &&
            (identical(other.questionNum, questionNum) ||
                other.questionNum == questionNum) &&
            (identical(other.paperNum, paperNum) ||
                other.paperNum == paperNum) &&
            (identical(other.examRoundNum, examRoundNum) ||
                other.examRoundNum == examRoundNum) &&
            (identical(other.examTime, examTime) ||
                other.examTime == examTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, questionNum, paperNum, examRoundNum, examTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExamGoodsDetailImplCopyWith<_$ExamGoodsDetailImpl> get copyWith =>
      __$$ExamGoodsDetailImplCopyWithImpl<_$ExamGoodsDetailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExamGoodsDetailImplToJson(
      this,
    );
  }
}

abstract class _ExamGoodsDetail implements ExamGoodsDetail {
  const factory _ExamGoodsDetail(
          {@JsonKey(name: 'question_num') final int questionNum,
          @JsonKey(name: 'paper_num') final int paperNum,
          @JsonKey(name: 'exam_round_num') final int examRoundNum,
          @JsonKey(name: 'exam_time') final String examTime}) =
      _$ExamGoodsDetailImpl;

  factory _ExamGoodsDetail.fromJson(Map<String, dynamic> json) =
      _$ExamGoodsDetailImpl.fromJson;

  @override
  @JsonKey(name: 'question_num')
  int get questionNum;
  @override
  @JsonKey(name: 'paper_num')
  int get paperNum;
  @override
  @JsonKey(name: 'exam_round_num')
  int get examRoundNum;
  @override
  @JsonKey(name: 'exam_time')
  String get examTime;
  @override
  @JsonKey(ignore: true)
  _$$ExamGoodsDetailImplCopyWith<_$ExamGoodsDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExamPaper _$ExamPaperFromJson(Map<String, dynamic> json) {
  return _ExamPaper.fromJson(json);
}

/// @nodoc
mixin _$ExamPaper {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'paper_exercise_id')
  String get paperExerciseId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExamPaperCopyWith<ExamPaper> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExamPaperCopyWith<$Res> {
  factory $ExamPaperCopyWith(ExamPaper value, $Res Function(ExamPaper) then) =
      _$ExamPaperCopyWithImpl<$Res, ExamPaper>;
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'paper_exercise_id') String paperExerciseId});
}

/// @nodoc
class _$ExamPaperCopyWithImpl<$Res, $Val extends ExamPaper>
    implements $ExamPaperCopyWith<$Res> {
  _$ExamPaperCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? paperExerciseId = null,
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
      paperExerciseId: null == paperExerciseId
          ? _value.paperExerciseId
          : paperExerciseId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExamPaperImplCopyWith<$Res>
    implements $ExamPaperCopyWith<$Res> {
  factory _$$ExamPaperImplCopyWith(
          _$ExamPaperImpl value, $Res Function(_$ExamPaperImpl) then) =
      __$$ExamPaperImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'paper_exercise_id') String paperExerciseId});
}

/// @nodoc
class __$$ExamPaperImplCopyWithImpl<$Res>
    extends _$ExamPaperCopyWithImpl<$Res, _$ExamPaperImpl>
    implements _$$ExamPaperImplCopyWith<$Res> {
  __$$ExamPaperImplCopyWithImpl(
      _$ExamPaperImpl _value, $Res Function(_$ExamPaperImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? paperExerciseId = null,
  }) {
    return _then(_$ExamPaperImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      paperExerciseId: null == paperExerciseId
          ? _value.paperExerciseId
          : paperExerciseId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExamPaperImpl implements _ExamPaper {
  const _$ExamPaperImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'paper_exercise_id') this.paperExerciseId = '0'});

  factory _$ExamPaperImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExamPaperImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(name: 'paper_exercise_id')
  final String paperExerciseId;

  @override
  String toString() {
    return 'ExamPaper(id: $id, name: $name, paperExerciseId: $paperExerciseId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExamPaperImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.paperExerciseId, paperExerciseId) ||
                other.paperExerciseId == paperExerciseId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, paperExerciseId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExamPaperImplCopyWith<_$ExamPaperImpl> get copyWith =>
      __$$ExamPaperImplCopyWithImpl<_$ExamPaperImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExamPaperImplToJson(
      this,
    );
  }
}

abstract class _ExamPaper implements ExamPaper {
  const factory _ExamPaper(
          {required final String id,
          required final String name,
          @JsonKey(name: 'paper_exercise_id') final String paperExerciseId}) =
      _$ExamPaperImpl;

  factory _ExamPaper.fromJson(Map<String, dynamic> json) =
      _$ExamPaperImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'paper_exercise_id')
  String get paperExerciseId;
  @override
  @JsonKey(ignore: true)
  _$$ExamPaperImplCopyWith<_$ExamPaperImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChapterPaperGroup _$ChapterPaperGroupFromJson(Map<String, dynamic> json) {
  return _ChapterPaperGroup.fromJson(json);
}

/// @nodoc
mixin _$ChapterPaperGroup {
  String get name => throw _privateConstructorUsedError;
  List<ExamPaper> get list => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChapterPaperGroupCopyWith<ChapterPaperGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChapterPaperGroupCopyWith<$Res> {
  factory $ChapterPaperGroupCopyWith(
          ChapterPaperGroup value, $Res Function(ChapterPaperGroup) then) =
      _$ChapterPaperGroupCopyWithImpl<$Res, ChapterPaperGroup>;
  @useResult
  $Res call({String name, List<ExamPaper> list});
}

/// @nodoc
class _$ChapterPaperGroupCopyWithImpl<$Res, $Val extends ChapterPaperGroup>
    implements $ChapterPaperGroupCopyWith<$Res> {
  _$ChapterPaperGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? list = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      list: null == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<ExamPaper>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChapterPaperGroupImplCopyWith<$Res>
    implements $ChapterPaperGroupCopyWith<$Res> {
  factory _$$ChapterPaperGroupImplCopyWith(_$ChapterPaperGroupImpl value,
          $Res Function(_$ChapterPaperGroupImpl) then) =
      __$$ChapterPaperGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, List<ExamPaper> list});
}

/// @nodoc
class __$$ChapterPaperGroupImplCopyWithImpl<$Res>
    extends _$ChapterPaperGroupCopyWithImpl<$Res, _$ChapterPaperGroupImpl>
    implements _$$ChapterPaperGroupImplCopyWith<$Res> {
  __$$ChapterPaperGroupImplCopyWithImpl(_$ChapterPaperGroupImpl _value,
      $Res Function(_$ChapterPaperGroupImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? list = null,
  }) {
    return _then(_$ChapterPaperGroupImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<ExamPaper>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChapterPaperGroupImpl implements _ChapterPaperGroup {
  const _$ChapterPaperGroupImpl(
      {required this.name, final List<ExamPaper> list = const []})
      : _list = list;

  factory _$ChapterPaperGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChapterPaperGroupImplFromJson(json);

  @override
  final String name;
  final List<ExamPaper> _list;
  @override
  @JsonKey()
  List<ExamPaper> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  String toString() {
    return 'ChapterPaperGroup(name: $name, list: $list)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChapterPaperGroupImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._list, _list));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, const DeepCollectionEquality().hash(_list));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChapterPaperGroupImplCopyWith<_$ChapterPaperGroupImpl> get copyWith =>
      __$$ChapterPaperGroupImplCopyWithImpl<_$ChapterPaperGroupImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChapterPaperGroupImplToJson(
      this,
    );
  }
}

abstract class _ChapterPaperGroup implements ChapterPaperGroup {
  const factory _ChapterPaperGroup(
      {required final String name,
      final List<ExamPaper> list}) = _$ChapterPaperGroupImpl;

  factory _ChapterPaperGroup.fromJson(Map<String, dynamic> json) =
      _$ChapterPaperGroupImpl.fromJson;

  @override
  String get name;
  @override
  List<ExamPaper> get list;
  @override
  @JsonKey(ignore: true)
  _$$ChapterPaperGroupImplCopyWith<_$ChapterPaperGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
