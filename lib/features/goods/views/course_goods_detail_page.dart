import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../core/mock/data/course_goods_profile_mock_data.dart';
import '../../order/providers/payment_provider.dart';

/// 课程商品详情页 - 对应小程序 course/courseDetail.vue
/// 功能:展示课程介绍、课程大纲、购买入口
/// 与 CourseDetailPage (已购买课程学习页) 区分
class CourseGoodsDetailPage extends ConsumerStatefulWidget {
  final String? goodsId;
  final String? professionalId;
  final int? type;

  const CourseGoodsDetailPage({
    super.key,
    this.goodsId,
    this.professionalId,
    this.type,
  });

  @override
  ConsumerState<CourseGoodsDetailPage> createState() =>
      _CourseGoodsDetailPageState();
}

class _CourseGoodsDetailPageState
    extends ConsumerState<CourseGoodsDetailPage> {
  int _tabIndex = 1; // 1-课程介绍 2-课程大纲

  // ✅ 遵守Mock规则: 通过API获取数据
  Map<String, dynamic> _goodsDetail = {};
  List<Map<String, dynamic>> _courseList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGoodsDetail();
  }

  /// 加载商品详情
  /// 对应小程序: getGoodsDetail API
  Future<void> _loadGoodsDetail() async {
    try {
      // TODO: 实现API调用获取商品详情
      // final response = await goodsService.getGoodsDetail(goodsId: widget.goodsId);
      // setState(() {
      //   _goodsDetail = response.toJson();
      //   _isLoading = false;
      // });
      
      // 临时使用Mock数据（通过拦截器会自动返回）
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        // 根据type参数选择不同的Mock数据
        // type=2或23是课程/套餐, type=18是题库
        if (widget.type == 2 || widget.type == 3) {
          // 课程类型 - 使用courseGoodsDetail
          _goodsDetail = CourseGoodsProfileMockData.courseGoodsDetail['data'];
          print('📚 加载课程商品详情: ${_goodsDetail['name']}');
          print('📚 permission_status: ${_goodsDetail['permission_status']}');
        } else {
          // 题库类型 - 使用goodsDetail
          _goodsDetail = CourseGoodsProfileMockData.goodsDetail['data'];
          print('📚 加载题库商品详情: ${_goodsDetail['name']}');
          print('📚 permission_status: ${_goodsDetail['permission_status']}');
        }
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white, // 状态栏白色
        statusBarIconBrightness: Brightness.dark, // 黑色图标
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('课程详情'),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: Stack(
          children: [
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildBody(),
            if (!_isLoading && _goodsDetail['permission_status'] == '2') _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      color: const Color(0xFFF5F6FA),
      child: CustomScrollView(
        slivers: [
          _buildCard(),
          _buildCoverImage(),
          _buildTab(),
          if (_tabIndex == 1) _buildIntroduction(),
          if (_tabIndex == 2) _buildCourseOutline(),
          SliverToBoxAdapter(child: SizedBox(height: 88.h)),
        ],
      ),
    );
  }

  /// 课程封面图（在标题下方）
  Widget _buildCoverImage() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: _goodsDetail['material_cover_path'] != null &&
                  _goodsDetail['material_cover_path'].isNotEmpty
              ? Image.network(
                  _goodsDetail['material_cover_path'],
                  width: double.infinity,
                  height: 200.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 200.h,
                      color: const Color(0xFFE5E5E5),
                      child: Icon(Icons.image, size: 60.sp, color: Colors.grey),
                    );
                  },
                )
              : Container(
                  width: double.infinity,
                  height: 200.h,
                  color: const Color(0xFFE5E5E5),
                  child: Icon(Icons.image, size: 60.sp, color: Colors.grey),
                ),
        ),
      ),
    );
  }

  /// 课程信息卡片
  Widget _buildCard() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            SizedBox(height: 12.h),
            _buildTags(),
            if (_goodsDetail['validity_start_date_val'] != null &&
                !_goodsDetail['validity_start_date_val'].contains('0001')) ...[
              SizedBox(height: 12.h),
              _buildValidityTime(),
            ],
            SizedBox(height: 16.h),
            _buildBottomInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_goodsDetail['shop_type'] != null) ...[
          _buildCourseTypeIcon(_goodsDetail['shop_type']),
          SizedBox(width: 8.w),
        ],
        Expanded(
          child: Text(
            _goodsDetail['name'] ?? '',
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
      ],
    );
  }

  Widget _buildCourseTypeIcon(String shopType) {
    String? iconPath;
    switch (shopType) {
      case '1':
        iconPath = 'assets/images/course_type/best.png';
        break;
      case '2':
        iconPath = 'assets/images/course_type/high.png';
        break;
      case '3':
        iconPath = 'assets/images/course_type/private.png';
        break;
      case 'good':
        iconPath = 'assets/images/course_type/good.png';
        break;
      case 'recommend':
        iconPath = 'assets/images/course_type/recommend.png';
        break;
      default:
        iconPath = 'assets/images/course_type/best.png';
    }

    return Image.asset(
      iconPath,
      width: 56.w,
      height: 28.h,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 56.w,
          height: 28.h,
          decoration: BoxDecoration(
            color: const Color(0xFFE3EBFF),
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      },
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 8.w,
      children: [
        if (_goodsDetail['teaching_type_name'] != null)
          _buildTag(
            _goodsDetail['teaching_type_name'],
            const Color(0xFFE3EBFF),
            const Color(0xFF2E68FF),
          ),
        if (_goodsDetail['service_type_name'] != null)
          _buildTag(
            _goodsDetail['service_type_name'],
            const Color(0xFFF5F5F5),
            Colors.black,
          ),
      ],
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(2.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildValidityTime() {
    return Text(
      '有效时间: ${_goodsDetail['validity_start_date_val']} - ${_goodsDetail['validity_end_date_val']}',
      style: TextStyle(
        fontSize: 12.sp,
        color: const Color(0xFF999999),
      ),
    );
  }

  Widget _buildBottomInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_goodsDetail['permission_status'] == '2' &&
            _goodsDetail['sale_price'] != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '￥',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFFF6600),
                ),
              ),
              Text(
                _goodsDetail['sale_price'].toString(),
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFF6600),
                ),
              ),
            ],
          )
        else
          const SizedBox.shrink(),
        Text(
          '${_goodsDetail['student_num'] ?? 0}人购买',
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF999999),
          ),
        ),
      ],
    );
  }

  /// Tab切换
  Widget _buildTab() {
    final List<Map<String, dynamic>> tabList = _getTabList();

    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 8.h),
        child: Row(
          children: tabList.map((tab) {
            final isActive = _tabIndex == tab['id'];
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _tabIndex = tab['id'];
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tab['title'],
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight:
                                  isActive ? FontWeight.w600 : FontWeight.w400,
                              color: isActive
                                  ? const Color(0xFF2F69FF)
                                  : const Color(0xFF999999),
                            ),
                          ),
                          if (tab['hasIcon'] == true) ...[
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.play_circle,
                              size: 16.sp,
                              color: isActive
                                  ? const Color(0xFF2F69FF)
                                  : const Color(0xFF999999),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        height: 2.h,
                        width: 40.w,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF2F69FF)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(1.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getTabList() {
    // 课程类型(type=2或3)显示课程大纲,否则只显示课程介绍
    if (widget.type == 2 || widget.type == 3) {
      return [
        {'title': '课程介绍', 'id': 1},
        {'title': '课程大纲', 'id': 2, 'hasIcon': true},
      ];
    } else {
      return [
        {'title': '课程介绍', 'id': 1},
      ];
    }
  }

  /// 课程介绍(图片)
  Widget _buildIntroduction() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 8.h),
        child: _goodsDetail['material_intro_path'] != null &&
                _goodsDetail['material_intro_path'].isNotEmpty
            ? Image.network(
                _goodsDetail['material_intro_path'],
                width: double.infinity,
                fit: BoxFit.fitWidth,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200.h,
                    alignment: Alignment.center,
                    child: Text(
                      '暂无课程介绍',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF999999),
                      ),
                    ),
                  );
                },
              )
            : Container(
                height: 200.h,
                alignment: Alignment.center,
                child: Text(
                  '暂无课程介绍',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF999999),
                  ),
                ),
              ),
      ),
    );
  }

  /// 课程大纲
  Widget _buildCourseOutline() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: _courseList.isEmpty
            ? Container(
                height: 200.h,
                alignment: Alignment.center,
                child: Text(
                  '暂无课程大纲',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF999999),
                  ),
                ),
              )
            : Column(
                children: _courseList.map((course) {
                  return _buildCourseBlock(course);
                }).toList(),
              ),
      ),
    );
  }

  Widget _buildCourseBlock(Map<String, dynamic> course) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course['name'] ?? '',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF262629),
            ),
          ),
          SizedBox(height: 12.h),
          ...((course['chapterData'] as List?) ?? []).map((chapter) {
            return _buildChapterBlock(chapter);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildChapterBlock(Map<String, dynamic> chapter) {
    final isExpand = chapter['expand'] ?? true;
    final subs = (chapter['subs'] as List?) ?? [];

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                chapter['expand'] = !isExpand;
              });
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    chapter['name'] ?? '',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF262629),
                    ),
                  ),
                ),
                Text(
                  '${subs.length}节',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF999999),
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  isExpand ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 20.sp,
                  color: const Color(0xFF999999),
                ),
              ],
            ),
          ),
          if (isExpand) ...[
            SizedBox(height: 8.h),
            ...subs.map((section) {
              return _buildSectionItem(section);
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionItem(Map<String, dynamic> section) {
    final canTrial = section['is_trial_listening'] == 1;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFF4F5F5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 4.w,
            decoration: const BoxDecoration(
              color: Color(0xFF999999),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section['time'] ?? '',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF696E7A),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  section['name'] ?? '',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF5B6E81),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (canTrial)
            GestureDetector(
              onTap: () => _onTrialListen(section),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4FF),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Text(
                  '开始试听',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF3B7BFB),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 底部购买/学习按钮
  Widget _buildBottomBar() {
    final isPurchased = _goodsDetail['permission_status'] == '1';

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
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
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isPurchased ? _onGoCourse : _onPurchase,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F69FF),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
              ),
              child: Text(
                isPurchased ? '去学习' : '立即报名',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===== 事件处理 =====

  /// 试听课程
  Future<void> _onTrialListen(Map<String, dynamic> section) async {
    try {
      EasyLoading.show(status: '加载中...');
      
      // TODO: 调用试听接口 trialListen API
      // final response = await ref.read(courseApiProvider).trialListen(
      //   goodsId: section['goods_id'],
      //   systemId: section['system_id'],
      // );
      
      // Mock演示：模拟网络请求延迟
      await Future.delayed(const Duration(seconds: 1));
      
      EasyLoading.dismiss();
      
      // Mock数据：假设返回了视频路径
      final String? videoPath = 'https://yakaixin.oss-cn-beijing.aliyuncs.com/test/video.mp4';
      
      if (videoPath != null && videoPath.isNotEmpty) {
        // 跳转视频播放页
        context.push(
          AppRoutes.videoIndex,
          extra: {
            'url': videoPath,
            'goods_id': widget.goodsId,
            'system_id': section['id'],
            'name': section['name'],
          },
        );
      } else {
        EasyLoading.showInfo('还没有试听内容');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('加载失败: $e');
    }
  }

  /// 支付流程 - 对应小程序 getOrder 方法
  Future<void> _onPurchase() async {
    try {
      EasyLoading.show(status: '创建订单中...');
      
      // 1. 获取商品信息
      final goodsId = _goodsDetail['id']?.toString() ?? '';
      final salePrice = double.tryParse(_goodsDetail['sale_price']?.toString() ?? '0') ?? 0.0;
      final goodsMonthsPriceId = _goodsDetail['goods_months_price_id']?.toString() ?? '';
      final months = _goodsDetail['month'] ?? 0;
      
      print('💳 开始支付流程:');
      print('💳 商品ID: $goodsId');
      print('💳 价格: $salePrice');
      print('💳 月价格ID: $goodsMonthsPriceId');
      print('💳 月数: $months');
      
      // 2. 调用支付流程
      final success = await ref.read(paymentProvider.notifier).processPayment(
        goodsId: goodsId,
        goodsMonthsPriceId: goodsMonthsPriceId,
        months: months,
        payableAmount: salePrice,
      );
      
      EasyLoading.dismiss();
      
      // 3. 支付结果处理
      if (success) {
        print('💳 支付成功,跳转支付成功页');
        if (mounted) {
          context.push(
            AppRoutes.paySuccess,
            extra: {
              'goods_id': goodsId,
              'professional_id_name': _goodsDetail['professional_id_name'],
              'isLearnButton': true,
            },
          );
        }
      } else {
        print('💳 支付失败或取消');
        EasyLoading.showError('支付失败');
      }
    } catch (e) {
      EasyLoading.dismiss();
      print('💳 支付异常: $e');
      EasyLoading.showError('支付失败: $e');
    }
  }

  void _onGoCourse() {
    // 已购买-跳转学习中心
    context.go(AppRoutes.studyIndex);
  }
}
