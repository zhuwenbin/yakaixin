import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// P5-1-5 学习报告中心页
/// 对应小程序: modules/jintiku/pages/userInfo/report.vue
class ReportCenterPage extends ConsumerStatefulWidget {
  const ReportCenterPage({super.key});

  @override
  ConsumerState<ReportCenterPage> createState() => _ReportCenterPageState();
}

class _ReportCenterPageState extends ConsumerState<ReportCenterPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  // Mock数据
  final Map<String, dynamic> _baseInfo = {
    'total_num': 1250,
    'today_learn_time': 15,
    'correct_rate': '85',
    'learn_time': '72',
    'knowledge_num': 120,
    'today_total_num': 50,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('学习报告'),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.h),
          child: _buildTabBar(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStudyData(),
          _buildScoreReport(),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: const Color(0xFF1890FF),
        indicatorWeight: 3,
        labelColor: const Color(0xFF1890FF),
        unselectedLabelColor: const Color(0xFF666666),
        labelStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
        ),
        tabs: const [
          Tab(text: '学习数据'),
          Tab(text: '成绩报告'),
        ],
      ),
    );
  }

  Widget _buildStudyData() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildStatisticsCard(),
          SizedBox(height: 16.h),
          _buildTodayCard(),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildMainStat(
                  '${_baseInfo['total_num']}',
                  '道',
                  '刷题量',
                ),
              ),
              Container(
                width: 1,
                height: 60.h,
                color: const Color(0xFFE8E8E8),
              ),
              Expanded(
                child: _buildMainStat(
                  '${_baseInfo['today_learn_time']}',
                  '天',
                  '坚持天数',
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: _buildSecondaryStat('正确率', '${_baseInfo['correct_rate']}%'),
              ),
              Expanded(
                child: _buildSecondaryStat('学习累计时长', '${_baseInfo['learn_time']}h'),
              ),
              Expanded(
                child: _buildSecondaryStat('学习知识点', '${_baseInfo['knowledge_num']}个'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainStat(String value, String unit, String label) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1890FF),
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              unit,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF666666),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF999999),
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF999999),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  Widget _buildTodayCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '今日学习',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF333333),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTodayItem('刷题量', '${_baseInfo['today_total_num']}道'),
              _buildTodayItem('学习时长', '${_baseInfo['today_learn_time']}h'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodayItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF666666),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1890FF),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreReport() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assessment_outlined,
            size: 80.sp,
            color: const Color(0xFFCCCCCC),
          ),
          SizedBox(height: 16.h),
          Text(
            '暂无成绩报告',
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }
}
