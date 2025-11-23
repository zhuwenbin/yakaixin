import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../../app/config/api_config.dart';
import '../models/user_model.dart';

/// 认证服务
/// 对应小程序: src/modules/jintiku/api/index.js
class AuthService {
  final DioClient _dioClient;

  AuthService(this._dioClient);

  /// 微信登录
  /// 对应小程序: Login接口
  /// POST /api/auth/login
  Future<WechatLoginResponse> login({
    required String wxopenid,
    String? account,
    String? password,
    String? majorId,
  }) async {
    final response = await _dioClient.post(
      '/auth/login',
      data: {
        'merchant_id': ApiConfig.merchantId,
        'brand_id': ApiConfig.brandId,
        'channel_id': ApiConfig.channelId,
        'wxopenid': wxopenid,
        if (account != null) 'account': account,
        if (password != null) 'password': password,
        if (majorId != null) 'major_id': majorId,
      },
    );

    // 响应格式已在拦截器中统一处理
    return WechatLoginResponse.fromJson(response.data['data']);
  }

  /// 获取微信Code
  /// 对应小程序: getCode接口
  /// POST /api/wechat/getCode
  Future<Map<String, dynamic>> getWechatCode({
    required String code,
    String? majorId,
  }) async {
    final response = await _dioClient.post(
      '/wechat/getCode',
      data: {
        'app_id': ApiConfig.wechatAppId,
        'code': code,
        if (majorId != null) 'major_id': majorId,
      },
    );

    // 响应格式已在拦截器中统一处理
    return response.data['data'];
  }

  /// 获取手机号
  /// 对应小程序: getPhone接口
  /// POST /api/wechat/getPhone
  Future<String> getPhone({
    required String code,
  }) async {
    final response = await _dioClient.post(
      '/wechat/getPhone',
      data: {
        'app_id': ApiConfig.wechatAppId,
        'code': code,
      },
    );

    // 响应格式已在拦截器中统一处理
    return response.data['data']['phone'];
  }

  /// 发送验证码
  /// 对应小程序: sendCode接口 (src/modules/jintiku/api/h5Active.js)
  /// POST /c/base/sms/sendcode
  Future<void> sendVerifyCode({
    required String phone,
  }) async {
    await _dioClient.post(
      '/c/base/sms/sendcode',
      data: {
        'phone': phone,
        'scene': 2, // 2=登录验证码 (对应小程序login-h5.vue)
      },
    );
    // 响应格式已在拦截器中统一处理,成功则无异常
  }

  /// 验证码登录
  /// 对应小程序: smslogin接口 (src/modules/jintiku/api/index.js)
  /// POST /c/student/smslogin
  Future<WechatLoginResponse> loginWithSms({
    required String phone,
    required String code,
    String? majorId,
  }) async {
    final response = await _dioClient.post(
      '/c/student/smslogin',
      data: {
        'phone': phone,
        'code': code,
        'merchant_id': ApiConfig.merchantId,
        'brand_id': ApiConfig.brandId,
        'channel_id': ApiConfig.channelId,
        'extendu_id': ApiConfig.extendUid,
        'need_employee_info': 1, // 需要员工信息
        if (majorId != null) 'major_id': majorId,
      },
    );

    // 响应格式已在拦截器中统一处理
    return WechatLoginResponse.fromJson(response.data['data']);
  }
}

/// AuthService Provider
final authServiceProvider = Provider<AuthService>((ref) {
  final dioClient = ref.read(dioClientProvider);
  return AuthService(dioClient);
});
