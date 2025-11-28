import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// 学习卡片网格
/// 对应小程序: 绝密押题、科目模考、模拟考试、学习报告
class StudyCardGrid extends StatelessWidget {
  final Function(int index)? onCardTap;

  const StudyCardGrid({
    super.key,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final cards = [
      {
        'title': '绝密押题',
        'subtitle': '名师密押 考后即焚',
        'imageUrl': 'https://yakaixin.oss-cn-beijing.aliyuncs.com/public/predictIcon.png',
      },
      {
        'title': '科目模考',
        'subtitle': '查漏补缺 直击重点',
        'imageUrl': 'https://yakaixin.oss-cn-beijing.aliyuncs.com/public/test-icon.png',
      },
      {
        'title': '模拟考试',
        'subtitle': '全真模拟 还原考场',
        'imageUrl': 'https://yakaixin.oss-cn-beijing.aliyuncs.com/public/exam-icon.png',
      },
      {
        'title': '学习报告',
        'subtitle': '实时学习情况',
        'imageUrl': 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/col-4.png',
      },
    ];

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
            title: card['title'] as String,
            subtitle: card['subtitle'] as String,
            imageUrl: card['imageUrl'] as String,
            onTap: () => onCardTap?.call(index),
          );
        },
      ),
    );
  }
}

/// 学习卡片单项
class _StudyCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback? onTap;

  const _StudyCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 图标
            CachedNetworkImage(
              imageUrl: imageUrl,
              width: 30.w,
              height: 30.w,
              errorWidget: (context, url, error) => Icon(
                Icons.image,
                size: 30.w,
                color: const Color(0xFFCCCCCC),
              ),
            ),
            SizedBox(width: 12.w),
            // 文字
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF999999),
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
