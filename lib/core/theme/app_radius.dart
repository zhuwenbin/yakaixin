import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 应用圆角常量
/// 
/// 所有圆角值必须使用本类定义的常量
class AppRadius {
  AppRadius._();

  // ============ 圆角值 ============
  
  static final double xs = 4.r;   // 超小圆角
  static final double sm = 8.r;   // 小圆角
  static final double md = 12.r;  // 中圆角
  static final double lg = 16.r;  // 大圆角
  static final double xl = 24.r;  // 超大圆角
  static final double circle = 9999.r; // 圆形

  // ============ BorderRadius ============
  
  static final BorderRadius radiusXs = BorderRadius.circular(xs);
  static final BorderRadius radiusSm = BorderRadius.circular(sm);
  static final BorderRadius radiusMd = BorderRadius.circular(md);
  static final BorderRadius radiusLg = BorderRadius.circular(lg);
  static final BorderRadius radiusXl = BorderRadius.circular(xl);
  static final BorderRadius radiusCircle = BorderRadius.circular(circle);
  
  /// 顶部圆角
  static final BorderRadius radiusTopMd = BorderRadius.only(
    topLeft: Radius.circular(md),
    topRight: Radius.circular(md),
  );
  
  /// 底部圆角
  static final BorderRadius radiusBottomMd = BorderRadius.only(
    bottomLeft: Radius.circular(md),
    bottomRight: Radius.circular(md),
  );
}
