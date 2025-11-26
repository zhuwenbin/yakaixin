import 'package:flutter/material.dart';

/// P3-8 排行榜 - 成绩排名
class RankListPage extends StatelessWidget {
  final String? examId;
  
  const RankListPage({super.key, this.examId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('排行榜')),
      body: const Center(child: Text('排行榜页面')),
    );
  }
}
