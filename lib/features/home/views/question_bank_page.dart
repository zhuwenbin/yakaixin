import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/mock/data/question_bank_mock_data.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/home_provider.dart';

/// 题库首页
/// 对应小程序: src/modules/jintiku/pages/index/index.vue
class QuestionBankPage extends ConsumerStatefulWidget {
  const QuestionBankPage({super.key});

  @override
  ConsumerState<QuestionBankPage> createState() => _QuestionBankPageState();
}

class _QuestionBankPageState extends ConsumerState<QuestionBankPage> {
  // ✅ 遵守Mock规则: 通过API获取学习数据
  Map<String, dynamic> _learningData = {};
  bool _isLoadingLearningData = true;
  
  String _majorName = '口腔执业医师';
  bool _showMajorSelector = false;

  @override
  void initState() {
    super.initState();
    _loadLearningData();
  }

  /// 加载学习数据
  /// 对应小程序: examLearningData API
  Future<void> _loadLearningData() async {
    try {
      // TODO: 实现API调用获取学习数据
      // final response = await examLearningDataApi();
      // setState(() {
      //   _learningData = response.data;
      //   _isLoadingLearningData = false;
      // });
      
      // 临时使用Mock数据（通过拦截器会自动返回）
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _learningData = QuestionBankMockData.learningData['data'] as Map<String, dynamic>;
        _isLoadingLearningData = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingLearningData = false;
      });
      print('❌ 加载学习数据失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // 渐变背景
          _buildGradientBackground(),
          // 主内容
          _buildContent(),
        ],
      ),
    );
  }

  /// 渐变背景
  Widget _buildGradientBackground() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 250.h,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB8E8FC),
              Color(0xFFE9F7FF),
            ],
            stops: [0.0, 1.0],
          ),
        ),
      ),
    );
  }

  /// 主内容
  Widget _buildContent() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeader()),
        SliverToBoxAdapter(child: _buildStudyCalendar()),
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        SliverToBoxAdapter(child: _buildStudyCardGrid()),
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        SliverToBoxAdapter(child: _buildDailyPractice()),
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        SliverToBoxAdapter(child: _buildChapterPractice()),
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        SliverToBoxAdapter(child: _buildPurchasedQuestions()),
        SliverToBoxAdapter(child: SizedBox(height: 60.h)),
      ],
    );
  }

  /// 顶部专业选择栏
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(top: 60.h, left: 24.w, bottom: 24.h),
      child: Row(
        children: [
          Text(
            _majorName,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 8.w),
          Icon(
            Icons.keyboard_arrow_down,
            size: 20.sp,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }

  /// 学习日历卡片
  Widget _buildStudyCalendar() {
    return _StudyCalendarCard(
      learningData: _learningData,
      onCheckIn: _handleCheckIn,
    );
  }

  /// 学习卡片网格(绝密押题、科目模考、模拟考试、学习报告)
  Widget _buildStudyCardGrid() {
    final cards = [
      {
        'title': '绝密押题',
        'subtitle': '名师密押 考后即焚',
        'imageUrl': 'https://yakaixin.oss-cn-beijing.aliyuncs.com/public/predictIcon.png',
        'action': () => _handleCardClick(0),
      },
      {
        'title': '科目模考',
        'subtitle': '查漏补缺 直击重点',
        'imageUrl': 'https://yakaixin.oss-cn-beijing.aliyuncs.com/public/test-icon.png',
        'action': () => _handleCardClick(1),
      },
      {
        'title': '模拟考试',
        'subtitle': '全真模拟 还原考场',
        'imageUrl': 'https://yakaixin.oss-cn-beijing.aliyuncs.com/public/exam-icon.png',
        'action': () => _handleCardClick(2),
      },
      {
        'title': '学习报告',
        'subtitle': '实时学习情况',
        'imageUrl': 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/col-4.png',
        'action': () => _handleCardClick(3),
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
        ),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return _buildStudyCard(
            title: card['title'] as String,
            subtitle: card['subtitle'] as String,
            imageUrl: card['imageUrl'] as String,
            onTap: card['action'] as VoidCallback,
          );
        },
      ),
    );
  }

  /// 学习卡片单项
  Widget _buildStudyCard({
    required String title,
    required String subtitle,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            // 图标
            Image.network(
              imageUrl,
              width: 30.w,
              height: 30.w,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image,
                  size: 30.w,
                  color: const Color(0xFFCCCCCC),
                );
              },
            ),
            SizedBox(width: 12.w),
            // 文字
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF999999),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 每日一测
  Widget _buildDailyPractice() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('每日一测'),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: _handleDailyPractice,
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.today, size: 40.w, color: Colors.orange),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '每日30题',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '已做 12/30 题',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 24.w, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 章节练习
  Widget _buildChapterPractice() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('章节练习'),
          SizedBox(height: 12.h),
          _buildChapterItem(
            '第一章 口腔解剖生理学',
            '500题',
            '已做120题',
            80.0,
          ),
          SizedBox(height: 12.h),
          _buildChapterItem(
            '第二章 口腔组织病理学',
            '450题',
            '已做80题',
            75.0,
          ),
        ],
      ),
    );
  }

  /// 章节练习单项
  Widget _buildChapterItem(
    String title,
    String totalQuestions,
    String doneQuestions,
    double accuracy,
  ) {
    return GestureDetector(
      onTap: () {
        // TODO: 跳转到章节练习详情
        print('点击章节: $title');
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(
                        totalQuestions,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF999999),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        doneQuestions,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        '正确率 ${accuracy.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 24.w, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  /// 已购试题
  Widget _buildPurchasedQuestions() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('已购试题'),
          SizedBox(height: 12.h),
          _buildPurchasedItem(
            '2026口腔执业医师历年真题精选',
            '3580题',
            'https://picsum.photos/200/120?random=1',
          ),
        ],
      ),
    );
  }

  /// 已购试题单项
  Widget _buildPurchasedItem(
    String title,
    String questionCount,
    String imageUrl,
  ) {
    return GestureDetector(
      onTap: () {
        // TODO: 跳转到试题详情
        print('点击已购试题: $title');
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                imageUrl,
                width: 80.w,
                height: 60.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80.w,
                    height: 60.h,
                    color: const Color(0xFFF5F5F5),
                    child: Icon(Icons.image, color: Colors.grey),
                  );
                },
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    questionCount,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 24.w, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  /// 分段标题
  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Image.network(
          'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/title-icon.png',
          width: 15.w,
          height: 15.w,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.star, size: 15.w, color: Colors.blue);
          },
        ),
        SizedBox(width: 5.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  // ==================== 事件处理 ====================

  /// 处理打卡
  /// ✅ 遵守Mock规则: 通过API调用打卡接口
  Future<void> _handleCheckIn() async {
    try {
      EasyLoading.show(status: '打卡中...');
      
      // TODO: 调用真实API打卡
      // await examCheckinApi();
      
      // 临时模拟打卡
      await Future.delayed(const Duration(milliseconds: 500));
      
      EasyLoading.dismiss();
      EasyLoading.showSuccess('打卡成功');
      
      // 重新加载学习数据
      _loadLearningData();
      
      print('✅ 打卡成功');
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('打卡失败');
      print('❌ 打卡失败: $e');
    }
  }

  /// 处理卡片点击
  void _handleCardClick(int type) {
    switch (type) {
      case 0:
        // 绝密押题 - 跳转到历年真题详情页
        _navigateToGoodsDetail('linianzhenti', AppRoutes.secretRealDetail);
        break;
      case 1:
        // 科目模考 - 跳转到科目模考详情页
        _navigateToGoodsDetail('kemumokao', AppRoutes.subjectMockDetail);
        break;
      case 2:
        // 模拟考试 - 跳转到模拟考场页
        _navigateToGoodsDetail('monikaoshi', AppRoutes.simulatedExamRoom);
        break;
      case 3:
        // 学习报告 - 跳转到报告中心
        context.push(AppRoutes.reportCenter);
        break;
    }
  }

  /// 跳转到商品详情页
  /// ✅ 遵守Mock规则: 通过API调用,由Mock拦截器返回Mock数据
  Future<void> _navigateToGoodsDetail(String positionIdentify, String routePath) async {
    try {
      EasyLoading.show(status: '加载中...');
      
      // 获取当前用户的专业ID
      final authState = ref.read(authProvider);
      final professionalId = authState.currentMajor?.majorId ?? '';
      
      // ✅ 通过API获取商品数据 (Mock拦截器会自动返回Mock数据)
      final goodsService = ref.read(goodsServiceProvider);
      final response = await goodsService.getGoodsByPosition(
        positionIdentify: positionIdentify,
        professionalId: professionalId.isNotEmpty ? professionalId : null,
      );
      
      EasyLoading.dismiss();
      
      if (response.list.isEmpty) {
        EasyLoading.showToast('暂无数据');
        return;
      }
      
      final firstGoods = response.list[0];
      
      // 跳转到对应的详情页
      context.push(
        routePath,
        extra: {
          'product_id': firstGoods.goodsId?.toString() ?? '',
          'professional_id': professionalId,
        },
      );
      
      print('📦 跳转到: $routePath, productId: ${firstGoods.goodsId}');
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('加载失败: ${e.toString()}');
      print('❌ 获取商品数据失败: $e');
    }
  }

  /// 处理每日一测点击
  void _handleDailyPractice() {
    // TODO: 调用API获取每日30题数据，跳转到做题页面
    context.push(AppRoutes.makeQuestion);
    print('点击了每日一测');
  }
}

// ==================== 独立 Widget 组件 ====================

/// 学习日历卡片
class _StudyCalendarCard extends StatelessWidget {
  final Map<String, dynamic> learningData;
  final VoidCallback onCheckIn;

  const _StudyCalendarCard({
    required this.learningData,
    required this.onCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    final checkinNum = learningData['checkin_num'] ?? 0;
    final totalNum = learningData['total_num'] ?? 0;
    final correctRate = learningData['correct_rate'] ?? '0';
    final isCheckin = learningData['is_checkin'] == 1;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                SizedBox(height: 20.h),
                _buildStatsRow(checkinNum, totalNum, correctRate),
                SizedBox(height: 20.h),
                _buildCheckInButton(isCheckin, onCheckIn),
              ],
            ),
          ),
          _buildDecoration(),
          _buildCheckInStatus(isCheckin),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      '学习日历',
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF333333),
      ),
    );
  }

  Widget _buildStatsRow(int checkinNum, int totalNum, String correctRate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _StatItem(label: '坚持打卡', value: '$checkinNum', unit: '天'),
        _buildDivider(),
        _StatItem(label: '做题总数', value: '$totalNum', unit: '题'),
        _buildDivider(),
        _StatItem(label: '正确率', value: correctRate, unit: '%'),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40.h,
      color: const Color(0xFFE5E5E5),
    );
  }

  Widget _buildCheckInButton(bool isCheckin, VoidCallback onCheckIn) {
    return GestureDetector(
      onTap: isCheckin ? null : onCheckIn,
      child: Container(
        width: double.infinity,
        height: 44.h,
        decoration: BoxDecoration(
          color: isCheckin ? const Color(0xFFFFEEE7) : const Color(0xFFFF5500),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            isCheckin ? '已打卡' : '打卡',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isCheckin ? const Color(0xFFF44900) : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDecoration() {
    return Positioned(
      top: 0,
      right: 0,
      child: Image.network(
        'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/study-card-color.png',
        width: 130.w,
        height: 32.h,
        opacity: const AlwaysStoppedAnimation(0.8),
        errorBuilder: (context, error, stackTrace) {
          return SizedBox(width: 130.w, height: 32.h);
        },
      ),
    );
  }

  Widget _buildCheckInStatus(bool isCheckin) {
    return Positioned(
      top: 0,
      right: 0,
      width: 130.w,
      height: 32.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/study-card-zan.png',
            width: 16.w,
            height: 16.w,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                isCheckin ? Icons.check_circle : Icons.circle_outlined,
                size: 16.w,
                color: const Color(0xFF666666),
              );
            },
          ),
          SizedBox(width: 4.w),
          Text(
            isCheckin ? '今日已打卡' : '今日未打卡',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}

/// 统计项组件
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _StatItem({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFF5500),
              ),
            ),
            SizedBox(width: 2.w),
            Text(
              unit,
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF999999),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF666666),
          ),
        ),
      ],
    );
  }
}
