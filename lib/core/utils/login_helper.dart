import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/routes/app_routes.dart';
import '../../features/auth/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/confirm_dialog.dart';

/// 登录检查工具类
/// 用于在需要登录的操作前检查登录状态，并提示用户登录
class LoginHelper {
  /// 检查是否已登录
  /// 
  /// 如果未登录，显示登录提示对话框
  /// 
  /// 返回 true 表示已登录，false 表示未登录
  static bool checkLogin(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.read(authProvider).isLoggedIn;
    
    if (!isLoggedIn) {
      _showLoginDialog(context);
      return false;
    }
    
    return true;
  }

  /// 显示登录提示对话框
  static void _showLoginDialog(BuildContext context) {
    ConfirmDialog.show(
      context,
      title: '需要登录',
      content: '此操作需要登录账户，请先登录后再试',
      confirmText: '去登录',
      cancelText: '取消',
      onConfirm: () {
        // ✅ 使用 GoRouterState.of(context).uri 获取当前完整路径（包括查询参数）
        final routerState = GoRouterState.of(context);
        final currentUri = routerState.uri;
        String returnPath = currentUri.path;
        if (currentUri.queryParameters.isNotEmpty) {
          final queryString = currentUri.queryParameters.entries
              .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
              .join('&');
          returnPath = '$returnPath?$queryString';
        }

        context.push(
          AppRoutes.loginCenter,
          extra: {'returnPath': returnPath},
        );
      },
    );
  }

  /// 检查登录状态（异步版本，用于需要等待用户登录的场景）
  /// 
  /// 如果未登录，显示登录提示对话框并跳转到登录页
  /// 返回 true 表示已登录或用户已去登录，false 表示用户取消
  static Future<bool> checkLoginAsync(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final isLoggedIn = ref.read(authProvider).isLoggedIn;
    
    if (!isLoggedIn) {
      final confirmed = await ConfirmDialog.show(
        context,
        title: '需要登录',
        content: '此操作需要登录账户，请先登录后再试',
        confirmText: '去登录',
        cancelText: '取消',
      );

      if (confirmed == true) {
        // ✅ 使用 GoRouterState.of(context).uri 获取当前完整路径（包括查询参数）
        final routerState = GoRouterState.of(context);
        final currentUri = routerState.uri;
        String returnPath = currentUri.path;
        if (currentUri.queryParameters.isNotEmpty) {
          final queryString = currentUri.queryParameters.entries
              .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
              .join('&');
          returnPath = '$returnPath?$queryString';
        }

        context.push(
          AppRoutes.loginCenter,
          extra: {'returnPath': returnPath},
        );
        return true;
      }

      return false;
    }
    
    return true;
  }
}
