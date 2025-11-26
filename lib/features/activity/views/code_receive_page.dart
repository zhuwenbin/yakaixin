import 'package:flutter/material.dart';

/// P9-1 兑换码领取 - 兑换码兑换
class CodeReceivePage extends StatelessWidget {
  final String? code;
  
  const CodeReceivePage({super.key, this.code});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('兑换码领取')),
      body: const Center(child: Text('兑换码领取页面')),
    );
  }
}
