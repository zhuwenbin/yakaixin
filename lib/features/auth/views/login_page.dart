import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/toast_util.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../../../app/routes/app_routes.dart';
import '../../payment/services/unified_payment_service.dart';
import '../../../core/utils/login_return_path_provider.dart';

/// 登录页面
/// 对应小程序: src/modules/jintiku/pages/loginCenter/index.vue
class LoginPage extends ConsumerStatefulWidget {
  /// 登录成功后的返回路径（可选）
  final String? returnPath;

  const LoginPage({super.key, this.returnPath});

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

  // 验证码倒计时（与小程序 login-h5 一致：获取验证码 / Xs后重新发送 / 重新获取验证码）
  int _countdown = 0;
  bool _hasSentCode = false;

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
      await ref
          .read(authProvider.notifier)
          .sendVerifyCode(_phoneController.text);

      // 开始倒计时 60 秒（与小程序 setTime 一致）
      setState(() {
        _countdown = 60;
        _hasSentCode = true;
      });

      Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return false;
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
    // ✅ 协议验证：底部黑色 Toast，先取消避免多次点击叠加
    if (!_agreeProtocol) {
      ToastUtil.showBottomBlack('请阅读并同意用户协议和隐私政策');
      return;
    }

    // ✅ 表单验证
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      print('🚀 [登录流程] 开始登录流程...');
      print('   - 登录方式: ${_isCodeLogin ? "验证码登录" : "密码登录"}');
      print('   - 手机号: ${_phoneController.text}');

      if (_isCodeLogin) {
        // ✅ 验证码登录 - 调用真实API
        print('📱 [登录流程] 调用 loginWithSms...');
        await ref
            .read(authProvider.notifier)
            .loginWithSms(
              phone: _phoneController.text,
              code: _codeController.text,
            );
        print('✅ [登录流程] loginWithSms 调用完成');
      } else {
        // ✅ 密码登录 - 调用真实API
        print('🔐 [登录流程] 调用 loginWithPhone...');
        await ref
            .read(authProvider.notifier)
            .loginWithPhone(
              account: _phoneController.text,
              password: _passwordController.text,
            );
        print('✅ [登录流程] loginWithPhone 调用完成');
      }

      // ✅ 登录成功后异步返回上一页（不使用延迟，使用 addPostFrameCallback）
      print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('🔄 [步骤1] 登录API调用完成，使用异步回调处理返回逻辑...');

      // ✅ 使用 addPostFrameCallback 在下一帧执行，确保状态已更新且页面未销毁
      // 这样不需要延迟，状态已经在 _handleLoginSuccess 中更新了
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          print('❌ [步骤1] 页面已销毁，无法继续处理');
          return;
        }

        final authState = ref.read(authProvider);
        print('🔍 [步骤2] 检查登录状态:');
        print('   - isLoggedIn: ${authState.isLoggedIn}');
        print('   - mounted: $mounted');
        print('   - user: ${authState.user?.studentId ?? "null"}');

        if (authState.isLoggedIn) {
          print('✅ [步骤3] 登录状态确认成功，准备返回上一页');
          print('🔍 [步骤3] Navigator.canPop: ${Navigator.of(context).canPop()}');

          // ✅ 步骤4: 清除 Provider 中的返回路径（避免路由拦截器再次使用）
          ref.read(loginReturnPathProvider.notifier).state = null;
          print('✅ [步骤4] 已清除返回路径 Provider');

          // ✅ 步骤5: 后台异步初始化支付服务（如果还未初始化）
          Future.microtask(() async {
            try {
              print('💳 [步骤5] 开始初始化支付服务...');
              final paymentService = ref.read(unifiedPaymentServiceProvider);
              await paymentService.initialize();
              print('✅ [步骤5] 支付服务初始化完成');
            } catch (e) {
              print('⚠️ [步骤5] 支付服务初始化失败: $e');
              // 支付服务初始化失败不影响应用使用，只影响支付功能
            }
          });

          // ✅ 步骤6: 再次检查页面是否已销毁（在返回前检查）
          if (!mounted) {
            print('❌ [步骤6] 当前登录页面已销毁，无法返回上一页');
            print('   - 说明：登录页面在回调执行期间被销毁了');
            return;
          }

          // ✅ 步骤7: 优先使用 Navigator.pop() 返回上一页（最简单可靠的方式）
          // ⚠️ 测试：不使用 returnPath，直接用 Navigator.pop() 返回
          final canPop = Navigator.of(context).canPop();

          // ✅ 获取当前页面信息
          final router = GoRouter.of(context);
          final currentLocation = router.routerDelegate.currentConfiguration.uri
              .toString();
          final currentRoute = ModalRoute.of(context);
          final currentRouteName = currentRoute?.settings.name ?? '未知';
          final currentRouteArguments = currentRoute?.settings.arguments;

          // ✅ 获取上一个页面的信息（通过 Navigator 的历史记录）
          String? previousRouteName;
          try {
            // 尝试获取上一个路由（不修改导航栈）
            final navigator = Navigator.of(context);
            if (navigator.canPop()) {
              // 注意：这里不能直接访问上一个路由，只能通过其他方式推断
              // 可以通过 GoRouter 的历史记录或者从 returnPath 推断
              final returnPath = ref.read(loginReturnPathProvider);
              if (returnPath != null && returnPath.isNotEmpty) {
                previousRouteName = '从 returnPath 推断: $returnPath';
              }
            }
          } catch (e) {
            print('⚠️ [步骤7] 获取上一个路由信息失败: $e');
          }

          print('🔍 [步骤7] 检查导航栈: canPop=$canPop');
          print('   - 当前页面路由: $currentLocation');
          print('   - 当前页面名称: $currentRouteName');
          if (currentRouteArguments != null) {
            print('   - 当前页面参数: $currentRouteArguments');
          }
          if (previousRouteName != null) {
            print('   - 上一个页面: $previousRouteName');
          } else {
            print('   - 上一个页面: 无法获取（可能是第一个页面或导航栈为空）');
          }
          print('   - canPop=true: 导航栈中有上一页，可以返回');
          print('   - canPop=false: 导航栈中没有上一页（可能是从启动页直接进入登录页）');

          // ✅ 登录成功跳转前取消所有 Toast，避免协议提示残留在主页面
          ToastUtil.cancel();
          if (canPop) {
            print('✅ [步骤7] 使用 Navigator.pop() 返回上一页');
            Navigator.of(context).pop();
            print('✅ [步骤7] Navigator.pop() 执行完成');
          } else {
            // ✅ 如果无法返回上一页（比如从启动页直接进入登录页），跳转到主页
            print('⚠️ [步骤7] 无法返回上一页，跳转到主页');
            context.go(AppRoutes.mainTab);
            print('✅ [步骤7] 已跳转到主页');
          }
          print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        } else {
          print('❌ [步骤3] 登录状态检查失败:');
          print('   - mounted: $mounted');
          print('   - isLoggedIn: ${authState.isLoggedIn}');
          print('   - user: ${authState.user?.studentId ?? "null"}');
          print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        }
      });
    } catch (e, stackTrace) {
      // 错误已在Provider中处理，显示Toast提示
      print('❌ [登录流程] 登录过程中发生异常:');
      print('   - 错误: $e');
      print('   - 堆栈: $stackTrace');
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
        // 键盘弹出时不压缩 body，隐私协议固定在底部不随键盘上移，避免遮挡手机号输入框（参考常见 APP 登录交互）
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          children: [
            // 主内容区域（可滚动，键盘显示时仅此区域可滚动，底部协议不参与布局变化）
            Expanded(
              child: SafeArea(
                bottom: false,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 30.w,
                    right: 30.w,
                    bottom: 24.h + MediaQuery.of(context).viewInsets.bottom,
                  ),
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
                                padding: EdgeInsets.only(
                                  left: 12.w,
                                  right: 8.w,
                                ),
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
                              // 验证码按钮（与小程序 login-h5 一致）
                              GestureDetector(
                                onTap: _countdown > 0 ? null : _sendCode,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                                  child: Text(
                                    _countdown > 0
                                        ? '${_countdown}s后重新发送'
                                        : (_hasSentCode ? '重新获取验证码' : '获取验证码'),
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
                                padding: EdgeInsets.only(
                                  left: 12.w,
                                  right: 8.w,
                                ),
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
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
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
                                    print(
                                      '🔑 点击忘记密码，跳转到: ${AppRoutes.forgetPassword}',
                                    );
                                    context.push(AppRoutes.forgetPassword);
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.h,
                                    ),
                                    minimumSize: Size(0, 0),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
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
                    ],
                  ),
                ),
              ),
            ),
            ), // Expanded
            // ✅ 隐私协议固定在最底部，键盘显示/收起时位置不变
            SafeArea(
              top: false,
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.only(
                  left: 30.w,
                  right: 30.w,
                  top: 20.h,
                  bottom: 20.h,
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
      ),
    );
  }
}
