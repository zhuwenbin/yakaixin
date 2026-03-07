import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/style/app_style_provider.dart';
import '../providers/my_course_provider.dart';
import '../../main/main_tab_page.dart';
import '../../../../app/config/api_config.dart';
import '../../../core/widgets/common_state_widget.dart';
import '../widgets/course_item_card.dart';

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

  /// 拼接完整图片URL（使用 ApiConfig.completeImageUrl，避免双斜杠）
  String _completePath(String? path) {
    return ApiConfig.completeImageUrl(path);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myCourseNotifierProvider);
    final indicatorColor = ref.watch(appStyleTokensProvider).colors.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      appBar: AppBar(title: const Text('我的课程'), backgroundColor: Colors.white),
      body: Column(
        children: [
          _buildTeachingTypeTab(state.teachingType, indicatorColor),
          Expanded(child: _buildCourseList(state)),
        ],
      ),
    );
  }

  /// 授课方式Tab
  /// 对应小程序: teachingTypeTab.vue
  Widget _buildTeachingTypeTab(String currentType, Color indicatorColor) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 16.h, bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabItem('3', '录播课', currentType, indicatorColor),
          _buildTabItem('1', '直播课', currentType, indicatorColor),
        ],
      ),
    );
  }

  /// Tab项（下划线使用模板主色）
  Widget _buildTabItem(String value, String label, String currentType, Color indicatorColor) {
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
                color: indicatorColor,
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
      return CommonStateWidget.loadError(
        message: state.error!,
        onRetry: () => ref.read(myCourseNotifierProvider.notifier).refresh(),
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
        return CourseItemCard(
          courseData: state.courseList[index],
          completePath: _completePath,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return CommonStateWidget.noCourse(
      message: '未找到符合的学习内容',
      onAction: () {
        // ✅ 修复：返回MainTabBar并切换到“课程”Tab（index=2）
        // MainTabPage的Tab索引：0=首页, 1=题库, 2=课程, 3=我的
        context.go('/main-tab');
        // 切换到课程Tab
        ref.read(mainTabIndexProvider.notifier).state =
        tabIndexForPage(kPageIndexCourse, ref.read(appStyleTokensProvider).images.tabBarOrder);
      },
    );
  }
}
