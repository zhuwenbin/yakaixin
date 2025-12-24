// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VideoState {
// 视频信息
  String get lessonName => throw _privateConstructorUsedError;
  String get videoUrl => throw _privateConstructorUsedError;
  String get currentLessonId => throw _privateConstructorUsedError; // 讲义内容
  String get handoutContent => throw _privateConstructorUsedError; // 章节数据
  List<Map<String, dynamic>> get chapterData =>
      throw _privateConstructorUsedError; // 播放进度
  double get currentTime => throw _privateConstructorUsedError;
  double get savedTime => throw _privateConstructorUsedError; // 签到状态
  bool get hasSignedIn => throw _privateConstructorUsedError; // UI状态
  int get tabIndex => throw _privateConstructorUsedError; // 1=目录, 2=讲义
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $VideoStateCopyWith<VideoState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoStateCopyWith<$Res> {
  factory $VideoStateCopyWith(
          VideoState value, $Res Function(VideoState) then) =
      _$VideoStateCopyWithImpl<$Res, VideoState>;
  @useResult
  $Res call(
      {String lessonName,
      String videoUrl,
      String currentLessonId,
      String handoutContent,
      List<Map<String, dynamic>> chapterData,
      double currentTime,
      double savedTime,
      bool hasSignedIn,
      int tabIndex,
      bool isLoading,
      String? error});
}

/// @nodoc
class _$VideoStateCopyWithImpl<$Res, $Val extends VideoState>
    implements $VideoStateCopyWith<$Res> {
  _$VideoStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lessonName = null,
    Object? videoUrl = null,
    Object? currentLessonId = null,
    Object? handoutContent = null,
    Object? chapterData = null,
    Object? currentTime = null,
    Object? savedTime = null,
    Object? hasSignedIn = null,
    Object? tabIndex = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      lessonName: null == lessonName
          ? _value.lessonName
          : lessonName // ignore: cast_nullable_to_non_nullable
              as String,
      videoUrl: null == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      currentLessonId: null == currentLessonId
          ? _value.currentLessonId
          : currentLessonId // ignore: cast_nullable_to_non_nullable
              as String,
      handoutContent: null == handoutContent
          ? _value.handoutContent
          : handoutContent // ignore: cast_nullable_to_non_nullable
              as String,
      chapterData: null == chapterData
          ? _value.chapterData
          : chapterData // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      currentTime: null == currentTime
          ? _value.currentTime
          : currentTime // ignore: cast_nullable_to_non_nullable
              as double,
      savedTime: null == savedTime
          ? _value.savedTime
          : savedTime // ignore: cast_nullable_to_non_nullable
              as double,
      hasSignedIn: null == hasSignedIn
          ? _value.hasSignedIn
          : hasSignedIn // ignore: cast_nullable_to_non_nullable
              as bool,
      tabIndex: null == tabIndex
          ? _value.tabIndex
          : tabIndex // ignore: cast_nullable_to_non_nullable
              as int,
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
abstract class _$$VideoStateImplCopyWith<$Res>
    implements $VideoStateCopyWith<$Res> {
  factory _$$VideoStateImplCopyWith(
          _$VideoStateImpl value, $Res Function(_$VideoStateImpl) then) =
      __$$VideoStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String lessonName,
      String videoUrl,
      String currentLessonId,
      String handoutContent,
      List<Map<String, dynamic>> chapterData,
      double currentTime,
      double savedTime,
      bool hasSignedIn,
      int tabIndex,
      bool isLoading,
      String? error});
}

/// @nodoc
class __$$VideoStateImplCopyWithImpl<$Res>
    extends _$VideoStateCopyWithImpl<$Res, _$VideoStateImpl>
    implements _$$VideoStateImplCopyWith<$Res> {
  __$$VideoStateImplCopyWithImpl(
      _$VideoStateImpl _value, $Res Function(_$VideoStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lessonName = null,
    Object? videoUrl = null,
    Object? currentLessonId = null,
    Object? handoutContent = null,
    Object? chapterData = null,
    Object? currentTime = null,
    Object? savedTime = null,
    Object? hasSignedIn = null,
    Object? tabIndex = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$VideoStateImpl(
      lessonName: null == lessonName
          ? _value.lessonName
          : lessonName // ignore: cast_nullable_to_non_nullable
              as String,
      videoUrl: null == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      currentLessonId: null == currentLessonId
          ? _value.currentLessonId
          : currentLessonId // ignore: cast_nullable_to_non_nullable
              as String,
      handoutContent: null == handoutContent
          ? _value.handoutContent
          : handoutContent // ignore: cast_nullable_to_non_nullable
              as String,
      chapterData: null == chapterData
          ? _value._chapterData
          : chapterData // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      currentTime: null == currentTime
          ? _value.currentTime
          : currentTime // ignore: cast_nullable_to_non_nullable
              as double,
      savedTime: null == savedTime
          ? _value.savedTime
          : savedTime // ignore: cast_nullable_to_non_nullable
              as double,
      hasSignedIn: null == hasSignedIn
          ? _value.hasSignedIn
          : hasSignedIn // ignore: cast_nullable_to_non_nullable
              as bool,
      tabIndex: null == tabIndex
          ? _value.tabIndex
          : tabIndex // ignore: cast_nullable_to_non_nullable
              as int,
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

class _$VideoStateImpl implements _VideoState {
  const _$VideoStateImpl(
      {this.lessonName = '',
      this.videoUrl = '',
      this.currentLessonId = '',
      this.handoutContent = '',
      final List<Map<String, dynamic>> chapterData = const [],
      this.currentTime = 0,
      this.savedTime = 0,
      this.hasSignedIn = false,
      this.tabIndex = 1,
      this.isLoading = false,
      this.error})
      : _chapterData = chapterData;

// 视频信息
  @override
  @JsonKey()
  final String lessonName;
  @override
  @JsonKey()
  final String videoUrl;
  @override
  @JsonKey()
  final String currentLessonId;
// 讲义内容
  @override
  @JsonKey()
  final String handoutContent;
// 章节数据
  final List<Map<String, dynamic>> _chapterData;
// 章节数据
  @override
  @JsonKey()
  List<Map<String, dynamic>> get chapterData {
    if (_chapterData is EqualUnmodifiableListView) return _chapterData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_chapterData);
  }

// 播放进度
  @override
  @JsonKey()
  final double currentTime;
  @override
  @JsonKey()
  final double savedTime;
// 签到状态
  @override
  @JsonKey()
  final bool hasSignedIn;
// UI状态
  @override
  @JsonKey()
  final int tabIndex;
// 1=目录, 2=讲义
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'VideoState(lessonName: $lessonName, videoUrl: $videoUrl, currentLessonId: $currentLessonId, handoutContent: $handoutContent, chapterData: $chapterData, currentTime: $currentTime, savedTime: $savedTime, hasSignedIn: $hasSignedIn, tabIndex: $tabIndex, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoStateImpl &&
            (identical(other.lessonName, lessonName) ||
                other.lessonName == lessonName) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.currentLessonId, currentLessonId) ||
                other.currentLessonId == currentLessonId) &&
            (identical(other.handoutContent, handoutContent) ||
                other.handoutContent == handoutContent) &&
            const DeepCollectionEquality()
                .equals(other._chapterData, _chapterData) &&
            (identical(other.currentTime, currentTime) ||
                other.currentTime == currentTime) &&
            (identical(other.savedTime, savedTime) ||
                other.savedTime == savedTime) &&
            (identical(other.hasSignedIn, hasSignedIn) ||
                other.hasSignedIn == hasSignedIn) &&
            (identical(other.tabIndex, tabIndex) ||
                other.tabIndex == tabIndex) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      lessonName,
      videoUrl,
      currentLessonId,
      handoutContent,
      const DeepCollectionEquality().hash(_chapterData),
      currentTime,
      savedTime,
      hasSignedIn,
      tabIndex,
      isLoading,
      error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoStateImplCopyWith<_$VideoStateImpl> get copyWith =>
      __$$VideoStateImplCopyWithImpl<_$VideoStateImpl>(this, _$identity);
}

abstract class _VideoState implements VideoState {
  const factory _VideoState(
      {final String lessonName,
      final String videoUrl,
      final String currentLessonId,
      final String handoutContent,
      final List<Map<String, dynamic>> chapterData,
      final double currentTime,
      final double savedTime,
      final bool hasSignedIn,
      final int tabIndex,
      final bool isLoading,
      final String? error}) = _$VideoStateImpl;

  @override // 视频信息
  String get lessonName;
  @override
  String get videoUrl;
  @override
  String get currentLessonId;
  @override // 讲义内容
  String get handoutContent;
  @override // 章节数据
  List<Map<String, dynamic>> get chapterData;
  @override // 播放进度
  double get currentTime;
  @override
  double get savedTime;
  @override // 签到状态
  bool get hasSignedIn;
  @override // UI状态
  int get tabIndex;
  @override // 1=目录, 2=讲义
  bool get isLoading;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$VideoStateImplCopyWith<_$VideoStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
