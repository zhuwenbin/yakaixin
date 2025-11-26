import 'package:flutter/material.dart';

/// P2-10 闯关报告 - 闯关成绩
class ChallengeReportPage extends StatelessWidget {
  final String? practiceId;
  
  const ChallengeReportPage({super.key, this.practiceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('闯关报告')),
      body: const Center(child: Text('闯关报告页面')),
    );
  }
}
