import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../providers/question_bank_provider.dart';
import '../models/question_bank_model.dart';
import '../models/goods_model.dart';
import '../../major/widgets/major_selector_dialog.dart';
import '../../auth/providers/auth_provider.dart';
import '../../goods/services/goods_service.dart' as goods_service;
import '../widgets/study_calendar_card.dart';
import '../widgets/study_card_grid.dart';
import '../widgets/daily_practice_card.dart';
import '../widgets/chapter_practice_section.dart';
import '../widgets/skill_mock_section.dart';
import '../widgets/purchased_questions_section.dart';
import '../../../../app/config/api_config.dart';

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
    final statusBarHeight = MediaQuery.of(context).padding.top;

    // ✅ 监听登录状态变化，登录成功后刷新题库数据
    // ✅ 仅「已登录→未登录」时在此刷新；「未登录→已登录」由 Auth 的 _refreshAllPagesAfterLogin 用正确专业 ID 刷新，避免竞态导致错误数据覆盖
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (previous?.isLoggedIn == true && !next.isLoggedIn) {
        print('🔄 [题库页] 检测到登录状态变化（已登录 → 未登录），刷新题库数据');
        ref.read(questionBankProvider.notifier).loadAllData();
      }
    });

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
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _buildGradientBackground(),
          _buildMainContent(context, ref, state, statusBarHeight),
        ],
      ),
    );
  }

  /// 主内容区域
  /// ✅ 修复：Header不再固定定位，而是作为ScrollView的第一个元素，跟随滚动
  Widget _buildMainContent(
    BuildContext context,
    WidgetRef ref,
    QuestionBankState state,
    double statusBarHeight,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        // ✅ 通过 ViewModel 处理业务逻辑
        await ref.read(questionBankProvider.notifier).refresh();
      },
      child: CustomScrollView(
        slivers: [
          // ✅ 顶部状态栏占位
          SliverToBoxAdapter(child: SizedBox(height: statusBarHeight)),
          // ✅ 专业选择栏（作为ScrollView的一部分，会跟随滚动）
          SliverToBoxAdapter(child: _buildScrollableHeader(context, ref)),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
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
      ),
    );
  }

  /// 渐变背景（绝对定位，不滚动）
  /// 对应小程序: .backgroud-color-blue
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

  /// 可滚动的专业选择栏（跟随ScrollView滚动）
  /// ✅ 修复：不再使用Positioned固定定位，改为普通Widget
  /// 对应小程序: .header-box .header
  Widget _buildScrollableHeader(BuildContext context, WidgetRef ref) {
    final majorInfo = ref.watch(currentMajorProvider);
    final majorName = majorInfo?.majorName ?? '选择专业';

    return Container(
      height: 48.h,
      color: Colors.transparent, // ✅ 透明背景，让渐变背景显示
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          showMajorSelector(
            context,
            onChanged: () {
              // 专业变更后刷新题库数据
              ref.read(questionBankProvider.notifier).loadAllData();
            },
          );
        },
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              majorName,
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20.sp,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  /// 学习日历卡片
  Widget _buildStudyCalendar(QuestionBankState state, WidgetRef ref) {
    return StudyCalendarCard(
      learningData: state.learningData,
      isLoadingLearningData: state.isLoadingLearning,
      onCheckIn: () => _handleCheckIn(context, ref),
    );
  }

  /// 处理打卡点击
  /// 对应小程序: index.vue Line 216-219 handleCheckIn()
  void _handleCheckIn(BuildContext context, WidgetRef ref) {
    // ✅ 检查登录状态（根据 Guideline 5.1.1，打卡需要登录）
    if (!ref.read(authProvider).isLoggedIn) {
      _showLoginDialog(context);
      return;
    }

    // 已登录，执行打卡
    ref.read(questionBankProvider.notifier).checkIn();
  }

  /// 学习卡片网格(绝密押题、科目模考、模拟考试、学习报告)
  Widget _buildStudyCardGrid(BuildContext context, WidgetRef ref) {
    final cards = [
      StudyCardData(
        title: '绝密押题',
        subtitle: '名师密押 考后即焚',
        imageUrl:
            'https://yakaixin.oss-cn-beijing.aliyuncs.com/public/predictIcon.png',
        onTap: () => _handleCardClick(context, ref, 0),
      ),
      StudyCardData(
        title: '科目模考',
        subtitle: '查漏补缺 直击重点',
        imageUrl:
            'https://yakaixin.oss-cn-beijing.aliyuncs.com/public/test-icon.png',
        onTap: () => _handleCardClick(context, ref, 1),
      ),
      StudyCardData(
        title: '模拟考试',
        subtitle: '全真模拟 还原考场',
        imageUrl:
            'https://yakaixin.oss-cn-beijing.aliyuncs.com/public/exam-icon.png',
        onTap: () => _handleCardClick(context, ref, 2),
      ),
      StudyCardData(
        title: '学习报告',
        subtitle: '实时学习情况',
        imageUrl: ApiConfig.completeImageUrl('col-4.png'),
        onTap: () => _handleCardClick(context, ref, 3),
      ),
    ];

    return StudyCardGrid(cards: cards);
  }

  /// 每日一测
  Widget _buildDailyPractice(
    BuildContext context,
    DailyPracticeModel dailyPractice,
  ) {
    return DailyPracticeCard(
      dailyPractice: dailyPractice,
      onTap: () => _handleDailyPractice(context),
    );
  }

  /// 章节练习
  /// 对应小程序: src/modules/jintiku/components/commen/index-nav.vue
  Widget _buildChapterPractice(QuestionBankState state) {
    return ChapterPracticeSection(
      chapterExercise: state.chapterExercise,
      isLoading: state.isLoadingChapters,
      onTap: () => _handleChapterPractice(context),
    );
  }

  /// 技能模拟区域
  Widget _buildSkillMockSection(
    BuildContext context,
    SkillMockModel skillMock,
  ) {
    return SkillMockSection(
      skillMock: skillMock,
      onTap: () {
        EasyLoading.showToast('点击了技能模拟');
      },
    );
  }

  /// 已购试题
  Widget _buildPurchasedQuestions(QuestionBankState state) {
    return PurchasedQuestionsSection(
      goods: state.purchasedGoods,
      isLoading: state.isLoadingPurchased,
      onItemTap: (goods) {
        _handlePurchasedItemTap(context, goods);
      },
    );
  }

  // ==================== 事件处理 ====================

  /// 处理卡片点击
  /// 对应小程序: src/modules/jintiku/components/commen/study-card-grid.vue
  Future<void> _handleCardClick(
    BuildContext context,
    WidgetRef ref,
    int type,
  ) async {
    String positionIdentify;
    switch (type) {
      case 0:
        // 绝密押题 - 历年真题
        positionIdentify = 'linianzhenti';
        break;
      case 1:
        // 科目模考
        positionIdentify = 'kemumokao';
        break;
      case 2:
        // 模拟考试
        positionIdentify = 'monikaoshi';
        break;
      case 3:
        // 学习报告 - 跳转到报告中心
        context.push(AppRoutes.reportCenter);
        return;
      default:
        return;
    }

    if (!mounted) return;

    try {
      EasyLoading.show(status: '加载中...');

      // 获取当前用户的专业ID
      final authState = ref.read(authProvider);
      final professionalId = authState.currentMajor?.majorId ?? '';

      // 通过API获取商品数据（与小程序 study-card-grid.vue 一致：/c/goods/v2 + shelf_platform_id + professional_id + position_identify）
      final goodsService = ref.read(goods_service.goodsServiceProvider);
      final response = await goodsService.getGoodsByPosition(
        positionIdentify: positionIdentify,
        professionalId: professionalId.isNotEmpty ? professionalId : null,
        shelfPlatformId: ApiConfig.shelfPlatformId,
      );

      if (!mounted) return;
      EasyLoading.dismiss();

      if (response.list.isEmpty) {
        EasyLoading.showToast('暂无数据');
        return;
      }

      final firstGoods = response.list[0];
      _goDetailPage(
        context,
        firstGoods,
        professionalId,
        positionIdentify: positionIdentify, // ✅ 传递 position_identify
      );
    } catch (e) {
      if (!mounted) return;
      EasyLoading.dismiss();
      EasyLoading.showError('加载失败: ${e.toString()}');
    }
  }

  /// 跳转到详情页
  /// 对应小程序: src/modules/jintiku/components/commen/study-card-grid.vue goDetailPage方法
  void _goDetailPage(
    BuildContext context,
    GoodsModel item,
    String professionalId, {
    String? positionIdentify, // ✅ 新增：用于判断是否是绝密押题
  }) {
    if (!mounted) return;

    // 使用 SafeTypeConverter 安全转换类型
    final permissionStatus = item.permissionStatus ?? '2';
    final dataType = item.dataType;
    final detailsType = item.detailsType;
    final goodsType = item.type; // 商品类型: 18=章节练习, 8=试卷, 10=模考
    final productId = item.goodsId?.toString() ?? '';
    final recitationQuestionModel =
        item.recitationQuestionModel?.toString() ?? '';

    // ✅ 调试日志：打印商品数据信息
    print(
      '🔍 绝密押题跳转 - permissionStatus: $permissionStatus, '
      'dataType: $dataType, detailsType: $detailsType, '
      'goodsType: $goodsType, productId: $productId, name: ${item.name}',
    );

    // 未购买 (permission_status == '2' 或 '0')
    if (permissionStatus == '2' || permissionStatus == '0') {
      // 模考类型 (data_type == 2)
      if (dataType == 2 || dataType == '2') {
        if (detailsType == 1 || detailsType == '1') {
          // 模考+经典版+没有购买 -> 跳转到经典商品详情页
          context.push(
            AppRoutes.goodsDetail,
            extra: {'product_id': productId, 'professional_id': professionalId},
          );
          return;
        } else if (detailsType == 4 || detailsType == '4') {
          // 模考+模考版+没有购买 -> 跳转到模拟考试商品详情页
          context.push(
            AppRoutes.simulatedExamRoom,
            extra: {'product_id': productId, 'professional_id': professionalId},
          );
          return;
        }
      }

      // 根据 details_type 跳转
      if (detailsType == 1 || detailsType == '1') {
        // 经典商品详情
        context.push(
          AppRoutes.goodsDetail,
          extra: {'product_id': productId, 'professional_id': professionalId},
        );
      } else if (detailsType == 2 || detailsType == '2') {
        // 真题商品详情
        context.push(
          AppRoutes.secretRealDetail,
          extra: {'product_id': productId, 'professional_id': professionalId},
        );
      } else if (detailsType == 3 || detailsType == '3') {
        // 科目商品详情
        context.push(
          AppRoutes.subjectMockDetail,
          extra: {'product_id': productId, 'professional_id': professionalId},
        );
      } else if (detailsType == 4 || detailsType == '4') {
        // 模拟商品详情
        context.push(
          AppRoutes.simulatedExamRoom,
          extra: {'product_id': productId, 'professional_id': professionalId},
        );
      }
      return;
    }

    // 已购买 (permission_status == '1')
    // 对应小程序: study-card-grid.vue Line 259-313
    if (permissionStatus == '1') {
      // 模考类型 (data_type == 2)
      if (dataType == 2 || dataType == '2') {
        if (detailsType == 1 || detailsType == '1') {
          // 模考+经典版+购买 -> 跳转到模考详情页
          context.push(
            AppRoutes.examInfo,
            extra: {
              'product_id': productId,
              'title': item.name ?? '',
              'page': 'home',
            },
          );
          return;
        } else if (detailsType == 4 || detailsType == '4') {
          // 模考+模考版+购买 -> 跳转到模拟考试详情页
          context.push(
            AppRoutes.simulatedExamRoom,
            extra: {'product_id': productId, 'professional_id': professionalId},
          );
          return;
        }
      }

      // 根据 details_type 跳转
      if (detailsType == 1 || detailsType == '1') {
        // 购买后，经典详情 -> 跳转到试卷详情页
        // 对应小程序 Line 287-290
        // ✅ 无论是绝密押题还是其他，已购买都跳转到试卷详情页（exam）
        // 试卷详情页会显示试卷列表，根据 paper_exercise_id 判断是否已完成
        print('✅ 已购买 detailsType=1 -> 跳转到试卷详情页 (TestExam)');
        context.push(
          AppRoutes.testExam,
          extra: {
            'id': productId,
            'professional_id': professionalId,
            'recitation_question_model': recitationQuestionModel,
          },
        );
      } else if (detailsType == 2 || detailsType == '2') {
        // 购买后，真题详情 -> 跳转到真题详情页
        // 对应小程序 Line 291-297
        print('✅ 已购买 detailsType=2 -> 跳转到真题详情页 (SecretRealDetail)');
        context.push(
          AppRoutes.secretRealDetail,
          extra: {'product_id': productId, 'professional_id': professionalId},
        );
      } else if (detailsType == 3 || detailsType == '3') {
        // 购买后，科目详情 -> 跳转到试卷详情页
        // 对应小程序 Line 298-301
        print('✅ 已购买 detailsType=3 -> 跳转到试卷详情页 (TestExam)');
        context.push(
          AppRoutes.testExam,
          extra: {
            'id': productId,
            'professional_id': professionalId,
            'recitation_question_model': recitationQuestionModel,
          },
        );
      } else if (detailsType == 4 || detailsType == '4') {
        // 购买后，模拟详情 -> 跳转到模拟考试详情页
        // 对应小程序 Line 302-311
        print('✅ 已购买 detailsType=4 -> 跳转到模拟考试详情页 (SimulatedExamRoom)');
        context.push(
          AppRoutes.simulatedExamRoom,
          extra: {
            'product_id': productId,
            'professional_id': professionalId,
            'title': item.name ?? '',
            'page': 'home',
            'recitation_question_model': recitationQuestionModel,
          },
        );
      }
    }
  }

  /// 处理已购试题点击
  /// 对应小程序: index-nav-item.vue Line 91-222
  void _handlePurchasedItemTap(
    BuildContext context,
    PurchasedGoodsModel goods,
  ) {
    // ✅ 使用 SafeTypeConverter 安全转换类型
    final type = goods.type;
    final dataType = goods.dataType;
    final detailsType = goods.detailsType;
    final permissionStatus = goods.permissionStatus;
    final productId = goods.id;
    final professionalId = goods.professionalId;
    final recitationQuestionModel = goods.recitationQuestionModel;

    print('🔍 点击已购试题:');
    print('  → 类型: $type');
    print('  → 数据类型: $dataType');
    print('  → 购买状态: $permissionStatus');
    print('  → 详情页类型: $detailsType');

    // ✅ 对应小程序 Line 103-161: 未购买场景 (permission_status == '2')
    if (permissionStatus == '2') {
      // 模考 (data_type == 2)
      if (dataType == '2') {
        if (detailsType == '1') {
          // 模考+经典版+没有购买 → 跳转商品详情
          print('🎯 模考+经典版+未购买 → 跳转 goodsDetail');
          context.push(
            AppRoutes.goodsDetail,
            extra: {'product_id': productId, 'professional_id': professionalId},
          );
          return;
        } else if (detailsType == '4') {
          // 模考+模考版+没有购买 → 跳转模拟考试
          print('🎯 模考+模考版+未购买 → 跳转 simulatedExamRoom');
          context.push(
            AppRoutes.simulatedExamRoom,
            extra: {'product_id': productId, 'professional_id': professionalId},
          );
          return;
        }
      }

      // 根据 details_type 跳转不同类型的商品详情页
      switch (detailsType) {
        case '1':
          // 经典商品详情
          print('📝 detailsType == 1 (经典)，未购买 → 跳转 goodsDetail');
          context.push(
            AppRoutes.goodsDetail,
            extra: {'product_id': productId, 'professional_id': professionalId},
          );
          break;
        case '2':
          // 真题商品详情
          print('📖 detailsType == 2 (真题)，未购买 → 跳转 secretRealDetail');
          context.push(
            AppRoutes.secretRealDetail,
            extra: {'product_id': productId, 'professional_id': professionalId},
          );
          break;
        case '3':
          // 科目商品详情
          print('📊 detailsType == 3 (科目)，未购买 → 跳转 subjectMockDetail');
          context.push(
            AppRoutes.subjectMockDetail,
            extra: {'product_id': productId, 'professional_id': professionalId},
          );
          break;
        case '4':
          // 模拟商品详情
          print('🎯 detailsType == 4 (模拟)，未购买 → 跳转 simulatedExamRoom');
          context.push(
            AppRoutes.simulatedExamRoom,
            extra: {'product_id': productId, 'professional_id': professionalId},
          );
          break;
      }
      return;
    }

    // ✅ 对应小程序 Line 164-222: 已购买场景 (permission_status == '1')
    if (permissionStatus == '1') {
      // 模考 (data_type == 2)
      if (dataType == '2') {
        if (detailsType == '1') {
          // 模考+经典版+购买 → 跳转模考详情页
          print('🎯 模考+经典版+已购买 → 跳转 examInfo');
          context.push(
            AppRoutes.examInfo,
            extra: {
              'product_id': productId,
              'title': goods.name,
              'page': 'home',
            },
          );
          return;
        } else if (detailsType == '4') {
          // 模考+模考版+购买 → 跳转模拟考试
          print('🎯 模考+模考版+已购买 → 跳转 simulatedExamRoom');
          context.push(
            AppRoutes.simulatedExamRoom,
            extra: {'product_id': productId, 'professional_id': professionalId},
          );
          return;
        }
      }

      // 根据 details_type 跳转不同类型的练习页
      switch (detailsType) {
        case '1':
        case '3':
          // detailsType == 1 或 3 → 试卷
          print('📝 detailsType == $detailsType (试卷)，已购买 → 跳转 testExam');
          context.push(
            AppRoutes.testExam,
            extra: {
              'id': productId,
              'professional_id': professionalId,
              'recitation_question_model': recitationQuestionModel,
            },
          );
          break;
        case '2':
          // detailsType == 2 → 真题详情
          print('📖 detailsType == 2 (真题)，已购买 → 跳转 secretRealDetail');
          context.push(
            AppRoutes.secretRealDetail,
            extra: {'product_id': productId, 'professional_id': professionalId},
          );
          break;
        case '4':
          // detailsType == 4 → 模拟考试
          print('🎯 detailsType == 4 (模拟)，已购买 → 跳转 simulatedExamRoom');
          context.push(
            AppRoutes.simulatedExamRoom,
            extra: {'product_id': productId, 'professional_id': professionalId},
          );
          break;
      }
    }
  }

  /// 对应小程序: daily-nav.vue Line 112-136
  void _handleDailyPractice(BuildContext context) {
    // ✅ 检查登录状态（根据 Guideline 5.1.1，刷题需要登录）
    if (!ref.read(authProvider).isLoggedIn) {
      _showLoginDialog(context);
      return;
    }

    final state = ref.read(questionBankProvider);
    final dailyPractice = state.dailyPractice;

    if (dailyPractice == null) {
      EasyLoading.showInfo('暂无每日一测数据');
      return;
    }

    // 获取当前专业ID
    final authState = ref.read(authProvider);
    final currentMajor = authState.currentMajor;
    final professionalId = currentMajor?.majorId;

    if (professionalId == null || professionalId.isEmpty) {
      EasyLoading.showInfo('请先选择专业');
      return;
    }

    final goodsId = dailyPractice.id;
    if (goodsId.isEmpty || goodsId == '0') {
      EasyLoading.showInfo('暂无免费每日一测！');
      return;
    }

    final permissionStatus = dailyPractice.permissionStatus;

    // ⚠️ 详细调试日志
    debugPrint('\n' + '=' * 50);
    debugPrint('📚 每日一测点击事件调试信息');
    debugPrint('=' * 50);
    debugPrint('goodsId: $goodsId');
    debugPrint('professionalId: $professionalId');
    debugPrint(
      'permissionStatus: $permissionStatus (类型: ${permissionStatus.runtimeType})',
    );
    debugPrint('permissionStatus == "1": ${permissionStatus == '1'}');
    debugPrint('permissionStatus != "1": ${permissionStatus != '1'}');
    debugPrint('dailyPractice完整数据: $dailyPractice');
    debugPrint('=' * 50 + '\n');

    // 未购买 (permission_status != '1')
    if (permissionStatus != '1') {
      // 跳转到商品详情页
      debugPrint('❌ 未购买 → 跳转到商品详情页 (GoodsDetailPage)');
      context.push(
        AppRoutes.goodsDetail,
        extra: {'product_id': goodsId, 'professional_id': professionalId},
      );
    } else {
      // 已购买 (permission_status == '1')
      // ✅ 对应小程序: daily-nav-two.vue Line 248-251，每日一练传 recitation_question_model=1 开启答题/背题
      debugPrint('✅ 已购买 → 跳转到试卷详情页 (TestExamPage)，开启背题模式');
      context.push(
        AppRoutes.testExam,
        extra: {
          'id': goodsId,
          'professional_id': professionalId,
          'recitation_question_model': '1',
        },
      );
    }
  }

  /// 处理章节练习点击
  /// 对应小程序: src/modules/jintiku/components/commen/index-nav.vue Line 110-135
  void _handleChapterPractice(BuildContext context) {
    // ✅ 检查登录状态（根据 Guideline 5.1.1，刷题需要登录）
    if (!ref.read(authProvider).isLoggedIn) {
      _showLoginDialog(context);
      return;
    }

    final state = ref.read(questionBankProvider);
    final chapterExercise = state.chapterExercise;

    if (chapterExercise == null) {
      EasyLoading.showInfo('暂无章节练习数据');
      return;
    }

    // 获取当前专业ID
    final authState = ref.read(authProvider);
    final currentMajor = authState.currentMajor;
    final professionalId = currentMajor?.majorId;

    if (professionalId == null || professionalId.isEmpty) {
      EasyLoading.showInfo('请先选择专业');
      return;
    }

    final goodsId = chapterExercise.id;
    if (goodsId.isEmpty || goodsId == '0') {
      EasyLoading.showInfo('暂无免费章节练习！');
      return;
    }

    // ✅ 根据小程序逻辑: index-nav.vue Line 110-135
    final permissionStatus = chapterExercise.permissionStatus;
    final questionNumber = chapterExercise.questionNumber;

    // ⚠️ 详细调试日志
    debugPrint('\n' + '=' * 50);
    debugPrint('📚 章节练习点击事件调试信息');
    debugPrint('=' * 50);
    debugPrint('goodsId: $goodsId');
    debugPrint('professionalId: $professionalId');
    debugPrint(
      'permissionStatus: $permissionStatus (类型: ${permissionStatus.runtimeType})',
    );
    debugPrint('questionNumber: $questionNumber');
    debugPrint('=' * 50 + '\n');

    // 未购买 (permission_status != '1')
    if (permissionStatus != '1') {
      // 跳转到商品详情页
      // 对应小程序: index-nav.vue Line 125-128
      print('❌ 章节练习未购买 → 跳转到商品详情页 (GoodsDetailPage)');
      context.push(
        AppRoutes.goodsDetail,
        extra: {'product_id': goodsId, 'professional_id': professionalId},
      );
    } else {
      // 已购买 (permission_status == '1')
      // ✅ 章节练习是 type=18 类型，跳转到章节列表页
      // 对应小程序: pages/chapterExercise/index (index-nav.vue Line 131-134)
      print(
        '✅ 章节练习已购买 → 跳转到章节列表页 (ChapterExercise) '
        'goodsId=$goodsId, total=$questionNumber',
      );
      context.push(
        AppRoutes.chapterExercise,
        extra: {
          'professional_id': professionalId,
          'goods_id': goodsId,
          'total': questionNumber,
          'isfree': 1,
        },
      );
    }
  }

  /// 显示登录提示对话框
  /// 根据 Guideline 5.1.1，打卡和刷题需要登录
  /// 使用统一的 ConfirmDialog 组件
  void _showLoginDialog(BuildContext context) {
    ConfirmDialog.show(
      context,
      title: '需要登录',
      content: '此操作需要登录账户，请先登录后再试',
      confirmText: '去登录',
      cancelText: '取消',
      onConfirm: () {
        // ✅ 使用 GoRouterState.of(context).uri 获取当前完整路径（包括查询参数）
        final routerState = GoRouterState.of(context);
        final currentUri = routerState.uri;
        String returnPath = currentUri.path;
        if (currentUri.queryParameters.isNotEmpty) {
          final queryString = currentUri.queryParameters.entries
              .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
              .join('&');
          returnPath = '$returnPath?$queryString';
        }

        print('🔄 [题库登录] 返回路径: $returnPath');

        context.push(AppRoutes.loginCenter, extra: {'returnPath': returnPath});
      },
    );
  }
}
