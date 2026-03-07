import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';

/// 学习卡片网格（绝密押题、科目模考、模拟考试、学习报告）
class StudyCardGrid extends StatelessWidget {
  final List<StudyCardData> cards;
  final double cardRadius;
  final double cardPadding;

  const StudyCardGrid({
    super.key,
    required this.cards,
    this.cardRadius = 16,
    this.cardPadding = 16,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ 小程序卡片固定高度 160rpx = 80.h
    final double cardHeight = 80.h;
    final double cellWidth = (MediaQuery.sizeOf(context).width - 10.w * 2 - 16.w) / 2;
    final double aspectRatio = cellWidth / cardHeight;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w), // ✅ 对应小程序 padding 10rpx
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: aspectRatio, // 固定高度 80.h，与小程序 160rpx 一致
          crossAxisSpacing: 16.w, // ✅ 对应小程序 16rpx 间距
          mainAxisSpacing: 8.h, // ✅ 对应小程序 16rpx ÷ 2 = 8.h
        ),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return _StudyCard(
            title: card.title,
            subtitle: card.subtitle,
            imageUrl: card.imageUrl,
            onTap: card.onTap,
            cardRadius: cardRadius,
            cardPadding: cardPadding,
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
  final double cardRadius;
  final double cardPadding;

  const _StudyCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
    required this.cardRadius,
    required this.cardPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(cardRadius.r), // ✅ 对应小程序 32rpx = 16.r
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(cardPadding.w), // ✅ 对应小程序 32rpx = 16.w
          child: Row(
            children: [
              _buildImage(imageUrl),
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
                        fontSize: 14.sp, // 对应小程序 study-card-grid.vue .card-title: 28rpx
                        fontWeight: FontWeight.w600, // 对应小程序 font-weight: 600
                        color: AppColors.textPrimary, // 对应小程序 #333
                        height: 1.5, // 对应小程序 line-height: 1.5
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

  Widget _buildImage(String imageUrl) {
    final isAsset = imageUrl.startsWith('assets/');
    if (isAsset) {
      return Image.asset(
        imageUrl,
        width: 30.w,
        height: 30.w,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(
          Icons.image,
          size: 30.w,
          color: AppColors.textDisabled,
        ),
      );
    }
    return Image.network(
      imageUrl,
      width: 30.w,
      height: 30.w,
      errorBuilder: (_, __, ___) => Icon(
        Icons.image,
        size: 30.w,
        color: AppColors.textDisabled,
      ),
    );
  }
}
