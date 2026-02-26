import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../../app/config/api_config.dart';

/// 账户删除服务
/// 对应 tiku 项目: 账户删除功能
class AccountDeletionService {
  final DioClient _dioClient;

  AccountDeletionService(this._dioClient);

  /// 验证密码（用于删除账户前的安全验证）
  /// 对应 tiku: SKVerificationViewControlelr - loginWithPassword
  /// 接口: POST /c/student/login
  /// 注意：必须和 AuthService.loginWithPassword 使用相同的参数，确保接口调用一致
  Future<bool> verifyPassword({
    required String account,
    required String password,
  }) async {
    try {
      print('\n🔐 [安全验证] 验证密码...');
      print('📞 [account] $account');
      print('🔑 [password] ${password.replaceAll(RegExp(r'.'), '*')}');
      
      final response = await _dioClient.post(
        '/c/student/login',
        data: {
          'account': account,
          'passwd': password,
          'scene': 1, // 场景值：1-密码登录
          // ✅ 必选参数 - 和 AuthService.loginWithPassword 保持一致
          'merchant_id': ApiConfig.merchantId,
          'brand_id': ApiConfig.brandId,
          'channel_id': ApiConfig.channelId,
          'extendu_id': ApiConfig.extendUid,
          'need_employee_info': 1, // ✅ 需要员工信息（和登录接口保持一致）
        },
      );

      print('✅ [安全验证] 接口响应: code=${response.data['code']}');
      
      // 如果登录成功，说明密码正确
      final isSuccess = response.data['code'] == 100000;
      if (isSuccess) {
        print('✅ [安全验证] 密码验证成功');
      } else {
        print('❌ [安全验证] 密码验证失败: ${response.data['msg']}');
      }
      
      return isSuccess;
    } catch (e) {
      print('❌ [安全验证] 接口调用异常: $e');
      return false;
    }
  }

  // 注意：题库项目中没有实际调用后端删除账户接口
  // 只是显示"注销审核中"提示，然后退出登录
  // 所以这里不需要实现 deleteAccount 方法
}

/// AccountDeletionService Provider
final accountDeletionServiceProvider = Provider<AccountDeletionService>((ref) {
  return AccountDeletionService(ref.read(dioClientProvider));
});
