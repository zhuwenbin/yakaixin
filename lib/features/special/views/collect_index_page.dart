import 'package:flutter/material.dart';

/// P8-1 试题收藏 - 收藏题目列表
class CollectIndexPage extends StatelessWidget {
  const CollectIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('试题收藏')),
      body: const Center(child: Text('试题收藏页面')),
    );
  }
}
