import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// P5-1-2 历年真题商品详情页
/// 对应小程序: modules/jintiku/pages/test/secretRealDetail.vue
class SecretRealDetailPage extends ConsumerStatefulWidget {
  final String? productId;
  final String? professionalId;

  const SecretRealDetailPage({
    super.key,
    this.productId,
    this.professionalId,
  });

  @override
  ConsumerState<SecretRealDetailPage> createState() => _SecretRealDetailPageState();
}

class _SecretRealDetailPageState extends ConsumerState<SecretRealDetailPage> {
  // Mock数据
  final Map<String, dynamic> _goodsInfo = {
    'examTitle': '口腔执业医师',
    'name': '2026口腔执业医师历年真题精选',
    'tiku_goods_details': {
      'question_num': 3580,
      'exam_time': '2026-12-31',
    },
    'paper_statistics': {
      'do_count': 0,
      'total_accuracy_rate': '0',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('绝密真题'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildContent(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildBlueBackground(),
          _buildGoodsCard(),
          SizedBox(height: 80.h),
        ],
      ),
    );
  }

  /// 蓝色背景
  Widget _buildBlueBackground() {
    return Container(
      height: 100.h,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4A90E2), Color(0xFF5BA3F5)],
        ),
      ),
    );
  }

  /// 商品信息卡片
  Widget _buildGoodsCard() {
    final info = _goodsInfo;
    final tikuDetails = info['tiku_goods_details'] as Map<String, dynamic>;
    final paperStats = info['paper_statistics'] as Map<String, dynamic>;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      transform: Matrix4.translationValues(0, -50.h, 0),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Text(
            info['examTitle']?.toString() ?? '',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF333333),
            ),
          ),
          SizedBox(height: 12.h),
          // 红色标签
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFF4D4F),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              '绝密真题',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          // 题目内容
          Text(
            '题目内容: ${info['name']}',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF666666),
            ),
          ),
          SizedBox(height: 20.h),
          // 统计信息列表
          _buildStatsList(tikuDetails, paperStats),
        ],
      ),
    );
  }

  /// 统计信息列表
  Widget _buildStatsList(Map<String, dynamic> tikuDetails, Map<String, dynamic> paperStats) {
    return Column(
      children: [
        _buildStatsItem(
          '总题数:',
          '${tikuDetails['question_num'] ?? 0}',
        ),
        _buildDivider(),
        _buildStatsItem(
          '做题次数:',
          '${paperStats['do_count'] ?? 0}',
        ),
        _buildDivider(),
        _buildStatsItem(
          '正确率:',
          '${paperStats['total_accuracy_rate'] ?? '0'}%',
        ),
        _buildDivider(),
        _buildStatsItem(
          '错题:',
          '查看错题',
          isLink: true,
          onTap: _goToWrongQuestions,
        ),
        _buildDivider(),
        _buildStatsItem(
          '题库到期时间:',
          tikuDetails['exam_time']?.toString() ?? '',
        ),
      ],
    );
  }

  Widget _buildStatsItem(String label, String value, {bool isLink = false, VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF666666),
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                color: isLink ? const Color(0xFF1890FF) : const Color(0xFF333333),
                fontWeight: isLink ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: const Color(0xFFF0F0F0),
    );
  }

  /// 底部按钮栏
  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: GestureDetector(
          onTap: _startPractice,
          child: Container(
            width: double.infinity,
            height: 48.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
              ),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Center(
              child: Text(
                '开始冲刺做题',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 查看错题
  void _goToWrongQuestions() {
    // TODO: 跳转到错题本页面
    print('查看错题');
  }

  /// 开始做题
  void _startPractice() {
    // TODO: 开始做题
    print('开始做题');
  }
}
