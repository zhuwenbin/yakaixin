// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CourseModel _$CourseModelFromJson(Map<String, dynamic> json) {
  return _CourseModel.fromJson(json);
}

/// @nodoc
mixin _$CourseModel {
  @JsonKey(name: 'goods_id')
  String? get goodsId => throw _privateConstructorUsedError;
  @JsonKey(name: 'goods_name')
  String? get goodsName => throw _privateConstructorUsedError;
  @JsonKey(name: 'goods_pid')
  String? get goodsPid => throw _privateConstructorUsedError;
  @JsonKey(name: 'goods_pid_name')
  String? get goodsPidName => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_id')
  String? get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'teaching_type_name')
  String? get teachingTypeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'class')
  Map<String, dynamic>? get classInfo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CourseModelCopyWith<CourseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseModelCopyWith<$Res> {
  factory $CourseModelCopyWith(
          CourseModel value, $Res Function(CourseModel) then) =
      _$CourseModelCopyWithImpl<$Res, CourseModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'goods_id') String? goodsId,
      @JsonKey(name: 'goods_name') String? goodsName,
      @JsonKey(name: 'goods_pid') String? goodsPid,
      @JsonKey(name: 'goods_pid_name') String? goodsPidName,
      @JsonKey(name: 'order_id') String? orderId,
      @JsonKey(name: 'teaching_type_name') String? teachingTypeName,
      @JsonKey(name: 'class') Map<String, dynamic>? classInfo});
}

/// @nodoc
class _$CourseModelCopyWithImpl<$Res, $Val extends CourseModel>
    implements $CourseModelCopyWith<$Res> {
  _$CourseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goodsId = freezed,
    Object? goodsName = freezed,
    Object? goodsPid = freezed,
    Object? goodsPidName = freezed,
    Object? orderId = freezed,
    Object? teachingTypeName = freezed,
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
      goodsPid: freezed == goodsPid
          ? _value.goodsPid
          : goodsPid // ignore: cast_nullable_to_non_nullable
              as String?,
      goodsPidName: freezed == goodsPidName
          ? _value.goodsPidName
          : goodsPidName // ignore: cast_nullable_to_non_nullable
              as String?,
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      teachingTypeName: freezed == teachingTypeName
          ? _value.teachingTypeName
          : teachingTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
      classInfo: freezed == classInfo
          ? _value.classInfo
          : classInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CourseModelImplCopyWith<$Res>
    implements $CourseModelCopyWith<$Res> {
  factory _$$CourseModelImplCopyWith(
          _$CourseModelImpl value, $Res Function(_$CourseModelImpl) then) =
      __$$CourseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'goods_id') String? goodsId,
      @JsonKey(name: 'goods_name') String? goodsName,
      @JsonKey(name: 'goods_pid') String? goodsPid,
      @JsonKey(name: 'goods_pid_name') String? goodsPidName,
      @JsonKey(name: 'order_id') String? orderId,
      @JsonKey(name: 'teaching_type_name') String? teachingTypeName,
      @JsonKey(name: 'class') Map<String, dynamic>? classInfo});
}

/// @nodoc
class __$$CourseModelImplCopyWithImpl<$Res>
    extends _$CourseModelCopyWithImpl<$Res, _$CourseModelImpl>
    implements _$$CourseModelImplCopyWith<$Res> {
  __$$CourseModelImplCopyWithImpl(
      _$CourseModelImpl _value, $Res Function(_$CourseModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goodsId = freezed,
    Object? goodsName = freezed,
    Object? goodsPid = freezed,
    Object? goodsPidName = freezed,
    Object? orderId = freezed,
    Object? teachingTypeName = freezed,
    Object? classInfo = freezed,
  }) {
    return _then(_$CourseModelImpl(
      goodsId: freezed == goodsId
          ? _value.goodsId
          : goodsId // ignore: cast_nullable_to_non_nullable
              as String?,
      goodsName: freezed == goodsName
          ? _value.goodsName
          : goodsName // ignore: cast_nullable_to_non_nullable
              as String?,
      goodsPid: freezed == goodsPid
          ? _value.goodsPid
          : goodsPid // ignore: cast_nullable_to_non_nullable
              as String?,
      goodsPidName: freezed == goodsPidName
          ? _value.goodsPidName
          : goodsPidName // ignore: cast_nullable_to_non_nullable
              as String?,
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      teachingTypeName: freezed == teachingTypeName
          ? _value.teachingTypeName
          : teachingTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
      classInfo: freezed == classInfo
          ? _value._classInfo
          : classInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseModelImpl implements _CourseModel {
  const _$CourseModelImpl(
      {@JsonKey(name: 'goods_id') this.goodsId,
      @JsonKey(name: 'goods_name') this.goodsName,
      @JsonKey(name: 'goods_pid') this.goodsPid,
      @JsonKey(name: 'goods_pid_name') this.goodsPidName,
      @JsonKey(name: 'order_id') this.orderId,
      @JsonKey(name: 'teaching_type_name') this.teachingTypeName,
      @JsonKey(name: 'class') final Map<String, dynamic>? classInfo})
      : _classInfo = classInfo;

  factory _$CourseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseModelImplFromJson(json);

  @override
  @JsonKey(name: 'goods_id')
  final String? goodsId;
  @override
  @JsonKey(name: 'goods_name')
  final String? goodsName;
  @override
  @JsonKey(name: 'goods_pid')
  final String? goodsPid;
  @override
  @JsonKey(name: 'goods_pid_name')
  final String? goodsPidName;
  @override
  @JsonKey(name: 'order_id')
  final String? orderId;
  @override
  @JsonKey(name: 'teaching_type_name')
  final String? teachingTypeName;
  final Map<String, dynamic>? _classInfo;
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
    return 'CourseModel(goodsId: $goodsId, goodsName: $goodsName, goodsPid: $goodsPid, goodsPidName: $goodsPidName, orderId: $orderId, teachingTypeName: $teachingTypeName, classInfo: $classInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseModelImpl &&
            (identical(other.goodsId, goodsId) || other.goodsId == goodsId) &&
            (identical(other.goodsName, goodsName) ||
                other.goodsName == goodsName) &&
            (identical(other.goodsPid, goodsPid) ||
                other.goodsPid == goodsPid) &&
            (identical(other.goodsPidName, goodsPidName) ||
                other.goodsPidName == goodsPidName) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.teachingTypeName, teachingTypeName) ||
                other.teachingTypeName == teachingTypeName) &&
            const DeepCollectionEquality()
                .equals(other._classInfo, _classInfo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      goodsId,
      goodsName,
      goodsPid,
      goodsPidName,
      orderId,
      teachingTypeName,
      const DeepCollectionEquality().hash(_classInfo));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseModelImplCopyWith<_$CourseModelImpl> get copyWith =>
      __$$CourseModelImplCopyWithImpl<_$CourseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseModelImplToJson(
      this,
    );
  }
}

abstract class _CourseModel implements CourseModel {
  const factory _CourseModel(
          {@JsonKey(name: 'goods_id') final String? goodsId,
          @JsonKey(name: 'goods_name') final String? goodsName,
          @JsonKey(name: 'goods_pid') final String? goodsPid,
          @JsonKey(name: 'goods_pid_name') final String? goodsPidName,
          @JsonKey(name: 'order_id') final String? orderId,
          @JsonKey(name: 'teaching_type_name') final String? teachingTypeName,
          @JsonKey(name: 'class') final Map<String, dynamic>? classInfo}) =
      _$CourseModelImpl;

  factory _CourseModel.fromJson(Map<String, dynamic> json) =
      _$CourseModelImpl.fromJson;

  @override
  @JsonKey(name: 'goods_id')
  String? get goodsId;
  @override
  @JsonKey(name: 'goods_name')
  String? get goodsName;
  @override
  @JsonKey(name: 'goods_pid')
  String? get goodsPid;
  @override
  @JsonKey(name: 'goods_pid_name')
  String? get goodsPidName;
  @override
  @JsonKey(name: 'order_id')
  String? get orderId;
  @override
  @JsonKey(name: 'teaching_type_name')
  String? get teachingTypeName;
  @override
  @JsonKey(name: 'class')
  Map<String, dynamic>? get classInfo;
  @override
  @JsonKey(ignore: true)
  _$$CourseModelImplCopyWith<_$CourseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
