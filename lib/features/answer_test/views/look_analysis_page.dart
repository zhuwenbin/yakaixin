import 'package:flutter/material.dart';

/// P2-5 查看解析 - 题目解析
class LookAnalysisPage extends StatelessWidget {
  final String? practiceId;
  
  const LookAnalysisPage({
    super.key,
    this.practiceId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('查看解析')),
      body: const Center(child: Text('查看解析页面')),
    );
  }
}
