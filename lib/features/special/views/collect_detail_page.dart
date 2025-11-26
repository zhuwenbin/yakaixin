import 'package:flutter/material.dart';

/// P8-2 试题详情 - 收藏题目详情
class CollectDetailPage extends StatelessWidget {
  final String? questionId;
  
  const CollectDetailPage({super.key, this.questionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('试题详情')),
      body: const Center(child: Text('试题详情页面')),
    );
  }
}
