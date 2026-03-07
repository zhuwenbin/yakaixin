import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/style/app_style_tokens.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/question_bank_model.dart';
import 'section_title.dart';

/// 章节练习区域
/// 对应小程序: src/modules/jintiku/components/commen/index-nav.vue
/// 浅灰色「有效期」标签不使用模板色
class ChapterPracticeSection extends StatelessWidget {
  final ChapterExerciseModel? chapterExercise;
  final bool isLoading;
  final VoidCallback onTap;
  final AppStyleTokens? styleTokens;

  const ChapterPracticeSection({
    super.key,
    required this.chapterExercise,
    required this.isLoading,
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
          const SectionTitle(title: '章节练习'),
          SizedBox(height: 12.h),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (chapterExercise == null)
            _buildEmptyState()
          else
            _ChapterExerciseCard(
              chapterExercise: chapterExercise!,
              onTap: onTap,
              styleTokens: styleTokens,
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      alignment: Alignment.center,
      child: Text(
        '暂无章节练习',
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
      ),
    );
  }
}

/// 章节练习卡片
/// 对应小程序: index-nav.vue 的 .chapter-exercise
class _ChapterExerciseCard extends StatelessWidget {
  final ChapterExerciseModel chapterExercise;
  final VoidCallback onTap;
  final AppStyleTokens? styleTokens;

  const _ChapterExerciseCard({
    required this.chapterExercise,
    required this.onTap,
    this.styleTokens,
  });

  @override
  Widget build(BuildContext context) {
    // 计算进度百分比
    final doQuestionNum = chapterExercise.doQuestionNum;
    final questionNumber = chapterExercise.questionNumber;
    final progress = questionNumber > 0 ? (doQuestionNum / questionNumber) : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // ✅ 移除固定高度，让内容自适应
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        decoration: BoxDecoration(
          // 对应小程序渐变背景
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEBF8FF), Colors.white],
            stops: [0.0, 0.4],
          ),
          borderRadius: BorderRadius.circular(16.r), // ✅ 修正：32rpx / 2 = 16.r
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题行
            Text(
              chapterExercise.name,
              style: TextStyle(
                fontSize: 15.sp, // ✅ 修正：30rpx / 2 = 15.sp
                fontWeight: FontWeight.w500,
                color: const Color(0xFF161f30),
                height: 1.0,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 7.h), // ✅ 修正：14rpx / 2 = 7.h (小程序 margin-bottom)
            // 标签行（题目数量、有效期）
            Row(
              children: [
                _buildTag(
                  '共${chapterExercise.questionNumber}道题目',
                  backgroundColor: styleTokens?.colors.tagBg ?? const Color(0xFFE0F0FF),
                  textColor: styleTokens?.colors.tagText ?? const Color(0xFF4783DC),
                ),
                SizedBox(width: 6.w), // ✅ 修正：12rpx / 2 = 6.w
                _buildTag(
                  '有效期:${chapterExercise.year}',
                  backgroundColor: const Color(0xFFEDF1F2),
                  textColor: const Color(0xFF777777),
                ),
              ],
            ),
            SizedBox(height: 10.h), // ✅ 修正：20rpx / 2 = 10.h
            // 底部行（进度条 + 按钮）
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 进度条区域
                Expanded(
                  child: Row(
                    children: [
                      // 进度条（对应小程序 .process + .current，轨道始终可见）
                      Flexible(
                        flex: 4,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final barWidth = constraints.maxWidth;
                            final fillWidth = barWidth * progress.clamp(0.0, 1.0);
                            return Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                // 轨道背景（始终完整显示）
                                Container(
                                  height: 8.h,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDDF3FD).withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                // 填充（使用模板 progressBar 色）
                                if (fillWidth > 0)
                                  Container(
                                    width: fillWidth,
                                    height: 8.h,
                                    decoration: BoxDecoration(
                                      color: styleTokens?.colors.progressBar ?? const Color(0xFF55C3FF),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 10.w), // ✅ 修正：20rpx / 2 = 10.w
                      // 进度文本
                      Text(
                        '$doQuestionNum/$questionNumber',
                        style: TextStyle(
                          fontSize: 12.sp, // ✅ 修正：24rpx / 2 = 12.sp
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF03203D).withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w), // ✅ 修正：16rpx / 2 = 8.w
                // 立即刷题按钮
                Container(
                  width: 99.w, // ✅ 修正：198rpx / 2 = 99.w
                  height: 35.h, // ✅ 修正：70rpx / 2 = 35.h
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        styleTokens?.colors.actionGradientStart ?? const Color(0xFFFF860E),
                        styleTokens?.colors.actionGradientEnd ?? const Color(0xFFFF6912),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18.r), // ✅ 修正：35rpx / 2 = 17.5 约等于 18.r
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '立即刷题',
                    style: TextStyle(
                      fontSize: 14.sp, // ✅ 修正：28rpx / 2 = 14.sp
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, {
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h), // ✅ 修正：20rpx/2=10.w, 10rpx/2=5.h
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4.r), // ✅ 修正：8rpx / 2 = 4.r
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp, // ✅ 修正：20rpx / 2 = 10.sp
          color: textColor,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
