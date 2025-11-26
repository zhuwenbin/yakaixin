import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:yakaixin_app/app/routes/app_routes.dart';
import '../../../core/mock/data/order_mock_data.dart';

/// 支付成功页 - 对应小程序 order/paySuccess.vue
/// 功能：显示支付成功信息，引导加群，开始学习
class PaySuccessPage extends ConsumerStatefulWidget {
  final String? orderId;
  final String? goodsId;
  final bool? isLearnButton;

  const PaySuccessPage({
    super.key,
    this.orderId,
    this.goodsId,
    this.isLearnButton,
  });

  @override
  ConsumerState<PaySuccessPage> createState() => _PaySuccessPageState();
}

class _PaySuccessPageState extends ConsumerState<PaySuccessPage> {
  // 从 Mock数据文件获取数据
  Map<String, dynamic> get _mockGoodsInfo => MockOrderData.paySuccessGoodsInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 40.h),
                    _buildSuccessCard(),
                  ],
                ),
              ),
            ),
            _buildButtonGroup(),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          _buildSuccessIcon(),
          SizedBox(height: 24.h),
          Text(
            '支付成功',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF000000),
            ),
          ),
          SizedBox(height: 32.h),
          _buildQRCodeSection(),
        ],
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 80.w,
      height: 80.w,
      decoration: BoxDecoration(
        color: const Color(0xFF04C140).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.check_circle,
        size: 50.sp,
        color: const Color(0xFF04C140),
      ),
    );
  }

  Widget _buildQRCodeSection() {
    return Column(
      children: [
        Text(
          '便于给您及时提供服务，长按二维码加群学习',
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF202020).withOpacity(0.85),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32.h),
        _buildQRCode(),
      ],
    );
  }

  Widget _buildQRCode() {
    return Container(
      width: 155.w,
      height: 155.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code, size: 80.sp, color: Colors.grey),
            SizedBox(height: 8.h),
            Text(
              '长按识别二维码',
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF999999)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonGroup() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF2F69FF)),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                '返回',
                style: TextStyle(fontSize: 16.sp, color: const Color(0xFF2F69FF)),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: ElevatedButton(
              onPressed: _onStartStudy,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F69FF),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
              ),
              child: Text(
                widget.isLearnButton == true ? '去学习' : '开始测验',
                style: TextStyle(fontSize: 16.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onStartStudy() {
    final info = _mockGoodsInfo;
    if (widget.isLearnButton == true) {
      // 跳转学习页
      context.go(AppRoutes.studyIndex);
      return;
    }

    // 根据商品类型跳转
    if (info['type'] == 18) {
      // 题库
      context.push(
        AppRoutes.chapterList,
        extra: {
          'professional_id': info['professional_id'],
          'goods_id': info['id'],
        },
      );
    } else if (info['type'] == 8) {
      // 试卷
      context.push(
        AppRoutes.testExam,
        extra: {'id': info['id']},
      );
    } else if (info['type'] == 2 || info['type'] == 3) {
      // 课程
      context.push(
        AppRoutes.courseDetail,
        extra: {
          'goods_id': info['id'],
          'order_id': widget.orderId,
        },
      );
    }
  }
}
