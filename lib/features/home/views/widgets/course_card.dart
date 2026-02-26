import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/utils/safe_type_converter.dart';
import '../../models/goods_model.dart';

/// 课程卡片组件（网课/直播）
/// 对应小程序: examination-course-item.vue (.card样式)
class CourseCard extends StatelessWidget {
  final GoodsModel goods;
  final VoidCallback? onTap;

  const CourseCard({
    required this.goods,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: AppSpacing.mdV),
        padding: AppSpacing.allMd,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadowLight,
              blurRadius: 1.r,
              offset: const Offset(0, 1),
            ),
            BoxShadow(
              color: AppColors.cardShadowMedium,
              blurRadius: 4.r,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: AppColors.cardShadowDark,
              blurRadius: 8.r,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            SizedBox(height: 10.h),
            if (_shouldShowValidityTime()) ...[
              _buildValidityTime(),
              SizedBox(height: 10.h),
            ],
            _buildTags(),
            SizedBox(height: 10.h),
            _buildPriceRow(),
            SizedBox(height: 6.5.h),
            _buildBottomInfo(),
          ],
        ),
      ),
    );
  }

  /// 标题
  Widget _buildTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCourseTypeIcon(),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            goods.name ?? '未命名课程',
            style: AppTextStyles.courseTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// 课程类型图标
  /// 对应小程序: course-type.vue
  /// shop_type 通过 computeShopType() 动态计算
  Widget _buildCourseTypeIcon() {
    // 使用扩展方法计算 shop_type
    final String shopType = goods.computeShopType();
    
    // 调试日志
    print('课程卡片 - 商品名称: ${goods.name}, 计算后的 shop_type: $shopType');
    print('  is_recommend: ${goods.isRecommend}, teaching_type_name: ${goods.teachingTypeName}, business_type: ${goods.businessType}');

    // 根据 shop_type 返回对应的本地图片路径
    String? iconPath;
    switch (shopType) {
      case '1':
        iconPath = 'assets/images/course_type/best.png';
        break;
      case '2':
        iconPath = 'assets/images/course_type/high.png';
        break;
      case '3':
        iconPath = 'assets/images/course_type/private.png';
        break;
      case 'good':
        iconPath = 'assets/images/course_type/good.png';
        break;
      case 'recommend':
        iconPath = 'assets/images/course_type/recommend.png';
        break;
      default:
        iconPath = 'assets/images/course_type/best.png';
    }

    print('加载图片: $iconPath');

    return Image.asset(
      iconPath,
      width: 56.w, // 小程序 112rpx ÷ 2 = 56.w
      height: 28.h, // 小程序 56rpx ÷ 2 = 28.h
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // 图片加载失败时显示占位容器
        print('图片加载失败: $iconPath, 错误: $error');
        return Container(
          width: 56.w,
          height: 28.h,
          decoration: BoxDecoration(
            color: AppColors.courseTagBg,
            borderRadius: AppRadius.radiusXs,
          ),
          child: Icon(
            Icons.image_not_supported,
            size: 16.w,
            color: AppColors.textHint,
          ),
        );
      },
    );
  }

  /// 是否显示有效期时间
  /// 对应小程序 examination-course-item.vue Line 10-13:
  /// v-if="item.type != 8 && item.type != 18 && !item.validity_start_date.startsWith('0001') && !item.validity_end_date.startsWith('0001')"
  bool _shouldShowValidityTime() {
    final typeInt = SafeTypeConverter.toInt(goods.type, defaultValue: 0);
    if (typeInt == 8 || typeInt == 18) return false;
    final start = goods.validityStartDate ?? goods.validityStartDateVal ?? '';
    final end = goods.validityEndDate ?? goods.validityEndDateVal ?? '';
    if (start.isEmpty || end.isEmpty) return false;
    if (start.contains('0001') || end.contains('0001')) return false;
    return true;
  }

  /// 有效期时间行
  /// 对应小程序: {{ item.validity_start_date }} - {{ item.validity_end_date }}
  Widget _buildValidityTime() {
    final start = goods.validityStartDate ?? goods.validityStartDateVal ?? '';
    final end = goods.validityEndDate ?? goods.validityEndDateVal ?? '';
    return Text(
      '$start – $end',
      style: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textHint,
        fontSize: 14.sp,
      ),
    );
  }

  /// 标签
  Widget _buildTags() {
    return Wrap(
      spacing: AppSpacing.sm,
      children: [
        if (goods.teachingTypeName != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.courseTagBg,
              borderRadius: BorderRadius.circular(2.r),
            ),
            child: Text(
              goods.teachingTypeName!,
              style: AppTextStyles.courseTag,
            ),
          ),
        if (goods.serviceTypeName != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(2.r),
            ),
            child: Text(
              goods.serviceTypeName!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
      ],
    );
  }

  /// 价格行
  Widget _buildPriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(),
        if (goods.permissionStatus == '2' && 
            goods.salePrice != null && 
            goods.salePrice!.isNotEmpty)
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('¥', style: AppTextStyles.coursePriceSymbol),
              Text('${goods.salePrice}', style: AppTextStyles.coursePriceNumber),
            ],
          ),
      ],
    );
  }

  /// 底部信息（学习计划和已购人数，一行显示两个）
  /// 对应小程序: examination-course-item.vue Line 26-29
  /// 小程序显示: {{ item.new_type_name }} | {{ item.student_num }}人购买
  Widget _buildBottomInfo() {
    // ✅ 获取已购人数（对应小程序 item.student_num）
    final studentNum = SafeTypeConverter.toInt(goods.studentNum, defaultValue: 0);
    final purchaseText = studentNum > 0 ? '$studentNum人购买' : '0人购买';

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      padding: EdgeInsets.only(top: 6.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ✅ 学习计划（左侧，对应小程序 item.new_type_name）
          Expanded(
            child: Text(
              goods.newTypeName ?? '学习计划',
              style: AppTextStyles.courseSecondary,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(width: 12.w),
          // ✅ 已购人数（右侧，对应小程序 {{ item.student_num }}人购买）
          Expanded(
            child: Text(
              purchaseText,
              style: AppTextStyles.courseSecondary,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
