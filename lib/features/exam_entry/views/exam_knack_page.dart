import 'package:flutter/material.dart';

/// P2-16 考点口诀 - 口诀列表
class ExamKnackPage extends StatelessWidget {
  const ExamKnackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('考点口诀')),
      body: const Center(child: Text('考点口诀页面')),
    );
  }
}
