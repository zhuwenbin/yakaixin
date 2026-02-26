import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/providers/auth_provider.dart';

/// 删除账户确认页面
/// 对应 tiku: SKDeleteAccountMakeSureVC
/// 功能：最终确认删除账户
class DeleteAccountConfirmPage extends ConsumerStatefulWidget {
  const DeleteAccountConfirmPage({super.key});

  @override
  ConsumerState<DeleteAccountConfirmPage> createState() =>
      _DeleteAccountConfirmPageState();
}

class _DeleteAccountConfirmPageState
    extends ConsumerState<DeleteAccountConfirmPage> {

  /// 格式化手机号（脱敏）
  String _formatPhone(String? phone) {
    if (phone == null || phone.isEmpty) return '';
    if (phone.length < 7) return phone;
    return phone.replaceRange(3, 7, '****');
  }

  /// 确认删除账户
  /// 对应 tiku: SKDeleteAccountMakeSureVC - btnNextAction
  /// 不调用后端API，直接显示"注销审核中"提示，然后退出登录
  Future<void> _confirmDelete() async {
    // 显示"注销审核中"提示对话框
    // 对应 tiku: SKDeleteAccountTostView
    if (mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('注销审核中'),
          content: const Text(
            '为维护用户在APP内权益，请等待审核，审核通过后注销成功。',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // 退出登录
                // 对应 tiku: SKDeleteAccountMakeSureVC - logout
                ref.read(authProvider.notifier).logout();
                // 跳转到登录页
                if (mounted) {
                  context.go(AppRoutes.loginCenter);
                }
              },
              child: const Text('好的'),
            ),
          ],
        ),
      );
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
        child: Column(
          children: [
            SizedBox(height: 130.h),

            // 标题
            Text(
              '您所要注销账号',
              style: AppTextStyles.heading4.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),

            // 账号信息
            Text(
              maskedPhone,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 100.h),

            // 确认删除按钮
            SizedBox(
              width: double.infinity,
              height: 40.h,
              child: ElevatedButton(
                onPressed: _confirmDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                child: Text(
                '确认注销',
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
    );
  }
}
