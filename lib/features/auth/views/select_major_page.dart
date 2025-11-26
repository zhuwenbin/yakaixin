import 'package:flutter/material.dart';

/// P1-3 选择专业
class SelectMajorPage extends StatelessWidget {
  const SelectMajorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('选择专业')),
      body: const Center(child: Text('选择专业页面')),
    );
  }
}
