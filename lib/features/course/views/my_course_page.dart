import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../app/routes/app_routes.dart';
import '../providers/my_course_provider.dart';
import '../../main/main_tab_page.dart'; // ✅ 导入mainTabIndexProvider

/// 我的课程页面 - 对应小程序 study/myCourse/index.vue
/// 功能：显示已购买的课程列表，支持按授课方式筛选
class MyCoursePage extends ConsumerStatefulWidget {
  const MyCoursePage({super.key});

  @override
  ConsumerState<MyCoursePage> createState() => _MyCoursePageState();
}

class _MyCoursePageState extends ConsumerState<MyCoursePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myCourseNotifierProvider.notifier).loadCourses();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = ref.read(myCourseNotifierProvider);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !state.isLoadingMore &&
        state.courseList.length < state.total) {
      ref.read(myCourseNotifierProvider.notifier).loadCourses(isLoadMore: true);
    }
  }

  /// 拼接完整图片URL
  /// 对应小程序: completePath() (course.vue Line 119-121)
  String _completePath(String? path) {
    if (path == null || path.isEmpty) {
      return '';
    }
    if (path.contains('http://') || path.contains('https://')) {
      return path;
    }
    return 'https://yakaixin.oss-cn-beijing.aliyuncs.com/$path';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myCourseNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      appBar: AppBar(title: const Text('我的课程'), backgroundColor: Colors.white),
      body: Column(
        children: [
          _buildTeachingTypeTab(state.teachingType),
          Expanded(child: _buildCourseList(state)),
        ],
      ),
    );
  }

  /// 授课方式Tab
  /// 对应小程序: teachingTypeTab.vue
  /// 注意：小程序只有"录播课"(3)和"直播课"(1)，没有"全部"
  Widget _buildTeachingTypeTab(String currentType) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 16.h, bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabItem('3', '录播课', currentType),
          _buildTabItem('1', '直播课', currentType),
        ],
      ),
    );
  }

  /// Tab项
  /// 对应小程序: teachingTypeTab.vue Line 9-16 (下划线样式)
  Widget _buildTabItem(String value, String label, String currentType) {
    final isSelected = currentType == value;
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          ref.read(myCourseNotifierProvider.notifier).changeTeachingType(value);
        }
      },
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isSelected ? 17.sp : 14.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? const Color(0xFF333333)
                  : const Color(0xFF999999),
            ),
          ),
          SizedBox(height: 3.h),
          if (isSelected)
            Container(
              width: 22.w,
              height: 3.h,
              decoration: BoxDecoration(
                color: const Color(0xFF018CFF),
                borderRadius: BorderRadius.circular(1.5.r),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCourseList(MyCourseState state) {
    if (state.isLoading && state.courseList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.courseList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text(
              state.error ?? '加载失败',
              style: TextStyle(fontSize: 14.sp, color: Colors.red),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () =>
                  ref.read(myCourseNotifierProvider.notifier).refresh(),
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (state.courseList.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      // ✅ 修复1: 尺寸除以2（小程序750rpx = Flutter 375）
      padding: EdgeInsets.fromLTRB(
        16.w,
        8.h,
        17.w,
        8.h,
      ), // 32rpx/2=16, 16rpx/2=8, 34rpx/2=17
      itemCount: state.courseList.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.courseList.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        return _CourseItem(
          course: state.courseList[index],
          completePath: _completePath,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/4045173295663081752515_8b3592c2dcddcac66af8ddd46abbbf1b74efa19fac63-AlBs3V_fw1200%402x.png',
            width: 156.w,
            height: 102.h,
            errorBuilder: (_, __, ___) => Icon(
              Icons.school_outlined,
              size: 80.sp,
              color: Colors.grey[300],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '未找到符合的学习内容',
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF999999)),
          ),
          SizedBox(height: 32.h),
          GestureDetector(
            onTap: () {
              // ✅ 修复：返回MainTabBar并切换到“课程”Tab（index=2）
              // MainTabPage的Tab索引：0=首页, 1=题库, 2=课程, 3=我的
              context.go('/main-tab');
              // 切换到课程Tab
              ref.read(mainTabIndexProvider.notifier).state = 2;
            },
            child: Container(
              width: 122.w,
              height: 34.h,
              decoration: BoxDecoration(
                color: const Color(0xFF018CFF),
                borderRadius: BorderRadius.circular(22.r),
              ),
              alignment: Alignment.center,
              child: Text(
                '我要去选课',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 课程项组件
/// 对应小程序: course.vue
class _CourseItem extends StatelessWidget {
  final Map<String, dynamic> course;
  final String Function(String?) completePath;

  const _CourseItem({required this.course, required this.completePath});

  @override
  Widget build(BuildContext context) {
    final goodsName = course['goods_name']?.toString() ?? '';
    final teachingTypeName = course['teaching_type_name']?.toString() ?? '';
    final classInfo = course['class'] as Map<String, dynamic>?;
    final classDate = classInfo?['date']?.toString() ?? '';
    final goodsPid = course['goods_pid']?.toString() ?? '';
    final goodsPidName = course['goods_pid_name']?.toString() ?? '';
    final teachers = (classInfo?['teacher'] as List?) ?? [];
    final evaluationType = (course['evaluation_type'] as List?) ?? [];
    final businessType = course['business_type'];

    return GestureDetector(
      onTap: () => _goToCourseDetail(context),
      child: Container(
        // ✅ 修复1: 尺寸除以2（20rpx/2=10）
        margin: EdgeInsets.only(bottom: 10.h),
        // ✅ 修复1: padding尺寸除以2（34rpx/2=17, 32rpx/2=16, 18rpx/2=9）
        // padding: EdgeInsets.fromLTRB(16.w, 17.h, 16.w, 9.h),
        decoration: BoxDecoration(
          color: Colors.white,
          // ✅ 修复1: 圆角除以2（32rpx/2=16）
          borderRadius: BorderRadius.circular(16.r),
          // ✅ 高端/私塾背景图（对应小程序 Line 324-336）
          image: businessType == 2
              ? const DecorationImage(
                  image: NetworkImage(
                    'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/61c7173510867228878785_gaoduan.png',
                  ),
                  fit: BoxFit.cover,
                )
              : businessType == 3
              ? const DecorationImage(
                  image: NetworkImage(
                    'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/6c3f173510870217835730_sishu.png',
                  ),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Stack(
          children: [
            // ✅ 修复2: 左上角标签，紧贴左上角（left: 0, top: 0）
            if (teachingTypeName.isNotEmpty)
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  // ✅ 修复1: 尺寸除以2（160rpx/2=80, 50rpx/2=25）
                  width: 80.w,
                  height: 25.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF04C140),
                    borderRadius: BorderRadius.only(
                      // ✅ 修复1: 圆角除以2（32rpx/2=16）
                      topLeft: Radius.circular(16.r),
                      bottomRight: Radius.circular(16.r),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    teachingTypeName,
                    style: TextStyle(
                      // ✅ 修复1: 字体除以2（24rpx/2=12）
                      fontSize: 12.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      // ✅ 修复1: 字间距除以2（10rpx/2=5）
                      letterSpacing: 5.w,
                    ),
                  ),
                ),
              ),

            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10), // 内边距设置
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ 修复1: 尺寸除以2（50rpx/2=25）
                  SizedBox(height: teachingTypeName.isNotEmpty ? 25.h : 0),
                  // ✅ 课程名称（对应小程序 Line 15）
                  Text(
                    goodsName,
                    style: TextStyle(
                      // ✅ 修复1: 字体除以2（34rpx/2=17）
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF262629),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // ✅ 修复1: 间距除以2（15rpx/2=7.5）
                  SizedBox(height: 7.5.h),
                  // ✅ 课程日期（对应小程序 Line 18-19）
                  if (classDate.isNotEmpty)
                    Text(
                      classDate,
                      style: TextStyle(
                        // ✅ 修复1: 字体除以2（24rpx/2=12）
                        fontSize: 12.sp,
                        color: const Color(0xFF4783DC),
                      ),
                    ),
                  // ✅ 套餐信息（对应小程序 Line 20-23）
                  if (goodsPid.isNotEmpty && goodsPid != '0')
                    Padding(
                      // ✅ 修复1: 间距除以2（20rpx/2=10）
                      padding: EdgeInsets.only(top: 10.h),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            // ✅ 修复1: 字体除以2（22rpx/2=11）
                            fontSize: 11.sp,
                            color: const Color(0xFF4783DC),
                          ),
                          children: [
                            const TextSpan(text: '套餐：'),
                            TextSpan(text: goodsPidName),
                          ],
                        ),
                      ),
                    ),
                  // ✅ 修复1: 间距除以2（32rpx/2=16）
                  SizedBox(height: 16.h),
                  // ✅ 教师列表（对应小程序 Line 39-49）
                  if (teachers.isNotEmpty) _buildTeachersList(teachers),
                  // ✅ 修复1: 间距除以2（14rpx/2=7）
                  SizedBox(height: 7.h),
                  // ✅ 操作按钮（对应小程序 Line 50-63）
                  if (evaluationType.isNotEmpty)
                    _buildEvaluationButtons(context, evaluationType),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 教师列表
  /// 对应小程序: course.vue Line 39-49
  Widget _buildTeachersList(List teachers) {
    return Wrap(
      spacing: 0,
      // ✅ 修复1: 间距除以2（22rpx/2=11）
      runSpacing: 11.h,
      children: teachers.map((teacher) {
        final avatar = teacher['avatar']?.toString() ?? '';
        final name = teacher['name']?.toString() ?? '';
        final title = teacher['title']?.toString() ?? '';
        final avatarUrl = avatar.isNotEmpty ? completePath(avatar) : '';

        return Container(
          width: double.infinity,
          // ✅ 修复1: 间距除以2（22rpx/2=11）
          margin: EdgeInsets.only(bottom: 11.h),
          child: Row(
            children: [
              // 头像
              Container(
                // ✅ 修复1: 尺寸除以2（80rpx/2=40）
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // ✅ 修复1: 边框除以2（2rpx/2=1）
                  border: Border.all(color: Colors.green, width: 1.w),
                ),
                child: ClipOval(
                  child: avatarUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: avatarUrl,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Image.network(
                            'https://yakaixin.oss-cn-beijing.aliyuncs.com/public/teacher_avatar.png',
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.network(
                          'https://yakaixin.oss-cn-beijing.aliyuncs.com/public/teacher_avatar.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              // ✅ 修复1: 间距除以2（10rpx/2=5）
              SizedBox(width: 5.w),
              // 姓名和职称
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        // ✅ 修复1: 字体除以2（24rpx/2=12）
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF262629),
                      ),
                    ),
                    // ✅ 修复1: 间距除以2（6rpx/2=3）
                    SizedBox(height: 3.h),
                    Text(
                      title,
                      style: TextStyle(
                        // ✅ 修复1: 字体除以2（24rpx/2=12）
                        fontSize: 12.sp,
                        color: const Color(0xFF262629).withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// 操作按钮（evaluation_type）
  /// 对应小程序: course.vue Line 50-63
  Widget _buildEvaluationButtons(BuildContext context, List evaluationType) {
    final validButtons = evaluationType
        .where(
          (btn) =>
              btn['paper_version_id'] != null &&
              btn['paper_version_id'] != '0' &&
              btn['paper_version_id'] != 0,
        )
        .toList();

    if (validButtons.isEmpty) return const SizedBox.shrink();

    return Wrap(
      // ✅ 修复1: 间距除以2（16rpx/2=8）
      spacing: 8.w,
      runSpacing: 8.h,
      children: validButtons.map((btn) {
        return GestureDetector(
          onTap: () => _goToAnswer(context, btn),
          child: Container(
            // ✅ 修复1: padding除以2（24rpx/2=12, 16rpx/2=8）
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              // ✅ 修复1: 边框除以2（3rpx/2=1.5）
              border: Border.all(color: Colors.black, width: 1.5.w),
              // ✅ 修复1: 圆角除以2（44rpx/2=22）
              borderRadius: BorderRadius.circular(22.r),
            ),
            child: Text(
              btn['name']?.toString() ?? '',
              style: TextStyle(
                // ✅ 修复1: 字体除以2（20rpx/2=10）
                fontSize: 10.sp,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 跳转到课程详情
  /// 对应小程序: goLearnCourseDetails() Line 113-117
  void _goToCourseDetail(BuildContext context) {
    context.push(
      AppRoutes.courseDetail,
      extra: {
        'goodsId': course['goods_id']?.toString() ?? '',
        'orderId': course['order_id']?.toString() ?? '',
        'goodsPid': course['goods_pid']?.toString() ?? '',
      },
    );
  }

  /// 跳转到答题页面
  /// 对应小程序: goAnswer() Line 123-128
  void _goToAnswer(BuildContext context, Map<String, dynamic> btn) {
    context.push(
      AppRoutes.makeQuestion,
      extra: {
        'paper_version_id': btn['paper_version_id']?.toString() ?? '',
        'evaluation_type_id': btn['id']?.toString() ?? '',
        'professional_id': btn['professional_id']?.toString() ?? '',
        'goods_id': course['paper_goods_id']?.toString() ?? '',
        'order_id': course['order_id']?.toString() ?? '',
        'system_id': course['system_id']?.toString() ?? '',
        'order_detail_id': course['order_goods_detail_id']?.toString() ?? '',
      },
    );
  }
}
