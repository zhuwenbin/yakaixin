import 'package:freezed_annotation/freezed_annotation.dart';

part 'major_model.freezed.dart';
part 'major_model.g.dart';

/// 专业数据模型
/// 对应小程序: select-major.vue
@freezed
class MajorModel with _$MajorModel {
  const factory MajorModel({
    required String id,
    @JsonKey(name: 'data_name') required String dataName,
    @JsonKey(name: 'level') String? level,
    @JsonKey(name: 'subs') @Default([]) List<MajorModel> subs,
  }) = _MajorModel;

  factory MajorModel.fromJson(Map<String, dynamic> json) =>
      _$MajorModelFromJson(json);
}

/// 专业列表响应
@freezed
class MajorListResponse with _$MajorListResponse {
  const factory MajorListResponse({
    @Default([]) List<MajorModel> list,
  }) = _MajorListResponse;

  factory MajorListResponse.fromJson(Map<String, dynamic> json) {
    // 直接将 data 数组转换为 list
    final data = json['data'] as List?;
    return MajorListResponse(
      list: data?.map((e) => MajorModel.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    );
  }
}

/// 当前选择的专业信息（存储）
@freezed
class CurrentMajor with _$CurrentMajor {
  const factory CurrentMajor({
    @JsonKey(name: 'major_id') required String majorId,
    @JsonKey(name: 'major_name') required String majorName,
    @JsonKey(name: 'major_pid_level') String? majorPidLevel,
  }) = _CurrentMajor;

  factory CurrentMajor.fromJson(Map<String, dynamic> json) =>
      _$CurrentMajorFromJson(json);
}
