import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/providers/auth_provider.dart';

/// 删除账户风险提示页面
/// 对应 tiku: SKDeleteAccountRiskVC
/// 功能：显示要删除的账号和风险提示
class DeleteAccountRiskPage extends ConsumerWidget {
  const DeleteAccountRiskPage({super.key});

  /// 格式化手机号（脱敏）
  String _formatPhone(String? phone) {
    if (phone == null || phone.isEmpty) return '';
    if (phone.length < 7) return phone;
    return phone.replaceRange(3, 7, '****');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final phone = user?.phone ?? '';
    final maskedPhone = _formatPhone(phone);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('注销账号'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 账号信息
            Center(
              child: Text(
                '注销账号：$maskedPhone',
                style: AppTextStyles.heading4.copyWith(
                  fontSize: 16.sp,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            SizedBox(height: 30.h),

            // 风险提示标题
            Text(
              '账号注销后，将放弃以下权益及资产：',
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 16.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 30.h),

            // 风险列表
            // 对应 tiku: SKDeleteAccountRiskVC.xib - 风险提示内容
            _buildRiskItem(
              '1、账号信息（包含金医圣、身份信息、认证信息等）将清空且无法恢复；',
            ),
            SizedBox(height: 30.h),

            _buildRiskItem(
              '2、账号相关数据，包括但不限于学习记录、笔记、下载记录等将被永久删除，请提前备份；',
            ),
            SizedBox(height: 30.h),

            _buildRiskItem(
              '3、该账号拥有的课程及权益将被清空且无法恢复；',
            ),
            SizedBox(height: 30.h),

            _buildRiskItem(
              '4、余额、赠币、礼券等资产将全部清空；',
            ),
            SizedBox(height: 30.h),

            _buildRiskItem(
              '5、将无法提现分享有赏中的余额，通过历史分享链接获得的返现金额，将视为主动放弃；',
            ),
            SizedBox(height: 40.h),

            // 下一步按钮
            SizedBox(
              width: double.infinity,
              height: 36.h,
              child: ElevatedButton(
                onPressed: () {
                  // 跳转到安全验证页面
                  context.push(AppRoutes.deleteAccountVerification);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                child: Text(
                  '下一步',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // 返回按钮
            Center(
              child: TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  '暂时不想注销，点击返回',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskItem(String text) {
    return Text(
      text,
      style: AppTextStyles.bodyMedium.copyWith(
        fontSize: 16.sp,
        color: AppColors.textSecondary,
        height: 1.5,
      ),
    );
  }
}
