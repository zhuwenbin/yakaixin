import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/utils/safe_type_converter.dart';
import '../../../core/style/app_style_provider.dart';
import '../../../core/style/app_style_tokens.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/widgets/common_state_widget.dart';
import '../../auth/providers/auth_provider.dart';
import '../../order/providers/payment_provider.dart';
import '../../home/services/chapter_service.dart';
import '../providers/goods_detail_provider.dart';
import '../models/goods_detail_model.dart';

/// 商品详情页(经典版)
/// 对应小程序: pages/test/detail.vue

class GoodsDetailPage extends ConsumerStatefulWidget {
  final String? productId;
  final String? goodsId;
  final String? professionalId;
  final String? active;

  const GoodsDetailPage({
    super.key,
    this.productId,
    this.goodsId,
    this.professionalId,
    this.active,
  });

  @override
  ConsumerState<GoodsDetailPage> createState() => _GoodsDetailPageState();
}

class _GoodsDetailPageState extends ConsumerState<GoodsDetailPage> {
  // ✅ 防止重复点击（对应小程序 Line 510-515）
  bool _isPurchasing = false;

  // ✅ 章节列表状态管理
  List<Map<String, dynamic>> _chapterList = [];
  bool _isLoadingChapters = false;
  String? _chapterError;
  final Set<String> _expandedChapters = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final goodsId = widget.goodsId ?? widget.productId;
      if (goodsId != null && goodsId.isNotEmpty) {
        ref.read(goodsDetailNotifierProvider.notifier).loadGoodsDetail(goodsId);
      }
    });
  }

  /// 加载章节列表数据
  /// 对应小程序: detail.vue Line 387-396 (getChapterpackageTree)
  Future<void> _loadChapterList(GoodsDetailModel detail) async {
    final professionalId = detail.professionalId ?? widget.professionalId;
    final goodsId = SafeTypeConverter.toSafeString(detail.goodsId);

    if (professionalId == null || professionalId.isEmpty || goodsId.isEmpty) {
      print(
        '⚠️ [商品详情页] 缺少章节列表参数: professionalId=$professionalId, goodsId=$goodsId',
      );
      return;
    }

    if (_isLoadingChapters) return; // 防止重复加载

    setState(() {
      _isLoadingChapters = true;
      _chapterError = null;
    });

    try {
      final service = ref.read(chapterServiceProvider);
      final chapters = await service.getChapterTree(
        professionalId: professionalId,
        goodsId: goodsId,
      );

      setState(() {
        _chapterList = chapters;
        _isLoadingChapters = false;
      });
    } catch (e) {
      print('❌ [商品详情页] 加载章节列表失败: $e');
      setState(() {
        _chapterError = e.toString();
        _isLoadingChapters = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(goodsDetailNotifierProvider);

    // ✅ 监听登录状态变化，登录成功后刷新商品详情
    ref.listen<AuthState>(authProvider, (previous, next) {
      // 如果从未登录变为已登录，刷新商品详情
      if (previous?.isLoggedIn == false && next.isLoggedIn) {
        print('🔄 [商品详情页] 检测到登录状态变化，刷新商品详情');
        final goodsId = widget.goodsId ?? widget.productId;
        if (goodsId != null && goodsId.isNotEmpty) {
          ref.read(goodsDetailNotifierProvider.notifier).refresh(goodsId);
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('商品详情'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: state.isLoading
          ? _buildLoading()
          : state.error != null
          ? _buildError(state.error!)
          : state.goodsDetail != null
          ? _buildContent(state.goodsDetail!)
          : _buildEmpty(),
      bottomNavigationBar: state.goodsDetail != null
          ? _buildBottomBar(state.goodsDetail!, state.selectedPriceIndex)
          : null,
    );
  }

  /// 构建加载中状态
  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: AppSpacing.mdV),
          Text('加载中...', style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  /// 构建错误状态
  Widget _buildError(String error) {
    return CommonStateWidget.loadError(
      message: error,
      onRetry: () {
        final goodsId = widget.goodsId ?? widget.productId;
        if (goodsId != null) {
          ref.read(goodsDetailNotifierProvider.notifier).refresh(goodsId);
        }
      },
    );
  }

  /// 构建空状态
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64.sp, color: AppColors.textHint),
          SizedBox(height: AppSpacing.mdV),
          Text(
            '暂无数据',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  /// 构建内容
  Widget _buildContent(GoodsDetailModel detail) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 顶部商品信息区
          _buildGoodsInfo(detail),
          // 2. 中间内容区（根据type显示不同内容）
          _buildContentArea(detail),
          // 底部占位（避免被底部栏遮挡）
          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  /// 1. 构建商品信息区
  /// 对应小程序: detail.vue Line 4-71
  Widget _buildGoodsInfo(GoodsDetailModel detail) {
    final state = ref.watch(goodsDetailNotifierProvider);
    final tokens = ref.watch(appStyleTokensProvider);

    return Container(
      width: double.infinity,
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 封面图片
          _buildCoverImage(detail, tokens),

          // 秒杀信息区（如果未购买）
          if (detail.permissionStatus == '2')
            _buildSeckillArea(detail, state.selectedPriceIndex, tokens),

          // 商品信息区
          _buildInfoBox(detail, state.selectedPriceIndex, tokens),
        ],
      ),
    );
  }

  /// 封面图片
  /// 对应小程序: .swiper-image (Line 8)
  /// ⚠️ 注意：封面路径已在 provider 中处理（路径互换、默认图片）
  Widget _buildCoverImage(GoodsDetailModel detail, AppStyleTokens tokens) {
    final coverPath = detail.materialCoverPath ?? '';
    final cardBg = tokens.colors.cardLightBg;
    final useLocalAsset = coverPath.startsWith('assets/');

    print('🖼️ [商品详情页] 封面图片: $coverPath');

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: useLocalAsset
          ? Image.asset(
              coverPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: cardBg,
                  child: Icon(Icons.image, size: 50.sp, color: AppColors.textHint),
                );
              },
            )
          : Image.network(
              coverPath,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: cardBg,
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: cardBg,
                  child: Image.asset(
                    'assets/images/app_icon.png',
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
    );
  }

  /// 秒杀信息区
  /// 对应小程序: detail.vue Line 10-44, CSS Line 675-770
  Widget _buildSeckillArea(
      GoodsDetailModel detail, int selectedIndex, AppStyleTokens tokens) {
    if (detail.prices.isEmpty) return const SizedBox.shrink();

    final selectedPrice = detail.prices[selectedIndex];
    final salePrice = double.tryParse(selectedPrice.salePrice ?? '0') ?? 0;
    final originalPrice =
        double.tryParse(selectedPrice.originalPrice ?? '0') ?? 0;
    final discountPrice = originalPrice - salePrice;

    // ✅ 倒计时：8小时（28800秒）
    const countdownSeconds = 8 * 60 * 60;

    return Container(
      // ✅ 对应小程序 .seckill-box, CSS Line 675-679
      // ⚠️ padding: 0 10px 10px 10px - px 单位，不需要除以 2
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      // ✅ background-color: red
      color: Colors.red,
      // ✅ position: relative, overflow: hidden
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ✅ 装饰圆 .tl (对应小程序 CSS Line 680-694)
          // ⚠️ width: 87px, height: 77px, left: -10px, top: -10px - px 单位
          Positioned(
            left: -10, // left: -10px (px 单位)
            top: -10, // top: -10px (px 单位)
            child: Container(
              width: 87, // width: 87px (px 单位)
              height: 77, // height: 77px (px 单位)
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFF5D00), // #ff5d00
                    const Color(0xFFFF5D00).withOpacity(0), // rgba(#ff5d00, 0)
                  ],
                ),
              ),
            ),
          ),
          // ✅ 装饰圆 .tr (对应小程序 CSS Line 695-707)
          // ⚠️ width: 87px, height: 77px, right: -20px, top: -30px - px 单位
          Positioned(
            right: -20, // right: -20px (px 单位)
            top: -30, // top: -30px (px 单位)
            child: Container(
              width: 87, // width: 87px (px 单位)
              height: 77, // height: 77px (px 单位)
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFF5D00), // #ff5d00
                    const Color(0xFFFF5D00).withOpacity(0), // rgba(#ff5d00, 0)
                  ],
                ),
              ),
            ),
          ),
          // ✅ 内容层（z-index: 1）
          Column(
            children: [
              // ✅ .t 部分 (对应小程序 CSS Line 745-769)
              // ⚠️ height: 49px - px 单位，不需要除以 2
              Container(
                height: 49, // height: 49px (px 单位)
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ), // padding: 0 10px (px 单位)
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ✅ .l "题库秒杀" (对应小程序 CSS Line 752-760)
                    // ⚠️ width: 37px, height: 39px, font-size: 14px, border-radius: 5px - px 单位
                    Container(
                      width: 37, // width: 37px (px 单位)
                      height: 39, // height: 39px (px 单位)
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFFDF001A,
                        ), // background-color: #df001a
                        borderRadius: BorderRadius.circular(
                          5,
                        ), // border-radius: 5px (px 单位)
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '题库秒杀',
                        style: const TextStyle(
                          fontSize: 14, // font-size: 14px (px 单位)
                          color: Colors.white, // color: #ffffff
                        ),
                      ),
                    ),
                    // ✅ .r 倒计时部分 (对应小程序 CSS Line 761-768)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '限时秒杀',
                          style: const TextStyle(
                            fontSize: 12, // font-size: 12px (px 单位)
                            color: Color(0xFFFED7C5), // color: #fed7c5
                          ),
                        ),
                        const SizedBox(height: 2), // margin-bottom: 2px (px 单位)
                        // ✅ 秒杀倒计时（对应小程序 count-down2.vue）
                        // ⚠️ 注意：秒杀区域的倒计时样式与首页不同
                        // 背景：白色 #ffffff，文字：深色 #1f232e，分隔符：白色 #ffffff
                        _buildSeckillCountdown(
                            countdownSeconds, tokens.colors.countdownTextColor),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 0), // 无间距（小程序中 .t 和 .price-text 紧贴）
              // ✅ .price-text 部分 (对应小程序 CSS Line 708-744)
              // ⚠️ padding: 8px 44px 8px 56px - px 单位，不需要除以 2
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  56, // padding-left: 56px (px 单位)
                  8, // padding-top: 8px (px 单位)
                  44, // padding-right: 44px (px 单位)
                  8, // padding-bottom: 8px (px 单位)
                ),
                decoration: BoxDecoration(
                  color: Colors.white, // background-color: #ffffff
                  borderRadius: BorderRadius.circular(
                    5,
                  ), // border-radius: 5px (px 单位)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ✅ 秒杀价
                    _buildSeckillPriceItem('秒杀价', salePrice),
                    // ✅ =
                    Text(
                      '=',
                      style: TextStyle(fontSize: 14.sp, color: Colors.black),
                    ),
                    // ✅ 原价
                    _buildSeckillPriceItem('原价', originalPrice),
                    // ✅ -
                    Text(
                      '-',
                      style: TextStyle(fontSize: 14.sp, color: Colors.black),
                    ),
                    // ✅ 限时优惠
                    _buildSeckillPriceItem('限时优惠', discountPrice),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 秒杀倒计时（对应小程序 count-down2.vue）
  /// ⚠️ 注意：秒杀区域的倒计时样式与首页不同
  /// 背景：白色 #ffffff，文字：countdownTextColor，分隔符：白色 #ffffff
  Widget _buildSeckillCountdown(int durationSeconds, Color countdownTextColor) {
    return _SeckillCountdownTimer(
      durationSeconds: durationSeconds,
      countdownTextColor: countdownTextColor,
      onFinish: () {
        // 倒计时结束，重新开始
      },
    );
  }

  /// 秒杀价格项 (对应小程序 .price-text .ee, CSS Line 722-743)
  Widget _buildSeckillPriceItem(String label, double price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ✅ label (对应小程序 view:nth-child(1), CSS Line 726-729)
        // ⚠️ font-size: 12px - px 单位，不需要除以 2
        Text(
          label,
          style: const TextStyle(
            fontSize: 12, // font-size: 12px (px 单位)
            color: Colors.red, // color: red
          ),
        ),
        const SizedBox(height: 0), // 无间距（小程序中 label 和 price 紧贴）
        // ✅ price (对应小程序 view:nth-child(2), CSS Line 730-742)
        // ⚠️ font-size: 24rpx, 34rpx - rpx 单位，需要除以 2
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '￥',
              style: TextStyle(
                fontWeight: FontWeight.w400, // font-weight: 400
                fontSize: 12.sp, // font-size: 24rpx ÷ 2 = 12.sp
                color: const Color(0xFFFF5430), // color: #ff5430
              ),
            ),
            Text(
              price.toStringAsFixed(2),
              style: TextStyle(
                fontWeight: FontWeight.w500, // font-weight: 500
                fontSize: 17.sp, // font-size: 34rpx ÷ 2 = 17.sp
                color: const Color(0xFFFF5430), // color: #ff5430
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 获取显示标题（对应小程序 detail.vue Line 47 和 secretRealDetail.vue Line 509）
  /// type == 8 时，根据 details_type 显示不同标题：
  /// - details_type == 2 → 计算 examTitle = year + 专业名称最后一部分（对应小程序 secretRealDetail.vue Line 506-509）
  /// - 其他情况 → 优先显示 exam_title（如果存在），否则显示 name
  String _getDisplayTitle(GoodsDetailModel detail) {
    final typeInt = int.tryParse(detail.type?.toString() ?? '') ?? 0;

    // ✅ type == 8（试卷）时，根据 details_type 显示标题
    if (typeInt == 8) {
      final detailsTypeInt =
          int.tryParse(detail.detailsType?.toString() ?? '') ?? 0;

      // ✅ details_type == 2 → 计算 examTitle（对应小程序 secretRealDetail.vue Line 506-509）
      if (detailsTypeInt == 2) {
        // ✅ 小程序逻辑：examTitle = year + 专业名称最后一部分
        final professionalIdName = detail.professionalIdName ?? '';
        if (professionalIdName.isNotEmpty) {
          final professionalIdNames = professionalIdName.split('-');
          final titleName = professionalIdNames.isNotEmpty
              ? professionalIdNames[professionalIdNames.length - 1]
              : '';
          final year = detail.year ?? '';
          // ✅ 组合：year + titleName（例如："2026" + "口腔执业医师" = "2026口腔执业医师"）
          // 但用户说显示的是"历年真题"，可能是 API 返回的 exam_title 就是"历年真题"
          // 或者需要特殊处理
          if (year.isNotEmpty && titleName.isNotEmpty) {
            return '$year$titleName';
          }
        }
        // ✅ 如果计算失败，优先使用 API 返回的 exam_title
        if (detail.examTitle != null && detail.examTitle!.isNotEmpty) {
          return detail.examTitle!;
        }
        // ✅ 如果 exam_title 也没有，返回"历年真题"作为默认值
        return '历年真题';
      }

      // ✅ 其他情况，优先显示 exam_title（如果存在）
      if (detail.examTitle != null && detail.examTitle!.isNotEmpty) {
        return detail.examTitle!;
      }
    }

    // ✅ 其他情况或 exam_title 为空时，显示 name
    return detail.name ?? '';
  }

  /// 商品信息框
  /// 对应小程序: detail.vue Line 45-70
  Widget _buildInfoBox(
      GoodsDetailModel detail, int selectedIndex, AppStyleTokens tokens) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.allMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 商品名称（type == 8 时优先显示 exam_title）
          Text(_getDisplayTitle(detail), style: AppTextStyles.heading3),
          SizedBox(height: AppSpacing.smV),
          // 标签（题目数量、年份等）
          Wrap(
            spacing: 12.w,
            runSpacing: 8.h,
            children: [
              if (detail.numText.isNotEmpty)
                _buildTag(detail.numText, tokens.colors.tagBg, tokens.colors.tagText),
              if (detail.year != null && detail.year!.isNotEmpty)
                _buildTag(detail.year!, tokens.colors.tagBg, tokens.colors.tagText),
            ],
          ),
          // 提示信息
          if (detail.tipsText.isNotEmpty) ...[
            SizedBox(height: AppSpacing.smV),
            Text(
              detail.tipsText,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          SizedBox(height: AppSpacing.mdV),
          Divider(height: 1, color: AppColors.divider),
          SizedBox(height: AppSpacing.mdV),
          // 有效期选择
          _buildPriceOptions(detail, selectedIndex, tokens),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color tagBg, Color tagText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: tagBg,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        text,
        style: AppTextStyles.courseTag.copyWith(color: tagText),
      ),
    );
  }

  /// 有效期选择
  /// 对应小程序: test/detail.vue .prices / .ee / .ee.active
  /// 未选: 背景 #f5f6fa, 字 rgba(3,32,61,0.85); 选中: 背景 primary, 字 #ffffff
  /// 尺寸: 宽 222rpx, 高 64rpx, 圆角 8rpx, 字号 24rpx; 文案「有效期 永久」/「有效期 X个月」
  Widget _buildPriceOptions(
      GoodsDetailModel detail, int selectedIndex, AppStyleTokens tokens) {
    if (detail.prices.isEmpty) return const SizedBox.shrink();

    final selectedBg = tokens.colors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '选择有效期',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 9.w,
          runSpacing: 12.h,
          children: detail.prices.asMap().entries.map((entry) {
            final index = entry.key;
            final price = entry.value;
            final isSelected = index == selectedIndex;

            return GestureDetector(
              onTap: () {
                ref
                    .read(goodsDetailNotifierProvider.notifier)
                    .selectPrice(index);
              },
              child: Container(
                width: 111.w,
                height: 32.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? selectedBg
                      : const Color(0xFFF5F6FA),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  '有效期 ${price.validityText}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: isSelected
                        ? const Color(0xFFFFFFFF)
                        : const Color(0xFF03203D).withOpacity(0.85),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 2. 构建内容区（根据type显示不同内容）
  /// 对应小程序: detail.vue Line 72-91
  Widget _buildContentArea(GoodsDetailModel detail) {
    final typeInt = SafeTypeConverter.toInt(detail.type);

    if (typeInt == 18) {
      // 章节练习 - 显示章节列表
      return _buildChapterArea(detail);
    } else {
      // 试卷/模考 - 显示商品介绍长图
      return _buildIntroImage(detail);
    }
  }

  /// 章节信息区
  /// 对应小程序: detail.vue Line 72-85
  Widget _buildChapterArea(GoodsDetailModel detail) {
    final questionNum = detail.tikuGoodsDetails?.questionNum?.toString() ?? '0';

    // ✅ 如果章节列表为空且未加载过，则加载章节数据
    if (_chapterList.isEmpty && !_isLoadingChapters && _chapterError == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadChapterList(detail);
      });
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: AppSpacing.mdV, bottom: AppSpacing.mdV),
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ✅ 课节头部（与小程序 .header 一致）：一层容器 + 背景图 + 星星与文案
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/chapter_header_bg.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Row(
              children: [
                Image.network(
                  'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/604d173977513550467950_xingixng.png',
                  width: 14.w,
                  height: 14.w,
                  errorBuilder: (_, __, ___) =>
                      Icon(Icons.star, size: 14.w, color: Colors.white),
                ),
                SizedBox(width: 6.w),
                Text(
                  '本题库共有 $questionNum 道题',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // ✅ 章节列表内容（与小程序 .chapter-list 一致）：白底、无圆角、上边挨着背景图、左右无边距
          Container(
            width: double.infinity,
            padding: AppSpacing.allMd,
            decoration: const BoxDecoration(
              color: AppColors.surface,
            ),
            child: _isLoadingChapters
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _chapterError != null
                ? Center(
                    child: Column(
                      children: [
                        Text(
                          '加载失败',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextButton(
                          onPressed: () => _loadChapterList(detail),
                          child: const Text('重试'),
                        ),
                      ],
                    ),
                  )
                : _chapterList.isEmpty
                ? Center(
                    child: Text(
                      '暂无章节数据',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : _buildChapterTree(_chapterList),
          ),
        ],
      ),
    );
  }

  /// 构建章节树（递归显示）
  /// 对应小程序: treeChapter 组件
  Widget _buildChapterTree(
    List<Map<String, dynamic>> chapters, {
    int level = 1,
  }) {
    return Column(
      children: chapters.map((chapter) {
        return _buildChapterItem(chapter, level: level);
      }).toList(),
    );
  }

  /// 构建章节项
  /// 对应小程序: tree-item.vue
  Widget _buildChapterItem(Map<String, dynamic> chapter, {int level = 1}) {
    final chapterId = chapter['id']?.toString() ?? '';
    final isExpanded = _expandedChapters.contains(chapterId);
    final children = chapter['child'] as List?;
    final hasChildren = children != null && children.isNotEmpty;
    final sectionType = chapter['section_type']?.toString();
    final questionNum = chapter['question_number']?.toString() ?? '0';
    final doQuestionNum = chapter['do_question_num']?.toString() ?? '0';

    // ✅ section_type == '2' 表示知识点（叶子节点），只显示名称和题数
    if (sectionType == '2' || !hasChildren) {
      return Container(
        padding: EdgeInsets.fromLTRB(16.w + (level - 1) * 20.w, 8.h, 16.w, 8.h),
        child: Row(
          children: [
            Container(
              width: 5.w,
              height: 5.w,
              margin: EdgeInsets.only(right: 15.w),
              decoration: BoxDecoration(
                color: const Color(0xFF387DFC),
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Text(
                chapter['sectionname']?.toString() ??
                    chapter['name']?.toString() ??
                    '未命名',
                style: AppTextStyles.bodySmall.copyWith(fontSize: 13.sp),
              ),
            ),
            Text(
              '$questionNum题',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      );
    }

    // ✅ 有子节点的章节，可展开/收起
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              if (isExpanded) {
                _expandedChapters.remove(chapterId);
              } else {
                _expandedChapters.add(chapterId);
              }
            });
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(
              16.w + (level - 1) * 20.w,
              12.h,
              16.w,
              12.h,
            ),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                // 与小程序 tree-head .left-image 一致：select.png，展开时旋转 180deg
                Transform.rotate(
                  angle: isExpanded ? math.pi : 0,
                  child: Image.network(
                    'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/16950043427848e3c169500434278459705_select.png',
                    width: 16.w,
                    height: 16.w,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 16.w,
                      color: AppColors.textHint,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    chapter['sectionname']?.toString() ??
                        chapter['name']?.toString() ??
                        '未命名',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: level == 1 ? 14.sp : 13.sp,
                    ),
                  ),
                ),
                // 与小程序 tree-head .num-group 一致：x/xx 题
                Text(
                  '$doQuestionNum/$questionNum',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded && hasChildren)
          _buildChapterTree(
            children.cast<Map<String, dynamic>>(),
            level: level + 1,
          ),
      ],
    );
  }

  /// 商品介绍长图
  /// 对应小程序: detail.vue Line 86-91
  /// ⚠️ 注意：介绍路径已在 provider 中处理（路径互换）
  Widget _buildIntroImage(GoodsDetailModel detail) {
    final introPath = detail.materialIntroPath ?? '';

    // ✅ 调试日志：打印完整URL（对比小程序）
    print('🖼️ [商品详情页] 介绍图片URL: $introPath');

    if (introPath.isEmpty) {
      print('🖼️ [商品详情页] 介绍图片路径为空，不显示');
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      color: AppColors.surface,
      // ✅ 使用 Image.network 避免 iOS Release 模式 Content-Disposition 问题
      child: Image.network(
        introPath,
        fit: BoxFit.fitWidth,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 200.h,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('❌ [商品详情页] 介绍图片加载失败: $introPath, error: $error');
          return Container(
            padding: AppSpacing.allXl,
            child: Center(
              child: Text(
                '商品介绍加载失败',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 3. 构建底部操作栏
  /// 对应小程序: detail.vue Line 93-110；无 prices 时与 Line 434-445 一致注入 0 元价，仍显示底部栏并支持购买
  Widget _buildBottomBar(GoodsDetailModel detail, int selectedIndex) {
    final GoodsPriceModel selectedPrice = _getEffectiveSelectedPrice(detail, selectedIndex);
    final permissionStatus = SafeTypeConverter.toSafeString(
      detail.permissionStatus,
    );
    final isNotPurchased = permissionStatus == '2';
    final tokens = ref.watch(appStyleTokensProvider);

    // 🔍 调试日志：打印购买状态
    print('\n🔍 底部栏渲染状态：');
    print('   permission_status: $permissionStatus (1=已购买, 2=未购买)');
    print('   isNotPurchased: $isNotPurchased');
    print('   商品类型: ${detail.type}');
    print('   按钮文字: ${isNotPurchased ? "立即购买" : _getActionButtonText(detail)}');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadowLight,
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (isNotPurchased) ...[
              // 未购买 - 显示价格和购买按钮
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '¥',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: tokens.colors.actionPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          selectedPrice.salePrice ?? '0.00',
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: tokens.colors.actionPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.md),
              // ✅ 购买按钮 (对应小程序 .but, CSS Line 938-949)
              SizedBox(
                width: 238.w, // width: 476rpx = 238.w
                height: 40.h, // height: 80rpx = 40.h
                child: ElevatedButton(
                  onPressed: () => _handlePurchase(detail, selectedPrice),
                  style: ElevatedButton.styleFrom(
                    // ✅ background: linear-gradient(163deg, #ff8928 0%, #ff5430 100%)
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    // ✅ border-radius: 40rpx = 20.r
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    // ✅ box-shadow: 0px 2px 6px 0px rgba(255, 89, 50, 0.45)
                    elevation: 0,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        // ✅ 163deg 对应角度计算
                        colors: [
                          tokens.colors.actionGradientStart,
                          tokens.colors.actionGradientEnd,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: tokens.colors.actionShadowColor
                              .withValues(alpha: 0.45),
                          offset: const Offset(0, 2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '立即购买',
                      style: TextStyle(
                        fontSize: 14.sp, // font-size: 28rpx = 14.sp
                        fontWeight: FontWeight.w500, // font-weight: 500
                        color: Colors.white, // color: #ffffff
                      ),
                    ),
                  ),
                ),
              ),
            ] else ...[
              // 已购买 - 显示"立即刷题"或"立即测试"按钮
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _handleStartPractice(detail),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tokens.colors.actionPrimary,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                  ),
                  child: Text(
                    _getActionButtonText(detail),
                    style: AppTextStyles.buttonLarge,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 获取操作按钮文字
  String _getActionButtonText(GoodsDetailModel detail) {
    final typeInt = SafeTypeConverter.toInt(detail.type);
    if (typeInt == 18) {
      return '立即刷题'; // 章节练习
    } else {
      return '立即测试'; // 试卷/模考
    }
  }

  /// 当前选中的价格，对应小程序 detail.vue：无 prices 时注入 { goods_months_price_id: '', month: '0', sale_price: '0.00' }（Line 434-445）
  GoodsPriceModel _getEffectiveSelectedPrice(GoodsDetailModel detail, int selectedIndex) {
    if (detail.prices.isNotEmpty && selectedIndex < detail.prices.length) {
      return detail.prices[selectedIndex];
    }
    final topSale = SafeTypeConverter.toSafeString(detail.salePrice, defaultValue: '0.00');
    return GoodsPriceModel(
      goodsMonthsPriceId: '',
      month: '0',
      salePrice: topSale,
      originalPrice: SafeTypeConverter.toSafeString(detail.originalPrice, defaultValue: '0.00'),
      days: '0',
    );
  }

  /// 处理购买 - 调用统一支付模块
  /// 对应小程序: detail.vue Line 509-583
  /// 未登录时直接跳转登录页（不提示、不跳转确认购买页），已登录时直接下单
  Future<void> _handlePurchase(
    GoodsDetailModel detail,
    GoodsPriceModel selectedPrice,
  ) async {
    if (!ref.read(authProvider).isLoggedIn) {
      _navigateToLogin();
      return;
    }

    // ✅ 防止重复点击（对应小程序 Line 510-518）
    if (_isPurchasing) {
      EasyLoading.showInfo('请勿重复点击');
      return;
    }

    final goodsId = SafeTypeConverter.toSafeString(
      detail.goodsId,
      defaultValue: '',
    );
    if (goodsId.isEmpty) {
      EasyLoading.showError('商品ID不能为空');
      return;
    }

    // ✅ 对应小程序 Line 534-536：价格套餐参数
    final goodsMonthsPriceId = SafeTypeConverter.toSafeString(
      selectedPrice.goodsMonthsPriceId,
      defaultValue: '',
    );
    final months = SafeTypeConverter.toInt(selectedPrice.month);
    final salePriceStr = SafeTypeConverter.toSafeString(
      selectedPrice.salePrice,
      defaultValue: '0',
    );
    final salePrice = double.tryParse(salePriceStr) ?? 0.0;

    try {
      // 设置锁定状态
      setState(() => _isPurchasing = true);

      EasyLoading.show(status: '正在处理订单...');

      // 🎯 调用统一支付入口
      final paymentNotifier = ref.read(paymentProvider.notifier);
      final result = await paymentNotifier.startPayment(
        goodsId: goodsId,
        goodsMonthsPriceId: goodsMonthsPriceId,
        months: months,
        payableAmount: salePrice,
      );

      EasyLoading.dismiss();

      if (!mounted) return;

      // 处理支付结果
      if (result.isFreeOrder) {
        // ✅ 0元课成功（对应小程序 Line 574-580）
        // 1. 刷新商品详情（获取最新购买状态）
        final refreshGoodsId = widget.goodsId ?? widget.productId;
        if (refreshGoodsId != null) {
          await ref
              .read(goodsDetailNotifierProvider.notifier)
              .refresh(refreshGoodsId);
        }

        // 2. 跳转支付成功页
        final professionalIdName = SafeTypeConverter.toSafeString(
          detail.professionalIdName,
          defaultValue: '',
        );
        final goodsType = SafeTypeConverter.toSafeString(
          detail.type,
          defaultValue: '',
        );
        context.push(
          AppRoutes.paySuccess,
          extra: {
            'goods_id': goodsId,
            'professional_id_name': professionalIdName,
            'goods_type': goodsType, // ✅ 传递商品类型，避免支付成功页再次调用API
          },
        );
      } else if (!result.isFreeOrder && result.isSuccess) {
        // ✅ 非0元课：跳转确认支付页（对应小程序 Line 569-573）
        final professionalIdName = SafeTypeConverter.toSafeString(
          detail.professionalIdName,
          defaultValue: '',
        );

        // ✅ 获取商品类型
        final goodsType = SafeTypeConverter.toSafeString(
          detail.type,
          defaultValue: '',
        );

        // 🔄 使用 await 等待支付结果（方案2：路由返回值）
        final paymentResult = await context.push<Map<String, dynamic>>(
          AppRoutes.confirmPayment,
          extra: {
            'order_id': result.orderId!,
            'flow_id': result.flowId!,
            'goods_id': result.goodsId!,
            'finance_body_id': result.financeBodyId ?? '', // ✅ 财务主体ID
            'goods_name': detail.name ?? '商品',
            'payable_amount': result.payableAmount!,
            'refresh_goods_id': goodsId, // 传递当前商品ID，用于刷新
            'professional_id_name': professionalIdName,
            'goods_type': goodsType, // ✅ 传递商品类型，避免支付成功页再次调用API
          },
        );

        // 🔄 支付成功：先刷新详情，再跳转支付成功页（与小程序一致：getGoodsDetail 后 push paySuccess）
        if (paymentResult != null && paymentResult['success'] == true) {
          print('\n🔄 支付成功，刷新商品详情并跳转支付成功页...');
          final refreshGoodsId =
              paymentResult['refresh_goods_id'] as String? ?? goodsId;
          await ref
              .read(goodsDetailNotifierProvider.notifier)
              .refresh(refreshGoodsId);
          if (!mounted) return;
          context.push(
            AppRoutes.paySuccess,
            extra: {
              'goods_id': goodsId,
              'professional_id_name': professionalIdName,
              'goods_type': goodsType,
              'isLearnButton': 0,
            },
          );
        }
      } else {
        // ❌ 下订单失败
        EasyLoading.showError(result.errorMessage ?? '订单创建失败');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('订单异常: $e');
    } finally {
      // ✅ 3秒后解锁（对应小程序 Line 511-514）
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _isPurchasing = false);
        }
      });
    }
  }

  /// 处理开始练习
  /// 对应小程序: detail.vue Line 339-366
  void _handleStartPractice(GoodsDetailModel detail) {
    print('\n📚 点击了「立即测试」按钮');

    // ✅ 检查登录状态（根据 Guideline 5.1.1，学习需要登录）；未登录直接跳转登录页，不弹窗
    if (!ref.read(authProvider).isLoggedIn) {
      _navigateToLogin();
      return;
    }

    // ✅ 检查购买状态（对应小程序 Line 344）
    final permissionStatus = SafeTypeConverter.toSafeString(
      detail.permissionStatus,
    );
    print('   权限状态: $permissionStatus (1=已购买, 2=未购买)');

    if (permissionStatus != '1') {
      print('   ❌ 未购买，无法跳转');
      EasyLoading.showInfo('请先购买课程');
      return;
    }

    final major = ref.read(currentMajorProvider);
    final goodsId = detail.goodsId?.toString();
    final professionalId = major?.majorId.toString();
    final typeInt = SafeTypeConverter.toInt(detail.type);

    print('   商品ID: $goodsId');
    print('   专业ID: $professionalId');
    print('   类型: $typeInt (18=章节练习, 8=试卷, 10=模考)');

    // type == 18: 章节练习（对应小程序 Line 345-351）
    if (typeInt == 18) {
      final url =
          '/chapterList?professional_id=$professionalId&goods_id=$goodsId&total=${detail.tikuGoodsDetails?.questionNum}';
      print('   ✅ 跳转到章节练习: $url');

      context.push(
        AppRoutes.chapterList,
        extra: {
          'goods_id': goodsId,
          'professional_id': professionalId,
          'total': detail.tikuGoodsDetails?.questionNum,
        },
      );
      return;
    }

    // type == 10: 模考（对应小程序 Line 353-360）
    if (typeInt == 10) {
      final url =
          '/examInfo?product_id=$goodsId&title=${detail.name}&page=home';
      print('   ✅ 跳转到模考: $url');

      context.push(
        AppRoutes.examInfo,
        extra: {'product_id': goodsId, 'title': detail.name, 'page': 'home'},
      );
      return;
    }

    // type == 8: 试卷（对应小程序 Line 361-364）
    if (typeInt == 8) {
      final url = '/testExam?id=$goodsId';
      print('   ✅ 跳转到试卷: $url');

      context.push(
        AppRoutes.testExam,
        extra: {
          'id': goodsId,
          'recitation_question_model': detail.recitationQuestionModel,
        },
      );
      return;
    }

    // 未知类型
    print('   ❌ 未知商品类型: $typeInt');
    EasyLoading.showInfo('不支持的商品类型');
  }

  /// 未登录时直接跳转登录页（不弹窗、不跳转确认购买页）
  void _navigateToLogin() {
    final routerState = GoRouterState.of(context);
    final currentUri = routerState.uri;
    String returnPath = currentUri.path;
    if (currentUri.queryParameters.isNotEmpty) {
      final queryString = currentUri.queryParameters.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');
      returnPath = '$returnPath?$queryString';
    }
    if (currentUri.queryParameters.isEmpty) {
      final goodsId = widget.goodsId ?? widget.productId;
      if (goodsId != null) {
        returnPath =
            '${AppRoutes.goodsDetail}?goods_id=$goodsId&product_id=$goodsId';
        if (widget.active != null) {
          returnPath = '$returnPath&active=${widget.active}';
        }
        if (widget.professionalId != null) {
          returnPath =
              '$returnPath&professional_id=${widget.professionalId}';
        }
      }
    }
    context.push(AppRoutes.loginCenter, extra: {'returnPath': returnPath});
  }
}

/// 秒杀倒计时组件（对应小程序 count-down2.vue）
/// 样式：白色背景，主色/深色文字，白色分隔符
class _SeckillCountdownTimer extends StatefulWidget {
  final int durationSeconds;
  final Color countdownTextColor;
  final VoidCallback? onFinish;

  const _SeckillCountdownTimer({
    required this.durationSeconds,
    required this.countdownTextColor,
    this.onFinish,
  });

  @override
  State<_SeckillCountdownTimer> createState() => _SeckillCountdownTimerState();
}

class _SeckillCountdownTimerState extends State<_SeckillCountdownTimer> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationSeconds;
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        widget.onFinish?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 对应小程序 count-down2.vue 的显示格式
    final hours = _remainingSeconds ~/ 3600;
    final minutes = (_remainingSeconds % 3600) ~/ 60;
    final seconds = _remainingSeconds % 60;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ✅ 小时（对应小程序 .time__item, CSS Line 54-64）
        Container(
          width: 17.w, // width: 34rpx ÷ 2 = 17.w
          height: 17.h, // height: 34rpx ÷ 2 = 17.h
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white, // ✅ 小程序 background: #ffffff
            borderRadius: BorderRadius.circular(
              4.r,
            ), // border-radius: 8rpx ÷ 2 = 4.r
          ),
          child: Text(
            hours > 9 ? hours.toString() : '0$hours',
            style: TextStyle(
              fontSize: 12.sp, // font-size: 24rpx ÷ 2 = 12.sp
              fontWeight: FontWeight.w400, // font-weight: 400
              color: widget.countdownTextColor,
            ),
          ),
        ),
        // ✅ 分隔符（对应小程序 .b, CSS Line 65-71）
        Container(
          width: 10.w, // width: 20rpx ÷ 2 = 10.w
          alignment: Alignment.center,
          child: Text(
            ':',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white, // ✅ 小程序 color: #ffffff
            ),
          ),
        ),
        // ✅ 分钟
        Container(
          width: 17.w,
          height: 17.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            minutes > 9 ? minutes.toString() : '0$minutes',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: widget.countdownTextColor,
            ),
          ),
        ),
        // ✅ 分隔符
        Container(
          width: 10.w,
          alignment: Alignment.center,
          child: Text(
            ':',
            style: TextStyle(fontSize: 12.sp, color: Colors.white),
          ),
        ),
        // ✅ 秒
        Container(
          width: 17.w,
          height: 17.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            seconds > 9 ? seconds.toString() : '0$seconds',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: widget.countdownTextColor,
            ),
          ),
        ),
      ],
    );
  }
}
