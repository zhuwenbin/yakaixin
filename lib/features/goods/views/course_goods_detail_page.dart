import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/utils/safe_type_converter.dart';
import '../../../core/utils/error_message_mapper.dart';
import '../../../core/payment/payment_flow_manager.dart';
import '../../../core/widgets/common_state_widget.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../home/services/goods_service.dart';
import '../../home/models/goods_model.dart';
import '../../main/main_tab_page.dart';
import '../../../core/storage/storage_service.dart';
import '../../../app/constants/storage_keys.dart';

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

class _CourseGoodsDetailPageState extends ConsumerState<CourseGoodsDetailPage> {
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
      // 对应小程序: courseDetail.vue Line 362-369
      // ⚠️ 重要: 商品详情页需要传 user_id 和 student_id 来获取 permission_status
      // ⚠️ 这样后端才能判断用户是否已购买，从而返回正确的 permission_status
      // ⚠️ permission_status='1' (已购买) → 显示"去学习"
      // ⚠️ permission_status='2' (未购买) → 显示"立即报名"
      final goodsService = ref.read(goodsServiceProvider);
      final storage = ref.read(storageServiceProvider);

      // 获取用户信息（如果已登录）
      final studentId = storage.getString(StorageKeys.studentId);

      final response = await goodsService.getGoodsDetail(
        goodsId: widget.goodsId!,
        userId: studentId, // ✅ 传入 user_id 以获取购买状态
        studentId: studentId, // ✅ 传入 student_id 以获取购买状态
        noProfessionalId: '1', // 不筛选专业ID
      );

      setState(() {
        _goodsDetail = response;
        _isLoading = false;
      });

      // ✅ 如果有课程大纲数据(detail_package_goods)，加载课程章节
      if (response.detailPackageGoods != null &&
          response.detailPackageGoods!.isNotEmpty) {
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
    } on DioException catch (e) {
      // ✅ 使用拦截器已处理好的用户友好错误信息
      final errorMsg = e.error?.toString() ?? '加载课程失败';
      setState(() {
        _errorMessage = errorMsg;
        _isLoading = false;
      });
      print('❌ 加载商品详情失败 (DioException): $e');
      EasyLoading.showError(errorMsg);
    } catch (e) {
      setState(() {
        _errorMessage = '加载课程失败，请稍后重试';
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
        // noUserId: '1',
      );

      // ✅ 解析章节数据并设置默认展开状态
      // 遵守 @data_type_safety.md: 安全的类型转换
      final chapters =
          (response as List?)?.map((item) {
            // ✅ 安全转换: dynamic -> Map<String, dynamic>
            final chapterMap = item is Map<String, dynamic>
                ? item
                : (item as Map).cast<String, dynamic>();

            return {
              ...chapterMap,
              'expand': true, // 默认展开所有章节
            };
          }).toList() ??
          [];

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
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          title: const Text('课程详情'),
          backgroundColor: AppColors.surface,
          elevation: 0,
          foregroundColor: AppColors.textPrimary,
        ),
        body: Stack(
          children: [
            if (_isLoading)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    SizedBox(height: AppSpacing.mdV),
                    Text('加载中...', style: AppTextStyles.bodyMedium),
                  ],
                ),
              )
            else if (_errorMessage != null)
              CommonStateWidget.loadError(
                message: _errorMessage!,
                onRetry: _loadGoodsDetail,
              )
            else if (_goodsDetail != null)
              _buildBody()
            else
              CommonStateWidget.empty(message: '暂无数据'),
            // ✅ 已购买(permissionStatus='1')显示"去学习"，未购买(permissionStatus='2')显示"立即报名"
            if (!_isLoading && _goodsDetail != null) _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      color: AppColors.background,
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
              child: coverPath.isNotEmpty
                  ? Image.network(
                      coverPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.card,
                          child: Icon(
                            Icons.image,
                            size: 60.sp,
                            color: AppColors.textHint,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: AppColors.card,
                      child: Icon(
                        Icons.image,
                        size: 60.sp,
                        color: AppColors.textHint,
                      ),
                    ),
            ),
            // ✅ 底部圆角遮罩（.fake-bar）
            Positioned(
              bottom: -1,
              left: 0,
              right: 0,
              child: Container(
                height: 15.h,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.lg),
                    topRight: Radius.circular(AppRadius.lg),
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
        color: AppColors.surface,
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.mdV,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            SizedBox(height: AppSpacing.smV),
            _buildTags(),
            if (_goodsDetail?.validityStartDateVal != null &&
                !_goodsDetail!.validityStartDateVal!.contains('0001')) ...[
              SizedBox(height: AppSpacing.smV),
              _buildValidityTime(),
            ],
            SizedBox(height: AppSpacing.mdV),
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
            style: AppTextStyles.courseTitle,
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
      spacing: AppSpacing.sm,
      children: [
        if (_goodsDetail?.teachingTypeName != null)
          _buildTag(
            _goodsDetail!.teachingTypeName!,
            AppColors.courseTagBg,
            AppColors.courseTagText,
          ),
        if (_goodsDetail?.serviceTypeName != null)
          _buildTag(
            _goodsDetail!.serviceTypeName!,
            AppColors.card,
            AppColors.textPrimary,
          ),
      ],
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelMedium.copyWith(color: textColor),
      ),
    );
  }

  Widget _buildValidityTime() {
    final startDate = _goodsDetail?.validityStartDateVal;
    final endDate = _goodsDetail?.validityEndDateVal;

    return Text(
      '有效时间: ${startDate ?? ''} - ${endDate ?? ''}',
      style: AppTextStyles.labelMedium.copyWith(color: AppColors.textHint),
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
                  color: AppColors.coursePrice,
                ),
              ),
              Text(
                salePrice,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.coursePrice,
                ),
              ),
            ],
          )
        else
          const SizedBox.shrink(),
        Text(
          '${studentNum ?? 0}人购买',
          style: AppTextStyles.labelMedium.copyWith(color: AppColors.textHint),
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
        margin: EdgeInsets.only(top: AppSpacing.mdV),
        height: 60.h,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
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
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isActive
                                ? AppColors.primary
                                : AppColors.textHint,
                          ),
                        ),
                        if (tab['hasIcon'] == true) ...[
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.play_circle,
                            size: 16.sp,
                            color: isActive
                                ? AppColors.primary
                                : AppColors.textHint,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Container(
                      height: 3.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(2.r),
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
        color: AppColors.surface,
        margin: EdgeInsets.only(top: AppSpacing.smV),
        child: introPath.isNotEmpty
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
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textHint,
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
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textHint,
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
        color: AppColors.surface,
        margin: EdgeInsets.only(top: AppSpacing.smV),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.smV,
        ),
        child: _courseList.isEmpty
            ? Container(
                height: 200.h,
                alignment: Alignment.center,
                child: Text(
                  '暂无课程大纲',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textHint,
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
            style: AppTextStyles.heading4.copyWith(
              color: AppColors.textPrimary,
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
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  '${subs.length}节',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Icon(
                  isExpand
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 20.sp,
                  color: AppColors.textHint,
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
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 蓝色竖条
          Container(
            width: 1.5,
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          SizedBox(width: 6.w),
          // 课程名称
          Expanded(
            child: Text(
              name,
              style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // 试听按钮
          if (canTrial) SizedBox(width: AppSpacing.sm),
          if (canTrial)
            GestureDetector(
              onTap: () => _onTrialListen(section),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.courseTagBg,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Text(
                  '开始试听',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
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
        padding: EdgeInsets.symmetric(vertical: AppSpacing.smV),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadowLight,
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Center(
            child: ElevatedButton(
              // ✅ 修复：已购买跳转到学习页面，未购买跳转到支付页面
              onPressed: isPurchased ? _onGoCourse : _onPurchase,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textWhite,
                minimumSize: Size(238.w, 40.h),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                elevation: 0,
              ),
              child: Text(
                isPurchased ? '去学习' : '立即报名',
                style: AppTextStyles.buttonMedium,
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
      final systemId =
          section['system_id']?.toString() ?? section['id']?.toString() ?? '';

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

  /// 报名/购买流程（使用统一支付管理器）
  /// 对应小程序 getOrder 方法 (Line 417-476)
  Future<void> _onPurchase() async {
    // 准备参数
    final goodsId = SafeTypeConverter.toSafeString(
      _goodsDetail?.goodsId,
      defaultValue: '',
    );
    if (goodsId.isEmpty) {
      EasyLoading.showError('商品ID不能为空');
      return;
    }

    final salePrice = _goodsDetail?.salePrice ?? '0';
    final payableAmount = double.tryParse(salePrice) ?? 0.0;
    final goodsMonthsPriceId = SafeTypeConverter.toSafeString(
      _goodsDetail?.goodsMonthsPriceId,
      defaultValue: '',
    );
    final months = SafeTypeConverter.toSafeString(
      _goodsDetail?.month,
      defaultValue: '0',
    );

    // ✅ 使用统一支付流程管理器
    await context.startPayment(
      ref: ref,
      goodsId: goodsId,
      goodsMonthsPriceId: goodsMonthsPriceId,
      months: months,
      payableAmount: payableAmount,
      goodsName: _goodsDetail?.name ?? '课程',
      professionalIdName: _goodsDetail?.professionalIdName,
      refreshGoodsId: goodsId,
      isLearnButton: 0, // 支付成功页显示"开始测验"按钮
      onSuccess: () async {
        // 支付成功：刷新商品详情
        print('✅ [课程商品] 支付成功，刷新商品详情');
        await _loadGoodsDetail();
        EasyLoading.showSuccess('购买成功');
      },
      onError: (error) {
        // 支付失败：显示错误
        print('❌ [课程商品] 支付失败: $error');
      },
    );
  }

  /// 去学习
  /// ✅ 返回主页面并切换到课程 Tab（索引 2）
  /// 参考: pay_success_page.dart Line 327-334
  void _onGoCourse() {
    if (mounted) {
      // 1. 设置 Tab 索引为课程页（索引 2）
      ref.read(mainTabIndexProvider.notifier).state = 2;
      // 2. 返回主 Tab 页面
      context.go(AppRoutes.mainTab);
    }
  }
}
