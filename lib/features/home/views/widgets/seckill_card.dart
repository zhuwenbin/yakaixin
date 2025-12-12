import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../models/goods_model.dart';
import 'countdown_timer.dart';
import '../../../../../app/config/api_config.dart';

/// 秒杀卡片组件
/// 对应小程序: examination-test-item (seckill模式)
class SeckillCard extends StatelessWidget {
  final GoodsModel goods;
  final VoidCallback? onTap;

  const SeckillCard({
    required this.goods,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(AppSpacing.md, 12.h, AppSpacing.md, 0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.seckillGradientStart, AppColors.seckillGradientEnd],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: AppRadius.radiusLg,
            boxShadow: [
              BoxShadow(
                color: AppColors.seckillShadow,
                blurRadius: 15.r,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              _buildTags(),
              _buildCountdown(),
            ],
          ),
        ),
      ),
    );
  }

  /// 头部：商品名称 + 价格
  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            goods.name ?? '未命名商品',
            style: AppTextStyles.courseTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 12.w),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.topRight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (goods.originalPrice != null && 
                    goods.originalPrice.toString().isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${goods.originalPrice}',
                        style: AppTextStyles.seckillOriginalPrice,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      CachedNetworkImage(
                        imageUrl: ApiConfig.completeImageUrl('public/92ac17422896646546913_miaoshajia.png'),
                        width: 35.w,
                        height: 15.h,
                        errorWidget: (context, error, stackTrace) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                if (goods.salePrice != null && goods.salePrice!.isNotEmpty)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('¥', style: AppTextStyles.seckillPriceSymbol),
                      Text('${goods.salePrice}', style: AppTextStyles.seckillPriceNumber),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 标签区域
  Widget _buildTags() {
    return Padding(
      padding: EdgeInsets.only(top: 5.h, bottom: 6.h),
      child: Wrap(
        spacing: 12.w,
        children: [
          if (goods.tikuGoodsDetails?.questionNum != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppColors.seckillTagBg,
                borderRadius: AppRadius.radiusSm,
              ),
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.seckillTagText,
                  children: [
                    const TextSpan(text: '共 '),
                    TextSpan(
                      text: '${goods.tikuGoodsDetails!.questionNum}',
                      style: const TextStyle(color: AppColors.seckillTagText),
                    ),
                    const TextSpan(text: ' 题'),
                  ],
                ),
              ),
            ),
          if (goods.validityDay != null && goods.validityDay!.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.tikuTagBorder, width: 1.5.w),
                borderRadius: BorderRadius.circular(AppRadius.xs),
                color: Colors.transparent,
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

  /// 倒计时区域
  /// 对应小程序: .bottom-time (L71-76)
  Widget _buildCountdown() {
    // ✅ 从 Mock 数据读取倒计时秒数 (seckill_countdown 字段)
    // 如果没有设置,默认 8小时 = 28800秒
    final dynamic countdownValue = goods.seckillCountdown;
    final int countdownSeconds = countdownValue != null 
        ? int.tryParse(countdownValue.toString()) ?? 28800
        : 28800;

    // print('🕒 秒杀倒计时: $countdownSeconds 秒 (商品ID: ${goods.goodsId})');

    return SizedBox(
      height: 40.h,
      child: Align(
        alignment: Alignment.bottomRight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = math.min(constraints.maxWidth * 0.9, 400.w);
            final minWidth = math.min(constraints.maxWidth * 0.7, maxWidth);
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
                minWidth: minWidth,
              ),
              child: Stack(
                children: [
                  // 背景图片
                  Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          ApiConfig.completeImageUrl('public/5e91174186068572265789_daojishiback.png'),
                        ),
                        fit: BoxFit.cover,
                        onError: (_, __) {},
                      ),
                    ),
                  ),
                  // ✅ 倒计时内容 - 固定在 bottom: 20.h
                  Positioned(
                    bottom: 2.h, // ✅ 固定距离底部 2px
                    left: 0,
                    right: 0,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '秒杀倒计时',
                              style: AppTextStyles.seckillCountdown,
                            ),
                            SizedBox(width: 10.w),
                            // ✅ 接入真实倒计时组件
                            CountdownTimer(
                              durationSeconds: countdownSeconds,
                              onFinish: () {
                                // print('⏰ 秒杀倒计时结束 - 商品ID: ${goods.goodsId}');
                                // TODO: 倒计时结束后的处理逻辑
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
