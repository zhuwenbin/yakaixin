import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_radius.dart';

/// 商品详情页底部按钮栏
/// 包含"去学习"或"立即报名"按钮
class GoodsDetailBottomBar extends StatelessWidget {
  final String? permissionStatus;
  final VoidCallback? onGoLearn;
  final VoidCallback? onSignUp;

  const GoodsDetailBottomBar({
    super.key,
    this.permissionStatus,
    this.onGoLearn,
    this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.border,
              blurRadius: 8.r,
              offset: Offset(0, -2.h),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: permissionStatus == '1'
              ? _buildGoLearnButton()
              : _buildSignUpButton(),
        ),
      ),
    );
  }

  /// "去学习"按钮（已购买）
  Widget _buildGoLearnButton() {
    return SizedBox(
      width: double.infinity,
      height: 44.h,
      child: ElevatedButton(
        onPressed: onGoLearn,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.radiusMd,
          ),
        ),
        child: Text(
          '去学习',
          style: AppTextStyles.buttonLarge,
        ),
      ),
    );
  }

  /// "立即报名"按钮（未购买）
  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      height: 44.h,
      child: ElevatedButton(
        onPressed: onSignUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.radiusMd,
          ),
        ),
        child: Text(
          '立即报名',
          style: AppTextStyles.buttonLarge,
        ),
      ),
    );
  }
}
