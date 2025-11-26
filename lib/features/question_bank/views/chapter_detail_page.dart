import 'package:flutter/material.dart';

/// P2-3 章节详情 - 章节题目列表
class ChapterDetailPage extends StatelessWidget {
  final String? chapterId;
  
  const ChapterDetailPage({
    super.key,
    this.chapterId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('章节详情')),
      body: const Center(child: Text('章节详情页面')),
    );
  }
}
