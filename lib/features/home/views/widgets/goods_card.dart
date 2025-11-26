import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/goods_model.dart';

/// 商品卡片组件（题库）
/// 对应小程序: examination-test-item (普通模式)
class GoodsCard extends StatelessWidget {
  final GoodsModel goods;
  final VoidCallback? onTap;

  const GoodsCard({
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
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 6.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F9FF),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0x0F1B2637),
              blurRadius: 15.r,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildTags(),
            if (goods.permissionStatus == '1') _buildActionButton(context),
          ],
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
            goods.goodsName ?? '未命名商品',
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
        if (goods.price != null && goods.price.toString().isNotEmpty) ...[
          SizedBox(width: 12.w),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.topRight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  if (goods.originalPrice != null && 
                      goods.originalPrice.toString().isNotEmpty) ...[
                    Text(
                      '${goods.originalPrice}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFA3A3A3),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    SizedBox(width: 5.w),
                  ],
                  Text(
                    '¥',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFFF5E00),
                    ),
                  ),
                  Text(
                    '${goods.price}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFFF5E00),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
                color: Color(0xFFEBF1FF),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                '共${goods.tikuGoodsDetails!.questionNum}题',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2E68FF),
                ),
              ),
            ),
          if (goods.type.toString() == '8' && 
              goods.tikuGoodsDetails?.questionNum != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF4981D7), width: 3.w),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                '共${goods.tikuGoodsDetails!.questionNum}题',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF4981D7),
                ),
              ),
            ),
          if (goods.validityDay != null && 
              goods.validityDay!.isNotEmpty && 
              goods.permissionStatus == '1')
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF4981D7), width: 1.5.w),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                goods.validityDay == '0' ? '永久' : '${goods.validityDay}个月',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF4981D7),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 底部按钮
  Widget _buildActionButton(BuildContext context) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE8E9EA), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 80.w,
            height: 28.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xFF2E68FF),
              borderRadius: BorderRadius.circular(32.r),
            ),
            child: Text(
              goods.type.toString() == '18' ? '立即刷题' : '立即测试',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
