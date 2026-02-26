import 'package:flutter/material.dart';

/// 应用颜色常量
///
/// 所有颜色值必须在此文件中定义，禁止在Widget中硬编码颜色
class AppColors {
  AppColors._();

  // ============ 主色调 ============

  /// 主色 - 蓝色 #2E68FF
  static const Color primary = Color(0xFFFF6B35);

  /// 主色 - 渐变起始色
  static const Color primaryGradientStart = Color(0xFF2E68FF);

  /// 主色 - 渐变结束色
  static const Color primaryGradientEnd = Color(0xFF1A4FCC);

  /// 次要色
  static const Color secondary = Color(0xFFFF6B35);

  /// 强调色
  static const Color accent = Color(0xFFFFD700);

  // ============ 功能色 ============

  /// 成功 - 绿色
  static const Color success = Color(0xFF52C41A);

  /// 警告 - 橙色
  static const Color warning = Color(0xFFFAAD14);

  /// 错误 - 红色
  static const Color error = Color(0xFFF5222D);

  /// 信息 - 蓝色
  static const Color info = Color(0xFF1890FF);

  // ============ 文本色 ============

  /// 主要文本 - 深灰 #333333
  static const Color textPrimary = Color(0xFF333333);

  /// 次要文本 - 中灰 #666666
  static const Color textSecondary = Color(0xFF666666);

  /// 提示文本 - 浅灰 #999999
  static const Color textHint = Color(0xFF999999);

  /// 禁用文本 - 超浅灰 #CCCCCC
  static const Color textDisabled = Color(0xFFCCCCCC);

  /// 白色文本
  static const Color textWhite = Color(0xFFFFFFFF);

  // ============ 背景色 ============

  /// 页面背景 - 浅灰 #F5F5F5
  static const Color background = Color(0xFFF5F5F5);

  static const Color backgroundLightGray = Color.fromARGB(255, 242, 243, 244);

  /// 卡片背景 - 白色
  static const Color surface = Color(0xFFFFFFFF);

  /// 卡片背景 - 浅色  #E0F0FF
  static const Color card = Color(0xFFE0F0FF);

  /// 输入框背景
  static const Color inputBackground = Color(0xFFF7F8FA);

  // ============ 边框色 ============

  /// 边框 - 浅灰 #E5E5E5
  static const Color border = Color(0xFFE5E5E5);

  /// 分割线 - 超浅灰 #F0F0F0
  static const Color divider = Color(0xFFF0F0F0);

  // ============ 遮罩色 ============

  /// 黑色半透明遮罩 (0.5透明度)
  static const Color maskDark = Color(0x80000000);

  /// 白色半透明遮罩 (0.5透明度)
  static const Color maskLight = Color(0x80FFFFFF);

  // ============ 特殊状态色 ============

  /// 未购买状态
  static const Color unpurchased = Color(0xFFFF6B35);

  /// 已购买状态
  static const Color purchased = Color(0xFF52C41A);

  /// 已过期状态
  static const Color expired = Color(0xFF999999);

  // ============ 秒杀专用色 ============

  /// 秒杀渐变起始色
  static const Color seckillGradientStart = Color(0xFFFBF1FF);

  /// 秒杀渐变结束色
  static const Color seckillGradientEnd = Color(0xFFD8F0FF);

  /// 秒杀价格色（粉红）
  static const Color seckillPrice = Color(0xFFD845A6);

  /// 秒杀标签背景色（黄色）
  static const Color seckillTagBg = Color(0xFFFFD27C);

  /// 秒杀标签文字色（红色）
  static const Color seckillTagText = Color(0xFFFF0000);

  /// 秒杀倒计时文字色（深蓝）
  static const Color seckillCountdownText = Color(0xFF082980);

  // ============ 课程专用色 ============

  /// 课程标签背景色（浅蓝）
  static const Color courseTagBg = Color(0xFFE3EBFF);

  /// 课程标签文字色
  static const Color courseTagText = Color(0xFF2E68FF);

  /// 课程价格色（橙色）
  static const Color coursePrice = Color(0xFFFF7600);

  /// 课程次要信息文字色（半透明黑）
  static const Color courseSecondaryText = Color(0xA603203D);

  /// 课程页日期选中色（与小程序 #018CFF 一致，周历/日历选中、小圆点）
  static const Color courseDatePrimary = Color(0xFF018CFF);

  // ============ 题库专用色 ============

  /// 题库标签背景色（浅蓝）
  static const Color tikuTagBg = Color(0xFFEBF1FF);

  /// 题库标签文字色
  static const Color tikuTagText = Color(0xFF2E68FF);

  /// 题库标签边框色
  static const Color tikuTagBorder = Color(0xFF4981D7);

  /// 题库价格色（橙红）
  static const Color tikuPrice = Color(0xFFFF5E00);

  /// 科目模考购买按钮色（橙红 #FF5402）
  static const Color subjectMockBuyButton = Color(0xFFFF5402);

  /// 科目模考价格色（红色 #CD3F2F）
  static const Color subjectMockPrice = Color(0xFFCD3F2F);

  // ============ Tab切换色 ============

  /// Tab激活指示器颜色
  static const Color tabIndicator = Color(0xFF018BFF);

  /// Tab未激活文字颜色
  static const Color tabInactiveText = Color(0xFF666666);

  // ============ 阴影色 ============

  /// 秒杀卡片阴影
  static const Color seckillShadow = Color(0x0F1B2637);

  /// 普通卡片阴影（浅）
  static const Color cardShadowLight = Color(0x08000000);

  /// 普通卡片阴影（中）
  static const Color cardShadowMedium = Color(0x0D000000);

  /// 普通卡片阴影（深）
  static const Color cardShadowDark = Color(0x14000000);
}
