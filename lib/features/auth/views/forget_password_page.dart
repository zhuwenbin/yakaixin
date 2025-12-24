import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/toast_util.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/auth_provider.dart';

/// 忘记密码页面
/// 功能：通过手机号验证码重置密码
class ForgetPasswordPage extends ConsumerStatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  ConsumerState<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends ConsumerState<ForgetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // 密码可见性
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  // 验证码倒计时
  int _countdown = 0;
  
  // 重置中状态
  bool _isResetting = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // 发送验证码
  Future<void> _sendCode() async {
    if (_phoneController.text.isEmpty) {
      ToastUtil.error('请输入手机号');
      return;
    }

    if (_phoneController.text.length != 11) {
      ToastUtil.error('请输入正确的手机号');
      return;
    }

    try {
      // ✅ scene=3 表示修改密码场景（忘记密码和修改密码使用相同接口）
      await ref.read(authProvider.notifier).sendVerifyCode(_phoneController.text, scene: 3);
      
      // 开始倒计时60秒
      setState(() {
        _countdown = 60;
      });
      
      Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 1));
        if (_countdown > 0 && mounted) {
          setState(() {
            _countdown--;
          });
          return true;
        }
        return false;
      });
    } catch (e) {
      // 错误已在Provider中处理
    }
  }

  // 重置密码
  Future<void> _handleResetPassword() async {
    // ✅ 表单验证
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    // 密码匹配验证
    if (_passwordController.text != _confirmPasswordController.text) {
      ToastUtil.error('两次输入的密码不一致');
      return;
    }
    
    setState(() => _isResetting = true);
    
    try {
      // ✅ 使用 changePassword 方法（与修改密码页面使用相同接口）
      await ref.read(authProvider.notifier).changePassword(
        phone: _phoneController.text,
        code: _codeController.text,
        newPassword: _passwordController.text,
      );
      
      if (!mounted) return;
      
      // 延迟返回登录页
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      // 错误已在Provider中处理
    } finally {
      if (mounted) {
        setState(() => _isResetting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // ✅ 点击空白区域隐藏键盘
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('忘记密码'),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.allMd,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.h),
                
                // 提示文本
                Text(
                  '通过手机验证码重置密码',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                
                SizedBox(height: 32.h),
                
                // 手机号输入
                _buildInputField(
                  controller: _phoneController,
                  hintText: '请输入手机号码',
                  icon: 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/16981168209892506169811682099042826_person.png',
                  fallbackIcon: Icons.person_outline,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入手机号';
                    }
                    if (value.length != 11) {
                      return '请输入正确的手机号';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 16.h),
                
                // 验证码输入
                _buildCodeInput(),
                
                SizedBox(height: 16.h),
                
                // 新密码输入
                _buildPasswordField(
                  controller: _passwordController,
                  hintText: '请输入新密码',
                  obscureText: _obscurePassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入新密码';
                    }
                    if (value.length < 6) {
                      return '密码至少6位';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 16.h),
                
                // 确认密码输入
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  hintText: '请再次输入新密码',
                  obscureText: _obscureConfirmPassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请再次输入密码';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 48.h),
                
                // 重置密码按钮
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: _isResetting ? null : _handleResetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      elevation: 0,
                    ),
                    child: _isResetting
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            '重置密码',
                            style: AppTextStyles.buttonLarge,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  /// 通用输入框
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required String icon,
    required IconData fallbackIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 15.sp),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 15.sp,
            color: AppColors.textHint,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Image.network(
              icon,
              width: 20.w,
              height: 20.w,
              errorBuilder: (_, __, ___) => Icon(
                fallbackIcon,
                size: 20.sp,
                color: AppColors.textHint,
              ),
            ),
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 44.w,
            minHeight: 20.h,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
        ),
        validator: validator,
      ),
    );
  }

  /// 验证码输入框
  Widget _buildCodeInput() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12.w, right: 8.w),
            child: Image.network(
              'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/1698116851191468616981168511918397_dun.png',
              width: 20.w,
              height: 20.w,
              errorBuilder: (_, __, ___) => Icon(
                Icons.shield_outlined,
                size: 20.sp,
                color: AppColors.textHint,
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 15.sp),
              decoration: InputDecoration(
                hintText: '请输入短信验证码',
                hintStyle: TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.textHint,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 16.h,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入验证码';
                }
                return null;
              },
            ),
          ),
          // 发送验证码按钮
          GestureDetector(
            onTap: _countdown > 0 ? null : _sendCode,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              child: Text(
                _countdown > 0 ? '${_countdown}s' : '发送验证码',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: _countdown > 0
                      ? AppColors.textDisabled
                      : AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 密码输入框
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12.w, right: 8.w),
            child: Image.network(
              'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/1698116851191468616981168511918397_dun.png',
              width: 20.w,
              height: 20.w,
              errorBuilder: (_, __, ___) => Icon(
                Icons.lock_outline,
                size: 20.sp,
                color: AppColors.textHint,
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              style: TextStyle(fontSize: 15.sp),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.textHint,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 16.h,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    size: 20.sp,
                    color: AppColors.textHint,
                  ),
                  onPressed: onToggleVisibility,
                ),
              ),
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }
}
