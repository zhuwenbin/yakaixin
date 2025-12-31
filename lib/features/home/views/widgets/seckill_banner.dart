import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../models/goods_model.dart';
import 'seckill_card.dart';
import '../../../../../app/config/api_config.dart';

/// 秒杀轮播组件
class SeckillBanner extends StatelessWidget {
  final List<GoodsModel> recommendList;
  final void Function(GoodsModel) onTap;

  const SeckillBanner({
    required this.recommendList,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 170.h,
      child: recommendList.isEmpty
          ? _buildEmptyCard()
          : _buildCarousel(),
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider.builder(
      itemCount: recommendList.length,
      itemBuilder: (context, index, realIndex) {
        final goods = recommendList[index];
        return SeckillCard(
          goods: goods,
          onTap: () => onTap(goods),
        );
      },
      options: CarouselOptions(
        height: 150.h,
        viewportFraction: 1.0, // ✅ 不显示前后预览，与小程序一致
        enlargeCenterPage: false, // ✅ 不缩放
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        pauseAutoPlayOnTouch: true,
        enableInfiniteScroll: true,
      ),
    );
  }

  Widget _buildEmptyCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: ClipRRect(
        borderRadius: AppRadius.radiusLg,
        // ✅ 使用 Image.network 避免 iOS Release 模式 Content-Disposition 问题
        child: Image.network(
          ApiConfig.completeImageUrl('public/36byshkvk6.jpg'),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.card,
              alignment: Alignment.center,
              child: Icon(
                Icons.image,
                size: 50.sp,
                color: AppColors.divider,
              ),
            );
          },
        ),
      ),
    );
  }
}
