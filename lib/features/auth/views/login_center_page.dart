import 'package:flutter/material.dart';
import 'login_page.dart';

/// P1-1 登录中心 - 使用 LoginPage 的登录UI
class LoginCenterPage extends StatelessWidget {
  const LoginCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 直接使用 LoginPage 的 UI
    return const LoginPage();
  }
}
