import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_state.freezed.dart';

/// 视频播放状态
@freezed
class VideoState with _$VideoState {
  const factory VideoState({
    // 视频信息
    @Default('') String lessonName,
    @Default('') String videoUrl,
    @Default('') String currentLessonId,
    
    // 讲义内容
    @Default('') String handoutContent,
    
    // 章节数据
    @Default([]) List<Map<String, dynamic>> chapterData,
    
    // 播放进度
    @Default(0) double currentTime,
    @Default(0) double savedTime,
    
    // 签到状态
    @Default(false) bool hasSignedIn,
    
    // UI状态
    @Default(1) int tabIndex, // 1=目录, 2=讲义
    @Default(false) bool isLoading,
    String? error,
  }) = _VideoState;
}
