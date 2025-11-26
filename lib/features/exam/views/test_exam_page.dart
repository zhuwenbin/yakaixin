import 'package:flutter/material.dart';

/// P3-6 试卷详情 - 历史试卷
class TestExamPage extends StatelessWidget {
  final String? examId;
  
  const TestExamPage({super.key, this.examId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('试卷详情')),
      body: const Center(child: Text('试卷详情页面')),
    );
  }
}
