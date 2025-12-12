import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../../app/config/api_config.dart';

/// 分段标题组件
/// 用于题库首页的各个区域标题
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.network(
          ApiConfig.completeImageUrl('title-icon.png'),
          width: 15.w,
          height: 15.w,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.star, size: 15.w, color: AppColors.primary);
          },
        ),
        SizedBox(width: 5.w),
        Text(
          title,
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
