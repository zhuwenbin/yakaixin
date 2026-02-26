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
/// 与小程序 study/detail learnCourseList 项一致：接口 /c/study/learning/series/goods 返回 id（套餐商品 id）、class_id、lesson 等
@freezed
class CourseClassModel with _$CourseClassModel {
  const factory CourseClassModel({
    /// 套餐商品 id，与 getGoodsDetail 的 detail_package_goods[].id 一致，小程序用作 filter_goods_id 拉目录
    String? id,
    @JsonKey(name: 'class_id') String? classId,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'teaching_type') String? teachingType,
    @JsonKey(name: 'teaching_type_name') String? teachingTypeName,
    @JsonKey(name: 'lesson_num') dynamic lessonNum,
    @JsonKey(name: 'lesson_attendance_num') dynamic lessonAttendanceNum,
    @JsonKey(name: 'address') String? address,
    @JsonKey(name: 'lesson') List<Map<String, dynamic>>? lessons,
    // ✅ UI状态字段（不从JSON解析），默认 true=收起（课程详情页小节默认不展开）
    @Default(true)
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
