import 'package:flutter/material.dart';

/// P7-1 错题本 - 错题列表
class WrongBookIndexPage extends StatelessWidget {
  const WrongBookIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('错题本')),
      body: const Center(child: Text('错题本页面')),
    );
  }
}
