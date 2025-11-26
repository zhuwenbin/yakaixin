import 'package:flutter/material.dart';

/// P2-15 词条详情 - 考点内容
class ExamEntryDetailPage extends StatelessWidget {
  final String? entryId;
  
  const ExamEntryDetailPage({super.key, this.entryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('词条详情')),
      body: const Center(child: Text('词条详情页面')),
    );
  }
}
