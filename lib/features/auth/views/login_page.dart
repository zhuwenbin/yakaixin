import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/toast_util.dart';
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
  
  // 验证码倒计时
  int _countdown = 0;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
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
    // ✅ 按照用户要求: 使用 Mock 数据快速登录（调试模式）
    // 直接使用 Mock 数据转换为 Model，不调用 API
    try {
      // Mock 用户数据
      final mockUserData = {
        'token': 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        'student_id': '123456',
        'student_name': '测试用户',
        'nickname': '牙开心${_phoneController.text.isNotEmpty ? _phoneController.text.substring(_phoneController.text.length - 4) : '0000'}',
        'avatar': 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/yakaixindf.png',
        'phone': _phoneController.text.isNotEmpty ? _phoneController.text : '13800138000',
        'major_id': 524033912737962623,
        'major_name': '医学-口腔执业医师',
      };

      // 直接使用 Provider 的内部方法处理登录成功逻辑
      await ref.read(authProvider.notifier).loginWithMockData(mockUserData);

      // 登录成功后跳转到TabBar首页
      if (ref.read(authProvider).isLoggedIn && mounted) {
        context.go(AppRoutes.mainTab);
      }
    } catch (e) {
      // 错误已在Provider中处理
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 80.h),
                
                // Logo
                // ✅ 符合数据安全规则: 添加 errorBuilder 处理图片加载失败
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 120.w,
                    height: 120.w,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.school,
                          size: 60.sp,
                          color: Colors.blue,
                        ),
                      );
                    },
                  ),
                ),
                
                SizedBox(height: 20.h),
                
                // 标题
                Text(
                  '牙开心题库',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                
                SizedBox(height: 10.h),
                
                Text(
                  '专业的医学考试题库',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
                
                SizedBox(height: 60.h),
                
                // 手机号输入
                // ✅ 符合 UI 迁移规则: 使用 .sp .w .r 单位
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: '手机号',
                    hintText: '请输入手机号',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Colors.blue, width: 2),
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
                
                SizedBox(height: 20.h),
                
                // 验证码或密码输入
                if (_isCodeLogin)
                  // 验证码输入
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _codeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: '验证码',
                            hintText: '请输入验证码',
                            prefixIcon: const Icon(Icons.message_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: const BorderSide(color: Colors.blue, width: 2),
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
                      SizedBox(width: 12.w),
                      // 发送验证码按钮
                      SizedBox(
                        width: 110.w,
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: _countdown > 0 ? null : _sendCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade50,
                            foregroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            _countdown > 0 ? '$_countdown秒' : '获取验证码',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  // 密码输入
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: '密码',
                      hintText: '请输入密码',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入密码';
                      }
                      return null;
                    },
                  ),
                
                SizedBox(height: 20.h),
                
                // 切换登录方式
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _isCodeLogin = !_isCodeLogin;
                      });
                    },
                    child: Text(
                      _isCodeLogin ? '密码登录' : '验证码登录',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 40.h),
                
                // 登录按钮
                ElevatedButton(
                  onPressed: authState.isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
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
                
                SizedBox(height: 20.h),
                
                // 提示信息
                Center(
                  child: Text(
                    _isCodeLogin ? '未注册手机号验证后自动创建账号' : '忘记密码请使用验证码登录',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
                
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
