import 'package:freezed_annotation/freezed_annotation.dart';

part 'score_report_model.freezed.dart';
part 'score_report_model.g.dart';

/// 成绩报告Model
/// 对应小程序: getScorereporting 接口返回
/// 接口: GET /c/tiku/exam/scorereporting/list
@freezed
class ScoreReportModel with _$ScoreReportModel {
  const factory ScoreReportModel({
    /// 考试名称
    @JsonKey(name: 'examination_name') String? examinationName,

    /// 交卷时间
    @JsonKey(name: 'hand_paper_time') String? handPaperTime,

    /// 是否及格 (1-及格, 其他-不及格)
    @JsonKey(name: 'is_pass') String? isPass,

    /// 试卷版本ID
    @JsonKey(name: 'paper_version_id') String? paperVersionId,

    /// 排名
    dynamic rank,

    /// 成绩
    dynamic score,
  }) = _ScoreReportModel;

  factory ScoreReportModel.fromJson(Map<String, dynamic> json) =>
      _$ScoreReportModelFromJson(json);
}
