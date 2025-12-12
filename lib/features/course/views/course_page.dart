import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/course_provider.dart';
import '../widgets/week_calendar.dart';
import '../widgets/today_lessons_section.dart';
import '../widgets/study_plan_section.dart';
import '../widgets/full_calendar.dart';
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
  bool _showCalendar = false;

  // ✅ Overlay 相关
  OverlayEntry? _calendarOverlay;
  final LayerLink _layerLink = LayerLink();

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

  @override
  void dispose() {
    _removeCalendarOverlay();
    super.dispose();
  }

  /// 显示日历 Overlay
  void _showCalendarOverlay() {
    _removeCalendarOverlay();

    // ✅ 获取当前 dotDates
    final dotDates = ref.read(courseNotifierProvider).dotDates;

    _calendarOverlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // 遮罩层
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeCalendarOverlay,
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
          ),
          // 日历下拉框 - 从周历底部展开
          Positioned(
            width: MediaQuery.of(context).size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(
                0,
                42.h + 7.h + 5.h,
              ), // ✅ 周历高度(42h) + 底部padding(7h) + 顶部padding(5h)
              child: Material(
                color: Colors.transparent,
                child: Container(
                  height: 500.h,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: _buildFullCalendar(dotDates),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_calendarOverlay!);
    setState(() {
      _showCalendar = true;
    });
  }

  /// 移除日历 Overlay
  void _removeCalendarOverlay() {
    _calendarOverlay?.remove();
    _calendarOverlay = null;
    // ✅ 修复：dispose时不能调用setState，需要判断mounted状态
    if (mounted) {
      setState(() {
        _showCalendar = false;
      });
    }
  }

  /// 显示/隐藏日历 Overlay
  void _toggleCalendarOverlay() {
    if (_showCalendar) {
      _removeCalendarOverlay();
    } else {
      _showCalendarOverlay();
    }
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
    final showPlan = courseState.showPlan;

    return Scaffold(
      backgroundColor: AppColors.backgroundLightGray,
      body: Column(
        children: [
          _buildAppBar(),
          WeekCalendar(
            selectedDate: _selectedDate,
            dotDates: dotDates,
            layerLink: _layerLink,
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

  /// 完整日历选择器
  Widget _buildFullCalendar(List<String> dotDates) {
    return FullCalendar(
      selectedDate: _selectedDate,
      dotDates: dotDates,
      onDaySelected: (selectedDay) async {
        setState(() {
          _selectedDate = selectedDay;
        });
        _removeCalendarOverlay();
        final notifier = ref.read(courseNotifierProvider.notifier);
        await Future.wait([
          notifier.loadDateLessons(selectedDay),
          notifier.loadDateCourse(selectedDay, _teachingType),
        ]);
      },
      onPageChanged: (focusedDay) {
        ref.read(courseNotifierProvider.notifier).refreshCalendar();
      },
    );
  }
}
