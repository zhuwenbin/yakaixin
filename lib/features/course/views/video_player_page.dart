import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 视频播放页面 - 对应小程序 study/video/index.vue
/// 功能：播放录播视频课程
class VideoPlayerPage extends ConsumerStatefulWidget {
  final String lessonId;
  final String? orderId;
  final String? goodsId;

  const VideoPlayerPage({
    super.key,
    required this.lessonId,
    this.orderId,
    this.goodsId,
  });

  @override
  ConsumerState<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends ConsumerState<VideoPlayerPage> {
  Timer? _studyTimer;
  String? _dataId;

  @override
  void initState() {
    super.initState();
    _startStudyTracking();
  }

  @override
  void dispose() {
    _studyTimer?.cancel();
    super.dispose();
  }

  void _startStudyTracking() {
    // 立即记录一次
    _addStudyData();
    
    // 每5分钟记录一次学习数据
    _studyTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _addStudyData();
    });
  }

  Future<void> _addStudyData() async {
    // TODO: 调用API记录学习数据
    // final response = await addStudyData({
    //   'data_id': _dataId,
    //   'lesson_id': widget.lessonId,
    //   'play_position': '',
    //   'terminal': 4, // iOS
    //   'type': 2,
    //   'user_type': 1,
    // });
    // _dataId = response['data_id'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('回放详情'),
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildVideoPlayer(),
          SizedBox(height: 20.h),
          _buildLessonInfo(),
          SizedBox(height: 40.h),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      width: double.infinity,
      height: 200.h,
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_circle_outline,
              size: 64.sp,
              color: Colors.white,
            ),
            SizedBox(height: 16.h),
            Text(
              '视频播放器',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '课程ID: ${widget.lessonId}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonInfo() {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '口腔解剖学基础',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF262629),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '主讲：张教授  |  时长：45分钟',
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildControlButton(Icons.skip_previous, '上一节', () {}),
          _buildControlButton(Icons.play_arrow, '播放', () {}),
          _buildControlButton(Icons.skip_next, '下一节', () {}),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: const BoxDecoration(
              color: Color(0xFF018CFF),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
