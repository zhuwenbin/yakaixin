import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_radius.dart';
import '../models/question_bank_model.dart';
import 'section_title.dart';

/// 已购试题区域
class PurchasedQuestionsSection extends StatelessWidget {
  final List<PurchasedGoodsModel> goods;
  final bool isLoading;
  final Function(PurchasedGoodsModel) onItemTap;

  const PurchasedQuestionsSection({
    super.key,
    required this.goods,
    required this.isLoading,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: '已购试题'),
            SizedBox(height: 12.h),
            const Center(child: CircularProgressIndicator()),
          ],
        ),
      );
    }

    if (goods.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: '已购试题'),
            SizedBox(height: 12.h),
            _buildEmptyState(),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: '已购试题'),
          SizedBox(height: 12.h),
          ...goods.map((item) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _PurchasedItem(
                  goods: item,
                  onTap: () => onItemTap(item),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(40.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radiusLg,
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 50.sp,
              color: AppColors.textDisabled,
            ),
            SizedBox(height: 12.h),
            Text(
              '暂无已购试题',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 已购试题单项
/// 对应小程序: index-nav-item.vue Line 2-20
class _PurchasedItem extends StatelessWidget {
  final PurchasedGoodsModel goods;
  final VoidCallback onTap;

  const _PurchasedItem({
    required this.goods,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // 对应小程序 Line 339-343: 白色背景 + 圆角
        // ⚠️ 小程序 750rpx → Flutter 375dp，需除以2
        padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 20.h), // 对应小程序 32rpx/2=16, 40rpx/2=20
        decoration: BoxDecoration(
          color: Colors.white, // 对应小程序 Line 341
          borderRadius: BorderRadius.circular(16.r), // 对应小程序 32rpx/2=16
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ 标题（对应小程序 Line 5-7）
            Text(
              goods.name,
              style: TextStyle(
                fontSize: 15.sp, // 对应小程序 30rpx/2=15
                fontWeight: FontWeight.w500, // 对应小程序 Line 368
                color: const Color(0xFF161F30), // 对应小程序 Line 369
                height: 1.0, // 对应小程序 Line 370
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            // ✅ 标签区域（对应小程序 Line 8-11）
            SizedBox(height: 10.h), // 对应小程序 20rpx/2=10
            Row(
              children: [
                // ✅ 题目数量标签（对应小程序 Line 9: plain-tag）
                if (goods.numText != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w, // 对应小程序 20rpx/2=10
                      vertical: 5.h, // 对应小程序 10rpx/2=5
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F0FF), // 对应小程序 Line 381
                      borderRadius: BorderRadius.circular(4.r), // 对应小程序 8rpx/2=4
                    ),
                    child: Text(
                      goods.numText!,
                      style: TextStyle(
                        fontSize: 10.sp, // 对应小程序 20rpx/2=10
                        color: const Color(0xFF4783DC), // 对应小程序 Line 382
                      ),
                    ),
                  ),
                
                SizedBox(width: 6.w), // 对应小程序 12rpx/2=6
                
                // ✅ 有效期标签（对应小程序 Line 10: custom-tag）
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w, // 对应小程序 20rpx/2=10
                    vertical: 5.h, // 对应小程序 10rpx/2=5
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF1F2), // 对应小程序 Line 390
                    borderRadius: BorderRadius.circular(4.r), // 对应小程序 8rpx/2=4
                  ),
                  child: Text(
                    _formatValidity(goods),
                    style: TextStyle(
                      fontSize: 10.sp, // 对应小程序 20rpx/2=10
                      color: const Color(0xFF777777), // 对应小程序 Line 391
                    ),
                  ),
                ),
              ],
            ),
            
            // ✅ 开考时间（对应小程序 Line 12-15）
            SizedBox(height: 20.h), // 对应小程序 40rpx/2=20
            Text(
              '开考时间:${goods.createdAt ?? "-"}',
              style: TextStyle(
                fontSize: 12.sp, // 对应小程序 24rpx/2=12
                color: const Color(0xFF777777), // 对应小程序 Line 440
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 格式化有效期
  /// 对应小程序 Line 65-81
  String _formatValidity(PurchasedGoodsModel goods) {
    // 检查是否有有效期字段
    if (goods.validityStartDate == null || goods.validityEndDate == null) {
      return '有效期：永久';
    }

    // 检查是否包含 "0001" (永久)
    if (goods.validityStartDate!.contains('0001')) {
      return '有效期：永久';
    }

    // 返回有效期范围
    return '有效期：${goods.validityStartDate}~${goods.validityEndDate}';
  }
}
