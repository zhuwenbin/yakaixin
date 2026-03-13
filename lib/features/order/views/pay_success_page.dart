import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/storage/storage_service.dart';
import '../../../core/utils/login_refresh_helper.dart';
import '../../../app/constants/storage_keys.dart';
import '../../../core/utils/safe_type_converter.dart';
import '../../main/main_tab_page.dart';
import '../../goods/services/goods_service.dart';

/// 支付成功页面
/// 对应小程序: pages/order/paySuccess.vue
/// 功能: 显示支付成功状态、学习群二维码、跳转学习或开始测验
class PaySuccessPage extends ConsumerStatefulWidget {
  final String? goodsId;
  final String? professionalIdName;
  final int? isLearnButton; // 1=显示"去学习"按钮, 0=显示"开始测验"按钮
  final String? goodsType; // ✅ 新增：商品类型（从详情页/订单页传递，避免再次调用API）

  const PaySuccessPage({
    super.key,
    this.goodsId,
    this.professionalIdName,
    this.isLearnButton,
    this.goodsType, // ✅ 新增：商品类型参数
  });

  @override
  ConsumerState<PaySuccessPage> createState() => _PaySuccessPageState();
}

class _PaySuccessPageState extends ConsumerState<PaySuccessPage> {
  String _qrcodeUrl = '';

  // ✅ 对应小程序 Line 40-56: qrcodeList
  // ⚠️ 使用完整URL，与小程序保持一致
  static final List<Map<String, dynamic>> _qrcodeList = [
    {
      'keys': ['口腔'],
      'src': 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/60dc174341121431254320_b597430dda7e46cc7fe564a6aa6416a.png'
    },
    {
      'keys': ['临床', '乡村'],
      'src': 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/WechatIMG357.jpg'
    },
    {
      'keys': ['中医', '护士', '药师', '西医', '中西医'],
      'src': 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/WechatIMG357.jpg'
    },
  ];

  static const String _defaultQrcodePath = 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/2ec4174341105901736218_tongyongma.png';

  @override
  void initState() {
    super.initState();
    _initQrcode();
    // 购买成功后通知首页、题库、课程刷新数据，返回主 Tab 时显示最新列表
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoginRefreshHelper.refreshAllPages(ref);
    });
  }

  /// 初始化二维码
  /// 对应小程序 Line 63-76: 根据专业名称匹配二维码
  /// ✅ 修复：从Storage读取专业名称，参考小程序 Line 64
  void _initQrcode() async {
    // ✅ 对应小程序 Line 64: 从Storage读取专业名称
    final storage = ref.read(storageServiceProvider);
    final majorInfo = storage.getJson(StorageKeys.majorInfo);
    String majorName = majorInfo?['major_name']?.toString() ?? '';
    
    // ✅ 对应小程序 Line 65-67: 如果参数中有专业名称，则使用参数的
    if (widget.professionalIdName != null && widget.professionalIdName!.isNotEmpty) {
      majorName = widget.professionalIdName!;
    }
    
    // 默认使用通用二维码
    String qrcodePath = _defaultQrcodePath;
    
    // 根据专业名称匹配二维码
    for (var item in _qrcodeList) {
      final keys = item['keys'] as List;
      for (var key in keys) {
        // ✅ 对应小程序 Line 70-73: 使用正则匹配
        if (majorName.contains(key)) {
          qrcodePath = item['src'];
          break;
        }
      }
    }
    
    // ✅ 对应小程序 Line 68-76: 直接使用完整URL，不需要拼接
    setState(() {
      _qrcodeUrl = qrcodePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ✅ 对应小程序 Line 205: padding-top: 102rpx
              // ⚠️ ScreenUtil 基准 375，小程序 750，需要除以 2
              SizedBox(height: 51.h), // 102rpx / 2
              _buildSuccessCard(),
              // ✅ 对应小程序 Line 238: padding-top: 80rpx
              SizedBox(height: 40.h), // 80rpx / 2
              _buildButtonGroup(),
              // 底部安全间距
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  /// 成功卡片
  /// 对应小程序 Line 164-200: .qrcode-box
  /// ⚠️ ScreenUtil 基准 375，小程序 750rpx，所有 rpx 需要除以 2
  Widget _buildSuccessCard() {
    return Container(
      width: 343.w, // ✅ 686rpx / 2
      height: 363.h, // ✅ 726rpx / 2
      margin: EdgeInsets.symmetric(horizontal: 16.w), // ✅ 32rpx / 2
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r), // ✅ 24rpx / 2
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ✅ 成功图标（悬浮在卡片外上方）
          // 对应小程序 Line 209-235: .success
          Positioned(
            top: -31.h, // ✅ -62rpx / 2
            left: (343.w / 2 - 51.5.w), // ✅ 居中: calc(50% - 103rpx/2)
            child: _buildSuccessIcon(),
          ),
          // ✅ 提示文字
          // 对应小程序 Line 175-182: .tips
          Positioned(
            top: 114.h, // ✅ 228rpx / 2
            left: 0,
            right: 0,
            child: Text(
              '便于给您及时提供服务，长按二维码加群学习',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp, // ✅ 28rpx / 2
                fontWeight: FontWeight.w400,
                color: const Color(0xFF202020).withOpacity(0.85),
                height: 20.sp / 14.sp, // ✅ 40rpx / 2 line-height
              ),
            ),
          ),
          // ✅ 二维码
          // 对应小程序 Line 184-199: .qrcode margin-top: 68rpx
          Positioned(
            top: 114.h + 20.h + 34.h, // ✅ (228 + 40 + 68)rpx / 2 = 168
            left: (343.w / 2 - 77.5.w), // ✅ 居中
            child: _buildQrcode(),
          ),
        ],
      ),
    );
  }

  /// 成功图标
  /// 对应小程序 Line 209-235: .success
  /// ⚠️ ScreenUtil 基准 375，小程序 750rpx，所有 rpx 需要除以 2
  Widget _buildSuccessIcon() {
    return Column(
      children: [
        // ✅ 圆形背景+图标
        Container(
          width: 103.w, // ✅ 206rpx / 2
          height: 103.h,
          padding: EdgeInsets.all(18.w), // ✅ 36rpx / 2
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          // ✅ 对应小程序 Line 6-8: 成功图标
          // ⚠️ 使用完整URL，与小程序保持一致
          child: Image.network(
            'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/26e2174185623886722986_%E7%BC%96%E7%BB%84%2013%402x.png',
            width: 64.w, // ✅ 128rpx / 2
            height: 64.h,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              // ✅ 图片加载失败时显示图标
              return const Icon(Icons.check_circle, size: 40, color: Colors.green);
            },
          ),
        ),
        SizedBox(height: 5.h), // ✅ 10rpx / 2
        // ✅ "支付成功"文字
        Text(
          '支付成功',
          style: TextStyle(
            fontSize: 22.sp, // ✅ 44rpx / 2
            fontWeight: FontWeight.w600,
            color: const Color(0xFF121212),
          ),
        ),
      ],
    );
  }

  /// 二维码
  /// 对应小程序 Line 184-199: .qrcode
  /// ⚠️ ScreenUtil 基准 375，小程序 750rpx，所有 rpx 需要除以 2
  /// 小程序结构：外层容器(.qrcode) + 内层图片(image)
  Widget _buildQrcode() {
    return Container(
      width: 155.w, // ✅ 310rpx / 2
      height: 155.h, // ✅ 310rpx / 2
      decoration: BoxDecoration(
        // ✅ 对应小程序 Line 192: background-image
        // ⚠️ 使用完整URL，与小程序保持一致
        image: DecorationImage(
          image: NetworkImage(
            'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/46c2174185637060211201_%E5%BD%A2%E7%8A%B6%E7%BB%93%E5%90%88%402x.png',
          ),
          fit: BoxFit.contain, // ✅ 使用 contain 而不是 cover
        ),
      ),
      alignment: Alignment.center,
      child: Container(
        width: 119.w, // ✅ 238rpx / 2
        height: 119.h,
        // ✅ 对应小程序 Line 197: background: #e4e8ed
        color: const Color(0xFFE4E8ED).withOpacity(0.8),
        // ✅ 正确处理二维码图片显示
        child: _qrcodeUrl.isNotEmpty
            ? Image.network(
                _qrcodeUrl,
                fit: BoxFit.contain, // ✅ 使用 contain 保持比例
                errorBuilder: (context, error, stackTrace) {
                  // ✅ 加载失败时显示占位符
                  return Container(
                    color: const Color(0xFFE4E8ED),
                    child: const Icon(Icons.qr_code, size: 30, color: Colors.grey),
                  );
                },
              )
            : Container(
                // ✅ URL为空时也显示占位符
                color: const Color(0xFFE4E8ED),
                child: const Icon(Icons.qr_code, size: 30, color: Colors.grey),
              ),
      ),
    );
  }

  /// 按钮组
  /// 统一以 goodsType 判断：课程(2,3)→「开始学习」，试卷/题库等→「开始测验」
  /// goodsType 为空时用 isLearnButton 兜底（兼容旧入口）
  Widget _buildButtonGroup() {
    final gt = widget.goodsType;
    final fallbackLearn = widget.isLearnButton == 1;
    final isCourseType = gt == '2' || gt == '3' || (gt == null && fallbackLearn);
    final primaryButtonText = isCourseType ? '开始学习' : '开始测验';
    final onPrimaryTap = isCourseType ? _onGoLearn : _onGoTest;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ✅ 返回按钮
        // 对应小程序 Line 21: @click="home"
        _buildButton(
          text: '返回',
          isPrimary: false,
          onTap: _onBack,
        ),
        SizedBox(width: 12.0), // ✅ 小程序: 12px (Line 255: margin-right)
        // ✅ 右侧按钮（开始学习 或 开始测验）
        _buildButton(
          text: primaryButtonText,
          isPrimary: true,
          onTap: onPrimaryTap,
        ),
      ],
    );
  }

  /// 单个按钮
  /// 对应小程序 Line 242-262
  /// ⚠️ 注意：小程序按钮宽度用 rpx，高度/圆角/字号用 px
  Widget _buildButton({
    required String text,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 132.w, // ✅ 264rpx / 2
        height: 44.0, // ✅ 44px - 固定值
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF2E68FF) : Colors.white,
          border: isPrimary
              ? null
              : Border.all(
                  color: const Color(0xFFD8DDE1),
                  width: 1,
                ),
          borderRadius: BorderRadius.circular(22.0), // ✅ 22px - 固定值
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14.0, // ✅ 14px - 固定值
            height: 1.0,
          ).copyWith(
            color: isPrimary
                ? Colors.white
                : const Color(0xFF03203D).withOpacity(0.65),
          ),
        ),
      ),
    );
  }

  // ===== 事件处理 =====

  /// 返回
  /// 对应小程序 Line 84-88: home()
  void _onBack() {
    if (mounted) {
      context.pop();
    }
  }

  /// 去学习
  /// 对应小程序 Line 89-91: goLearn()
  /// ✅ 优化：返回主页面并切换到课程Tab（索引2）
  void _onGoLearn() {
    if (mounted) {
      // 1. 设置Tab索引为课程页（索引2）
      ref.read(mainTabIndexProvider.notifier).state = 2;
      // 2. 返回主Tab页面
      context.go(AppRoutes.mainTab);
    }
  }

  /// 开始测验
  /// 对应小程序 paySuccess.vue Line 97-154: goDetail()
  /// 根据商品 type / data_type / details_type 跳转到对应测验页，与小程序一致
  Future<void> _onGoTest() async {
    if (widget.goodsId == null || widget.goodsId!.isEmpty) {
      _goToHomePageWithTab(tabIndex: 1);
      return;
    }

    final goodsService = ref.read(goodsServiceProvider);
    final storage = ref.read(storageServiceProvider);
    final studentId = storage.getString(StorageKeys.studentId);

    try {
      final detail = await goodsService.getGoodsDetail(
        goodsId: widget.goodsId!,
        userId: studentId,
        studentId: studentId,
      );

      if (!mounted) return;

      final type = detail.type?.toString();
      final dataType = detail.dataType?.toString();
      final detailsType = detail.detailsType?.toString();
      final productId = detail.goodsId?.toString() ?? widget.goodsId;
      final professionalId = detail.professionalId ?? '';

      // 打印 type、data_type，后续各分支会打印跳转类型名称和路由
      print('📋 [开始测验] type=$type, data_type=$dataType, details_type=$detailsType');

      // type == 2 或 3 (课程) → 返回主页面并选中课程Tab（对应小程序 push pages/study/index）
      if (type == '2' || type == '3') {
        print('📋 [开始测验] 跳转类型: 课程 | 路由: 回主页选课程Tab (tabIndex=2)');
        _goToHomePageWithTab(tabIndex: 2);
        return;
      }

      // data_type == 2 (模考)（对应小程序 Line 111-131）
      if (dataType == '2') {
        if (detailsType == '1') {
          // 模考+经典版 → 模考信息页
          print('📋 [开始测验] 跳转类型: 模考+经典版 | 路由: ${AppRoutes.examInfo}');
          context.push(
            AppRoutes.examInfo,
            extra: {
              'product_id': productId,
              'title': detail.name,
              'page': 'home',
              'professional_id': professionalId,
            },
          );
          return;
        }
        if (detailsType == '4') {
          // 模考+模考版 → 模考房间
          print('📋 [开始测验] 跳转类型: 模考+模考版 | 路由: ${AppRoutes.simulatedExamRoom}');
          context.push(
            AppRoutes.simulatedExamRoom,
            extra: {
              'product_id': productId,
              'professional_id': professionalId,
            },
          );
          return;
        }
      }

      // type == 18 (章节练习) → 章节列表（对应小程序 Line 133-139）
      if (type == '18') {
        final total = SafeTypeConverter.toInt(
          detail.tikuGoodsDetails?.questionNum,
          defaultValue: 0,
        );
        print('📋 [开始测验] 跳转类型: 章节练习 | 路由: ${AppRoutes.chapterList}');
        context.push(
          AppRoutes.chapterList,
          extra: {
            'goods_id': productId,
            'professional_id': professionalId,
            'total': total,
          },
        );
        return;
      }

      // type == 10 (模考) → 模考信息页（对应小程序 Line 141-146）
      if (type == '10') {
        print('📋 [开始测验] 跳转类型: 模考 | 路由: ${AppRoutes.examInfo}');
        context.push(
          AppRoutes.examInfo,
          extra: {
            'product_id': productId,
            'title': detail.name,
            'page': 'home',
            'professional_id': professionalId,
          },
        );
        return;
      }

      // type == 8 (试卷) → 试卷做题页（对应小程序 Line 148-152）
      if (type == '8') {
        print('📋 [开始测验] 跳转类型: 试卷 | 路由: ${AppRoutes.testExam}');
        context.push(
          AppRoutes.testExam,
          extra: {
            'id': productId,
            'professional_id': professionalId,
            'recitation_question_model': detail.recitationQuestionModel,
          },
        );
        return;
      }

      // 未知类型 → 返回主页面选题库Tab
      print('📋 [开始测验] 跳转类型: 未知类型 | 路由: 回主页选题库Tab (tabIndex=1)');
      _goToHomePageWithTab(tabIndex: 1);
    } catch (e) {
      print('❌ [支付成功页] 获取商品详情失败: $e');
      if (mounted) {
        _goToHomePageWithTab(tabIndex: 1);
      }
    }
  }

  /// 返回主页面并选中指定Tab
  /// 
  /// - tabIndex: Tab索引（0=首页, 1=题库, 2=课程, 3=我的）
  /// ⚠️ 用户反馈：应该返回到主页面并选中对应的Tab，而不是跳转到新的详情页
  void _goToHomePageWithTab({required int tabIndex}) {
    if (mounted) {
      // 1. 设置Tab索引
      ref.read(mainTabIndexProvider.notifier).state = tabIndex;
      // 2. 返回主Tab页面（显示TabBar）
      context.go(AppRoutes.mainTab);
    }
  }

}
