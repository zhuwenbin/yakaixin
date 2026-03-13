import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../models/goods_model.dart';
import 'seckill_card.dart';

/// 秒杀轮播组件
/// 有数据：轮播秒杀卡片；无数据：白色背景 + 中心 logo
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
          ? _buildDefaultCarousel(context)
          : _buildCarousel(context),
    );
  }

  Widget _buildCarousel(BuildContext context) {
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
        viewportFraction: 1.0,
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

  /// 无数据时：白色背景 + 中心 logo
  Widget _buildDefaultCarousel(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: ClipRRect(
        borderRadius: AppRadius.radiusLg,
        child: Container(
          width: double.infinity,
          height: 150.h,
          color: Colors.white,
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/app_icon.png',
            width: 80.w,
            height: 80.w,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.image_not_supported_outlined,
                size: 48.sp,
                color: Colors.grey,
              );
            },
          ),
        ),
      ),
    );
  }
}
