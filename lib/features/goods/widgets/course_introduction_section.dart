import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';

/// 课程介绍区域组件
/// 对应小程序: .introduction-content
class CourseIntroductionSection extends StatelessWidget {
  final String? introduction;

  const CourseIntroductionSection({
    super.key,
    this.introduction,
  });

  @override
  Widget build(BuildContext context) {
    if (introduction == null || introduction!.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          padding: AppSpacing.allMd,
          color: AppColors.surface,
          child: Center(
            child: Text(
              '暂无课程介绍',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
            ),
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.surface,
        margin: EdgeInsets.only(top: 16.h),
        padding: AppSpacing.allMd,
        child: Text(
          introduction!,
          style: AppTextStyles.bodyMedium,
        ),
      ),
    );
  }
}
