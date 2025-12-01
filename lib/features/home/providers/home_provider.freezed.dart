// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeState {
  List<GoodsModel> get recommendList => throw _privateConstructorUsedError;
  List<GoodsModel> get questionBankList => throw _privateConstructorUsedError;
  List<GoodsModel> get onlineCourseList => throw _privateConstructorUsedError;
  List<GoodsModel> get liveList => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call(
      {List<GoodsModel> recommendList,
      List<GoodsModel> questionBankList,
      List<GoodsModel> onlineCourseList,
      List<GoodsModel> liveList,
      bool isLoading,
      String? error});
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recommendList = null,
    Object? questionBankList = null,
    Object? onlineCourseList = null,
    Object? liveList = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      recommendList: null == recommendList
          ? _value.recommendList
          : recommendList // ignore: cast_nullable_to_non_nullable
              as List<GoodsModel>,
      questionBankList: null == questionBankList
          ? _value.questionBankList
          : questionBankList // ignore: cast_nullable_to_non_nullable
              as List<GoodsModel>,
      onlineCourseList: null == onlineCourseList
          ? _value.onlineCourseList
          : onlineCourseList // ignore: cast_nullable_to_non_nullable
              as List<GoodsModel>,
      liveList: null == liveList
          ? _value.liveList
          : liveList // ignore: cast_nullable_to_non_nullable
              as List<GoodsModel>,
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
}

/// @nodoc
abstract class _$$HomeStateImplCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$$HomeStateImplCopyWith(
          _$HomeStateImpl value, $Res Function(_$HomeStateImpl) then) =
      __$$HomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<GoodsModel> recommendList,
      List<GoodsModel> questionBankList,
      List<GoodsModel> onlineCourseList,
      List<GoodsModel> liveList,
      bool isLoading,
      String? error});
}

/// @nodoc
class __$$HomeStateImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateImpl>
    implements _$$HomeStateImplCopyWith<$Res> {
  __$$HomeStateImplCopyWithImpl(
      _$HomeStateImpl _value, $Res Function(_$HomeStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recommendList = null,
    Object? questionBankList = null,
    Object? onlineCourseList = null,
    Object? liveList = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$HomeStateImpl(
      recommendList: null == recommendList
          ? _value._recommendList
          : recommendList // ignore: cast_nullable_to_non_nullable
              as List<GoodsModel>,
      questionBankList: null == questionBankList
          ? _value._questionBankList
          : questionBankList // ignore: cast_nullable_to_non_nullable
              as List<GoodsModel>,
      onlineCourseList: null == onlineCourseList
          ? _value._onlineCourseList
          : onlineCourseList // ignore: cast_nullable_to_non_nullable
              as List<GoodsModel>,
      liveList: null == liveList
          ? _value._liveList
          : liveList // ignore: cast_nullable_to_non_nullable
              as List<GoodsModel>,
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

class _$HomeStateImpl implements _HomeState {
  const _$HomeStateImpl(
      {final List<GoodsModel> recommendList = const [],
      final List<GoodsModel> questionBankList = const [],
      final List<GoodsModel> onlineCourseList = const [],
      final List<GoodsModel> liveList = const [],
      this.isLoading = false,
      this.error})
      : _recommendList = recommendList,
        _questionBankList = questionBankList,
        _onlineCourseList = onlineCourseList,
        _liveList = liveList;

  final List<GoodsModel> _recommendList;
  @override
  @JsonKey()
  List<GoodsModel> get recommendList {
    if (_recommendList is EqualUnmodifiableListView) return _recommendList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendList);
  }

  final List<GoodsModel> _questionBankList;
  @override
  @JsonKey()
  List<GoodsModel> get questionBankList {
    if (_questionBankList is EqualUnmodifiableListView)
      return _questionBankList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questionBankList);
  }

  final List<GoodsModel> _onlineCourseList;
  @override
  @JsonKey()
  List<GoodsModel> get onlineCourseList {
    if (_onlineCourseList is EqualUnmodifiableListView)
      return _onlineCourseList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_onlineCourseList);
  }

  final List<GoodsModel> _liveList;
  @override
  @JsonKey()
  List<GoodsModel> get liveList {
    if (_liveList is EqualUnmodifiableListView) return _liveList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_liveList);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'HomeState(recommendList: $recommendList, questionBankList: $questionBankList, onlineCourseList: $onlineCourseList, liveList: $liveList, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateImpl &&
            const DeepCollectionEquality()
                .equals(other._recommendList, _recommendList) &&
            const DeepCollectionEquality()
                .equals(other._questionBankList, _questionBankList) &&
            const DeepCollectionEquality()
                .equals(other._onlineCourseList, _onlineCourseList) &&
            const DeepCollectionEquality().equals(other._liveList, _liveList) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_recommendList),
      const DeepCollectionEquality().hash(_questionBankList),
      const DeepCollectionEquality().hash(_onlineCourseList),
      const DeepCollectionEquality().hash(_liveList),
      isLoading,
      error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);
}

abstract class _HomeState implements HomeState {
  const factory _HomeState(
      {final List<GoodsModel> recommendList,
      final List<GoodsModel> questionBankList,
      final List<GoodsModel> onlineCourseList,
      final List<GoodsModel> liveList,
      final bool isLoading,
      final String? error}) = _$HomeStateImpl;

  @override
  List<GoodsModel> get recommendList;
  @override
  List<GoodsModel> get questionBankList;
  @override
  List<GoodsModel> get onlineCourseList;
  @override
  List<GoodsModel> get liveList;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
