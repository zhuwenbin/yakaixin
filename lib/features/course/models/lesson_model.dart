import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson_model.freezed.dart';
part 'lesson_model.g.dart';

/// 课节数据模型
/// 对应小程序 lessonsList.vue 使用的 item 字段
@freezed
class LessonModel with _$LessonModel {
  const factory LessonModel({
    @JsonKey(name: 'lesson_id') String? lessonId,
    @JsonKey(name: 'lesson_num') String? lessonNum,
    @JsonKey(name: 'lesson_name') String? lessonName,
    @JsonKey(name: 'start_time') String? startTime,
    @JsonKey(name: 'teaching_type') dynamic teachingType, // 授课类型: 1-直播, 2-面授, 3-录播
    @JsonKey(name: 'teaching_type_name') String? teachingTypeName,
    @JsonKey(name: 'resource_document') @Default([]) List<dynamic> resourceDocument,
    @JsonKey(name: 'evaluation_type') @Default([]) List<Map<String, dynamic>> evaluationType,
    // 课前测/课后测跳转 answertest/answer 所需（与小程序 goAnswer 参数一致）
    @JsonKey(name: 'order_id') dynamic orderId,
    @JsonKey(name: 'system_id') dynamic systemId,
    @JsonKey(name: 'order_goods_detail_id') dynamic orderGoodsDetailId,
    @JsonKey(name: 'paper_goods_id') dynamic paperGoodsId,
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
