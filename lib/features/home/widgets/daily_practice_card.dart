import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/style/app_style_config.dart';
import '../../../core/style/app_style_tokens.dart';
import '../models/question_bank_model.dart';
import 'section_title.dart';

/// 每日一测卡片
class DailyPracticeCard extends StatelessWidget {
  final DailyPracticeModel dailyPractice;
  final VoidCallback onTap;
  final AppStyleTokens? styleTokens;

  const DailyPracticeCard({
    super.key,
    required this.dailyPractice,
    required this.onTap,
    this.styleTokens,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: '每日一测'),
          SizedBox(height: 12.h),
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16.r),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16.r),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // 渐变背景（Positioned.fill 避免无界高度导致 parentData 断言）
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: styleTokens?.config.template == AppStyleTemplate.green
                                ? const [Color(0xFFCFFAE8), Color(0xFFFFFFFF)]
                                : const [Color(0xFFEBF8FF), Color(0xFFFFFFFF)],
                            stops: const [0.0, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                    ),
                    // 绿色模版：右侧装饰背景图
                    if (styleTokens?.config.template == AppStyleTemplate.green)
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        width: 160.w,
                        child: Image.asset(
                          'assets/images/Template/tiku/mokao_back.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                    // 前景内容（决定 Stack 尺寸）
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 标题
                          Text(
                            '每日一练',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF161F30),
                              height: 1.0,
                            ),
                          ),
                          // 立即刷题按钮（使用模板 action 渐变）
                          Builder(
                      builder: (_) {
                        final c = styleTokens?.colors;
                        final start = c?.actionGradientStart ?? const Color(0xFFFF860E);
                        final end = c?.actionGradientEnd ?? const Color(0xFFFF6912);
                        return Container(
                          width: 100.w,
                          height: 35.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [start, end],
                            ),
                            borderRadius: BorderRadius.circular(35.r),
                          ),
                          child: Center(
                            child: Text(
                              '立即刷题',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
