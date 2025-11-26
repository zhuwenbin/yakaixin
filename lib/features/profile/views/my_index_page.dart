import 'package:flutter/material.dart';

/// P6-1 个人中心 - 用户信息/菜单
class MyIndexPage extends StatelessWidget {
  const MyIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('个人中心')),
      body: const Center(child: Text('个人中心页面')),
    );
  }
}
