import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/utils/safe_type_converter.dart';
import '../../auth/providers/auth_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(goodsDetailNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('商品详情'),
        backgroundColor: Colors.white,
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
          CircularProgressIndicator(),
          SizedBox(height: 16.h),
          Text('加载中...', style: TextStyle(fontSize: 14.sp)),
        ],
      ),
    );
  }

  /// 构建错误状态
  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(50.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.red.shade300),
            SizedBox(height: 16.h),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                final goodsId = widget.goodsId ?? widget.productId;
                if (goodsId != null) {
                  ref
                      .read(goodsDetailNotifierProvider.notifier)
                      .refresh(goodsId);
                }
              },
              icon: Icon(Icons.refresh, size: 18.sp),
              label: Text('重试', style: TextStyle(fontSize: 14.sp)),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64.sp, color: Colors.grey.shade300),
          SizedBox(height: 16.h),
          Text('暂无数据', style: TextStyle(fontSize: 14.sp)),
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

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 封面图片
          _buildCoverImage(detail),

          // 秒杀信息区（如果未购买）
          if (detail.permissionStatus == '2')
            _buildSeckillArea(detail, state.selectedPriceIndex),

          // 商品信息区
          _buildInfoBox(detail, state.selectedPriceIndex),
        ],
      ),
    );
  }

  /// 封面图片
  Widget _buildCoverImage(GoodsDetailModel detail) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: CachedNetworkImage(
        imageUrl: detail.materialCoverPath ?? '',
        fit: BoxFit.cover,
        errorWidget: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade200,
            child: Icon(Icons.image, size: 50.sp, color: Colors.grey.shade400),
          );
        },
      ),
    );
  }

  /// 秒杀信息区
  /// 对应小程序: detail.vue Line 10-44
  Widget _buildSeckillArea(GoodsDetailModel detail, int selectedIndex) {
    if (detail.prices.isEmpty) return const SizedBox.shrink();

    final selectedPrice = detail.prices[selectedIndex];
    final salePrice = double.tryParse(selectedPrice.salePrice ?? '0') ?? 0;
    final originalPrice =
        double.tryParse(selectedPrice.originalPrice ?? '0') ?? 0;
    final discountPrice = originalPrice - salePrice;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // 秒杀标题和倒计时
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '题库秒杀',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  '限时秒杀',
                  style: TextStyle(fontSize: 12.sp, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // 价格计算公式
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPriceItem('秒杀价', salePrice),
              Text(
                ' = ',
                style: TextStyle(fontSize: 16.sp, color: Colors.white),
              ),
              _buildPriceItem('原价', originalPrice),
              Text(
                ' - ',
                style: TextStyle(fontSize: 16.sp, color: Colors.white),
              ),
              _buildPriceItem('限时优惠', discountPrice),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceItem(String label, double price) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.white70),
        ),
        SizedBox(height: 4.h),
        Text(
          '¥${price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  /// 商品信息框
  /// 对应小程序: detail.vue Line 45-70
  Widget _buildInfoBox(GoodsDetailModel detail, int selectedIndex) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 商品名称
          Text(
            detail.name ?? '',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 12.h),
          // 标签（题目数量、年份等）
          Wrap(
            spacing: 12.w,
            runSpacing: 8.h,
            children: [
              if (detail.numText.isNotEmpty) _buildTag(detail.numText),
              if (detail.year != null && detail.year!.isNotEmpty)
                _buildTag(detail.year!),
            ],
          ),
          // 提示信息
          if (detail.tipsText.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              detail.tipsText,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
            ),
          ],
          SizedBox(height: 16.h),
          Divider(height: 1, color: Colors.grey.shade300),
          SizedBox(height: 16.h),
          // 有效期选择
          _buildPriceOptions(detail, selectedIndex),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12.sp, color: Color(0xFF2E68FF)),
      ),
    );
  }

  /// 有效期选择
  /// 对应小程序: detail.vue Line 58-69
  Widget _buildPriceOptions(GoodsDetailModel detail, int selectedIndex) {
    if (detail.prices.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '选择有效期',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 12.w,
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
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFF2E68FF) : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? Color(0xFF2E68FF)
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '有效期 ${price.validityText}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected
                        ? FontWeight.w500
                        : FontWeight.normal,
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

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      color: Color(0xFFF5F5F5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, size: 20.sp, color: Color(0xFF2E68FF)),
              SizedBox(width: 8.w),
              Text(
                '本题库共有 $questionNum 道题',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '章节列表功能开发中...',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  /// 商品介绍长图
  /// 对应小程序: detail.vue Line 86-91
  Widget _buildIntroImage(GoodsDetailModel detail) {
    if (detail.materialIntroPath == null || detail.materialIntroPath!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: CachedNetworkImage(
        imageUrl: detail.materialIntroPath!,
        fit: BoxFit.fitWidth,
        errorWidget: (context, error, stackTrace) {
          return Container(
            padding: EdgeInsets.all(50.h),
            child: Center(
              child: Text(
                '商品介绍加载失败',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 3. 构建底部操作栏
  /// 对应小程序: detail.vue Line 93-110
  Widget _buildBottomBar(GoodsDetailModel detail, int selectedIndex) {
    if (detail.prices.isEmpty) return const SizedBox.shrink();

    final selectedPrice = detail.prices[selectedIndex];
    final isNotPurchased = detail.permissionStatus == '2';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, -2),
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
                            color: Color(0xFFFF5E00),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          selectedPrice.salePrice ?? '0.00',
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: Color(0xFFFF5E00),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              ElevatedButton(
                onPressed: () => _handlePurchase(detail, selectedPrice),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2E68FF),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 14.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
                child: Text(
                  '立即购买',
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ] else ...[
              // 已购买 - 显示"立即刷题"或"立即测试"按钮
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _handleStartPractice(detail),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2E68FF),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: Text(
                    _getActionButtonText(detail),
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
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

  /// 处理购买
  /// 对应小程序: detail.vue Line 509-580
  void _handlePurchase(GoodsDetailModel detail, GoodsPriceModel selectedPrice) {
    // TODO: 实现购买流程
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('购买功能开发中...')));
  }

  /// 处理开始练习
  /// 对应小程序: detail.vue Line 339-366
  void _handleStartPractice(GoodsDetailModel detail) {
    final major = ref.read(currentMajorProvider);
    final goodsId = detail.goodsId?.toString();
    final professionalId = major?.majorId.toString();
    final typeInt = SafeTypeConverter.toInt(detail.type);

    // type == 18: 章节练习
    if (typeInt == 18) {
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

    // type == 10: 模考
    if (typeInt == 10) {
      context.push(
        AppRoutes.examInfo,
        extra: {'product_id': goodsId, 'title': detail.name, 'page': 'home'},
      );
      return;
    }

    // type == 8: 试卷
    if (typeInt == 8) {
      context.push(
        AppRoutes.testExam,
        extra: {
          'id': goodsId,
          'recitation_question_model': detail.recitationQuestionModel,
        },
      );
      return;
    }
  }
}
