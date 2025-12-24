import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/toast_util.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/auth_provider.dart';

/// 修改密码页面
/// 功能：已登录用户通过验证码修改密码
class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // 密码可见性
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  
  // 验证码倒计时
  int _countdown = 0;
  
  // 修改中状态
  bool _isChanging = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
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
      // ✅ scene=3 表示修改密码场景
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

  // 修改密码
  Future<void> _handleChangePassword() async {
    // ✅ 表单验证
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    // 密码匹配验证
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ToastUtil.error('两次输入的密码不一致');
      return;
    }
    
    setState(() => _isChanging = true);
    
    try {
      // ✅ 调用修改密码API（通过验证码）
      await ref.read(authProvider.notifier).changePassword(
        phone: _phoneController.text,
        code: _codeController.text,
        newPassword: _newPasswordController.text,
      );
      
      if (!mounted) return;
      
      // 延迟返回
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      // 错误已在Provider中处理
    } finally {
      if (mounted) {
        setState(() => _isChanging = false);
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
          title: const Text('修改密码'),
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
                  '为了您的账号安全，请通过手机验证码修改密码',
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
                _buildCodeField(
                  controller: _codeController,
                  hintText: '请输入验证码',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入验证码';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 16.h),
                
                // 新密码输入
                _buildPasswordField(
                  controller: _newPasswordController,
                  hintText: '请输入新密码',
                  obscureText: _obscureNewPassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
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
                
                // 修改密码按钮
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: _isChanging ? null : _handleChangePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      elevation: 0,
                    ),
                    child: _isChanging
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            '确认修改',
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

  /// 普通输入框
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
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12.w, right: 8.w),
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
          Expanded(
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
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 16.h,
                ),
              ),
              validator: validator,
            ),
          ),
          SizedBox(width: 12.w),
        ],
      ),
    );
  }

  /// 验证码输入框
  Widget _buildCodeField({
    required TextEditingController controller,
    required String hintText,
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
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 15.sp),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.textHint,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 16.h,
                ),
              ),
              validator: validator,
            ),
          ),
          // 验证码按钮
          GestureDetector(
            onTap: _countdown > 0 ? null : _sendCode,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
              margin: EdgeInsets.only(right: 8.w),
              decoration: BoxDecoration(
                color: _countdown > 0 ? Colors.grey[300] : AppColors.primary,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                _countdown > 0 ? '${_countdown}s' : '获取验证码',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: _countdown > 0 ? AppColors.textHint : Colors.white,
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
