import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// P5-1-3 科目模考商品详情页
/// 对应小程序: modules/jintiku/pages/test/subjectMockDetail.vue
class SubjectMockDetailPage extends ConsumerStatefulWidget {
  final String? productId;
  final String? professionalId;

  const SubjectMockDetailPage({
    super.key,
    this.productId,
    this.professionalId,
  });

  @override
  ConsumerState<SubjectMockDetailPage> createState() => _SubjectMockDetailPageState();
}

class _SubjectMockDetailPageState extends ConsumerState<SubjectMockDetailPage> {
  // Mock数据
  final Map<String, dynamic> _goodsInfo = {
    'name': '2026口腔执业医师科目模考',
    'subtitle': '查漏补缺 直击重点',
    'sale_price': '199.00',
    'original_price': '299.00',
    'longImagePath': '', // 长图路径，暂时为空
  };

  bool _showBuyPopup = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('科目模考'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildContent(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildContent() {
    final longImagePath = _goodsInfo['longImagePath']?.toString() ?? '';
    
    return SingleChildScrollView(
      child: Column(
        children: [
          // 长图展示区域
          if (longImagePath.isNotEmpty)
            Image.network(
              longImagePath,
              width: double.infinity,
              fit: BoxFit.fitWidth,
              errorBuilder: (context, error, stackTrace) {
                return _buildPlaceholder();
              },
            )
          else
            _buildPlaceholder(),
        ],
      ),
    );
  }

  /// 占位图（当长图未配置时显示）
  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(40.w),
      color: const Color(0xFFF5F7FA),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 80.sp,
            color: const Color(0xFFCCCCCC),
          ),
          SizedBox(height: 16.h),
          Text(
            _goodsInfo['name']?.toString() ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF333333),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _goodsInfo['subtitle']?.toString() ?? '',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF999999),
            ),
          ),
          SizedBox(height: 40.h),
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                _buildInfoRow('课程名称', _goodsInfo['name']?.toString() ?? ''),
                SizedBox(height: 12.h),
                _buildInfoRow('课程特点', _goodsInfo['subtitle']?.toString() ?? ''),
                SizedBox(height: 12.h),
                _buildInfoRow(
                  '价格',
                  '¥${_goodsInfo['sale_price']}',
                  valueColor: const Color(0xFFFF4D4F),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF666666),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            color: valueColor ?? const Color(0xFF333333),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// 底部购买栏
  Widget _buildBottomBar() {
    final salePrice = _goodsInfo['sale_price']?.toString() ?? '0.00';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // 价格
            Column(
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
                        fontSize: 14.sp,
                        color: const Color(0xFFFF4D4F),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      salePrice,
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: const Color(0xFFFF4D4F),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(width: 16.w),
            // 购买按钮
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _showBuyPopup = true),
                child: Container(
                  height: 44.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                    ),
                    borderRadius: BorderRadius.circular(22.r),
                  ),
                  child: Center(
                    child: Text(
                      '立即购买',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
