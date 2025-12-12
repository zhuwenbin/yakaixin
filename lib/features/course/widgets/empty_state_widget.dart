import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../../app/config/api_config.dart';

/// 空状态组件
/// 当没有课程和学习计划时显示
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? imageUrl;

  const EmptyStateWidget({
    super.key,
    this.message = '未找到学习内容',
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final defaultImageUrl =
        ApiConfig.completeImageUrl('public/4045173295663081752515_8b3592c2dcddcac66af8ddd46abbbf1b74efa19fac63-AlBs3V_fw1200%402x.png');

    return Container(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        children: [
          Image.network(
            imageUrl ?? defaultImageUrl,
            width: 120.w,
            height: 120.w,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.inbox, size: 120.w, color: AppColors.textHint),
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}
