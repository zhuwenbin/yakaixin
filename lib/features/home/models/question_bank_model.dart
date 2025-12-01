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
    @StringConverter() @JsonKey(name: 'correct_rate') @Default('0') String correctRate,
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
    @StringConverter() @JsonKey(name: 'sectionname') @Default('') String sectionName,
    @IntConverter() @JsonKey(name: 'question_number') @Default(0) int questionNumber,
    @IntConverter() @JsonKey(name: 'do_question_num') @Default(0) int doQuestionNum,
    @DoubleConverter() @JsonKey(name: 'correct_rate') @Default(0.0) double correctRate,
  }) = _ChapterModel;

  factory ChapterModel.fromJson(Map<String, dynamic> json) =>
      _$ChapterModelFromJson(json);
}

/// 已购商品模型
@freezed
class PurchasedGoodsModel with _$PurchasedGoodsModel {
  const factory PurchasedGoodsModel({
    @StringConverter() @JsonKey(name: 'id') @Default('') String id,
    @StringConverter() @JsonKey(name: 'name') @Default('') String name,
    @StringConverter() @JsonKey(name: 'material_cover_path') @Default('') String materialCoverPath,
    @IntConverter() @JsonKey(name: 'question_count') @Default(0) int questionCount,
  }) = _PurchasedGoodsModel;

  factory PurchasedGoodsModel.fromJson(Map<String, dynamic> json) =>
      _$PurchasedGoodsModelFromJson(json);
}

/// 每日一测模型
@freezed
class DailyPracticeModel with _$DailyPracticeModel {
  const factory DailyPracticeModel({
    @StringConverter() @JsonKey(name: 'id') @Default('') String id,
    @StringConverter() @JsonKey(name: 'name') @Default('每日30题') String name,
    @IntConverter() @JsonKey(name: 'total_questions') @Default(30) int totalQuestions,
    @IntConverter() @JsonKey(name: 'done_questions') @Default(0) int doneQuestions,
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
    @StringConverter() @JsonKey(name: 'description') @Default('') String description,
  }) = _SkillMockModel;

  factory SkillMockModel.fromJson(Map<String, dynamic> json) =>
      _$SkillMockModelFromJson(json);
}
