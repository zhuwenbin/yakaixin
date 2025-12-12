// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LessonModel _$LessonModelFromJson(Map<String, dynamic> json) {
  return _LessonModel.fromJson(json);
}

/// @nodoc
mixin _$LessonModel {
  @JsonKey(name: 'lesson_id')
  String? get lessonId => throw _privateConstructorUsedError;
  @JsonKey(name: 'lesson_num')
  String? get lessonNum => throw _privateConstructorUsedError;
  @JsonKey(name: 'lesson_name')
  String? get lessonName => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  String? get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'teaching_type')
  dynamic get teachingType =>
      throw _privateConstructorUsedError; // ✅ 授课类型: 1-直播, 2-面授, 3-录播
  @JsonKey(name: 'teaching_type_name')
  String? get teachingTypeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'resource_document')
  List<dynamic> get resourceDocument => throw _privateConstructorUsedError;
  @JsonKey(name: 'evaluation_type')
  List<Map<String, dynamic>> get evaluationType =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LessonModelCopyWith<LessonModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LessonModelCopyWith<$Res> {
  factory $LessonModelCopyWith(
          LessonModel value, $Res Function(LessonModel) then) =
      _$LessonModelCopyWithImpl<$Res, LessonModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'lesson_id') String? lessonId,
      @JsonKey(name: 'lesson_num') String? lessonNum,
      @JsonKey(name: 'lesson_name') String? lessonName,
      @JsonKey(name: 'start_time') String? startTime,
      @JsonKey(name: 'teaching_type') dynamic teachingType,
      @JsonKey(name: 'teaching_type_name') String? teachingTypeName,
      @JsonKey(name: 'resource_document') List<dynamic> resourceDocument,
      @JsonKey(name: 'evaluation_type')
      List<Map<String, dynamic>> evaluationType});
}

/// @nodoc
class _$LessonModelCopyWithImpl<$Res, $Val extends LessonModel>
    implements $LessonModelCopyWith<$Res> {
  _$LessonModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lessonId = freezed,
    Object? lessonNum = freezed,
    Object? lessonName = freezed,
    Object? startTime = freezed,
    Object? teachingType = freezed,
    Object? teachingTypeName = freezed,
    Object? resourceDocument = null,
    Object? evaluationType = null,
  }) {
    return _then(_value.copyWith(
      lessonId: freezed == lessonId
          ? _value.lessonId
          : lessonId // ignore: cast_nullable_to_non_nullable
              as String?,
      lessonNum: freezed == lessonNum
          ? _value.lessonNum
          : lessonNum // ignore: cast_nullable_to_non_nullable
              as String?,
      lessonName: freezed == lessonName
          ? _value.lessonName
          : lessonName // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      teachingType: freezed == teachingType
          ? _value.teachingType
          : teachingType // ignore: cast_nullable_to_non_nullable
              as dynamic,
      teachingTypeName: freezed == teachingTypeName
          ? _value.teachingTypeName
          : teachingTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceDocument: null == resourceDocument
          ? _value.resourceDocument
          : resourceDocument // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      evaluationType: null == evaluationType
          ? _value.evaluationType
          : evaluationType // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LessonModelImplCopyWith<$Res>
    implements $LessonModelCopyWith<$Res> {
  factory _$$LessonModelImplCopyWith(
          _$LessonModelImpl value, $Res Function(_$LessonModelImpl) then) =
      __$$LessonModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'lesson_id') String? lessonId,
      @JsonKey(name: 'lesson_num') String? lessonNum,
      @JsonKey(name: 'lesson_name') String? lessonName,
      @JsonKey(name: 'start_time') String? startTime,
      @JsonKey(name: 'teaching_type') dynamic teachingType,
      @JsonKey(name: 'teaching_type_name') String? teachingTypeName,
      @JsonKey(name: 'resource_document') List<dynamic> resourceDocument,
      @JsonKey(name: 'evaluation_type')
      List<Map<String, dynamic>> evaluationType});
}

/// @nodoc
class __$$LessonModelImplCopyWithImpl<$Res>
    extends _$LessonModelCopyWithImpl<$Res, _$LessonModelImpl>
    implements _$$LessonModelImplCopyWith<$Res> {
  __$$LessonModelImplCopyWithImpl(
      _$LessonModelImpl _value, $Res Function(_$LessonModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lessonId = freezed,
    Object? lessonNum = freezed,
    Object? lessonName = freezed,
    Object? startTime = freezed,
    Object? teachingType = freezed,
    Object? teachingTypeName = freezed,
    Object? resourceDocument = null,
    Object? evaluationType = null,
  }) {
    return _then(_$LessonModelImpl(
      lessonId: freezed == lessonId
          ? _value.lessonId
          : lessonId // ignore: cast_nullable_to_non_nullable
              as String?,
      lessonNum: freezed == lessonNum
          ? _value.lessonNum
          : lessonNum // ignore: cast_nullable_to_non_nullable
              as String?,
      lessonName: freezed == lessonName
          ? _value.lessonName
          : lessonName // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      teachingType: freezed == teachingType
          ? _value.teachingType
          : teachingType // ignore: cast_nullable_to_non_nullable
              as dynamic,
      teachingTypeName: freezed == teachingTypeName
          ? _value.teachingTypeName
          : teachingTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
      resourceDocument: null == resourceDocument
          ? _value._resourceDocument
          : resourceDocument // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      evaluationType: null == evaluationType
          ? _value._evaluationType
          : evaluationType // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LessonModelImpl implements _LessonModel {
  const _$LessonModelImpl(
      {@JsonKey(name: 'lesson_id') this.lessonId,
      @JsonKey(name: 'lesson_num') this.lessonNum,
      @JsonKey(name: 'lesson_name') this.lessonName,
      @JsonKey(name: 'start_time') this.startTime,
      @JsonKey(name: 'teaching_type') this.teachingType,
      @JsonKey(name: 'teaching_type_name') this.teachingTypeName,
      @JsonKey(name: 'resource_document')
      final List<dynamic> resourceDocument = const [],
      @JsonKey(name: 'evaluation_type')
      final List<Map<String, dynamic>> evaluationType = const []})
      : _resourceDocument = resourceDocument,
        _evaluationType = evaluationType;

  factory _$LessonModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LessonModelImplFromJson(json);

  @override
  @JsonKey(name: 'lesson_id')
  final String? lessonId;
  @override
  @JsonKey(name: 'lesson_num')
  final String? lessonNum;
  @override
  @JsonKey(name: 'lesson_name')
  final String? lessonName;
  @override
  @JsonKey(name: 'start_time')
  final String? startTime;
  @override
  @JsonKey(name: 'teaching_type')
  final dynamic teachingType;
// ✅ 授课类型: 1-直播, 2-面授, 3-录播
  @override
  @JsonKey(name: 'teaching_type_name')
  final String? teachingTypeName;
  final List<dynamic> _resourceDocument;
  @override
  @JsonKey(name: 'resource_document')
  List<dynamic> get resourceDocument {
    if (_resourceDocument is EqualUnmodifiableListView)
      return _resourceDocument;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_resourceDocument);
  }

  final List<Map<String, dynamic>> _evaluationType;
  @override
  @JsonKey(name: 'evaluation_type')
  List<Map<String, dynamic>> get evaluationType {
    if (_evaluationType is EqualUnmodifiableListView) return _evaluationType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_evaluationType);
  }

  @override
  String toString() {
    return 'LessonModel(lessonId: $lessonId, lessonNum: $lessonNum, lessonName: $lessonName, startTime: $startTime, teachingType: $teachingType, teachingTypeName: $teachingTypeName, resourceDocument: $resourceDocument, evaluationType: $evaluationType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LessonModelImpl &&
            (identical(other.lessonId, lessonId) ||
                other.lessonId == lessonId) &&
            (identical(other.lessonNum, lessonNum) ||
                other.lessonNum == lessonNum) &&
            (identical(other.lessonName, lessonName) ||
                other.lessonName == lessonName) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            const DeepCollectionEquality()
                .equals(other.teachingType, teachingType) &&
            (identical(other.teachingTypeName, teachingTypeName) ||
                other.teachingTypeName == teachingTypeName) &&
            const DeepCollectionEquality()
                .equals(other._resourceDocument, _resourceDocument) &&
            const DeepCollectionEquality()
                .equals(other._evaluationType, _evaluationType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      lessonId,
      lessonNum,
      lessonName,
      startTime,
      const DeepCollectionEquality().hash(teachingType),
      teachingTypeName,
      const DeepCollectionEquality().hash(_resourceDocument),
      const DeepCollectionEquality().hash(_evaluationType));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LessonModelImplCopyWith<_$LessonModelImpl> get copyWith =>
      __$$LessonModelImplCopyWithImpl<_$LessonModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LessonModelImplToJson(
      this,
    );
  }
}

abstract class _LessonModel implements LessonModel {
  const factory _LessonModel(
      {@JsonKey(name: 'lesson_id') final String? lessonId,
      @JsonKey(name: 'lesson_num') final String? lessonNum,
      @JsonKey(name: 'lesson_name') final String? lessonName,
      @JsonKey(name: 'start_time') final String? startTime,
      @JsonKey(name: 'teaching_type') final dynamic teachingType,
      @JsonKey(name: 'teaching_type_name') final String? teachingTypeName,
      @JsonKey(name: 'resource_document') final List<dynamic> resourceDocument,
      @JsonKey(name: 'evaluation_type')
      final List<Map<String, dynamic>> evaluationType}) = _$LessonModelImpl;

  factory _LessonModel.fromJson(Map<String, dynamic> json) =
      _$LessonModelImpl.fromJson;

  @override
  @JsonKey(name: 'lesson_id')
  String? get lessonId;
  @override
  @JsonKey(name: 'lesson_num')
  String? get lessonNum;
  @override
  @JsonKey(name: 'lesson_name')
  String? get lessonName;
  @override
  @JsonKey(name: 'start_time')
  String? get startTime;
  @override
  @JsonKey(name: 'teaching_type')
  dynamic get teachingType;
  @override // ✅ 授课类型: 1-直播, 2-面授, 3-录播
  @JsonKey(name: 'teaching_type_name')
  String? get teachingTypeName;
  @override
  @JsonKey(name: 'resource_document')
  List<dynamic> get resourceDocument;
  @override
  @JsonKey(name: 'evaluation_type')
  List<Map<String, dynamic>> get evaluationType;
  @override
  @JsonKey(ignore: true)
  _$$LessonModelImplCopyWith<_$LessonModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LessonsData _$LessonsDataFromJson(Map<String, dynamic> json) {
  return _LessonsData.fromJson(json);
}

/// @nodoc
mixin _$LessonsData {
  @JsonKey(name: 'lesson_num')
  String? get lessonNum => throw _privateConstructorUsedError;
  @JsonKey(name: 'lesson_attendance_num')
  String? get lessonAttendanceNum => throw _privateConstructorUsedError;
  @JsonKey(name: 'lesson_attendance')
  List<LessonModel> get lessonAttendance => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LessonsDataCopyWith<LessonsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LessonsDataCopyWith<$Res> {
  factory $LessonsDataCopyWith(
          LessonsData value, $Res Function(LessonsData) then) =
      _$LessonsDataCopyWithImpl<$Res, LessonsData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'lesson_num') String? lessonNum,
      @JsonKey(name: 'lesson_attendance_num') String? lessonAttendanceNum,
      @JsonKey(name: 'lesson_attendance') List<LessonModel> lessonAttendance});
}

/// @nodoc
class _$LessonsDataCopyWithImpl<$Res, $Val extends LessonsData>
    implements $LessonsDataCopyWith<$Res> {
  _$LessonsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lessonNum = freezed,
    Object? lessonAttendanceNum = freezed,
    Object? lessonAttendance = null,
  }) {
    return _then(_value.copyWith(
      lessonNum: freezed == lessonNum
          ? _value.lessonNum
          : lessonNum // ignore: cast_nullable_to_non_nullable
              as String?,
      lessonAttendanceNum: freezed == lessonAttendanceNum
          ? _value.lessonAttendanceNum
          : lessonAttendanceNum // ignore: cast_nullable_to_non_nullable
              as String?,
      lessonAttendance: null == lessonAttendance
          ? _value.lessonAttendance
          : lessonAttendance // ignore: cast_nullable_to_non_nullable
              as List<LessonModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LessonsDataImplCopyWith<$Res>
    implements $LessonsDataCopyWith<$Res> {
  factory _$$LessonsDataImplCopyWith(
          _$LessonsDataImpl value, $Res Function(_$LessonsDataImpl) then) =
      __$$LessonsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'lesson_num') String? lessonNum,
      @JsonKey(name: 'lesson_attendance_num') String? lessonAttendanceNum,
      @JsonKey(name: 'lesson_attendance') List<LessonModel> lessonAttendance});
}

/// @nodoc
class __$$LessonsDataImplCopyWithImpl<$Res>
    extends _$LessonsDataCopyWithImpl<$Res, _$LessonsDataImpl>
    implements _$$LessonsDataImplCopyWith<$Res> {
  __$$LessonsDataImplCopyWithImpl(
      _$LessonsDataImpl _value, $Res Function(_$LessonsDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lessonNum = freezed,
    Object? lessonAttendanceNum = freezed,
    Object? lessonAttendance = null,
  }) {
    return _then(_$LessonsDataImpl(
      lessonNum: freezed == lessonNum
          ? _value.lessonNum
          : lessonNum // ignore: cast_nullable_to_non_nullable
              as String?,
      lessonAttendanceNum: freezed == lessonAttendanceNum
          ? _value.lessonAttendanceNum
          : lessonAttendanceNum // ignore: cast_nullable_to_non_nullable
              as String?,
      lessonAttendance: null == lessonAttendance
          ? _value._lessonAttendance
          : lessonAttendance // ignore: cast_nullable_to_non_nullable
              as List<LessonModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LessonsDataImpl implements _LessonsData {
  const _$LessonsDataImpl(
      {@JsonKey(name: 'lesson_num') this.lessonNum,
      @JsonKey(name: 'lesson_attendance_num') this.lessonAttendanceNum,
      @JsonKey(name: 'lesson_attendance')
      final List<LessonModel> lessonAttendance = const []})
      : _lessonAttendance = lessonAttendance;

  factory _$LessonsDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$LessonsDataImplFromJson(json);

  @override
  @JsonKey(name: 'lesson_num')
  final String? lessonNum;
  @override
  @JsonKey(name: 'lesson_attendance_num')
  final String? lessonAttendanceNum;
  final List<LessonModel> _lessonAttendance;
  @override
  @JsonKey(name: 'lesson_attendance')
  List<LessonModel> get lessonAttendance {
    if (_lessonAttendance is EqualUnmodifiableListView)
      return _lessonAttendance;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lessonAttendance);
  }

  @override
  String toString() {
    return 'LessonsData(lessonNum: $lessonNum, lessonAttendanceNum: $lessonAttendanceNum, lessonAttendance: $lessonAttendance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LessonsDataImpl &&
            (identical(other.lessonNum, lessonNum) ||
                other.lessonNum == lessonNum) &&
            (identical(other.lessonAttendanceNum, lessonAttendanceNum) ||
                other.lessonAttendanceNum == lessonAttendanceNum) &&
            const DeepCollectionEquality()
                .equals(other._lessonAttendance, _lessonAttendance));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, lessonNum, lessonAttendanceNum,
      const DeepCollectionEquality().hash(_lessonAttendance));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LessonsDataImplCopyWith<_$LessonsDataImpl> get copyWith =>
      __$$LessonsDataImplCopyWithImpl<_$LessonsDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LessonsDataImplToJson(
      this,
    );
  }
}

abstract class _LessonsData implements LessonsData {
  const factory _LessonsData(
      {@JsonKey(name: 'lesson_num') final String? lessonNum,
      @JsonKey(name: 'lesson_attendance_num') final String? lessonAttendanceNum,
      @JsonKey(name: 'lesson_attendance')
      final List<LessonModel> lessonAttendance}) = _$LessonsDataImpl;

  factory _LessonsData.fromJson(Map<String, dynamic> json) =
      _$LessonsDataImpl.fromJson;

  @override
  @JsonKey(name: 'lesson_num')
  String? get lessonNum;
  @override
  @JsonKey(name: 'lesson_attendance_num')
  String? get lessonAttendanceNum;
  @override
  @JsonKey(name: 'lesson_attendance')
  List<LessonModel> get lessonAttendance;
  @override
  @JsonKey(ignore: true)
  _$$LessonsDataImplCopyWith<_$LessonsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
