import 'package:flutter/material.dart';

/// P2-9 闯关练习 - 闯关做题
class ChallengePractisePage extends StatelessWidget {
  final String? levelId;
  
  const ChallengePractisePage({super.key, this.levelId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('闯关练习')),
      body: const Center(child: Text('闯关练习页面')),
    );
  }
}
