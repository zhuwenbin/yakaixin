import 'package:freezed_annotation/freezed_annotation.dart';

part 'paper_model.freezed.dart';
part 'paper_model.g.dart';

/// 试卷模型
/// 对应小程序: pages/test/exam.vue 的 paper 接口返回
@freezed
class PaperModel with _$PaperModel {
  const factory PaperModel({
    @JsonKey(name: 'id') dynamic id, // 试卷ID
    @JsonKey(name: 'name') String? name, // 试卷名称
    @JsonKey(name: 'paper_exercise_id') String? paperExerciseId, // 试卷答题记录ID ('0'表示未答题)
  }) = _PaperModel;

  factory PaperModel.fromJson(Map<String, dynamic> json) => _$PaperModelFromJson(json);
}

/// 章节试卷模型
/// 对应小程序: pages/test/exam.vue 的 chapterpaper 接口返回
@freezed
class ChapterPaperModel with _$ChapterPaperModel {
  const factory ChapterPaperModel({
    @JsonKey(name: 'name') String? name, // 章节名称
    @JsonKey(name: 'list') @Default([]) List<PaperModel> list, // 试卷列表
  }) = _ChapterPaperModel;

  factory ChapterPaperModel.fromJson(Map<String, dynamic> json) => _$ChapterPaperModelFromJson(json);
}
