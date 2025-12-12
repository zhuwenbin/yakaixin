import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection_question_model.freezed.dart';
part 'collection_question_model.g.dart';

/// 安全类型转换器 - 将dynamic转为String
/// 用于处理后端返回 int 或 String 的字段
class DynamicToStringConverter implements JsonConverter<String?, dynamic> {
  const DynamicToStringConverter();

  @override
  String? fromJson(dynamic value) {
    if (value == null) return null;
    return value.toString();  // ✅ int/String/double 都转为 String
  }

  @override
  dynamic toJson(String? value) => value;
}

/// 安全类型转换器 - 将dynamic转为List<String>
/// 遵循data_type_safety.md规则
/// 
/// 处理后端返回的不确定类型：
/// - null → null
/// - "组织结构" → ["组织结构"] (String → List)
/// - ["A", "B"] → ["A", "B"] (List → List<String>)
class DynamicToStringListConverter implements JsonConverter<List<String>?, dynamic> {
  const DynamicToStringListConverter();

  @override
  List<String>? fromJson(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    if (value is String) {
      return [value]; // 单个String转为列表
    }
    return null;
  }

  @override
  dynamic toJson(List<String>? value) => value;
}

/// 收藏题目模型
/// 对应小程序: collect/index.vue Line 157-172
@freezed
class CollectionQuestionModel with _$CollectionQuestionModel {
  const factory CollectionQuestionModel({
    // 基本信息
    required String id,
    @JsonKey(name: 'practice_id') String? practiceId,
    @JsonKey(name: 'professional_id') String? professionalId,
    @JsonKey(name: 'chapter_id') String? chapterId,
    
    // 题目信息
    @JsonKey(name: 'thematic_stem') String? thematicStem, // 病例题干
    required String type, // 题型: 1-A1, 2-A2, 3-A3, 4-A4, 5-B1, 6-B2, 7-X
    @JsonKey(name: 'type_name') String? typeName, // 题型名称
    required String level, // 难度等级 1-5
    String? year, // 年份
    @JsonKey(name: 'err_rate') String? errRate, // 错误率
    String? parse, // 解析
    
    // 知识点 (使用转换器安全处理类型不一致)
    @JsonKey(name: 'knowledge_ids')
    @DynamicToStringListConverter()
    List<String>? knowledgeIds,
    @JsonKey(name: 'knowledge_ids_name')
    @DynamicToStringListConverter()
    List<String>? knowledgeIdsName,
    
    // 题干列表
    @JsonKey(name: 'stem_list') required List<QuestionStemModel> stemList,
    
    // 收藏信息
    @JsonKey(name: 'created_at') String? createdAt, // 收藏时间
    @JsonKey(name: 'is_collect') String? isCollect, // 是否收藏 '1'-是 '2'-否
    
    // 答题状态
    @JsonKey(name: 'is_answer') String? isAnswer,
    @JsonKey(name: 'user_option') String? userOption,
    @JsonKey(name: 'answer_status') String? answerStatus,
    
    // UI辅助字段 (前端处理后添加，使用转换器安全处理类型不一致)
    @JsonKey(name: 'titleInfo')
    @DynamicToStringListConverter()
    List<String>? titleInfo, // 题目标题信息
  }) = _CollectionQuestionModel;

  factory CollectionQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$CollectionQuestionModelFromJson(json);
}

/// 题干模型
@freezed
class QuestionStemModel with _$QuestionStemModel {
  const factory QuestionStemModel({
    required String id,
    String? sort,
    String? content, // 题干内容
    String? option, // 选项 JSON字符串
    String? answer, // 答案 JSON字符串
    
    // ✅ question_version_id 后端可能返回 int 或 String，使用转换器
    @JsonKey(name: 'question_version_id')
    @DynamicToStringConverter()
    String? questionVersionId,
  }) = _QuestionStemModel;

  factory QuestionStemModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionStemModelFromJson(json);
}

/// 收藏列表响应模型
@freezed
class CollectionListResponse with _$CollectionListResponse {
  const factory CollectionListResponse({
    required List<CollectionQuestionModel> list,
    required int total,
  }) = _CollectionListResponse;

  factory CollectionListResponse.fromJson(Map<String, dynamic> json) =>
      _$CollectionListResponseFromJson(json);
}

/// 收藏列表分组模型 (按题型分组)
@freezed
class CollectionGroupModel with _$CollectionGroupModel {
  const factory CollectionGroupModel({
    required String typeName, // 题型名称
    required List<CollectionQuestionModel> questions, // 该题型的题目列表
  }) = _CollectionGroupModel;
}
