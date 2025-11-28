import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/constants/storage_keys.dart';
import '../../../core/storage/storage_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../order/providers/order_provider.dart';
import '../../home/services/goods_service.dart';
import '../../home/models/goods_model.dart';

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

  // ✅ 使用 Model 类存储商品详情
  GoodsModel? _goodsDetail;
  List<Map<String, dynamic>> _courseList = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadGoodsDetail();
  }

  /// 加载商品详情
  /// 对应小程序: getGoodsDetail({ goods_id, user_id, student_id, merchant_id, brand_id, no_professional_id })
  /// 参考: mini-dev_250812/src/modules/jintiku/pages/course/courseDetail.vue:357-410
  Future<void> _loadGoodsDetail() async {
    if (widget.goodsId == null || widget.goodsId!.isEmpty) {
      setState(() {
        _errorMessage = '商品ID不能为空';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // ✅ 调用真实API获取商品详情
      final goodsService = ref.read(goodsServiceProvider);
      final response = await goodsService.getGoodsDetail(
        goodsId: widget.goodsId!,
      );
      
      setState(() {
        _goodsDetail = response;
        _isLoading = false;
      });
      
      print('✅ 加载商品详情成功: ${response.name}');
      print('📦 商品详情数据: permission_status=${response.permissionStatus}');
      print('🖼️ 封面图路径: ${response.materialCoverPath}');
      print('📄 介绍图路径: ${response.materialIntroPath}');
      
      // ✅ 如果有课程大纲数据(detail_package_goods)，加载课程章节
      if (response.detailPackageGoods != null && response.detailPackageGoods!.isNotEmpty) {
        print('📚 开始加载 ${response.detailPackageGoods!.length} 个课程的章节数据...');
        _courseList = response.detailPackageGoods!.map((course) {
          return {
            ...course,
            'chapterData': [], // 初始化空章节数据
          };
        }).toList();
        
        // 为每个课程加载章节
        for (var course in _courseList) {
          await _loadChapterData(course);
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = '加载失败: $e';
        _isLoading = false;
      });
      print('❌ 加载商品详情失败: $e');
      EasyLoading.showError('加载失败');
    }
  }
  
  /// 拼接完整路径
  /// 对应小程序: completePath() (Line 478-486)
  /// 如果路径不包含完整域名,则拼接OSS域名前缀
  String _completePath(String? path) {
    if (path == null || path.isEmpty) {
      return '';
    }
    // 如果已经包含完整域名,直接返回
    if (path.contains('yakaixin.oss-cn-beijing.aliyuncs.com')) {
      return path;
    }
    // 拼接完整路径
    return 'https://yakaixin.oss-cn-beijing.aliyuncs.com/$path';
  }
  
  /// 加载课程章节数据
  /// 对应小程序: getChapter() -> chapterpaper API
  /// 参考: mini-dev_250812/src/modules/jintiku/pages/course/courseDetail.vue:340-356
  Future<void> _loadChapterData(Map<String, dynamic> course) async {
    try {
      final courseId = course['id']?.toString();
      if (courseId == null || courseId.isEmpty) {
        print('⚠️ 课程ID为空，跳过章节加载');
        return;
      }
      
      print('📖 加载课程章节: $courseId - ${course['name']}');
      
      // ✅ 调用真实API获取章节数据
      // 对应小程序: chapterpaper({ goods_id, no_professional_id, no_user_id })
      final goodsService = ref.read(goodsServiceProvider);
      final response = await goodsService.getChapterPaper(
        goodsId: courseId,
        noProfessionalId: '1',
        noUserId: '1',
      );
      
      // ✅ 解析章节数据并设置默认展开状态
      // 遵守 @data_type_safety.md: 安全的类型转换
      final chapters = (response as List?)?.map((item) {
        // ✅ 安全转换: dynamic -> Map<String, dynamic>
        final chapterMap = item is Map<String, dynamic> 
            ? item 
            : (item as Map).cast<String, dynamic>();
        
        return {
          ...chapterMap,
          'expand': true, // 默认展开所有章节
        };
      }).toList() ?? [];
      
      setState(() {
        course['chapterData'] = chapters;
      });
      
      print('✅ 章节加载成功: ${chapters.length} 章');
    } catch (e) {
      print('❌ 加载章节失败: $e');
      // ✅ 失败时设置空数据，不影响页面展示
      setState(() {
        course['chapterData'] = [];
      });
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
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_errorMessage != null)
              _buildError()
            else if (_goodsDetail != null)
              _buildBody()
            else
              const Center(child: Text('暂无数据')),
            if (!_isLoading && _goodsDetail?.permissionStatus == '2') _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: Colors.grey),
          SizedBox(height: 16.h),
          Text(
            _errorMessage ?? '加载失败',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: _loadGoodsDetail,
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      color: const Color(0xFFF5F6FA),
      child: CustomScrollView(
        slivers: [
          _buildCoverImage(), // ✅ 封面图放在最顶部
          _buildCard(),
          _buildTab(),
          if (_tabIndex == 1) _buildIntroduction(),
          if (_tabIndex == 2) _buildCourseOutline(),
          SliverToBoxAdapter(child: SizedBox(height: 88.h)),
        ],
      ),
    );
  }

  /// 课程封面图（在顶部）
  /// 对应小程序: .header-image-wrap (Line 503-535)
  Widget _buildCoverImage() {
    // ✅ 使用 _completePath 拼接完整URL
    final coverPath = _completePath(_goodsDetail?.materialCoverPath);
    
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        height: 300.h, // 小程序: 300px
        child: Stack(
          children: [
            // ✅ 背景图片
            Positioned.fill(
              child: coverPath != null && coverPath.isNotEmpty
                  ? Image.network(
                      coverPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFE5E5E5),
                          child: Icon(Icons.image, size: 60.sp, color: Colors.grey),
                        );
                      },
                    )
                  : Container(
                      color: const Color(0xFFE5E5E5),
                      child: Icon(Icons.image, size: 60.sp, color: Colors.grey),
                    ),
            ),
            // ✅ 底部圆角遮罩（.fake-bar）
            Positioned(
              bottom: -1,
              left: 0,
              right: 0,
              child: Container(
                height: 15.h, // 30rpx ÷ 2 = 15.h
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.r),
                    topRight: Radius.circular(15.r),
                  ),
                ),
              ),
            ),
          ],
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
            if (_goodsDetail?.validityStartDateVal != null &&
                !_goodsDetail!.validityStartDateVal!.contains('0001')) ...[
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
        if (_goodsDetail?.shopType != null) ...[
          _buildCourseTypeIcon(_goodsDetail!.shopType!),
          SizedBox(width: 8.w),
        ],
        Expanded(
          child: Text(
            _goodsDetail?.name ?? '',
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
        if (_goodsDetail?.teachingTypeName != null)
          _buildTag(
            _goodsDetail!.teachingTypeName!,
            const Color(0xFFE3EBFF),
            const Color(0xFF2E68FF),
          ),
        if (_goodsDetail?.serviceTypeName != null)
          _buildTag(
            _goodsDetail!.serviceTypeName!,
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
    final startDate = _goodsDetail?.validityStartDateVal;
    final endDate = _goodsDetail?.validityEndDateVal;
    
    return Text(
      '有效时间: ${startDate ?? ''} - ${endDate ?? ''}',
      style: TextStyle(
        fontSize: 12.sp,
        color: const Color(0xFF999999),
      ),
    );
  }

  Widget _buildBottomInfo() {
    final permissionStatus = _goodsDetail?.permissionStatus;
    final salePrice = _goodsDetail?.salePrice;
    final studentNum = _goodsDetail?.studentNum;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (permissionStatus == '2' && salePrice != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '¥',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFFF6600),
                ),
              ),
              Text(
                salePrice,
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
          '${studentNum ?? 0}人购买',
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF999999),
          ),
        ),
      ],
    );
  }

  /// Tab切换
  /// 对应小程序: .tab (Line 747-786)
  Widget _buildTab() {
    final List<Map<String, dynamic>> tabList = _getTabList();

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 16.h), // 小程序: 32rpx
        height: 60.h, // 小程序: 120rpx
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r), // 小程序: 40rpx
            topRight: Radius.circular(20.r),
          ),
        ),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    SizedBox(height: 3.h),
                    Container(
                      height: 3.h, // 小程序: 6rpx
                      width: 40.w, // 小程序: 80rpx
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFF1469FF) // 小程序: rgba(20, 105, 255, 1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(2.r), // 小程序: 4rpx
                      ),
                    ),
                  ],
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
    // ✅ 使用 _completePath 拼接完整URL
    final introPath = _completePath(_goodsDetail?.materialIntroPath);
    
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 8.h),
        child: introPath != null && introPath.isNotEmpty
            ? Image.network(
                introPath,
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

  /// 课程小节项 - 简化版（单行居中对齐）
  /// 对应小程序: .section-line (Line 554-609)
  Widget _buildSectionItem(Map<String, dynamic> section) {
    // ✅ 对应小程序: v-if="section.is_trial_listening == 1"
    final canTrial = section['is_trial_listening'] == 1;
    final name = section['name']?.toString() ?? '';

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFF4F5F5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 蓝色竖条
          Container(
            width: 1.5,
            height: 12,
            decoration: BoxDecoration(
              color: const Color(0xFF3B7BFB),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          SizedBox(width: 6.w),
          // 课程名称
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF5B6E81),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // 试听按钮
          if (canTrial)
            SizedBox(width: 8.w),
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
  /// 对应小程序: .pay-bottom (Line 856-880)
  Widget _buildBottomBar() {
    final isPurchased = _goodsDetail?.permissionStatus == '1';

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h), // 小程序: 20rpx 0
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08), // 小程序: rgba(0, 0, 0, 0.08)
              blurRadius: 6, // 小程序: 12rpx
              offset: const Offset(0, -2), // 小程序: -4rpx
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Center(
            child: ElevatedButton(
              onPressed: isPurchased ? _onGoCourse : _onPurchase,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B7BFB), // 小程序: #3B7BFB
                foregroundColor: Colors.white,
                minimumSize: Size(238.w, 40.h), // 小程序: 476rpx × 80rpx
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r), // 小程序: 40rpx
                ),
                elevation: 0,
              ),
              child: Text(
                isPurchased ? '去学习' : '立即报名',
                style: TextStyle(
                  fontSize: 14.sp, // 小程序: 28rpx
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
  /// 对应小程序: tryListen() (Line 321-338)
  Future<void> _onTrialListen(Map<String, dynamic> section) async {
    try {
      EasyLoading.show(status: '加载中...');
      
      // ✅ 对应小程序: trialListen API
      // trialListen({ goods_id: section.goods_id, system_id: section.system_id })
      final goodsId = section['goods_id']?.toString() ?? widget.goodsId;
      final systemId = section['system_id']?.toString() ?? section['id']?.toString() ?? '';
      
      print('🎧 试听课程:');
      print('   商品ID: $goodsId');
      print('   章节ID: $systemId');
      print('   章节名称: ${section['name']}');
      
      // TODO: 调用试听接口
      // final response = await ref.read(courseServiceProvider).trialListen(
      //   goodsId: goodsId,
      //   systemId: systemId,
      // );
      
      // Mock演示：模拟网络请求延迟
      await Future.delayed(const Duration(milliseconds: 500));
      
      EasyLoading.dismiss();
      
      // ✅ 对应小程序: if (res.data && res.data.path)
      // Mock数据：假设返回了视频路径
      final String? videoPath = 'course/test/video.mp4'; // 相对路径
      
      if (videoPath != null && videoPath.isNotEmpty) {
        // ✅ 对应小程序: completePath(res.data.path)
        final fullPath = _completePath(videoPath);
        
        // ✅ 对应小程序: this.$xh.push('jintiku', `pages/course/listenVideo?url=...`)
        if (mounted) {
          context.push(
            AppRoutes.videoIndex,
            extra: {
              'url': fullPath,
              'goods_id': goodsId,
              'system_id': systemId,
              'name': section['name'] ?? '',
            },
          );
        }
      } else {
        // ✅ 对应小程序: this.$xh.Toast('还没有试听内容')
        EasyLoading.showInfo('还没有试听内容');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('加载失败: $e');
      print('❌ 试听失败: $e');
    }
  }

  /// 报名/购买流程 - 对应小程序 getOrder 方法 (Line 417-476)
  /// ✅ MVVM架构: View层调用ViewModel方法，不包含业务逻辑
  /// 流程:
  ///   1. 创建订单 (POST /c/order/v2)
  ///   2. 判断金额:
  ///      - > 0 元: 跳转支付页面
  ///      - = 0 元: 直接跳转支付成功页
  Future<void> _onPurchase() async {
    try {
      EasyLoading.show(status: '创建订单中...');
      
      // 1. ✅ 获取商品信息 - 安全转换
      final goodsId = _goodsDetail?.goodsId?.toString() ?? '';
      final salePrice = _goodsDetail?.salePrice ?? '0';
      final payableAmount = double.tryParse(salePrice) ?? 0.0;
      
      // ✅ 对应小程序: goods_months_price_id 和 month
      final goodsMonthsPriceId = _goodsDetail?.goodsMonthsPriceId?.toString() ?? '';
      final months = _goodsDetail?.month?.toString() ?? '';
      
      // ✅ 对应小程序 Line 420: let student_id = uni.getStorageSync('__xingyun_userinfo__').student_id
      // 从Storage读取用户信息
      final storage = ref.read(storageServiceProvider);
      final userInfoJson = storage.getJson(StorageKeys.userInfo);
      final studentId = userInfoJson?['student_id']?.toString() ?? '';
      
      // ✅ 对应小程序 Line 447-448: employee_id
      final employeeId = '508948528815416786';
      
      // ✅ 验证必要参数
      if (goodsId.isEmpty) {
        EasyLoading.showError('商品ID不能为空');
        return;
      }
      
      if (studentId.isEmpty) {
        EasyLoading.showError('请先登录');
        return;
      }
      
      print('📦 开始报名流程:');
      print('   商品ID: $goodsId');
      print('   应付金额: $payableAmount');
      print('   商品月份价格ID: $goodsMonthsPriceId');
      print('   月份: $months');
      print('   学员ID: $studentId');
      print('   员工ID: $employeeId');
      
      // 2. ✅ 调用ViewModel创建订单
      final result = await ref.read(orderNotifierProvider.notifier).createOrder(
        goodsId: goodsId,
        goodsMonthsPriceId: goodsMonthsPriceId,
        months: months,
        payableAmount: payableAmount,
        studentId: studentId,
        employeeId: employeeId,
      );
      
      EasyLoading.dismiss();
      
      // 3. ✅ 处理业务结果 (View层只负责UI导航)
      // 对应小程序 Line 458-472
      result.when(
        needPayment: (orderId, flowId) {
          // ✅ 对应小程序 Line 458-463: if (Number(payable_amount) > 0)
          print('💰 需要支付,订单ID: $orderId, 流水ID: $flowId');
          if (mounted) {
            // TODO: 跳转支付页面
            context.push(
              '/payment',
              extra: {
                'order_id': orderId,
                'flow_id': flowId,
                'goods_id': goodsId,
              },
            );
          }
        },
        freeOrder: (orderId) {
          // ✅ 对应小程序 Line 464-472: else (0元课)
          // this.$xh.push('jintiku', `pages/order/paySuccess?goods_id=..&professional_id_name=..&isLearnButton=1`)
          print('🎉 0元课程,直接跳转成功页，订单ID: $orderId');
          if (mounted) {
            final professionalIdName = _goodsDetail?.professionalIdName?.toString() ?? '';
            context.push(
              AppRoutes.paySuccess,  // ✅ 使用正确的路由常量
              extra: {
                'goods_id': goodsId,
                'professional_id_name': professionalIdName,
                'isLearnButton': 1,
              },
            );
          }
        },
        error: (message) {
          // ✅ 错误处理
          print('❌ 创建订单失败: $message');
          EasyLoading.showError('创建订单失败: $message');
        },
      );
    } catch (e) {
      EasyLoading.dismiss();
      print('❌ 报名失败: $e');
      EasyLoading.showError('报名失败: $e');
    }
  }


  void _onGoCourse() {
    // 已购买-跳转学习中心
    context.go(AppRoutes.studyIndex);
  }
}
