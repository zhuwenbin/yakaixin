// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'major_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MajorModel _$MajorModelFromJson(Map<String, dynamic> json) {
  return _MajorModel.fromJson(json);
}

/// @nodoc
mixin _$MajorModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_name')
  String get dataName => throw _privateConstructorUsedError;
  @JsonKey(name: 'level')
  String? get level => throw _privateConstructorUsedError;
  @JsonKey(name: 'subs')
  List<MajorModel> get subs => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MajorModelCopyWith<MajorModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MajorModelCopyWith<$Res> {
  factory $MajorModelCopyWith(
          MajorModel value, $Res Function(MajorModel) then) =
      _$MajorModelCopyWithImpl<$Res, MajorModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'data_name') String dataName,
      @JsonKey(name: 'level') String? level,
      @JsonKey(name: 'subs') List<MajorModel> subs});
}

/// @nodoc
class _$MajorModelCopyWithImpl<$Res, $Val extends MajorModel>
    implements $MajorModelCopyWith<$Res> {
  _$MajorModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dataName = null,
    Object? level = freezed,
    Object? subs = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dataName: null == dataName
          ? _value.dataName
          : dataName // ignore: cast_nullable_to_non_nullable
              as String,
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
      subs: null == subs
          ? _value.subs
          : subs // ignore: cast_nullable_to_non_nullable
              as List<MajorModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MajorModelImplCopyWith<$Res>
    implements $MajorModelCopyWith<$Res> {
  factory _$$MajorModelImplCopyWith(
          _$MajorModelImpl value, $Res Function(_$MajorModelImpl) then) =
      __$$MajorModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'data_name') String dataName,
      @JsonKey(name: 'level') String? level,
      @JsonKey(name: 'subs') List<MajorModel> subs});
}

/// @nodoc
class __$$MajorModelImplCopyWithImpl<$Res>
    extends _$MajorModelCopyWithImpl<$Res, _$MajorModelImpl>
    implements _$$MajorModelImplCopyWith<$Res> {
  __$$MajorModelImplCopyWithImpl(
      _$MajorModelImpl _value, $Res Function(_$MajorModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dataName = null,
    Object? level = freezed,
    Object? subs = null,
  }) {
    return _then(_$MajorModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dataName: null == dataName
          ? _value.dataName
          : dataName // ignore: cast_nullable_to_non_nullable
              as String,
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
      subs: null == subs
          ? _value._subs
          : subs // ignore: cast_nullable_to_non_nullable
              as List<MajorModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MajorModelImpl implements _MajorModel {
  const _$MajorModelImpl(
      {required this.id,
      @JsonKey(name: 'data_name') required this.dataName,
      @JsonKey(name: 'level') this.level,
      @JsonKey(name: 'subs') final List<MajorModel> subs = const []})
      : _subs = subs;

  factory _$MajorModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MajorModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'data_name')
  final String dataName;
  @override
  @JsonKey(name: 'level')
  final String? level;
  final List<MajorModel> _subs;
  @override
  @JsonKey(name: 'subs')
  List<MajorModel> get subs {
    if (_subs is EqualUnmodifiableListView) return _subs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subs);
  }

  @override
  String toString() {
    return 'MajorModel(id: $id, dataName: $dataName, level: $level, subs: $subs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MajorModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dataName, dataName) ||
                other.dataName == dataName) &&
            (identical(other.level, level) || other.level == level) &&
            const DeepCollectionEquality().equals(other._subs, _subs));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, dataName, level,
      const DeepCollectionEquality().hash(_subs));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MajorModelImplCopyWith<_$MajorModelImpl> get copyWith =>
      __$$MajorModelImplCopyWithImpl<_$MajorModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MajorModelImplToJson(
      this,
    );
  }
}

abstract class _MajorModel implements MajorModel {
  const factory _MajorModel(
      {required final String id,
      @JsonKey(name: 'data_name') required final String dataName,
      @JsonKey(name: 'level') final String? level,
      @JsonKey(name: 'subs') final List<MajorModel> subs}) = _$MajorModelImpl;

  factory _MajorModel.fromJson(Map<String, dynamic> json) =
      _$MajorModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'data_name')
  String get dataName;
  @override
  @JsonKey(name: 'level')
  String? get level;
  @override
  @JsonKey(name: 'subs')
  List<MajorModel> get subs;
  @override
  @JsonKey(ignore: true)
  _$$MajorModelImplCopyWith<_$MajorModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MajorListResponse {
  List<MajorModel> get list => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MajorListResponseCopyWith<MajorListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MajorListResponseCopyWith<$Res> {
  factory $MajorListResponseCopyWith(
          MajorListResponse value, $Res Function(MajorListResponse) then) =
      _$MajorListResponseCopyWithImpl<$Res, MajorListResponse>;
  @useResult
  $Res call({List<MajorModel> list});
}

/// @nodoc
class _$MajorListResponseCopyWithImpl<$Res, $Val extends MajorListResponse>
    implements $MajorListResponseCopyWith<$Res> {
  _$MajorListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
  }) {
    return _then(_value.copyWith(
      list: null == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<MajorModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MajorListResponseImplCopyWith<$Res>
    implements $MajorListResponseCopyWith<$Res> {
  factory _$$MajorListResponseImplCopyWith(_$MajorListResponseImpl value,
          $Res Function(_$MajorListResponseImpl) then) =
      __$$MajorListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<MajorModel> list});
}

/// @nodoc
class __$$MajorListResponseImplCopyWithImpl<$Res>
    extends _$MajorListResponseCopyWithImpl<$Res, _$MajorListResponseImpl>
    implements _$$MajorListResponseImplCopyWith<$Res> {
  __$$MajorListResponseImplCopyWithImpl(_$MajorListResponseImpl _value,
      $Res Function(_$MajorListResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
  }) {
    return _then(_$MajorListResponseImpl(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<MajorModel>,
    ));
  }
}

/// @nodoc

class _$MajorListResponseImpl implements _MajorListResponse {
  const _$MajorListResponseImpl({final List<MajorModel> list = const []})
      : _list = list;

  final List<MajorModel> _list;
  @override
  @JsonKey()
  List<MajorModel> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  String toString() {
    return 'MajorListResponse(list: $list)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MajorListResponseImpl &&
            const DeepCollectionEquality().equals(other._list, _list));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_list));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MajorListResponseImplCopyWith<_$MajorListResponseImpl> get copyWith =>
      __$$MajorListResponseImplCopyWithImpl<_$MajorListResponseImpl>(
          this, _$identity);
}

abstract class _MajorListResponse implements MajorListResponse {
  const factory _MajorListResponse({final List<MajorModel> list}) =
      _$MajorListResponseImpl;

  @override
  List<MajorModel> get list;
  @override
  @JsonKey(ignore: true)
  _$$MajorListResponseImplCopyWith<_$MajorListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CurrentMajor _$CurrentMajorFromJson(Map<String, dynamic> json) {
  return _CurrentMajor.fromJson(json);
}

/// @nodoc
mixin _$CurrentMajor {
  @JsonKey(name: 'major_id')
  String get majorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'major_name')
  String get majorName => throw _privateConstructorUsedError;
  @JsonKey(name: 'major_pid_level')
  String? get majorPidLevel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CurrentMajorCopyWith<CurrentMajor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrentMajorCopyWith<$Res> {
  factory $CurrentMajorCopyWith(
          CurrentMajor value, $Res Function(CurrentMajor) then) =
      _$CurrentMajorCopyWithImpl<$Res, CurrentMajor>;
  @useResult
  $Res call(
      {@JsonKey(name: 'major_id') String majorId,
      @JsonKey(name: 'major_name') String majorName,
      @JsonKey(name: 'major_pid_level') String? majorPidLevel});
}

/// @nodoc
class _$CurrentMajorCopyWithImpl<$Res, $Val extends CurrentMajor>
    implements $CurrentMajorCopyWith<$Res> {
  _$CurrentMajorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? majorId = null,
    Object? majorName = null,
    Object? majorPidLevel = freezed,
  }) {
    return _then(_value.copyWith(
      majorId: null == majorId
          ? _value.majorId
          : majorId // ignore: cast_nullable_to_non_nullable
              as String,
      majorName: null == majorName
          ? _value.majorName
          : majorName // ignore: cast_nullable_to_non_nullable
              as String,
      majorPidLevel: freezed == majorPidLevel
          ? _value.majorPidLevel
          : majorPidLevel // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrentMajorImplCopyWith<$Res>
    implements $CurrentMajorCopyWith<$Res> {
  factory _$$CurrentMajorImplCopyWith(
          _$CurrentMajorImpl value, $Res Function(_$CurrentMajorImpl) then) =
      __$$CurrentMajorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'major_id') String majorId,
      @JsonKey(name: 'major_name') String majorName,
      @JsonKey(name: 'major_pid_level') String? majorPidLevel});
}

/// @nodoc
class __$$CurrentMajorImplCopyWithImpl<$Res>
    extends _$CurrentMajorCopyWithImpl<$Res, _$CurrentMajorImpl>
    implements _$$CurrentMajorImplCopyWith<$Res> {
  __$$CurrentMajorImplCopyWithImpl(
      _$CurrentMajorImpl _value, $Res Function(_$CurrentMajorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? majorId = null,
    Object? majorName = null,
    Object? majorPidLevel = freezed,
  }) {
    return _then(_$CurrentMajorImpl(
      majorId: null == majorId
          ? _value.majorId
          : majorId // ignore: cast_nullable_to_non_nullable
              as String,
      majorName: null == majorName
          ? _value.majorName
          : majorName // ignore: cast_nullable_to_non_nullable
              as String,
      majorPidLevel: freezed == majorPidLevel
          ? _value.majorPidLevel
          : majorPidLevel // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CurrentMajorImpl implements _CurrentMajor {
  const _$CurrentMajorImpl(
      {@JsonKey(name: 'major_id') required this.majorId,
      @JsonKey(name: 'major_name') required this.majorName,
      @JsonKey(name: 'major_pid_level') this.majorPidLevel});

  factory _$CurrentMajorImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurrentMajorImplFromJson(json);

  @override
  @JsonKey(name: 'major_id')
  final String majorId;
  @override
  @JsonKey(name: 'major_name')
  final String majorName;
  @override
  @JsonKey(name: 'major_pid_level')
  final String? majorPidLevel;

  @override
  String toString() {
    return 'CurrentMajor(majorId: $majorId, majorName: $majorName, majorPidLevel: $majorPidLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrentMajorImpl &&
            (identical(other.majorId, majorId) || other.majorId == majorId) &&
            (identical(other.majorName, majorName) ||
                other.majorName == majorName) &&
            (identical(other.majorPidLevel, majorPidLevel) ||
                other.majorPidLevel == majorPidLevel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, majorId, majorName, majorPidLevel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrentMajorImplCopyWith<_$CurrentMajorImpl> get copyWith =>
      __$$CurrentMajorImplCopyWithImpl<_$CurrentMajorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CurrentMajorImplToJson(
      this,
    );
  }
}

abstract class _CurrentMajor implements CurrentMajor {
  const factory _CurrentMajor(
          {@JsonKey(name: 'major_id') required final String majorId,
          @JsonKey(name: 'major_name') required final String majorName,
          @JsonKey(name: 'major_pid_level') final String? majorPidLevel}) =
      _$CurrentMajorImpl;

  factory _CurrentMajor.fromJson(Map<String, dynamic> json) =
      _$CurrentMajorImpl.fromJson;

  @override
  @JsonKey(name: 'major_id')
  String get majorId;
  @override
  @JsonKey(name: 'major_name')
  String get majorName;
  @override
  @JsonKey(name: 'major_pid_level')
  String? get majorPidLevel;
  @override
  @JsonKey(ignore: true)
  _$$CurrentMajorImplCopyWith<_$CurrentMajorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
