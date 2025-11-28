import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson_model.freezed.dart';
part 'lesson_model.g.dart';

/// 课节数据模型
@freezed
class LessonModel with _$LessonModel {
  const factory LessonModel({
    @JsonKey(name: 'lesson_id') String? lessonId,
    @JsonKey(name: 'lesson_num') String? lessonNum,
    @JsonKey(name: 'lesson_name') String? lessonName,
    @JsonKey(name: 'start_time') String? startTime,
    @JsonKey(name: 'teaching_type_name') String? teachingTypeName,
    @JsonKey(name: 'resource_document') @Default([]) List<dynamic> resourceDocument,
    @JsonKey(name: 'evaluation_type') @Default([]) List<Map<String, dynamic>> evaluationType,
  }) = _LessonModel;

  factory LessonModel.fromJson(Map<String, dynamic> json) =>
      _$LessonModelFromJson(json);
}

/// 今日课节数据
@freezed
class LessonsData with _$LessonsData {
  const factory LessonsData({
    @JsonKey(name: 'lesson_num') String? lessonNum,
    @JsonKey(name: 'lesson_attendance_num') String? lessonAttendanceNum,
    @JsonKey(name: 'lesson_attendance') @Default([]) List<LessonModel> lessonAttendance,
  }) = _LessonsData;

  factory LessonsData.fromJson(Map<String, dynamic> json) =>
      _$LessonsDataFromJson(json);
}
