import 'package:flutter/material.dart';

/// P3-2 模考详情 - 模考信息
class ExamInfoPage extends StatelessWidget {
  final String? examId;
  
  const ExamInfoPage({super.key, this.examId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('模考详情')),
      body: const Center(child: Text('模考详情页面')),
    );
  }
}
