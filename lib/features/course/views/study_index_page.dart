import 'package:flutter/material.dart';

/// P4-1 课程首页 - 学习日历/课程列表
class StudyIndexPage extends StatelessWidget {
  const StudyIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('学习中心')),
      body: const Center(child: Text('学习中心页面')),
    );
  }
}
