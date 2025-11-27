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
  /// 秒杀商品都是未购买状态(permission_status == '2'),直接跳转商品详情页
  void _handleSeckillCardTap(GoodsModel goods) {
    print('⚡ 点击秒杀卡片: ${goods.goodsName}, type: ${goods.type}');
    
    final major = ref.read(currentMajorProvider);
    final goodsId = goods.goodsId?.toString();
    final professionalId = major?.majorId?.toString();
    
    // 秒杀商品跳转到商品详情页（未购买）
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
        onTap: () => _handleGoodsCardTap(goods),
      )).toList(),
    );
  }

  /// 处理题库卡片点击
  /// 对应小程序: examination-test-item.vue goDetail()
  void _handleGoodsCardTap(GoodsModel goods) {
    print('👆 点击题库卡片: ${goods.goodsName}, type: ${goods.type}, permission: ${goods.permissionStatus}');
    
    final major = ref.read(currentMajorProvider);
    final goodsId = goods.goodsId?.toString();
    final professionalId = major?.majorId?.toString();
    
    // 根据购买状态和商品类型跳转不同页面
    if (goods.permissionStatus == '2') {
      // 未购买 - 跳转商品详情页
      _navigateToGoodsDetail(goods, goodsId, professionalId);
    } else if (goods.permissionStatus == '1') {
      // 已购买 - 跳转练习页面
      _navigateToChapterPractice(goods, goodsId, professionalId);
    }
  }

  /// 跳转到商品详情页（未购买）
  void _navigateToGoodsDetail(GoodsModel goods, String? goodsId, String? professionalId) {
    final type = goods.type;
    final detailsType = goods.detailsType;
    final dataType = goods.dataType;
    
    print('📦 跳转商品详情 - type: $type, detailsType: $detailsType, dataType: $dataType');
    
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

  /// 跳转到章节练习（已购买）
  void _navigateToChapterPractice(GoodsModel goods, String? goodsId, String? professionalId) {
    final type = goods.type;
    final detailsType = goods.detailsType;
    final dataType = goods.dataType;
    final questionNum = goods.tikuGoodsDetails?.questionNum;
    
    print('📝 跳转章节练习 - type: $type, detailsType: $detailsType');
    
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
        // TODO: 实现ExamInfoPage
        print('⚠️ 模考详情页待实现');
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
        // TODO: 实现TestExamPage
        print('⚠️ 考试页待实现');
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
