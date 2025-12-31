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
    @JsonKey(name: 'name') String? name, // ✅ 商品名称
    @JsonKey(name: 'material_cover_path') String? materialCoverPath, // ✅ 封面路径
    @JsonKey(name: 'material_intro_path')
    String? materialIntroPath, // ✅ 详情介绍HTML路径
    @JsonKey(name: 'type') dynamic type, // 可能是String或int
    @JsonKey(name: 'type_name') String? typeName,
    @JsonKey(name: 'details_type')
    dynamic detailsType, // 可能是String或int: 1=经典 2=真题 3=科目 4=模拟
    @JsonKey(name: 'data_type')
    dynamic dataType, // 可能是String或int: 1=普通 2=模考 3=其他
    @JsonKey(name: 'sale_price') String? salePrice, // ✅ 销售价格
    @JsonKey(name: 'original_price') dynamic originalPrice, // 可能是String或num
    @JsonKey(name: 'permission_status')
    String? permissionStatus, // 权限状态 1:已购买 2:未购买
    @JsonKey(name: 'is_homepage_recommend')
    dynamic isHomepageRecommend, // 可能是String或int
    @JsonKey(name: 'seckill_countdown') dynamic seckillCountdown, // ✅ 秒杀倒计时(秒)
    @JsonKey(name: 'teaching_type') dynamic teachingType, // 可能是String或int
    @JsonKey(name: 'teaching_type_name') String? teachingTypeName,
    @JsonKey(name: 'business_type') dynamic businessType, // 可能是String或int
    @JsonKey(name: 'is_recommend') dynamic isRecommend, // 可能是String或int
    @JsonKey(name: 'teacher_data') List<TeacherModel>? teacherData,
    @JsonKey(name: 'question_number') String? questionNumber, // 题目数量
    @JsonKey(name: 'total_class_hour') String? totalClassHour, // 总课时
    @JsonKey(name: 'validity_type') String? validityType, // 有效期类型
    @JsonKey(name: 'validity_day') String? validityDay, // 有效天数
    @JsonKey(name: 'validity_start_date') String? validityStartDate, // 有效期开始日期
    @JsonKey(name: 'validity_start_date_val')
    String? validityStartDateVal, // ✅ 有效期开始日期值
    @JsonKey(name: 'validity_end_date') String? validityEndDate, // 有效期结束日期
    @JsonKey(name: 'validity_end_date_val')
    String? validityEndDateVal, // ✅ 有效期结束日期值
    @JsonKey(name: 'service_type_name') String? serviceTypeName, // 服务类型名称
    @JsonKey(name: 'new_type_name') String? newTypeName, // 新类型名称
    @JsonKey(name: 'student_num') dynamic studentNum, // 购买人数
    @JsonKey(name: 'shop_type') String? shopType, // 商店类型
    @JsonKey(name: 'recitation_question_model')
    dynamic recitationQuestionModel, // 背诵模式: 1=开启 2=关闭
    @JsonKey(name: 'goods_months_price_id')
    String? goodsMonthsPriceId, // ✅ 商品月份价格ID (小程序Line 428)
    @JsonKey(name: 'month') dynamic month, // ✅ 月份 (小程序Line 429) - 可能是String或int
    @JsonKey(name: 'months_prices')
    List<Map<String, dynamic>>? monthsPrices, // ✅ 月份价格列表 (小程序Line 382-388)
    @JsonKey(name: 'professional_id')
    dynamic professionalId, // ✅ 专业ID (小程序Line 129, 195)
    @JsonKey(name: 'professional_id_name')
    String? professionalIdName, // ✅ 专业ID名称 (小程序Line 470)
    @JsonKey(name: 'year') String? year, // ✅ 年份 (小程序Line 17, 190)
    @JsonKey(name: 'permission_operation_type')
    dynamic permissionOperationType, // ✅ 权限操作类型 (小程序Line 195)
    @JsonKey(name: 'tiku_goods_details')
    TikuGoodsDetails? tikuGoodsDetails, // 题库商品详情
    @JsonKey(name: 'detail_package_goods')
    List<Map<String, dynamic>>? detailPackageGoods, // ✅ 课程大纲数据
    @JsonKey(name: 'permission_order_id')
    dynamic permissionOrderId, // ✅ 权限订单ID (小程序Line 473: 为0表示未报名)
    @JsonKey(name: 'teaching_system')
    Map<String, dynamic>? teachingSystem, // ✅ 教学体系（用于显示 system_id_name）
    @JsonKey(name: 'created_at')
    String? createdAt, // ✅ 创建时间（开考时间，用于已购试题）
  }) = _GoodsModel;

  factory GoodsModel.fromJson(Map<String, dynamic> json) =>
      _$GoodsModelFromJson(json);
}

/// GoodsModel 扩展方法
extension GoodsModelExtension on GoodsModel {
  /// 计算课程类型图标类型
  /// 对应小程序 brushing.vue 的 computGoodType 函数
  ///
  /// 判断优先级：
  /// 1. is_recommend == 1 → "recommend" (推荐)
  /// 2. teaching_type_name == "直播" → "good" (好课)
  /// 3. teaching_type_name != "直播" → business_type (1=精品, 2=高端, 3=私塾)
  /// 4. 默认 → "1" (精品)
  String computeShopType() {
    // 优先级1: 判断是否推荐
    if (isRecommend != null) {
      final recommend = isRecommend.toString();
      if (recommend == '1') {
        return 'recommend';
      }
    }

    // 优先级2: 判断是否直播
    if (teachingTypeName == '直播') {
      return 'good';
    }

    // 优先级3: 非直播使用 business_type
    if (teachingTypeName != null && teachingTypeName != '直播') {
      if (businessType != null) {
        return businessType.toString();
      }
    }

    // 默认: 精品
    return '1';
  }
}

/// 题库商品详情
@freezed
class TikuGoodsDetails with _$TikuGoodsDetails {
  const factory TikuGoodsDetails({
    @JsonKey(name: 'question_num') dynamic questionNum, // 题目数量
    @JsonKey(name: 'paper_num') dynamic paperNum, // 试卷数量
    @JsonKey(name: 'exam_round_num') dynamic examRoundNum, // 考试轮次
    @JsonKey(name: 'exam_time') String? examTime, // 考试时间
  }) = _TikuGoodsDetails;

  factory TikuGoodsDetails.fromJson(Map<String, dynamic> json) =>
      _$TikuGoodsDetailsFromJson(json);
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

  factory TeacherModel.fromJson(Map<String, dynamic> json) =>
      _$TeacherModelFromJson(json);
}

/// 商品列表响应
@freezed
class GoodsListResponse with _$GoodsListResponse {
  const factory GoodsListResponse({
    @JsonKey(name: 'list')
    @Default([])
    List<GoodsModel> list, // 使用默认空数组,避免null导致的类型转换错误
    @JsonKey(name: 'total') int? total,
  }) = _GoodsListResponse;

  factory GoodsListResponse.fromJson(Map<String, dynamic> json) =>
      _$GoodsListResponseFromJson(json);
}
