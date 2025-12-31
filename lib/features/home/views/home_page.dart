import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/utils/safe_type_converter.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/home_provider.dart';
import '../models/goods_model.dart';
import '../../major/widgets/major_selector_dialog.dart';
import 'widgets/home_header.dart';
import 'widgets/home_content.dart';

/// 首页 - 刷题（带轮播）
/// 对应小程序: src/modules/jintiku/pages/index/brushing.vue
class HomePage extends ConsumerStatefulWidget {
  /// 初始Tab索引（可选，支持从其他页面跳转时指定）
  /// 对应小程序: Line 156-165 的 globalData.tabParams.index
  final int? initialTabIndex;

  const HomePage({super.key, this.initialTabIndex});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // ✅ Tab索引: 1=题库, 2=网课, 3=直播 (与小程序保持一致)
  int _tabIndex = 1;

  @override
  void initState() {
    super.initState();

    // ✅ 全局Tab参数支持（对应小程序 Line 156-165）
    // 如果传入了 initialTabIndex，则切换到对应的 Tab
    if (widget.initialTabIndex != null &&
        widget.initialTabIndex! >= 1 &&
        widget.initialTabIndex! <= 3) {
      _tabIndex = widget.initialTabIndex!;
      print('🔄 [Tab切换] 从路由参数切换到 Tab $_tabIndex');
    }

    // 页面加载时获取数据
    Future.microtask(() {
      ref.read(homeProvider.notifier).loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final major = ref.watch(currentMajorProvider);
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _buildMainContent(homeState, statusBarHeight),
          HomeHeader(
            majorName: major?.majorName ?? '选择专业',
            statusBarHeight: statusBarHeight,
            onTap: _handleMajorSelector,
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(HomeState state, double statusBarHeight) {
    return Positioned.fill(
      child: RefreshIndicator(
        onRefresh: () => ref.read(homeProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            // ✅ 顶部留出专业选择栏的高度（白色导航栏）
            SliverToBoxAdapter(child: SizedBox(height: statusBarHeight + 48.h)),
            if (state.isLoading)
              SliverToBoxAdapter(child: _buildLoading())
            else if (state.error != null)
              SliverToBoxAdapter(child: _buildError(state.error!))
            else
              HomeContent(
                state: state,
                tabIndex: _tabIndex,
                onTabChanged: _handleTabChanged,
                onSeckillTap: _handleSeckillCardTap,
                onGoodsTap: _handleGoodsCardTap,
                onCourseTap: _handleCourseCardTap,
              ),
          ],
        ),
      ),
    );
  }

  void _handleMajorSelector() {
    showMajorSelector(
      context,
      onChanged: () => ref.read(homeProvider.notifier).loadHomeData(),
    );
  }

  void _handleTabChanged(int newTabIndex) {
    if (_tabIndex != newTabIndex) {
      setState(() => _tabIndex = newTabIndex);
    }
  }

  /// 构建加载中状态
  Widget _buildLoading() {
    return Center(
      child: Padding(
        padding: AppSpacing.allXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: AppSpacing.mdV),
            Text(
              '加载中...',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建错误状态
  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: AppSpacing.allXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: AppColors.error.withOpacity(0.3),
            ),
            SizedBox(height: AppSpacing.mdV),
            Text(
              error,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.lgV),
            ElevatedButton.icon(
              onPressed: () => ref.read(homeProvider.notifier).refresh(),
              icon: Icon(Icons.refresh, size: 18.sp),
              label: Text('重试', style: AppTextStyles.buttonMedium),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textWhite,
                padding: AppSpacing.horizontalMd,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 处理秒杀卡片点击
  /// 对应小程序: examination-test-item.vue Line 191-357 的 goDetail(item)
  void _handleSeckillCardTap(GoodsModel goods) {
    final major = ref.read(currentMajorProvider);
    final goodsId = goods.goodsId?.toString();
    final professionalId = major?.majorId.toString();

    // ✅ 区分购买状态（对应小程序 Line 199 和 Line 268）
    if (goods.permissionStatus == '2') {
      // 未购买 → 跳转商品详情页
      _navigateToGoodsDetail(goods, goodsId, professionalId);
    } else if (goods.permissionStatus == '1') {
      // 已购买 → 跳转练习页
      _navigateToChapterPractice(goods, goodsId, professionalId);
    } else {
      // 未知状态 → 默认跳转详情页
      _navigateToGoodsDetail(goods, goodsId, professionalId);
    }
  }

  /// 处理题库卡片点击
  /// 对应小程序: examination-test-item.vue Line 191-357 的 goDetail(item)
  /// ✅ 逻辑一致：区分 permission_status == '1' (已购买) 和 '2' (未购买)
  void _handleGoodsCardTap(GoodsModel goods) {
    final major = ref.read(currentMajorProvider);
    final goodsId = goods.goodsId?.toString();
    final professionalId = major?.majorId.toString();

    if (goods.permissionStatus == '2') {
      _navigateToGoodsDetail(goods, goodsId, professionalId);
    } else if (goods.permissionStatus == '1') {
      _navigateToChapterPractice(goods, goodsId, professionalId);
    }
  }

  /// 处理商品详情跳转 (未购买场景)
  /// 对应小程序: examination-test-item.vue Line 199-264 (permission_status == '2')
  void _navigateToGoodsDetail(
    GoodsModel goods,
    String? goodsId,
    String? professionalId,
  ) {
    // ⚠️ 使用 toString() 确保类型安全
    final type = goods.type?.toString();
    final detailsType = goods.detailsType?.toString();
    final dataType = goods.dataType?.toString();

    // ✅ type == 2 (课程) - 跳转课程详情（对应小程序 Line 202-207）
    if (type == '2') {
      print('📚 type == 2 (课程)，未购买 → 跳转 courseDetail');
      context.push(
        AppRoutes.courseDetail, // ✅ 修复：改为 courseDetail
        extra: {
          'goods_id': goodsId,
          'professional_id': professionalId,
          'type': type,
        },
      );
      return;
    }

    // ✅ data_type == 2 (模考) + details_type == 1 (经典版) - 跳转商品详情（对应小程序 Line 210-219）
    if (dataType == '2') {
      if (detailsType == '1') {
        print(
          '🎯 dataType == 2, detailsType == 1 (模考+经典版)，未购买 → 跳转 goodsDetail',
        );
        context.push(
          AppRoutes.goodsDetail,
          extra: {'goods_id': goodsId, 'professional_id': professionalId},
        );
        return;
      } else if (detailsType == '4') {
        print(
          '🎯 dataType == 2, detailsType == 4 (模考+模考版)，未购买 → 跳转 simulatedExamRoom',
        );
        context.push(
          AppRoutes.simulatedExamRoom,
          extra: {'product_id': goodsId, 'professional_id': professionalId},
        );
        return;
      }
    }

    // ✅ 根据 details_type 跳转不同类型的商品详情（对应小程序 Line 234-264）
    switch (detailsType) {
      case '1':
        print('📝 detailsType == 1 (经典版)，未购买 → 跳转 goodsDetail');
        context.push(
          AppRoutes.goodsDetail,
          extra: {'goods_id': goodsId, 'professional_id': professionalId},
        );
        break;
      case '2':
        print('📖 detailsType == 2 (真题)，未购买 → 跳转 secretRealDetail');
        context.push(
          AppRoutes.secretRealDetail,
          extra: {'product_id': goodsId, 'professional_id': professionalId},
        );
        break;
      case '3':
        print('📊 detailsType == 3 (科目)，未购买 → 跳转 subjectMockDetail');
        context.push(
          AppRoutes.subjectMockDetail,
          extra: {'product_id': goodsId, 'professional_id': professionalId},
        );
        break;
      case '4':
        print('🎯 detailsType == 4 (模拟)，未购买 → 跳转 simulatedExamRoom');
        context.push(
          AppRoutes.simulatedExamRoom,
          extra: {'product_id': goodsId, 'professional_id': professionalId},
        );
        break;
      default:
        print('⚠️ detailsType == $detailsType (未知)，默认跳转 goodsDetail');
        context.push(
          AppRoutes.goodsDetail,
          extra: {'goods_id': goodsId, 'professional_id': professionalId},
        );
    }
  }

  /// 处理练习页跳转 (已购买场景)
  /// 对应小程序: examination-test-item.vue Line 268-337 (permission_status == '1')
  void _navigateToChapterPractice(
    GoodsModel goods,
    String? goodsId,
    String? professionalId,
  ) {
    // ⚠️ 使用 toString() 确保类型安全（type/detailsType/dataType 可能是 String 或 int）
    final type = goods.type?.toString();
    final detailsType = goods.detailsType?.toString();
    final dataType = goods.dataType?.toString();
    final questionNum = goods.tikuGoodsDetails?.questionNum;

    // ✅ type == 2 (课程) - 跳转课程详情（对应小程序 Line 270-275）

    print(
      '📚 name == ${goods.name}，type == $type，details_type == $detailsType，data_type == $dataType',
    );

    if (type == '2') {
      print('📚 type == 2 (课程)，已购买 → 跳转 courseDetail');
      context.push(
        AppRoutes.courseDetail, // ✅ 修复：改为 courseDetail
        extra: {
          'goods_id': goodsId,
          'professional_id': professionalId,
          'type': type,
        },
      );
      return;
    }

    // ✅ type == 18 (章节练习) - 跳转章节列表（对应小程序 Line 277-282）
    if (type == '18') {
      print('📚 type == 18 (章节练习)，已购买 → 跳转 chapterList');
      // ✅ 安全转换 questionNum 为 int（可能是 String 或 int）
      final totalInt = SafeTypeConverter.toInt(questionNum, defaultValue: 0);
      context.push(
        AppRoutes.chapterList,
        extra: {
          'goods_id': goodsId,
          'professional_id': professionalId,
          'total': totalInt, // ✅ 确保传递 int 类型
        },
      );
      return;
    }

    // ✅ data_type == 2 (模考) - 已购买场景（对应小程序 Line 287-308）
    if (dataType == '2') {
      if (detailsType == '1') {
        // 模考+经典版+购买 → 跳转 examInfo
        print('🎯 dataType == 2, detailsType == 1 (模考+经典版)，已购买 → 跳转 examInfo');
        context.push(
          AppRoutes.examInfo,
          extra: {'product_id': goodsId, 'title': goods.name, 'page': 'home'},
        );
        return;
      } else if (detailsType == '4') {
        // 模考+模考版+购买 → 跳转 simulatedExamRoom
        print(
          '🎯 dataType == 2, detailsType == 4 (模考+模考版)，已购买 → 跳转 simulatedExamRoom',
        );
        context.push(
          AppRoutes.simulatedExamRoom,
          extra: {'product_id': goodsId, 'professional_id': professionalId},
        );
        return;
      }
    }

    // ✅ 根据 details_type 跳转不同类型的练习页（对应小程序 Line 310-336）
    switch (detailsType) {
      case '1':
      case '3':
        // detailsType == 1 或 3 → 试卷
        print('📝 detailsType == $detailsType (试卷)，已购买 → 跳转 testExam');
        context.push(
          AppRoutes.testExam,
          extra: {
            'id': goodsId,
            'professional_id': professionalId, // ✅ 添加 professional_id 参数
            'recitation_question_model': goods.recitationQuestionModel,
          },
        );
        break;
      case '2':
        // detailsType == 2 → 真题详情
        print('📖 detailsType == 2 (真题)，已购买 → 跳转 secretRealDetail');
        context.push(
          AppRoutes.secretRealDetail,
          extra: {'product_id': goodsId, 'professional_id': professionalId},
        );
        break;
      case '4':
        // detailsType == 4 → 模拟考试
        print('🎯 detailsType == 4 (模拟)，已购买 → 跳转 simulatedExamRoom');
        context.push(
          AppRoutes.simulatedExamRoom,
          extra: {'product_id': goodsId, 'professional_id': professionalId},
        );
        break;
    }
  }

  /// 处理课程卡片点击
  void _handleCourseCardTap(GoodsModel goods) {
    final major = ref.read(currentMajorProvider);
    final goodsId = goods.goodsId?.toString();
    final professionalId = major?.majorId.toString();
    // ⚠️ 使用 toString() 确保类型安全
    final type = goods.type?.toString();

    print('🔍 点击了课程卡片: $goods.name');
    print('🔍 商品类型: $type');
    print('  → 传递 orderId: ${goods.permissionOrderId}');

    // ✅ 对应小程序 Line 511-516: 网课/直播课特殊处理
    // if ((type == '2' || type == '3') &&
    //     (goods.teachingType?.toString() == '1' || goods.teachingType?.toString() == '3')) {
    // ⚠️ 根据购买状态跳转不同页面
    //   if (goods.permissionStatus == '1') {
    //     // ✅ 已购买 - 跳转课程学习页 CourseDetailPage
    //     // 对应小程序: study/detail/index.vue (带 order_id)

    //     context.push(
    //       AppRoutes.courseDetail,
    //       extra: {
    //         'goodsId': goodsId,
    //         'orderId':
    //             goods.permissionOrderId?.toString() ?? '0', // ✅ 传递 orderId
    //         'goodsPid': null,
    //       },
    //     );
    //   } else {
    //     // ❌ 未购买 - 跳转商品详情页 CourseGoodsDetailPage
    //     // 对应小程序: courseDetail.vue (报名页)
    //     print('\n❌ 判断: 未购买课程');
    //     print('  → 跳转 CourseGoodsDetailPage (商品详情/报名页)');
    //     print('==============================================\n');

    //     context.push(
    //       AppRoutes.goodsDetail,
    //       extra: {
    //         'goods_id': goodsId,
    //         'professional_id': professionalId,
    //         'type': type,
    //       },
    //     );
    //   }
    //   return;
    // }

    if ((type == '2' || type == '3')) {
      context.push(
        AppRoutes.courseGoodsDetail,
        extra: {
          'goods_id': goodsId,
          'professional_id': professionalId,
          'type': type,
        },
      );
      return;
    }

    // ⚠️ 其他类型课程（目前暂无）
    print('\n⚠️ 其他类型课程，跳转商品详情页');
    print('==============================================\n');
    context.push(
      AppRoutes.goodsDetail,
      extra: {
        'goods_id': goodsId,
        'professional_id': professionalId,
        'type': type,
      },
    );
  }
}
