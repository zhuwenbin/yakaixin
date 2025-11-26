import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 直播课程页面 - 对应小程序 study/live/index.vue
/// 功能：观看直播课程
class LivePlayerPage extends ConsumerStatefulWidget {
  final String lessonId;

  const LivePlayerPage({
    super.key,
    required this.lessonId,
  });

  @override
  ConsumerState<LivePlayerPage> createState() => _LivePlayerPageState();
}

class _LivePlayerPageState extends ConsumerState<LivePlayerPage> {
  bool _isLive = true;
  int _viewerCount = 128;

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
      title: const Text('直播课程'),
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildLivePlayer(),
        Expanded(
          child: Container(
            color: Colors.white,
            child: _buildChatArea(),
          ),
        ),
        _buildInputBar(),
      ],
    );
  }

  Widget _buildLivePlayer() {
    return Container(
      width: double.infinity,
      height: 250.h,
      color: Colors.black87,
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isLive ? Icons.fiber_manual_record : Icons.play_circle_outline,
                  size: 64.sp,
                  color: _isLive ? Colors.red : Colors.white,
                ),
                SizedBox(height: 16.h),
                Text(
                  _isLive ? '直播中' : '回放',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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
          Positioned(
            top: 16.h,
            left: 16.w,
            child: _buildLiveBadge(),
          ),
          Positioned(
            top: 16.h,
            right: 16.w,
            child: _buildViewerCount(),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveBadge() {
    if (!_isLive) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            '直播',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewerCount() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.remove_red_eye, size: 14.sp, color: Colors.white),
          SizedBox(width: 4.w),
          Text(
            '$_viewerCount',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 10,
      itemBuilder: (context, index) {
        return _buildChatMessage(
          '用户${index + 1}',
          index % 3 == 0 ? '老师讲得真好！' : '这个知识点很重要',
        );
      },
    );
  }

  Widget _buildChatMessage(String username, String message) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF262629)),
          children: [
            TextSpan(
              text: '$username: ',
              style: TextStyle(
                color: const Color(0xFF018CFF),
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(text: message),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: const Color(0xFFE8E9EA)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 36.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '说点什么...',
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF999999),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () {
              // TODO: 发送消息
            },
            child: Container(
              width: 64.w,
              height: 36.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF018CFF),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Text(
                '发送',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
