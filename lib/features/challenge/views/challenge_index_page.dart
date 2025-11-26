import 'package:flutter/material.dart';

/// P2-7 真题闯关 - 闯关入口
class ChallengeIndexPage extends StatelessWidget {
  const ChallengeIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('真题闯关')),
      body: const Center(child: Text('真题闯关页面')),
    );
  }
}
