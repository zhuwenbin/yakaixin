// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_course_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MyCourseState {
  List<Map<String, dynamic>> get courseList =>
      throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isLoadingMore => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  String get teachingType =>
      throw _privateConstructorUsedError; // 3=录播课, 1=直播课（对应小程序 teachingTypeTab.vue）
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MyCourseStateCopyWith<MyCourseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyCourseStateCopyWith<$Res> {
  factory $MyCourseStateCopyWith(
          MyCourseState value, $Res Function(MyCourseState) then) =
      _$MyCourseStateCopyWithImpl<$Res, MyCourseState>;
  @useResult
  $Res call(
      {List<Map<String, dynamic>> courseList,
      bool isLoading,
      bool isLoadingMore,
      int currentPage,
      int total,
      String teachingType,
      String? error});
}

/// @nodoc
class _$MyCourseStateCopyWithImpl<$Res, $Val extends MyCourseState>
    implements $MyCourseStateCopyWith<$Res> {
  _$MyCourseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courseList = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? currentPage = null,
    Object? total = null,
    Object? teachingType = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      courseList: null == courseList
          ? _value.courseList
          : courseList // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      teachingType: null == teachingType
          ? _value.teachingType
          : teachingType // ignore: cast_nullable_to_non_nullable
              as String,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MyCourseStateImplCopyWith<$Res>
    implements $MyCourseStateCopyWith<$Res> {
  factory _$$MyCourseStateImplCopyWith(
          _$MyCourseStateImpl value, $Res Function(_$MyCourseStateImpl) then) =
      __$$MyCourseStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Map<String, dynamic>> courseList,
      bool isLoading,
      bool isLoadingMore,
      int currentPage,
      int total,
      String teachingType,
      String? error});
}

/// @nodoc
class __$$MyCourseStateImplCopyWithImpl<$Res>
    extends _$MyCourseStateCopyWithImpl<$Res, _$MyCourseStateImpl>
    implements _$$MyCourseStateImplCopyWith<$Res> {
  __$$MyCourseStateImplCopyWithImpl(
      _$MyCourseStateImpl _value, $Res Function(_$MyCourseStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courseList = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? currentPage = null,
    Object? total = null,
    Object? teachingType = null,
    Object? error = freezed,
  }) {
    return _then(_$MyCourseStateImpl(
      courseList: null == courseList
          ? _value._courseList
          : courseList // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      teachingType: null == teachingType
          ? _value.teachingType
          : teachingType // ignore: cast_nullable_to_non_nullable
              as String,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$MyCourseStateImpl implements _MyCourseState {
  const _$MyCourseStateImpl(
      {final List<Map<String, dynamic>> courseList = const [],
      this.isLoading = false,
      this.isLoadingMore = false,
      this.currentPage = 1,
      this.total = 0,
      this.teachingType = '3',
      this.error})
      : _courseList = courseList;

  final List<Map<String, dynamic>> _courseList;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get courseList {
    if (_courseList is EqualUnmodifiableListView) return _courseList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_courseList);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isLoadingMore;
  @override
  @JsonKey()
  final int currentPage;
  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final String teachingType;
// 3=录播课, 1=直播课（对应小程序 teachingTypeTab.vue）
  @override
  final String? error;

  @override
  String toString() {
    return 'MyCourseState(courseList: $courseList, isLoading: $isLoading, isLoadingMore: $isLoadingMore, currentPage: $currentPage, total: $total, teachingType: $teachingType, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MyCourseStateImpl &&
            const DeepCollectionEquality()
                .equals(other._courseList, _courseList) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.teachingType, teachingType) ||
                other.teachingType == teachingType) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_courseList),
      isLoading,
      isLoadingMore,
      currentPage,
      total,
      teachingType,
      error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MyCourseStateImplCopyWith<_$MyCourseStateImpl> get copyWith =>
      __$$MyCourseStateImplCopyWithImpl<_$MyCourseStateImpl>(this, _$identity);
}

abstract class _MyCourseState implements MyCourseState {
  const factory _MyCourseState(
      {final List<Map<String, dynamic>> courseList,
      final bool isLoading,
      final bool isLoadingMore,
      final int currentPage,
      final int total,
      final String teachingType,
      final String? error}) = _$MyCourseStateImpl;

  @override
  List<Map<String, dynamic>> get courseList;
  @override
  bool get isLoading;
  @override
  bool get isLoadingMore;
  @override
  int get currentPage;
  @override
  int get total;
  @override
  String get teachingType;
  @override // 3=录播课, 1=直播课（对应小程序 teachingTypeTab.vue）
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$MyCourseStateImplCopyWith<_$MyCourseStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
