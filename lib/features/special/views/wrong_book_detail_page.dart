import 'package:flutter/material.dart';

/// P7-2 错题详情 - 错题解析
class WrongBookDetailPage extends StatelessWidget {
  final String? questionId;
  
  const WrongBookDetailPage({super.key, this.questionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('错题详情')),
      body: const Center(child: Text('错题详情页面')),
    );
  }
}
