import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/toast_util.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/auth_provider.dart';
import '../../../app/routes/app_routes.dart';

/// 登录页面
/// 对应小程序: src/modules/jintiku/pages/loginCenter/index.vue
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // 登录方式: true=验证码, false=密码
  bool _isCodeLogin = true;
  
  // 密码可见性
  bool _obscurePassword = true;
  
  // 验证码倒计时
  int _countdown = 0;
  
  // 协议勾选状态
  bool _agreeProtocol = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  // 切换密码可见性
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
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
      await ref.read(authProvider.notifier).sendVerifyCode(_phoneController.text);
      
      // 开始倒计时60秒
      setState(() {
        _countdown = 60;
      });
      
      Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 1));
        if (_countdown > 0) {
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

  Future<void> _handleLogin() async {
    // ✅ 协议验证
    if (!_agreeProtocol) {
      ToastUtil.error('请阅读并同意用户协议和隐私政策');
      return;
    }
    
    // ✅ 表单验证
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    try {
      if (_isCodeLogin) {
        // ✅ 验证码登录 - 调用真实API
        await ref.read(authProvider.notifier).loginWithSms(
          phone: _phoneController.text,
          code: _codeController.text,
        );
      } else {
        // ✅ 密码登录 - 调用真实API
        await ref.read(authProvider.notifier).loginWithPhone(
          account: _phoneController.text,
          password: _passwordController.text,
        );
      }
      
      // 登录成功后跳转到TabBar首页
      if (ref.read(authProvider).isLoggedIn && mounted) {
        context.go(AppRoutes.mainTab);
      }
    } catch (e) {
      // 错误已在Provider中处理，显示Toast提示
      // 不需要额外处理
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return GestureDetector(
      // ✅ 点击空白区域隐藏键盘
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // 主内容区域（可滚动）
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 60.h),
                    
                    // Logo
                    Center(
                      child: Image.asset(
                        'assets/images/app_icon.png',
                        width: 80.w,
                        height: 80.w,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.account_circle,
                            size: 80.sp,
                            color: AppColors.primary,
                          );
                        },
                      ),
                    ),
                    
                    SizedBox(height: 48.h),
                    
                    // 标题：手机号登陆 + 注册说明
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '手机号登录',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          // ✅ 新用户注册提示（App Store审核要求）
                          Text(
                            '新用户验证后自动注册',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // 手机号输入
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(fontSize: 15.sp),
                        decoration: InputDecoration(
                          hintText: '请输入手机号码',
                          hintStyle: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.textHint,
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Image.network(
                              'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/16981168209892506169811682099042826_person.png',
                              width: 20.w,
                              height: 20.w,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.person_outline,
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
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // 验证码或密码输入
                    if (_isCodeLogin)
                      // 验证码输入
                      Container(
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
                      )
                    else
                      // 密码输入
                      Container(
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
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: TextStyle(fontSize: 15.sp),
                                decoration: InputDecoration(
                                  hintText: '请输入密码',
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
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      size: 20.sp,
                                      color: AppColors.textHint,
                                    ),
                                    onPressed: _togglePasswordVisibility,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '请输入密码';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    
                    SizedBox(height: 16.h),
                    
                    // 切换登录方式 & 忘记密码
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 切换登录方式按钮
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _isCodeLogin = !_isCodeLogin;
                                });
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                minimumSize: Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                _isCodeLogin ? '密码登录' : '验证码登录',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // 忘记密码按钮（仅密码登录时显示）
                        if (!_isCodeLogin)
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  print('🔑 点击忘记密码，跳转到: ${AppRoutes.forgetPassword}');
                                  context.push(AppRoutes.forgetPassword);
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  minimumSize: Size(0, 0),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  '忘记密码？',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppColors.textHint,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    
                    SizedBox(height: 80.h),
                    
                    // 登录按钮
                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: authState.isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          elevation: 0,
                        ),
                        child: authState.isLoading
                            ? SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                '登录',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    
                    // ✅ 留出底部协议的空间
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ),
          
          // ✅ 协议勾选（固定在屏幕底部）
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                left: 30.w,
                right: 30.w,
                bottom: MediaQuery.of(context).padding.bottom + 20.h,  // ✅ 安全区域
                top: 20.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: Checkbox(
                      value: _agreeProtocol,
                      onChanged: (value) {
                        setState(() {
                          _agreeProtocol = value ?? false;
                        });
                      },
                      activeColor: AppColors.primary,
                      shape: const CircleBorder(),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Flexible(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          '我已阅读并同意',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textHint,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.push(AppRoutes.userServiceAgreement);
                          },
                          child: Text(
                            '《用户服务协议》',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.push(AppRoutes.privacyPolicy);
                          },
                          child: Text(
                            '《隐私政策》',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Text(
                          '，并授权使用该账号信息进行统一管理',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
