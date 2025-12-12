// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paper_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaperModel _$PaperModelFromJson(Map<String, dynamic> json) {
  return _PaperModel.fromJson(json);
}

/// @nodoc
mixin _$PaperModel {
  @JsonKey(name: 'id')
  dynamic get id => throw _privateConstructorUsedError; // 试卷ID
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError; // 试卷名称
  @JsonKey(name: 'paper_exercise_id')
  String? get paperExerciseId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaperModelCopyWith<PaperModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaperModelCopyWith<$Res> {
  factory $PaperModelCopyWith(
          PaperModel value, $Res Function(PaperModel) then) =
      _$PaperModelCopyWithImpl<$Res, PaperModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') dynamic id,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'paper_exercise_id') String? paperExerciseId});
}

/// @nodoc
class _$PaperModelCopyWithImpl<$Res, $Val extends PaperModel>
    implements $PaperModelCopyWith<$Res> {
  _$PaperModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? paperExerciseId = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as dynamic,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      paperExerciseId: freezed == paperExerciseId
          ? _value.paperExerciseId
          : paperExerciseId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaperModelImplCopyWith<$Res>
    implements $PaperModelCopyWith<$Res> {
  factory _$$PaperModelImplCopyWith(
          _$PaperModelImpl value, $Res Function(_$PaperModelImpl) then) =
      __$$PaperModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') dynamic id,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'paper_exercise_id') String? paperExerciseId});
}

/// @nodoc
class __$$PaperModelImplCopyWithImpl<$Res>
    extends _$PaperModelCopyWithImpl<$Res, _$PaperModelImpl>
    implements _$$PaperModelImplCopyWith<$Res> {
  __$$PaperModelImplCopyWithImpl(
      _$PaperModelImpl _value, $Res Function(_$PaperModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? paperExerciseId = freezed,
  }) {
    return _then(_$PaperModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as dynamic,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      paperExerciseId: freezed == paperExerciseId
          ? _value.paperExerciseId
          : paperExerciseId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaperModelImpl implements _PaperModel {
  const _$PaperModelImpl(
      {@JsonKey(name: 'id') this.id,
      @JsonKey(name: 'name') this.name,
      @JsonKey(name: 'paper_exercise_id') this.paperExerciseId});

  factory _$PaperModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaperModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final dynamic id;
// 试卷ID
  @override
  @JsonKey(name: 'name')
  final String? name;
// 试卷名称
  @override
  @JsonKey(name: 'paper_exercise_id')
  final String? paperExerciseId;

  @override
  String toString() {
    return 'PaperModel(id: $id, name: $name, paperExerciseId: $paperExerciseId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaperModelImpl &&
            const DeepCollectionEquality().equals(other.id, id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.paperExerciseId, paperExerciseId) ||
                other.paperExerciseId == paperExerciseId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(id), name, paperExerciseId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaperModelImplCopyWith<_$PaperModelImpl> get copyWith =>
      __$$PaperModelImplCopyWithImpl<_$PaperModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaperModelImplToJson(
      this,
    );
  }
}

abstract class _PaperModel implements PaperModel {
  const factory _PaperModel(
          {@JsonKey(name: 'id') final dynamic id,
          @JsonKey(name: 'name') final String? name,
          @JsonKey(name: 'paper_exercise_id') final String? paperExerciseId}) =
      _$PaperModelImpl;

  factory _PaperModel.fromJson(Map<String, dynamic> json) =
      _$PaperModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  dynamic get id;
  @override // 试卷ID
  @JsonKey(name: 'name')
  String? get name;
  @override // 试卷名称
  @JsonKey(name: 'paper_exercise_id')
  String? get paperExerciseId;
  @override
  @JsonKey(ignore: true)
  _$$PaperModelImplCopyWith<_$PaperModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChapterPaperModel _$ChapterPaperModelFromJson(Map<String, dynamic> json) {
  return _ChapterPaperModel.fromJson(json);
}

/// @nodoc
mixin _$ChapterPaperModel {
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError; // 章节名称
  @JsonKey(name: 'list')
  List<PaperModel> get list => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChapterPaperModelCopyWith<ChapterPaperModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChapterPaperModelCopyWith<$Res> {
  factory $ChapterPaperModelCopyWith(
          ChapterPaperModel value, $Res Function(ChapterPaperModel) then) =
      _$ChapterPaperModelCopyWithImpl<$Res, ChapterPaperModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String? name,
      @JsonKey(name: 'list') List<PaperModel> list});
}

/// @nodoc
class _$ChapterPaperModelCopyWithImpl<$Res, $Val extends ChapterPaperModel>
    implements $ChapterPaperModelCopyWith<$Res> {
  _$ChapterPaperModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? list = null,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      list: null == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<PaperModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChapterPaperModelImplCopyWith<$Res>
    implements $ChapterPaperModelCopyWith<$Res> {
  factory _$$ChapterPaperModelImplCopyWith(_$ChapterPaperModelImpl value,
          $Res Function(_$ChapterPaperModelImpl) then) =
      __$$ChapterPaperModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String? name,
      @JsonKey(name: 'list') List<PaperModel> list});
}

/// @nodoc
class __$$ChapterPaperModelImplCopyWithImpl<$Res>
    extends _$ChapterPaperModelCopyWithImpl<$Res, _$ChapterPaperModelImpl>
    implements _$$ChapterPaperModelImplCopyWith<$Res> {
  __$$ChapterPaperModelImplCopyWithImpl(_$ChapterPaperModelImpl _value,
      $Res Function(_$ChapterPaperModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? list = null,
  }) {
    return _then(_$ChapterPaperModelImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<PaperModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChapterPaperModelImpl implements _ChapterPaperModel {
  const _$ChapterPaperModelImpl(
      {@JsonKey(name: 'name') this.name,
      @JsonKey(name: 'list') final List<PaperModel> list = const []})
      : _list = list;

  factory _$ChapterPaperModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChapterPaperModelImplFromJson(json);

  @override
  @JsonKey(name: 'name')
  final String? name;
// 章节名称
  final List<PaperModel> _list;
// 章节名称
  @override
  @JsonKey(name: 'list')
  List<PaperModel> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  String toString() {
    return 'ChapterPaperModel(name: $name, list: $list)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChapterPaperModelImpl &&
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
  _$$ChapterPaperModelImplCopyWith<_$ChapterPaperModelImpl> get copyWith =>
      __$$ChapterPaperModelImplCopyWithImpl<_$ChapterPaperModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChapterPaperModelImplToJson(
      this,
    );
  }
}

abstract class _ChapterPaperModel implements ChapterPaperModel {
  const factory _ChapterPaperModel(
          {@JsonKey(name: 'name') final String? name,
          @JsonKey(name: 'list') final List<PaperModel> list}) =
      _$ChapterPaperModelImpl;

  factory _ChapterPaperModel.fromJson(Map<String, dynamic> json) =
      _$ChapterPaperModelImpl.fromJson;

  @override
  @JsonKey(name: 'name')
  String? get name;
  @override // 章节名称
  @JsonKey(name: 'list')
  List<PaperModel> get list;
  @override
  @JsonKey(ignore: true)
  _$$ChapterPaperModelImplCopyWith<_$ChapterPaperModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
