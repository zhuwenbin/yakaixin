import 'package:flutter/material.dart';

/// P5-2 我的订单 - 订单列表
class MyOrderPage extends StatelessWidget {
  const MyOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的订单')),
      body: const Center(child: Text('我的订单页面')),
    );
  }
}
