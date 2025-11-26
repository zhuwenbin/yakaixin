import 'package:flutter/material.dart';

/// P2-12 测评练习 - 测评做题
class IntelligentPractisePage extends StatelessWidget {
  final String? evaluationId;
  
  const IntelligentPractisePage({super.key, this.evaluationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('测评练习')),
      body: const Center(child: Text('测评练习页面')),
    );
  }
}
