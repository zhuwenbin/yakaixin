import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/course_provider.dart';
import '../widgets/week_calendar.dart';
import '../widgets/today_lessons_section.dart';
import '../widgets/study_plan_section.dart';
import '../widgets/calendar_dialog.dart';
import '../widgets/empty_state_widget.dart';

/// 上课主页 - 对应小程序: src/modules/jintiku/pages/study/index.vue
///
/// 主要功能：
/// 1. 日历选择器 - 选择日期查看当天课程
/// 2. 今日课程列表 (LessonsList) - 显示选中日期的课节
/// 3. 学习计划 (CourseList) - 显示课程列表,支持授课形式筛选
/// 4. 空状态提示 (NotLearn)
class CoursePage extends ConsumerStatefulWidget {
  const CoursePage({super.key});

  @override
  ConsumerState<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends ConsumerState<CoursePage> {
  DateTime _selectedDate = DateTime.now();
  String _teachingType = ''; // "": 全部, "1": 直播, "2": 面授, "3": 录播

  @override
  void initState() {
    super.initState();
    // ✅ 使用 Provider 加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(courseNotifierProvider.notifier)
          .loadInitialData(_selectedDate, _teachingType);
    });
  }

  /// 显示/隐藏日历弹窗（和专业选择下拉动画效果一致）
  /// ✅ 不传递 topOffset，让 Dialog 在 build 方法中计算（和专业选择下拉一致）
  void _toggleCalendarOverlay() {
    // ✅ 获取当前 dotDates
    final dotDates = ref.read(courseNotifierProvider).dotDates;

    // ✅ 显示日历弹窗（和专业选择下拉动画效果一致）
    // 不传递 topOffset，让 Dialog 在 build 方法中使用 Dialog 的 context 计算位置
    // 这样可以确保 MediaQuery 在不同平台上都正确
    showCalendarDialog(
      context,
      selectedDate: _selectedDate,
      dotDates: dotDates,
      onDaySelected: (selectedDay) async {
        setState(() {
          _selectedDate = selectedDay;
        });
        final notifier = ref.read(courseNotifierProvider.notifier);
        await Future.wait([
          notifier.loadDateLessons(selectedDay),
          notifier.loadDateCourse(selectedDay, _teachingType),
        ]);
      },
      onPageChanged: (focusedDay) {
        ref.read(courseNotifierProvider.notifier).refreshCalendar();
      },
      // ✅ 不传递 topOffset，让 Dialog 自己计算（和专业选择下拉一致）
    );
  }

  /// 处理日期选择
  Future<void> _handleDateSelected(DateTime day) async {
    setState(() {
      _selectedDate = day;
    });
    final notifier = ref.read(courseNotifierProvider.notifier);
    await Future.wait([
      notifier.loadDateLessons(day),
      notifier.loadDateCourse(day, _teachingType),
    ]);
  }

  /// 处理授课形式切换
  void _handleTeachingTypeChange(String value) {
    setState(() {
      _teachingType = value;
    });
    ref
        .read(courseNotifierProvider.notifier)
        .loadDateCourse(_selectedDate, value);
  }

  @override
  Widget build(BuildContext context) {
    final courseState = ref.watch(courseNotifierProvider);
    final dotDates = courseState.dotDates;
    final lessonsData = courseState.lessonsData;
    final courseList = courseState.courseList;
    final isLoading = courseState.isLoading;
    final isCourseListLoading = courseState.isCourseListLoading;
    
    // ✅ 仅「已登录→未登录」时在此刷新；「未登录→已登录」由 Auth 的 _refreshAllPagesAfterLogin 统一刷新
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (previous?.isLoggedIn == true && !next.isLoggedIn) {
        print('🔄 [课程页] 检测到登录状态变化（已登录 → 未登录），刷新课程数据');
        ref.read(courseNotifierProvider.notifier).loadInitialData(_selectedDate, _teachingType);
      }
    });
    final showPlan = courseState.showPlan;

    return Scaffold(
      backgroundColor: AppColors.backgroundLightGray,
      body: Column(
        children: [
          _buildAppBar(),
          WeekCalendar(
            selectedDate: _selectedDate,
            dotDates: dotDates,
            layerLink: LayerLink(), // ✅ 保留参数以保持兼容性，但不再使用
            onDateSelected: _handleDateSelected,
            onShowFullCalendar: _toggleCalendarOverlay,
          ),
          SizedBox(height: 15.h),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      if (lessonsData != null &&
                          (lessonsData.lessonNum ?? '0') != '0')
                        TodayLessonsSection(
                          lessonNum: lessonsData.lessonNum ?? '0',
                          attendanceNum: lessonsData.lessonAttendanceNum ?? '0',
                          lessons: lessonsData.lessonAttendance,
                        ),
                      if (showPlan)
                        StudyPlanSection(
                          courseList: courseList,
                          isCourseListLoading: isCourseListLoading,
                          teachingType: _teachingType,
                          onTeachingTypeChanged: _handleTeachingTypeChange,
                        ),
                      if ((lessonsData == null ||
                              (lessonsData.lessonNum ?? '0') == '0') &&
                          courseList.isEmpty &&
                          !isLoading)
                        const EmptyStateWidget(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16.w,
        right: 16.w,
        bottom: 12.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('上课', style: AppTextStyles.heading3)],
      ),
    );
  }
}
