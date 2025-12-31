import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
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
      margin: EdgeInsets.symmetric(horizontal: 12.w), // ✅ 对应小程序 25rpx = 12.5.w
      child: Stack(
        clipBehavior: Clip.none, // ✅ 允许装饰图溢出
        children: [
          // 主卡片内容
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r), // ✅ 对应小程序 32rpx = 16.r
            elevation: 2,
            shadowColor: Colors.black.withValues(alpha: 0.05),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Padding(
              padding: EdgeInsets.all(20.w), // ✅ 对应小程序 40rpx = 20.w
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
          ),
          // ✅ 装饰图和文字在Material外层，不被裁剪（对应小程序position:absolute）
          _buildDecoration(),
          _buildCheckInStatus(isCheckin),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      '学习日历',
      style: AppTextStyles.heading4.copyWith(color: AppColors.textPrimary),
    );
  }

  Widget _buildStatsRow(int checkinNum, int totalNum, String correctRate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _StatItem(label: '累计坚持天数', value: '$checkinNum', unit: '天'),
        _buildDivider(),
        _StatItem(label: '考试倒计时天数', value: _calculateCountdown(), unit: '天'),
        _buildDivider(),
        _ThirdStatItem(totalNum: totalNum, correctRate: correctRate),
      ],
    );
  }

  /// 计算考试倒计时天数
  /// 目标日期：每年8月22日
  /// 如果今年的8月22日已过，则计算到明年8月22日的天数
  String _calculateCountdown() {
    final today = DateTime.now();
    final currentYear = today.year;

    // 创建今年的8月22日
    var targetDate = DateTime(currentYear, 8, 22);

    // 如果今年的8月22日已经过了，就设置为明年的8月22日
    if (today.isAfter(targetDate)) {
      targetDate = DateTime(currentYear + 1, 8, 22);
    }

    // 计算天数差
    final daysDiff = targetDate.difference(today).inDays;

    return daysDiff.toString();
  }

  Widget _buildDivider() {
    return Container(width: 1.w, height: 40.h, color: AppColors.border);
  }

  Widget _buildCheckInButton(bool isCheckin, VoidCallback onCheckIn) {
    final isDisabled = isCheckin || isLoadingLearningData;

    return Material(
      color: isCheckin ? const Color(0xFFFFEEE7) : const Color(0xFFFF5500),
      borderRadius: BorderRadius.circular(8.r),
      clipBehavior: Clip.antiAliasWithSaveLayer, // ✅ 使用更强的抗锯齿模式
      child: InkWell(
        onTap: isDisabled ? null : onCheckIn,
        child: Container(
          width: double.infinity,
          height: 44.h,
          alignment: Alignment.center,
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
                    color: isCheckin
                        ? const Color(0xFFF44900)
                        : AppColors.textWhite,
                  ),
                ),
        ),
      ),
    );
  }

  /// 右上角装饰背景图（对应小程序 decoration-image）
  /// 小程序：position: absolute; top: 0; right: 0; width: 260rpx; height: 64rpx;
  /// ✅ 图片本身带有圆角设计，只需简单定位，不做裁剪处理
  Widget _buildDecoration() {
    return Positioned(
      top: -1,
      right: -1,
      child: Image.network(
        ApiConfig.completeImageUrl('study-card-color.png'),
        width: 130.w,
        height: 32.h,
        fit: BoxFit.contain, // ✅ 保持图片原有形状
        opacity: const AlwaysStoppedAnimation(0.8),
        errorBuilder: (context, error, stackTrace) {
          return SizedBox(width: 130.w, height: 32.h);
        },
      ),
    );
  }

  /// 右上角打卡状态文字（对应小程序 check-in-status）
  /// 叠加在装饰图片上方
  Widget _buildCheckInStatus(bool isCheckin) {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        width: 130.w,
        height: 32.h,
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ 使用图片图标（对应小程序 check-icon）
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
      ),
    );
  }
}

/// 统计项组件（前两项）
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

/// 第三项统计组件（做题数/正确率）
class _ThirdStatItem extends StatelessWidget {
  final int totalNum;
  final String correctRate;

  const _ThirdStatItem({required this.totalNum, required this.correctRate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '做题数:$totalNum',
          style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
        ),
        SizedBox(height: 8.h),
        Text(
          '正确率:$correctRate%',
          style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
