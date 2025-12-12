// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScoreReportModelImpl _$$ScoreReportModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ScoreReportModelImpl(
      examinationName: json['examination_name'] as String?,
      handPaperTime: json['hand_paper_time'] as String?,
      isPass: json['is_pass'] as String?,
      paperVersionId: json['paper_version_id'] as String?,
      rank: json['rank'],
      score: json['score'],
    );

Map<String, dynamic> _$$ScoreReportModelImplToJson(
        _$ScoreReportModelImpl instance) =>
    <String, dynamic>{
      'examination_name': instance.examinationName,
      'hand_paper_time': instance.handPaperTime,
      'is_pass': instance.isPass,
      'paper_version_id': instance.paperVersionId,
      'rank': instance.rank,
      'score': instance.score,
    };
