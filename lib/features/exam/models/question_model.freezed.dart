// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) {
  return _QuestionModel.fromJson(json);
}

/// @nodoc
mixin _$QuestionModel {
  /// 题目版本ID（question_version_id）
  /// ⚠️ 关键：提交答案时使用此字段作为 question_id 参数
  /// 对应接口返回的 section_info[i].id （如 582238838496170019）
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;

  /// 题目引用ID（question_id）
  /// ⚠️ 注意：此字段只用于数据库关联，不用于提交答案
  /// 对应接口返回的 section_info[i].question_id （如 582238836886474787）
  @JsonKey(name: 'question_id')
  String? get questionId => throw _privateConstructorUsedError;

  /// 练习ID
  @JsonKey(name: 'practice_id')
  String? get practiceId => throw _privateConstructorUsedError;

  /// 专业ID
  @JsonKey(name: 'professional_id')
  String? get professionalId => throw _privateConstructorUsedError;

  /// 章节ID
  @JsonKey(name: 'chapter_id')
  String? get chapterId => throw _privateConstructorUsedError;

  /// 知识点IDs
  @JsonKey(name: 'knowledge_ids')
  List<String>? get knowledgeIds => throw _privateConstructorUsedError;

  /// 知识点名称
  @JsonKey(name: 'knowledge_ids_name')
  List<String>? get knowledgeIdsName => throw _privateConstructorUsedError;

  /// 题干（主题型题目）
  @JsonKey(name: 'thematic_stem')
  String? get thematicStem => throw _privateConstructorUsedError;

  /// 题型 (1-单选, 2-多选, 3-判断, 8-填空, 9-简答, 10-论述)
  @JsonKey(name: 'type')
  String get type => throw _privateConstructorUsedError;

  /// 题型名称
  @JsonKey(name: 'type_name')
  String? get typeName => throw _privateConstructorUsedError;

  /// 难度等级
  @JsonKey(name: 'level')
  String? get level => throw _privateConstructorUsedError;

  /// 年份
  @JsonKey(name: 'year')
  String? get year => throw _privateConstructorUsedError;

  /// 错误率
  @JsonKey(name: 'err_rate')
  String? get errRate => throw _privateConstructorUsedError;

  /// 版本
  @JsonKey(name: 'version')
  String? get version => throw _privateConstructorUsedError;

  /// 解析（HTML格式）
  @JsonKey(name: 'parse')
  String? get parse => throw _privateConstructorUsedError;

  /// 子题列表
  @JsonKey(name: 'stem_list')
  List<SubQuestionModel> get stemList => throw _privateConstructorUsedError;

  /// 章节详情ID
  @JsonKey(name: 'chapter_detail_id')
  String? get chapterDetailId => throw _privateConstructorUsedError;

  /// 是否已答
  @JsonKey(name: 'is_answer')
  String? get isAnswer => throw _privateConstructorUsedError;

  /// 用户选项（逗号分隔，如 "1,2"）
  @JsonKey(name: 'user_option')
  String? get userOption => throw _privateConstructorUsedError;

  /// 答题状态 (0-未答, 1-已答)
  @JsonKey(name: 'answer_status')
  String? get answerStatus => throw _privateConstructorUsedError;

  /// 批改状态
  @JsonKey(name: 'check_status')
  String? get checkStatus => throw _privateConstructorUsedError;

  /// 题目统计信息
  @JsonKey(name: 'question_statistics_info')
  QuestionStatisticsModel? get questionStatisticsInfo =>
      throw _privateConstructorUsedError;

  /// 是否标疑（Flutter本地字段，不从API返回）
  bool get doubt => throw _privateConstructorUsedError;

  /// 题号（Flutter本地字段）
  int get questionNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuestionModelCopyWith<QuestionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionModelCopyWith<$Res> {
  factory $QuestionModelCopyWith(
          QuestionModel value, $Res Function(QuestionModel) then) =
      _$QuestionModelCopyWithImpl<$Res, QuestionModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'question_id') String? questionId,
      @JsonKey(name: 'practice_id') String? practiceId,
      @JsonKey(name: 'professional_id') String? professionalId,
      @JsonKey(name: 'chapter_id') String? chapterId,
      @JsonKey(name: 'knowledge_ids') List<String>? knowledgeIds,
      @JsonKey(name: 'knowledge_ids_name') List<String>? knowledgeIdsName,
      @JsonKey(name: 'thematic_stem') String? thematicStem,
      @JsonKey(name: 'type') String type,
      @JsonKey(name: 'type_name') String? typeName,
      @JsonKey(name: 'level') String? level,
      @JsonKey(name: 'year') String? year,
      @JsonKey(name: 'err_rate') String? errRate,
      @JsonKey(name: 'version') String? version,
      @JsonKey(name: 'parse') String? parse,
      @JsonKey(name: 'stem_list') List<SubQuestionModel> stemList,
      @JsonKey(name: 'chapter_detail_id') String? chapterDetailId,
      @JsonKey(name: 'is_answer') String? isAnswer,
      @JsonKey(name: 'user_option') String? userOption,
      @JsonKey(name: 'answer_status') String? answerStatus,
      @JsonKey(name: 'check_status') String? checkStatus,
      @JsonKey(name: 'question_statistics_info')
      QuestionStatisticsModel? questionStatisticsInfo,
      bool doubt,
      int questionNumber});

  $QuestionStatisticsModelCopyWith<$Res>? get questionStatisticsInfo;
}

/// @nodoc
class _$QuestionModelCopyWithImpl<$Res, $Val extends QuestionModel>
    implements $QuestionModelCopyWith<$Res> {
  _$QuestionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? questionId = freezed,
    Object? practiceId = freezed,
    Object? professionalId = freezed,
    Object? chapterId = freezed,
    Object? knowledgeIds = freezed,
    Object? knowledgeIdsName = freezed,
    Object? thematicStem = freezed,
    Object? type = null,
    Object? typeName = freezed,
    Object? level = freezed,
    Object? year = freezed,
    Object? errRate = freezed,
    Object? version = freezed,
    Object? parse = freezed,
    Object? stemList = null,
    Object? chapterDetailId = freezed,
    Object? isAnswer = freezed,
    Object? userOption = freezed,
    Object? answerStatus = freezed,
    Object? checkStatus = freezed,
    Object? questionStatisticsInfo = freezed,
    Object? doubt = null,
    Object? questionNumber = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      questionId: freezed == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      knowledgeIds: freezed == knowledgeIds
          ? _value.knowledgeIds
          : knowledgeIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      knowledgeIdsName: freezed == knowledgeIdsName
          ? _value.knowledgeIdsName
          : knowledgeIdsName // ignore: cast_nullable_to_non_nullable
              as List<String>?,
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
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
      year: freezed == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as String?,
      errRate: freezed == errRate
          ? _value.errRate
          : errRate // ignore: cast_nullable_to_non_nullable
              as String?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      parse: freezed == parse
          ? _value.parse
          : parse // ignore: cast_nullable_to_non_nullable
              as String?,
      stemList: null == stemList
          ? _value.stemList
          : stemList // ignore: cast_nullable_to_non_nullable
              as List<SubQuestionModel>,
      chapterDetailId: freezed == chapterDetailId
          ? _value.chapterDetailId
          : chapterDetailId // ignore: cast_nullable_to_non_nullable
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
      checkStatus: freezed == checkStatus
          ? _value.checkStatus
          : checkStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      questionStatisticsInfo: freezed == questionStatisticsInfo
          ? _value.questionStatisticsInfo
          : questionStatisticsInfo // ignore: cast_nullable_to_non_nullable
              as QuestionStatisticsModel?,
      doubt: null == doubt
          ? _value.doubt
          : doubt // ignore: cast_nullable_to_non_nullable
              as bool,
      questionNumber: null == questionNumber
          ? _value.questionNumber
          : questionNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $QuestionStatisticsModelCopyWith<$Res>? get questionStatisticsInfo {
    if (_value.questionStatisticsInfo == null) {
      return null;
    }

    return $QuestionStatisticsModelCopyWith<$Res>(
        _value.questionStatisticsInfo!, (value) {
      return _then(_value.copyWith(questionStatisticsInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuestionModelImplCopyWith<$Res>
    implements $QuestionModelCopyWith<$Res> {
  factory _$$QuestionModelImplCopyWith(
          _$QuestionModelImpl value, $Res Function(_$QuestionModelImpl) then) =
      __$$QuestionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'question_id') String? questionId,
      @JsonKey(name: 'practice_id') String? practiceId,
      @JsonKey(name: 'professional_id') String? professionalId,
      @JsonKey(name: 'chapter_id') String? chapterId,
      @JsonKey(name: 'knowledge_ids') List<String>? knowledgeIds,
      @JsonKey(name: 'knowledge_ids_name') List<String>? knowledgeIdsName,
      @JsonKey(name: 'thematic_stem') String? thematicStem,
      @JsonKey(name: 'type') String type,
      @JsonKey(name: 'type_name') String? typeName,
      @JsonKey(name: 'level') String? level,
      @JsonKey(name: 'year') String? year,
      @JsonKey(name: 'err_rate') String? errRate,
      @JsonKey(name: 'version') String? version,
      @JsonKey(name: 'parse') String? parse,
      @JsonKey(name: 'stem_list') List<SubQuestionModel> stemList,
      @JsonKey(name: 'chapter_detail_id') String? chapterDetailId,
      @JsonKey(name: 'is_answer') String? isAnswer,
      @JsonKey(name: 'user_option') String? userOption,
      @JsonKey(name: 'answer_status') String? answerStatus,
      @JsonKey(name: 'check_status') String? checkStatus,
      @JsonKey(name: 'question_statistics_info')
      QuestionStatisticsModel? questionStatisticsInfo,
      bool doubt,
      int questionNumber});

  @override
  $QuestionStatisticsModelCopyWith<$Res>? get questionStatisticsInfo;
}

/// @nodoc
class __$$QuestionModelImplCopyWithImpl<$Res>
    extends _$QuestionModelCopyWithImpl<$Res, _$QuestionModelImpl>
    implements _$$QuestionModelImplCopyWith<$Res> {
  __$$QuestionModelImplCopyWithImpl(
      _$QuestionModelImpl _value, $Res Function(_$QuestionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? questionId = freezed,
    Object? practiceId = freezed,
    Object? professionalId = freezed,
    Object? chapterId = freezed,
    Object? knowledgeIds = freezed,
    Object? knowledgeIdsName = freezed,
    Object? thematicStem = freezed,
    Object? type = null,
    Object? typeName = freezed,
    Object? level = freezed,
    Object? year = freezed,
    Object? errRate = freezed,
    Object? version = freezed,
    Object? parse = freezed,
    Object? stemList = null,
    Object? chapterDetailId = freezed,
    Object? isAnswer = freezed,
    Object? userOption = freezed,
    Object? answerStatus = freezed,
    Object? checkStatus = freezed,
    Object? questionStatisticsInfo = freezed,
    Object? doubt = null,
    Object? questionNumber = null,
  }) {
    return _then(_$QuestionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      questionId: freezed == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      knowledgeIds: freezed == knowledgeIds
          ? _value._knowledgeIds
          : knowledgeIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      knowledgeIdsName: freezed == knowledgeIdsName
          ? _value._knowledgeIdsName
          : knowledgeIdsName // ignore: cast_nullable_to_non_nullable
              as List<String>?,
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
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
      year: freezed == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as String?,
      errRate: freezed == errRate
          ? _value.errRate
          : errRate // ignore: cast_nullable_to_non_nullable
              as String?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      parse: freezed == parse
          ? _value.parse
          : parse // ignore: cast_nullable_to_non_nullable
              as String?,
      stemList: null == stemList
          ? _value._stemList
          : stemList // ignore: cast_nullable_to_non_nullable
              as List<SubQuestionModel>,
      chapterDetailId: freezed == chapterDetailId
          ? _value.chapterDetailId
          : chapterDetailId // ignore: cast_nullable_to_non_nullable
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
      checkStatus: freezed == checkStatus
          ? _value.checkStatus
          : checkStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      questionStatisticsInfo: freezed == questionStatisticsInfo
          ? _value.questionStatisticsInfo
          : questionStatisticsInfo // ignore: cast_nullable_to_non_nullable
              as QuestionStatisticsModel?,
      doubt: null == doubt
          ? _value.doubt
          : doubt // ignore: cast_nullable_to_non_nullable
              as bool,
      questionNumber: null == questionNumber
          ? _value.questionNumber
          : questionNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionModelImpl implements _QuestionModel {
  const _$QuestionModelImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'question_id') this.questionId,
      @JsonKey(name: 'practice_id') this.practiceId,
      @JsonKey(name: 'professional_id') this.professionalId,
      @JsonKey(name: 'chapter_id') this.chapterId,
      @JsonKey(name: 'knowledge_ids') final List<String>? knowledgeIds,
      @JsonKey(name: 'knowledge_ids_name') final List<String>? knowledgeIdsName,
      @JsonKey(name: 'thematic_stem') this.thematicStem,
      @JsonKey(name: 'type') required this.type,
      @JsonKey(name: 'type_name') this.typeName,
      @JsonKey(name: 'level') this.level,
      @JsonKey(name: 'year') this.year,
      @JsonKey(name: 'err_rate') this.errRate,
      @JsonKey(name: 'version') this.version,
      @JsonKey(name: 'parse') this.parse,
      @JsonKey(name: 'stem_list')
      required final List<SubQuestionModel> stemList,
      @JsonKey(name: 'chapter_detail_id') this.chapterDetailId,
      @JsonKey(name: 'is_answer') this.isAnswer,
      @JsonKey(name: 'user_option') this.userOption,
      @JsonKey(name: 'answer_status') this.answerStatus,
      @JsonKey(name: 'check_status') this.checkStatus,
      @JsonKey(name: 'question_statistics_info') this.questionStatisticsInfo,
      this.doubt = false,
      this.questionNumber = 0})
      : _knowledgeIds = knowledgeIds,
        _knowledgeIdsName = knowledgeIdsName,
        _stemList = stemList;

  factory _$QuestionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionModelImplFromJson(json);

  /// 题目版本ID（question_version_id）
  /// ⚠️ 关键：提交答案时使用此字段作为 question_id 参数
  /// 对应接口返回的 section_info[i].id （如 582238838496170019）
  @override
  @JsonKey(name: 'id')
  final String id;

  /// 题目引用ID（question_id）
  /// ⚠️ 注意：此字段只用于数据库关联，不用于提交答案
  /// 对应接口返回的 section_info[i].question_id （如 582238836886474787）
  @override
  @JsonKey(name: 'question_id')
  final String? questionId;

  /// 练习ID
  @override
  @JsonKey(name: 'practice_id')
  final String? practiceId;

  /// 专业ID
  @override
  @JsonKey(name: 'professional_id')
  final String? professionalId;

  /// 章节ID
  @override
  @JsonKey(name: 'chapter_id')
  final String? chapterId;

  /// 知识点IDs
  final List<String>? _knowledgeIds;

  /// 知识点IDs
  @override
  @JsonKey(name: 'knowledge_ids')
  List<String>? get knowledgeIds {
    final value = _knowledgeIds;
    if (value == null) return null;
    if (_knowledgeIds is EqualUnmodifiableListView) return _knowledgeIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// 知识点名称
  final List<String>? _knowledgeIdsName;

  /// 知识点名称
  @override
  @JsonKey(name: 'knowledge_ids_name')
  List<String>? get knowledgeIdsName {
    final value = _knowledgeIdsName;
    if (value == null) return null;
    if (_knowledgeIdsName is EqualUnmodifiableListView)
      return _knowledgeIdsName;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// 题干（主题型题目）
  @override
  @JsonKey(name: 'thematic_stem')
  final String? thematicStem;

  /// 题型 (1-单选, 2-多选, 3-判断, 8-填空, 9-简答, 10-论述)
  @override
  @JsonKey(name: 'type')
  final String type;

  /// 题型名称
  @override
  @JsonKey(name: 'type_name')
  final String? typeName;

  /// 难度等级
  @override
  @JsonKey(name: 'level')
  final String? level;

  /// 年份
  @override
  @JsonKey(name: 'year')
  final String? year;

  /// 错误率
  @override
  @JsonKey(name: 'err_rate')
  final String? errRate;

  /// 版本
  @override
  @JsonKey(name: 'version')
  final String? version;

  /// 解析（HTML格式）
  @override
  @JsonKey(name: 'parse')
  final String? parse;

  /// 子题列表
  final List<SubQuestionModel> _stemList;

  /// 子题列表
  @override
  @JsonKey(name: 'stem_list')
  List<SubQuestionModel> get stemList {
    if (_stemList is EqualUnmodifiableListView) return _stemList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stemList);
  }

  /// 章节详情ID
  @override
  @JsonKey(name: 'chapter_detail_id')
  final String? chapterDetailId;

  /// 是否已答
  @override
  @JsonKey(name: 'is_answer')
  final String? isAnswer;

  /// 用户选项（逗号分隔，如 "1,2"）
  @override
  @JsonKey(name: 'user_option')
  final String? userOption;

  /// 答题状态 (0-未答, 1-已答)
  @override
  @JsonKey(name: 'answer_status')
  final String? answerStatus;

  /// 批改状态
  @override
  @JsonKey(name: 'check_status')
  final String? checkStatus;

  /// 题目统计信息
  @override
  @JsonKey(name: 'question_statistics_info')
  final QuestionStatisticsModel? questionStatisticsInfo;

  /// 是否标疑（Flutter本地字段，不从API返回）
  @override
  @JsonKey()
  final bool doubt;

  /// 题号（Flutter本地字段）
  @override
  @JsonKey()
  final int questionNumber;

  @override
  String toString() {
    return 'QuestionModel(id: $id, questionId: $questionId, practiceId: $practiceId, professionalId: $professionalId, chapterId: $chapterId, knowledgeIds: $knowledgeIds, knowledgeIdsName: $knowledgeIdsName, thematicStem: $thematicStem, type: $type, typeName: $typeName, level: $level, year: $year, errRate: $errRate, version: $version, parse: $parse, stemList: $stemList, chapterDetailId: $chapterDetailId, isAnswer: $isAnswer, userOption: $userOption, answerStatus: $answerStatus, checkStatus: $checkStatus, questionStatisticsInfo: $questionStatisticsInfo, doubt: $doubt, questionNumber: $questionNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.practiceId, practiceId) ||
                other.practiceId == practiceId) &&
            (identical(other.professionalId, professionalId) ||
                other.professionalId == professionalId) &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId) &&
            const DeepCollectionEquality()
                .equals(other._knowledgeIds, _knowledgeIds) &&
            const DeepCollectionEquality()
                .equals(other._knowledgeIdsName, _knowledgeIdsName) &&
            (identical(other.thematicStem, thematicStem) ||
                other.thematicStem == thematicStem) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.typeName, typeName) ||
                other.typeName == typeName) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.errRate, errRate) || other.errRate == errRate) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.parse, parse) || other.parse == parse) &&
            const DeepCollectionEquality().equals(other._stemList, _stemList) &&
            (identical(other.chapterDetailId, chapterDetailId) ||
                other.chapterDetailId == chapterDetailId) &&
            (identical(other.isAnswer, isAnswer) ||
                other.isAnswer == isAnswer) &&
            (identical(other.userOption, userOption) ||
                other.userOption == userOption) &&
            (identical(other.answerStatus, answerStatus) ||
                other.answerStatus == answerStatus) &&
            (identical(other.checkStatus, checkStatus) ||
                other.checkStatus == checkStatus) &&
            (identical(other.questionStatisticsInfo, questionStatisticsInfo) ||
                other.questionStatisticsInfo == questionStatisticsInfo) &&
            (identical(other.doubt, doubt) || other.doubt == doubt) &&
            (identical(other.questionNumber, questionNumber) ||
                other.questionNumber == questionNumber));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        questionId,
        practiceId,
        professionalId,
        chapterId,
        const DeepCollectionEquality().hash(_knowledgeIds),
        const DeepCollectionEquality().hash(_knowledgeIdsName),
        thematicStem,
        type,
        typeName,
        level,
        year,
        errRate,
        version,
        parse,
        const DeepCollectionEquality().hash(_stemList),
        chapterDetailId,
        isAnswer,
        userOption,
        answerStatus,
        checkStatus,
        questionStatisticsInfo,
        doubt,
        questionNumber
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionModelImplCopyWith<_$QuestionModelImpl> get copyWith =>
      __$$QuestionModelImplCopyWithImpl<_$QuestionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionModelImplToJson(
      this,
    );
  }
}

abstract class _QuestionModel implements QuestionModel {
  const factory _QuestionModel(
      {@JsonKey(name: 'id') required final String id,
      @JsonKey(name: 'question_id') final String? questionId,
      @JsonKey(name: 'practice_id') final String? practiceId,
      @JsonKey(name: 'professional_id') final String? professionalId,
      @JsonKey(name: 'chapter_id') final String? chapterId,
      @JsonKey(name: 'knowledge_ids') final List<String>? knowledgeIds,
      @JsonKey(name: 'knowledge_ids_name') final List<String>? knowledgeIdsName,
      @JsonKey(name: 'thematic_stem') final String? thematicStem,
      @JsonKey(name: 'type') required final String type,
      @JsonKey(name: 'type_name') final String? typeName,
      @JsonKey(name: 'level') final String? level,
      @JsonKey(name: 'year') final String? year,
      @JsonKey(name: 'err_rate') final String? errRate,
      @JsonKey(name: 'version') final String? version,
      @JsonKey(name: 'parse') final String? parse,
      @JsonKey(name: 'stem_list')
      required final List<SubQuestionModel> stemList,
      @JsonKey(name: 'chapter_detail_id') final String? chapterDetailId,
      @JsonKey(name: 'is_answer') final String? isAnswer,
      @JsonKey(name: 'user_option') final String? userOption,
      @JsonKey(name: 'answer_status') final String? answerStatus,
      @JsonKey(name: 'check_status') final String? checkStatus,
      @JsonKey(name: 'question_statistics_info')
      final QuestionStatisticsModel? questionStatisticsInfo,
      final bool doubt,
      final int questionNumber}) = _$QuestionModelImpl;

  factory _QuestionModel.fromJson(Map<String, dynamic> json) =
      _$QuestionModelImpl.fromJson;

  @override

  /// 题目版本ID（question_version_id）
  /// ⚠️ 关键：提交答案时使用此字段作为 question_id 参数
  /// 对应接口返回的 section_info[i].id （如 582238838496170019）
  @JsonKey(name: 'id')
  String get id;
  @override

  /// 题目引用ID（question_id）
  /// ⚠️ 注意：此字段只用于数据库关联，不用于提交答案
  /// 对应接口返回的 section_info[i].question_id （如 582238836886474787）
  @JsonKey(name: 'question_id')
  String? get questionId;
  @override

  /// 练习ID
  @JsonKey(name: 'practice_id')
  String? get practiceId;
  @override

  /// 专业ID
  @JsonKey(name: 'professional_id')
  String? get professionalId;
  @override

  /// 章节ID
  @JsonKey(name: 'chapter_id')
  String? get chapterId;
  @override

  /// 知识点IDs
  @JsonKey(name: 'knowledge_ids')
  List<String>? get knowledgeIds;
  @override

  /// 知识点名称
  @JsonKey(name: 'knowledge_ids_name')
  List<String>? get knowledgeIdsName;
  @override

  /// 题干（主题型题目）
  @JsonKey(name: 'thematic_stem')
  String? get thematicStem;
  @override

  /// 题型 (1-单选, 2-多选, 3-判断, 8-填空, 9-简答, 10-论述)
  @JsonKey(name: 'type')
  String get type;
  @override

  /// 题型名称
  @JsonKey(name: 'type_name')
  String? get typeName;
  @override

  /// 难度等级
  @JsonKey(name: 'level')
  String? get level;
  @override

  /// 年份
  @JsonKey(name: 'year')
  String? get year;
  @override

  /// 错误率
  @JsonKey(name: 'err_rate')
  String? get errRate;
  @override

  /// 版本
  @JsonKey(name: 'version')
  String? get version;
  @override

  /// 解析（HTML格式）
  @JsonKey(name: 'parse')
  String? get parse;
  @override

  /// 子题列表
  @JsonKey(name: 'stem_list')
  List<SubQuestionModel> get stemList;
  @override

  /// 章节详情ID
  @JsonKey(name: 'chapter_detail_id')
  String? get chapterDetailId;
  @override

  /// 是否已答
  @JsonKey(name: 'is_answer')
  String? get isAnswer;
  @override

  /// 用户选项（逗号分隔，如 "1,2"）
  @JsonKey(name: 'user_option')
  String? get userOption;
  @override

  /// 答题状态 (0-未答, 1-已答)
  @JsonKey(name: 'answer_status')
  String? get answerStatus;
  @override

  /// 批改状态
  @JsonKey(name: 'check_status')
  String? get checkStatus;
  @override

  /// 题目统计信息
  @JsonKey(name: 'question_statistics_info')
  QuestionStatisticsModel? get questionStatisticsInfo;
  @override

  /// 是否标疑（Flutter本地字段，不从API返回）
  bool get doubt;
  @override

  /// 题号（Flutter本地字段）
  int get questionNumber;
  @override
  @JsonKey(ignore: true)
  _$$QuestionModelImplCopyWith<_$QuestionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SubQuestionModel _$SubQuestionModelFromJson(Map<String, dynamic> json) {
  return _SubQuestionModel.fromJson(json);
}

/// @nodoc
mixin _$SubQuestionModel {
  /// 子题ID
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;

  /// 排序
  @JsonKey(name: 'sort')
  String? get sort => throw _privateConstructorUsedError;

  /// 题干内容（HTML格式）
  @JsonKey(name: 'content')
  String get content => throw _privateConstructorUsedError;

  /// 选项（JSON字符串数组，如 '["选项A", "选项B"]'）
  @JsonKey(name: 'option')
  String? get option => throw _privateConstructorUsedError;

  /// 正确答案（JSON字符串数组，如 '["1", "2"]'）
  @JsonKey(name: 'answer')
  String? get answer => throw _privateConstructorUsedError;

  /// 题目版本ID
  @JsonKey(name: 'question_version_id')
  String? get questionVersionId => throw _privateConstructorUsedError;

  /// 用户选择的答案（Flutter本地字段，List<String>）
  List<String> get selected => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SubQuestionModelCopyWith<SubQuestionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubQuestionModelCopyWith<$Res> {
  factory $SubQuestionModelCopyWith(
          SubQuestionModel value, $Res Function(SubQuestionModel) then) =
      _$SubQuestionModelCopyWithImpl<$Res, SubQuestionModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'sort') String? sort,
      @JsonKey(name: 'content') String content,
      @JsonKey(name: 'option') String? option,
      @JsonKey(name: 'answer') String? answer,
      @JsonKey(name: 'question_version_id') String? questionVersionId,
      List<String> selected});
}

/// @nodoc
class _$SubQuestionModelCopyWithImpl<$Res, $Val extends SubQuestionModel>
    implements $SubQuestionModelCopyWith<$Res> {
  _$SubQuestionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sort = freezed,
    Object? content = null,
    Object? option = freezed,
    Object? answer = freezed,
    Object? questionVersionId = freezed,
    Object? selected = null,
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
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
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
      selected: null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubQuestionModelImplCopyWith<$Res>
    implements $SubQuestionModelCopyWith<$Res> {
  factory _$$SubQuestionModelImplCopyWith(_$SubQuestionModelImpl value,
          $Res Function(_$SubQuestionModelImpl) then) =
      __$$SubQuestionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'sort') String? sort,
      @JsonKey(name: 'content') String content,
      @JsonKey(name: 'option') String? option,
      @JsonKey(name: 'answer') String? answer,
      @JsonKey(name: 'question_version_id') String? questionVersionId,
      List<String> selected});
}

/// @nodoc
class __$$SubQuestionModelImplCopyWithImpl<$Res>
    extends _$SubQuestionModelCopyWithImpl<$Res, _$SubQuestionModelImpl>
    implements _$$SubQuestionModelImplCopyWith<$Res> {
  __$$SubQuestionModelImplCopyWithImpl(_$SubQuestionModelImpl _value,
      $Res Function(_$SubQuestionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sort = freezed,
    Object? content = null,
    Object? option = freezed,
    Object? answer = freezed,
    Object? questionVersionId = freezed,
    Object? selected = null,
  }) {
    return _then(_$SubQuestionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sort: freezed == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
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
      selected: null == selected
          ? _value._selected
          : selected // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubQuestionModelImpl implements _SubQuestionModel {
  const _$SubQuestionModelImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'sort') this.sort,
      @JsonKey(name: 'content') required this.content,
      @JsonKey(name: 'option') this.option,
      @JsonKey(name: 'answer') this.answer,
      @JsonKey(name: 'question_version_id') this.questionVersionId,
      final List<String> selected = const []})
      : _selected = selected;

  factory _$SubQuestionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubQuestionModelImplFromJson(json);

  /// 子题ID
  @override
  @JsonKey(name: 'id')
  final String id;

  /// 排序
  @override
  @JsonKey(name: 'sort')
  final String? sort;

  /// 题干内容（HTML格式）
  @override
  @JsonKey(name: 'content')
  final String content;

  /// 选项（JSON字符串数组，如 '["选项A", "选项B"]'）
  @override
  @JsonKey(name: 'option')
  final String? option;

  /// 正确答案（JSON字符串数组，如 '["1", "2"]'）
  @override
  @JsonKey(name: 'answer')
  final String? answer;

  /// 题目版本ID
  @override
  @JsonKey(name: 'question_version_id')
  final String? questionVersionId;

  /// 用户选择的答案（Flutter本地字段，List<String>）
  final List<String> _selected;

  /// 用户选择的答案（Flutter本地字段，List<String>）
  @override
  @JsonKey()
  List<String> get selected {
    if (_selected is EqualUnmodifiableListView) return _selected;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selected);
  }

  @override
  String toString() {
    return 'SubQuestionModel(id: $id, sort: $sort, content: $content, option: $option, answer: $answer, questionVersionId: $questionVersionId, selected: $selected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubQuestionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sort, sort) || other.sort == sort) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.option, option) || other.option == option) &&
            (identical(other.answer, answer) || other.answer == answer) &&
            (identical(other.questionVersionId, questionVersionId) ||
                other.questionVersionId == questionVersionId) &&
            const DeepCollectionEquality().equals(other._selected, _selected));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sort,
      content,
      option,
      answer,
      questionVersionId,
      const DeepCollectionEquality().hash(_selected));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SubQuestionModelImplCopyWith<_$SubQuestionModelImpl> get copyWith =>
      __$$SubQuestionModelImplCopyWithImpl<_$SubQuestionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubQuestionModelImplToJson(
      this,
    );
  }
}

abstract class _SubQuestionModel implements SubQuestionModel {
  const factory _SubQuestionModel(
      {@JsonKey(name: 'id') required final String id,
      @JsonKey(name: 'sort') final String? sort,
      @JsonKey(name: 'content') required final String content,
      @JsonKey(name: 'option') final String? option,
      @JsonKey(name: 'answer') final String? answer,
      @JsonKey(name: 'question_version_id') final String? questionVersionId,
      final List<String> selected}) = _$SubQuestionModelImpl;

  factory _SubQuestionModel.fromJson(Map<String, dynamic> json) =
      _$SubQuestionModelImpl.fromJson;

  @override

  /// 子题ID
  @JsonKey(name: 'id')
  String get id;
  @override

  /// 排序
  @JsonKey(name: 'sort')
  String? get sort;
  @override

  /// 题干内容（HTML格式）
  @JsonKey(name: 'content')
  String get content;
  @override

  /// 选项（JSON字符串数组，如 '["选项A", "选项B"]'）
  @JsonKey(name: 'option')
  String? get option;
  @override

  /// 正确答案（JSON字符串数组，如 '["1", "2"]'）
  @JsonKey(name: 'answer')
  String? get answer;
  @override

  /// 题目版本ID
  @JsonKey(name: 'question_version_id')
  String? get questionVersionId;
  @override

  /// 用户选择的答案（Flutter本地字段，List<String>）
  List<String> get selected;
  @override
  @JsonKey(ignore: true)
  _$$SubQuestionModelImplCopyWith<_$SubQuestionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuestionStatisticsModel _$QuestionStatisticsModelFromJson(
    Map<String, dynamic> json) {
  return _QuestionStatisticsModel.fromJson(json);
}

/// @nodoc
mixin _$QuestionStatisticsModel {
  /// 做题数量
  @JsonKey(name: 'doQuestionNum')
  String? get doQuestionNum => throw _privateConstructorUsedError;

  /// 正确率
  @JsonKey(name: 'accuracy')
  String? get accuracy => throw _privateConstructorUsedError;

  /// 错误选项
  @JsonKey(name: 'errorOption')
  String? get errorOption => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuestionStatisticsModelCopyWith<QuestionStatisticsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionStatisticsModelCopyWith<$Res> {
  factory $QuestionStatisticsModelCopyWith(QuestionStatisticsModel value,
          $Res Function(QuestionStatisticsModel) then) =
      _$QuestionStatisticsModelCopyWithImpl<$Res, QuestionStatisticsModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'doQuestionNum') String? doQuestionNum,
      @JsonKey(name: 'accuracy') String? accuracy,
      @JsonKey(name: 'errorOption') String? errorOption});
}

/// @nodoc
class _$QuestionStatisticsModelCopyWithImpl<$Res,
        $Val extends QuestionStatisticsModel>
    implements $QuestionStatisticsModelCopyWith<$Res> {
  _$QuestionStatisticsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? doQuestionNum = freezed,
    Object? accuracy = freezed,
    Object? errorOption = freezed,
  }) {
    return _then(_value.copyWith(
      doQuestionNum: freezed == doQuestionNum
          ? _value.doQuestionNum
          : doQuestionNum // ignore: cast_nullable_to_non_nullable
              as String?,
      accuracy: freezed == accuracy
          ? _value.accuracy
          : accuracy // ignore: cast_nullable_to_non_nullable
              as String?,
      errorOption: freezed == errorOption
          ? _value.errorOption
          : errorOption // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionStatisticsModelImplCopyWith<$Res>
    implements $QuestionStatisticsModelCopyWith<$Res> {
  factory _$$QuestionStatisticsModelImplCopyWith(
          _$QuestionStatisticsModelImpl value,
          $Res Function(_$QuestionStatisticsModelImpl) then) =
      __$$QuestionStatisticsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'doQuestionNum') String? doQuestionNum,
      @JsonKey(name: 'accuracy') String? accuracy,
      @JsonKey(name: 'errorOption') String? errorOption});
}

/// @nodoc
class __$$QuestionStatisticsModelImplCopyWithImpl<$Res>
    extends _$QuestionStatisticsModelCopyWithImpl<$Res,
        _$QuestionStatisticsModelImpl>
    implements _$$QuestionStatisticsModelImplCopyWith<$Res> {
  __$$QuestionStatisticsModelImplCopyWithImpl(
      _$QuestionStatisticsModelImpl _value,
      $Res Function(_$QuestionStatisticsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? doQuestionNum = freezed,
    Object? accuracy = freezed,
    Object? errorOption = freezed,
  }) {
    return _then(_$QuestionStatisticsModelImpl(
      doQuestionNum: freezed == doQuestionNum
          ? _value.doQuestionNum
          : doQuestionNum // ignore: cast_nullable_to_non_nullable
              as String?,
      accuracy: freezed == accuracy
          ? _value.accuracy
          : accuracy // ignore: cast_nullable_to_non_nullable
              as String?,
      errorOption: freezed == errorOption
          ? _value.errorOption
          : errorOption // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionStatisticsModelImpl implements _QuestionStatisticsModel {
  const _$QuestionStatisticsModelImpl(
      {@JsonKey(name: 'doQuestionNum') this.doQuestionNum,
      @JsonKey(name: 'accuracy') this.accuracy,
      @JsonKey(name: 'errorOption') this.errorOption});

  factory _$QuestionStatisticsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionStatisticsModelImplFromJson(json);

  /// 做题数量
  @override
  @JsonKey(name: 'doQuestionNum')
  final String? doQuestionNum;

  /// 正确率
  @override
  @JsonKey(name: 'accuracy')
  final String? accuracy;

  /// 错误选项
  @override
  @JsonKey(name: 'errorOption')
  final String? errorOption;

  @override
  String toString() {
    return 'QuestionStatisticsModel(doQuestionNum: $doQuestionNum, accuracy: $accuracy, errorOption: $errorOption)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionStatisticsModelImpl &&
            (identical(other.doQuestionNum, doQuestionNum) ||
                other.doQuestionNum == doQuestionNum) &&
            (identical(other.accuracy, accuracy) ||
                other.accuracy == accuracy) &&
            (identical(other.errorOption, errorOption) ||
                other.errorOption == errorOption));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, doQuestionNum, accuracy, errorOption);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionStatisticsModelImplCopyWith<_$QuestionStatisticsModelImpl>
      get copyWith => __$$QuestionStatisticsModelImplCopyWithImpl<
          _$QuestionStatisticsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionStatisticsModelImplToJson(
      this,
    );
  }
}

abstract class _QuestionStatisticsModel implements QuestionStatisticsModel {
  const factory _QuestionStatisticsModel(
          {@JsonKey(name: 'doQuestionNum') final String? doQuestionNum,
          @JsonKey(name: 'accuracy') final String? accuracy,
          @JsonKey(name: 'errorOption') final String? errorOption}) =
      _$QuestionStatisticsModelImpl;

  factory _QuestionStatisticsModel.fromJson(Map<String, dynamic> json) =
      _$QuestionStatisticsModelImpl.fromJson;

  @override

  /// 做题数量
  @JsonKey(name: 'doQuestionNum')
  String? get doQuestionNum;
  @override

  /// 正确率
  @JsonKey(name: 'accuracy')
  String? get accuracy;
  @override

  /// 错误选项
  @JsonKey(name: 'errorOption')
  String? get errorOption;
  @override
  @JsonKey(ignore: true)
  _$$QuestionStatisticsModelImplCopyWith<_$QuestionStatisticsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ExamInfoModel _$ExamInfoModelFromJson(Map<String, dynamic> json) {
  return _ExamInfoModel.fromJson(json);
}

/// @nodoc
mixin _$ExamInfoModel {
  /// 考试ID
  @JsonKey(name: 'exam_id')
  String? get examId => throw _privateConstructorUsedError;

  /// 考试轮次ID
  @JsonKey(name: 'exam_round_id')
  String? get examRoundId => throw _privateConstructorUsedError;

  /// 开始时间
  @JsonKey(name: 'start_time')
  String? get startTime => throw _privateConstructorUsedError;

  /// 结束时间
  @JsonKey(name: 'end_time')
  String? get endTime => throw _privateConstructorUsedError;

  /// 当前时间
  @JsonKey(name: 'current_time')
  String? get currentTime => throw _privateConstructorUsedError;

  /// 考试状态
  @JsonKey(name: 'status')
  dynamic get status => throw _privateConstructorUsedError;

  /// 考试时长（秒）
  @JsonKey(name: 'duration')
  dynamic get duration => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExamInfoModelCopyWith<ExamInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExamInfoModelCopyWith<$Res> {
  factory $ExamInfoModelCopyWith(
          ExamInfoModel value, $Res Function(ExamInfoModel) then) =
      _$ExamInfoModelCopyWithImpl<$Res, ExamInfoModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'exam_id') String? examId,
      @JsonKey(name: 'exam_round_id') String? examRoundId,
      @JsonKey(name: 'start_time') String? startTime,
      @JsonKey(name: 'end_time') String? endTime,
      @JsonKey(name: 'current_time') String? currentTime,
      @JsonKey(name: 'status') dynamic status,
      @JsonKey(name: 'duration') dynamic duration});
}

/// @nodoc
class _$ExamInfoModelCopyWithImpl<$Res, $Val extends ExamInfoModel>
    implements $ExamInfoModelCopyWith<$Res> {
  _$ExamInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? examId = freezed,
    Object? examRoundId = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? currentTime = freezed,
    Object? status = freezed,
    Object? duration = freezed,
  }) {
    return _then(_value.copyWith(
      examId: freezed == examId
          ? _value.examId
          : examId // ignore: cast_nullable_to_non_nullable
              as String?,
      examRoundId: freezed == examRoundId
          ? _value.examRoundId
          : examRoundId // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String?,
      currentTime: freezed == currentTime
          ? _value.currentTime
          : currentTime // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as dynamic,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExamInfoModelImplCopyWith<$Res>
    implements $ExamInfoModelCopyWith<$Res> {
  factory _$$ExamInfoModelImplCopyWith(
          _$ExamInfoModelImpl value, $Res Function(_$ExamInfoModelImpl) then) =
      __$$ExamInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'exam_id') String? examId,
      @JsonKey(name: 'exam_round_id') String? examRoundId,
      @JsonKey(name: 'start_time') String? startTime,
      @JsonKey(name: 'end_time') String? endTime,
      @JsonKey(name: 'current_time') String? currentTime,
      @JsonKey(name: 'status') dynamic status,
      @JsonKey(name: 'duration') dynamic duration});
}

/// @nodoc
class __$$ExamInfoModelImplCopyWithImpl<$Res>
    extends _$ExamInfoModelCopyWithImpl<$Res, _$ExamInfoModelImpl>
    implements _$$ExamInfoModelImplCopyWith<$Res> {
  __$$ExamInfoModelImplCopyWithImpl(
      _$ExamInfoModelImpl _value, $Res Function(_$ExamInfoModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? examId = freezed,
    Object? examRoundId = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? currentTime = freezed,
    Object? status = freezed,
    Object? duration = freezed,
  }) {
    return _then(_$ExamInfoModelImpl(
      examId: freezed == examId
          ? _value.examId
          : examId // ignore: cast_nullable_to_non_nullable
              as String?,
      examRoundId: freezed == examRoundId
          ? _value.examRoundId
          : examRoundId // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String?,
      currentTime: freezed == currentTime
          ? _value.currentTime
          : currentTime // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as dynamic,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExamInfoModelImpl implements _ExamInfoModel {
  const _$ExamInfoModelImpl(
      {@JsonKey(name: 'exam_id') this.examId,
      @JsonKey(name: 'exam_round_id') this.examRoundId,
      @JsonKey(name: 'start_time') this.startTime,
      @JsonKey(name: 'end_time') this.endTime,
      @JsonKey(name: 'current_time') this.currentTime,
      @JsonKey(name: 'status') this.status,
      @JsonKey(name: 'duration') this.duration});

  factory _$ExamInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExamInfoModelImplFromJson(json);

  /// 考试ID
  @override
  @JsonKey(name: 'exam_id')
  final String? examId;

  /// 考试轮次ID
  @override
  @JsonKey(name: 'exam_round_id')
  final String? examRoundId;

  /// 开始时间
  @override
  @JsonKey(name: 'start_time')
  final String? startTime;

  /// 结束时间
  @override
  @JsonKey(name: 'end_time')
  final String? endTime;

  /// 当前时间
  @override
  @JsonKey(name: 'current_time')
  final String? currentTime;

  /// 考试状态
  @override
  @JsonKey(name: 'status')
  final dynamic status;

  /// 考试时长（秒）
  @override
  @JsonKey(name: 'duration')
  final dynamic duration;

  @override
  String toString() {
    return 'ExamInfoModel(examId: $examId, examRoundId: $examRoundId, startTime: $startTime, endTime: $endTime, currentTime: $currentTime, status: $status, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExamInfoModelImpl &&
            (identical(other.examId, examId) || other.examId == examId) &&
            (identical(other.examRoundId, examRoundId) ||
                other.examRoundId == examRoundId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.currentTime, currentTime) ||
                other.currentTime == currentTime) &&
            const DeepCollectionEquality().equals(other.status, status) &&
            const DeepCollectionEquality().equals(other.duration, duration));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      examId,
      examRoundId,
      startTime,
      endTime,
      currentTime,
      const DeepCollectionEquality().hash(status),
      const DeepCollectionEquality().hash(duration));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExamInfoModelImplCopyWith<_$ExamInfoModelImpl> get copyWith =>
      __$$ExamInfoModelImplCopyWithImpl<_$ExamInfoModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExamInfoModelImplToJson(
      this,
    );
  }
}

abstract class _ExamInfoModel implements ExamInfoModel {
  const factory _ExamInfoModel(
      {@JsonKey(name: 'exam_id') final String? examId,
      @JsonKey(name: 'exam_round_id') final String? examRoundId,
      @JsonKey(name: 'start_time') final String? startTime,
      @JsonKey(name: 'end_time') final String? endTime,
      @JsonKey(name: 'current_time') final String? currentTime,
      @JsonKey(name: 'status') final dynamic status,
      @JsonKey(name: 'duration') final dynamic duration}) = _$ExamInfoModelImpl;

  factory _ExamInfoModel.fromJson(Map<String, dynamic> json) =
      _$ExamInfoModelImpl.fromJson;

  @override

  /// 考试ID
  @JsonKey(name: 'exam_id')
  String? get examId;
  @override

  /// 考试轮次ID
  @JsonKey(name: 'exam_round_id')
  String? get examRoundId;
  @override

  /// 开始时间
  @JsonKey(name: 'start_time')
  String? get startTime;
  @override

  /// 结束时间
  @JsonKey(name: 'end_time')
  String? get endTime;
  @override

  /// 当前时间
  @JsonKey(name: 'current_time')
  String? get currentTime;
  @override

  /// 考试状态
  @JsonKey(name: 'status')
  dynamic get status;
  @override

  /// 考试时长（秒）
  @JsonKey(name: 'duration')
  dynamic get duration;
  @override
  @JsonKey(ignore: true)
  _$$ExamInfoModelImplCopyWith<_$ExamInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
