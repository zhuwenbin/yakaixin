import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/safe_type_converter.dart';
import '../../../core/payment/payment_flow_manager.dart';
import '../../../core/widgets/common_state_widget.dart';
import '../providers/secret_real_detail_provider.dart';
import '../models/goods_detail_model.dart';

/// P5-1-2 历年真题商品详情页（绝密真题）
/// 对应小程序: modules/jintiku/pages/test/secretRealDetail.vue
class SecretRealDetailPage extends ConsumerStatefulWidget {
  final String? productId;
  final String? professionalId;

  const SecretRealDetailPage({super.key, this.productId, this.professionalId});

  @override
  ConsumerState<SecretRealDetailPage> createState() =>
      _SecretRealDetailPageState();
}

class _SecretRealDetailPageState extends ConsumerState<SecretRealDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.productId != null && widget.productId!.isNotEmpty) {
        ref
            .read(secretRealDetailNotifierProvider.notifier)
            .loadDetail(widget.productId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(secretRealDetailNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F6F8,
      ), // 对应小程序 .secret-real-detail background-color: #F5F6F8
      appBar: AppBar(
        title: const Text('历年真题'),
        backgroundColor: Colors.white, // ✅ 白色 AppBar（对应小程序 navbar）
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: state.isLoading
          ? _buildLoading()
          : state.error != null
          ? _buildError(state.error!)
          : state.goodsDetail != null
          ? _buildContent(state.goodsDetail!)
          : _buildEmpty(),
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
    return CommonStateWidget.loadError(
      message: error,
      onRetry: () {
        if (widget.productId != null) {
          ref
              .read(secretRealDetailNotifierProvider.notifier)
              .refresh(widget.productId!);
        }
      },
    );
  }

  Widget _buildEmpty() {
    return CommonStateWidget.empty();
  }

  Widget _buildContent(GoodsDetailModel detail) {
    // 对应小程序 Line 2-52
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // 渐变背景（对应小程序 .back-blue, CSS Line 701-709）
        // height: 50vh, position: absolute, top: 0
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: screenHeight * 0.5,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFB8E8FC), // 浅蓝色
                  const Color(0xFFF5F6F8), // 灰白色（对应小程序 background-color）
                ],
              ),
            ),
          ),
        ),
        // 内容区域（对应小程序 .page-content, CSS Line 716-724）
        // padding: 90upx 32upx, position: absolute, top: 0
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16.w, // 32upx / 2 = 16
                45.h, // 90upx / 2 = 45
                16.w,
                0,
              ), // 对应小程序 padding: 90upx 32upx
              child: Column(
                children: [
                  // 白色卡片（对应小程序 .old-card, CSS Line 726-730）
                  // background-color: #fff, padding: 55upx 35upx, border-radius: 40upx
                  _buildCard(detail),
                  SizedBox(
                    height: 40.h,
                  ), // 对应小程序 .share-button margin: 20vh auto 0
                  // "开始冲刺做题"按钮（对应小程序 .share-button, CSS Line 796-806）
                  _buildActionButton(detail),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建背景图片（对应小程序 .bg-wrapper, CSS Line 768-794）
  /// 小程序使用本地静态资源: url("../../../../static/imgs/jintiku/secret.png")
  /// Flutter 使用本地资源: assets/images/secret.png（与小程序保持一致，都是本地资源）
  /// background-size: 60% auto, background-position: center, background-repeat: no-repeat
  Widget _buildBackgroundImage() {
    // ✅ 小程序路径: ../../../../static/imgs/jintiku/secret.png（本地静态资源）
    // ✅ Flutter 路径: assets/images/secret.png（本地资源，已复制到 assets 目录）
    return FractionallySizedBox(
      widthFactor: 0.6, // 60% 宽度（对应小程序 background-size: 60% auto）
      alignment: Alignment.center,
      child: Image(
        image: const AssetImage('assets/images/secret.png'),
        fit: BoxFit.contain,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) {
          // 如果资源加载失败，显示空白（对应小程序 background-color: #ffffff 备用背景色）
          print('❌ [secretRealDetail] 背景图片加载失败: $error');
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// 计算 examTitle（对应小程序 secretRealDetail.vue Line 13 和 Line 506-509）
  /// 小程序显示逻辑：
  /// 1. 优先使用 API 返回的 exam_title（如果存在且不为空）
  /// 2. 如果 exam_title 为空，按小程序逻辑计算：year + 专业名称最后一部分
  /// 3. 对于 details_type == 2 的商品，如果计算失败，显示"历年真题"
  String _getExamTitle(GoodsDetailModel detail) {
    // ✅ 优先使用 API 返回的 exam_title（如果存在且不为空）
    if (detail.examTitle != null && detail.examTitle!.isNotEmpty) {
      return detail.examTitle!;
    }

    // ✅ 如果 exam_title 为空，按小程序逻辑计算：year + 专业名称最后一部分（对应小程序 Line 506-509）
    final professionalIdName = detail.professionalIdName ?? '';
    if (professionalIdName.isNotEmpty) {
      final professionalIdNames = professionalIdName.split('-');
      final titleName = professionalIdNames.isNotEmpty
          ? professionalIdNames[professionalIdNames.length - 1]
          : '';
      final year = detail.year ?? '';
      if (year.isNotEmpty && titleName.isNotEmpty) {
        return '$year$titleName';
      }
    }

    // ✅ 如果计算失败，对于 details_type == 2 的商品，显示"历年真题"（对应小程序显示逻辑）
    final detailsTypeInt =
        int.tryParse(detail.detailsType?.toString() ?? '') ?? 0;
    if (detailsTypeInt == 2) {
      return '历年真题';
    }

    // ✅ 其他情况，返回默认值
    return detail.professionalIdName ?? '口腔执业医师';
  }

  Widget _buildCard(GoodsDetailModel detail) {
    // 对应小程序 Line 7-47
    final questionNum = detail.tikuGoodsDetails?.questionNum?.toString() ?? '0';
    final examTime = detail.tikuGoodsDetails?.examTime ?? '';
    final doCount = detail.paperStatistics?.doCount?.toString() ?? '0';
    final accuracyRate =
        detail.paperStatistics?.totalAccuracyRate?.toString() ?? '0';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        17.5.w, // 35upx / 2 = 17.5
        27.5.h, // 55upx / 2 = 27.5
        17.5.w,
        27.5.h,
      ), // 对应小程序 .old-card padding: 55upx 35upx
      decoration: BoxDecoration(
        color: Colors.white, // 对应小程序 .old-card background-color: #fff
        borderRadius: BorderRadius.circular(20.r), // 40upx / 2 = 20
      ),
      child: Stack(
        children: [
          // 1. 背景图片（对应小程序 .bg-wrapper, CSS Line 768-794）
          // 小程序使用本地静态资源: url("../../../../static/imgs/jintiku/secret.png")
          // Flutter 需要使用网络 URL，尝试多个可能的路径
          Positioned.fill(child: _buildBackgroundImage()),
          // 2. 内容层
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 3. 标题（对应小程序 .title-1, Line 11-14, CSS Line 711-714）
              // text-align: center, font-size: 22px, 默认颜色（小程序未指定，使用默认黑色）
              Text(
                _getExamTitle(detail),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp, // 对应小程序 font-size: 22px
                  color: const Color(0xFF000000), // 小程序默认黑色
                  fontWeight: FontWeight.normal, // 小程序未指定，使用默认
                ),
              ),
              SizedBox(height: AppSpacing.mdV),
              // 4. "绝密真题"标签（对应小程序 .red-title, Line 15, CSS Line 740-745）
              // color: #D02C23, font-weight: 700, font-size: 27px, text-align: center
              Text(
                '绝密真题',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFFD02C23), // 对应小程序 color: #D02C23
                  fontWeight: FontWeight.w700, // 对应小程序 font-weight: 700
                  fontSize: 27.sp, // 对应小程序 font-size: 27px
                ),
              ),
              SizedBox(
                height: 22.5.h,
              ), // 对应小程序 .content-title margin-top: 45upx / 2 = 22.5
              // 5. 题目内容（对应小程序 .content-title, Line 17-19, CSS Line 732-738）
              // margin-top: 45upx, text-align: center, padding: 3upx 6upx, border-radius: 3upx, background-color: #fff
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w, // 6upx / 2 = 3
                  vertical: 1.5.h, // 3upx / 2 = 1.5
                ), // 对应小程序 padding: 3upx 6upx
                decoration: BoxDecoration(
                  color: Colors.white, // 对应小程序 background-color: #fff
                  borderRadius: BorderRadius.circular(
                    1.5.r, // 3upx / 2 = 1.5
                  ), // 对应小程序 border-radius: 3upx
                ),
                child: Text(
                  '题目内容：${detail.name ?? ''}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp, // 小程序未指定，使用默认（通常14px）
                    color: const Color(0xFF000000), // 小程序默认黑色
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.mdV),
              // 6. 列表容器（对应小程序 .content-list, Line 22-44）
              // 小程序没有为 .content-list 定义样式，只是容器
              Column(
                children: [
                  // 7. 列表项（对应小程序 .content-item, CSS Line 755-762）
                  // width: 100%, display: flex, justify-content: space-between, align-items: center
                  // font-size: 14px, margin-top: 20upx
                  _buildInfoRow('总题数', questionNum),
                  SizedBox(height: 10.h), // 20upx / 2 = 10
                  _buildInfoRow('做题次数', doCount),
                  SizedBox(height: 10.h),
                  _buildInfoRow('正确率', '$accuracyRate%'),
                  SizedBox(height: 10.h),
                  _buildInfoRowWithAction('错题', '查看错题', () {
                    // // TODO: 跳转错题本（对应小程序 Line 221-230）
                    // ScaffoldMessenger.of(
                    //   context,
                    // ).showSnackBar(SnackBar(content: Text('错题本功能开发中...')));
                  }),
                  SizedBox(height: 10.h),
                  _buildInfoRow('题库到期时间', examTime),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    // 对应小程序 .content-item, CSS Line 755-762
    // width: 100%, display: flex, justify-content: space-between, align-items: center
    // font-size: 14px, margin-top: 20upx
    // 小程序未指定颜色，使用默认黑色
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 14.sp, // 对应小程序 font-size: 14px
            color: const Color(0xFF000000), // 小程序默认黑色
            fontWeight: FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp, // 对应小程序 font-size: 14px
            color: const Color(0xFF000000), // 小程序默认黑色
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRowWithAction(
    String label,
    String actionText,
    VoidCallback onTap,
  ) {
    // 对应小程序 .content-item, CSS Line 755-762
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 14.sp, // 对应小程序 font-size: 14px
            color: AppColors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: TextStyle(
              fontSize: 14.sp, // 对应小程序 font-size: 14px
              color: const Color(0xFF0185F4), // 对应小程序 .link-text color: #0185F4
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }

  /// "开始冲刺做题"按钮（对应小程序 .share-button, CSS Line 796-806）
  /// margin: 20vh auto 0, background-color: #ff5402, border-radius: 100upx, width: 560upx, height: 96upx
  Widget _buildActionButton(GoodsDetailModel detail) {
    final isPurchased = detail.permissionStatus == '1';

    return SizedBox(
      width: 280.w, // 560upx / 2 = 280
      height: 48.h, // 96upx / 2 = 48
      child: ElevatedButton(
        onPressed: () => _handleAction(detail, isPurchased),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(
            0xFFFF5402,
          ), // 对应小程序 background-color: #ff5402
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              50.r, // 100upx / 2 = 50
            ), // 对应小程序 border-radius: 100upx
          ),
          elevation: 0,
        ),
        child: Text(
          '开始冲刺做题',
          style: TextStyle(
            fontSize: 18.sp, // 对应小程序 font-size: 18px
            color: Colors.white, // 对应小程序 color: #ffffff
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _handleAction(GoodsDetailModel detail, bool isPurchased) {
    if (isPurchased) {
      // 已购买 - 跳转考试页（对应小程序 Line 215）
      // pages/test/exam?id=${this.info.id}&recitation_question_model=${this.info.recitation_question_model}
      context.push(
        AppRoutes.testExam,
        extra: {
          'id': detail.goodsId?.toString(),
          'recitation_question_model': detail.recitationQuestionModel,
        },
      );
    } else {
      // 未购买 - 调用下单流程
      // 对应小程序: secretRealDetail.vue Line 218, 532-608
      _startPurchaseFlow(detail);
    }
  }

  /// 开始购买流程（使用统一支付管理器）
  /// 对应小程序: secretRealDetail.vue Line 532-674
  Future<void> _startPurchaseFlow(GoodsDetailModel detail) async {
    // ✅ 获取选中的价格信息
    // 注意：秘卷真题页面暂时使用第一个价格（小程序逻辑）
    final selectedIndex = 0;
    if (detail.prices.isEmpty || selectedIndex >= detail.prices.length) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('价格信息异常')));
      }
      return;
    }

    final selectedPrice = detail.prices[selectedIndex];
    final payableAmount = double.tryParse(selectedPrice.salePrice ?? '0') ?? 0;
    final goodsId = SafeTypeConverter.toSafeString(detail.goodsId);
    final months = SafeTypeConverter.toSafeString(
      selectedPrice.month,
      defaultValue: '0',
    );
    final goodsMonthsPriceId = selectedPrice.goodsMonthsPriceId ?? '';

    print('\n🛒 [秘卷真题] 开始下单:');
    print('   商品ID: $goodsId');
    print('   月数: $months');
    print('   应付金额: ¥$payableAmount');

    // ✅ 使用统一支付流程管理器
    await context.startPayment(
      ref: ref,
      goodsId: goodsId,
      goodsMonthsPriceId: goodsMonthsPriceId,
      months: months,
      payableAmount: payableAmount,
      goodsName: detail.name ?? '秘卷真题',
      professionalIdName: detail.professionalIdName,
      refreshGoodsId: goodsId,
      isLearnButton: 1, // 支付成功页显示"去学习"按钮
      onSuccess: () {
        // 支付成功回调：刷新商品详情
        print('✅ [秘卷真题] 支付成功，刷新商品详情');
        ref.read(secretRealDetailNotifierProvider.notifier).refresh(goodsId);
      },
      onError: (error) {
        // 支付失败回调
        print('❌ [秘卷真题] 支付失败: $error');
      },
    );
  }
}
