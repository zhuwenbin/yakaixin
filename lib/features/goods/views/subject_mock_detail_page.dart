import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../providers/subject_mock_detail_provider.dart';
import '../models/goods_detail_model.dart';
import '../../order/providers/payment_provider.dart';
import '../../../core/utils/safe_type_converter.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/config/api_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';

/// P5-1-3 科目模考商品详情页
/// 对应小程序: modules/jintiku/pages/test/subjectMockDetail.vue
class SubjectMockDetailPage extends ConsumerStatefulWidget {
  final String? productId;
  final String? professionalId;

  const SubjectMockDetailPage({super.key, this.productId, this.professionalId});

  @override
  ConsumerState<SubjectMockDetailPage> createState() =>
      _SubjectMockDetailPageState();
}

class _SubjectMockDetailPageState extends ConsumerState<SubjectMockDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.productId != null && widget.productId!.isNotEmpty) {
        ref
            .read(subjectMockDetailNotifierProvider.notifier)
            .loadDetail(widget.productId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subjectMockDetailNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('科目模考'),
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
          ? _buildBottomBar(state.goodsDetail!)
          : null,
    );
  }

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

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: AppSpacing.allXl,
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: AppColors.error),
            SizedBox(height: AppSpacing.mdV),
            Text(error, textAlign: TextAlign.center, style: AppTextStyles.bodyMedium),
            SizedBox(height: AppSpacing.lgV),
            ElevatedButton(
              onPressed: () {
                if (widget.productId != null) {
                  ref
                      .read(subjectMockDetailNotifierProvider.notifier)
                      .refresh(widget.productId!);
                }
              },
              child: Text('重试', style: AppTextStyles.buttonMedium),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Text('暂无数据', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint)),
    );
  }

  Widget _buildContent(GoodsDetailModel detail) {
    // 科目模考显示长图介绍（对应小程序 Line 4-6）
    final longImagePath = detail.longImgPath;
    
    // ✅ 对照小程序 Line 444: this.longImagePath = this.completepath(res.data.long_img_path)
    // ✅ completepath 逻辑：如果不是 http 开头，则补全 OSS 域名
    String? completeImageUrl;
    if (longImagePath != null && longImagePath.isNotEmpty) {
      completeImageUrl = ApiConfig.completeImageUrl(longImagePath);
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          if (completeImageUrl != null && completeImageUrl.isNotEmpty)
            CachedNetworkImage(
              imageUrl: completeImageUrl,
              fit: BoxFit.fitWidth,
              placeholder: (context, url) => Container(
                height: 200.h,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, error, stackTrace) {
                return Container(
                  padding: AppSpacing.allXl,
                  child: Column(
                    children: [
                      Icon(Icons.image, size: 64.sp, color: AppColors.textHint),
                      SizedBox(height: AppSpacing.mdV),
                      Text(
                        '图片加载失败',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                      ),
                      SizedBox(height: AppSpacing.smV),
                      Text(
                        'URL: $completeImageUrl',
                        style: AppTextStyles.labelSmall.copyWith(color: AppColors.textHint),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            )
          else
            Container(
              padding: AppSpacing.allXl,
              child: Column(
                children: [
                  Icon(Icons.description, size: 64.sp, color: AppColors.textHint),
                  SizedBox(height: AppSpacing.mdV),
                  Text(
                    '暂无商品介绍',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                  ),
                ],
              ),
            ),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  Widget _buildBottomBar(GoodsDetailModel detail) {
    final isPurchased = detail.permissionStatus == '1';
    final activePriceIndex = ref.watch(
      subjectMockDetailNotifierProvider.select((s) => s.activePriceIndex),
    );
    final prices = detail.prices ?? [];
    final currentPrice = prices.isNotEmpty && activePriceIndex < prices.length
        ? prices[activePriceIndex]
        : null;
    final currentSalePrice = SafeTypeConverter.toSafeString(
      currentPrice?.salePrice,
      defaultValue: '0',
    );

    return Container(
      padding: AppSpacing.allMd,
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
            if (!isPurchased && currentPrice != null) ...[
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
                            color: AppColors.subjectMockPrice,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          currentSalePrice,
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: AppColors.subjectMockPrice,
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
                onPressed: () => _handlePurchase(context, ref, detail, currentPrice),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.subjectMockBuyButton, // ✅ 对应小程序 Line 640: background-color: #ff5402
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 14.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                  ),
                ),
                child: Text('立即购买', style: AppTextStyles.buttonLarge),
              ),
            ] else ...[
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _handleStartPractice(context, detail),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                  ),
                  child: Text('开始练习', style: AppTextStyles.buttonLarge),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 处理购买 - 使用统一支付入口
  /// ✅ 对应小程序 Line 451-526: getOrder() - 下单后跳转支付
  Future<void> _handlePurchase(
    BuildContext context,
    WidgetRef ref,
    GoodsDetailModel detail,
    dynamic currentPrice,
  ) async {
    if (currentPrice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('价格信息错误')),
      );
      return;
    }

    // 1. 准备参数
    final goodsId = SafeTypeConverter.toSafeString(detail.goodsId, defaultValue: '');
    if (goodsId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('商品ID不能为空')),
      );
      return;
    }

    final goodsMonthsPriceId = SafeTypeConverter.toSafeString(
      currentPrice.goodsMonthsPriceId,
      defaultValue: '',
    );
    final months = SafeTypeConverter.toInt(currentPrice.month);
    final salePriceStr = SafeTypeConverter.toSafeString(
      currentPrice.salePrice,
      defaultValue: '0',
    );
    final salePrice = double.tryParse(salePriceStr) ?? 0.0;

    if (goodsMonthsPriceId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('价格套餐错误')),
      );
      return;
    }

    // 2. 🎯 调用统一支付入口
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('正在处理订单...')),
      );
      
      final result = await ref.read(paymentProvider.notifier).startPayment(
        goodsId: goodsId,
        goodsMonthsPriceId: goodsMonthsPriceId,
        months: months,
        payableAmount: salePrice,
      );
      
      if (!context.mounted) return;
      
      // 3. 处理支付结果
      if (result.isFreeOrder) {
        // ✅ 0元课：跳转支付成功页
        context.push(AppRoutes.paySuccess, extra: {
          'goods_id': goodsId,
          'professional_id_name': detail.professionalIdName,
        });
      } else if (!result.isFreeOrder && result.isSuccess) {
        // ✅ 非0元课：跳转确认支付页，携带订单信息
        final professionalIdName = SafeTypeConverter.toSafeString(
          detail.professionalIdName,
          defaultValue: '',
        );
        
        // 🔄 使用路由返回值监听支付结果
        final paymentResult = await context.push<bool>(
          AppRoutes.confirmPayment,
          extra: {
            'order_id': result.orderId!,
            'flow_id': result.flowId!,
            'goods_id': result.goodsId!,
            'finance_body_id': result.financeBodyId ?? '',  // ✅ 财务主体ID
            'goods_name': detail.name ?? '科目模考',
            'payable_amount': result.payableAmount!,
            'refresh_goods_id': goodsId,
            'professional_id_name': professionalIdName,
          },
        );
        
        // 🔄 支付成功后刷新页面（TODO: 实现页面刷新逻辑）
        if (paymentResult == true && context.mounted) {
          print('\n🔄 支付成功，刷新科目模考详情页...');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('购买成功')),
          );
          // TODO: 调用页面刷新方法
        }
      } else {
        // ❌ 下订单失败：当前页提示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.errorMessage ?? '订单创建失败')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('订单异常: $e')),
        );
      }
    }
  }

  /// 处理开始练习
  void _handleStartPractice(BuildContext context, GoodsDetailModel detail) {
    // 科目模考类型 (type=8, details_type=3) 跳转到答题页面
    final type = SafeTypeConverter.toInt(detail.type);
    final goodsIdStr = SafeTypeConverter.toSafeString(detail.goodsId);
    
    if (type == 8) {
      // 科目模考答题页
      context.push(
        '/exam?id=$goodsIdStr&recitation_question_model=${detail.recitationQuestionModel ?? "1"}',
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('答题功能开发中...')),
      );
    }
  }
}
