// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      token: json['token'] as String,
      studentId: json['student_id'] as String,
      studentName: json['student_name'] as String?,
      nickname: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
      merchants: (json['merchant'] as List<dynamic>?)
          ?.map((e) => MerchantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      employeeInfo: json['employee_info'] == null
          ? null
          : EmployeeInfoModel.fromJson(
              json['employee_info'] as Map<String, dynamic>),
      majors: (json['major'] as List<dynamic>?)
          ?.map((e) => MajorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'student_id': instance.studentId,
      'student_name': instance.studentName,
      'nickname': instance.nickname,
      'avatar': instance.avatar,
      'phone': instance.phone,
      'merchant': instance.merchants,
      'employee_info': instance.employeeInfo,
      'major': instance.majors,
    };

_$MajorModelImpl _$$MajorModelImplFromJson(Map<String, dynamic> json) =>
    _$MajorModelImpl(
      majorId: json['major_id'] as String,
      majorName: json['major_name'] as String,
      majorCode: json['major_code'] as String?,
      majorLogo: json['major_logo'] as String?,
    );

Map<String, dynamic> _$$MajorModelImplToJson(_$MajorModelImpl instance) =>
    <String, dynamic>{
      'major_id': instance.majorId,
      'major_name': instance.majorName,
      'major_code': instance.majorCode,
      'major_logo': instance.majorLogo,
    };

_$MerchantModelImpl _$$MerchantModelImplFromJson(Map<String, dynamic> json) =>
    _$MerchantModelImpl(
      merchantId: json['merchant_id'] as String,
      merchantName: json['merchant_name'] as String,
      brandId: json['brand_id'] as String?,
      brandName: json['brand_name'] as String?,
    );

Map<String, dynamic> _$$MerchantModelImplToJson(_$MerchantModelImpl instance) =>
    <String, dynamic>{
      'merchant_id': instance.merchantId,
      'merchant_name': instance.merchantName,
      'brand_id': instance.brandId,
      'brand_name': instance.brandName,
    };

_$EmployeeInfoModelImpl _$$EmployeeInfoModelImplFromJson(
        Map<String, dynamic> json) =>
    _$EmployeeInfoModelImpl(
      employeeId: json['employee_id'],
      postName: json['post_name'] as String?,
      orgName: json['org_name'] as String?,
    );

Map<String, dynamic> _$$EmployeeInfoModelImplToJson(
        _$EmployeeInfoModelImpl instance) =>
    <String, dynamic>{
      'employee_id': instance.employeeId,
      'post_name': instance.postName,
      'org_name': instance.orgName,
    };

_$WechatLoginResponseImpl _$$WechatLoginResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$WechatLoginResponseImpl(
      token: json['token'] as String,
      studentId: json['student_id'] as String,
      studentName: json['student_name'] as String?,
      nickname: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
      merchants: (json['merchant'] as List<dynamic>?)
          ?.map((e) => MerchantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      employeeInfo: json['employee_info'] == null
          ? null
          : EmployeeInfoModel.fromJson(
              json['employee_info'] as Map<String, dynamic>),
      majorId: json['major_id'],
      majorName: json['major_name'] as String?,
      employeeId: json['employee_id'],
      isRealName: json['is_real_name'],
      promoterId: json['promoter_id'] as String?,
      promoterType: json['promoter_type'],
      isNew: json['is_new'],
    );

Map<String, dynamic> _$$WechatLoginResponseImplToJson(
        _$WechatLoginResponseImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'student_id': instance.studentId,
      'student_name': instance.studentName,
      'nickname': instance.nickname,
      'avatar': instance.avatar,
      'phone': instance.phone,
      'merchant': instance.merchants,
      'employee_info': instance.employeeInfo,
      'major_id': instance.majorId,
      'major_name': instance.majorName,
      'employee_id': instance.employeeId,
      'is_real_name': instance.isRealName,
      'promoter_id': instance.promoterId,
      'promoter_type': instance.promoterType,
      'is_new': instance.isNew,
    };

_$UserInfoModelImpl _$$UserInfoModelImplFromJson(Map<String, dynamic> json) =>
    _$UserInfoModelImpl(
      studentId: json['student_id'] as String,
      studentName: json['student_name'] as String?,
      nickname: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
      merchants: (json['merchant'] as List<dynamic>?)
          ?.map((e) => MerchantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      employeeInfo: json['employee_info'] == null
          ? null
          : EmployeeInfoModel.fromJson(
              json['employee_info'] as Map<String, dynamic>),
      majors: (json['major'] as List<dynamic>?)
          ?.map((e) => MajorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$UserInfoModelImplToJson(_$UserInfoModelImpl instance) =>
    <String, dynamic>{
      'student_id': instance.studentId,
      'student_name': instance.studentName,
      'nickname': instance.nickname,
      'avatar': instance.avatar,
      'phone': instance.phone,
      'merchant': instance.merchants,
      'employee_info': instance.employeeInfo,
      'major': instance.majors,
    };
