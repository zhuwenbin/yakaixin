import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login_page.dart';
import '../../../core/utils/login_return_path_provider.dart';

/// P1-1 登录中心 - 使用 LoginPage 的登录UI
class LoginCenterPage extends ConsumerWidget {
  /// 登录成功后的返回路径（可选）
  final String? returnPath;

  const LoginCenterPage({super.key, this.returnPath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ 立即保存返回路径到 Provider（使用 Future.microtask 避免在 build 时修改）
    // 注意：必须在 build 时立即保存，因为路由拦截器可能在页面构建之前触发
    if (returnPath != null && returnPath!.isNotEmpty) {
      // ✅ 使用 Future.microtask 确保在 build 完成后立即保存（不等待下一帧）
      Future.microtask(() {
        setLoginReturnPath(ref, returnPath);
        print('🔄 [登录中心] 保存返回路径到 Provider: $returnPath');
      });
    }
    
    // ✅ 传递返回路径给 LoginPage
    return LoginPage(returnPath: returnPath);
  }
}
