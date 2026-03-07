import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/style/app_style_config.dart';
import '../../../../core/style/app_style_tokens.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../models/goods_model.dart';

/// 商品卡片组件（题库）
/// 对应小程序: examination-test-item (普通模式)
/// [styleTokens] 不为空时标签使用模板色 tagBg/tagText/tagBorder
class GoodsCard extends StatelessWidget {
  final GoodsModel goods;
  final VoidCallback? onTap;
  final AppStyleTokens? styleTokens;

  const GoodsCard({
    required this.goods,
    this.onTap,
    this.styleTokens,
    super.key,
  });

  /// 格式化价格：去除小数点后不必要的0
  /// 例如：9.90 → 9.9, 199.00 → 199, 199.0 → 199, 29.9 → 29.9
  /// ⚠️ 特殊处理：零元课（价格为0）显示 0.00
  /// ✅ 对应小程序：价格显示时自动去除尾随0
  String _formatPrice(String? price) {
    if (price == null || price.isEmpty) return '';
    try {
      final numValue = double.parse(price);
      // ✅ 零元课（价格为0）显示 0.00
      if (numValue == 0) {
        return '0.00';
      }
      // 先转换为字符串
      String formatted = numValue.toString();
      // 使用正则表达式去除小数点后的尾随0和小数点（如果所有小数位都是0）
      formatted = formatted.replaceAll(
        RegExp(r'\.0+$'),
        '',
      ); // 去除 .0, .00, .000 等
      formatted = formatted.replaceAll(
        RegExp(r'\.(\d*?)0+$'),
        r'.$1',
      ); // 去除尾随的0，如 .90 → .9
      return formatted;
    } catch (e) {
      // 如果解析失败，尝试直接处理字符串
      String formatted = price;
      // ✅ 零元课（价格为0）显示 0.00
      if (formatted == '0' || formatted == '0.0' || formatted == '0.00') {
        return '0.00';
      }
      formatted = formatted.replaceAll(RegExp(r'\.0+$'), '');
      formatted = formatted.replaceAll(RegExp(r'\.(\d*?)0+$'), r'.$1');
      return formatted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBlueDefault = styleTokens?.config.template == AppStyleTemplate.blueDefault;
    final cardBg = (styleTokens != null && !isBlueDefault)
        ? const Color(0xFFF7F9FC)
        : AppColors.card;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: AppSpacing.mdV),
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.mdV,
          AppSpacing.md,
          AppSpacing.mdV,
        ),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: AppRadius.radiusLg,
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.06),
              blurRadius: 15.r,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: AppSpacing.mdV),
            _buildTags(),
            // ✅ 开考时间（对应小程序 Line 52-54: .path）
            // 小程序：v-if="info.system_id_name && !seckill"
            // 小程序逻辑：if (item.type == 10) { system_id_name = `开考时间:${info.exam_time}` }
            if (_getSystemIdName() != null && _getSystemIdName()!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(
                  bottom: 12.h,
                ), // ✅ 小程序 .path padding-bottom: 24rpx ÷ 2 = 12.h
                child: Text(
                  _getSystemIdName()!,
                  style: TextStyle(
                    fontSize:
                        12.sp, // ✅ 小程序 .path .text font-size: 12px = 12.sp
                    color: const Color(
                      0xFF03203D,
                    ).withOpacity(0.65), // ✅ 小程序 color: rgba(3, 32, 61, 0.65)
                  ),
                ),
              ),
            // ⚠️ 修复：只有已购买 + type == 18（章节练习）才显示底部按钮（对应小程序 Line 55）
            // if (goods.permissionStatus == '1' && goods.type.toString() == '18')
            //   _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  /// 计算价格（对应小程序 months_prices() 方法 Line 373-408）
  /// 小程序逻辑：
  /// 1. 如果 months_prices 为空，使用 item.sale_price
  /// 2. 如果有 months_prices，从排序后的第一个价格项中取 sale_price 和 original_price
  String? _getSalePrice() {
    // ✅ 优先从 months_prices 数组中获取（对应小程序 Line 382-400）
    if (goods.monthsPrices != null && goods.monthsPrices!.isNotEmpty) {
      // ✅ 排序：永久（month == 0）排最后，其他按 month 从小到大排序
      final sortedPrices = List<Map<String, dynamic>>.from(goods.monthsPrices!)
        ..sort((a, b) {
          final aMonth = int.tryParse(a['month']?.toString() ?? '0') ?? 0;
          final bMonth = int.tryParse(b['month']?.toString() ?? '0') ?? 0;
          if (aMonth == 0) return 1; // 永久排最后
          if (bMonth == 0) return -1;
          return aMonth.compareTo(bMonth);
        });

      // ✅ 取排序后的第一个价格项
      final firstPrice = sortedPrices.first;
      final salePrice = firstPrice['sale_price'];
      if (salePrice != null) {
        return salePrice.toString();
      }
    }

    // ✅ 如果没有 months_prices，使用 salePrice 字段（对应小程序 Line 375）
    if (goods.salePrice != null && goods.salePrice!.isNotEmpty) {
      return goods.salePrice;
    }

    return null;
  }

  String? _getOriginalPrice() {
    // ✅ 优先从 months_prices 数组中获取（对应小程序 Line 382-400）
    if (goods.monthsPrices != null && goods.monthsPrices!.isNotEmpty) {
      // ✅ 排序：永久（month == 0）排最后，其他按 month 从小到大排序
      final sortedPrices = List<Map<String, dynamic>>.from(goods.monthsPrices!)
        ..sort((a, b) {
          final aMonth = int.tryParse(a['month']?.toString() ?? '0') ?? 0;
          final bMonth = int.tryParse(b['month']?.toString() ?? '0') ?? 0;
          if (aMonth == 0) return 1; // 永久排最后
          if (bMonth == 0) return -1;
          return aMonth.compareTo(bMonth);
        });

      // ✅ 取排序后的第一个价格项
      final firstPrice = sortedPrices.first;
      final originalPrice = firstPrice['original_price'];
      if (originalPrice != null &&
          originalPrice.toString() != '0' &&
          originalPrice.toString().isNotEmpty) {
        return originalPrice.toString();
      }
    }

    // ✅ 如果没有 months_prices，使用 originalPrice 字段（对应小程序 Line 376）
    if (goods.originalPrice != null) {
      final originalPriceStr = goods.originalPrice.toString();
      if (originalPriceStr.isNotEmpty &&
          originalPriceStr != '0' &&
          originalPriceStr != 'null') {
        return originalPriceStr;
      }
    }

    return null;
  }

  /// 头部：商品名称 + 价格
  /// ⚠️ 价格只在未购买时显示（对应小程序 Line 19: v-if="!isPay && !seckill && item.permission_status == '2'"）
  Widget _buildHeader() {
    // ✅ 计算价格（从 months_prices 或直接字段获取）
    final salePrice = _getSalePrice();
    final originalPrice = _getOriginalPrice();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 商品名靠左，自动撑开占可用空间
        Expanded(
          child: Text(
            goods.name ?? '未命名商品',
            style: AppTextStyles.tikuCardTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // 现价原价整体靠右：放在一个Column/FittedBox中
        if (goods.permissionStatus == '2' &&
            salePrice != null &&
            salePrice.isNotEmpty)
          Container(
            margin: EdgeInsets.only(left: 12.w),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.topRight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                mainAxisSize: MainAxisSize.min,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  // 先显示原价（如有）
                  if (originalPrice != null && originalPrice.isNotEmpty) ...[
                    Text(
                      _formatPrice(originalPrice),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDisabled,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    SizedBox(width: 10.w),
                  ],
                  // 现价（带符号）
                  Text(
                    '¥',
                    style: AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.error,
                    ),
                  ),
                  Text(
                    _formatPrice(salePrice),
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// 计算 num_text（对应小程序 Line 366-372）
  /// type == 8: 共X份（paper_num）
  /// type == 10: 共X轮（exam_round_num）
  /// 其他: 共X题（question_num）
  String _getNumText() {
    final typeInt = int.tryParse(goods.type?.toString() ?? '') ?? 0;
    final tikuDetails = goods.tikuGoodsDetails;

    if (typeInt == 8) {
      // ✅ 试卷：显示份数（对应小程序 Line 367-368）
      final paperNum = tikuDetails?.paperNum ?? 0;
      return '共$paperNum份';
    } else if (typeInt == 10) {
      // ✅ 模考：显示轮数（对应小程序 Line 370-371）
      final examRoundNum = tikuDetails?.examRoundNum ?? 0;
      return '共$examRoundNum轮';
    } else {
      // ✅ 题库：显示题数（对应小程序 Line 366）
      final questionNum = tikuDetails?.questionNum ?? 0;
      return '共$questionNum题';
    }
  }

  /// 计算 month_text（对应小程序 Line 373-408）
  /// 从 months_prices 数组计算，与秒杀卡片逻辑一致
  String? _getMonthText() {
    if (goods.monthsPrices != null && goods.monthsPrices!.isNotEmpty) {
      // ✅ 排序：永久（month == 0）排最后，其他按 month 从小到大排序
      final sortedPrices = List<Map<String, dynamic>>.from(goods.monthsPrices!)
        ..sort((a, b) {
          final aMonth = int.tryParse(a['month']?.toString() ?? '0') ?? 0;
          final bMonth = int.tryParse(b['month']?.toString() ?? '0') ?? 0;
          if (aMonth == 0) return 1; // 永久排最后
          if (bMonth == 0) return -1;
          return aMonth.compareTo(bMonth);
        });

      // ✅ 取排序后的第一个价格项
      final firstPrice = sortedPrices.first;
      final monthValue = firstPrice['month'];
      int monthInt = 0;
      if (monthValue is int) {
        monthInt = monthValue;
      } else if (monthValue is String) {
        monthInt = int.tryParse(monthValue) ?? 0;
      }
      return monthInt == 0 ? '永久' : '$monthInt个月';
    } else if (goods.month != null) {
      // ✅ 如果没有 months_prices，使用 month 字段
      int monthInt = 0;
      if (goods.month is int) {
        monthInt = goods.month as int;
      } else if (goods.month is String) {
        monthInt = int.tryParse(goods.month as String) ?? 0;
      } else {
        final monthStr = goods.month.toString();
        if (monthStr.isNotEmpty && monthStr != 'null') {
          monthInt = int.tryParse(monthStr) ?? 0;
        }
      }
      return monthInt == 0 ? '永久' : '$monthInt个月';
    } else {
      // ✅ 如果都没有，默认永久（对应小程序 Line 377）
      return '永久';
    }
  }

  /// 格式化有效期文本（对应小程序 validity() 方法）
  String _formatValidity(String? startDate, String? endDate) {
    if (startDate == null || startDate.isEmpty) {
      return '有效期：永久';
    }
    if (startDate.startsWith('0001')) {
      return '有效期：永久';
    }
    return '有效期：$startDate~$endDate';
  }

  /// 计算 system_id_name（对应小程序 months_prices() 方法 Line 360-364）
  /// 小程序逻辑：
  /// 1. 默认：system_id_name = item?.teaching_system?.system_id_name || ''
  /// 2. 如果 type == 10：system_id_name = `开考时间:${info.exam_time}`
  /// ⚠️ 注意：如果 exam_time 为空或null，应该显示"开考时间: 不限"或"开考时间: 不限"
  String? _getSystemIdName() {
    final typeInt = int.tryParse(goods.type?.toString() ?? '') ?? 0;

    // ✅ type == 10（模考）时，显示开考时间（对应小程序 Line 362-364）
    if (typeInt == 10) {
      final examTime = goods.tikuGoodsDetails?.examTime;
      // ✅ 如果 exam_time 为空或null，显示"开考时间: 不限"（对应小程序可能显示"不限"）
      if (examTime == null || examTime.isEmpty) {
        return '开考时间: 不限';
      }
      return '开考时间:$examTime';
    }

    // ✅ 其他情况：返回 teaching_system.system_id_name（如果有）
    if (goods.teachingSystem != null) {
      final systemIdName = goods.teachingSystem!['system_id_name']?.toString();
      if (systemIdName != null && systemIdName.isNotEmpty) {
        return systemIdName;
      }
    }

    return null;
  }

  /// 标签（styleTokens 不为空时使用模板 tagBg/tagText/tagBorder）
  Widget _buildTags() {
    final typeInt = int.tryParse(goods.type?.toString() ?? '') ?? 0;
    final permissionStatus = goods.permissionStatus?.toString() ?? '';
    final numText = _getNumText();
    final monthText = _getMonthText();
    final c = styleTokens?.colors;

    final Color tagBgColor = c?.tagBg ?? const Color(0xFFEBF1FF);
    final Color tagTextColor = c?.tagText ?? const Color(0xFF2E68FF);
    final Color tagBorderColor = c?.tagBorder ?? const Color(0xFF4981D7);

    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 12.h),
      child: Wrap(
        spacing: 6.w,
        children: [
          if (permissionStatus != '1')
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: tagBgColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                numText,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: tagTextColor,
                ),
              ),
            ),
          if (typeInt == 8 &&
              goods.tikuGoodsDetails?.questionNum != null &&
              permissionStatus != '1')
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                border: Border.all(color: tagBorderColor, width: 1.0),
                borderRadius: BorderRadius.circular(4.r),
                color: Colors.transparent,
              ),
              child: Text(
                '共${goods.tikuGoodsDetails!.questionNum}题',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: tagTextColor,
                ),
              ),
            ),
          if (permissionStatus == '2' && monthText != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                border: Border.all(color: tagBorderColor, width: 1.0),
                borderRadius: BorderRadius.circular(4.r),
                color: Colors.transparent,
              ),
              child: Text(
                monthText,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: tagTextColor,
                ),
              ),
            ),
          if (goods.validityStartDate != null &&
              goods.validityStartDate!.isNotEmpty &&
              permissionStatus == '1')
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: tagBgColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                _formatValidity(goods.validityStartDate, goods.validityEndDate),
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: tagTextColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 底部按钮（对应小程序 Line 55-70）
  /// 只在 isPay && type == 18 时显示
  Widget _buildActionButton(BuildContext context) {
    return Container(
      height: 50.h,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 80.w,
            height: 28.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(32.r),
            ),
            child: Text(
              // ✅ type == 18 固定显示“立即刷题”（对应小程序 Line 68）
              '立即刷题',
              style: AppTextStyles.tikuButton,
            ),
          ),
        ],
      ),
    );
  }
}
