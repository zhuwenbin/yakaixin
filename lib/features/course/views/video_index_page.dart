import 'package:flutter/material.dart';

/// P4-5 视频播放 - 录播观看
class VideoIndexPage extends StatelessWidget {
  final String? lessonId;
  
  const VideoIndexPage({super.key, this.lessonId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('视频播放')),
      body: const Center(child: Text('视频播放页面')),
    );
  }
}
