import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 商品详情页(经典版)
/// 对应小程序: pages/test/detail
class GoodsDetailPage extends ConsumerWidget {
  final String? productId;
  final String? goodsId;
  final String? professionalId;
  final String? active;

  const GoodsDetailPage({
    super.key,
    this.productId,
    this.goodsId,
    this.professionalId,
    this.active,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('商品详情'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart,
              size: 80.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 20.h),
            Text(
              '商品详情页',
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              '功能开发中...',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[500],
              ),
            ),
            if (productId != null)
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Text(
                  'ID: $productId',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[400],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
