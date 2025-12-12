import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';

/// 学习卡片网格（绝密押题、科目模考、模拟考试、学习报告）
class StudyCardGrid extends StatelessWidget {
  final List<StudyCardData> cards;

  const StudyCardGrid({
    super.key,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
        ),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return _StudyCard(
            title: card.title,
            subtitle: card.subtitle,
            imageUrl: card.imageUrl,
            onTap: card.onTap,
          );
        },
      ),
    );
  }
}

/// 学习卡片数据模型
class StudyCardData {
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onTap;

  const StudyCardData({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
  });
}

/// 学习卡片单项
class _StudyCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onTap;

  const _StudyCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.allMd,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.radiusLg,
        ),
        child: Row(
          children: [
            Image.network(
              imageUrl,
              width: 30.w,
              height: 30.w,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image,
                  size: 30.w,
                  color: AppColors.textDisabled,
                );
              },
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textHint,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
