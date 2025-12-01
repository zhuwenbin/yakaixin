// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_detail_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CourseDetailState {
  CourseDetailModel? get courseInfo => throw _privateConstructorUsedError;
  List<CourseClassModel> get classList => throw _privateConstructorUsedError;
  RecentlyDataModel? get recentlyData => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CourseDetailStateCopyWith<CourseDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseDetailStateCopyWith<$Res> {
  factory $CourseDetailStateCopyWith(
          CourseDetailState value, $Res Function(CourseDetailState) then) =
      _$CourseDetailStateCopyWithImpl<$Res, CourseDetailState>;
  @useResult
  $Res call(
      {CourseDetailModel? courseInfo,
      List<CourseClassModel> classList,
      RecentlyDataModel? recentlyData,
      bool isLoading,
      String? error});

  $CourseDetailModelCopyWith<$Res>? get courseInfo;
  $RecentlyDataModelCopyWith<$Res>? get recentlyData;
}

/// @nodoc
class _$CourseDetailStateCopyWithImpl<$Res, $Val extends CourseDetailState>
    implements $CourseDetailStateCopyWith<$Res> {
  _$CourseDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courseInfo = freezed,
    Object? classList = null,
    Object? recentlyData = freezed,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      courseInfo: freezed == courseInfo
          ? _value.courseInfo
          : courseInfo // ignore: cast_nullable_to_non_nullable
              as CourseDetailModel?,
      classList: null == classList
          ? _value.classList
          : classList // ignore: cast_nullable_to_non_nullable
              as List<CourseClassModel>,
      recentlyData: freezed == recentlyData
          ? _value.recentlyData
          : recentlyData // ignore: cast_nullable_to_non_nullable
              as RecentlyDataModel?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CourseDetailModelCopyWith<$Res>? get courseInfo {
    if (_value.courseInfo == null) {
      return null;
    }

    return $CourseDetailModelCopyWith<$Res>(_value.courseInfo!, (value) {
      return _then(_value.copyWith(courseInfo: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $RecentlyDataModelCopyWith<$Res>? get recentlyData {
    if (_value.recentlyData == null) {
      return null;
    }

    return $RecentlyDataModelCopyWith<$Res>(_value.recentlyData!, (value) {
      return _then(_value.copyWith(recentlyData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CourseDetailStateImplCopyWith<$Res>
    implements $CourseDetailStateCopyWith<$Res> {
  factory _$$CourseDetailStateImplCopyWith(_$CourseDetailStateImpl value,
          $Res Function(_$CourseDetailStateImpl) then) =
      __$$CourseDetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {CourseDetailModel? courseInfo,
      List<CourseClassModel> classList,
      RecentlyDataModel? recentlyData,
      bool isLoading,
      String? error});

  @override
  $CourseDetailModelCopyWith<$Res>? get courseInfo;
  @override
  $RecentlyDataModelCopyWith<$Res>? get recentlyData;
}

/// @nodoc
class __$$CourseDetailStateImplCopyWithImpl<$Res>
    extends _$CourseDetailStateCopyWithImpl<$Res, _$CourseDetailStateImpl>
    implements _$$CourseDetailStateImplCopyWith<$Res> {
  __$$CourseDetailStateImplCopyWithImpl(_$CourseDetailStateImpl _value,
      $Res Function(_$CourseDetailStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courseInfo = freezed,
    Object? classList = null,
    Object? recentlyData = freezed,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$CourseDetailStateImpl(
      courseInfo: freezed == courseInfo
          ? _value.courseInfo
          : courseInfo // ignore: cast_nullable_to_non_nullable
              as CourseDetailModel?,
      classList: null == classList
          ? _value._classList
          : classList // ignore: cast_nullable_to_non_nullable
              as List<CourseClassModel>,
      recentlyData: freezed == recentlyData
          ? _value.recentlyData
          : recentlyData // ignore: cast_nullable_to_non_nullable
              as RecentlyDataModel?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CourseDetailStateImpl implements _CourseDetailState {
  const _$CourseDetailStateImpl(
      {this.courseInfo,
      final List<CourseClassModel> classList = const [],
      this.recentlyData,
      this.isLoading = true,
      this.error})
      : _classList = classList;

  @override
  final CourseDetailModel? courseInfo;
  final List<CourseClassModel> _classList;
  @override
  @JsonKey()
  List<CourseClassModel> get classList {
    if (_classList is EqualUnmodifiableListView) return _classList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_classList);
  }

  @override
  final RecentlyDataModel? recentlyData;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'CourseDetailState(courseInfo: $courseInfo, classList: $classList, recentlyData: $recentlyData, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseDetailStateImpl &&
            (identical(other.courseInfo, courseInfo) ||
                other.courseInfo == courseInfo) &&
            const DeepCollectionEquality()
                .equals(other._classList, _classList) &&
            (identical(other.recentlyData, recentlyData) ||
                other.recentlyData == recentlyData) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      courseInfo,
      const DeepCollectionEquality().hash(_classList),
      recentlyData,
      isLoading,
      error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseDetailStateImplCopyWith<_$CourseDetailStateImpl> get copyWith =>
      __$$CourseDetailStateImplCopyWithImpl<_$CourseDetailStateImpl>(
          this, _$identity);
}

abstract class _CourseDetailState implements CourseDetailState {
  const factory _CourseDetailState(
      {final CourseDetailModel? courseInfo,
      final List<CourseClassModel> classList,
      final RecentlyDataModel? recentlyData,
      final bool isLoading,
      final String? error}) = _$CourseDetailStateImpl;

  @override
  CourseDetailModel? get courseInfo;
  @override
  List<CourseClassModel> get classList;
  @override
  RecentlyDataModel? get recentlyData;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$CourseDetailStateImplCopyWith<_$CourseDetailStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
