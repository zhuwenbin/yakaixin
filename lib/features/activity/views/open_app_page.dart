import 'package:flutter/material.dart';

/// P9-3 打开APP - 跳转APP
class OpenAppPage extends StatelessWidget {
  const OpenAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('打开APP')),
      body: const Center(child: Text('打开APP页面')),
    );
  }
}
