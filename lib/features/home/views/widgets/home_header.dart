import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
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
        color: Colors.transparent,
        padding: EdgeInsets.only(
          top: statusBarHeight,
          left: AppSpacing.md,
        ),
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                majorName,
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              CachedNetworkImage(
                imageUrl:
                    ApiConfig.completeImageUrl('down.png'),
                width: 10.w,
                height: 10.w,
                errorWidget: (_, __, ___) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
