import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('绝密真题'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
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
        padding: EdgeInsets.all(50.h),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: AppColors.error),
            SizedBox(height: AppSpacing.mdV),
            Text(error, textAlign: TextAlign.center),
            SizedBox(height: AppSpacing.lgV),
            ElevatedButton(
              onPressed: () {
                if (widget.productId != null) {
                  ref
                      .read(secretRealDetailNotifierProvider.notifier)
                      .refresh(widget.productId!);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
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
    // 对应小程序 Line 2-52
    return Stack(
      children: [
        // 渐变背景（对应小程序 Line 3-5, CSS Line 701-709）
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFB8E8FC), // 浅蓝色
                  AppColors.background, // 灰白色
                ],
              ),
            ),
          ),
        ),
        // 内容区域（对应小程序 Line 6-52）
        SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 45.h, 16.w, 0),
            child: Column(
              children: [
                // 绝密真题卡片（对应小程序 Line 7-47）
                Expanded(child: _buildCard(detail)),
              ],
            ),
          ),
        ),
      ],
    );
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
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadowLight,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 专业名称（对应小程序 Line 11-14）
            Text(
              detail.professionalIdName ?? '口腔执业医师',
              textAlign: TextAlign.center,
              style: AppTextStyles.heading2.copyWith(color: AppColors.textPrimary),
            ),
            SizedBox(height: AppSpacing.mdV),
            // 绝密真题标签（对应小程序 Line 15）
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: AppSpacing.smV),
              decoration: BoxDecoration(
                color: AppColors.unpurchased,
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
              child: Text(
                '绝密真题',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.lgV),
            // 题目内容（对应小程序 Line 17-19）
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              width: double.infinity,
              child: Text(
                '题目内容：${detail.name ?? ''}',
                textAlign: TextAlign.left,
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
              ),
            ),
            SizedBox(height: AppSpacing.mdV),
            Divider(color: AppColors.divider),
            SizedBox(height: AppSpacing.mdV),
            // 详情列表（对应小程序 Line 22-44）
            _buildInfoRow('总题数', questionNum),
            SizedBox(height: AppSpacing.mdV),
            _buildInfoRow('做题次数', doCount),
            SizedBox(height: AppSpacing.mdV),
            _buildInfoRow('正确率', '$accuracyRate%'),
            SizedBox(height: AppSpacing.mdV),
            _buildInfoRowWithAction('错题', '查看错题', () {
              // TODO: 跳转错题本（对应小程序 Line 221-230）
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('错题本功能开发中...')));
            }),
            SizedBox(height: AppSpacing.mdV),
            _buildInfoRow('题库到期时间', examTime),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildInfoRowWithAction(
    String label,
    String actionText,
    VoidCallback onTap,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.primary,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }

  /// 底部按钮（对应小程序 Line 50, 211-220）
  Widget _buildBottomBar(GoodsDetailModel detail) {
    final isPurchased = detail.permissionStatus == '1';

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
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
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _handleAction(detail, isPurchased),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(vertical: AppSpacing.mdV),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              elevation: 0,
            ),
            child: Text(
              isPurchased ? '开始冲刺做题' : '立即购买',
              style: AppTextStyles.buttonLarge.copyWith(color: AppColors.textWhite),
            ),
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
      // 未购买 - 显示购买弹窗（对应小程序 Line 218，54-98）
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('购买功能开发中...')));
    }
  }
}
