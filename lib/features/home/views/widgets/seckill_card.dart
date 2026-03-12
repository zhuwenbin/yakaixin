import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/style/app_style_provider.dart';
import '../../../../core/style/app_style_presets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../models/goods_model.dart';
import 'countdown_timer.dart';
import '../../../../../app/constants/storage_keys.dart';
import '../../../../core/storage/storage_service.dart';

/// 秒杀卡片组件
/// 对应小程序: examination-test-item (seckill模式)
class SeckillCard extends ConsumerStatefulWidget {
  final GoodsModel goods;
  final VoidCallback? onTap;

  const SeckillCard({required this.goods, this.onTap, super.key});

  @override
  ConsumerState<SeckillCard> createState() => _SeckillCardState();
}

class _SeckillCardState extends ConsumerState<SeckillCard> {
  /// 计算倒计时时间（秒）
  /// 对应小程序: setTime() 方法 (Line 164-181)
  /// 逻辑：
  /// 1. 从本地存储读取开始时间戳
  /// 2. 总倒计时时间 = 8小时 = 28800秒
  /// 3. 如果存储有值，计算剩余时间 = 总时间 - (当前时间 - 存储时间)
  /// 4. 如果剩余时间 < 0，重新设置开始时间
  /// 5. 如果存储没有值，设置当前时间为开始时间
  int _calculateCountdownSeconds() {
    final storage = ref.read(storageServiceProvider);
    final key = StorageKeys.seckillCountdownTime;
    final storedTimeStr = storage.getString(key);

    final now = DateTime.now();
    final totalSeconds = 8 * 3600; // 8小时 = 28800秒

    // 设置开始时间的函数
    void setStartTime() {
      storage.setString(key, now.millisecondsSinceEpoch.toString());
    }

    if (storedTimeStr != null && storedTimeStr.isNotEmpty) {
      try {
        final storedTime = DateTime.fromMillisecondsSinceEpoch(
          int.parse(storedTimeStr),
        );
        final elapsed = now.difference(storedTime).inSeconds;
        final remaining = totalSeconds - elapsed;

        if (remaining > 0) {
          return remaining;
        } else {
          // 剩余时间 < 0，重新开始
          setStartTime();
          return totalSeconds;
        }
      } catch (e) {
        // 解析失败，重新开始
        setStartTime();
        return totalSeconds;
      }
    } else {
      // 没有存储，设置当前时间为开始时间
      setStartTime();
      return totalSeconds;
    }
  }

  /// 重新开始倒计时（倒计时结束时调用）
  /// 对应小程序: @finish="setTime()"
  void _restartCountdown() {
    setState(() {
      // 重新计算倒计时时间，会触发重新设置开始时间
      _calculateCountdownSeconds();
    });
  }

  /// 格式化价格：去除小数点后不必要的0
  /// 例如：9.90 → 9.9, 199.00 → 199, 199.0 → 199, 29.9 → 29.9
  /// ✅ 对应小程序：价格显示时自动去除尾随0
  String _formatPrice(String? price) {
    if (price == null || price.isEmpty) return '';
    try {
      final numValue = double.parse(price);
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
      formatted = formatted.replaceAll(
        RegExp(r'\.0+$'),
        '',
      ); // 去除 .0, .00, .000 等
      formatted = formatted.replaceAll(
        RegExp(r'\.(\d*?)0+$'),
        r'.$1',
      ); // 去除尾随的0
      return formatted;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 小程序：.item { padding: 24rpx 32rpx 0rpx 32rpx; margin-bottom: 24rpx; }
    // 即：padding-top: 24rpx (12.h), padding-right: 32rpx (16.w), padding-bottom: 0, padding-left: 32rpx (16.w)
    // margin-bottom: 24rpx (12.h)
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(
          bottom: 12.h,
        ), // ✅ 小程序margin-bottom: 24rpx ÷ 2 = 12.h
        padding: EdgeInsets.fromLTRB(
          16.w, // ✅ 小程序padding-left: 32rpx ÷ 2 = 16.w
          12.h, // ✅ 小程序padding-top: 24rpx ÷ 2 = 12.h
          16.w, // ✅ 小程序padding-right: 32rpx ÷ 2 = 16.w
          0, // ✅ 小程序padding-bottom: 0
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFBF1FF), // ✅ 小程序.item-background 起始色 #FBF1FF
              Color(0xFFD8F0FF), // ✅ 小程序.item-background 结束色 #D8F0FF
            ],
            begin:
                Alignment.centerLeft, // ✅ 小程序 linear-gradient(90deg, ...) 从左到右
            end: Alignment.centerRight,
            stops: const [0.0, 1.0], // ✅ 小程序 0%, 100%
          ),
          borderRadius: AppRadius.radiusLg,
          boxShadow: [
            BoxShadow(
              color: AppColors.seckillShadow,
              blurRadius: 15.r,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none, // ✅ 允许倒计时区域超出卡片边界
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                _buildTags(ref.watch(appStyleTokensProvider).colors),
              ],
            ),
            _buildCountdown(), // ✅ 倒计时区域使用Positioned定位，延伸到卡片右边缘
          ],
        ),
      ),
    );
  }

  /// 头部：商品名称 + 价格（同一行）
  /// ✅ 对应小程序: .header { display: flex; justify-content: space-between; }
  /// 小程序标题使用 text-ellipsis-2（两行），但能根据内容自动扩展，一行能显示完就一行显示
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ 标题（左侧，单行，超出显示...）
        // ⚠️ 修复：秒杀标题不换行，字体小一号（32rpx）
        // 小程序：.name { font-size: 34rpx; font-weight: 500; color: #000000; }
        // 秒杀模式：字体小一号（32rpx），单行显示
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 0.w), // ✅ 标题和价格之间的间距
            child: Text(
              widget.goods.name ?? '',
              style: TextStyle(
                fontSize:
                    16.sp, // ✅ 秒杀模式字体小一号：32rpx ÷ 2 = 16.sp（原34rpx ÷ 2 = 17.sp）
                fontWeight: FontWeight.w500, // ✅ 小程序font-weight: 500
                color: Colors.black, // ✅ 小程序color: #000000
                letterSpacing: 0, // ✅ 确保字符间距为0，避免字体变粗的视觉效果
              ),
              maxLines: 1, // ✅ 秒杀模式：不换行，单行显示
              overflow: TextOverflow.ellipsis, // ✅ 超出显示...
            ),
          ),
        ),
        // ✅ 价格（右侧，flex-shrink: 0，与小程序一致）
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            // ✅ 原价 + 秒杀价标签（对应小程序 .original_price）
            // ⚠️ 小程序中，秒杀价标签图片总是显示在秒杀模式下
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.goods.originalPrice != null &&
                    widget.goods.originalPrice.toString().isNotEmpty) ...[
                  Text(
                    _formatPrice(
                      widget.goods.originalPrice?.toString(),
                    ), // ✅ 去除小数点后不必要的0
                    style: TextStyle(
                      fontSize: 16
                          .sp, // ✅ 小程序.price2 .huaxian font-size: 32rpx ÷ 2 = 16.sp
                      fontWeight: FontWeight
                          .w700, // ⚠️ 修复：Android上w800显示过粗，使用w700更接近小程序效果
                      color: const Color(0xFFA3A3A3), // ✅ 小程序color: #a3a3a3
                      decoration: TextDecoration.lineThrough, // ✅ 删除线
                      letterSpacing: 0, // ✅ 确保字符间距为0
                    ),
                  ),
                  SizedBox(
                    width: 3.w,
                  ), // ✅ 小程序.price2 .huaxian margin-right: 10rpx ÷ 2 = 5.w
                ],
                // ✅ 秒杀价标签图片（对应小程序 .miaoshajia）
                // ⚠️ 小程序中，这个图片在秒杀模式下总是显示，即使没有原价
                // 小程序样式：width: 70rpx; height: 30rpx; margin-right: 10rpx; margin-left: 8rpx;
                Padding(
                  padding: EdgeInsets.only(
                    left: 3.w, // ✅ 小程序.miaoshajia margin-left: 8rpx ÷ 2 = 4.w
                    right:
                        3.w, // ✅ 小程序.miaoshajia margin-right: 10rpx ÷ 2 = 5.w
                  ),
                  // ✅ 使用 Image.network 避免 iOS Release 模式 Content-Disposition 问题
                  child: Image.network(
                    'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/92ac17422896646546913_miaoshajia.png', // ✅ 小程序完整URL，确保图片正确显示
                    width: 35.w, // ✅ 小程序70rpx ÷ 2 = 35.w
                    height: 15.h, // ✅ 小程序30rpx ÷ 2 = 15.h
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // ✅ 如果图片加载失败，显示红色占位符以便调试
                      return Container(
                        width: 35.w,
                        height: 15.h,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                        child: Center(
                          child: Text(
                            '秒杀价',
                            style: TextStyle(fontSize: 8.sp, color: Colors.red),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (widget.goods.originalPrice != null &&
                    widget.goods.originalPrice.toString().isNotEmpty)
                  SizedBox(
                    width: 5.w,
                  ), // ✅ 小程序.miaoshajia margin-right: 10rpx ÷ 2 = 5.w
              ],
            ),
            if (widget.goods.salePrice != null &&
                widget.goods.salePrice!.isNotEmpty)
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '￥', // ✅ 小程序使用￥符号
                    style: TextStyle(
                      fontSize: 12
                          .sp, // ✅ 小程序.price2 .fuhao font-size: 24rpx ÷ 2 = 12.sp
                      fontWeight: FontWeight.w500, // ✅ 小程序font-weight: 500
                      color: const Color(
                        0xFFD845A6,
                      ), // ✅ 小程序.price2 .fuhao color: #D845A6
                      letterSpacing: 0, // ✅ 确保字符间距为0
                    ),
                  ),
                  Text(
                    _formatPrice(widget.goods.salePrice), // ✅ 去除小数点后不必要的0
                    style: TextStyle(
                      fontSize: 20
                          .sp, // ✅ 小程序.price2 .jine font-size: 40rpx ÷ 2 = 20.sp
                      fontWeight: FontWeight
                          .w700, // ⚠️ 修复：Android上w800显示过粗，使用w700更接近小程序效果
                      color: const Color(
                        0xFFFF5E00,
                      ), // ✅ 小程序.price2 color: #ff5e00 (继承到.jine)
                      letterSpacing: 0, // ✅ 确保字符间距为0
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  /// 标签区域（使用样式模板 tagBg/tagText/tagBorder）
  /// ✅ 对应小程序: .tags (Line 29-50)
  Widget _buildTags(AppColorPalette colors) {
    final goods = widget.goods;
    final typeInt = int.tryParse(goods.type?.toString() ?? '') ?? 0;

    // ✅ 检查 permission_status（可能是字符串或数字，统一转换为字符串比较）
    final permissionStatus = goods.permissionStatus?.toString() ?? '';

    // ✅ 计算 month_text（对应小程序 Line 373-400）
    // 小程序逻辑：
    // 1. 如果 months_prices 为空或不存在，返回 '永久'
    // 2. 如果有数据，从排序后的第一个价格项中取 month，计算 month_text
    String? monthText;

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
      final monthValue = firstPrice['month'];
      int monthInt = 0;

      if (monthValue is int) {
        monthInt = monthValue;
      } else if (monthValue is String) {
        monthInt = int.tryParse(monthValue) ?? 0;
      } else if (monthValue != null) {
        monthInt = int.tryParse(monthValue.toString()) ?? 0;
      }

      monthText = monthInt == 0 ? '永久' : '$monthInt个月';
    } else if (goods.month != null) {
      // ✅ 如果没有 months_prices，尝试从 month 字段获取（列表接口可能直接返回）
      // ⚠️ 注意：month 可能是 String 或 int，需要统一处理
      int monthInt = 0;
      if (goods.month is int) {
        monthInt = goods.month as int;
      } else if (goods.month is String) {
        final monthStr = goods.month as String;
        if (monthStr.isNotEmpty && monthStr != 'null') {
          monthInt = int.tryParse(monthStr) ?? 0;
        }
      } else {
        // 尝试转换为字符串再解析
        final monthStr = goods.month.toString();
        if (monthStr.isNotEmpty && monthStr != 'null') {
          monthInt = int.tryParse(monthStr) ?? 0;
        }
      }

      monthText = monthInt == 0 ? '永久' : '$monthInt个月';
    } else {
      // ✅ 如果 month 字段和 months_prices 都为空，且 permission_status == '2'，显示"永久"（对应小程序 Line 373-380）
      if (permissionStatus == '2') {
        monthText = '永久';
      }
    }

    return Padding(
      padding: EdgeInsets.only(
        top: 10.h,
        bottom: 12.h,
      ), // ✅ 小程序padding-bottom: 24rpx ÷ 2 = 12.h
      child: Wrap(
        spacing: 12.w, // ✅ 小程序margin-right: 12rpx ÷ 2 = 12.w
        children: [
          // ✅ 第一个标签：秒杀时「共 X 题」与小程序 .ee-seckill-q / .ee-seckill-q-row 一致
          // 小程序：background #FFD27C，共/题 黑色，数字 红色，font-weight 600，border-radius 8rpx，padding 4rpx 16rpx
          if (goods.tikuGoodsDetails?.questionNum != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD27C),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF000000),
                  ),
                  children: [
                    const TextSpan(text: '共 '),
                    TextSpan(
                      text: '${goods.tikuGoodsDetails!.questionNum}',
                      style: const TextStyle(
                        color: Color(0xFFFF0000),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(text: ' 题'),
                  ],
                ),
              ),
            ),
          // ✅ 第二个标签：type == 8 时显示边框样式的"共X题"
          if (typeInt == 8 && goods.tikuGoodsDetails?.questionNum != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                border: Border.all(color: colors.tagBorder, width: 1.0),
                borderRadius: BorderRadius.circular(4.r),
                color: Colors.transparent,
              ),
              child: Text(
                '共${goods.tikuGoodsDetails!.questionNum}题',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: colors.tagText,
                ),
              ),
            ),
          // ✅ 第三个标签：permission_status == '2' 时显示 month_text
          if (permissionStatus == '2' && monthText != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                border: Border.all(color: colors.tagBorder, width: 1.0),
                borderRadius: BorderRadius.circular(4.r),
                color: Colors.transparent,
              ),
              child: Text(
                monthText,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: colors.tagText,
                ),
              ),
            ),
          // ✅ 第四个标签：validity_start_date && permission_status == '1' 时显示有效期
          if (goods.validityStartDate != null &&
              goods.validityStartDate!.isNotEmpty &&
              permissionStatus == '1')
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                color: Colors.transparent,
              ),
              child: Text(
                _formatValidity(goods.validityStartDate, goods.validityEndDate),
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: colors.tagText,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 格式化有效期文本
  /// 对应小程序 validity() 方法 (Line 158-163)
  String _formatValidity(String? startDate, String? endDate) {
    if (startDate == null || startDate.isEmpty) return '';

    // ✅ 如果开始日期包含 "0001"，显示"有效期：永久"
    if (startDate.contains('0001')) {
      return '有效期：永久';
    }

    // ✅ 否则显示日期范围
    final end = endDate ?? '';
    return '有效期：$startDate~$end';
  }

  /// 倒计时区域
  /// ✅ 对应小程序: .bottom-time (L71-76) 和 count-down.vue
  /// 小程序结构：
  /// - .bottom-time { width: 100%; height: 72rpx; right: -32rpx; bottom: 0; position: relative; }
  /// - .pay-time { position: absolute; bottom: -2rpx; right: 0; width: 70%; height: 94rpx; padding-top: 22rpx; }
  Widget _buildCountdown() {
    // ✅ 使用小程序逻辑：从存储读取时间，8小时倒计时
    // 对应小程序: setTime() 方法 (Line 164-181)
    final int countdownSeconds = _calculateCountdownSeconds();

    // ✅ 小程序：.bottom-time { right: -32rpx; } 用于抵消卡片的 padding-right: 32rpx
    // 这样倒计时背景可以延伸到卡片右边缘
    return Positioned(
      left: -16.w, // ✅ 小程序right: -32rpx ÷ 2 = -16.w（向左偏移，抵消padding-right）
      right: -16.w, // ✅ 同时设置right，确保宽度扩展到卡片边缘
      bottom: 0, // ✅ 小程序bottom: 0
      height: 36.h, // ✅ 小程序.bottom-time height: 72rpx ÷ 2 = 36.h
      child: LayoutBuilder(
        builder: (context, constraints) {
          // ✅ 计算倒计时背景宽度：70% 的容器宽度（对应小程序 width: 70%）
          final countdownWidth = constraints.maxWidth * 0.7;

          return Stack(
            clipBehavior: Clip.none, // ✅ 允许内容超出Stack边界，避免被裁剪
            children: [
              // ✅ 背景图片（对应小程序 .pay-time background-image）
              // 小程序：position: absolute; bottom: -2rpx; right: 0; width: 70%; height: 94rpx;
              // 小程序：display: flex; align-items: center; justify-content: center; padding-top: 22rpx;
              // ⚠️ 注意：小程序虽然有 padding-top: 22rpx，但 align-items: center 会让内容垂直居中
              // 在 Flutter 中，使用 alignment: Alignment.center 实现完全居中，不使用 padding-top
              // ✅ 与小程序 .pay-time 一致：width 70%，height 94rpx → 47.h
              Positioned(
                right: 0,
                bottom: -1.h,
                child: Container(
                  width: countdownWidth,
                  height: 47.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      bottomRight: Radius.circular(16.r),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/5e91174186068572265789_daojishiback.png',
                      ),
                      fit: BoxFit.cover,
                      onError: (_, __) {},
                    ),
                  ),
                  // ✅ 倒计时内容（对应小程序 .pay-time 内容）
                  // 小程序：display: flex; align-items: center; justify-content: center;
                  // ⚠️ 修复：移除 padding-top，使用 alignment: Alignment.center 实现完全居中
                  alignment: Alignment
                      .center, // ✅ 小程序 align-items: center; justify-content: center;（完全居中）
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // ✅ 小程序 justify-content: center;（水平居中）
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // ✅ 小程序 align-items: center;（垂直居中）
                    children: [
                      Text(
                        '秒杀倒计时',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF000000),
                          letterSpacing: 3.w,
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ), // ✅ 小程序margin-right: 10rpx ÷ 2 = 5.w
                      // ✅ 倒计时组件（对应小程序 count-down.vue），数字块背景使用模板主色
                      CountdownTimer(
                        durationSeconds: countdownSeconds,
                        boxBackgroundColor: ref
                            .watch(appStyleTokensProvider)
                            .colors
                            .primary,
                        onFinish: () {
                          _restartCountdown();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    /* ⚠️ 以下代码暂时注释，不要删除
    return SizedBox(
      height: 40.h,
      child: Align(
        alignment: Alignment.bottomRight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = math.min(constraints.maxWidth * 0.9, 400.w);
            final minWidth = math.min(constraints.maxWidth * 0.7, maxWidth);
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
                minWidth: minWidth,
              ),
              child: Stack(
                children: [
                  // 背景图片
                  Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          ApiConfig.completeImageUrl('public/5e91174186068572265789_daojishiback.png'),
                        ),
                        fit: BoxFit.cover,
                        onError: (_, __) {},
                      ),
                    ),
                  ),
                  // ✅ 倒计时内容 - 固定在 bottom: 20.h
                  Positioned(
                    bottom: 2.h, // ✅ 固定距离底部 2px
                    left: 0,
                    right: 0,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '秒杀倒计时',
                              style: AppTextStyles.seckillCountdown,
                            ),
                            SizedBox(width: 10.w),
                            // ✅ 接入真实倒计时组件
                            CountdownTimer(
                              durationSeconds: countdownSeconds,
                              onFinish: () {
                                // print('⏰ 秒杀倒计时结束 - 商品ID: ${goods.goodsId}');
                                // TODO: 倒计时结束后的处理逻辑
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
    */
  }
}
