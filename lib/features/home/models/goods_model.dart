import 'package:freezed_annotation/freezed_annotation.dart';

part 'goods_model.freezed.dart';
part 'goods_model.g.dart';

/// 商品模型
/// 对应小程序: 题库、课程、直播等商品
/// ✅ 符合数据安全规则: 使用 Freezed 生成不可变 Model,所有可选字段使用可空类型
/// ✅ 使用 dynamic 处理可能为 String 或 int 的字段,避免类型转换错误
@freezed
class GoodsModel with _$GoodsModel {
  const factory GoodsModel({
    @JsonKey(name: 'id') dynamic goodsId, // API可能返回String或int,使用dynamic避免溢出
    @JsonKey(name: 'name') String? goodsName, // API返回字段是name
    @JsonKey(name: 'material_cover_path') String? coverImg,
    @JsonKey(name: 'type') dynamic type, // 可能是String或int
    @JsonKey(name: 'type_name') String? typeName,
    @JsonKey(name: 'details_type') String? detailsType,
    @JsonKey(name: 'sale_price') dynamic price, // 可能是String或num
    @JsonKey(name: 'original_price') dynamic originalPrice, // 可能是String或num
    @JsonKey(name: 'permission_status') String? permissionStatus, // 权限状态 1:未购买 2:已购买
    @JsonKey(name: 'is_homepage_recommend') dynamic isHomepageRecommend, // 可能是String或int
    @JsonKey(name: 'teaching_type') dynamic teachingType, // 可能是String或int
    @JsonKey(name: 'teaching_type_name') String? teachingTypeName,
    @JsonKey(name: 'business_type') dynamic businessType, // 可能是String或int
    @JsonKey(name: 'is_recommend') dynamic isRecommend, // 可能是String或int
    @JsonKey(name: 'teacher_data') List<TeacherModel>? teacherData,
    @JsonKey(name: 'question_number') String? questionNumber, // 题目数量
    @JsonKey(name: 'total_class_hour') String? totalClassHour, // 总课时
    @JsonKey(name: 'validity_type') String? validityType, // 有效期类型
    @JsonKey(name: 'validity_day') String? validityDay, // 有效天数
  }) = _GoodsModel;

  factory GoodsModel.fromJson(Map<String, dynamic> json) => _$GoodsModelFromJson(json);
}

/// 教师模型
@freezed
class TeacherModel with _$TeacherModel {
  const factory TeacherModel({
    @JsonKey(name: 'teacher_id') String? teacherId,
    @JsonKey(name: 'teacher_name') String? teacherName,
    @JsonKey(name: 'avatar') String? avatar,
    @JsonKey(name: 'introduction') String? introduction,
  }) = _TeacherModel;

  factory TeacherModel.fromJson(Map<String, dynamic> json) => _$TeacherModelFromJson(json);
}

/// 商品列表响应
@freezed
class GoodsListResponse with _$GoodsListResponse {
  const factory GoodsListResponse({
    @JsonKey(name: 'list') required List<GoodsModel> list,
    @JsonKey(name: 'total') int? total,
  }) = _GoodsListResponse;

  factory GoodsListResponse.fromJson(Map<String, dynamic> json) => _$GoodsListResponseFromJson(json);
}
