import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/utils/safe_type_converter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/common_state_widget.dart';
import '../../auth/providers/auth_provider.dart';
import '../../order/providers/payment_provider.dart';
import '../providers/goods_detail_provider.dart';
import '../models/goods_detail_model.dart';

/// 商品详情页（弹窗风格）
/// 样式参照小程序 secretRealDetail.vue 的 u-popup 购买弹窗（popup-box、popup-box-top、popup-card、pay-bottom）
class GoodsDetailPopupPage extends ConsumerStatefulWidget {
  final String? productId;
  final String? goodsId;
  final String? professionalId;

  const GoodsDetailPopupPage({
    super.key,
    this.productId,
    this.goodsId,
    this.professionalId,
  });

  @override
  ConsumerState<GoodsDetailPopupPage> createState() =>
      _GoodsDetailPopupPageState();
}

class _GoodsDetailPopupPageState extends ConsumerState<GoodsDetailPopupPage> {
  bool _isPurchasing = false;

  // 小程序样式常量（对应 secretRealDetail.vue .popup-box 及子类）
  static const Color _bgGray = Color(0xFFEDF1F2); // popup-box-top
  static const Color _borderRed = Color(0xFFD02C23); // top-300 border / sub-title
  static const Color _priceRed = Color(0xFFCD3F2F); // price-top / bottom-price / checkbox
  static const Color _btnOrange = Color(0xFFFF5402); // pay-button

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final goodsId = widget.goodsId ?? widget.productId;
      if (goodsId != null && goodsId.isNotEmpty) {
        ref
            .read(goodsDetailNotifierProvider.notifier)
            .loadGoodsDetail(goodsId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(goodsDetailNotifierProvider);

    return Scaffold(
      backgroundColor: _bgGray,
      appBar: AppBar(
        backgroundColor: _bgGray,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF333333)),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          '历年真题详情',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? CommonStateWidget.loadError(
                  message: state.error!,
                  onRetry: () {
                    final goodsId = widget.goodsId ?? widget.productId;
                    if (goodsId != null) {
                      ref
                          .read(goodsDetailNotifierProvider.notifier)
                          .loadGoodsDetail(goodsId);
                    }
                  },
                )
              : state.goodsDetail != null
                  ? _buildPopupBody(state.goodsDetail!)
                  : CommonStateWidget.empty(),
    );
  }

  /// 当前选中价格，对应小程序：无 prices 时注入 goods_months_price_id: ''、sale_price: '0.00'（detail.vue Line 434-445）
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

  /// 包一层：可滚动内容 + 底部固定栏 + 底部安全区白色
  /// 对应小程序：无 prices 时注入 0 元价（detail.vue / secretRealDetail.vue Line 434-446），仍显示底栏并支持购买
  Widget _buildPopupBody(GoodsDetailModel detail) {
    final GoodsPriceModel selectedPrice = _getEffectiveSelectedPrice(detail, 0);
    final salePriceStr = SafeTypeConverter.toSafeString(
      selectedPrice.salePrice,
      defaultValue: '0',
    );
    final currentSalePrice = double.tryParse(salePriceStr) ?? 0.0;
    final permissionStatus = SafeTypeConverter.toSafeString(
      detail.permissionStatus,
    );
    final isPurchased = permissionStatus == '1';
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Column(
      children: [
        Expanded(child: _buildPopupContent(detail, isPurchased, currentSalePrice)),
        if (!isPurchased)
          _buildBottomBar(currentSalePrice, detail, selectedPrice),
        if (bottomPadding > 0)
          Container(
            height: bottomPadding,
            color: Colors.white,
          ),
      ],
    );
  }

  /// 弹窗风格可滚动内容（不含底部栏，底部栏固定）
  Widget _buildPopupContent(
    GoodsDetailModel detail,
    bool isPurchased,
    double currentSalePrice,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 34.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCoverImage(detail),
          SizedBox(height: 17.h),
          _buildTitlePriceCard(
            name: detail.name ?? '商品',
            subtitle: detail.numText,
            price: currentSalePrice,
          ),
          SizedBox(height: 17.h),
          _buildRightsCard(detail),
          SizedBox(height: 17.h),
          if (isPurchased)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 27.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Text(
                  '您已购买',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 封面图（与商品详情页一致：有网络图则显示，无或加载失败则默认图）
  Widget _buildCoverImage(GoodsDetailModel detail) {
    final coverPath = detail.materialCoverPath ?? '';
    final hasNetworkImage =
        coverPath.isNotEmpty && coverPath.startsWith(RegExp(r'https?://'));

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: hasNetworkImage
              ? Image.network(
                  coverPath,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: const Color(0xFFF5F6FA),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return _buildDefaultCover();
                  },
                )
              : _buildDefaultCover(),
        ),
      ),
    );
  }

  Widget _buildDefaultCover() {
    return Container(
      color: const Color(0xFFF5F6FA),
      child: Center(
        child: Icon(
          Icons.menu_book_outlined,
          size: 64.sp,
          color: AppColors.textHint,
        ),
      ),
    );
  }

  /// 标题+副标题+价格卡片（对应小程序 top-300 popup-card: border 2upx #D02C23, padding 54upx 48upx, radius 20upx）
  Widget _buildTitlePriceCard({
    required String name,
    required String subtitle,
    required double price,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 27.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                    letterSpacing: 0.5,
                    color: const Color(0xFF333333),
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  SizedBox(height: 11.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: _borderRed,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            '￥${price.toStringAsFixed(2)}',
            style: TextStyle(
              color: _priceRed,
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
            ),
          ),
        ],
      ),
    );
  }

  /// 专享权益卡片（参照小程序 personal-right popup-card: .title + .list v-html confirmation_page_data）
  Widget _buildRightsCard(GoodsDetailModel detail) {
    final htmlContent = detail.confirmationPageData?.trim() ?? '';
    final stripped = htmlContent.replaceAll(RegExp(r'<[^>]*>'), '').trim();
    final hasHtml = htmlContent.isNotEmpty && stripped.isNotEmpty;

    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 27.h, 24.w, 27.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '专享权益',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
              color: const Color(0xFF333333),
            ),
          ),
          SizedBox(height: 13.h),
          if (hasHtml)
            Html(
              data: htmlContent,
              style: {
                '*': Style(
                  fontSize: FontSize(14.sp),
                  color: const Color(0xFF666666),
                  lineHeight: const LineHeight(1.5),
                ),
                'p': Style(margin: Margins.only(bottom: 8.h)),
              },
            )
          else
            _buildRightsFallbackText(detail),
        ],
      ),
    );
  }

  Widget _buildRightsFallbackText(GoodsDetailModel detail) {
    final lines = <String>[];
    if (detail.numText.isNotEmpty) lines.add(detail.numText);
    if (detail.tipsText.isNotEmpty) lines.add(detail.tipsText);
    if (lines.isEmpty) lines.add('购买后即可使用全部题目与解析');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines
          .map(
            (e) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Text(
                e,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF666666),
                  height: 1.4,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  /// 底部价格+确认付款（固定底栏，按钮尺寸与商品详情页一致：238.w 40.h 14.sp 20.r）
  Widget _buildBottomBar(
    double currentSalePrice,
    GoodsDetailModel detail,
    GoodsPriceModel selectedPrice,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '￥${currentSalePrice.toStringAsFixed(2)}',
            style: TextStyle(
              color: _priceRed,
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(
            width: 238.w,
            height: 40.h,
            child: ElevatedButton(
              onPressed: _isPurchasing
                  ? null
                  : () => _handleConfirmPay(detail, selectedPrice),
              style: ElevatedButton.styleFrom(
                backgroundColor: _btnOrange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                elevation: 0,
              ),
              child: Text(
                '确认付款',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 确认付款：逻辑与 GoodsDetailPage 一致
  Future<void> _handleConfirmPay(
    GoodsDetailModel detail,
    GoodsPriceModel selectedPrice,
  ) async {
    if (!ref.read(authProvider).isLoggedIn) {
      _navigateToLogin();
      return;
    }
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
      setState(() => _isPurchasing = true);
      EasyLoading.show(status: '正在处理订单...');

      final paymentNotifier = ref.read(paymentProvider.notifier);
      final result = await paymentNotifier.startPayment(
        goodsId: goodsId,
        goodsMonthsPriceId: goodsMonthsPriceId,
        months: months,
        payableAmount: salePrice,
      );

      EasyLoading.dismiss();
      if (!mounted) return;

      if (result.isFreeOrder) {
        final refreshGoodsId = widget.goodsId ?? widget.productId;
        if (refreshGoodsId != null) {
          await ref
              .read(goodsDetailNotifierProvider.notifier)
              .refresh(refreshGoodsId);
        }
        final professionalIdName = SafeTypeConverter.toSafeString(
          detail.professionalIdName,
          defaultValue: '',
        );
        final goodsType = SafeTypeConverter.toSafeString(
          detail.type,
          defaultValue: '',
        );
        final isCourse = goodsType == '2' || goodsType == '3';
        context.push(
          AppRoutes.paySuccess,
          extra: {
            'goods_id': goodsId,
            'professional_id_name': professionalIdName,
            'goods_type': goodsType,
            'isLearnButton': isCourse ? 1 : 0,
          },
        );
      } else if (!result.isFreeOrder && result.isSuccess) {
        final professionalIdName = SafeTypeConverter.toSafeString(
          detail.professionalIdName,
          defaultValue: '',
        );
        final goodsType = SafeTypeConverter.toSafeString(
          detail.type,
          defaultValue: '',
        );

        final paymentResult = await context.push<Map<String, dynamic>>(
          AppRoutes.confirmPayment,
          extra: {
            'order_id': result.orderId!,
            'flow_id': result.flowId!,
            'goods_id': result.goodsId!,
            'finance_body_id': result.financeBodyId ?? '',
            'goods_name': detail.name ?? '商品',
            'payable_amount': result.payableAmount!,
            'refresh_goods_id': goodsId,
            'professional_id_name': professionalIdName,
            'goods_type': goodsType,
          },
        );

        if (paymentResult != null && paymentResult['success'] == true) {
          final refreshGoodsId =
              paymentResult['refresh_goods_id'] as String? ?? goodsId;
          await ref
              .read(goodsDetailNotifierProvider.notifier)
              .refresh(refreshGoodsId);
          if (!mounted) return;
          final isCourse = goodsType == '2' || goodsType == '3';
          context.push(
            AppRoutes.paySuccess,
            extra: {
              'goods_id': goodsId,
              'professional_id_name': professionalIdName,
              'goods_type': goodsType,
              'isLearnButton': isCourse ? 1 : 0,
            },
          );
        }
      } else {
        EasyLoading.showError(result.errorMessage ?? '订单创建失败');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('订单异常: $e');
    } finally {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => _isPurchasing = false);
      });
    }
  }

  /// 未登录时跳转登录页，登录后返回当前详情页（与商品详情页保持一致）
  void _navigateToLogin() {
    final goodsId = widget.goodsId ?? widget.productId;
    String returnPath = AppRoutes.goodsDetailPopup;
    if (goodsId != null && goodsId.isNotEmpty) {
      returnPath =
          '$returnPath?goods_id=$goodsId&product_id=$goodsId';
      if (widget.professionalId != null &&
          widget.professionalId!.isNotEmpty) {
        returnPath = '$returnPath&professional_id=${widget.professionalId}';
      }
    }
    context.push(AppRoutes.loginCenter, extra: {'returnPath': returnPath});
  }
}
