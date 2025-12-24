import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

/// 应用文字样式常量
/// 
/// 所有文字样式必须在此文件中定义，禁止在Widget中硬编码文字样式
class AppTextStyles {
  AppTextStyles._();

  // ============ 标题样式 ============
  
  /// 一级标题 - 24sp, 粗体
  static TextStyle heading1 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  /// 二级标题 - 20sp, 粗体
  static TextStyle heading2 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  /// 三级标题 - 18sp, 中粗
  static TextStyle heading3 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  /// 四级标题 - 16sp, 中粗
  static TextStyle heading4 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // ============ 正文样式 ============
  
  /// 大正文 - 16sp, 常规
  static TextStyle bodyLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  
  /// 中正文 - 14sp, 常规
  static TextStyle bodyMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  
  /// 小正文 - 12sp, 常规
  static TextStyle bodySmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // ============ 标签样式 ============
  
  /// 大标签 - 14sp, 常规
  static TextStyle labelLarge = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
  
  /// 中标签 - 12sp, 常规
  static TextStyle labelMedium = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textHint,
  );
  
  /// 小标签 - 10sp, 常规
  static TextStyle labelSmall = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textHint,
  );

  // ============ 按钮样式 ============
  
  /// 大按钮文字 - 16sp, 中粗
  static TextStyle buttonLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );
  
  /// 中按钮文字 - 14sp, 中粗
  static TextStyle buttonMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );
  
  /// 小按钮文字 - 12sp, 中粗
  static TextStyle buttonSmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );

  // ============ 价格样式 ============
  
  /// 大价格 - 24sp, 粗体, 红色
  static TextStyle priceLarge = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.error,
  );
  
  /// 中价格 - 18sp, 粗体, 红色
  static TextStyle priceMedium = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.error,
  );
  
  /// 小价格 - 14sp, 中粗, 红色
  static TextStyle priceSmall = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.error,
  );

  // ============ 秒杀专用样式 ============
  
  /// 秒杀价格符号 - 12sp, 粉红
  static TextStyle seckillPriceSymbol = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.seckillPrice,
  );
  
  /// 秒杀价格数字 - 20sp, 粗体, 粉红
  static TextStyle seckillPriceNumber = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w800,
    color: AppColors.seckillPrice,
  );
  
  /// 秒杀原价 - 16sp, 粗体, 灰色, 删除线
  static TextStyle seckillOriginalPrice = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w800,
    color: Color(0xFFA3A3A3),
    decoration: TextDecoration.lineThrough,
  );
  
  /// 秒杀标签文字 - 10sp, 中粗, 黑色
  static TextStyle seckillTagText = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
  
  /// 秒杀倒计时文字 - 14sp, 常规, 深蓝
  static TextStyle seckillCountdown = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.seckillCountdownText,
    letterSpacing: 6.w,
  );

  // ============ 课程专用样式 ============
  
  /// 课程标题 - 17sp, 中粗, 黑色
  static TextStyle courseTitle = TextStyle(
    fontSize: 17.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  /// 课程标签文字 - 12sp, 蓝色
  static TextStyle courseTag = TextStyle(
    fontSize: 12.sp,
    color: AppColors.courseTagText,
  );
  
  /// 课程价格符号 - 14sp, 橙色
  static TextStyle coursePriceSymbol = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.coursePrice,
  );
  
  /// 课程价格数字 - 18sp, 中粗, 橙色
  static TextStyle coursePriceNumber = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.coursePrice,
  );
  
  /// 课程次要信息 - 12sp, 半透明黑
  static TextStyle courseSecondary = TextStyle(
    fontSize: 12.sp,
    color: AppColors.courseSecondaryText,
  );

  // ============ 题库专用样式 ============
  
  /// 题库卡片标题 - 16sp, 中粗, 黑色
  static TextStyle tikuCardTitle = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  /// 题库标签文字 - 10sp, 常规, 蓝色
  static TextStyle tikuTag = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.tikuTagText,
  );
  
  /// 题库价格 - 14sp, 常规, 橙红
  static TextStyle tikuPrice = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.tikuPrice,
  );
  
  /// 题库按钮文字 - 14sp, 常规, 白色
  static TextStyle tikuButton = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textWhite,
  );
}
