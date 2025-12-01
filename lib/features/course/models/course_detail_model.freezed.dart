// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CourseDetailModel _$CourseDetailModelFromJson(Map<String, dynamic> json) {
  return _CourseDetailModel.fromJson(json);
}

/// @nodoc
mixin _$CourseDetailModel {
  @JsonKey(name: 'goods_id')
  String? get goodsId => throw _privateConstructorUsedError;
  @JsonKey(name: 'goods_name')
  String? get goodsName => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_type')
  dynamic get businessType =>
      throw _privateConstructorUsedError; // 1:普通 2:高端 3:私塾
  @JsonKey(name: 'class')
  Map<String, dynamic>? get classInfo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CourseDetailModelCopyWith<CourseDetailModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseDetailModelCopyWith<$Res> {
  factory $CourseDetailModelCopyWith(
          CourseDetailModel value, $Res Function(CourseDetailModel) then) =
      _$CourseDetailModelCopyWithImpl<$Res, CourseDetailModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'goods_id') String? goodsId,
      @JsonKey(name: 'goods_name') String? goodsName,
      @JsonKey(name: 'business_type') dynamic businessType,
      @JsonKey(name: 'class') Map<String, dynamic>? classInfo});
}

/// @nodoc
class _$CourseDetailModelCopyWithImpl<$Res, $Val extends CourseDetailModel>
    implements $CourseDetailModelCopyWith<$Res> {
  _$CourseDetailModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goodsId = freezed,
    Object? goodsName = freezed,
    Object? businessType = freezed,
    Object? classInfo = freezed,
  }) {
    return _then(_value.copyWith(
      goodsId: freezed == goodsId
          ? _value.goodsId
          : goodsId // ignore: cast_nullable_to_non_nullable
              as String?,
      goodsName: freezed == goodsName
          ? _value.goodsName
          : goodsName // ignore: cast_nullable_to_non_nullable
              as String?,
      businessType: freezed == businessType
          ? _value.businessType
          : businessType // ignore: cast_nullable_to_non_nullable
              as dynamic,
      classInfo: freezed == classInfo
          ? _value.classInfo
          : classInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CourseDetailModelImplCopyWith<$Res>
    implements $CourseDetailModelCopyWith<$Res> {
  factory _$$CourseDetailModelImplCopyWith(_$CourseDetailModelImpl value,
          $Res Function(_$CourseDetailModelImpl) then) =
      __$$CourseDetailModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'goods_id') String? goodsId,
      @JsonKey(name: 'goods_name') String? goodsName,
      @JsonKey(name: 'business_type') dynamic businessType,
      @JsonKey(name: 'class') Map<String, dynamic>? classInfo});
}

/// @nodoc
class __$$CourseDetailModelImplCopyWithImpl<$Res>
    extends _$CourseDetailModelCopyWithImpl<$Res, _$CourseDetailModelImpl>
    implements _$$CourseDetailModelImplCopyWith<$Res> {
  __$$CourseDetailModelImplCopyWithImpl(_$CourseDetailModelImpl _value,
      $Res Function(_$CourseDetailModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goodsId = freezed,
    Object? goodsName = freezed,
    Object? businessType = freezed,
    Object? classInfo = freezed,
  }) {
    return _then(_$CourseDetailModelImpl(
      goodsId: freezed == goodsId
          ? _value.goodsId
          : goodsId // ignore: cast_nullable_to_non_nullable
              as String?,
      goodsName: freezed == goodsName
          ? _value.goodsName
          : goodsName // ignore: cast_nullable_to_non_nullable
              as String?,
      businessType: freezed == businessType
          ? _value.businessType
          : businessType // ignore: cast_nullable_to_non_nullable
              as dynamic,
      classInfo: freezed == classInfo
          ? _value._classInfo
          : classInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseDetailModelImpl implements _CourseDetailModel {
  const _$CourseDetailModelImpl(
      {@JsonKey(name: 'goods_id') this.goodsId,
      @JsonKey(name: 'goods_name') this.goodsName,
      @JsonKey(name: 'business_type') this.businessType,
      @JsonKey(name: 'class') final Map<String, dynamic>? classInfo})
      : _classInfo = classInfo;

  factory _$CourseDetailModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseDetailModelImplFromJson(json);

  @override
  @JsonKey(name: 'goods_id')
  final String? goodsId;
  @override
  @JsonKey(name: 'goods_name')
  final String? goodsName;
  @override
  @JsonKey(name: 'business_type')
  final dynamic businessType;
// 1:普通 2:高端 3:私塾
  final Map<String, dynamic>? _classInfo;
// 1:普通 2:高端 3:私塾
  @override
  @JsonKey(name: 'class')
  Map<String, dynamic>? get classInfo {
    final value = _classInfo;
    if (value == null) return null;
    if (_classInfo is EqualUnmodifiableMapView) return _classInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'CourseDetailModel(goodsId: $goodsId, goodsName: $goodsName, businessType: $businessType, classInfo: $classInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseDetailModelImpl &&
            (identical(other.goodsId, goodsId) || other.goodsId == goodsId) &&
            (identical(other.goodsName, goodsName) ||
                other.goodsName == goodsName) &&
            const DeepCollectionEquality()
                .equals(other.businessType, businessType) &&
            const DeepCollectionEquality()
                .equals(other._classInfo, _classInfo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      goodsId,
      goodsName,
      const DeepCollectionEquality().hash(businessType),
      const DeepCollectionEquality().hash(_classInfo));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseDetailModelImplCopyWith<_$CourseDetailModelImpl> get copyWith =>
      __$$CourseDetailModelImplCopyWithImpl<_$CourseDetailModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseDetailModelImplToJson(
      this,
    );
  }
}

abstract class _CourseDetailModel implements CourseDetailModel {
  const factory _CourseDetailModel(
          {@JsonKey(name: 'goods_id') final String? goodsId,
          @JsonKey(name: 'goods_name') final String? goodsName,
          @JsonKey(name: 'business_type') final dynamic businessType,
          @JsonKey(name: 'class') final Map<String, dynamic>? classInfo}) =
      _$CourseDetailModelImpl;

  factory _CourseDetailModel.fromJson(Map<String, dynamic> json) =
      _$CourseDetailModelImpl.fromJson;

  @override
  @JsonKey(name: 'goods_id')
  String? get goodsId;
  @override
  @JsonKey(name: 'goods_name')
  String? get goodsName;
  @override
  @JsonKey(name: 'business_type')
  dynamic get businessType;
  @override // 1:普通 2:高端 3:私塾
  @JsonKey(name: 'class')
  Map<String, dynamic>? get classInfo;
  @override
  @JsonKey(ignore: true)
  _$$CourseDetailModelImplCopyWith<_$CourseDetailModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CourseClassModel _$CourseClassModelFromJson(Map<String, dynamic> json) {
  return _CourseClassModel.fromJson(json);
}

/// @nodoc
mixin _$CourseClassModel {
  @JsonKey(name: 'class_id')
  String? get classId => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'teaching_type')
  String? get teachingType => throw _privateConstructorUsedError;
  @JsonKey(name: 'teaching_type_name')
  String? get teachingTypeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'lesson_num')
  dynamic get lessonNum => throw _privateConstructorUsedError;
  @JsonKey(name: 'lesson_attendance_num')
  dynamic get lessonAttendanceNum => throw _privateConstructorUsedError;
  @JsonKey(name: 'address')
  String? get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'lesson')
  List<Map<String, dynamic>>? get lessons =>
      throw _privateConstructorUsedError; // ✅ UI状态字段（不从JSON解析）
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isClose => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CourseClassModelCopyWith<CourseClassModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseClassModelCopyWith<$Res> {
  factory $CourseClassModelCopyWith(
          CourseClassModel value, $Res Function(CourseClassModel) then) =
      _$CourseClassModelCopyWithImpl<$Res, CourseClassModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'class_id') String? classId,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'teaching_type') String? teachingType,
      @JsonKey(name: 'teaching_type_name') String? teachingTypeName,
      @JsonKey(name: 'lesson_num') dynamic lessonNum,
      @JsonKey(name: 'lesson_attendance_num') dynamic lessonAttendanceNum,
      @JsonKey(name: 'address') String? address,
      @JsonKey(name: 'lesson') List<Map<String, dynamic>>? lessons,
      @JsonKey(includeFromJson: false, includeToJson: false) bool isClose});
}

/// @nodoc
class _$CourseClassModelCopyWithImpl<$Res, $Val extends CourseClassModel>
    implements $CourseClassModelCopyWith<$Res> {
  _$CourseClassModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? classId = freezed,
    Object? name = freezed,
    Object? teachingType = freezed,
    Object? teachingTypeName = freezed,
    Object? lessonNum = freezed,
    Object? lessonAttendanceNum = freezed,
    Object? address = freezed,
    Object? lessons = freezed,
    Object? isClose = null,
  }) {
    return _then(_value.copyWith(
      classId: freezed == classId
          ? _value.classId
          : classId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      teachingType: freezed == teachingType
          ? _value.teachingType
          : teachingType // ignore: cast_nullable_to_non_nullable
              as String?,
      teachingTypeName: freezed == teachingTypeName
          ? _value.teachingTypeName
          : teachingTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
      lessonNum: freezed == lessonNum
          ? _value.lessonNum
          : lessonNum // ignore: cast_nullable_to_non_nullable
              as dynamic,
      lessonAttendanceNum: freezed == lessonAttendanceNum
          ? _value.lessonAttendanceNum
          : lessonAttendanceNum // ignore: cast_nullable_to_non_nullable
              as dynamic,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      lessons: freezed == lessons
          ? _value.lessons
          : lessons // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      isClose: null == isClose
          ? _value.isClose
          : isClose // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CourseClassModelImplCopyWith<$Res>
    implements $CourseClassModelCopyWith<$Res> {
  factory _$$CourseClassModelImplCopyWith(_$CourseClassModelImpl value,
          $Res Function(_$CourseClassModelImpl) then) =
      __$$CourseClassModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'class_id') String? classId,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'teaching_type') String? teachingType,
      @JsonKey(name: 'teaching_type_name') String? teachingTypeName,
      @JsonKey(name: 'lesson_num') dynamic lessonNum,
      @JsonKey(name: 'lesson_attendance_num') dynamic lessonAttendanceNum,
      @JsonKey(name: 'address') String? address,
      @JsonKey(name: 'lesson') List<Map<String, dynamic>>? lessons,
      @JsonKey(includeFromJson: false, includeToJson: false) bool isClose});
}

/// @nodoc
class __$$CourseClassModelImplCopyWithImpl<$Res>
    extends _$CourseClassModelCopyWithImpl<$Res, _$CourseClassModelImpl>
    implements _$$CourseClassModelImplCopyWith<$Res> {
  __$$CourseClassModelImplCopyWithImpl(_$CourseClassModelImpl _value,
      $Res Function(_$CourseClassModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? classId = freezed,
    Object? name = freezed,
    Object? teachingType = freezed,
    Object? teachingTypeName = freezed,
    Object? lessonNum = freezed,
    Object? lessonAttendanceNum = freezed,
    Object? address = freezed,
    Object? lessons = freezed,
    Object? isClose = null,
  }) {
    return _then(_$CourseClassModelImpl(
      classId: freezed == classId
          ? _value.classId
          : classId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      teachingType: freezed == teachingType
          ? _value.teachingType
          : teachingType // ignore: cast_nullable_to_non_nullable
              as String?,
      teachingTypeName: freezed == teachingTypeName
          ? _value.teachingTypeName
          : teachingTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
      lessonNum: freezed == lessonNum
          ? _value.lessonNum
          : lessonNum // ignore: cast_nullable_to_non_nullable
              as dynamic,
      lessonAttendanceNum: freezed == lessonAttendanceNum
          ? _value.lessonAttendanceNum
          : lessonAttendanceNum // ignore: cast_nullable_to_non_nullable
              as dynamic,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      lessons: freezed == lessons
          ? _value._lessons
          : lessons // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      isClose: null == isClose
          ? _value.isClose
          : isClose // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseClassModelImpl implements _CourseClassModel {
  const _$CourseClassModelImpl(
      {@JsonKey(name: 'class_id') this.classId,
      @JsonKey(name: 'name') this.name,
      @JsonKey(name: 'teaching_type') this.teachingType,
      @JsonKey(name: 'teaching_type_name') this.teachingTypeName,
      @JsonKey(name: 'lesson_num') this.lessonNum,
      @JsonKey(name: 'lesson_attendance_num') this.lessonAttendanceNum,
      @JsonKey(name: 'address') this.address,
      @JsonKey(name: 'lesson') final List<Map<String, dynamic>>? lessons,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.isClose = false})
      : _lessons = lessons;

  factory _$CourseClassModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseClassModelImplFromJson(json);

  @override
  @JsonKey(name: 'class_id')
  final String? classId;
  @override
  @JsonKey(name: 'name')
  final String? name;
  @override
  @JsonKey(name: 'teaching_type')
  final String? teachingType;
  @override
  @JsonKey(name: 'teaching_type_name')
  final String? teachingTypeName;
  @override
  @JsonKey(name: 'lesson_num')
  final dynamic lessonNum;
  @override
  @JsonKey(name: 'lesson_attendance_num')
  final dynamic lessonAttendanceNum;
  @override
  @JsonKey(name: 'address')
  final String? address;
  final List<Map<String, dynamic>>? _lessons;
  @override
  @JsonKey(name: 'lesson')
  List<Map<String, dynamic>>? get lessons {
    final value = _lessons;
    if (value == null) return null;
    if (_lessons is EqualUnmodifiableListView) return _lessons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// ✅ UI状态字段（不从JSON解析）
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isClose;

  @override
  String toString() {
    return 'CourseClassModel(classId: $classId, name: $name, teachingType: $teachingType, teachingTypeName: $teachingTypeName, lessonNum: $lessonNum, lessonAttendanceNum: $lessonAttendanceNum, address: $address, lessons: $lessons, isClose: $isClose)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseClassModelImpl &&
            (identical(other.classId, classId) || other.classId == classId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.teachingType, teachingType) ||
                other.teachingType == teachingType) &&
            (identical(other.teachingTypeName, teachingTypeName) ||
                other.teachingTypeName == teachingTypeName) &&
            const DeepCollectionEquality().equals(other.lessonNum, lessonNum) &&
            const DeepCollectionEquality()
                .equals(other.lessonAttendanceNum, lessonAttendanceNum) &&
            (identical(other.address, address) || other.address == address) &&
            const DeepCollectionEquality().equals(other._lessons, _lessons) &&
            (identical(other.isClose, isClose) || other.isClose == isClose));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      classId,
      name,
      teachingType,
      teachingTypeName,
      const DeepCollectionEquality().hash(lessonNum),
      const DeepCollectionEquality().hash(lessonAttendanceNum),
      address,
      const DeepCollectionEquality().hash(_lessons),
      isClose);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseClassModelImplCopyWith<_$CourseClassModelImpl> get copyWith =>
      __$$CourseClassModelImplCopyWithImpl<_$CourseClassModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseClassModelImplToJson(
      this,
    );
  }
}

abstract class _CourseClassModel implements CourseClassModel {
  const factory _CourseClassModel(
      {@JsonKey(name: 'class_id') final String? classId,
      @JsonKey(name: 'name') final String? name,
      @JsonKey(name: 'teaching_type') final String? teachingType,
      @JsonKey(name: 'teaching_type_name') final String? teachingTypeName,
      @JsonKey(name: 'lesson_num') final dynamic lessonNum,
      @JsonKey(name: 'lesson_attendance_num') final dynamic lessonAttendanceNum,
      @JsonKey(name: 'address') final String? address,
      @JsonKey(name: 'lesson') final List<Map<String, dynamic>>? lessons,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final bool isClose}) = _$CourseClassModelImpl;

  factory _CourseClassModel.fromJson(Map<String, dynamic> json) =
      _$CourseClassModelImpl.fromJson;

  @override
  @JsonKey(name: 'class_id')
  String? get classId;
  @override
  @JsonKey(name: 'name')
  String? get name;
  @override
  @JsonKey(name: 'teaching_type')
  String? get teachingType;
  @override
  @JsonKey(name: 'teaching_type_name')
  String? get teachingTypeName;
  @override
  @JsonKey(name: 'lesson_num')
  dynamic get lessonNum;
  @override
  @JsonKey(name: 'lesson_attendance_num')
  dynamic get lessonAttendanceNum;
  @override
  @JsonKey(name: 'address')
  String? get address;
  @override
  @JsonKey(name: 'lesson')
  List<Map<String, dynamic>>? get lessons;
  @override // ✅ UI状态字段（不从JSON解析）
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isClose;
  @override
  @JsonKey(ignore: true)
  _$$CourseClassModelImplCopyWith<_$CourseClassModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecentlyDataModel _$RecentlyDataModelFromJson(Map<String, dynamic> json) {
  return _RecentlyDataModel.fromJson(json);
}

/// @nodoc
mixin _$RecentlyDataModel {
  @JsonKey(name: 'lesson_id')
  String? get lessonId => throw _privateConstructorUsedError;
  @JsonKey(name: 'lesson_name')
  String? get lessonName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RecentlyDataModelCopyWith<RecentlyDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentlyDataModelCopyWith<$Res> {
  factory $RecentlyDataModelCopyWith(
          RecentlyDataModel value, $Res Function(RecentlyDataModel) then) =
      _$RecentlyDataModelCopyWithImpl<$Res, RecentlyDataModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'lesson_id') String? lessonId,
      @JsonKey(name: 'lesson_name') String? lessonName});
}

/// @nodoc
class _$RecentlyDataModelCopyWithImpl<$Res, $Val extends RecentlyDataModel>
    implements $RecentlyDataModelCopyWith<$Res> {
  _$RecentlyDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lessonId = freezed,
    Object? lessonName = freezed,
  }) {
    return _then(_value.copyWith(
      lessonId: freezed == lessonId
          ? _value.lessonId
          : lessonId // ignore: cast_nullable_to_non_nullable
              as String?,
      lessonName: freezed == lessonName
          ? _value.lessonName
          : lessonName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecentlyDataModelImplCopyWith<$Res>
    implements $RecentlyDataModelCopyWith<$Res> {
  factory _$$RecentlyDataModelImplCopyWith(_$RecentlyDataModelImpl value,
          $Res Function(_$RecentlyDataModelImpl) then) =
      __$$RecentlyDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'lesson_id') String? lessonId,
      @JsonKey(name: 'lesson_name') String? lessonName});
}

/// @nodoc
class __$$RecentlyDataModelImplCopyWithImpl<$Res>
    extends _$RecentlyDataModelCopyWithImpl<$Res, _$RecentlyDataModelImpl>
    implements _$$RecentlyDataModelImplCopyWith<$Res> {
  __$$RecentlyDataModelImplCopyWithImpl(_$RecentlyDataModelImpl _value,
      $Res Function(_$RecentlyDataModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lessonId = freezed,
    Object? lessonName = freezed,
  }) {
    return _then(_$RecentlyDataModelImpl(
      lessonId: freezed == lessonId
          ? _value.lessonId
          : lessonId // ignore: cast_nullable_to_non_nullable
              as String?,
      lessonName: freezed == lessonName
          ? _value.lessonName
          : lessonName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecentlyDataModelImpl implements _RecentlyDataModel {
  const _$RecentlyDataModelImpl(
      {@JsonKey(name: 'lesson_id') this.lessonId,
      @JsonKey(name: 'lesson_name') this.lessonName});

  factory _$RecentlyDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecentlyDataModelImplFromJson(json);

  @override
  @JsonKey(name: 'lesson_id')
  final String? lessonId;
  @override
  @JsonKey(name: 'lesson_name')
  final String? lessonName;

  @override
  String toString() {
    return 'RecentlyDataModel(lessonId: $lessonId, lessonName: $lessonName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentlyDataModelImpl &&
            (identical(other.lessonId, lessonId) ||
                other.lessonId == lessonId) &&
            (identical(other.lessonName, lessonName) ||
                other.lessonName == lessonName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, lessonId, lessonName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentlyDataModelImplCopyWith<_$RecentlyDataModelImpl> get copyWith =>
      __$$RecentlyDataModelImplCopyWithImpl<_$RecentlyDataModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecentlyDataModelImplToJson(
      this,
    );
  }
}

abstract class _RecentlyDataModel implements RecentlyDataModel {
  const factory _RecentlyDataModel(
          {@JsonKey(name: 'lesson_id') final String? lessonId,
          @JsonKey(name: 'lesson_name') final String? lessonName}) =
      _$RecentlyDataModelImpl;

  factory _RecentlyDataModel.fromJson(Map<String, dynamic> json) =
      _$RecentlyDataModelImpl.fromJson;

  @override
  @JsonKey(name: 'lesson_id')
  String? get lessonId;
  @override
  @JsonKey(name: 'lesson_name')
  String? get lessonName;
  @override
  @JsonKey(ignore: true)
  _$$RecentlyDataModelImplCopyWith<_$RecentlyDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
