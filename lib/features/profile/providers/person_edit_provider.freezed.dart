// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'person_edit_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PersonEditState {
  String get studentId => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  String get avatar => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isUploading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PersonEditStateCopyWith<PersonEditState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonEditStateCopyWith<$Res> {
  factory $PersonEditStateCopyWith(
          PersonEditState value, $Res Function(PersonEditState) then) =
      _$PersonEditStateCopyWithImpl<$Res, PersonEditState>;
  @useResult
  $Res call(
      {String studentId,
      String nickname,
      String avatar,
      bool isLoading,
      bool isUploading,
      String? error});
}

/// @nodoc
class _$PersonEditStateCopyWithImpl<$Res, $Val extends PersonEditState>
    implements $PersonEditStateCopyWith<$Res> {
  _$PersonEditStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentId = null,
    Object? nickname = null,
    Object? avatar = null,
    Object? isLoading = null,
    Object? isUploading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isUploading: null == isUploading
          ? _value.isUploading
          : isUploading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PersonEditStateImplCopyWith<$Res>
    implements $PersonEditStateCopyWith<$Res> {
  factory _$$PersonEditStateImplCopyWith(_$PersonEditStateImpl value,
          $Res Function(_$PersonEditStateImpl) then) =
      __$$PersonEditStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String studentId,
      String nickname,
      String avatar,
      bool isLoading,
      bool isUploading,
      String? error});
}

/// @nodoc
class __$$PersonEditStateImplCopyWithImpl<$Res>
    extends _$PersonEditStateCopyWithImpl<$Res, _$PersonEditStateImpl>
    implements _$$PersonEditStateImplCopyWith<$Res> {
  __$$PersonEditStateImplCopyWithImpl(
      _$PersonEditStateImpl _value, $Res Function(_$PersonEditStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentId = null,
    Object? nickname = null,
    Object? avatar = null,
    Object? isLoading = null,
    Object? isUploading = null,
    Object? error = freezed,
  }) {
    return _then(_$PersonEditStateImpl(
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isUploading: null == isUploading
          ? _value.isUploading
          : isUploading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$PersonEditStateImpl implements _PersonEditState {
  const _$PersonEditStateImpl(
      {this.studentId = '',
      this.nickname = '',
      this.avatar = '',
      this.isLoading = false,
      this.isUploading = false,
      this.error});

  @override
  @JsonKey()
  final String studentId;
  @override
  @JsonKey()
  final String nickname;
  @override
  @JsonKey()
  final String avatar;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isUploading;
  @override
  final String? error;

  @override
  String toString() {
    return 'PersonEditState(studentId: $studentId, nickname: $nickname, avatar: $avatar, isLoading: $isLoading, isUploading: $isUploading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonEditStateImpl &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isUploading, isUploading) ||
                other.isUploading == isUploading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, studentId, nickname, avatar, isLoading, isUploading, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonEditStateImplCopyWith<_$PersonEditStateImpl> get copyWith =>
      __$$PersonEditStateImplCopyWithImpl<_$PersonEditStateImpl>(
          this, _$identity);
}

abstract class _PersonEditState implements PersonEditState {
  const factory _PersonEditState(
      {final String studentId,
      final String nickname,
      final String avatar,
      final bool isLoading,
      final bool isUploading,
      final String? error}) = _$PersonEditStateImpl;

  @override
  String get studentId;
  @override
  String get nickname;
  @override
  String get avatar;
  @override
  bool get isLoading;
  @override
  bool get isUploading;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$PersonEditStateImplCopyWith<_$PersonEditStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
