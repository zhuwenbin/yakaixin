import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
        viewportFraction: 0.85,
        enlargeCenterPage: false,
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
        child: CachedNetworkImage(
          imageUrl:
              ApiConfig.completeImageUrl('public/36byshkvk6.jpg'),
          fit: BoxFit.cover,
          errorWidget: (context, error, stackTrace) {
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
