import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../models/goods_model.dart';

/// 商品卡片组件（题库）
/// 对应小程序: examination-test-item (普通模式)
class GoodsCard extends StatelessWidget {
  final GoodsModel goods;
  final VoidCallback? onTap;

  const GoodsCard({required this.goods, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: AppSpacing.mdV),
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.mdV,
          AppSpacing.md,
          AppSpacing.mdV,
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppRadius.radiusLg,
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.06),
              blurRadius: 15.r,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: AppSpacing.mdV),
            _buildTags(),
            // ⚠️ 修复：只有已购买 + type == 18（章节练习）才显示底部按钮（对应小程序 Line 55）
            // if (goods.permissionStatus == '1' && goods.type.toString() == '18')
            //   _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  /// 头部：商品名称 + 价格
  /// ⚠️ 价格只在未购买时显示（对应小程序 Line 19: v-if="!isPay && !seckill && item.permission_status == '2'"）
  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 商品名靠左，自动撑开占可用空间
        Expanded(
          child: Text(
            goods.name ?? '未命名商品',
            style: AppTextStyles.tikuCardTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // 现价原价整体靠右：放在一个Column/FittedBox中
        if (goods.permissionStatus == '2' &&
            goods.salePrice != null &&
            goods.salePrice!.isNotEmpty)
          Container(
            margin: EdgeInsets.only(left: 12.w),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.topRight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                mainAxisSize: MainAxisSize.min,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  // 先显示原价（如有）
                  if (goods.originalPrice != null &&
                      goods.originalPrice.toString().isNotEmpty) ...[
                    Text(
                      '${goods.originalPrice}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDisabled,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    SizedBox(width: 5.w),
                  ],
                  // 现价（带符号）
                  Text(
                    '¥',
                    style: AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.error,
                    ),
                  ),
                  Text(
                    '${goods.salePrice}',
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// 标签
  Widget _buildTags() {
    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 12.h),
      child: Wrap(
        spacing: 12.w,
        children: [
          if (goods.tikuGoodsDetails?.questionNum != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppColors.tikuTagBg,
                borderRadius: AppRadius.radiusSm,
              ),
              child: Text(
                '共${goods.tikuGoodsDetails!.questionNum}题',
                style: AppTextStyles.tikuTag,
              ),
            ),
          if (goods.type.toString() == '8' &&
              goods.tikuGoodsDetails?.questionNum != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.tikuTagBorder, width: 3.w),
                borderRadius: AppRadius.radiusSm,
              ),
              child: Text(
                '共${goods.tikuGoodsDetails!.questionNum}题',
                style: AppTextStyles.tikuTag.copyWith(
                  color: AppColors.tikuTagBorder,
                ),
              ),
            ),
          // ✅ 未购买时显示有效期月份（对应小程序 Line 44-46）
          if (goods.permissionStatus == '2' &&
              goods.validityDay != null &&
              goods.validityDay!.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.tikuTagBorder, width: 3.w),
                borderRadius: AppRadius.radiusSm,
              ),
              child: Text(
                goods.validityDay == '0' ? '永久' : '${goods.validityDay}个月',
                style: AppTextStyles.tikuTag.copyWith(
                  color: AppColors.tikuTagBorder,
                ),
              ),
            ),
          // ✅ 已购买时显示有效期（对应小程序 Line 47-49）
          if (goods.validityDay != null &&
              goods.validityDay!.isNotEmpty &&
              goods.permissionStatus == '1')
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.tikuTagBorder,
                  width: 1.5.w,
                ),
                borderRadius: AppRadius.radiusXs,
              ),
              child: Text(
                goods.validityDay == '0' ? '永久' : '${goods.validityDay}个月',
                style: AppTextStyles.tikuTag.copyWith(
                  color: AppColors.tikuTagBorder,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 底部按钮（对应小程序 Line 55-70）
  /// 只在 isPay && type == 18 时显示
  Widget _buildActionButton(BuildContext context) {
    return Container(
      height: 50.h,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 80.w,
            height: 28.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(32.r),
            ),
            child: Text(
              // ✅ type == 18 固定显示“立即刷题”（对应小程序 Line 68）
              '立即刷题',
              style: AppTextStyles.tikuButton,
            ),
          ),
        ],
      ),
    );
  }
}
