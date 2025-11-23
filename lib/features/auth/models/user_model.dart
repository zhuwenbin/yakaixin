import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// 用户Model
/// 对应小程序: src/store/index.js - userinfo
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String token,
    @JsonKey(name: 'student_id') required String studentId,
    @JsonKey(name: 'student_name') String? studentName,
    String? nickname,
    String? avatar,
    String? phone,
    @JsonKey(name: 'merchant') List<MerchantModel>? merchants,
    @JsonKey(name: 'employee_info') EmployeeInfoModel? employeeInfo,
    @JsonKey(name: 'major') List<MajorModel>? majors,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

/// 专业Model
/// 对应小程序: src/store/index.js - majorInfo
@freezed
class MajorModel with _$MajorModel {
  const factory MajorModel({
    @JsonKey(name: 'major_id') required String majorId,
    @JsonKey(name: 'major_name') required String majorName,
    @JsonKey(name: 'major_code') String? majorCode,
    @JsonKey(name: 'major_logo') String? majorLogo,
  }) = _MajorModel;

  factory MajorModel.fromJson(Map<String, dynamic> json) =>
      _$MajorModelFromJson(json);
}

/// 商家Model
@freezed
class MerchantModel with _$MerchantModel {
  const factory MerchantModel({
    @JsonKey(name: 'merchant_id') required String merchantId,
    @JsonKey(name: 'merchant_name') required String merchantName,
    @JsonKey(name: 'brand_id') String? brandId,
    @JsonKey(name: 'brand_name') String? brandName,
  }) = _MerchantModel;

  factory MerchantModel.fromJson(Map<String, dynamic> json) =>
      _$MerchantModelFromJson(json);
}

/// 员工信息Model
@freezed
class EmployeeInfoModel with _$EmployeeInfoModel {
  const factory EmployeeInfoModel({
    @JsonKey(name: 'employee_id') int? employeeId,  // 注意:返回的是数字类型
    @JsonKey(name: 'post_name') String? postName,
    @JsonKey(name: 'org_name') String? orgName,
  }) = _EmployeeInfoModel;

  factory EmployeeInfoModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeInfoModelFromJson(json);
}

/// 微信登录响应Model
/// 对应小程序: src/modules/jintiku/api/index.js - smslogin
/// 注意:小程序返回的是扁平结构,直接包含所有字段
/// 
/// Mock数据参考: lib/features/auth/mock/login_mock_data.dart
@freezed
class WechatLoginResponse with _$WechatLoginResponse {
  const factory WechatLoginResponse({
    required String token,
    @JsonKey(name: 'student_id') required String studentId,
    @JsonKey(name: 'student_name') String? studentName,
    String? nickname,
    String? avatar,
    String? phone,
    @JsonKey(name: 'merchant') List<MerchantModel>? merchants,
    @JsonKey(name: 'employee_info') EmployeeInfoModel? employeeInfo,
    @JsonKey(name: 'major_id') dynamic majorId,  // 可能是int或String,因为数值可能超过int范围
    @JsonKey(name: 'major_name') String? majorName,
    @JsonKey(name: 'employee_id') int? employeeId,  // 注意:返回的是数字类型
    @JsonKey(name: 'is_real_name') int? isRealName,
    @JsonKey(name: 'promoter_id') String? promoterId,
    @JsonKey(name: 'promoter_type') int? promoterType,
    @JsonKey(name: 'is_new') int? isNew,
  }) = _WechatLoginResponse;

  factory WechatLoginResponse.fromJson(Map<String, dynamic> json) =>
      _$WechatLoginResponseFromJson(json);
}

/// 用户信息Model (登录响应中的userinfo)
@freezed
class UserInfoModel with _$UserInfoModel {
  const factory UserInfoModel({
    @JsonKey(name: 'student_id') required String studentId,
    @JsonKey(name: 'student_name') String? studentName,
    String? nickname,
    String? avatar,
    String? phone,
    @JsonKey(name: 'merchant') List<MerchantModel>? merchants,
    @JsonKey(name: 'employee_info') EmployeeInfoModel? employeeInfo,
    @JsonKey(name: 'major') List<MajorModel>? majors,
  }) = _UserInfoModel;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfoModelFromJson(json);
}
