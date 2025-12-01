import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../app/routes/app_routes.dart';
import '../providers/question_bank_provider.dart';
import '../models/question_bank_model.dart';
import '../../major/widgets/major_selector_dialog.dart';
import '../../auth/providers/auth_provider.dart';
import '../../goods/services/goods_service.dart' as goods_service;

/// 题库首页
/// 对应小程序: src/modules/jintiku/pages/index/index.vue
/// ✅ 使用 ConsumerStatefulWidget，支持页面初始化时加载数据
class QuestionBankPage extends ConsumerStatefulWidget {
  const QuestionBankPage({super.key});

  @override
  ConsumerState<QuestionBankPage> createState() => _QuestionBankPageState();
}

class _QuestionBankPageState extends ConsumerState<QuestionBankPage> {
  @override
  void initState() {
    super.initState();
    // 页面加载时自动加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(questionBankProvider.notifier).loadAllData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 通过 ref.watch 监听 ViewModel 状态
    final state = ref.watch(questionBankProvider);

    // ✅ 使用 ref.listen 处理副作用（Toast、导航等）
    ref.listen<QuestionBankState>(questionBankProvider, (previous, next) {
      // 打卡成功提示
      if (next.checkInSuccess && !(previous?.checkInSuccess ?? false)) {
        EasyLoading.showSuccess(next.successMessage ?? '打卡成功');
        ref.read(questionBankProvider.notifier).clearSuccessFlag();
      }

      // 错误提示
      if (next.error != null && next.error != previous?.error) {
        EasyLoading.showError(next.error!);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: RefreshIndicator(
        onRefresh: () async {
          // ✅ 通过 ViewModel 处理业务逻辑
          await ref.read(questionBankProvider.notifier).refresh();
        },
        child: Stack(
          children: [
            _buildGradientBackground(),
            _buildContent(context, ref, state),
          ],
        ),
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
            colors: [Color(0xFFB8E8FC), Color(0xFFE9F7FF)],
            stops: [0.0, 1.0],
          ),
        ),
      ),
    );
  }

  /// 主内容
  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    QuestionBankState state,
  ) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeader(context, ref)),
        SliverToBoxAdapter(child: _buildStudyCalendar(state, ref)),
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        SliverToBoxAdapter(child: _buildStudyCardGrid(context, ref)),
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        // 每日一测
        if (state.dailyPractice != null) ...[
          SliverToBoxAdapter(
            child: _buildDailyPractice(context, state.dailyPractice!),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        ],
        // 章节练习
        SliverToBoxAdapter(child: _buildChapterPractice(state)),
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        // 技能模拟
        if (state.skillMock != null) ...[
          SliverToBoxAdapter(
            child: _buildSkillMockSection(context, state.skillMock!),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        ],
        // 已购试题
        SliverToBoxAdapter(child: _buildPurchasedQuestions(state)),
        SliverToBoxAdapter(child: SizedBox(height: 60.h)),
      ],
    );
  }

  /// 顶部专业选择栏
  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    // ✅ 从 majorProvider 读取当前专业信息
    final majorInfo = ref.watch(currentMajorProvider);
    final majorName = majorInfo?.majorName ?? '选择专业';

    return GestureDetector(
      onTap: () {
        // ✅ 打开专业选择弹窗(与首页保持一致)
        showMajorSelector(
          context,
          onChanged: () {
            // 专业变更后刷新题库数据
            ref.read(questionBankProvider.notifier).loadAllData();
          },
        );
      },
      child: Container(
        padding: EdgeInsets.only(top: 60.h, left: 24.w, bottom: 24.h),
        child: Row(
          children: [
            Text(
              majorName,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.keyboard_arrow_down, size: 20.sp, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  /// 学习日历卡片
  Widget _buildStudyCalendar(QuestionBankState state, WidgetRef ref) {
    return _StudyCalendarCard(
      learningData: state.learningData,
      isLoadingLearningData: state.isLoadingLearning,
      onCheckIn: () => ref.read(questionBankProvider.notifier).checkIn(),
    );
  }

  /// 学习卡片网格(绝密押题、科目模考、模拟考试、学习报告)
  Widget _buildStudyCardGrid(BuildContext context, WidgetRef ref) {
    final cards = [
      {
        'title': '绝密押题',
        'subtitle': '名师密押 考后即焚',
        'imageUrl':
            'https://yakaixin.oss-cn-beijing.aliyuncs.com/public/predictIcon.png',
        'action': () => _handleCardClick(context, ref, 0),
      },
      {
        'title': '科目模考',
        'subtitle': '查漏补缺 直击重点',
        'imageUrl':
            'https://yakaixin.oss-cn-beijing.aliyuncs.com/public/test-icon.png',
        'action': () => _handleCardClick(context, ref, 1),
      },
      {
        'title': '模拟考试',
        'subtitle': '全真模拟 还原考场',
        'imageUrl':
            'https://yakaixin.oss-cn-beijing.aliyuncs.com/public/exam-icon.png',
        'action': () => _handleCardClick(context, ref, 2),
      },
      {
        'title': '学习报告',
        'subtitle': '实时学习情况',
        'imageUrl':
            'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/col-4.png',
        'action': () => _handleCardClick(context, ref, 3),
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
  Widget _buildDailyPractice(
    BuildContext context,
    DailyPracticeModel dailyPractice,
  ) {
    final totalQuestions = dailyPractice.totalQuestions;
    final doneQuestions = dailyPractice.doneQuestions;
    final name = dailyPractice.name;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('每日一测'),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () => _handleDailyPractice(context),
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
                          name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '已做 $doneQuestions/$totalQuestions 题',
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
  Widget _buildChapterPractice(QuestionBankState state) {
    if (state.isLoadingChapters) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('章节练习'),
            SizedBox(height: 12.h),
            Center(child: CircularProgressIndicator()),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('章节练习'),
          SizedBox(height: 12.h),
          // 显示前3个章节
          ...(state.chapters
              .take(3)
              .map(
                (chapter) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _buildChapterItem(
                    chapter.sectionName,
                    '${chapter.questionNumber}题',
                    '已做${chapter.doQuestionNum}题',
                    chapter.correctRate,
                    () {
                      // TODO: 跳转到章节详情
                      EasyLoading.showToast('点击了章节: ${chapter.sectionName}');
                    },
                  ),
                ),
              )),
          // 查看更多按钮
          if (state.chapters.length > 3)
            GestureDetector(
              onTap: () {
                // TODO: 跳转到章节列表页
                EasyLoading.showToast('查看全部 ${state.chapters.length} 个章节');
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFFE5E5E5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '查看全部 ${state.chapters.length} 个章节',
                      style: TextStyle(fontSize: 14.sp, color: Colors.blue),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12.sp,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
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
    VoidCallback onTap,
  ) {
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
                        style: TextStyle(fontSize: 12.sp, color: Colors.blue),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        '正确率 ${accuracy.toStringAsFixed(0)}%',
                        style: TextStyle(fontSize: 12.sp, color: Colors.green),
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

  /// 技能模拟区域
  Widget _buildSkillMockSection(
    BuildContext context,
    SkillMockModel skillMock,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('技能模拟'),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () {
              // TODO: 跳转到技能模拟页面
              EasyLoading.showToast('点击了技能模拟');
            },
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                gradient: LinearGradient(
                  colors: [Color(0xFFF5F7FF), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  // 图标
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.medical_services,
                      size: 30.w,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // 文字
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          skillMock.name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          skillMock.description,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF999999),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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

  /// 已购试题
  Widget _buildPurchasedQuestions(QuestionBankState state) {
    if (state.isLoadingPurchased) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('已购试题'),
            SizedBox(height: 12.h),
            Center(child: CircularProgressIndicator()),
          ],
        ),
      );
    }

    if (state.purchasedGoods.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('已购试题'),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(40.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 50.sp,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      '暂无已购试题',
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('已购试题'),
          SizedBox(height: 12.h),
          ...(state.purchasedGoods.map((goods) {
            final name = goods.name;
            final coverPath = goods.materialCoverPath;

            // ✅ 安全处理封面路径
            final imageUrl =
                coverPath.isNotEmpty && coverPath.startsWith('http')
                ? coverPath
                : coverPath.isNotEmpty
                ? 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/$coverPath'
                : '';

            // ✅ 使用 PurchasedGoodsModel 的 questionCount 字段
            final questionCount = '${goods.questionCount}题';

            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildPurchasedItem(name, questionCount, imageUrl),
            );
          })),
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

  /// 处理卡片点击
  void _handleCardClick(BuildContext context, WidgetRef ref, int type) {
    switch (type) {
      case 0:
        // 绝密押题 - 历年真题
        // ✅ 对照小程序：position_identify = "linianzhenti"
        _navigateToGoodsDetail(
          context,
          ref,
          'linianzhenti',
          AppRoutes.secretRealDetail,
        );
        break;
      case 1:
        // 科目模考
        // ✅ 对照小程序：position_identify = "kemumokao"
        _navigateToGoodsDetail(
          context,
          ref,
          'kemumokao',
          AppRoutes.subjectMockDetail,
        );
        break;
      case 2:
        // 模拟考试
        // ✅ 对照小程序：position_identify = "monikaoshi"
        _navigateToGoodsDetail(
          context,
          ref,
          'monikaoshi',
          AppRoutes.simulatedExamRoom,
        );
        break;
      case 3:
        // 学习报告 - 跳转到报告中心
        context.push(AppRoutes.reportCenter);
        break;
    }
  }

  /// 跳转到商品详情页
  Future<void> _navigateToGoodsDetail(
    BuildContext context,
    WidgetRef ref,
    String positionIdentify,
    String routePath,
  ) async {
    if (!mounted) return;

    try {
      EasyLoading.show(status: '加载中...');

      // 获取当前用户的专业ID
      final authState = ref.read(authProvider);
      final professionalId = authState.currentMajor?.majorId ?? '';

      // ✅ 通过API获取商品数据 (Mock拦截器会自动返回Mock数据)
      final goodsService = ref.read(goods_service.goodsServiceProvider);
      final response = await goodsService.getGoodsByPosition(
        positionIdentify: positionIdentify,
        professionalId: professionalId.isNotEmpty ? professionalId : null,
      );

      if (!mounted) return;
      EasyLoading.dismiss();

      if (response.list.isEmpty) {
        EasyLoading.showToast('暂无数据');
        return;
      }

      final firstGoods = response.list[0];

      // 跳转到对应的详情页
      if (!mounted) return;
      context.push(
        routePath,
        extra: {
          'product_id': firstGoods.goodsId?.toString() ?? '',
          'professional_id': professionalId,
        },
      );
    } catch (e) {
      if (!mounted) return;
      EasyLoading.dismiss();
      EasyLoading.showError('加载失败: ${e.toString()}');
    }
  }

  /// 处理每日一测点击
  void _handleDailyPractice(BuildContext context) {
    // TODO: 调用API获取每日30题数据，跳转到做题页面
    context.push(AppRoutes.makeQuestion);
  }
}

// ==================== 独立 Widget 组件 ====================

/// 学习日历卡片
class _StudyCalendarCard extends StatelessWidget {
  final LearningDataModel? learningData;
  final bool isLoadingLearningData;
  final VoidCallback onCheckIn;

  const _StudyCalendarCard({
    required this.learningData,
    required this.isLoadingLearningData,
    required this.onCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    final checkinNum = learningData?.checkinNum ?? 0;
    final totalNum = learningData?.totalNum ?? 0;
    final correctRate = learningData?.correctRate ?? '0';
    final isCheckin = (learningData?.isCheckin ?? 0) == 1;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
    return Container(width: 1, height: 40.h, color: const Color(0xFFE5E5E5));
  }

  Widget _buildCheckInButton(bool isCheckin, VoidCallback onCheckIn) {
    // ⚠️ 加载中时禁用按钮
    final isDisabled = isCheckin || isLoadingLearningData;

    return GestureDetector(
      onTap: isDisabled ? null : onCheckIn,
      child: Container(
        width: double.infinity,
        height: 44.h,
        decoration: BoxDecoration(
          color: isCheckin ? const Color(0xFFFFEEE7) : const Color(0xFFFF5500),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: isLoadingLearningData
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCheckin ? const Color(0xFFF44900) : Colors.white,
                    ),
                  ),
                )
              : Text(
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
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF999999)),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: const Color(0xFF666666)),
        ),
      ],
    );
  }
}
