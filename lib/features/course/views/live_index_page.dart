import 'package:flutter/material.dart';

/// P4-4 直播课程 - 直播观看
class LiveIndexPage extends StatelessWidget {
  final String? lessonId;
  
  const LiveIndexPage({super.key, this.lessonId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('直播课程')),
      body: const Center(child: Text('直播课程页面')),
    );
  }
}
