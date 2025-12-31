import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../../app/config/api_config.dart';

/// 首页顶部专业选择栏
class HomeHeader extends StatelessWidget {
  final String majorName;
  final double statusBarHeight;
  final VoidCallback onTap;

  const HomeHeader({
    required this.majorName,
    required this.statusBarHeight,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: statusBarHeight + 48.h,
        color: AppColors.surface, // ✅ 白色背景，类似iOS导航栏
        padding: EdgeInsets.only(
          top: statusBarHeight,
          left: AppSpacing.md,
          right: AppSpacing.md,
        ),
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque, // ✅ 确保整个区域（包括箭头）都可以点击
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                majorName,
                style: TextStyle(
                  fontSize: 20.sp, // ✅ 小程序40rpx ÷ 2 = 20.sp
                  fontWeight: FontWeight.w500, // ✅ 小程序font-weight: 500
                  color: const Color(0xFF03203D), // ✅ 小程序默认黑色
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              // ✅ 箭头图标也可以点击（通过外层的 GestureDetector）
              // ✅ 使用 Image.network 避免 iOS Release 模式 Content-Disposition 问题
              Image.network(
                ApiConfig.completeImageUrl('down.png'),
                width: 10.w,
                height: 10.w,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
