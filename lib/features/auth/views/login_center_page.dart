import 'package:flutter/material.dart';

/// P1-1 登录中心 - 微信授权登录
class LoginCenterPage extends StatelessWidget {
  const LoginCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('登录中心')),
      body: const Center(child: Text('登录中心页面')),
    );
  }
}
