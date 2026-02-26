import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../providers/subject_mock_detail_provider.dart';
import '../models/goods_detail_model.dart';
import '../../../core/utils/safe_type_converter.dart';
import '../../../core/payment/payment_flow_manager.dart';
import '../../../core/widgets/common_state_widget.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/utils/toast_util.dart';
import '../../auth/providers/auth_provider.dart';
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
          ? CommonStateWidget.loadError(
              message: state.error!,
              onRetry: () {
                if (widget.productId != null) {
                  ref
                      .read(subjectMockDetailNotifierProvider.notifier)
                      .refresh(widget.productId!);
                }
              },
            )
          : state.goodsDetail != null
          ? _buildContent(state.goodsDetail!)
          : CommonStateWidget.empty(),
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
            // ✅ 使用 Image.network 避免 iOS Release 模式 Content-Disposition 问题
            Image.network(
              completeImageUrl,
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
                return Container(
                  padding: AppSpacing.allXl,
                  child: Column(
                    children: [
                      Icon(Icons.image, size: 64.sp, color: AppColors.textHint),
                      SizedBox(height: AppSpacing.mdV),
                      Text(
                        '图片加载失败',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                      SizedBox(height: AppSpacing.smV),
                      Text(
                        'URL: $completeImageUrl',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textHint,
                        ),
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
                  Icon(
                    Icons.description,
                    size: 64.sp,
                    color: AppColors.textHint,
                  ),
                  SizedBox(height: AppSpacing.mdV),
                  Text(
                    '暂无商品介绍',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textHint,
                    ),
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
    final prices = detail.prices;
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
                            fontSize:
                                18.sp, // ✅ 对应小程序 font-size: 36upx ÷ 2 = 18.sp
                            color: AppColors
                                .subjectMockPrice, // ✅ 对应小程序 color: #cd3f2f
                            fontWeight:
                                FontWeight.w700, // ✅ 对应小程序 font-weight: 700
                          ),
                        ),
                        Text(
                          currentSalePrice,
                          style: TextStyle(
                            fontSize:
                                18.sp, // ✅ 对应小程序 font-size: 36upx ÷ 2 = 18.sp
                            color: AppColors
                                .subjectMockPrice, // ✅ 对应小程序 color: #cd3f2f
                            fontWeight:
                                FontWeight.w700, // ✅ 对应小程序 font-weight: 700
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.md),
              // ✅ 购买按钮 (对应小程序 .pay-button, CSS Line 639-648)
              SizedBox(
                width: 240.w, // ✅ 对应小程序 width: 480upx ÷ 2 = 240.w
                height: 48.h, // ✅ 对应小程序 height: 96upx ÷ 2 = 48.h
                child: ElevatedButton(
                  onPressed: () =>
                      _handlePurchase(context, ref, detail, currentPrice),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors
                        .subjectMockBuyButton, // ✅ 对应小程序 background-color: #ff5402
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        100.r,
                      ), // ✅ 对应小程序 border-radius: 200upx ÷ 2 = 100.r
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    '立即购买',
                    style: TextStyle(
                      fontSize: 18.sp, // ✅ 对应小程序 font-size: 36upx ÷ 2 = 18.sp
                      color: Colors.white, // ✅ 对应小程序 color: #ffffff
                      fontWeight: FontWeight.normal, // 小程序未指定，使用默认
                    ),
                  ),
                ),
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

  /// 处理购买（使用统一支付管理器）
  /// ✅ 对应小程序 Line 451-526: getOrder() - 下单后跳转支付
  /// 未登录时进入购买确认页（5.1.1 合规）
  Future<void> _handlePurchase(
    BuildContext context,
    WidgetRef ref,
    GoodsDetailModel detail,
    dynamic currentPrice,
  ) async {
    if (currentPrice == null) {
      ToastUtil.error('价格信息错误');
      return;
    }

    if (!ref.read(authProvider).isLoggedIn) {
      _navigateToPurchaseConfirm(context, detail, currentPrice);
      return;
    }

    // 准备参数
    final goodsId = SafeTypeConverter.toSafeString(
      detail.goodsId,
      defaultValue: '',
    );
    if (goodsId.isEmpty) {
      ToastUtil.error('商品ID不能为空');
      return;
    }

    final goodsMonthsPriceId = SafeTypeConverter.toSafeString(
      currentPrice.goodsMonthsPriceId,
      defaultValue: '',
    );
    final months = SafeTypeConverter.toSafeString(
      currentPrice.month,
      defaultValue: '0',
    );
    final salePriceStr = SafeTypeConverter.toSafeString(
      currentPrice.salePrice,
      defaultValue: '0',
    );
    final salePrice = double.tryParse(salePriceStr) ?? 0.0;

    if (goodsMonthsPriceId.isEmpty) {
      ToastUtil.error('价格套餐错误');
      return;
    }

    // ✅ 使用统一支付流程管理器
    await context.startPayment(
      ref: ref,
      goodsId: goodsId,
      goodsMonthsPriceId: goodsMonthsPriceId,
      months: months,
      payableAmount: salePrice,
      goodsName: detail.name ?? '科目模考',
      professionalIdName: detail.professionalIdName,
      refreshGoodsId: goodsId,
      isLearnButton: 0, // 支付成功页显示"开始测验"按钮
      onSuccess: () {
        // 支付成功：刷新商品详情
        print('✅ [科目模考] 支付成功，刷新商品详情');
        ref.read(subjectMockDetailNotifierProvider.notifier).refresh(goodsId);
      },
      onError: (error) {
        // 支付失败：显示错误
        print('❌ [科目模考] 支付失败: $error');
      },
    );
  }

  /// 处理开始练习
  void _handleStartPractice(BuildContext context, GoodsDetailModel detail) {
    // ✅ 检查登录状态（根据 Guideline 5.1.1，学习需要登录）
    if (!ref.read(authProvider).isLoggedIn) {
      _showLoginDialog(context);
      return;
    }

    // 科目模考类型 (type=8, details_type=3) 跳转到答题页面
    final type = SafeTypeConverter.toInt(detail.type);
    final goodsIdStr = SafeTypeConverter.toSafeString(detail.goodsId);

    if (type == 8) {
      // 科目模考答题页
      context.push(
        '/exam?id=$goodsIdStr&recitation_question_model=${detail.recitationQuestionModel ?? "1"}',
      );
    } else {
      ToastUtil.show('答题功能开发中...');
    }
  }

  /// 未登录时跳转购买确认页（5.1.1 合规）
  void _navigateToPurchaseConfirm(
    BuildContext context,
    GoodsDetailModel detail,
    dynamic currentPrice,
  ) {
    final goodsId = SafeTypeConverter.toSafeString(
      detail.goodsId,
      defaultValue: '',
    );
    if (goodsId.isEmpty) return;
    final goodsMonthsPriceId = SafeTypeConverter.toSafeString(
      currentPrice.goodsMonthsPriceId,
      defaultValue: '',
    );
    final months = SafeTypeConverter.toSafeString(
      currentPrice.month,
      defaultValue: '0',
    );
    final salePriceStr = SafeTypeConverter.toSafeString(
      currentPrice.salePrice,
      defaultValue: '0',
    );
    final salePrice = double.tryParse(salePriceStr) ?? 0.0;
    context.push(
      AppRoutes.purchaseConfirm,
      extra: {
        'goods_id': goodsId,
        'goods_name': detail.name ?? '科目模考',
        'goods_months_price_id': goodsMonthsPriceId,
        'months': months,
        'payable_amount': salePrice,
        'professional_id_name': detail.professionalIdName,
        'refresh_goods_id': goodsId,
        'is_learn_button': 0,
      },
    );
  }

  /// 显示登录提示对话框
  /// 根据 Guideline 5.1.1，购买和学习需要登录
  /// 使用统一的 ConfirmDialog 组件
  void _showLoginDialog(BuildContext context) {
    ConfirmDialog.show(
      context,
      title: '需要登录',
      content: '此操作需要登录账户，请先登录后再试',
      confirmText: '去登录',
      cancelText: '取消',
      onConfirm: () {
        // ✅ 使用 GoRouterState.of(context).uri 获取当前完整路径（包括查询参数）
        final routerState = GoRouterState.of(context);
        final currentUri = routerState.uri;
        String returnPath = currentUri.path;
        if (currentUri.queryParameters.isNotEmpty) {
          final queryString = currentUri.queryParameters.entries
              .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
              .join('&');
          returnPath = '$returnPath?$queryString';
        }

        // ✅ 如果查询参数为空，使用 widget 参数手动构建（因为参数可能通过 extra 传递）
        if (currentUri.queryParameters.isEmpty && widget.productId != null) {
          returnPath =
              '${AppRoutes.subjectMockDetail}?product_id=${widget.productId}';
          if (widget.professionalId != null) {
            returnPath = '$returnPath&professional_id=${widget.professionalId}';
          }
        }

        print('🔄 [科目模考登录] 返回路径: $returnPath');

        context.push(AppRoutes.loginCenter, extra: {'returnPath': returnPath});
      },
    );
  }
}
