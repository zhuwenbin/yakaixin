import 'package:flutter/material.dart';

/// P3-3 考试须知 - 考前须知
class ExamNoticePage extends StatelessWidget {
  final String? examId;
  
  const ExamNoticePage({super.key, this.examId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('考试须知')),
      body: const Center(child: Text('考试须知页面')),
    );
  }
}
