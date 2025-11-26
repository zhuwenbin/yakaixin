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
  int _tabIndex = 0;

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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Stack(
          children: [
            // 主内容区域
            RefreshIndicator(
              onRefresh: () => ref.read(homeProvider.notifier).refresh(),
              child: CustomScrollView(
                slivers: [
                  // 顶部占位（为固定头部留空间）
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 48.h, // 小程序96rpx ÷ 2 = 48.h
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
            // 固定头部
            _buildFixedHeader(major?.majorName ?? '选择专业'),
          ],
        ),
      ),
    );
  }

  /// 构建固定头部 - 专业选择
  /// 对应小程序: .header-box (height: 100rpx + padding-top: 80rpx)
  /// 小程序 .major text: font-size: 40rpx, font-weight: 500
  Widget _buildFixedHeader(String majorName) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 48.h, // 小程序96rpx ÷ 2 = 48.h
        color: Colors.white,
        padding: EdgeInsets.only(left: 12.w), // 小程序24rpx ÷ 2 = 12.w
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
                  onTap: () {
                    // TODO: 跳转到商品详情页
                  },
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
    final tabs = ['题库', '网课', '直播'];
    final List<GoodsModel> currentList;
    switch (_tabIndex) {
      case 1:
        currentList = state.onlineCourseList;
        break;
      case 2:
        currentList = state.liveList;
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
                      if (_tabIndex != idx) {
                        setState(() {
                          _tabIndex = idx;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 10.h), // 20rpx ÷ 2 = 10.h
                  // 根据不同Tab显示不同列表
                  if (_tabIndex == 0)
                    _buildQuestionBankList(currentList)
                  else
                    _buildCourseList(currentList),
                  SizedBox(height: 30.h), // 60rpx ÷ 2 = 30.h
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
    return HomeTabBar(
      tabs: tabs,
      activeIndex: activeIndex,
      onTap: onTap,
    );
  }

  /// 构建题库列表
  Widget _buildQuestionBankList(List<GoodsModel> list) {
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

    return Column(
      children: list.map((goods) => GoodsCard(
        goods: goods,
        onTap: () {
          // TODO: 跳转到详情页
        },
      )).toList(),
    );
  }
  
  /// 构建课程列表（网课/直播）
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
        onTap: () {
          print('👆 点击课程卡片: ${goods.goodsName}, type: ${goods.type}');
          // 跳转到课程商品详情页
          final major = ref.read(currentMajorProvider);
          print('📦 准备跳转 - goodsId: ${goods.goodsId}, type: ${goods.type}, majorId: ${major?.majorId}');
          context.push(
            AppRoutes.goodsDetail,
            extra: {
              'goods_id': goods.goodsId?.toString(),
              'professional_id': major?.majorId?.toString(),
              'type': goods.type, // 2/3=课程
            },
          );
          print('✅ context.push 已执行');
        },
      )).toList(),
    );
  }
}
