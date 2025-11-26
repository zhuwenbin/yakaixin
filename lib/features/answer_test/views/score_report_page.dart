import 'package:flutter/material.dart';

/// P2-6 成绩报告 - 练习成绩
class ScoreReportPage extends StatelessWidget {
  final String? practiceId;
  
  const ScoreReportPage({
    super.key,
    this.practiceId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('成绩报告')),
      body: const Center(child: Text('成绩报告页面')),
    );
  }
}
