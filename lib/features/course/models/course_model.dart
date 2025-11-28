import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_model.freezed.dart';
part 'course_model.g.dart';

/// 课程数据模型
@freezed
class CourseModel with _$CourseModel {
  const factory CourseModel({
    @JsonKey(name: 'goods_id') String? goodsId,
    @JsonKey(name: 'goods_name') String? goodsName,
    @JsonKey(name: 'goods_pid') String? goodsPid,
    @JsonKey(name: 'goods_pid_name') String? goodsPidName,
    @JsonKey(name: 'order_id') String? orderId,
    @JsonKey(name: 'teaching_type_name') String? teachingTypeName,
    @JsonKey(name: 'class') Map<String, dynamic>? classInfo,
  }) = _CourseModel;

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);
}
