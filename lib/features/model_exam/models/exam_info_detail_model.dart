import 'package:freezed_annotation/freezed_annotation.dart';

part 'exam_info_detail_model.freezed.dart';
part 'exam_info_detail_model.g.dart';

/// 模考详情响应 Model
/// 对应小程序: examInfo.vue getExaminfoDetail 返回的 data
@freezed
class ExamInfoDetailModel with _$ExamInfoDetailModel {
  const factory ExamInfoDetailModel({
    /// 模考信息
    @JsonKey(name: 'mock_exam') required MockExamModel mockExam,
    
    /// 考试轮次列表
    @JsonKey(name: 'mock_exam_details') required List<ExamRoundModel> examRounds,
    
    /// 报名人数
    @JsonKey(name: 'sign_up_count') @Default('0') String signUpCount,
    
    /// 模考状态
    @JsonKey(name: 'mock_status') @Default('') String mockStatus,
    
    /// 模考状态名称
    @JsonKey(name: 'mock_status_name') @Default('') String mockStatusName,
    
    /// 其他模考列表
    @JsonKey(name: 'mock_list') @Default([]) List<MockExamListItemModel> mockList,
  }) = _ExamInfoDetailModel;

  factory ExamInfoDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ExamInfoDetailModelFromJson(json);
}

/// 模考信息 Model
/// 对应小程序: examInfo.vue currentInfo
@freezed
class MockExamModel with _$MockExamModel {
  const factory MockExamModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'professional_id') @Default('') String professionalId,
    @JsonKey(name: 'start_time') @Default('') String startTime,
    @JsonKey(name: 'end_time') @Default('') String endTime,
    @JsonKey(name: 'mock_name') @Default('') String mockName,
  }) = _MockExamModel;

  factory MockExamModel.fromJson(Map<String, dynamic> json) =>
      _$MockExamModelFromJson(json);
}

/// 考试轮次 Model
/// 对应小程序: examInfo.vue exam_rounds 数组项
@freezed
class ExamRoundModel with _$ExamRoundModel {
  const factory ExamRoundModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'mock_id') @Default('') String mockId,
    @JsonKey(name: 'exam_round_name') @Default('') String examRoundName,
    @JsonKey(name: 'start_time') @Default('') String startTime,
    @JsonKey(name: 'end_time') @Default('') String endTime,
    @JsonKey(name: 'status') @Default('') String status, // 1-进行中, 2-未报名, 3-已完成, 4-补考未开启, 5-补考
    @JsonKey(name: 'status_name') @Default('') String statusName,
    @JsonKey(name: 'btn_is_enable') @Default('1') String btnIsEnable, // 1-可操作, 2-不可操作
    @JsonKey(name: 'exam_paper_id') @Default('') String examPaperId,
    @JsonKey(name: 'subject_name') @Default('') String subjectName,
  }) = _ExamRoundModel;

  factory ExamRoundModel.fromJson(Map<String, dynamic> json) =>
      _$ExamRoundModelFromJson(json);
}

/// 其他模考列表项 Model
/// 对应小程序: examInfo.vue list 数组项
@freezed
class MockExamListItemModel with _$MockExamListItemModel {
  const factory MockExamListItemModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'mock_name') @Default('') String mockName,
    @JsonKey(name: 'start_time') @Default('') String startTime,
  }) = _MockExamListItemModel;

  factory MockExamListItemModel.fromJson(Map<String, dynamic> json) =>
      _$MockExamListItemModelFromJson(json);
}

