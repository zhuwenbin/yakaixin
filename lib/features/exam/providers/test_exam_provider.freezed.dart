// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_exam_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TestExamState {
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  GoodsModel? get goodsInfo => throw _privateConstructorUsedError;
  List<PaperModel> get paperList =>
      throw _privateConstructorUsedError; // 普通试卷列表 (data_type == '1')
  List<ChapterPaperModel> get chapterPaperList =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TestExamStateCopyWith<TestExamState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestExamStateCopyWith<$Res> {
  factory $TestExamStateCopyWith(
          TestExamState value, $Res Function(TestExamState) then) =
      _$TestExamStateCopyWithImpl<$Res, TestExamState>;
  @useResult
  $Res call(
      {bool isLoading,
      String? error,
      GoodsModel? goodsInfo,
      List<PaperModel> paperList,
      List<ChapterPaperModel> chapterPaperList});

  $GoodsModelCopyWith<$Res>? get goodsInfo;
}

/// @nodoc
class _$TestExamStateCopyWithImpl<$Res, $Val extends TestExamState>
    implements $TestExamStateCopyWith<$Res> {
  _$TestExamStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? error = freezed,
    Object? goodsInfo = freezed,
    Object? paperList = null,
    Object? chapterPaperList = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      goodsInfo: freezed == goodsInfo
          ? _value.goodsInfo
          : goodsInfo // ignore: cast_nullable_to_non_nullable
              as GoodsModel?,
      paperList: null == paperList
          ? _value.paperList
          : paperList // ignore: cast_nullable_to_non_nullable
              as List<PaperModel>,
      chapterPaperList: null == chapterPaperList
          ? _value.chapterPaperList
          : chapterPaperList // ignore: cast_nullable_to_non_nullable
              as List<ChapterPaperModel>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $GoodsModelCopyWith<$Res>? get goodsInfo {
    if (_value.goodsInfo == null) {
      return null;
    }

    return $GoodsModelCopyWith<$Res>(_value.goodsInfo!, (value) {
      return _then(_value.copyWith(goodsInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TestExamStateImplCopyWith<$Res>
    implements $TestExamStateCopyWith<$Res> {
  factory _$$TestExamStateImplCopyWith(
          _$TestExamStateImpl value, $Res Function(_$TestExamStateImpl) then) =
      __$$TestExamStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      String? error,
      GoodsModel? goodsInfo,
      List<PaperModel> paperList,
      List<ChapterPaperModel> chapterPaperList});

  @override
  $GoodsModelCopyWith<$Res>? get goodsInfo;
}

/// @nodoc
class __$$TestExamStateImplCopyWithImpl<$Res>
    extends _$TestExamStateCopyWithImpl<$Res, _$TestExamStateImpl>
    implements _$$TestExamStateImplCopyWith<$Res> {
  __$$TestExamStateImplCopyWithImpl(
      _$TestExamStateImpl _value, $Res Function(_$TestExamStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? error = freezed,
    Object? goodsInfo = freezed,
    Object? paperList = null,
    Object? chapterPaperList = null,
  }) {
    return _then(_$TestExamStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      goodsInfo: freezed == goodsInfo
          ? _value.goodsInfo
          : goodsInfo // ignore: cast_nullable_to_non_nullable
              as GoodsModel?,
      paperList: null == paperList
          ? _value._paperList
          : paperList // ignore: cast_nullable_to_non_nullable
              as List<PaperModel>,
      chapterPaperList: null == chapterPaperList
          ? _value._chapterPaperList
          : chapterPaperList // ignore: cast_nullable_to_non_nullable
              as List<ChapterPaperModel>,
    ));
  }
}

/// @nodoc

class _$TestExamStateImpl implements _TestExamState {
  const _$TestExamStateImpl(
      {this.isLoading = false,
      this.error,
      this.goodsInfo,
      final List<PaperModel> paperList = const [],
      final List<ChapterPaperModel> chapterPaperList = const []})
      : _paperList = paperList,
        _chapterPaperList = chapterPaperList;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
  @override
  final GoodsModel? goodsInfo;
  final List<PaperModel> _paperList;
  @override
  @JsonKey()
  List<PaperModel> get paperList {
    if (_paperList is EqualUnmodifiableListView) return _paperList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_paperList);
  }

// 普通试卷列表 (data_type == '1')
  final List<ChapterPaperModel> _chapterPaperList;
// 普通试卷列表 (data_type == '1')
  @override
  @JsonKey()
  List<ChapterPaperModel> get chapterPaperList {
    if (_chapterPaperList is EqualUnmodifiableListView)
      return _chapterPaperList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_chapterPaperList);
  }

  @override
  String toString() {
    return 'TestExamState(isLoading: $isLoading, error: $error, goodsInfo: $goodsInfo, paperList: $paperList, chapterPaperList: $chapterPaperList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestExamStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.goodsInfo, goodsInfo) ||
                other.goodsInfo == goodsInfo) &&
            const DeepCollectionEquality()
                .equals(other._paperList, _paperList) &&
            const DeepCollectionEquality()
                .equals(other._chapterPaperList, _chapterPaperList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      error,
      goodsInfo,
      const DeepCollectionEquality().hash(_paperList),
      const DeepCollectionEquality().hash(_chapterPaperList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TestExamStateImplCopyWith<_$TestExamStateImpl> get copyWith =>
      __$$TestExamStateImplCopyWithImpl<_$TestExamStateImpl>(this, _$identity);
}

abstract class _TestExamState implements TestExamState {
  const factory _TestExamState(
      {final bool isLoading,
      final String? error,
      final GoodsModel? goodsInfo,
      final List<PaperModel> paperList,
      final List<ChapterPaperModel> chapterPaperList}) = _$TestExamStateImpl;

  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  GoodsModel? get goodsInfo;
  @override
  List<PaperModel> get paperList;
  @override // 普通试卷列表 (data_type == '1')
  List<ChapterPaperModel> get chapterPaperList;
  @override
  @JsonKey(ignore: true)
  _$$TestExamStateImplCopyWith<_$TestExamStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
