import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 统一确认对话框组件
///
/// 对应小程序: uni.showModal
///
/// 使用场景:
/// - 退出登录确认
/// - 删除确认
/// - 操作确认
/// - 其他需要用户确认的操作
///
/// 示例:
/// ```dart
/// final confirmed = await ConfirmDialog.show(
///   context,
///   title: '提示',
///   content: '确定退出登录',
/// );
/// if (confirmed == true) {
///   // 执行确认操作
/// }
/// ```
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
  });

  /// 显示确认对话框
  ///
  /// 返回 true 表示用户点击了"确定"，false 表示点击了"取消"或关闭
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfirmDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ 标题（居中）
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF333333),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            // ✅ 内容（居中）
            Text(
              content,
              style: TextStyle(fontSize: 14.sp, color: const Color(0xFF666666)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            // ✅ 按钮（左右分布）
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 取消按钮（左侧）
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      onCancel?.call();
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      cancelText ?? '取消',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFF387DFC),
                      ),
                    ),
                  ),
                ),
                // 确定按钮（右侧）
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      onConfirm?.call();
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      confirmText ?? '确定',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFF387DFC),
                      ),
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
}
