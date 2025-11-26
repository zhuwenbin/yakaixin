import 'package:freezed_annotation/freezed_annotation.dart';

part 'exam_paper_model.freezed.dart';
part 'exam_paper_model.g.dart';

/// 考试商品信息
@freezed
class ExamGoodsInfo with _$ExamGoodsInfo {
  const factory ExamGoodsInfo({
    required String id,
    required String name,
    @Default('') String year,
    @JsonKey(name: 'material_intro_path') @Default('') String materialIntroPath,
    @JsonKey(name: 'num_text') @Default('') String numText,
    @Default(8) int type,
    @JsonKey(name: 'professional_id') @Default('') String professionalId,
    @JsonKey(name: 'permission_order_id') @Default('') String permissionOrderId,
    @JsonKey(name: 'permission_status') @Default('0') String permissionStatus,
    @JsonKey(name: 'data_type') @Default('1') String dataType, // 1-普通试卷 3-章节试卷
    @JsonKey(name: 'tiku_goods_details') required ExamGoodsDetail tikuGoodsDetails,
  }) = _ExamGoodsInfo;

  factory ExamGoodsInfo.fromJson(Map<String, dynamic> json) =>
      _$ExamGoodsInfoFromJson(json);
}

/// 考试商品详情
@freezed
class ExamGoodsDetail with _$ExamGoodsDetail {
  const factory ExamGoodsDetail({
    @JsonKey(name: 'question_num') @Default(0) int questionNum,
    @JsonKey(name: 'paper_num') @Default(0) int paperNum,
    @JsonKey(name: 'exam_round_num') @Default(0) int examRoundNum,
    @JsonKey(name: 'exam_time') @Default('') String examTime,
  }) = _ExamGoodsDetail;

  factory ExamGoodsDetail.fromJson(Map<String, dynamic> json) =>
      _$ExamGoodsDetailFromJson(json);
}

/// 试卷信息
@freezed
class ExamPaper with _$ExamPaper {
  const factory ExamPaper({
    required String id,
    required String name,
    @JsonKey(name: 'paper_exercise_id') @Default('0') String paperExerciseId,
  }) = _ExamPaper;

  factory ExamPaper.fromJson(Map<String, dynamic> json) =>
      _$ExamPaperFromJson(json);
}

/// 章节试卷分组
@freezed
class ChapterPaperGroup with _$ChapterPaperGroup {
  const factory ChapterPaperGroup({
    required String name,
    @Default([]) List<ExamPaper> list,
  }) = _ChapterPaperGroup;

  factory ChapterPaperGroup.fromJson(Map<String, dynamic> json) =>
      _$ChapterPaperGroupFromJson(json);
}
