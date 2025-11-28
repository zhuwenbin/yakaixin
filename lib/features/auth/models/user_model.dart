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
/// ⚠️ employee_id 可能是 String（如"0"）或 int，使用 dynamic
@freezed
class EmployeeInfoModel with _$EmployeeInfoModel {
  const factory EmployeeInfoModel({
    @JsonKey(name: 'employee_id') dynamic employeeId,  // ⚠️ String或int，兼容"0"和0
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
/// 
/// ⚠️ 关键字段类型说明（基于真实API响应 2025-01-27）:
/// - major_id: 可能是 String（大数值如"524033912737962623"）或 int，使用 dynamic
/// - employee_id: 可能是 String（如"0"）或 int，使用 dynamic
/// - is_real_name: 可能是 String（如"2"）或 int，使用 dynamic
/// - promoter_type: 可能是 String（如"2"）或 int，使用 dynamic
/// - is_new: 可能是 String（如"0"）或 int，使用 dynamic
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
    @JsonKey(name: 'major_id') dynamic majorId,  // ⚠️ String或int，大数值使用String
    @JsonKey(name: 'major_name') String? majorName,
    @JsonKey(name: 'employee_id') dynamic employeeId,  // ⚠️ String或int，兼容"0"和0
    @JsonKey(name: 'is_real_name') dynamic isRealName,  // ⚠️ String或int，兼容"2"和2
    @JsonKey(name: 'promoter_id') String? promoterId,
    @JsonKey(name: 'promoter_type') dynamic promoterType,  // ⚠️ String或int，兼容"2"和2
    @JsonKey(name: 'is_new') dynamic isNew,  // ⚠️ String或int，兼容"0"和0
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
