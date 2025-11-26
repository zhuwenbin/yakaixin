import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';

/// 支付成功页面
/// 对应小程序: order/paySuccess.vue
class PaySuccessPage extends ConsumerStatefulWidget {
  final String? goodsId;
  final String? orderId; // 订单ID
  final bool isLearnButton; // true-去学习按钮, false-开始测验按钮
  final String? professionalIdName; // 专业名称

  const PaySuccessPage({
    super.key,
    this.goodsId,
    this.orderId,
    this.isLearnButton = false,
    this.professionalIdName,
  });

  @override
  ConsumerState<PaySuccessPage> createState() => _PaySuccessPageState();
}

class _PaySuccessPageState extends ConsumerState<PaySuccessPage> {
  String _qrcodeUrl = '';
  Map<String, dynamic> _goodsInfo = {};
  bool _isLoading = true;

  // 二维码列表（根据专业显示不同的群二维码）
  final List<Map<String, dynamic>> _qrcodeList = [
    {
      'key': ['口腔'],
      'src': 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/60dc174341121431254320_b597430dda7e46cc7fe564a6aa6416a.png',
    },
    {
      'key': ['临床', '乡村'],
      'src': 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/WechatIMG357.jpg',
    },
    {
      'key': ['中医', '护士', '药师', '西医', '中西医'],
      'src': 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/WechatIMG357.jpg',
    },
  ];

  final String _allQrcode = 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/2ec4174341105901736218_tongyongma.png';

  @override
  void initState() {
    super.initState();
    _selectQrcode();
    _loadGoodsDetail();
  }

  /// 根据专业选择二维码
  void _selectQrcode() {
    // TODO: 从本地存储获取当前专业名称
    String majorName = widget.professionalIdName ?? '';
    
    _qrcodeUrl = _allQrcode; // 默认使用通用二维码
    
    for (var qrcode in _qrcodeList) {
      final keys = qrcode['key'] as List<dynamic>;
      for (var key in keys) {
        if (majorName.contains(key as String)) {
          _qrcodeUrl = qrcode['src'] as String;
          break;
        }
      }
    }
  }

  /// 加载商品详情
  Future<void> _loadGoodsDetail() async {
    // 如果没有goodsId，不加载
    if (widget.goodsId == null || widget.goodsId!.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    
    try {
      // TODO: 实现API调用获取商品详情
      // final response = await goodsService.getGoodsDetail(goodsId: widget.goodsId!);
      // setState(() {
      //   _goodsInfo = response.toJson();
      //   _isLoading = false;
      // });
      
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('❌ 加载商品详情失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 51.h),
            Expanded(
              child: Column(
                children: [
                  _buildSuccessCard(),
                  SizedBox(height: 40.h),
                  _buildButtonGroup(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建成功卡片
  Widget _buildSuccessCard() {
    return Container(
      width: 343.w,
      height: 363.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 成功图标和文字（顶部悬浮）
          Positioned(
            top: -31.h,
            left: 0,
            right: 0,
            child: _buildSuccessIcon(),
          ),
          // 内容区域
          Padding(
            padding: EdgeInsets.only(top: 114.h),
            child: Column(
              children: [
                Text(
                  '便于给您及时提供服务，长按二维码加群学习',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF202020).withOpacity(0.85),
                    height: 1.43,
                  ),
                ),
                SizedBox(height: 34.h),
                _buildQrcode(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建成功图标
  Widget _buildSuccessIcon() {
    return Column(
      children: [
        Container(
          width: 103.w,
          height: 103.w,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(18.w),
          child: Image.network(
            'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/26e2174185623886722986_%E7%BC%96%E7%BB%84%2013%402x.png',
            width: 64.w,
            height: 64.w,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          '支付成功',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF121212),
          ),
        ),
      ],
    );
  }

  /// 构建二维码
  Widget _buildQrcode() {
    return Container(
      width: 155.w,
      height: 155.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/46c2174185637060211201_%E5%BD%A2%E7%8A%B6%E7%BB%93%E5%90%88%402x.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.center,
      child: Image.network(
        _qrcodeUrl,
        width: 119.w,
        height: 119.w,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 119.w,
            height: 119.w,
            color: const Color(0xFFE4E8ED),
            child: Icon(Icons.qr_code, size: 60.sp, color: Colors.grey),
          );
        },
      ),
    );
  }

  /// 构建按钮组
  Widget _buildButtonGroup() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 返回按钮
          GestureDetector(
            onTap: _handleBack,
            child: Container(
              width: 132.w,
              height: 44.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD8DDE1), width: 1),
                borderRadius: BorderRadius.circular(22.r),
              ),
              child: Text(
                '返回',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF03203D).withOpacity(0.65),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // 开始测验/去学习按钮
          GestureDetector(
            onTap: _handleAction,
            child: Container(
              width: 132.w,
              height: 44.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF2E68FF),
                borderRadius: BorderRadius.circular(22.r),
              ),
              child: Text(
                widget.isLearnButton ? '去学习' : '开始测验',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 处理返回
  void _handleBack() {
    context.pop();
  }

  /// 处理操作按钮点击
  void _handleAction() {
    if (widget.isLearnButton) {
      // 去学习 - 跳转到课程页
      context.push(AppRoutes.myCourse);
      return;
    }

    // 开始测验 - 根据商品类型跳转
    _navigateByGoodsType();
  }

  /// 根据商品类型跳转
  void _navigateByGoodsType() {
    final type = _goodsInfo['type'];
    final dataType = _goodsInfo['data_type'];
    final detailsType = _goodsInfo['details_type'];

    // 课程类型
    if (type == 2 || type == 3) {
      context.push(
        AppRoutes.myCourse,
        extra: {
          'professional_id': _goodsInfo['professional_id'],
          'id': _goodsInfo['id'],
          'type': type,
        },
      );
      return;
    }

    // 模拟考试
    if (dataType == 2) {
      if (detailsType == 1) {
        // 模考+经典版
        context.push(
          AppRoutes.examInfo,
          extra: {
            'product_id': _goodsInfo['id'],
            'title': _goodsInfo['name'],
            'page': 'home',
          },
        );
      } else if (detailsType == 4) {
        // 模考+模考版
        context.push(
          AppRoutes.simulatedExamRoom,
          extra: {
            'professional_id': _goodsInfo['professional_id'],
            'id': _goodsInfo['id'],
            'showPopup': 1,
          },
        );
      }
      return;
    }

    // 章节练习
    if (type == 18) {
      context.push(
        AppRoutes.chapterList,
        extra: {
          'professional_id': _goodsInfo['professional_id'],
          'goods_id': _goodsInfo['id'],
          'total': _goodsInfo['tiku_goods_details']?['question_num'] ?? 0,
        },
      );
      return;
    }

    // 模拟考试（老版）
    if (type == 10) {
      context.push(
        AppRoutes.examInfo,
        extra: {
          'product_id': _goodsInfo['id'],
          'title': _goodsInfo['name'],
          'page': 'home',
          'professional_id': _goodsInfo['professional_id'],
        },
      );
      return;
    }

    // 普通考试
    if (type == 8) {
      context.push(
        AppRoutes.examinationing,
        extra: {
          'id': _goodsInfo['id'],
          'recitation_question_model': _goodsInfo['recitation_question_model'],
        },
      );
      return;
    }
  }
}
