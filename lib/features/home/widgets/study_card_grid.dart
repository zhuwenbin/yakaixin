import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';

/// 学习卡片网格（绝密押题、科目模考、模拟考试、学习报告）
class StudyCardGrid extends StatelessWidget {
  final List<StudyCardData> cards;

  const StudyCardGrid({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w), // ✅ 对应小程序 10rpx = 5.w
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          // ✅ 小程序卡片高度 160rpx = 80.h
          // 对应小程序 margin-right + margin-left = 16rpx + 16rpx = 32rpx = 16.w
          childAspectRatio: 1.3,
          crossAxisSpacing: 16.w, // ✅ 对应小程序横向间距 32rpx = 16.w
          mainAxisSpacing: 8.h,   // ✅ 对应小程序纵向间距 16rpx = 8.h
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
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16.r), // ✅ 对应小程序 32rpx = 16.r
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.w), // ✅ 对应小程序 32rpx = 16.w
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
              SizedBox(width: 12.5.w), // ✅ 小程序25rpx ÷ 2 = 12.5.w
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp, // ✅ 小程序28rpx ÷ 2 = 14.sp
                        fontWeight: FontWeight.w600, // ✅ 小程序font-weight: 600
                        color: AppColors.textPrimary,
                        height: 1.5, // ✅ 小程序line-height: 1.5
                      ),
                    ),
                    SizedBox(height: 3.h), // ✅ 小程序6rpx ÷ 2 = 3.h
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11.sp, // ✅ 小程序22rpx ÷ 2 = 11.sp
                        fontWeight: FontWeight.normal,
                        color: AppColors.textHint, // ✅ 小程序#666
                        height: 1.5, // ✅ 小程序line-height: 1.5
                      ),
                      maxLines: 2, // ✅ 允许换行显示完整描述
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
