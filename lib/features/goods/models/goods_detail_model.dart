import 'package:freezed_annotation/freezed_annotation.dart';

part 'goods_detail_model.freezed.dart';
part 'goods_detail_model.g.dart';

/// 商品详情Model
/// 对应小程序: pages/test/detail.vue
/// API: GET /c/goods/v2/detail?goods_id={id}
@freezed
class GoodsDetailModel with _$GoodsDetailModel {
  const factory GoodsDetailModel({
    @JsonKey(name: 'id') dynamic goodsId,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'type') dynamic type, // 18=章节练习, 8=试卷, 10=模考
    @JsonKey(name: 'material_cover_path') String? materialCoverPath,
    @JsonKey(name: 'material_intro_path') String? materialIntroPath,
    @JsonKey(name: 'long_img_path') String? longImgPath, // 长图路径（科目模考专用）
    @JsonKey(name: 'permission_status')
    String? permissionStatus, // 1=已购买, 2=未购买
    @JsonKey(name: 'professional_id') String? professionalId,
    @JsonKey(name: 'professional_id_name') String? professionalIdName,
    @JsonKey(name: 'year') String? year,
    @JsonKey(name: 'exam_title') String? examTitle,
    @JsonKey(name: 'prices') @Default([]) List<GoodsPriceModel> prices,
    @JsonKey(name: 'tiku_goods_details') TikuGoodsDetails? tikuGoodsDetails,
    @JsonKey(name: 'teaching_system') TeachingSystem? teachingSystem,
    @JsonKey(name: 'paper_statistics') PaperStatistics? paperStatistics,
    @JsonKey(name: 'recitation_question_model') dynamic recitationQuestionModel,
    @JsonKey(name: 'permission_order_id') dynamic permissionOrderId,
    // ✅ 新增：套餐包含的商品列表
    @JsonKey(name: 'detail_package_goods')
    List<PackageGoodsModel>? detailPackageGoods,
  }) = _GoodsDetailModel;

  factory GoodsDetailModel.fromJson(Map<String, dynamic> json) =>
      _$GoodsDetailModelFromJson(json);
}

/// GoodsDetailModel 扩展方法
extension GoodsDetailModelExtension on GoodsDetailModel {
  /// 计算数量文本
  /// 对应小程序 detail.vue Line 449-455
  String get numText {
    final typeInt = int.tryParse(type?.toString() ?? '') ?? 0;

    if (typeInt == 18) {
      // 章节练习
      final num = tikuGoodsDetails?.questionNum?.toString() ?? '0';
      return '共${num}题';
    } else if (typeInt == 8) {
      // 试卷
      final num = tikuGoodsDetails?.paperNum?.toString() ?? '0';
      return '共${num}份';
    } else if (typeInt == 10) {
      // 模考
      final num = tikuGoodsDetails?.examRoundNum?.toString() ?? '0';
      return '共${num}轮';
    }

    return '';
  }

  /// 计算提示信息
  /// 对应小程序 detail.vue Line 456-459
  String get tipsText {
    final typeInt = int.tryParse(type?.toString() ?? '') ?? 0;

    if (typeInt == 10) {
      // 模考显示开考时间
      final examTime = tikuGoodsDetails?.examTime ?? '';
      return '开考时间:$examTime';
    }

    // 其他显示教学体系
    return teachingSystem?.systemIdName ?? '';
  }
}

/// 商品价格Model
@freezed
class GoodsPriceModel with _$GoodsPriceModel {
  const factory GoodsPriceModel({
    @JsonKey(name: 'goods_months_price_id') String? goodsMonthsPriceId,
    @JsonKey(name: 'month') dynamic month, // 0=永久
    @JsonKey(name: 'sale_price') String? salePrice,
    @JsonKey(name: 'original_price') String? originalPrice,
    @JsonKey(name: 'days') String? days,
  }) = _GoodsPriceModel;

  factory GoodsPriceModel.fromJson(Map<String, dynamic> json) =>
      _$GoodsPriceModelFromJson(json);
}

/// GoodsPriceModel 扩展方法
extension GoodsPriceModelExtension on GoodsPriceModel {
  /// 有效期文本
  String get validityText {
    final monthInt = int.tryParse(month?.toString() ?? '') ?? 0;
    return monthInt == 0 ? '永久' : '$monthInt个月';
  }

  /// 优惠金额
  double get discountAmount {
    final sale = double.tryParse(salePrice ?? '0') ?? 0;
    final original = double.tryParse(originalPrice ?? '0') ?? 0;
    return original - sale;
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

/// 教学体系
@freezed
class TeachingSystem with _$TeachingSystem {
  const factory TeachingSystem({
    @JsonKey(name: 'system_id_name') String? systemIdName,
  }) = _TeachingSystem;

  factory TeachingSystem.fromJson(Map<String, dynamic> json) =>
      _$TeachingSystemFromJson(json);
}

/// 做题统计Model
/// 对应小程序: secretRealDetail.vue Line 29-35
@freezed
class PaperStatistics with _$PaperStatistics {
  const factory PaperStatistics({
    @JsonKey(name: 'do_count') dynamic doCount,
    @JsonKey(name: 'total_accuracy_rate') dynamic totalAccuracyRate,
  }) = _PaperStatistics;

  factory PaperStatistics.fromJson(Map<String, dynamic> json) =>
      _$PaperStatisticsFromJson(json);
}

/// 套餐包含的商品Model
/// 对应小程序: newVideo.vue Line 400-407 (detail_package_goods)
@freezed
class PackageGoodsModel with _$PackageGoodsModel {
  const factory PackageGoodsModel({
    @JsonKey(name: 'id') dynamic id,
    @JsonKey(name: 'name') String? name,
  }) = _PackageGoodsModel;

  factory PackageGoodsModel.fromJson(Map<String, dynamic> json) =>
      _$PackageGoodsModelFromJson(json);
}
