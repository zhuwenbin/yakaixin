import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/payment/payment_flow_manager.dart';

/// 购买确认页（App Store 5.1.1 合规）
///
/// 在详情页提示登录并支持下订单购买，不在一进入详情就强制弹登录。
/// 本页展示商品信息、价格、登录说明与「去登录」「立即购买」入口。
class PurchaseConfirmPage extends ConsumerWidget {
  final String goodsId;
  final String goodsName;
  final String goodsMonthsPriceId;
  final String months;
  final double payableAmount;
  final String? professionalIdName;
  final String? refreshGoodsId;
  final String? goodsType;
  final int? isLearnButton;

  const PurchaseConfirmPage({
    super.key,
    required this.goodsId,
    required this.goodsName,
    required this.goodsMonthsPriceId,
    required this.months,
    required this.payableAmount,
    this.professionalIdName,
    this.refreshGoodsId,
    this.goodsType,
    this.isLearnButton,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        title: const Text('确认购买'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProductCard(),
            SizedBox(height: AppSpacing.lgV),
            _buildLoginHint(context, ref),
            SizedBox(height: AppSpacing.xlV),
            _buildPurchaseButton(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            goodsName,
            style: AppTextStyles.heading3,
          ),
          SizedBox(height: AppSpacing.smV),
          Text(
            '¥${payableAmount.toStringAsFixed(2)}',
            style: AppTextStyles.priceLarge.copyWith(
              color: const Color(0xFFFF5402),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginHint(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '登录后可在多设备使用，您可随时登录绑定账户。',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSpacing.smV),
          GestureDetector(
            onTap: () {
              final routerState = GoRouterState.of(context);
              final currentUri = routerState.uri;
              String returnPath = currentUri.path;
              if (currentUri.queryParameters.isNotEmpty) {
                final queryString = currentUri.queryParameters.entries
                    .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
                    .join('&');
                returnPath = '$returnPath?$queryString';
              }
              context.push(
                AppRoutes.loginCenter,
                extra: {'returnPath': returnPath},
              );
            },
            child: Text(
              '去登录',
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFF0185F4),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: () => _handlePurchase(context, ref),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF5402),
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.r),
          ),
          elevation: 0,
        ),
        child: const Text('立即购买'),
      ),
    );
  }

  Future<void> _handlePurchase(BuildContext context, WidgetRef ref) async {
    await context.startPayment(
      ref: ref,
      goodsId: goodsId,
      goodsMonthsPriceId: goodsMonthsPriceId,
      months: months,
      payableAmount: payableAmount,
      goodsName: goodsName,
      professionalIdName: professionalIdName,
      refreshGoodsId: refreshGoodsId ?? goodsId,
      goodsType: goodsType,
      isLearnButton: isLearnButton ?? 1,
      onSuccess: () {
        if (context.mounted) {
          context.pop();
        }
      },
      onError: (_) {},
    );
  }
}
