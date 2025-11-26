import 'package:flutter/material.dart';

/// P2-13 测评报告 - 测评成绩
class IntelligentReportPage extends StatelessWidget {
  final String? practiceId;
  
  const IntelligentReportPage({super.key, this.practiceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('测评报告')),
      body: const Center(child: Text('测评报告页面')),
    );
  }
}
