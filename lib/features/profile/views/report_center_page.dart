import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/config/api_config.dart';
import '../../../core/utils/safe_type_converter.dart';
import '../models/learning_data_model.dart';
import '../providers/report_provider.dart';
import '../widgets/column_chart_widget.dart';

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
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        title: const Text('报告中心'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
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
  /// 对应小程序: .tabs
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      height: 40.h,
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
                        fontSize: isActive ? 16.sp : 14.sp,
                        fontWeight:
                            isActive ? FontWeight.w800 : FontWeight.normal,
                        color: isActive
                            ? const Color(0xFF2E68FF)
                            : const Color(0xFF787E8F),
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
                        fontSize: isActive ? 16.sp : 14.sp,
                        fontWeight:
                            isActive ? FontWeight.w800 : FontWeight.normal,
                        color: isActive
                            ? const Color(0xFF2E68FF)
                            : const Color(0xFF787E8F),
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

// ==================== 学习数据视图 ====================

/// 学习数据视图
/// 对应小程序: report.vue index==0 部分
class _StudyDataView extends ConsumerStatefulWidget {
  const _StudyDataView();

  @override
  ConsumerState<_StudyDataView> createState() => _StudyDataViewState();
}

class _StudyDataViewState extends ConsumerState<_StudyDataView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(learningDataProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(learningDataProvider);

    if (state.isLoading && state.data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.data == null) {
      return Center(
        child: Text(
          '加载失败: ${state.error}',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
        ),
      );
    }

    final data = state.data;
    if (data == null) {
      return Center(
        child: Text(
          '暂无数据',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(10.w),
      child: Column(
        children: [
          _buildTopStatCard(data),
          SizedBox(height: 10.h),
          _buildQuestionCard(data, state),
          SizedBox(height: 10.h),
          _buildStudyTimeCard(data, state),
          SizedBox(height: 10.h),
          _buildErrorKnowledgeCard(data),
        ],
      ),
    );
  }

  /// 顶部统计卡片
  Widget _buildTopStatCard(LearningDataModel data) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  SafeTypeConverter.toSafeString(data.totalNum, defaultValue: '0'),
                  '道',
                  '刷题量',
                ),
              ),
              Container(width: 1.w, height: 40.h, color: const Color(0xFFD7E5FE)),
              Expanded(
                child: _buildStatItem(
                  SafeTypeConverter.toSafeString(data.todayLearnTime, defaultValue: '0'),
                  '天',
                  '坚持天数',
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSmallCard('正确率', '${data.correctRate ?? '0'}%'),
              _buildSmallCard('学习累计时长', '${data.learnTime ?? '0'}h'),
              _buildSmallCard(
                '学习知识点',
                '${SafeTypeConverter.toSafeString(data.knowledgeNum, defaultValue: '0')}个',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String unit, String label) {
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
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF2E68FF),
              ),
            ),
            SizedBox(width: 7.w),
            Text(
              unit,
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF787E8F)),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: const Color(0xFF787E8F)),
        ),
      ],
    );
  }

  Widget _buildSmallCard(String title, String value) {
    return Container(
      width: 100.w,
      height: 60.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8FF),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 13.sp, color: const Color(0xFF787E8F)),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF161F30),
            ),
          ),
        ],
      ),
    );
  }

  /// 刷题量卡片
  Widget _buildQuestionCard(LearningDataModel data, LearningDataState state) {
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
            '刷题量',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF161F30),
            ),
          ),
          SizedBox(height: 20.h),
          _buildChartTab(
            state.questionNumType,
            (type) => ref.read(learningDataProvider.notifier).setQuestionNumType(type),
          ),
          SizedBox(height: 10.h),
          _buildChartData(
            ref.read(learningDataProvider.notifier).getQuestionData(),
          ),
          SizedBox(height: 22.h),
          _buildCurrentStat(
            '今日刷题',
            '${SafeTypeConverter.toSafeString(data.todayTotalNum, defaultValue: '0')}道',
          ),
        ],
      ),
    );
  }

  /// 学习时长卡片
  Widget _buildStudyTimeCard(LearningDataModel data, LearningDataState state) {
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
            '学习时长（h）',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF161F30),
            ),
          ),
          SizedBox(height: 20.h),
          _buildChartTab(
            state.questionHourType,
            (type) => ref.read(learningDataProvider.notifier).setQuestionHourType(type),
          ),
          SizedBox(height: 10.h),
          _buildLearnTimeData(
            ref.read(learningDataProvider.notifier).getLearnTimeData(),
          ),
          SizedBox(height: 22.h),
          _buildCurrentStat(
            '今日学习',
            '${data.todayLearnTime ?? '0'}h',
          ),
        ],
      ),
    );
  }

  /// 图表Tab切换
  Widget _buildChartTab(int currentType, Function(int) onTap) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onTap(1),
            child: Center(
              child: Text(
                '最近一周',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: currentType == 1 ? FontWeight.w800 : FontWeight.normal,
                  color: currentType == 1
                      ? const Color(0xFF161F30)
                      : const Color(0xFF787E8F),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onTap(2),
            child: Center(
              child: Text(
                '按月查看',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: currentType == 2 ? FontWeight.w800 : FontWeight.normal,
                  color: currentType == 2
                      ? const Color(0xFF161F30)
                      : const Color(0xFF787E8F),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 刷题量数据展示（使用fl_chart）
  Widget _buildChartData(List<DailyQuestionModel> dataList) {
    final chartData = dataList
        .map((item) => ChartData(
              label: item.date ?? '',
              value: SafeTypeConverter.toDouble(item.num),
            ))
        .toList();

    return ColumnChartWidget(
      data: chartData,
      barColor: const Color(0xFF2E68FF),
    );
  }

  /// 学习时长数据展示（使用fl_chart）
  Widget _buildLearnTimeData(List<DailyLearnTimeModel> dataList) {
    final chartData = dataList
        .map((item) => ChartData(
              label: item.date ?? '',
              value: SafeTypeConverter.toDouble(item.learnTime),
            ))
        .toList();

    return ColumnChartWidget(
      data: chartData,
      barColor: const Color(0xFF2E68FF),
    );
  }

  Widget _buildCurrentStat(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13.sp, color: const Color(0xFF787E8F)),
        ),
        SizedBox(width: 12.w),
        Text(
          value,
          style: TextStyle(fontSize: 13.sp, color: const Color(0xFF161F30)),
        ),
      ],
    );
  }

  /// 易错知识点卡片
  Widget _buildErrorKnowledgeCard(LearningDataModel data) {
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
              color: const Color(0xFF161F30),
            ),
          ),
          SizedBox(height: 10.h),
          if (data.knowledgeErrList.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Text(
                  '暂无数据',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
              ),
            )
          else
            ...data.knowledgeErrList.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Container(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              item.knowledgeIdName ?? '',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${SafeTypeConverter.toSafeString(item.faultSum, defaultValue: '0')}次',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF787E8F),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}

// ==================== 成绩报告视图 ====================

/// 成绩报告视图
/// 对应小程序: report.vue index==1 部分
class _ScoreReportView extends ConsumerStatefulWidget {
  const _ScoreReportView();

  @override
  ConsumerState<_ScoreReportView> createState() => _ScoreReportViewState();
}

class _ScoreReportViewState extends ConsumerState<_ScoreReportView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(scoreReportNotifierProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scoreReportNotifierProvider);

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(10.w),
          child: _buildSearchBar(state),
        ),
        Expanded(
          child: _buildReportList(state),
        ),
      ],
    );
  }

  /// 搜索栏
  Widget _buildSearchBar(ScoreReportState state) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 34.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F7F8),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: '输入考试名称',
                border: InputBorder.none,
                isDense: true,
              ),
              style: TextStyle(fontSize: 12.sp),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: () {
            ref
                .read(scoreReportNotifierProvider.notifier)
                .search(_searchController.text);
          },
          child: Container(
            width: 66.w,
            height: 34.h,
            decoration: BoxDecoration(
              color: const Color(0xFF2E68FF),
              borderRadius: BorderRadius.circular(16.r),
            ),
            alignment: Alignment.center,
            child: Text(
              '搜索',
              style: TextStyle(fontSize: 12.sp, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  /// 报告列表
  Widget _buildReportList(ScoreReportState state) {
    if (state.isLoading && state.reports.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.reports.isEmpty) {
      return Center(
        child: Text(
          '加载失败: ${state.error}',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
        ),
      );
    }

    if (state.reports.isEmpty) {
      return Center(
        child: Text(
          '暂无任何数据！',
          style: TextStyle(fontSize: 12.sp, color: const Color(0xFFCCCCCC)),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(15.w),
      itemCount: state.reports.length,
      itemBuilder: (context, index) {
        final report = state.reports[index];
        return Container(
          margin: EdgeInsets.only(bottom: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                report.handPaperTime ?? '',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF161F30),
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.examinationName ?? '',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _buildScoreItem(
                              '成绩',
                              '${SafeTypeConverter.toSafeString(report.score, defaultValue: '0')}分',
                            ),
                            SizedBox(width: 29.w),
                            _buildScoreItem(
                              '排名',
                              SafeTypeConverter.toSafeString(report.rank, defaultValue: '-'),
                            ),
                          ],
                        ),
                        // 及格/不及格图标
                        _buildPassIcon(report.isPass),
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

  Widget _buildScoreItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13.sp, color: const Color(0xFF787E8F)),
        ),
        SizedBox(height: 12.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF2E68FF),
          ),
        ),
      ],
    );
  }

  /// 及格/不及格图标
  Widget _buildPassIcon(String? isPass) {
    final isPassBool = isPass == '1';
    
    return Container(
      width: 75.w,
      height: 73.h,
      decoration: BoxDecoration(
        color: isPassBool 
            ? const Color(0xFFE8F5E9) 
            : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(8.r),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isPassBool ? Icons.check_circle : Icons.cancel,
            color: isPassBool 
                ? const Color(0xFF4CAF50) 
                : const Color(0xFFF44336),
            size: 32.sp,
          ),
          SizedBox(height: 4.h),
          Text(
            isPassBool ? '及格' : '不及格',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isPassBool 
                  ? const Color(0xFF4CAF50) 
                  : const Color(0xFFF44336),
            ),
          ),
        ],
      ),
    );
  }
}
