import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yakaixin_app/core/utils/safe_type_converter.dart';

part 'question_bank_model.freezed.dart';
part 'question_bank_model.g.dart';

// ============================================
// 类型安全转换器 - 永远不要信任外部数据源
// ============================================
//
// 注意：SafeTypeConverter 已统一在 lib/core/utils/safe_type_converter.dart 中定义
// 本文件中的 JsonConverter 类使用统一的 SafeTypeConverter

/// JsonConverter 实现
class IntConverter implements JsonConverter<int, dynamic> {
  const IntConverter();

  @override
  int fromJson(dynamic value) => SafeTypeConverter.toInt(value);

  @override
  dynamic toJson(int value) => value;
}

class DoubleConverter implements JsonConverter<double, dynamic> {
  const DoubleConverter();

  @override
  double fromJson(dynamic value) => SafeTypeConverter.toDouble(value);

  @override
  dynamic toJson(double value) => value;
}

class StringConverter implements JsonConverter<String, dynamic> {
  const StringConverter();

  @override
  String fromJson(dynamic value) => SafeTypeConverter.toSafeString(value);

  @override
  dynamic toJson(String value) => value;
}

class BoolConverter implements JsonConverter<bool, dynamic> {
  const BoolConverter();

  @override
  bool fromJson(dynamic value) => SafeTypeConverter.toBool(value);

  @override
  dynamic toJson(bool value) => value;
}

// ============================================
// 数据模型
// ============================================

/// 学习数据模型
@freezed
class LearningDataModel with _$LearningDataModel {
  const factory LearningDataModel({
    @IntConverter() @JsonKey(name: 'checkin_num') @Default(0) int checkinNum,
    @IntConverter() @JsonKey(name: 'total_num') @Default(0) int totalNum,
    @StringConverter()
    @JsonKey(name: 'correct_rate')
    @Default('0')
    String correctRate,
    @IntConverter() @JsonKey(name: 'is_checkin') @Default(0) int isCheckin,
    @IntConverter() @JsonKey(name: 'done_num') @Default(0) int doneNum,
    @IntConverter() @JsonKey(name: 'study_days') @Default(0) int studyDays,
  }) = _LearningDataModel;

  factory LearningDataModel.fromJson(Map<String, dynamic> json) =>
      _$LearningDataModelFromJson(json);
}

/// 章节模型
@freezed
class ChapterModel with _$ChapterModel {
  const factory ChapterModel({
    @StringConverter() @JsonKey(name: 'id') @Default('') String id,
    @StringConverter()
    @JsonKey(name: 'sectionname')
    @Default('')
    String sectionName,
    @IntConverter()
    @JsonKey(name: 'question_number')
    @Default(0)
    int questionNumber,
    @IntConverter()
    @JsonKey(name: 'do_question_num')
    @Default(0)
    int doQuestionNum,
    @DoubleConverter()
    @JsonKey(name: 'correct_rate')
    @Default(0.0)
    double correctRate,
  }) = _ChapterModel;

  factory ChapterModel.fromJson(Map<String, dynamic> json) =>
      _$ChapterModelFromJson(json);
}

/// 章节练习模型
/// 对应小程序: src/modules/jintiku/components/commen/index-nav.vue
/// 注意：与每日一测使用相同的UI样式，但数据源和跳转逻辑不同
@freezed
class ChapterExerciseModel with _$ChapterExerciseModel {
  const factory ChapterExerciseModel({
    @StringConverter() @JsonKey(name: 'id') @Default('') String id,
    @StringConverter() @JsonKey(name: 'name') @Default('章节练习') String name,
    
    /// 权限状态 (1-已购买, 2-未购买)
    /// 对应小程序: index-nav.vue Line 123
    @StringConverter() @JsonKey(name: 'permission_status') @Default('2') String permissionStatus,
    
    /// 题目数量（对应接口返回的 question_num）
    /// 对应小程序: index-nav.vue Line 278
    @IntConverter() @JsonKey(name: 'question_num') @Default(0) int questionNumber,
    
    /// 已做题数
    /// 对应小程序: index-nav.vue Line 276, student_finish.do_num
    @IntConverter()
    @JsonKey(name: 'do_question_num')
    @Default(0)
    int doQuestionNum,
    
    /// 有效期
    @StringConverter() @JsonKey(name: 'year') @Default('') String year,
    
    /// 专业ID
    @StringConverter() @JsonKey(name: 'professional_id') @Default('') String professionalId,
  }) = _ChapterExerciseModel;

  factory ChapterExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$ChapterExerciseModelFromJson(json);
}

/// 已购商品模型
/// 对应小程序: index-nav-item.vue
@freezed
class PurchasedGoodsModel with _$PurchasedGoodsModel {
  const factory PurchasedGoodsModel({
    @StringConverter() @JsonKey(name: 'id') @Default('') String id,
    @StringConverter() @JsonKey(name: 'name') @Default('') String name,
    @StringConverter()
    @JsonKey(name: 'material_cover_path')
    @Default('')
    String materialCoverPath,
    @IntConverter()
    @JsonKey(name: 'question_count')
    @Default(0)
    int questionCount,
    
    // ✅ 新增字段（对应小程序 Line 275-328）
    /// 商品类型 (8-试卷, 10-模考, 18-题库)
    @StringConverter() @JsonKey(name: 'type') @Default('') String type,
    
    /// 详情页类型 (1-经典, 2-真题, 3-科目, 4-模拟)
    @StringConverter() @JsonKey(name: 'details_type') @Default('') String detailsType,
    
    /// 数据类型 (2-模考)
    @StringConverter() @JsonKey(name: 'data_type') @Default('') String dataType,
    
    /// 权限状态 (1-已购买, 2-未购买)
    @StringConverter() @JsonKey(name: 'permission_status') @Default('1') String permissionStatus,
    
    /// 背题模式
    @StringConverter() @JsonKey(name: 'recitation_question_model') @Default('') String recitationQuestionModel,
    
    /// 专业ID
    @StringConverter() @JsonKey(name: 'professional_id') @Default('') String professionalId,
    
    /// 有效期开始时间
    @StringConverter() @JsonKey(name: 'validity_start_date') String? validityStartDate,
    
    /// 有效期结束时间
    @StringConverter() @JsonKey(name: 'validity_end_date') String? validityEndDate,
    
    /// 创建时间（开考时间）
    @StringConverter() @JsonKey(name: 'created_at') String? createdAt,
    
    /// 题目数量文本（如 "共3580题"）
    @StringConverter() @JsonKey(name: 'num_text') String? numText,
    
    /// 题库详情
    @JsonKey(name: 'tiku_goods_details') TikuGoodsDetailsModel? tikuGoodsDetails,
  }) = _PurchasedGoodsModel;

  factory PurchasedGoodsModel.fromJson(Map<String, dynamic> json) =>
      _$PurchasedGoodsModelFromJson(json);
}

/// 题库商品详情
@freezed
class TikuGoodsDetailsModel with _$TikuGoodsDetailsModel {
  const factory TikuGoodsDetailsModel({
    @IntConverter() @JsonKey(name: 'question_num') @Default(0) int questionNum,
    @IntConverter() @JsonKey(name: 'paper_num') @Default(0) int paperNum,
    @IntConverter() @JsonKey(name: 'exam_round_num') @Default(0) int examRoundNum,
    @StringConverter() @JsonKey(name: 'exam_time') @Default('') String examTime,
  }) = _TikuGoodsDetailsModel;

  factory TikuGoodsDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$TikuGoodsDetailsModelFromJson(json);
}

/// 每日一测模型
@freezed
class DailyPracticeModel with _$DailyPracticeModel {
  const factory DailyPracticeModel({
    @StringConverter() @JsonKey(name: 'id') @Default('') String id,
    @StringConverter() @JsonKey(name: 'name') @Default('每日30题') String name,
    
    /// 权限状态 (1-已购买, 2-未购买)
    /// 对应小程序: daily-nav.vue Line 126, daily-nav-two.vue Line 127
    @StringConverter() @JsonKey(name: 'permission_status') @Default('2') String permissionStatus,
    
    /// 题目数量（对应接口返回的 question_num）
    /// 对应小程序: daily-nav.vue Line 273, daily-nav-two.vue Line 428
    @IntConverter() @JsonKey(name: 'question_num') @Default(30) int questionNumber,
    
    /// 总题数（兼容字段）
    @IntConverter()
    @JsonKey(name: 'total_questions')
    @Default(30)
    int totalQuestions,
    
    /// 已做题数
    @IntConverter()
    @JsonKey(name: 'done_questions')
    @Default(0)
    int doneQuestions,
    
    @StringConverter() @JsonKey(name: 'year') @Default('') String year,
    
    /// 专业ID
    @StringConverter() @JsonKey(name: 'professional_id') @Default('') String professionalId,
  }) = _DailyPracticeModel;

  factory DailyPracticeModel.fromJson(Map<String, dynamic> json) =>
      _$DailyPracticeModelFromJson(json);
}

/// 技能模拟模型
@freezed
class SkillMockModel with _$SkillMockModel {
  const factory SkillMockModel({
    @StringConverter() @JsonKey(name: 'id') @Default('') String id,
    @StringConverter() @JsonKey(name: 'name') @Default('技能模拟') String name,
    @StringConverter()
    @JsonKey(name: 'description')
    @Default('')
    String description,
  }) = _SkillMockModel;

  factory SkillMockModel.fromJson(Map<String, dynamic> json) =>
      _$SkillMockModelFromJson(json);
}
