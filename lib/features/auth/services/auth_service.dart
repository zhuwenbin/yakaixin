import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
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

  /// 密码登录
  /// 对应后台新接口: POST /c/student/login
  /// 请求格式: x-www-form-urlencoded
  Future<WechatLoginResponse> loginWithPassword({
    required String account,
    required String password,
    String? majorId,
  }) async {
    print('\n📡 [密码登录] 发起请求...');
    print('📞 [account] $account');
    print('🔑 [password] ${password.replaceAll(RegExp(r'.'), '*')}');
    print('🎯 [majorId] $majorId');
    
    final response = await _dioClient.post(
      '/c/student/login',
      data: {
        'account': account,
        'passwd': password,
        'scene': 1, // 场景值：1-密码登录
        // ✅ 必选参数 - 对照小程序
        'merchant_id': ApiConfig.merchantId,
        'brand_id': ApiConfig.brandId,
        'channel_id': ApiConfig.channelId,
        'extendu_id': ApiConfig.extendUid,
        'need_employee_info': 1, // 需要员工信息
        if (majorId != null) 'major_id': majorId,
      },
    );

    print('✅ [登录响应] 接口返回成功');
    print('📦 [response.data] \${response.data}');
    
    // 响应格式已在拦截器中统一处理
    final loginData = WechatLoginResponse.fromJson(response.data['data']);
    
    print('✅ [登录数据] 解析成功');
    print('   - token: \${loginData.token.substring(0, 20)}...');
    print('   - studentId: \${loginData.studentId}');
    print('   - major_id: \${loginData.majorId} (类型: \${loginData.majorId.runtimeType})');
    print('   - major_name: \${loginData.majorName}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    
    return loginData;
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
        'app_id': ApiConfig.wechatMiniProgramAppId,
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
        'app_id': ApiConfig.wechatMiniProgramAppId,
        'code': code,
      },
    );

    // 响应格式已在拦截器中统一处理
    return response.data['data']['phone'];
  }

  /// 发送验证码
  /// 对应小程序: sendCode接口 (src/modules/jintiku/api/h5Active.js)
  /// 发送验证码
  /// POST /c/base/sms/sendcode
  /// 
  /// scene参数说明:
  /// - 2: 登录验证码
  /// - 3: 修改密码验证码
  Future<void> sendVerifyCode({
    required String phone,
    int scene = 2, // 默认为登录场景
  }) async {
    print('\n📧 [发送验证码] 发起请求...');
    print('📞 [phone] $phone');
    print('🎯 [scene] $scene (2=登录, 3=修改密码)');
    
    try {
      final response = await _dioClient.post(
        '/c/base/sms/sendcode',
        data: {
          'phone': phone,
          'scene': scene,
        },
      );
      
      print('✅ [验证码响应] 接口返回成功');
      print('📦 [response.data] ${response.data}');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      // 响应格式已在拦截器中统一处理,成功则无异常
    } on DioException catch (e) {
      print('\n❌ [发送验证码] 网络错误');
      print('📍 错误类型: ${e.type}');
      print('📍 错误信息: ${e.message}');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      
      // ✅ 根据错误类型返回用户友好的提示
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
          throw Exception('连接超时，请检查网络后重试');
        case DioExceptionType.receiveTimeout:
          throw Exception('服务器响应超时，请稍后重试');
        case DioExceptionType.badResponse:
          final statusCode = e.response?.statusCode ?? 0;
          throw Exception('服务器错误($statusCode)，请稍后重试');
        case DioExceptionType.cancel:
          throw Exception('请求已取消');
        case DioExceptionType.connectionError:
          throw Exception('网络连接失败，请检查网络设置');
        default:
          throw Exception('网络请求失败: ${e.message}');
      }
    } catch (e) {
      print('\n❌ [发送验证码] 未知错误: $e');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      rethrow;
    }
  }

  /// 验证码登录
  /// 对应小程序: smslogin接口 (src/modules/jintiku/api/index.js)
  /// POST /c/student/smslogin
  Future<WechatLoginResponse> loginWithSms({
    required String phone,
    required String code,
    String? majorId,
  }) async {
    print('\n📡 [登录请求] 发起验证码登录...');
    print('📞 [phone] $phone');
    print('🔑 [code] $code');
    print('🎯 [majorId] $majorId');
    
    final response = await _dioClient.post(
      '/c/student/smslogin',
      data: {
        'phone': phone,
        'code': code,
        // ✅ 必选参数 - 对照小程序 (login-h5.vue:164-175)
        'merchant_id': ApiConfig.merchantId,
        'brand_id': ApiConfig.brandId,
        'channel_id': ApiConfig.channelId,
        'extendu_id': ApiConfig.extendUid,
        'need_employee_info': 1, // 需要员工信息
        if (majorId != null) 'major_id': majorId,
      },
    );

    print('✅ [登录响应] 接口返回成功');
    print('📦 [response.data] ${response.data}');
    
    // 响应格式已在拦截器中统一处理
    final loginData = WechatLoginResponse.fromJson(response.data['data']);
    
    print('✅ [登录数据] 解析成功');
    print('   - token: ${loginData.token.substring(0, 20)}...');
    print('   - studentId: ${loginData.studentId}');
    print('   - major_id: ${loginData.majorId} (类型: ${loginData.majorId.runtimeType})');
    print('   - major_name: ${loginData.majorName}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    
    return loginData;
  }
  
  /// 重置密码
  /// 接口: POST /c/student/resetpassword
  /// TODO: 等待后端实现，暂时使用占位接口
  Future<void> resetPassword({
    required String phone,
    required String code,
    required String newPassword,
  }) async {
    print('\n🔐 [重置密码] 发起请求...');
    print('📞 [phone] $phone');
    print('🔑 [code] $code');
    
    await _dioClient.post(
      '/c/student/resetpassword',
      data: {
        'phone': phone,
        'code': code,
        'password': newPassword,
      },
    );
    
    print('✅ [重置密码] 操作成功');
  }
  
  /// 修改密码（通过验证码）
  /// 接口: PUT /c/student/reset/passwd
  /// form格式：phone, verification_code, new_passwd, confirm_passwd
  Future<void> changePassword({
    required String phone,
    required String code,
    required String newPassword,
  }) async {
    print('\n🔐 [修改密码] 发起请求...');
    print('📞 [phone] $phone');
    print('🔑 [code] $code');
    
    await _dioClient.put(
      '/c/student/reset/passwd',  // ✅ 修复：去掉开头的 /api
      data: {
        'phone': phone,
        'verification_code': code,
        'new_passwd': newPassword,
        'confirm_passwd': newPassword,
      },
      options: Options(
        contentType: 'application/x-www-form-urlencoded',
      ),
    );
    
    print('✅ [修改密码] 操作成功');
  }
}

/// AuthService Provider
final authServiceProvider = Provider<AuthService>((ref) {
  final dioClient = ref.read(dioClientProvider);
  return AuthService(dioClient);
});
