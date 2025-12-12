import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';

/// 课程封面区域组件
/// 对应小程序: .header-image-wrap
class CourseCoverSection extends StatelessWidget {
  final String? coverPath;
  final double height;

  const CourseCoverSection({
    super.key,
    this.coverPath,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height.h,
      child: Stack(
        children: [
          // 背景图片
          Positioned.fill(
            child: _buildCoverImage(),
          ),
          // 底部圆角遮罩
          Positioned(
            bottom: -1,
            left: 0,
            right: 0,
            child: Container(
              height: 15.h,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.r),
                  topRight: Radius.circular(15.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverImage() {
    if (coverPath == null || coverPath!.isEmpty) {
      return Container(
        color: AppColors.border,
        child: Icon(Icons.image, size: 60.sp, color: AppColors.textHint),
      );
    }

    return Image.network(
      coverPath!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: AppColors.border,
          child: Icon(Icons.image, size: 60.sp, color: AppColors.textHint),
        );
      },
    );
  }
}
