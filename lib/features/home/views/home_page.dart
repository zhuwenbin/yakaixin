import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/home_provider.dart';
import '../models/goods_model.dart';

/// 首页 - 刷题（带轮播）
/// 对应小程序: src/modules/jintiku/pages/index/brushing.vue
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final PageController _pageController;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
    // 页面加载时获取数据
    Future.microtask(() {
      ref.read(homeProvider.notifier).loadHomeData();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                      height: 96.h,
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
        height: 96.h,
        color: Colors.white,
        padding: EdgeInsets.only(left: 24.w),
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () {
            // TODO: 打开专业选择弹窗
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                majorName,
                style: TextStyle(
                  fontSize: 20.sp, // 小程序: 40rpx
                  fontWeight: FontWeight.w500, // 小程序: 500
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 20.w), // 小程序: margin-left: 20rpx
              CachedNetworkImage(
                imageUrl: 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/down.png',
                width: 20.w,
                height: 20.w,
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
      height: 300.h, // 增加高度避免溢出,小程序是270rpx但内容较多
      child: PageView.builder(
        controller: _pageController,
        padEnds: false,
        itemCount: recommendList.isEmpty ? 1 : recommendList.length,
        itemBuilder: (context, index) {
          if (recommendList.isEmpty) {
            // 空状态图片 (对应小程序 .empty-item: padding: 24rpx 24rpx 0rpx 24rpx)
            return Padding(
              padding: EdgeInsets.only(left: 8.w, right: 8.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32.r),
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
          final goods = recommendList[index];
          // swiper-item 的 padding: 24rpx 24rpx 0rpx 24rpx
          return Padding(
            padding: EdgeInsets.only(left: 8.w, right: 8.w),
            child: _buildSeckillCard(goods),
          );
        },
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
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 秒杀标题区域(有左右padding)
            // 小程序: .title margin-bottom: 20rpx
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 0.h), // 移除顶部间距,紧贴content顶部
                  _buildSectionTitle('秒杀'),
                  SizedBox(height: 20.h), // 小程序: margin-bottom: 20rpx
                ],
              ),
            ),
            // 秒杀轮播区域（全屏宽度）
            _buildSeckillBanner(state.recommendList),
            // 其余内容（有左右padding）
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                  SizedBox(height: 20.h),
                  _buildQuestionBankList(currentList),
                  SizedBox(height: 60.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建区域标题
  /// 对应小程序: .title (font-size: 32rpx, font-weight: 600, margin-right: 10rpx)
  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/title-icon.png',
          width: 30.w,
          height: 30.w,
          errorWidget: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
        SizedBox(width: 10.w), // 小程序: margin-right: 10rpx
        Text(
          title,
          style: TextStyle(
            fontSize: 32.sp, // 小程序: 32rpx
            fontWeight: FontWeight.w600,
            color: Color(0xFF161f30),
          ),
        ),
      ],
    );
  }

  /// 构建Tab切换栏
  /// 对应小程序: .tabs
  Widget _buildTabBar({
    required List<String> tabs,
    required int activeIndex,
    required ValueChanged<int> onTap,
  }) {
    return SizedBox(
      height: 70.h,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isActive = index == activeIndex;
            return Padding(
              padding: EdgeInsets.only(right: index == tabs.length - 1 ? 0 : 40.w),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(index),
                child: _buildTabItem(
                  tabs[index],
                  isActive: isActive,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  /// 构建单个Tab项
  Widget _buildTabItem(String label, {bool isActive = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isActive ? 36.sp : 32.sp,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? Colors.black : const Color(0xFF666666),
          ),
        ),
        if (isActive) ...[
          SizedBox(height: 4.h),
          Container(
            width: 80.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: const Color(0xFF018BFF),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ],
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
      children: list.map((goods) => _buildGoodsCard(goods)).toList(),
    );
  }

  /// 构建秒杀卡片
  /// 对应小程序: examination-test-item (seckill模式)
  /// min-height: 213rpx, padding: 24rpx 32rpx 0rpx 32rpx
  Widget _buildSeckillCard(GoodsModel goods) {
    return GestureDetector(
      onTap: () {
        // TODO: 跳转到商品详情页
      },
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 213.h),
        padding: EdgeInsets.fromLTRB(32.w, 24.h, 32.w, 0),
        decoration: BoxDecoration(
          // 渐变背景: linear-gradient(90deg, #FBF1FF 0%, #D8F0FF 100%)
          gradient: LinearGradient(
            colors: [Color(0xFFFBF1FF), Color(0xFFD8F0FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(32.r),
          // box-shadow: 0 0 30rpx rgba(27, 38, 55, 0.06)
          boxShadow: [
            BoxShadow(
              color: Color(0x0F1B2637), // rgba(27, 38, 55, 0.06)
              blurRadius: 30.r,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 头部：商品名称 + 价格
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 商品名称（2行省略，.text-ellipsis-2）
                Expanded(
                  child: Text(
                    goods.goodsName ?? '未命名商品',
                    style: TextStyle(
                      fontSize: 34.sp, // font-size: 34rpx
                      fontWeight: FontWeight.w500, // font-weight: 500
                      color: Colors.black,
                      height: 1.4, // line-height: 1.4
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 12.w),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.topRight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 原价 (.original_price)
                        if (goods.originalPrice != null && 
                            goods.originalPrice.toString().isNotEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${goods.originalPrice}',
                                style: TextStyle(
                                  fontSize: 32.sp, // font-size: 32rpx
                                  fontWeight: FontWeight.w800, // font-weight: 800
                                  color: const Color(0xFFA3A3A3),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              SizedBox(width: 8.w), // margin-left: 8rpx
                              // 秒杀价标签图标: 70rpx x 30rpx
                              CachedNetworkImage(
                                imageUrl: 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/92ac17422896646546913_miaoshajia.png',
                                width: 70.w,
                                height: 30.h,
                                errorWidget: (context, error, stackTrace) => const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        // 现价 (.sale_price) - 与原价同行!
                        if (goods.price != null && goods.price.toString().isNotEmpty)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 符号: 24rpx, font-weight: 500, color: #D845A6
                              Text(
                                '¥',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFD845A6),
                                ),
                              ),
                              // 金额: 40rpx, font-weight: 800, color: #D845A6
                              Text(
                                '${goods.price}',
                                style: TextStyle(
                                  fontSize: 40.sp,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFFD845A6),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // 标签区域 (.tags)
            // padding-top: 20rpx, padding-bottom: 24rpx
            Padding(
              padding: EdgeInsets.only(top: 20.h, bottom: 24.h),
              child: Wrap(
                spacing: 12.w, // margin-right: 12rpx
                children: [
                  // 题数标签 (.ee-seckill-q)
                  // background: #FFD27C, font-weight: 600, color: black
                  if (goods.tikuGoodsDetails?.questionNum != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFD27C),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(text: '共 '),
                            TextSpan(
                              text: '${goods.tikuGoodsDetails!.questionNum}',
                              style: TextStyle(color: Colors.red),
                            ),
                            TextSpan(text: ' 题'),
                          ],
                        ),
                      ),
                    ),
                  // 有效期标签 (.ee-tag-class)
                  // border: 3rpx solid #4981D7, color: #4981D7, background: transparent
                  if (goods.validityDay != null && goods.validityDay!.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF4981D7), width: 3.w),
                        borderRadius: BorderRadius.circular(8.r),
                        color: Colors.transparent,
                      ),
                      child: Text(
                        goods.validityDay == '0' ? '永久' : '${goods.validityDay}个月',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF4981D7),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // 倒计时区域 (.bottom-time)
            // height: 72rpx, position: relative, bottom: 0, right: 0
            SizedBox(
              height: 94.h,
              child: Align(
                alignment: Alignment.bottomRight,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final maxWidth = math.min(constraints.maxWidth * 0.9, 400.w);
                    final minWidth = math.min(constraints.maxWidth * 0.7, maxWidth);
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: maxWidth,
                        minWidth: minWidth,
                      ),
                      child: Container(
                        height: 94.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: const NetworkImage(
                              'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/5e91174186068572265789_daojishiback.png',
                            ),
                            fit: BoxFit.cover,
                            onError: (_, __) {},
                          ),
                        ),
                        padding: EdgeInsets.only(top: 22.h),
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 标签文字: 28rpx, font-weight: 400, color: #082980
                              // letter-spacing: 6rpx
                              Text(
                                '秒杀倒计时',
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF082980),
                                  letterSpacing: 6.w,
                                ),
                              ),
                              SizedBox(width: 10.w), // margin-right: 10rpx
                              // TODO: 接入真实倒计时组件 <countDown>
                              Text(
                                '07:08:48',
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF082980),
                                  letterSpacing: 2.w,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建商品卡片（普通模式）
  Widget _buildGoodsCard(GoodsModel goods) {
    return GestureDetector(
      onTap: () {
        // TODO: 跳转到详情页
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 24.h),
        padding: EdgeInsets.fromLTRB(32.w, 20.h, 32.w, 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F9FF),
          borderRadius: BorderRadius.circular(32.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0x0F1B2637),
              blurRadius: 30.r,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头部：商品名称 + 价格
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    goods.goodsName ?? '未命名商品',
                    style: TextStyle(
                      fontSize: 34.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (goods.price != null && goods.price.toString().isNotEmpty) ...[
                  SizedBox(width: 12.w),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topRight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          if (goods.originalPrice != null && goods.originalPrice.toString().isNotEmpty) ...[
                            Text(
                              '${goods.originalPrice}',
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFA3A3A3),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            SizedBox(width: 12.w),
                          ],
                          Text(
                            '¥',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFFF5E00),
                            ),
                          ),
                          Text(
                            '${goods.price}',
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFFF5E00),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
            // 标签
            Padding(
              padding: EdgeInsets.only(top: 20.h, bottom: 24.h),
              child: Wrap(
                spacing: 12.w,
                children: [
                  if (goods.tikuGoodsDetails?.questionNum != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Color(0xFFEBF1FF),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '共${goods.tikuGoodsDetails!.questionNum}题',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF2E68FF),
                        ),
                      ),
                    ),
                  if (goods.type.toString() == '8' && goods.tikuGoodsDetails?.questionNum != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF4981D7), width: 3.w),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '共${goods.tikuGoodsDetails!.questionNum}题',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF4981D7),
                        ),
                      ),
                    ),
                  if (goods.validityDay != null && goods.validityDay!.isNotEmpty && goods.permissionStatus == '1')
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF4981D7), width: 3.w),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        goods.validityDay == '0' ? '永久' : '${goods.validityDay}个月',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF4981D7),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // 底部按钮
            if (goods.permissionStatus == '1') ...[
              Container(
                height: 100.h,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFFE8E9EA), width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 160.w,
                      height: 56.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xFF2E68FF),
                        borderRadius: BorderRadius.circular(64.r),
                      ),
                      child: Text(
                        goods.type.toString() == '18' ? '立即刷题' : '立即测试',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
