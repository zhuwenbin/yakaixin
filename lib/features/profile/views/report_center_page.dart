import 'package:flutter/material.dart';

/// P6-3 报告中心 - 历史报告
class ReportCenterPage extends StatelessWidget {
  const ReportCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('报告中心')),
      body: const Center(child: Text('报告中心页面')),
    );
  }
}
