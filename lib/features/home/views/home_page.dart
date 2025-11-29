import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/home_provider.dart';
import '../models/goods_model.dart';
import '../../major/widgets/major_selector_dialog.dart';
import 'widgets/seckill_card.dart';
import 'widgets/goods_card.dart';
import 'widgets/course_card.dart';
import 'widgets/home_tab_bar.dart';
import 'widgets/section_title.dart';

/// 首页 - 刷题（带轮播）
/// 对应小程序: src/modules/jintiku/pages/index/brushing.vue
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // ✅ Tab索引: 1=题库, 2=网课, 3=直播 (与小程序保持一致)
  int _tabIndex = 1;

  @override
  void initState() {
    super.initState();
    // 页面加载时获取数据
    Future.microtask(() {
      ref.read(homeProvider.notifier).loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final major = ref.watch(currentMajorProvider);
    // 获取状态栏高度
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      // ✅ 不使用 SafeArea,让背景图片充满状态栏
      body: Stack(
        children: [
          // ✅ 背景图片 - 充满状态栏
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CachedNetworkImage(
              imageUrl: 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/my-background-img.png',
              height: (statusBarHeight + 48.h), // 状态栏高度 + 固定头部高度
              fit: BoxFit.cover,
              errorWidget: (context, error, stackTrace) {
                return Container(
                  height: (statusBarHeight + 48.h),
                  color: Colors.white,
                );
              },
            ),
          ),
          // 主内容区域
          Positioned.fill(
            child: RefreshIndicator(
              onRefresh: () => ref.read(homeProvider.notifier).refresh(),
              child: CustomScrollView(
                slivers: [
                  // 顶部占位（状态栏 + 固定头部）
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: statusBarHeight + 48.h, // 状态栏高度 + 固定头部高度
                    ),
                  ),
                  // 内容区域
                  if (homeState.isLoading)
                    SliverToBoxAdapter(
                      child: _buildLoading(),
                    )
                  else if (homeState.error != null)
                    SliverToBoxAdapter(
                      child: _buildError(homeState.error!),
                    )
                  else
                    _buildContent(homeState),
                ],
              ),
            ),
          ),
          // 固定头部
          _buildFixedHeader(
            major?.majorName ?? '选择专业',
            statusBarHeight,
          ),
        ],
      ),
    );
  }

  /// 构建固定头部 - 专业选择
  /// 对应小程序: .header-box (height: 100rpx + padding-top: 80rpx)
  /// 小程序 .major text: font-size: 40rpx, font-weight: 500
  Widget _buildFixedHeader(String majorName, double statusBarHeight) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        // ✅ 总高度 = 状态栏高度 + 固定头部高度
        height: statusBarHeight + 48.h,
        // ✅ 透明背景,让背景图片显示
        color: Colors.transparent,
        // ✅ 内容从状态栏下方开始
        padding: EdgeInsets.only(
          top: statusBarHeight,
          left: 12.w,
        ),
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () {
            // 打开专业选择弹窗
            showMajorSelector(
              context,
              onChanged: () {
                // 专业变更后刷新首页数据
                ref.read(homeProvider.notifier).loadHomeData();
              },
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                majorName,
                style: TextStyle(
                  fontSize: 20.sp, // 小程序40rpx ÷ 2 = 20.sp
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 10.w), // 小程序20rpx ÷ 2 = 10.w
              CachedNetworkImage(
                imageUrl: 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/down.png',
                width: 10.w, // 小程序20rpx ÷ 2 = 10.w
                height: 10.w,
                errorWidget: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建加载中状态
  Widget _buildLoading() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(50.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16.h),
            Text(
              '加载中...',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
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
        padding: EdgeInsets.all(50.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: Colors.red.shade300,
            ),
            SizedBox(height: 16.h),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(homeProvider.notifier).refresh();
              },
              icon: Icon(Icons.refresh, size: 18.sp),
              label: Text(
                '重试',
                style: TextStyle(fontSize: 14.sp),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 12.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建秒杀轮播
  /// 对应小程序: .seckill swiper
  /// 宽度: 100vw, 高度: 270rpx, left: -24rpx (突破父容器padding)
  Widget _buildSeckillBanner(List<GoodsModel> recommendList) {
    
    return SizedBox(
      width: double.infinity,
      height: 170.h, // 增加高度确保内容不溢出(小程序270rpx ÷ 2 = 135.h,实际需要更多)
      child: recommendList.isEmpty
          ? _buildEmptySeckillCard()
          : CarouselSlider.builder(
              itemCount: recommendList.length,
              itemBuilder: (context, index, realIndex) {
                final goods = recommendList[index];
                return SeckillCard(
                  goods: goods,
                  onTap: () => _handleSeckillCardTap(goods),
                );
              },
              options: CarouselOptions(
                height: 150.h,
                viewportFraction: 0.85, // 卡片占屏幕宽度92%
                enlargeCenterPage: false,
                autoPlay: true, // 开启自动轮播
                autoPlayInterval: Duration(seconds: 3), // 3秒自动切换
                autoPlayAnimationDuration: Duration(milliseconds: 800), // 动画时长800ms
                autoPlayCurve: Curves.fastOutSlowIn, // 动画曲线
                pauseAutoPlayOnTouch: true, // 触摸时暂停自动播放
                enableInfiniteScroll: true, // 无限循环
              ),
            ),
    );
  }

  /// 处理秒杀卡片点击
  void _handleSeckillCardTap(GoodsModel goods) {
    final major = ref.read(currentMajorProvider);
    final goodsId = goods.goodsId?.toString();
    final professionalId = major?.majorId.toString();
    
    // 秒杀商品跳转到商品详情页
    _navigateToGoodsDetail(goods, goodsId, professionalId);
  }

  /// 构建空状态秒杀卡片
  Widget _buildEmptySeckillCard() {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, right: 4.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: CachedNetworkImage(
          imageUrl: 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/36byshkvk6.jpg',
          fit: BoxFit.cover,
          errorWidget: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFFF4F9FF),
              alignment: Alignment.center,
              child: Icon(Icons.image, size: 50.sp, color: Colors.grey.shade300),
            );
          },
        ),
      ),
    );
  }

  /// 构建内容区域
  /// 对应小程序: .content
  Widget _buildContent(HomeState state) {
    // ✅ 对照小程序 Line 108-120: 默认只显示「题库」tab
    // 小程序通过 getConfigCo() 动态控制是否显示「网课」和「直播」
    // TODO: 后续需要实现配置接口控制tab显示
    final tabs = ['题库', '网课', '直播'];
    
    // ✅ 根据tabIndex分发数据 (与小程序保持一致)
    // 小程序 Line 48-59:
    // tabIndex==1 → goodsList8a10a18 (题库)
    // tabIndex==2 → goodsOnlineCourses (网课)
    // tabIndex==3 → goodsListLive (直播)
    final List<GoodsModel> currentList;
    switch (_tabIndex) {
      case 1:
        currentList = state.questionBankList; // ✅ 题库
        break;
      case 2:
        currentList = state.onlineCourseList; // ✅ 网课
        break;
      case 3:
        currentList = state.liveList; // ✅ 直播
        break;
      default:
        currentList = state.questionBankList;
    }

    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.r), // 20rpx ÷ 2 = 10.r
            topRight: Radius.circular(10.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 秒杀标题区域(有左右padding)
            // 小程序: .title margin-bottom: 20rpx, padding: 32rpx 24rpx
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w), // 24rpx ÷ 2 = 12.w
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h), // 32rpx ÷ 2 = 16.h (小程序content的padding-top)
                  _buildSectionTitle('秒杀'),
                  SizedBox(height: 10.h), // 20rpx ÷ 2 = 10.h
                ],
              ),
            ),
            // 秒杀轮播区域（全屏宽度）

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: _buildSeckillBanner(state.recommendList),    
            ),
            // _buildSeckillBanner(state.recommendList),   
            SizedBox(height: 20.h),
            // 其余内容（有左右padding）
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w), // 24rpx ÷ 2 = 12.w
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTabBar(
                    tabs: tabs,
                    activeIndex: _tabIndex,
                    onTap: (idx) {
                      // ✅ 修复: idx范围为 0,1,2，需要+1转换为 1,2,3后再比较
                      final newTabIndex = idx + 1;
                      if (_tabIndex != newTabIndex) {
                        setState(() {
                          _tabIndex = newTabIndex;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 10.h), // 20rpx ÷ 2 = 10.h
                  // ✅ 根据不同Tab显示不同列表 (对照小程序 Line 48-59)
                  if (_tabIndex == 1)
                    _buildQuestionBankList(currentList) // 题库 - 使用GoodsCard
                  else
                    _buildCourseList(currentList), // 网课/直播 - 使用CourseCard
                  SizedBox(height: 30.h), // 60rpx ÷ 2 = 30.h
                  // ✅ 已购试题区域（只在题库tab显示）
                  // 对应小程序 Line 54-59
                  if (_tabIndex == 1 && state.purchasedList.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('已购试题'),
                        SizedBox(height: 10.h),
                        _buildPurchasedList(state.purchasedList),
                        SizedBox(height: 30.h),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建区域标题
  Widget _buildSectionTitle(String title) {
    return SectionTitle(title: title);
  }

  /// 构建Tab切换栏
  Widget _buildTabBar({
    required List<String> tabs,
    required int activeIndex,
    required ValueChanged<int> onTap,
  }) {
    // ✅ activeIndex: 1,2,3 → 转换为 0,1,2 显示
    return HomeTabBar(
      tabs: tabs,
      activeIndex: activeIndex - 1,
      onTap: onTap,
    );
  }

  /// 构建题库列表
  Widget _buildQuestionBankList(List<GoodsModel> list) {
    if (list.isEmpty) {
      print('⚠️ [题库列表] 列表为空，显示空状态');
      return Center(
        child: Padding(
          padding: EdgeInsets.all(50.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inbox_outlined, size: 64.sp, color: Colors.grey.shade300),
              SizedBox(height: 16.h),
              Text(
                '暂无题库数据',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    print('✅ [题库列表] 显示 ${list.length} 个题库商品:');
    for (var i = 0; i < list.length; i++) {
      final goods = list[i];
      print('   [$i] ${goods.name} (ID: ${goods.goodsId}, type: ${goods.type}, permission_status: ${goods.permissionStatus})');
    }

    return Column(
      children: list.map((goods) => GoodsCard(
        goods: goods,
        onTap: () => _handleGoodsCardTap(goods),
      )).toList(),
    );
  }

  /// ✅ 构建已购试题列表
  /// 对应小程序 Line 59
  Widget _buildPurchasedList(List<GoodsModel> list) {
    print('✅ [已购试题] 显示 ${list.length} 个已购商品:');
    for (var i = 0; i < list.length; i++) {
      final goods = list[i];
      print('   [$i] ${goods.name} (ID: ${goods.goodsId}, type: ${goods.type})');
    }

    return Column(
      children: list.map((goods) => GoodsCard(
        goods: goods,
        onTap: () => _handleGoodsCardTap(goods),
      )).toList(),
    );
  }

  /// 处理题库卡片点击
  void _handleGoodsCardTap(GoodsModel goods) {
    final major = ref.read(currentMajorProvider);
    final goodsId = goods.goodsId?.toString();
    final professionalId = major?.majorId.toString();
    
    // 根据购买状态和商品类型跳转不同页面
    if (goods.permissionStatus == '2') {
      // 未购买 - 跳转商品详情页
      _navigateToGoodsDetail(goods, goodsId, professionalId);
    } else if (goods.permissionStatus == '1') {
      // 已购买 - 跳转练习页面
      _navigateToChapterPractice(goods, goodsId, professionalId);
    }
  }

  /// 跳转到商品详情页
  void _navigateToGoodsDetail(GoodsModel goods, String? goodsId, String? professionalId) {
    final type = goods.type;
    final detailsType = goods.detailsType;
    final dataType = goods.dataType;
    
    // type == 2: 课程
    if (type == 2) {
      context.push(
        AppRoutes.goodsDetail,
        extra: {
          'goods_id': goodsId,
          'professional_id': professionalId,
          'type': type,
        },
      );
      return;
    }
    
    // 模考 (dataType == 2)
    if (dataType == 2) {
      if (detailsType == 1) {
        // 模考+经典版+没有购买
        context.push(
          AppRoutes.goodsDetail,
          extra: {
            'goods_id': goodsId,
            'professional_id': professionalId,
          },
        );
        return;
      } else if (detailsType == 4) {
        // 模考+模考版+没有购买
        context.push(
          AppRoutes.simulatedExamRoom,
          extra: {
            'product_id': goodsId,
            'professional_id': professionalId,
          },
        );
        return;
      }
    }
    
    // 根据detailsType跳转不同商品详情页
    switch (detailsType) {
      case 1:
        // 经典商品详情
        context.push(
          AppRoutes.goodsDetail,
          extra: {
            'goods_id': goodsId,
            'professional_id': professionalId,
          },
        );
        break;
      case 2:
        // 真题商品详情
        context.push(
          AppRoutes.secretRealDetail,
          extra: {
            'product_id': goodsId,
            'professional_id': professionalId,
          },
        );
        break;
      case 3:
        // 科目商品详情
        context.push(
          AppRoutes.subjectMockDetail,
          extra: {
            'product_id': goodsId,
            'professional_id': professionalId,
          },
        );
        break;
      case 4:
        // 模拟商品详情
        context.push(
          AppRoutes.simulatedExamRoom,
          extra: {
            'product_id': goodsId,
            'professional_id': professionalId,
          },
        );
        break;
      default:
        // 默认跳转经典商品详情
        context.push(
          AppRoutes.goodsDetail,
          extra: {
            'goods_id': goodsId,
            'professional_id': professionalId,
          },
        );
    }
  }

  /// 跳转到章节练习
  void _navigateToChapterPractice(GoodsModel goods, String? goodsId, String? professionalId) {
    final type = goods.type;
    final detailsType = goods.detailsType;
    final dataType = goods.dataType;
    final questionNum = goods.tikuGoodsDetails?.questionNum;
    
    // type == 2: 课程
    if (type == 2) {
      context.push(
        AppRoutes.goodsDetail,
        extra: {
          'goods_id': goodsId,
          'professional_id': professionalId,
          'type': type,
        },
      );
      return;
    }
    
    // type == 18: 章节练习
    if (type == 18) {
      context.push(
        AppRoutes.chapterList,
        extra: {
          'goods_id': goodsId,
          'professional_id': professionalId,
          'total': questionNum,
        },
      );
      return;
    }
    
    // 模考 (dataType == 2)
    if (dataType == 2) {
      if (detailsType == 1) {
        // 模考+经典版+已购买
        // 对应小程序: pages/modelExaminationCompetition/examInfo
        context.push(
          AppRoutes.examInfo,
          extra: {
            'product_id': goodsId,
            'title': goods.name,
            'page': 'home',
          },
        );
        return;
      } else if (detailsType == 4) {
        // 模考+模考版+已购买
        context.push(
          AppRoutes.simulatedExamRoom,
          extra: {
            'product_id': goodsId,
            'professional_id': professionalId,
          },
        );
        return;
      }
    }
    
    // 根据detailsType跳转不同页面
    switch (detailsType) {
      case 1:
      case 3:
        // 经典详情/科目详情 - 跳转考试页
        // 对应小程序: pages/test/exam
        context.push(
          AppRoutes.testExam,
          extra: {
            'id': goodsId,
            'recitation_question_model': goods.recitationQuestionModel,
          },
        );
        break;
      case 2:
        // 真题详情
        context.push(
          AppRoutes.secretRealDetail,
          extra: {
            'product_id': goodsId,
            'professional_id': professionalId,
          },
        );
        break;
      case 4:
        // 模拟详情
        context.push(
          AppRoutes.simulatedExamRoom,
          extra: {
            'product_id': goodsId,
            'professional_id': professionalId,
          },
        );
        break;
    }
  }
  
  /// 构建课程列表（网课/直播）
  /// 对应小程序: 首页课程卡片点击逻辑
  Widget _buildCourseList(List<GoodsModel> list) {
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(50.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inbox_outlined, size: 64.sp, color: Colors.grey.shade300),
              SizedBox(height: 16.h),
              Text(
                '暂无课程数据',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: list.map((goods) => CourseCard(
        goods: goods,
        onTap: () => _handleCourseCardTap(goods),
      )).toList(),
    );
  }
  
  /// 处理课程卡片点击
  /// 对应小程序: courseDetail.vue 的跳转逻辑
  void _handleCourseCardTap(GoodsModel goods) {

    final major = ref.read(currentMajorProvider);
    final goodsId = goods.goodsId?.toString();
    final professionalId = major?.majorId.toString();
    final type = goods.type;
    
    // ✅ 对应小程序 Line 511-516: 网课/直播课特殊处理
    if ((type == 2 || type == 3) && 
        (goods.teachingType == 1 || goods.teachingType == 3)) {
      
      // ⚠️ 根据购买状态跳转不同页面
      if (goods.permissionStatus == '1') {
        // ✅ 已购买 - 跳转课程学习页 CourseDetailPage
        // 对应小程序: study/detail/index.vue (带 order_id)
        print('\n✅ 判断: 已购买课程');
        print('  → 跳转 CourseDetailPage (课程学习页)');
        print('  → 传递 orderId: ${goods.permissionOrderId}');
        print('==============================================\n');
        
        context.push(
          AppRoutes.courseDetail,
          extra: {
            'goodsId': goodsId,
            'orderId': goods.permissionOrderId?.toString() ?? '0',  // ✅ 传递 orderId
            'goodsPid': null,
          },
        );
      } else {
        // ❌ 未购买 - 跳转商品详情页 CourseGoodsDetailPage
        // 对应小程序: courseDetail.vue (报名页)
        print('\n❌ 判断: 未购买课程');
        print('  → 跳转 CourseGoodsDetailPage (商品详情/报名页)');
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
