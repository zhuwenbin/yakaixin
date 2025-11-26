import 'package:flutter/material.dart';

/// P1-2 H5登录 - 手机号验证码登录
class H5LoginPage extends StatelessWidget {
  const H5LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('手机号登录')),
      body: const Center(child: Text('H5登录页面')),
    );
  }
}
