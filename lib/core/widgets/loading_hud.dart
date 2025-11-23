import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/// HUD加载提示
/// 对应小程序: uni.showLoading
class LoadingHUD {
  /// 初始化配置
  static void init() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.circle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.white
      ..backgroundColor = Colors.black.withOpacity(0.7)
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = Colors.black.withOpacity(0.5)
      ..userInteractions = false
      ..dismissOnTap = false;
  }

  /// 显示加载中
  static void show([String? message]) {
    EasyLoading.show(status: message ?? '加载中...');
  }

  /// 显示成功
  static void showSuccess([String? message]) {
    EasyLoading.showSuccess(message ?? '操作成功');
  }

  /// 显示失败
  static void showError([String? message]) {
    EasyLoading.showError(message ?? '操作失败');
  }

  /// 显示信息
  static void showInfo(String message) {
    EasyLoading.showInfo(message);
  }

  /// 显示进度
  static void showProgress(double progress, [String? status]) {
    EasyLoading.showProgress(progress, status: status);
  }

  /// 隐藏
  static void dismiss() {
    EasyLoading.dismiss();
  }

  /// 是否正在显示
  static bool get isShow => EasyLoading.isShow;
}
