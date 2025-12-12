import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/utils/safe_type_converter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../auth/providers/auth_provider.dart';
import '../../order/providers/payment_provider.dart';
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
    return Center(
      child: Padding(
        padding: AppSpacing.allXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: AppColors.error),
            SizedBox(height: AppSpacing.mdV),
            Text(
              error,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            SizedBox(height: AppSpacing.lgV),
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
              label: Text('重试', style: AppTextStyles.buttonMedium),
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
          Icon(Icons.inbox_outlined, size: 64.sp, color: AppColors.textHint),
          SizedBox(height: AppSpacing.mdV),
          Text('暂无数据', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint)),
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
      color: AppColors.surface,
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
  /// 对应小程序: .swiper-image (Line 8)
  /// ⚠️ 注意：封面路径已在 provider 中处理（路径互换、默认图片）
  Widget _buildCoverImage(GoodsDetailModel detail) {
    final coverPath = detail.materialCoverPath ?? '';
    
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: CachedNetworkImage(
        imageUrl: coverPath,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppColors.card,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, error, stackTrace) {
          return Container(
            color: AppColors.card,
            child: Icon(Icons.image, size: 50.sp, color: AppColors.textHint),
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
      padding: AppSpacing.allMd,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.error, AppColors.secondary],
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
                style: AppTextStyles.heading3.copyWith(color: AppColors.textWhite),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.maskLight,
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: Text(
                  '限时秒杀',
                  style: AppTextStyles.labelMedium.copyWith(color: AppColors.textWhite),
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
      padding: AppSpacing.allMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 商品名称
          Text(
            detail.name ?? '',
            style: AppTextStyles.heading3,
          ),
          SizedBox(height: AppSpacing.smV),
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
            SizedBox(height: AppSpacing.smV),
            Text(
              detail.tipsText,
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary),
            ),
          ],
          SizedBox(height: AppSpacing.mdV),
          Divider(height: 1, color: AppColors.divider),
          SizedBox(height: AppSpacing.mdV),
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
        color: AppColors.courseTagBg,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        text,
        style: AppTextStyles.courseTag,
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
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(height: AppSpacing.smV),
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
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  '有效期 ${price.validityText}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
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
      padding: AppSpacing.allMd,
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, size: 20.sp, color: AppColors.primary),
              SizedBox(width: AppSpacing.sm),
              Text(
                '本题库共有 $questionNum 道题',
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.mdV),
          Container(
            padding: AppSpacing.allMd,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              '章节列表功能开发中...',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  /// 商品介绍长图
  /// 对应小程序: detail.vue Line 86-91
  /// ⚠️ 注意：介绍路径已在 provider 中处理（路径互换）
  Widget _buildIntroImage(GoodsDetailModel detail) {
    final introPath = detail.materialIntroPath ?? '';
    
    if (introPath.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      color: AppColors.surface,
      child: CachedNetworkImage(
        imageUrl: introPath,
        fit: BoxFit.fitWidth,
        placeholder: (context, url) => Container(
          height: 200.h,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        ),
        errorWidget: (context, error, stackTrace) {
          return Container(
            padding: AppSpacing.allXl,
            child: Center(
              child: Text(
                '商品介绍加载失败',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
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
    final permissionStatus = SafeTypeConverter.toSafeString(detail.permissionStatus);
    final isNotPurchased = permissionStatus == '2';
    
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
                            color: AppColors.tikuPrice,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          selectedPrice.salePrice ?? '0.00',
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: AppColors.tikuPrice,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.md),
              ElevatedButton(
                onPressed: () => _handlePurchase(detail, selectedPrice),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 14.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                  ),
                ),
                child: Text(
                  '立即购买',
                  style: AppTextStyles.buttonLarge,
                ),
              ),
            ] else ...[
              // 已购买 - 显示"立即刷题"或"立即测试"按钮
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _handleStartPractice(detail),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
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

  /// 处理购买 - 调用统一支付模块
  /// 对应小程序: detail.vue Line 509-583
  Future<void> _handlePurchase(GoodsDetailModel detail, GoodsPriceModel selectedPrice) async {
    // ✅ 防止重复点击（对应小程序 Line 510-518）
    if (_isPurchasing) {
      EasyLoading.showInfo('请勿重复点击');
      return;
    }
    
    final goodsId = SafeTypeConverter.toSafeString(detail.goodsId, defaultValue: '');
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
          await ref.read(goodsDetailNotifierProvider.notifier).refresh(refreshGoodsId);
        }
        
        // 2. 跳转支付成功页
        final professionalIdName = SafeTypeConverter.toSafeString(
          detail.professionalIdName,
          defaultValue: '',
        );
        context.push(AppRoutes.paySuccess, extra: {
          'goods_id': goodsId,
          'professional_id_name': professionalIdName,
        });
      } else if (!result.isFreeOrder && result.isSuccess) {
        // ✅ 非0元课：跳转确认支付页（对应小程序 Line 569-573）
        final professionalIdName = SafeTypeConverter.toSafeString(
          detail.professionalIdName,
          defaultValue: '',
        );
        
        // 🔄 使用 await 等待支付结果（方案2：路由返回值）
        final paymentResult = await context.push<Map<String, dynamic>>(
          AppRoutes.confirmPayment,
          extra: {
            'order_id': result.orderId!,
            'flow_id': result.flowId!,
            'goods_id': result.goodsId!,
            'finance_body_id': result.financeBodyId ?? '',  // ✅ 财务主体ID
            'goods_name': detail.name ?? '商品',
            'payable_amount': result.payableAmount!,
            'refresh_goods_id': goodsId,  // 传递当前商品ID，用于刷新
            'professional_id_name': professionalIdName,
          },
        );
        
        // 🔄 支付成功回调：刷新商品详情（对应小程序 Line 639: this.getGoodsDetail()）
        if (paymentResult != null && paymentResult['success'] == true) {
          print('\n🔄 支付成功回调，刷新商品详情...');
          final refreshGoodsId = paymentResult['refresh_goods_id'] as String? ?? goodsId;
          await ref.read(goodsDetailNotifierProvider.notifier).refresh(refreshGoodsId);
          print('✅ 商品详情已刷新，按钮状态已更新为"去学习"');
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
    
    // ✅ 检查购买状态（对应小程序 Line 344）
    final permissionStatus = SafeTypeConverter.toSafeString(detail.permissionStatus);
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
      final url = '/chapterList?professional_id=$professionalId&goods_id=$goodsId&total=${detail.tikuGoodsDetails?.questionNum}';
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
      final url = '/examInfo?product_id=$goodsId&title=${detail.name}&page=home';
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
}
