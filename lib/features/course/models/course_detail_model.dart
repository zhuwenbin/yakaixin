import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_detail_model.freezed.dart';
part 'course_detail_model.g.dart';

/// 课程详情模型
@freezed
class CourseDetailModel with _$CourseDetailModel {
  const factory CourseDetailModel({
    @JsonKey(name: 'goods_id') String? goodsId,
    @JsonKey(name: 'goods_name') String? goodsName,
    @JsonKey(name: 'business_type') dynamic businessType, // 1:普通 2:高端 3:私塾
    @JsonKey(name: 'class') Map<String, dynamic>? classInfo,
  }) = _CourseDetailModel;

  factory CourseDetailModel.fromJson(Map<String, dynamic> json) =>
      _$CourseDetailModelFromJson(json);
}

/// 班级课节模型
@freezed
class CourseClassModel with _$CourseClassModel {
  const factory CourseClassModel({
    @JsonKey(name: 'class_id') String? classId,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'teaching_type') String? teachingType,
    @JsonKey(name: 'teaching_type_name') String? teachingTypeName,
    @JsonKey(name: 'lesson_num') dynamic lessonNum,
    @JsonKey(name: 'lesson_attendance_num') dynamic lessonAttendanceNum,
    @JsonKey(name: 'address') String? address,
    @JsonKey(name: 'lesson') List<Map<String, dynamic>>? lessons,
    // ✅ UI状态字段（不从JSON解析）
    @Default(false)
    @JsonKey(includeFromJson: false, includeToJson: false)
    bool isClose,
  }) = _CourseClassModel;

  factory CourseClassModel.fromJson(Map<String, dynamic> json) =>
      _$CourseClassModelFromJson(json);
}

/// 最近学习记录模型
@freezed
class RecentlyDataModel with _$RecentlyDataModel {
  const factory RecentlyDataModel({
    @JsonKey(name: 'lesson_id') String? lessonId,
    @JsonKey(name: 'lesson_name') String? lessonName,
  }) = _RecentlyDataModel;

  factory RecentlyDataModel.fromJson(Map<String, dynamic> json) =>
      _$RecentlyDataModelFromJson(json);
}
