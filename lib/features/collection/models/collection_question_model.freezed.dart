// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection_question_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CollectionQuestionModel _$CollectionQuestionModelFromJson(
    Map<String, dynamic> json) {
  return _CollectionQuestionModel.fromJson(json);
}

/// @nodoc
mixin _$CollectionQuestionModel {
// 基本信息
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'practice_id')
  String? get practiceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'professional_id')
  String? get professionalId => throw _privateConstructorUsedError;
  @JsonKey(name: 'chapter_id')
  String? get chapterId => throw _privateConstructorUsedError; // 题目信息
  @JsonKey(name: 'thematic_stem')
  String? get thematicStem => throw _privateConstructorUsedError; // 病例题干
  String get type =>
      throw _privateConstructorUsedError; // 题型: 1-A1, 2-A2, 3-A3, 4-A4, 5-B1, 6-B2, 7-X
  @JsonKey(name: 'type_name')
  String? get typeName => throw _privateConstructorUsedError; // 题型名称
  String get level => throw _privateConstructorUsedError; // 难度等级 1-5
  String? get year => throw _privateConstructorUsedError; // 年份
  @JsonKey(name: 'err_rate')
  String? get errRate => throw _privateConstructorUsedError; // 错误率
  String? get parse => throw _privateConstructorUsedError; // 解析
// 知识点 (使用转换器安全处理类型不一致)
  @JsonKey(name: 'knowledge_ids')
  @DynamicToStringListConverter()
  List<String>? get knowledgeIds => throw _privateConstructorUsedError;
  @JsonKey(name: 'knowledge_ids_name')
  @DynamicToStringListConverter()
  List<String>? get knowledgeIdsName =>
      throw _privateConstructorUsedError; // 题干列表
  @JsonKey(name: 'stem_list')
  List<QuestionStemModel> get stemList =>
      throw _privateConstructorUsedError; // 收藏信息
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError; // 收藏时间
  @JsonKey(name: 'is_collect')
  String? get isCollect =>
      throw _privateConstructorUsedError; // 是否收藏 '1'-是 '2'-否
// 答题状态
  @JsonKey(name: 'is_answer')
  String? get isAnswer => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_option')
  String? get userOption => throw _privateConstructorUsedError;
  @JsonKey(name: 'answer_status')
  String? get answerStatus =>
      throw _privateConstructorUsedError; // UI辅助字段 (前端处理后添加，使用转换器安全处理类型不一致)
  @JsonKey(name: 'titleInfo')
  @DynamicToStringListConverter()
  List<String>? get titleInfo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CollectionQuestionModelCopyWith<CollectionQuestionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollectionQuestionModelCopyWith<$Res> {
  factory $CollectionQuestionModelCopyWith(CollectionQuestionModel value,
          $Res Function(CollectionQuestionModel) then) =
      _$CollectionQuestionModelCopyWithImpl<$Res, CollectionQuestionModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'practice_id') String? practiceId,
      @JsonKey(name: 'professional_id') String? professionalId,
      @JsonKey(name: 'chapter_id') String? chapterId,
      @JsonKey(name: 'thematic_stem') String? thematicStem,
      String type,
      @JsonKey(name: 'type_name') String? typeName,
      String level,
      String? year,
      @JsonKey(name: 'err_rate') String? errRate,
      String? parse,
      @JsonKey(name: 'knowledge_ids')
      @DynamicToStringListConverter()
      List<String>? knowledgeIds,
      @JsonKey(name: 'knowledge_ids_name')
      @DynamicToStringListConverter()
      List<String>? knowledgeIdsName,
      @JsonKey(name: 'stem_list') List<QuestionStemModel> stemList,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'is_collect') String? isCollect,
      @JsonKey(name: 'is_answer') String? isAnswer,
      @JsonKey(name: 'user_option') String? userOption,
      @JsonKey(name: 'answer_status') String? answerStatus,
      @JsonKey(name: 'titleInfo')
      @DynamicToStringListConverter()
      List<String>? titleInfo});
}

/// @nodoc
class _$CollectionQuestionModelCopyWithImpl<$Res,
        $Val extends CollectionQuestionModel>
    implements $CollectionQuestionModelCopyWith<$Res> {
  _$CollectionQuestionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? practiceId = freezed,
    Object? professionalId = freezed,
    Object? chapterId = freezed,
    Object? thematicStem = freezed,
    Object? type = null,
    Object? typeName = freezed,
    Object? level = null,
    Object? year = freezed,
    Object? errRate = freezed,
    Object? parse = freezed,
    Object? knowledgeIds = freezed,
    Object? knowledgeIdsName = freezed,
    Object? stemList = null,
    Object? createdAt = freezed,
    Object? isCollect = freezed,
    Object? isAnswer = freezed,
    Object? userOption = freezed,
    Object? answerStatus = freezed,
    Object? titleInfo = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      practiceId: freezed == practiceId
          ? _value.practiceId
          : practiceId // ignore: cast_nullable_to_non_nullable
              as String?,
      professionalId: freezed == professionalId
          ? _value.professionalId
          : professionalId // ignore: cast_nullable_to_non_nullable
              as String?,
      chapterId: freezed == chapterId
          ? _value.chapterId
          : chapterId // ignore: cast_nullable_to_non_nullable
              as String?,
      thematicStem: freezed == thematicStem
          ? _value.thematicStem
          : thematicStem // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      typeName: freezed == typeName
          ? _value.typeName
          : typeName // ignore: cast_nullable_to_non_nullable
              as String?,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      year: freezed == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as String?,
      errRate: freezed == errRate
          ? _value.errRate
          : errRate // ignore: cast_nullable_to_non_nullable
              as String?,
      parse: freezed == parse
          ? _value.parse
          : parse // ignore: cast_nullable_to_non_nullable
              as String?,
      knowledgeIds: freezed == knowledgeIds
          ? _value.knowledgeIds
          : knowledgeIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      knowledgeIdsName: freezed == knowledgeIdsName
          ? _value.knowledgeIdsName
          : knowledgeIdsName // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      stemList: null == stemList
          ? _value.stemList
          : stemList // ignore: cast_nullable_to_non_nullable
              as List<QuestionStemModel>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      isCollect: freezed == isCollect
          ? _value.isCollect
          : isCollect // ignore: cast_nullable_to_non_nullable
              as String?,
      isAnswer: freezed == isAnswer
          ? _value.isAnswer
          : isAnswer // ignore: cast_nullable_to_non_nullable
              as String?,
      userOption: freezed == userOption
          ? _value.userOption
          : userOption // ignore: cast_nullable_to_non_nullable
              as String?,
      answerStatus: freezed == answerStatus
          ? _value.answerStatus
          : answerStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      titleInfo: freezed == titleInfo
          ? _value.titleInfo
          : titleInfo // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CollectionQuestionModelImplCopyWith<$Res>
    implements $CollectionQuestionModelCopyWith<$Res> {
  factory _$$CollectionQuestionModelImplCopyWith(
          _$CollectionQuestionModelImpl value,
          $Res Function(_$CollectionQuestionModelImpl) then) =
      __$$CollectionQuestionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'practice_id') String? practiceId,
      @JsonKey(name: 'professional_id') String? professionalId,
      @JsonKey(name: 'chapter_id') String? chapterId,
      @JsonKey(name: 'thematic_stem') String? thematicStem,
      String type,
      @JsonKey(name: 'type_name') String? typeName,
      String level,
      String? year,
      @JsonKey(name: 'err_rate') String? errRate,
      String? parse,
      @JsonKey(name: 'knowledge_ids')
      @DynamicToStringListConverter()
      List<String>? knowledgeIds,
      @JsonKey(name: 'knowledge_ids_name')
      @DynamicToStringListConverter()
      List<String>? knowledgeIdsName,
      @JsonKey(name: 'stem_list') List<QuestionStemModel> stemList,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'is_collect') String? isCollect,
      @JsonKey(name: 'is_answer') String? isAnswer,
      @JsonKey(name: 'user_option') String? userOption,
      @JsonKey(name: 'answer_status') String? answerStatus,
      @JsonKey(name: 'titleInfo')
      @DynamicToStringListConverter()
      List<String>? titleInfo});
}

/// @nodoc
class __$$CollectionQuestionModelImplCopyWithImpl<$Res>
    extends _$CollectionQuestionModelCopyWithImpl<$Res,
        _$CollectionQuestionModelImpl>
    implements _$$CollectionQuestionModelImplCopyWith<$Res> {
  __$$CollectionQuestionModelImplCopyWithImpl(
      _$CollectionQuestionModelImpl _value,
      $Res Function(_$CollectionQuestionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? practiceId = freezed,
    Object? professionalId = freezed,
    Object? chapterId = freezed,
    Object? thematicStem = freezed,
    Object? type = null,
    Object? typeName = freezed,
    Object? level = null,
    Object? year = freezed,
    Object? errRate = freezed,
    Object? parse = freezed,
    Object? knowledgeIds = freezed,
    Object? knowledgeIdsName = freezed,
    Object? stemList = null,
    Object? createdAt = freezed,
    Object? isCollect = freezed,
    Object? isAnswer = freezed,
    Object? userOption = freezed,
    Object? answerStatus = freezed,
    Object? titleInfo = freezed,
  }) {
    return _then(_$CollectionQuestionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      practiceId: freezed == practiceId
          ? _value.practiceId
          : practiceId // ignore: cast_nullable_to_non_nullable
              as String?,
      professionalId: freezed == professionalId
          ? _value.professionalId
          : professionalId // ignore: cast_nullable_to_non_nullable
              as String?,
      chapterId: freezed == chapterId
          ? _value.chapterId
          : chapterId // ignore: cast_nullable_to_non_nullable
              as String?,
      thematicStem: freezed == thematicStem
          ? _value.thematicStem
          : thematicStem // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      typeName: freezed == typeName
          ? _value.typeName
          : typeName // ignore: cast_nullable_to_non_nullable
              as String?,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      year: freezed == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as String?,
      errRate: freezed == errRate
          ? _value.errRate
          : errRate // ignore: cast_nullable_to_non_nullable
              as String?,
      parse: freezed == parse
          ? _value.parse
          : parse // ignore: cast_nullable_to_non_nullable
              as String?,
      knowledgeIds: freezed == knowledgeIds
          ? _value._knowledgeIds
          : knowledgeIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      knowledgeIdsName: freezed == knowledgeIdsName
          ? _value._knowledgeIdsName
          : knowledgeIdsName // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      stemList: null == stemList
          ? _value._stemList
          : stemList // ignore: cast_nullable_to_non_nullable
              as List<QuestionStemModel>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      isCollect: freezed == isCollect
          ? _value.isCollect
          : isCollect // ignore: cast_nullable_to_non_nullable
              as String?,
      isAnswer: freezed == isAnswer
          ? _value.isAnswer
          : isAnswer // ignore: cast_nullable_to_non_nullable
              as String?,
      userOption: freezed == userOption
          ? _value.userOption
          : userOption // ignore: cast_nullable_to_non_nullable
              as String?,
      answerStatus: freezed == answerStatus
          ? _value.answerStatus
          : answerStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      titleInfo: freezed == titleInfo
          ? _value._titleInfo
          : titleInfo // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CollectionQuestionModelImpl implements _CollectionQuestionModel {
  const _$CollectionQuestionModelImpl(
      {required this.id,
      @JsonKey(name: 'practice_id') this.practiceId,
      @JsonKey(name: 'professional_id') this.professionalId,
      @JsonKey(name: 'chapter_id') this.chapterId,
      @JsonKey(name: 'thematic_stem') this.thematicStem,
      required this.type,
      @JsonKey(name: 'type_name') this.typeName,
      required this.level,
      this.year,
      @JsonKey(name: 'err_rate') this.errRate,
      this.parse,
      @JsonKey(name: 'knowledge_ids')
      @DynamicToStringListConverter()
      final List<String>? knowledgeIds,
      @JsonKey(name: 'knowledge_ids_name')
      @DynamicToStringListConverter()
      final List<String>? knowledgeIdsName,
      @JsonKey(name: 'stem_list')
      required final List<QuestionStemModel> stemList,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'is_collect') this.isCollect,
      @JsonKey(name: 'is_answer') this.isAnswer,
      @JsonKey(name: 'user_option') this.userOption,
      @JsonKey(name: 'answer_status') this.answerStatus,
      @JsonKey(name: 'titleInfo')
      @DynamicToStringListConverter()
      final List<String>? titleInfo})
      : _knowledgeIds = knowledgeIds,
        _knowledgeIdsName = knowledgeIdsName,
        _stemList = stemList,
        _titleInfo = titleInfo;

  factory _$CollectionQuestionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CollectionQuestionModelImplFromJson(json);

// 基本信息
  @override
  final String id;
  @override
  @JsonKey(name: 'practice_id')
  final String? practiceId;
  @override
  @JsonKey(name: 'professional_id')
  final String? professionalId;
  @override
  @JsonKey(name: 'chapter_id')
  final String? chapterId;
// 题目信息
  @override
  @JsonKey(name: 'thematic_stem')
  final String? thematicStem;
// 病例题干
  @override
  final String type;
// 题型: 1-A1, 2-A2, 3-A3, 4-A4, 5-B1, 6-B2, 7-X
  @override
  @JsonKey(name: 'type_name')
  final String? typeName;
// 题型名称
  @override
  final String level;
// 难度等级 1-5
  @override
  final String? year;
// 年份
  @override
  @JsonKey(name: 'err_rate')
  final String? errRate;
// 错误率
  @override
  final String? parse;
// 解析
// 知识点 (使用转换器安全处理类型不一致)
  final List<String>? _knowledgeIds;
// 解析
// 知识点 (使用转换器安全处理类型不一致)
  @override
  @JsonKey(name: 'knowledge_ids')
  @DynamicToStringListConverter()
  List<String>? get knowledgeIds {
    final value = _knowledgeIds;
    if (value == null) return null;
    if (_knowledgeIds is EqualUnmodifiableListView) return _knowledgeIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _knowledgeIdsName;
  @override
  @JsonKey(name: 'knowledge_ids_name')
  @DynamicToStringListConverter()
  List<String>? get knowledgeIdsName {
    final value = _knowledgeIdsName;
    if (value == null) return null;
    if (_knowledgeIdsName is EqualUnmodifiableListView)
      return _knowledgeIdsName;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// 题干列表
  final List<QuestionStemModel> _stemList;
// 题干列表
  @override
  @JsonKey(name: 'stem_list')
  List<QuestionStemModel> get stemList {
    if (_stemList is EqualUnmodifiableListView) return _stemList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stemList);
  }

// 收藏信息
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
// 收藏时间
  @override
  @JsonKey(name: 'is_collect')
  final String? isCollect;
// 是否收藏 '1'-是 '2'-否
// 答题状态
  @override
  @JsonKey(name: 'is_answer')
  final String? isAnswer;
  @override
  @JsonKey(name: 'user_option')
  final String? userOption;
  @override
  @JsonKey(name: 'answer_status')
  final String? answerStatus;
// UI辅助字段 (前端处理后添加，使用转换器安全处理类型不一致)
  final List<String>? _titleInfo;
// UI辅助字段 (前端处理后添加，使用转换器安全处理类型不一致)
  @override
  @JsonKey(name: 'titleInfo')
  @DynamicToStringListConverter()
  List<String>? get titleInfo {
    final value = _titleInfo;
    if (value == null) return null;
    if (_titleInfo is EqualUnmodifiableListView) return _titleInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CollectionQuestionModel(id: $id, practiceId: $practiceId, professionalId: $professionalId, chapterId: $chapterId, thematicStem: $thematicStem, type: $type, typeName: $typeName, level: $level, year: $year, errRate: $errRate, parse: $parse, knowledgeIds: $knowledgeIds, knowledgeIdsName: $knowledgeIdsName, stemList: $stemList, createdAt: $createdAt, isCollect: $isCollect, isAnswer: $isAnswer, userOption: $userOption, answerStatus: $answerStatus, titleInfo: $titleInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectionQuestionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.practiceId, practiceId) ||
                other.practiceId == practiceId) &&
            (identical(other.professionalId, professionalId) ||
                other.professionalId == professionalId) &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId) &&
            (identical(other.thematicStem, thematicStem) ||
                other.thematicStem == thematicStem) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.typeName, typeName) ||
                other.typeName == typeName) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.errRate, errRate) || other.errRate == errRate) &&
            (identical(other.parse, parse) || other.parse == parse) &&
            const DeepCollectionEquality()
                .equals(other._knowledgeIds, _knowledgeIds) &&
            const DeepCollectionEquality()
                .equals(other._knowledgeIdsName, _knowledgeIdsName) &&
            const DeepCollectionEquality().equals(other._stemList, _stemList) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isCollect, isCollect) ||
                other.isCollect == isCollect) &&
            (identical(other.isAnswer, isAnswer) ||
                other.isAnswer == isAnswer) &&
            (identical(other.userOption, userOption) ||
                other.userOption == userOption) &&
            (identical(other.answerStatus, answerStatus) ||
                other.answerStatus == answerStatus) &&
            const DeepCollectionEquality()
                .equals(other._titleInfo, _titleInfo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        practiceId,
        professionalId,
        chapterId,
        thematicStem,
        type,
        typeName,
        level,
        year,
        errRate,
        parse,
        const DeepCollectionEquality().hash(_knowledgeIds),
        const DeepCollectionEquality().hash(_knowledgeIdsName),
        const DeepCollectionEquality().hash(_stemList),
        createdAt,
        isCollect,
        isAnswer,
        userOption,
        answerStatus,
        const DeepCollectionEquality().hash(_titleInfo)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CollectionQuestionModelImplCopyWith<_$CollectionQuestionModelImpl>
      get copyWith => __$$CollectionQuestionModelImplCopyWithImpl<
          _$CollectionQuestionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CollectionQuestionModelImplToJson(
      this,
    );
  }
}

abstract class _CollectionQuestionModel implements CollectionQuestionModel {
  const factory _CollectionQuestionModel(
      {required final String id,
      @JsonKey(name: 'practice_id') final String? practiceId,
      @JsonKey(name: 'professional_id') final String? professionalId,
      @JsonKey(name: 'chapter_id') final String? chapterId,
      @JsonKey(name: 'thematic_stem') final String? thematicStem,
      required final String type,
      @JsonKey(name: 'type_name') final String? typeName,
      required final String level,
      final String? year,
      @JsonKey(name: 'err_rate') final String? errRate,
      final String? parse,
      @JsonKey(name: 'knowledge_ids')
      @DynamicToStringListConverter()
      final List<String>? knowledgeIds,
      @JsonKey(name: 'knowledge_ids_name')
      @DynamicToStringListConverter()
      final List<String>? knowledgeIdsName,
      @JsonKey(name: 'stem_list')
      required final List<QuestionStemModel> stemList,
      @JsonKey(name: 'created_at') final String? createdAt,
      @JsonKey(name: 'is_collect') final String? isCollect,
      @JsonKey(name: 'is_answer') final String? isAnswer,
      @JsonKey(name: 'user_option') final String? userOption,
      @JsonKey(name: 'answer_status') final String? answerStatus,
      @JsonKey(name: 'titleInfo')
      @DynamicToStringListConverter()
      final List<String>? titleInfo}) = _$CollectionQuestionModelImpl;

  factory _CollectionQuestionModel.fromJson(Map<String, dynamic> json) =
      _$CollectionQuestionModelImpl.fromJson;

  @override // 基本信息
  String get id;
  @override
  @JsonKey(name: 'practice_id')
  String? get practiceId;
  @override
  @JsonKey(name: 'professional_id')
  String? get professionalId;
  @override
  @JsonKey(name: 'chapter_id')
  String? get chapterId;
  @override // 题目信息
  @JsonKey(name: 'thematic_stem')
  String? get thematicStem;
  @override // 病例题干
  String get type;
  @override // 题型: 1-A1, 2-A2, 3-A3, 4-A4, 5-B1, 6-B2, 7-X
  @JsonKey(name: 'type_name')
  String? get typeName;
  @override // 题型名称
  String get level;
  @override // 难度等级 1-5
  String? get year;
  @override // 年份
  @JsonKey(name: 'err_rate')
  String? get errRate;
  @override // 错误率
  String? get parse;
  @override // 解析
// 知识点 (使用转换器安全处理类型不一致)
  @JsonKey(name: 'knowledge_ids')
  @DynamicToStringListConverter()
  List<String>? get knowledgeIds;
  @override
  @JsonKey(name: 'knowledge_ids_name')
  @DynamicToStringListConverter()
  List<String>? get knowledgeIdsName;
  @override // 题干列表
  @JsonKey(name: 'stem_list')
  List<QuestionStemModel> get stemList;
  @override // 收藏信息
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override // 收藏时间
  @JsonKey(name: 'is_collect')
  String? get isCollect;
  @override // 是否收藏 '1'-是 '2'-否
// 答题状态
  @JsonKey(name: 'is_answer')
  String? get isAnswer;
  @override
  @JsonKey(name: 'user_option')
  String? get userOption;
  @override
  @JsonKey(name: 'answer_status')
  String? get answerStatus;
  @override // UI辅助字段 (前端处理后添加，使用转换器安全处理类型不一致)
  @JsonKey(name: 'titleInfo')
  @DynamicToStringListConverter()
  List<String>? get titleInfo;
  @override
  @JsonKey(ignore: true)
  _$$CollectionQuestionModelImplCopyWith<_$CollectionQuestionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

QuestionStemModel _$QuestionStemModelFromJson(Map<String, dynamic> json) {
  return _QuestionStemModel.fromJson(json);
}

/// @nodoc
mixin _$QuestionStemModel {
  String get id => throw _privateConstructorUsedError;
  String? get sort => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError; // 题干内容
  String? get option => throw _privateConstructorUsedError; // 选项 JSON字符串
  String? get answer => throw _privateConstructorUsedError; // 答案 JSON字符串
// ✅ question_version_id 后端可能返回 int 或 String，使用转换器
  @JsonKey(name: 'question_version_id')
  @DynamicToStringConverter()
  String? get questionVersionId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuestionStemModelCopyWith<QuestionStemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionStemModelCopyWith<$Res> {
  factory $QuestionStemModelCopyWith(
          QuestionStemModel value, $Res Function(QuestionStemModel) then) =
      _$QuestionStemModelCopyWithImpl<$Res, QuestionStemModel>;
  @useResult
  $Res call(
      {String id,
      String? sort,
      String? content,
      String? option,
      String? answer,
      @JsonKey(name: 'question_version_id')
      @DynamicToStringConverter()
      String? questionVersionId});
}

/// @nodoc
class _$QuestionStemModelCopyWithImpl<$Res, $Val extends QuestionStemModel>
    implements $QuestionStemModelCopyWith<$Res> {
  _$QuestionStemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sort = freezed,
    Object? content = freezed,
    Object? option = freezed,
    Object? answer = freezed,
    Object? questionVersionId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sort: freezed == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      option: freezed == option
          ? _value.option
          : option // ignore: cast_nullable_to_non_nullable
              as String?,
      answer: freezed == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as String?,
      questionVersionId: freezed == questionVersionId
          ? _value.questionVersionId
          : questionVersionId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionStemModelImplCopyWith<$Res>
    implements $QuestionStemModelCopyWith<$Res> {
  factory _$$QuestionStemModelImplCopyWith(_$QuestionStemModelImpl value,
          $Res Function(_$QuestionStemModelImpl) then) =
      __$$QuestionStemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? sort,
      String? content,
      String? option,
      String? answer,
      @JsonKey(name: 'question_version_id')
      @DynamicToStringConverter()
      String? questionVersionId});
}

/// @nodoc
class __$$QuestionStemModelImplCopyWithImpl<$Res>
    extends _$QuestionStemModelCopyWithImpl<$Res, _$QuestionStemModelImpl>
    implements _$$QuestionStemModelImplCopyWith<$Res> {
  __$$QuestionStemModelImplCopyWithImpl(_$QuestionStemModelImpl _value,
      $Res Function(_$QuestionStemModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sort = freezed,
    Object? content = freezed,
    Object? option = freezed,
    Object? answer = freezed,
    Object? questionVersionId = freezed,
  }) {
    return _then(_$QuestionStemModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sort: freezed == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      option: freezed == option
          ? _value.option
          : option // ignore: cast_nullable_to_non_nullable
              as String?,
      answer: freezed == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as String?,
      questionVersionId: freezed == questionVersionId
          ? _value.questionVersionId
          : questionVersionId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionStemModelImpl implements _QuestionStemModel {
  const _$QuestionStemModelImpl(
      {required this.id,
      this.sort,
      this.content,
      this.option,
      this.answer,
      @JsonKey(name: 'question_version_id')
      @DynamicToStringConverter()
      this.questionVersionId});

  factory _$QuestionStemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionStemModelImplFromJson(json);

  @override
  final String id;
  @override
  final String? sort;
  @override
  final String? content;
// 题干内容
  @override
  final String? option;
// 选项 JSON字符串
  @override
  final String? answer;
// 答案 JSON字符串
// ✅ question_version_id 后端可能返回 int 或 String，使用转换器
  @override
  @JsonKey(name: 'question_version_id')
  @DynamicToStringConverter()
  final String? questionVersionId;

  @override
  String toString() {
    return 'QuestionStemModel(id: $id, sort: $sort, content: $content, option: $option, answer: $answer, questionVersionId: $questionVersionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionStemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sort, sort) || other.sort == sort) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.option, option) || other.option == option) &&
            (identical(other.answer, answer) || other.answer == answer) &&
            (identical(other.questionVersionId, questionVersionId) ||
                other.questionVersionId == questionVersionId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, sort, content, option, answer, questionVersionId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionStemModelImplCopyWith<_$QuestionStemModelImpl> get copyWith =>
      __$$QuestionStemModelImplCopyWithImpl<_$QuestionStemModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionStemModelImplToJson(
      this,
    );
  }
}

abstract class _QuestionStemModel implements QuestionStemModel {
  const factory _QuestionStemModel(
      {required final String id,
      final String? sort,
      final String? content,
      final String? option,
      final String? answer,
      @JsonKey(name: 'question_version_id')
      @DynamicToStringConverter()
      final String? questionVersionId}) = _$QuestionStemModelImpl;

  factory _QuestionStemModel.fromJson(Map<String, dynamic> json) =
      _$QuestionStemModelImpl.fromJson;

  @override
  String get id;
  @override
  String? get sort;
  @override
  String? get content;
  @override // 题干内容
  String? get option;
  @override // 选项 JSON字符串
  String? get answer;
  @override // 答案 JSON字符串
// ✅ question_version_id 后端可能返回 int 或 String，使用转换器
  @JsonKey(name: 'question_version_id')
  @DynamicToStringConverter()
  String? get questionVersionId;
  @override
  @JsonKey(ignore: true)
  _$$QuestionStemModelImplCopyWith<_$QuestionStemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CollectionListResponse _$CollectionListResponseFromJson(
    Map<String, dynamic> json) {
  return _CollectionListResponse.fromJson(json);
}

/// @nodoc
mixin _$CollectionListResponse {
  List<CollectionQuestionModel> get list => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CollectionListResponseCopyWith<CollectionListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollectionListResponseCopyWith<$Res> {
  factory $CollectionListResponseCopyWith(CollectionListResponse value,
          $Res Function(CollectionListResponse) then) =
      _$CollectionListResponseCopyWithImpl<$Res, CollectionListResponse>;
  @useResult
  $Res call({List<CollectionQuestionModel> list, int total});
}

/// @nodoc
class _$CollectionListResponseCopyWithImpl<$Res,
        $Val extends CollectionListResponse>
    implements $CollectionListResponseCopyWith<$Res> {
  _$CollectionListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      list: null == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<CollectionQuestionModel>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CollectionListResponseImplCopyWith<$Res>
    implements $CollectionListResponseCopyWith<$Res> {
  factory _$$CollectionListResponseImplCopyWith(
          _$CollectionListResponseImpl value,
          $Res Function(_$CollectionListResponseImpl) then) =
      __$$CollectionListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<CollectionQuestionModel> list, int total});
}

/// @nodoc
class __$$CollectionListResponseImplCopyWithImpl<$Res>
    extends _$CollectionListResponseCopyWithImpl<$Res,
        _$CollectionListResponseImpl>
    implements _$$CollectionListResponseImplCopyWith<$Res> {
  __$$CollectionListResponseImplCopyWithImpl(
      _$CollectionListResponseImpl _value,
      $Res Function(_$CollectionListResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? total = null,
  }) {
    return _then(_$CollectionListResponseImpl(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<CollectionQuestionModel>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CollectionListResponseImpl implements _CollectionListResponse {
  const _$CollectionListResponseImpl(
      {required final List<CollectionQuestionModel> list, required this.total})
      : _list = list;

  factory _$CollectionListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CollectionListResponseImplFromJson(json);

  final List<CollectionQuestionModel> _list;
  @override
  List<CollectionQuestionModel> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  final int total;

  @override
  String toString() {
    return 'CollectionListResponse(list: $list, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectionListResponseImpl &&
            const DeepCollectionEquality().equals(other._list, _list) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_list), total);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CollectionListResponseImplCopyWith<_$CollectionListResponseImpl>
      get copyWith => __$$CollectionListResponseImplCopyWithImpl<
          _$CollectionListResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CollectionListResponseImplToJson(
      this,
    );
  }
}

abstract class _CollectionListResponse implements CollectionListResponse {
  const factory _CollectionListResponse(
      {required final List<CollectionQuestionModel> list,
      required final int total}) = _$CollectionListResponseImpl;

  factory _CollectionListResponse.fromJson(Map<String, dynamic> json) =
      _$CollectionListResponseImpl.fromJson;

  @override
  List<CollectionQuestionModel> get list;
  @override
  int get total;
  @override
  @JsonKey(ignore: true)
  _$$CollectionListResponseImplCopyWith<_$CollectionListResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CollectionGroupModel {
  String get typeName => throw _privateConstructorUsedError; // 题型名称
  List<CollectionQuestionModel> get questions =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CollectionGroupModelCopyWith<CollectionGroupModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollectionGroupModelCopyWith<$Res> {
  factory $CollectionGroupModelCopyWith(CollectionGroupModel value,
          $Res Function(CollectionGroupModel) then) =
      _$CollectionGroupModelCopyWithImpl<$Res, CollectionGroupModel>;
  @useResult
  $Res call({String typeName, List<CollectionQuestionModel> questions});
}

/// @nodoc
class _$CollectionGroupModelCopyWithImpl<$Res,
        $Val extends CollectionGroupModel>
    implements $CollectionGroupModelCopyWith<$Res> {
  _$CollectionGroupModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? typeName = null,
    Object? questions = null,
  }) {
    return _then(_value.copyWith(
      typeName: null == typeName
          ? _value.typeName
          : typeName // ignore: cast_nullable_to_non_nullable
              as String,
      questions: null == questions
          ? _value.questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<CollectionQuestionModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CollectionGroupModelImplCopyWith<$Res>
    implements $CollectionGroupModelCopyWith<$Res> {
  factory _$$CollectionGroupModelImplCopyWith(_$CollectionGroupModelImpl value,
          $Res Function(_$CollectionGroupModelImpl) then) =
      __$$CollectionGroupModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String typeName, List<CollectionQuestionModel> questions});
}

/// @nodoc
class __$$CollectionGroupModelImplCopyWithImpl<$Res>
    extends _$CollectionGroupModelCopyWithImpl<$Res, _$CollectionGroupModelImpl>
    implements _$$CollectionGroupModelImplCopyWith<$Res> {
  __$$CollectionGroupModelImplCopyWithImpl(_$CollectionGroupModelImpl _value,
      $Res Function(_$CollectionGroupModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? typeName = null,
    Object? questions = null,
  }) {
    return _then(_$CollectionGroupModelImpl(
      typeName: null == typeName
          ? _value.typeName
          : typeName // ignore: cast_nullable_to_non_nullable
              as String,
      questions: null == questions
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<CollectionQuestionModel>,
    ));
  }
}

/// @nodoc

class _$CollectionGroupModelImpl implements _CollectionGroupModel {
  const _$CollectionGroupModelImpl(
      {required this.typeName,
      required final List<CollectionQuestionModel> questions})
      : _questions = questions;

  @override
  final String typeName;
// 题型名称
  final List<CollectionQuestionModel> _questions;
// 题型名称
  @override
  List<CollectionQuestionModel> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  String toString() {
    return 'CollectionGroupModel(typeName: $typeName, questions: $questions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectionGroupModelImpl &&
            (identical(other.typeName, typeName) ||
                other.typeName == typeName) &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, typeName, const DeepCollectionEquality().hash(_questions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CollectionGroupModelImplCopyWith<_$CollectionGroupModelImpl>
      get copyWith =>
          __$$CollectionGroupModelImplCopyWithImpl<_$CollectionGroupModelImpl>(
              this, _$identity);
}

abstract class _CollectionGroupModel implements CollectionGroupModel {
  const factory _CollectionGroupModel(
          {required final String typeName,
          required final List<CollectionQuestionModel> questions}) =
      _$CollectionGroupModelImpl;

  @override
  String get typeName;
  @override // 题型名称
  List<CollectionQuestionModel> get questions;
  @override
  @JsonKey(ignore: true)
  _$$CollectionGroupModelImplCopyWith<_$CollectionGroupModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
