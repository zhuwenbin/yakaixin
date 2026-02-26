import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../models/goods_model.dart';
import 'seckill_card.dart';

/// 秒杀为空时默认轮播图（与小程序 brushing.vue 一致）
const String _kSeckillEmptyImageUrl =
    'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/36byshkvk6.jpg';

/// 秒杀轮播组件
/// 有数据：轮播秒杀卡片；无数据：显示默认轮播图（单页，与小程序 showSeckillEmpty 一致）
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
          ? _buildDefaultCarousel()
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

  /// 无数据时显示默认轮播图（与小程序 swiper-item v-if="showSeckillEmpty" 一致）
  /// 使用同一套轮播组件，仅 1 页，保持与有数据时相同的高度和圆角
  Widget _buildDefaultCarousel() {
    return CarouselSlider.builder(
      itemCount: 1,
      itemBuilder: (context, index, realIndex) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: ClipRRect(
            borderRadius: AppRadius.radiusLg,
            child: Image.network(
              _kSeckillEmptyImageUrl,
              width: double.infinity,
              height: 150.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 150.h,
                  color: AppColors.card,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 48.sp,
                    color: AppColors.divider,
                  ),
                );
              },
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 150.h,
        viewportFraction: 1.0,
        enlargeCenterPage: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enableInfiniteScroll: false,
      ),
    );
  }
}
