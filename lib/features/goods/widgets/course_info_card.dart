import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_radius.dart';
import '../../home/models/goods_model.dart';

/// 课程信息卡片组件
/// 显示课程标题、标签、价格等信息
class CourseInfoCard extends StatelessWidget {
  final GoodsModel goodsDetail;

  const CourseInfoCard({
    super.key,
    required this.goodsDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          SizedBox(height: 12.h),
          _buildTags(),
          if (_shouldShowValidityTime()) ...[
            SizedBox(height: 12.h),
            _buildValidityTime(),
          ],
          SizedBox(height: 16.h),
          _buildBottomInfo(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (goodsDetail.shopType != null) ...[
          _buildCourseTypeIcon(goodsDetail.shopType!),
          SizedBox(width: 8.w),
        ],
        Expanded(
          child: Text(
            goodsDetail.name ?? '',
            style: AppTextStyles.heading3.copyWith(
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCourseTypeIcon(String shopType) {
    String? iconPath;
    switch (shopType) {
      case '1':
        iconPath = 'assets/images/course_type/best.png';
        break;
      case '2':
        iconPath = 'assets/images/course_type/high.png';
        break;
      case '3':
        iconPath = 'assets/images/course_type/private.png';
        break;
      case 'good':
        iconPath = 'assets/images/course_type/good.png';
        break;
      case 'recommend':
        iconPath = 'assets/images/course_type/recommend.png';
        break;
      default:
        iconPath = 'assets/images/course_type/best.png';
    }

    return Image.asset(
      iconPath,
      width: 56.w,
      height: 28.h,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 56.w,
          height: 28.h,
          decoration: BoxDecoration(
            color: const Color(0xFFE3EBFF),
            borderRadius: AppRadius.radiusXs,
          ),
        );
      },
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 8.w,
      children: [
        if (goodsDetail.teachingTypeName != null)
          _buildTag(
            goodsDetail.teachingTypeName!,
            const Color(0xFFE3EBFF),
            AppColors.primary,
          ),
        if (goodsDetail.serviceTypeName != null)
          _buildTag(
            goodsDetail.serviceTypeName!,
            AppColors.background,
            AppColors.textPrimary,
          ),
      ],
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.radiusXs,
      ),
      child: Text(
        text,
        style: AppTextStyles.labelMedium.copyWith(color: textColor),
      ),
    );
  }

  bool _shouldShowValidityTime() {
    final startDate = goodsDetail.validityStartDateVal;
    return startDate != null && !startDate.contains('0001');
  }

  Widget _buildValidityTime() {
    final startDate = goodsDetail.validityStartDateVal;
    final endDate = goodsDetail.validityEndDateVal;

    return Text(
      '有效时间: ${startDate ?? ''} - ${endDate ?? ''}',
      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
    );
  }

  Widget _buildBottomInfo() {
    final permissionStatus = goodsDetail.permissionStatus;
    final salePrice = goodsDetail.salePrice;
    final studentNum = goodsDetail.studentNum;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (permissionStatus == '2' && salePrice != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '¥',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFFF6600),
                ),
              ),
              Text(
                salePrice,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFF6600),
                ),
              ),
            ],
          )
        else
          const SizedBox.shrink(),
        Text(
          '${studentNum ?? 0}人购买',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
        ),
      ],
    );
  }
}
