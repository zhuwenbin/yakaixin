import 'package:flutter/material.dart';

/// P2-4 做题页 - 做题界面
class MakeQuestionPage extends StatelessWidget {
  final String? practiceId;
  
  const MakeQuestionPage({
    super.key,
    this.practiceId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('做题')),
      body: const Center(child: Text('做题页面')),
    );
  }
}
