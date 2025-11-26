import 'package:flutter/material.dart';

/// P2-8 关卡列表 - 关卡选择
class LevelListPage extends StatelessWidget {
  final String? challengeId;
  
  const LevelListPage({super.key, this.challengeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('关卡列表')),
      body: const Center(child: Text('关卡列表页面')),
    );
  }
}
