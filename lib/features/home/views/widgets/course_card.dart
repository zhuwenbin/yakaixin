import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 1.r,
              offset: Offset(0, 1),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4.r,
              offset: Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8.r,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            SizedBox(height: 10.h),
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
        // 课程类型图标 (对应小程序 course-type 组件)
        // 总是显示，因为 computeShopType() 会返回默认值
        _buildCourseTypeIcon(),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            goods.goodsName ?? '未命名课程',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              height: 1.4,
            ),
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
    print('课程卡片 - 商品名称: ${goods.goodsName}, 计算后的 shop_type: $shopType');
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
            color: Color(0xFFE3EBFF),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Icon(
            Icons.image_not_supported,
            size: 16.w,
            color: Colors.grey,
          ),
        );
      },
    );
  }

  /// 标签
  Widget _buildTags() {
    return Wrap(
      spacing: 8.w,
      children: [
        if (goods.teachingTypeName != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Color(0xFFE3EBFF),
              borderRadius: BorderRadius.circular(2.r),
            ),
            child: Text(
              goods.teachingTypeName!,
              style: TextStyle(
                fontSize: 12.sp,
                color: Color(0xFF2E68FF),
              ),
            ),
          ),
        if (goods.serviceTypeName != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(2.r),
            ),
            child: Text(
              goods.serviceTypeName!,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
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
        SizedBox(),
        if (goods.permissionStatus == '2' && 
            goods.price != null && 
            goods.price.toString().isNotEmpty)
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '¥',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFFF7600),
                ),
              ),
              Text(
                '${goods.price}',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF7600),
                ),
              ),
            ],
          ),
      ],
    );
  }

  /// 底部信息
  Widget _buildBottomInfo() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE5E5E5), width: 1),
        ),
      ),
      padding: EdgeInsets.only(top: 6.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              goods.newTypeName ?? '',
              style: TextStyle(
                fontSize: 12.sp,
                color: Color(0xA603203D),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${goods.studentNum ?? 0}人购买',
            style: TextStyle(
              fontSize: 12.sp,
              color: Color(0xA603203D),
            ),
          ),
        ],
      ),
    );
  }
}
