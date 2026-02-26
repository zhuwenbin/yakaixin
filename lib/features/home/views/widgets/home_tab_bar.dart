import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';

/// 首页Tab切换栏
/// 对应小程序: .tabs
class HomeTabBar extends StatelessWidget {
  final List<String> tabs;
  final int activeIndex;
  final ValueChanged<int> onTap;

  const HomeTabBar({
    required this.tabs,
    required this.activeIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isActive = index == activeIndex;
            return Padding(
              padding: EdgeInsets.only(
                right: index == tabs.length - 1 ? 0 : AppSpacing.md,
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(index),
                child: _buildTabItem(
                  tabs[index],
                  isActive: isActive,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTabItem(String label, {bool isActive = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: isActive ? 18.sp : 16.sp,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? AppColors.textPrimary : AppColors.tabInactiveText,
          ),
        ),
        if (isActive) ...[
          SizedBox(height: AppSpacing.xsV),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.primaryGradientStart,
              borderRadius: AppRadius.radiusXs,
            ),
          ),
        ],
      ],
    );
  }
}
