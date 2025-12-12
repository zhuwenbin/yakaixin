import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../auth/views/login_page.dart';
import '../auth/providers/auth_provider.dart';
import '../main/main_tab_page.dart';
import '../../app/routes/app_routes.dart';
import '../../app/config/api_config.dart';
import '../../app/constants/app_constants.dart';
import '../../core/storage/storage_service.dart';
import '../payment/services/wechat_payment_service.dart';
import '../payment/services/unified_payment_service.dart';

/// 启动页 - 执行初始化 + 检查登录状态
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // ✅ 等待 500ms（确保原生启动页显示）
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (!mounted) return;

      // ✅ 初始化支付服务（包含内购产品列表加载）
      print('\n💳 初始化支付服务...');
      final paymentService = ref.read(unifiedPaymentServiceProvider);
      await paymentService.initialize();
      print('✅ 支付服务初始化完成\n');
      
      // ✅ 检查登录状态
      final isLoggedIn = ref.read(authProvider).isLoggedIn;

      // ✅ 跳转页面
      if (isLoggedIn) {
        context.go(AppRoutes.mainTab);
      } else {
        context.go(AppRoutes.loginCenter);
      }
    } catch (e) {
      print('❌ 检查登录状态失败: $e');
      if (mounted) {
        context.go(AppRoutes.loginCenter);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 空白页面，不显示任何内容（只显示原生启动页）
    return const Scaffold(
      backgroundColor: Colors.transparent,
    );
  }
}

/// 临时首页 - 显示已登录状态
class TempHomePage extends ConsumerWidget {
  const TempHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final major = ref.watch(currentMajorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('牙开心题库'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(30.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 80.sp,
                color: Colors.green,
              ),
              SizedBox(height: 30.h),
              Text(
                '登录成功!',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30.h),
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '用户信息',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    _buildInfoRow('学员ID', user?.studentId ?? '-'),
                    _buildInfoRow('学员姓名', user?.studentName ?? '-'),
                    _buildInfoRow('昵称', user?.nickname ?? '-'),
                    _buildInfoRow('手机号', user?.phone ?? '-'),
                    if (major != null)
                      _buildInfoRow('当前专业', major.majorName),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              ElevatedButton(
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) {
                    context.go(AppRoutes.loginCenter);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  '退出登录',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'TabBar主页面待实现...',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
