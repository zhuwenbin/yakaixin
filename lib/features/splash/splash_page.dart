import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../app/constants/storage_keys.dart';
import '../../app/routes/app_routes.dart';
import '../../core/storage/storage_service.dart';
import '../auth/providers/auth_provider.dart';
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

      // ✅ 首次安装需弹出隐私协议弹窗（小米应用商店要求）
      // 参照 iOS PrivacyProtectVC 实现
      final storage = ref.read(storageServiceProvider);
      final hasAgreedPrivacy =
          storage.getBool(StorageKeys.agreePrivacyProtect) ?? false;

      if (!hasAgreedPrivacy) {
        context.go(AppRoutes.privacyAgreement);
        return;
      }

      // ✅ 先跳转页面，避免白屏
      // 根据 Guideline 5.1.1，未登录用户应该可以浏览公开内容（首页）
      // ✅ 未登录时也跳转到 mainTab，这样可以看到 tabbar
      context.go(AppRoutes.mainTab);

      // ✅ 后台异步初始化支付服务（不阻塞页面跳转）
      // 这样即使支付服务初始化较慢，也不会导致白屏
      print('\n💳 后台初始化支付服务...');
      final paymentService = ref.read(unifiedPaymentServiceProvider);
      paymentService
          .initialize()
          .then((_) {
            print('✅ 支付服务初始化完成\n');
          })
          .catchError((e) {
            print('⚠️ 支付服务初始化失败: $e\n');
            // 支付服务初始化失败不影响应用使用，只影响支付功能
          });
    } catch (e) {
      print('❌ 检查登录状态失败: $e');
      if (mounted) {
        context.go(AppRoutes.loginCenter);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 显示启动页图片（全屏）
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/splash.png',
          fit: BoxFit.contain, // ✅ 完整显示整张图片，不裁剪
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            // ✅ 如果图片加载失败，显示白色背景
            return Container(
              color: Colors.white,
              child: const Center(
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 48,
                ),
              ),
            );
          },
        ),
      ),
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
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
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
                    if (major != null) _buildInfoRow('当前专业', major.majorName),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 16.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text('退出登录', style: TextStyle(fontSize: 16.sp)),
              ),
              SizedBox(height: 20.h),
              Text(
                'TabBar主页面待实现...',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
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
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
