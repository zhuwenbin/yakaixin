import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 应用间距常量
/// 
/// 遵循8的倍数设计系统，所有间距必须使用本类定义的常量
class AppSpacing {
  AppSpacing._();

  // ============ 水平间距 ============
  
  static final double xs = 4.w;   // 超小间距
  static final double sm = 8.w;   // 小间距
  static final double md = 16.w;  // 中间距
  static final double lg = 24.w;  // 大间距
  static final double xl = 32.w;  // 超大间距
  static final double xxl = 48.w; // 超超大间距

  // ============ 垂直间距 ============
  
  static final double xsV = 4.h;   // 超小垂直间距
  static final double smV = 8.h;   // 小垂直间距
  static final double mdV = 16.h;  // 中垂直间距
  static final double lgV = 24.h;  // 大垂直间距
  static final double xlV = 32.h;  // 超大垂直间距
  static final double xxlV = 48.h; // 超超大垂直间距

  // ============ 常用EdgeInsets ============
  
  /// 无间距
  static final zero = EdgeInsets.zero;
  
  /// 全方向超小间距
  static final allXs = EdgeInsets.all(xs);
  
  /// 全方向小间距
  static final allSm = EdgeInsets.all(sm);
  
  /// 全方向中间距
  static final allMd = EdgeInsets.all(md);
  
  /// 全方向大间距
  static final allLg = EdgeInsets.all(lg);
  
  /// 全方向超大间距
  static final allXl = EdgeInsets.all(xl);
  
  /// 水平中间距
  static final horizontalMd = EdgeInsets.symmetric(horizontal: md);
  
  /// 垂直中间距
  static final verticalMd = EdgeInsets.symmetric(vertical: mdV);
  
  /// 页面标准内边距 (水平16, 垂直16)
  static final pagePadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: mdV,
  );
  
  /// 卡片标准内边距 (水平16, 垂直12)
  static final cardPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: 12.h,
  );
}
