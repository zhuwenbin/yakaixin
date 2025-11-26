import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// P6-3 报告中心 - 学习数据 & 成绩报告
/// 对应小程序: src/modules/jintiku/pages/userInfo/report.vue
class ReportCenterPage extends StatefulWidget {
  const ReportCenterPage({super.key});

  @override
  State<ReportCenterPage> createState() => _ReportCenterPageState();
}

class _ReportCenterPageState extends State<ReportCenterPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F8),
      appBar: AppBar(
        title: const Text('报告中心'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Tab栏
          _buildTabBar(),
          // 内容
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _StudyDataView(),
                _ScoreReportView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建Tab栏
  /// 对应小程序: .tabs 样式 (height: 80rpx → 40.h)
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      height: 40.h,  // 80rpx ÷ 2 = 40.h
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _tabController.animateTo(0),
              child: Center(
                child: AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, child) {
                    final isActive = _tabController.index == 0;
                    return Text(
                      '学习数据',
                      style: TextStyle(
                        fontSize: isActive ? 16.sp : 14.sp,  // 32rpx÷2=16, 28rpx÷2=14
                        fontWeight:
                            isActive ? FontWeight.w800 : FontWeight.normal,
                        color: isActive ? Color(0xFF2E68FF) : Color(0xFF787E8F),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _tabController.animateTo(1),
              child: Center(
                child: AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, child) {
                    final isActive = _tabController.index == 1;
                    return Text(
                      '成绩报告',
                      style: TextStyle(
                        fontSize: isActive ? 16.sp : 14.sp,  // 32rpx÷2=16, 28rpx÷2=14
                        fontWeight:
                            isActive ? FontWeight.w800 : FontWeight.normal,
                        color: isActive ? Color(0xFF2E68FF) : Color(0xFF787E8F),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 学习数据视图
class _StudyDataView extends StatelessWidget {
  const _StudyDataView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.w),  // 20rpx ÷ 2 = 10.w
      child: Column(
        children: [
          // 顶部统计卡片
          _buildTopStatCard(),
          SizedBox(height: 10.h),  // 20rpx ÷ 2 = 10.h
          // 刷题量图表卡片
          _buildQuestionCountCard(),
          SizedBox(height: 10.h),
          // 学习时长图表卡片
          _buildStudyTimeCard(),
          SizedBox(height: 10.h),
          // 易错知识点卡片
          _buildErrorKnowledgeCard(),
        ],
      ),
    );
  }

  /// 顶部统计卡片
  Widget _buildTopStatCard() {
    return Container(
      padding: EdgeInsets.all(10.w),  // 20rpx ÷ 2 = 10.w
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),  // 20rpx ÷ 2 = 10.r
      ),
      child: Column(
        children: [
          // 刷题量 & 坚持天数
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '1250',
                          style: TextStyle(
                            fontSize: 16.sp,  // 32rpx ÷ 2 = 16.sp
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2E68FF),
                            height: 1.0,
                          ),
                        ),
                        SizedBox(width: 7.w),  // 14rpx ÷ 2 = 7.w
                        Text(
                          '道',
                          style: TextStyle(
                            fontSize: 12.sp,  // 24rpx ÷ 2 = 12.sp
                            color: Color(0xFF787E8F),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),  // 24rpx ÷ 2 = 12.h
                    Text(
                      '刷题量',
                      style: TextStyle(
                        fontSize: 12.sp,  // 24rpx ÷ 2 = 12.sp
                        color: Color(0xFF787E8F),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1.w,  // 2rpx ÷ 2 = 1.w
                height: 40.h,  // 80rpx ÷ 2 = 40.h
                color: Color(0xFFD7E5FE),
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '30',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2E68FF),
                            height: 1.0,
                          ),
                        ),
                        SizedBox(width: 7.w),
                        Text(
                          '天',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Color(0xFF787E8F),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      '坚持天数',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFF787E8F),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),  // 40rpx ÷ 2 = 20.h
          // 三个小卡片:正确率、学习累计时长、学习知识点
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSmallStatCard('正确率', '85.2%'),
              _buildSmallStatCard('学习累计时长', '128h'),
              _buildSmallStatCard('学习知识点', '156个'),
            ],
          ),
        ],
      ),
    );
  }

  /// 小统计卡片
  Widget _buildSmallStatCard(String title, String value) {
    return Container(
      width: 100.w,  // 200rpx ÷ 2 = 100.w
      height: 60.h,  // 120rpx ÷ 2 = 60.h
      decoration: BoxDecoration(
        color: Color(0xFFF1F8FF),
        borderRadius: BorderRadius.circular(6.r),  // 12rpx ÷ 2 = 6.r
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,  // 26rpx ÷ 2 = 13.sp
              color: Color(0xFF787E8F),
            ),
          ),
          SizedBox(height: 8.h),  // 16rpx ÷ 2 = 8.h
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,  // 28rpx ÷ 2 = 14.sp
              fontWeight: FontWeight.w900,
              color: Color(0xFF161F30),
            ),
          ),
        ],
      ),
    );
  }

  /// 刷题量图表卡片
  Widget _buildQuestionCountCard() {
    return Container(
      padding: EdgeInsets.all(10.w),  // 20rpx ÷ 2
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),  // 20rpx ÷ 2
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '刷题量',
            style: TextStyle(
              fontSize: 15.sp,  // 30rpx ÷ 2
              fontWeight: FontWeight.w800,
              color: Color(0xFF161F30),
            ),
          ),
          SizedBox(height: 20.h),  // 40rpx ÷ 2
          // Tab切换:最近一周/按月查看
          _buildChartTabBar(),
          SizedBox(height: 10.h),  // 20rpx ÷ 2
          // 图表占位
          Container(
            height: 100.h,  // 200rpx ÷ 2
            alignment: Alignment.center,
            child: Text(
              '暂无任何数据!',
              style: TextStyle(
                fontSize: 12.sp,  // 24rpx ÷ 2
                color: Color(0xFFCCCCCC),
              ),
            ),
          ),
          SizedBox(height: 22.h),  // 44rpx ÷ 2
          // 今日刷题
          Row(
            children: [
              Text(
                '今日刷题',
                style: TextStyle(
                  fontSize: 13.sp,  // 26rpx ÷ 2
                  color: Color(0xFF787E8F),
                ),
              ),
              SizedBox(width: 12.w),  // 24rpx ÷ 2
              Text(
                '50道',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Color(0xFF161F30),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 学习时长图表卡片
  Widget _buildStudyTimeCard() {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '学习时长(h)',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: Color(0xFF161F30),
            ),
          ),
          SizedBox(height: 20.h),
          // Tab切换
          _buildChartTabBar(),
          SizedBox(height: 10.h),
          // 图表占位
          Container(
            height: 100.h,
            alignment: Alignment.center,
            child: Text(
              '暂无任何数据!',
              style: TextStyle(
                fontSize: 12.sp,
                color: Color(0xFFCCCCCC),
              ),
            ),
          ),
          SizedBox(height: 22.h),
          // 今日学习
          Row(
            children: [
              Text(
                '今日学习',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Color(0xFF787E8F),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                '2.5h',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Color(0xFF161F30),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 易错知识点卡片
  Widget _buildErrorKnowledgeCard() {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '易错知识点',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: Color(0xFF161F30),
            ),
          ),
          SizedBox(height: 10.h),
          // 易错知识点列表
          ...List.generate(5, (index) {
            final knowledgeItems = [
              '口腔组织病理学',
              '口腔解剖生理学',
              '牙体牙髓病学',
              '口腔修复学',
              '口腔颌面外科学',
            ];
            return Container(
              height: 28.h,  // 56rpx ÷ 2
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 8.w),  // 16rpx ÷ 2
                      Text(
                        knowledgeItems[index],
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${12 - index * 2}次',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Color(0xFF787E8F),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// 图表Tab栏
  Widget _buildChartTabBar() {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: Text(
              '最近一周',
              style: TextStyle(
                fontSize: 13.sp,  // 26rpx ÷ 2
                fontWeight: FontWeight.w800,
                color: Color(0xFF161F30),
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              '按月查看',
              style: TextStyle(
                fontSize: 13.sp,
                color: Color(0xFF787E8F),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 成绩报告视图
class _ScoreReportView extends StatefulWidget {
  const _ScoreReportView();

  @override
  State<_ScoreReportView> createState() => _ScoreReportViewState();
}

class _ScoreReportViewState extends State<_ScoreReportView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.w),  // 30rpx ÷ 2 = 15.w
      child: Container(
        padding: EdgeInsets.all(10.w),  // 20rpx ÷ 2
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),  // 20rpx ÷ 2
        ),
        child: Column(
          children: [
            // 搜索栏
            _buildSearchBar(),
            SizedBox(height: 20.h),  // 40rpx ÷ 2
            // 成绩报告列表
            Expanded(
              child: _buildReportList(),
            ),
          ],
        ),
      ),
    );
  }

  /// 搜索栏
  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 34.h,  // 68rpx ÷ 2 = 34.h
            padding: EdgeInsets.only(left: 16.w),  // 32rpx ÷ 2
            decoration: BoxDecoration(
              color: Color(0xFFF6F7F8),
              borderRadius: BorderRadius.circular(16.r),  // 32rpx ÷ 2
            ),
            alignment: Alignment.center,  // 垂直居中
            child: TextField(
              controller: _searchController,
              textAlignVertical: TextAlignVertical.center,  // 文字垂直居中
              decoration: InputDecoration(
                hintText: '输入考试名称',
                border: InputBorder.none,
                isDense: true,  // 紧凑模式
                contentPadding: EdgeInsets.zero,  // 移除默认padding
                hintStyle: TextStyle(
                  fontSize: 12.sp,  // 24rpx ÷ 2
                  color: Color(0xFFCCCCCC),
                ),
              ),
              style: TextStyle(fontSize: 12.sp),
            ),
          ),
        ),
        SizedBox(width: 6.w),  // 12rpx ÷ 2
        GestureDetector(
          onTap: () {
            // 搜索逻辑
          },
          child: Container(
            width: 66.w,  // 132rpx ÷ 2
            height: 34.h,  // 68rpx ÷ 2
            decoration: BoxDecoration(
              color: Color(0xFF2E68FF),
              borderRadius: BorderRadius.circular(16.r),
            ),
            alignment: Alignment.center,
            child: Text(
              '搜索',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 成绩报告列表
  Widget _buildReportList() {
    // Mock数据
    final reports = [
      {
        'time': '2024-01-20 14:30',
        'name': '口腔执业医师综合测试(一)',
        'score': '85',
        'rank': '120',
        'isPass': true,
      },
      {
        'time': '2024-01-15 10:20',
        'name': '口腔执业医师综合测试(二)',
        'score': '72',
        'rank': '256',
        'isPass': false,
      },
      {
        'time': '2024-01-10 16:45',
        'name': '口腔执业医师综合测试(三)',
        'score': '90',
        'rank': '68',
        'isPass': true,
      },
    ];

    if (reports.isEmpty) {
      return Center(
        child: Text(
          '暂无任何数据!',
          style: TextStyle(
            fontSize: 12.sp,  // 24rpx ÷ 2
            color: Color(0xFFCCCCCC),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return Container(
          margin: EdgeInsets.only(bottom: 20.h),  // 40rpx ÷ 2
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 时间
              Text(
                report['time'] as String,
                style: TextStyle(
                  fontSize: 15.sp,  // 30rpx ÷ 2
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF161F30),
                ),
              ),
              SizedBox(height: 12.h),  // 24rpx ÷ 2
              // 考试信息卡片
              Container(
                padding: EdgeInsets.fromLTRB(12.w, 15.h, 12.w, 0),  // 24/30rpx ÷ 2
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),  // 20rpx ÷ 2
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 考试名称
                    Text(
                      report['name'] as String,
                      style: TextStyle(
                        fontSize: 15.sp,  // 30rpx ÷ 2
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121),
                      ),
                    ),
                    SizedBox(height: 10.h),  // 20rpx ÷ 2
                    // 成绩和排名
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 左侧:成绩和排名
                        Row(
                          children: [
                            // 成绩
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '成绩',
                                  style: TextStyle(
                                    fontSize: 13.sp,  // 26rpx ÷ 2
                                    color: Color(0xFF787E8F),
                                  ),
                                ),
                                SizedBox(height: 12.h),  // 24rpx ÷ 2
                                Text(
                                  '${report['score']}分',
                                  style: TextStyle(
                                    fontSize: 14.sp,  // 28rpx ÷ 2
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF2E68FF),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 29.w),  // 58rpx ÷ 2
                            // 排名
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '排名',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Color(0xFF787E8F),
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  report['rank'] as String,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF2E68FF),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // 右侧:及格/不及格图标
                        Image.network(
                          report['isPass'] as bool
                              ? 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/16969942606636768169699426066363349_jige.png'
                              : 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/16969942734451def169699427344583935_bujige.png',
                          width: 75.w,  // 150rpx ÷ 2
                          height: 73.h,  // 146rpx ÷ 2
                          errorBuilder: (context, error, stack) {
                            return Container(
                              width: 75.w,
                              height: 73.h,
                              color: Colors.grey[200],
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
