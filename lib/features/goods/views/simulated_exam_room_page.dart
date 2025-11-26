import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// P5-1-4 模拟考场页
/// 对应小程序: modules/jintiku/pages/test/simulatedExamRoom.vue
class SimulatedExamRoomPage extends ConsumerStatefulWidget {
  final String? productId;
  final String? professionalId;

  const SimulatedExamRoomPage({
    super.key,
    this.productId,
    this.professionalId,
  });

  @override
  ConsumerState<SimulatedExamRoomPage> createState() => _SimulatedExamRoomPageState();
}

class _SimulatedExamRoomPageState extends ConsumerState<SimulatedExamRoomPage> {
  // Mock数据
  final Map<String, dynamic> _examInfo = {
    'examTitle': '口腔执业医师',
    'permission_status': '2', // 1-已购买 2-未购买
    'mkgoods_statistics': {
      'fullMarkScore': 600,
      'examDuration': 150,
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Stack(
          children: [
            _buildLeftSidebar(),
            _buildMainContent(),
          ],
        ),
      ),
    );
  }

  /// 左侧考生信息栏
  Widget _buildLeftSidebar() {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      width: 120.w,
      child: Container(
        color: const Color(0xFFFF6B6B),
        padding: EdgeInsets.symmetric(vertical: 30.h),
        child: Column(
          children: [
            _buildSidebarItem('姓名：', 'FELIXELICSI'),
            SizedBox(height: 20.h),
            _buildSidebarItem('准考证号：', '1001'),
            SizedBox(height: 20.h),
            _buildSidebarItem('考场号：', '01'),
            SizedBox(height: 20.h),
            _buildSidebarItem('座位号：', '01'),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// 主内容区域
  Widget _buildMainContent() {
    return Container(
      margin: EdgeInsets.only(left: 120.w),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 24.h),
            _buildInfoSummary(),
            SizedBox(height: 24.h),
            _buildNotice(),
            SizedBox(height: 32.h),
            _buildEnterButton(),
          ],
        ),
      ),
    );
  }

  /// 标题区域
  Widget _buildHeader() {
    final examTitle = _examInfo['examTitle']?.toString() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          examTitle,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF333333),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: const Color(0xFF1890FF),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            '模拟考场',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  /// 考试信息摘要
  Widget _buildInfoSummary() {
    final stats = _examInfo['mkgoods_statistics'] as Map<String, dynamic>;
    final fullScore = stats['fullMarkScore'] ?? 0;
    final duration = stats['examDuration'] ?? 0;

    return Row(
      children: [
        Text(
          '总分: ${fullScore}分',
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF666666),
          ),
        ),
        SizedBox(width: 24.w),
        Text(
          '时间: ${duration}分钟',
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  /// 注意事项
  Widget _buildNotice() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFE8E8E8),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '注意事项',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF333333),
            ),
          ),
          SizedBox(height: 12.h),
          _buildNoticeItem('1. 交卷后，显示分数及答案解析。'),
          _buildNoticeItem('2. 每天每个科目只能进行 1 次考试。', hasHighlight: true),
          _buildNoticeItem('3. 考试中途退出会保留做题记录。'),
        ],
      ),
    );
  }

  Widget _buildNoticeItem(String text, {bool hasHighlight = false}) {
    if (!hasHighlight) {
      return Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF666666),
            height: 1.6,
          ),
        ),
      );
    }

    // 处理高亮文本
    final parts = text.split('1');
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF666666),
            height: 1.6,
          ),
          children: [
            TextSpan(text: parts[0]),
            TextSpan(
              text: '1',
              style: TextStyle(
                color: const Color(0xFFFF4D4F),
                fontWeight: FontWeight.bold,
              ),
            ),
            if (parts.length > 1) TextSpan(text: parts[1]),
          ],
        ),
      ),
    );
  }

  /// 进入考场按钮
  Widget _buildEnterButton() {
    return GestureDetector(
      onTap: _enterExamRoom,
      child: Container(
        width: double.infinity,
        height: 48.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF5BA3F5)],
          ),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Center(
          child: Text(
            '进入考场',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// 进入考场
  void _enterExamRoom() {
    // TODO: 根据permission_status判断是否已购买
    // 如果未购买，弹出购买弹窗
    // 如果已购买，开始考试
    print('进入考场');
  }
}
