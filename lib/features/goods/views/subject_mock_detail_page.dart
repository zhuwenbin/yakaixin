import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/subject_mock_detail_provider.dart';
import '../models/goods_detail_model.dart';
import '../../../core/utils/safe_type_converter.dart';

/// P5-1-3 科目模考商品详情页
/// 对应小程序: modules/jintiku/pages/test/subjectMockDetail.vue
class SubjectMockDetailPage extends ConsumerStatefulWidget {
  final String? productId;
  final String? professionalId;

  const SubjectMockDetailPage({super.key, this.productId, this.professionalId});

  @override
  ConsumerState<SubjectMockDetailPage> createState() =>
      _SubjectMockDetailPageState();
}

class _SubjectMockDetailPageState extends ConsumerState<SubjectMockDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.productId != null && widget.productId!.isNotEmpty) {
        ref
            .read(subjectMockDetailNotifierProvider.notifier)
            .loadDetail(widget.productId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subjectMockDetailNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('科目模考'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: state.isLoading
          ? _buildLoading()
          : state.error != null
          ? _buildError(state.error!)
          : state.goodsDetail != null
          ? _buildContent(state.goodsDetail!)
          : _buildEmpty(),
      bottomNavigationBar: state.goodsDetail != null
          ? _buildBottomBar(state.goodsDetail!)
          : null,
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16.h),
          Text('加载中...', style: TextStyle(fontSize: 14.sp)),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(50.h),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.red.shade300),
            SizedBox(height: 16.h),
            Text(error, textAlign: TextAlign.center),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                if (widget.productId != null) {
                  ref
                      .read(subjectMockDetailNotifierProvider.notifier)
                      .refresh(widget.productId!);
                }
              },
              child: Text('重试'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Text('暂无数据', style: TextStyle(fontSize: 14.sp)),
    );
  }

  Widget _buildContent(GoodsDetailModel detail) {
    // 科目模考显示长图介绍（对应小程序 Line 4-6）
    final longImagePath = detail.longImgPath;
    
    // ✅ 对照小程序 Line 444: this.longImagePath = this.completepath(res.data.long_img_path)
    // ✅ completepath 逻辑：如果不是 http 开头，则补全 OSS 域名
    String? completeImageUrl;
    if (longImagePath != null && longImagePath.isNotEmpty) {
      if (longImagePath.startsWith('http')) {
        completeImageUrl = longImagePath;
      } else {
        completeImageUrl = 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/$longImagePath';
      }
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          if (completeImageUrl != null && completeImageUrl.isNotEmpty)
            CachedNetworkImage(
              imageUrl: completeImageUrl,
              fit: BoxFit.fitWidth,
              placeholder: (context, url) => Container(
                height: 200.h,
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, error, stackTrace) {
                return Container(
                  padding: EdgeInsets.all(50.h),
                  child: Column(
                    children: [
                      Icon(Icons.image, size: 64.sp, color: Colors.grey),
                      SizedBox(height: 16.h),
                      Text(
                        '图片加载失败',
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'URL: $completeImageUrl',
                        style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            )
          else
            Container(
              padding: EdgeInsets.all(50.h),
              child: Column(
                children: [
                  Icon(Icons.description, size: 64.sp, color: Colors.grey),
                  SizedBox(height: 16.h),
                  Text(
                    '暂无商品介绍',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                ],
              ),
            ),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  Widget _buildBottomBar(GoodsDetailModel detail) {
    final isPurchased = detail.permissionStatus == '1';
    final activePriceIndex = ref.watch(
      subjectMockDetailNotifierProvider.select((s) => s.activePriceIndex),
    );
    final prices = detail.prices ?? [];
    final currentPrice = prices.isNotEmpty && activePriceIndex < prices.length
        ? prices[activePriceIndex]
        : null;
    final currentSalePrice = SafeTypeConverter.toSafeString(
      currentPrice?.salePrice,
      defaultValue: '0',
    );

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (!isPurchased && currentPrice != null) ...[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '¥',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Color(0xFFCD3F2F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          currentSalePrice,
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: Color(0xFFCD3F2F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('购买功能开发中...')));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2E68FF),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 14.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
                child: Text('立即购买', style: TextStyle(fontSize: 16.sp)),
              ),
            ] else ...[
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('开始练习功能开发中...')));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2E68FF),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: Text('开始练习', style: TextStyle(fontSize: 16.sp)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
