import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/constants/storage_keys.dart';
import '../../../core/storage/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/toast_util.dart';
import '../../../core/widgets/loading_hud.dart';
import '../../auth/providers/auth_provider.dart';
import '../services/account_deletion_service.dart';

/// 删除账户安全验证页面
/// 对应 tiku: SKVerificationViewControlelr
/// 功能：输入密码验证身份
class DeleteAccountVerificationPage extends ConsumerStatefulWidget {
  const DeleteAccountVerificationPage({super.key});

  @override
  ConsumerState<DeleteAccountVerificationPage> createState() =>
      _DeleteAccountVerificationPageState();
}

class _DeleteAccountVerificationPageState
    extends ConsumerState<DeleteAccountVerificationPage> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isVerifying = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  /// 格式化手机号（脱敏）
  String _formatPhone(String? phone) {
    if (phone == null || phone.isEmpty) return '';
    if (phone.length < 7) return phone;
    return phone.replaceRange(3, 7, '****');
  }

  /// 验证密码
  Future<void> _verifyPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_passwordController.text.length < 6) {
      ToastUtil.error('密码不能小于6位');
      return;
    }

    setState(() => _isVerifying = true);
    LoadingHUD.show('验证中...');

    try {
      // ✅ 从存储中读取用户信息，确保获取到 phone
      // 对应 tiku: SKMessageTools userMessage.uphone
      final user = ref.read(authProvider).user;
      final storage = ref.read(storageServiceProvider);
      final userJson = storage.getJson(StorageKeys.userInfo);
      
      print('🔍 [安全验证] 调试用户信息:');
      print('   - user.phone: ${user?.phone}');
      print('   - userJson: $userJson');
      print('   - userJson[phone]: ${userJson?['phone']}');
      
      // ✅ 优先从存储中读取 phone（最可靠）
      String account = '';
      if (userJson != null && userJson['phone'] != null) {
        account = userJson['phone'].toString();
        print('✅ [安全验证] 从存储中获取手机号: $account');
      } else if (user?.phone != null && user!.phone!.isNotEmpty) {
        account = user.phone!;
        print('✅ [安全验证] 从 user.phone 获取手机号: $account');
      } else {
        // ❌ 如果都没有手机号，提示错误（不应该使用 studentId）
        print('❌ [安全验证] 无法获取手机号');
        ToastUtil.error('无法获取手机号，请重新登录');
        return;
      }
      
      if (account.isEmpty) {
        ToastUtil.error('无法获取账号信息，请重新登录');
        return;
      }
      
      print('🔐 [安全验证] 最终账号（手机号）: $account');

      final service = ref.read(accountDeletionServiceProvider);
      final isValid = await service.verifyPassword(
        account: account,
        password: _passwordController.text,
      );

      LoadingHUD.dismiss();

      if (isValid) {
        ToastUtil.success('密码校验成功');
        // 跳转到确认删除页面
        if (mounted) {
          context.push(AppRoutes.deleteAccountConfirm);
        }
      } else {
        ToastUtil.error('密码校验失败');
      }
    } catch (e) {
      LoadingHUD.dismiss();
      ToastUtil.error('验证失败: $e');
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final phone = user?.phone ?? '';
    final maskedPhone = _formatPhone(phone);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('安全验证'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              // 账号信息
              Center(
                child: Text(
                  maskedPhone,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              SizedBox(height: 40.h),

              // 密码输入框
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: '请输入密码',
                  hintText: '请输入密码',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入密码';
                  }
                  if (value.length < 6) {
                    return '密码不能小于6位';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40.h),

              // 下一步按钮
              SizedBox(
                width: double.infinity,
                height: 40.h,
                child: ElevatedButton(
                  onPressed: _isVerifying ? null : _verifyPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  child: _isVerifying
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          '下一步',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
