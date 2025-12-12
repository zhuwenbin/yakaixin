import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_radius.dart';
import '../models/question_bank_model.dart';
import '../../../../app/config/api_config.dart';

/// 学习日历卡片
class StudyCalendarCard extends StatelessWidget {
  final LearningDataModel? learningData;
  final bool isLoadingLearningData;
  final VoidCallback onCheckIn;

  const StudyCalendarCard({
    super.key,
    required this.learningData,
    required this.isLoadingLearningData,
    required this.onCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    final checkinNum = learningData?.checkinNum ?? 0;
    final totalNum = learningData?.totalNum ?? 0;
    final correctRate = learningData?.correctRate ?? '0';
    final isCheckin = (learningData?.isCheckin ?? 0) == 1;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radiusLg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                SizedBox(height: 20.h),
                _buildStatsRow(checkinNum, totalNum, correctRate),
                SizedBox(height: 20.h),
                _buildCheckInButton(isCheckin, onCheckIn),
              ],
            ),
          ),
          _buildDecoration(),
          _buildCheckInStatus(isCheckin),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      '学习日历',
      style: AppTextStyles.heading4.copyWith(
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildStatsRow(int checkinNum, int totalNum, String correctRate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _StatItem(label: '坚持打卡', value: '$checkinNum', unit: '天'),
        _buildDivider(),
        _StatItem(label: '做题总数', value: '$totalNum', unit: '题'),
        _buildDivider(),
        _StatItem(label: '正确率', value: correctRate, unit: '%'),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 40.h, color: AppColors.border);
  }

  Widget _buildCheckInButton(bool isCheckin, VoidCallback onCheckIn) {
    final isDisabled = isCheckin || isLoadingLearningData;

    return GestureDetector(
      onTap: isDisabled ? null : onCheckIn,
      child: Container(
        width: double.infinity,
        height: 44.h,
        decoration: BoxDecoration(
          color: isCheckin ? const Color(0xFFFFEEE7) : const Color(0xFFFF5500),
          borderRadius: AppRadius.radiusSm,
        ),
        child: Center(
          child: isLoadingLearningData
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCheckin ? const Color(0xFFF44900) : AppColors.textWhite,
                    ),
                  ),
                )
              : Text(
                  isCheckin ? '已打卡' : '打卡',
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: isCheckin ? const Color(0xFFF44900) : AppColors.textWhite,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDecoration() {
    return Positioned(
      top: 0,
      right: 0,
      child: Image.network(
        ApiConfig.completeImageUrl('study-card-color.png'),
        width: 130.w,
        height: 32.h,
        opacity: const AlwaysStoppedAnimation(0.8),
        errorBuilder: (context, error, stackTrace) {
          return SizedBox(width: 130.w, height: 32.h);
        },
      ),
    );
  }

  Widget _buildCheckInStatus(bool isCheckin) {
    return Positioned(
      top: 0,
      right: 0,
      width: 130.w,
      height: 32.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            ApiConfig.completeImageUrl('study-card-zan.png'),
            width: 16.w,
            height: 16.w,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                isCheckin ? Icons.check_circle : Icons.circle_outlined,
                size: 16.w,
                color: AppColors.textSecondary,
              );
            },
          ),
          SizedBox(width: 4.w),
          Text(
            isCheckin ? '今日已打卡' : '今日未打卡',
            style: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// 统计项组件
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _StatItem({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFF5500),
              ),
            ),
            SizedBox(width: 2.w),
            Text(
              unit,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
