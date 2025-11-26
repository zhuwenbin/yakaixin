import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../app/routes/app_routes.dart';

/// 课程首页（上课）
/// 对应小程序: src/modules/jintiku/pages/study/index.vue
/// 
/// 主要功能：
/// 1. 日历选择器 - 选择日期查看当天课程
/// 2. 今日课程列表 - 显示选中日期的课程安排
/// 3. 学习计划 - 可筛选授课形式（全部/录播/直播/面授）
class CoursePage extends ConsumerStatefulWidget {
  const CoursePage({super.key});

  @override
  ConsumerState<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends ConsumerState<CoursePage> {
  DateTime _selectedDate = DateTime.now();
  String _teachingType = ''; // "": 全部, "1": 直播, "2": 面授, "3": 录播
  bool _showTeachingTypeSelector = false;
  bool _showCalendar = false; // 日历展开状态
  
  // Mock数据 - 打卡日期
  final List<String> _dotDates = [
    '2025-11-20',
    '2025-11-21',
    '2025-11-22',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildWeekCalendar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 12.h),
                        _buildTodayLessons(),
                        _buildStudyPlan(),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 日历遮罩 - 在最下层
          if (_showCalendar) _buildCalendarMask(),
          // 日历选择器 - 在遮罩上面
          if (_showCalendar)
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildWeekCalendar(),
                  _buildFullCalendar(),
                ],
              ),
            ),
          // 授课形式选择器遮罩
          if (_showTeachingTypeSelector) _buildTeachingTypeSelector(),
        ],
      ),
    );
  }

  /// 顶部Header
  /// 对应小程序: .header-box
  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '上课',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }

  /// 周日历选择器
  /// 对应小程序: ModuleStudySelectDate 组件
  Widget _buildWeekCalendar() {
    final weekDays = _getWeekDays(_selectedDate);
    final today = DateTime.now();
    
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(3.5.w, 2.5.h, 0, 3.5.h),
      child: Row(
        children: [
          ...weekDays.map((date) {
            final isSelected = _isSameDay(date, _selectedDate);
            final isToday = _isSameDay(date, today);
            final hasDot = _dotDates.contains(_formatDate(date));
            
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                  });
                },
                child: Container(
                  height: 42.h,
                  margin: EdgeInsets.only(right: 1.w),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF018CFF) : Colors.transparent,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isToday ? '今天' : _getWeekDayName(date),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF5B6E81),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        isSelected
                            ? '${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'
                            : date.day.toString(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF262629),
                        ),
                      ),
                      if (hasDot) ...[
                        SizedBox(height: 1.h),
                        Container(
                          width: 2.5.w,
                          height: 2.5.w,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : const Color(0xFF018CFF),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
          // "更多日期" 按钮
          Container(
            width: 25.5.w,
            margin: EdgeInsets.only(right: 10.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFAFCFF), Color(0xFFFFFFFF)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE8EAEF).withOpacity(0.22),
                  offset: const Offset(-2, 0),
                  blurRadius: 2,
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showCalendar = !_showCalendar;
                  _showTeachingTypeSelector = false; // 关闭授课形式选择器
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '更多',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xFF262629),
                      height: 1.6,
                    ),
                  ),
                  Text(
                    '日期',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xFF262629),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 今日课程列表
  /// 对应小程序: ModuleStudyLessonsList 组件
  Widget _buildTodayLessons() {
    // Mock数据
    final todayLessons = _getMockTodayLessons();
    
    if (todayLessons.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.network(
                    'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/title-icon.png',
                    width: 15.w,
                    height: 15.w,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    '今日共',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF666666),
                    ),
                  ),
                  Text(
                    '${todayLessons.length}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFFFF860E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '节课',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
              Text(
                '已完成 0 节',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF999999),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // 课程列表
          ...todayLessons.map((lesson) => _buildLessonItem(lesson)),
        ],
      ),
    );
  }
  
  /// 课程项
  Widget _buildLessonItem(Map<String, dynamic> lesson) {
    return GestureDetector(
      onTap: () => _goLookCourse(lesson),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 左侧时间和类型
            Column(
              children: [
              Text(
                lesson['start_time'] ?? '09:00',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF333333),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getTeachingTypeColor(lesson['teaching_type']),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  _getTeachingTypeName(lesson['teaching_type']),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 12.w),
          // 右侧内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson['lesson_num'] ?? '',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  lesson['lesson_name'] ?? '',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF666666),
                  ),
                ),
                if (lesson['has_homework'] == true) ...[
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: () => _goAnswer(lesson, lesson['homework_btn']),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF018CFF)),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        '课前作业',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF018CFF),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
  
  /// 学习计划
  /// 对应小程序: ModuleStudyCourseList 组件
  Widget _buildStudyPlan() {
    final courseList = _getMockCourseList();
    
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 0),
      color: const Color(0xFFF5F5F5), // 小程序背景色
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Row(
            children: [
              Image.network(
                'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/title-icon.png',
                width: 15.w,
                height: 15.w,
              ),
              SizedBox(width: 5.w),
              Text(
                '学习计划',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF262629),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // 筛选栏
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showTeachingTypeSelector = true;
                  });
                },
                child: Text(
                  _getTeachingTypeDisplayName(_teachingType),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF262629),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.push(AppRoutes.myCourse);
                },
                child: Text(
                  '我的课程',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF03203D).withOpacity(0.75),
                  ),
                ),
              ),
            ],
          ),
          // 课程列表
          if (courseList.isEmpty)
            _buildEmptyCourseList()
          else
            Padding(
              padding: EdgeInsets.only(top: 20.h, bottom: 8.h),
              child: Column(
                children: courseList.map((course) => _buildCourseCard(course)).toList(),
              ),
            ),
        ],
      ),
    );
  }
  
  /// 空课程列表
  Widget _buildEmptyCourseList() {
    return Column(
      children: [
        SizedBox(height: 30.h),
        Image.network(
          'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/4045173295663081752515_8b3592c2dcddcac66af8ddd46abbbf1b74efa19fac63-AlBs3V_fw1200%402x.png',
          width: 120.w,
          height: 120.w,
        ),
        SizedBox(height: 16.h),
        Text(
          '未找到符合的学习内容',
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF999999),
          ),
        ),
        SizedBox(height: 30.h),
      ],
    );
  }
  
  /// 课程卡片
  /// 对应小程序: study/course.vue 的 .study-plan-item
  Widget _buildCourseCard(Map<String, dynamic> course) {
    return GestureDetector(
      onTap: () => _goCourseDetail(course),
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Stack(
          children: [
            // 主体内容
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 17.h, 16.w, 9.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 给标签留出空间
                  if (course['teaching_type_name'] != null)
                    SizedBox(height: 33.h),
                  // 课程名称
                  Text(
              course['goods_name'] ?? '',
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF262629),
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 7.5.h),
            // 上课日期
            Text(
              course['class_date'] ?? '',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF4783DC),
              ),
            ),
            // 套餐信息
            if (course['goods_pid'] != null && course['goods_pid'] != '0') ...[
              SizedBox(height: 10.h),
              Text(
                '套餐：${course['goods_pid_name'] ?? ''}',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFF4783DC),
                ),
              ),
            ],
            SizedBox(height: 16.h),
            // 老师列表
            if (course['teachers'] != null && (course['teachers'] as List).isNotEmpty)
              Wrap(
                spacing: 16.w,
                runSpacing: 11.h,
                children: (course['teachers'] as List).map((teacher) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 老师头像
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF04C140),
                            width: 1,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              teacher['avatar'] ?? 'https://yakaixin.oss-cn-beijing.aliyuncs.com/public/teacher_avatar.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      // 老师信息
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            teacher['name'] ?? '',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF262629),
                            ),
                          ),
                          if (teacher['title'] != null) ...[
                            SizedBox(height: 3.h),
                            Text(
                              teacher['title'],
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFF262629).withOpacity(0.6),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  );
                }).toList(),
              ),
            SizedBox(height: 7.h),
            // 底部操作按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ...(course['evaluation_type'] as List).map((btn) {
                  return GestureDetector(
                    onTap: () => _goAnswer(course, btn),
                    child: Container(
                      margin: EdgeInsets.only(left: 8.w),
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(22.r),
                      ),
                      child: Text(
                        btn['name'] ?? '',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
      // 左上角授课形式标签 - 绝对定位到卡片左上角
      if (course['teaching_type_name'] != null)
        Positioned(
          left: 0,
          top: 0,
          child: Container(
            width: 80.w,
            height: 25.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF04C140),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
            ),
            child: Text(
              course['teaching_type_name'],
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                letterSpacing: 5.w,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
    );
  }
  
  /// 授课形式选择器
  Widget _buildTeachingTypeSelector() {
    final options = [
      {'name': '全部', 'id': ''},
      {'name': '录播', 'id': '3'},
      {'name': '直播', 'id': '1'},
      {'name': '面授', 'id': '2'},
    ];
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _showTeachingTypeSelector = false;
        });
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {}, // 阻止点击穿透
              child: Container(
                margin: EdgeInsets.only(top: 58.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
                ),
                child: Column(
                  children: [
                    // 标题区域
                    Container(
                      padding: EdgeInsets.all(15.w),
                      color: const Color(0xFFF2F5F7),
                      child: Row(
                        children: [
                          Image.network(
                            'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/title-icon.png',
                            width: 15.w,
                            height: 15.w,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            '学习计划',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF262629),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 选项列表
                    Container(
                      padding: EdgeInsets.fromLTRB(15.w, 14.h, 15.w, 8.h),
                      child: Wrap(
                        spacing: 12.w,
                        runSpacing: 20.h,
                        children: options.map((option) {
                          final isSelected = _teachingType == option['id'];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _teachingType = option['id'] as String;
                                _showTeachingTypeSelector = false;
                              });
                            },
                            child: Container(
                              width: 49.w,
                              height: 19.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF018CFF).withOpacity(0.14)
                                    : const Color(0xFFECEEF0),
                                borderRadius: BorderRadius.circular(22.r),
                              ),
                              child: Text(
                                option['name'] as String,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  color: isSelected
                                      ? const Color(0xFF018CFF)
                                      : const Color(0xFF03203D).withOpacity(0.85),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 完整日历选择器
  /// 对应小程序: uni-calendar 组件
  Widget _buildFullCalendar() {
    return Container(
      height: 380.h,
      color: Colors.white,
      child: TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 365)),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: _selectedDate,
        selectedDayPredicate: (day) => _isSameDay(day, _selectedDate),
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        locale: 'zh_CN',
        // 样式配置
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF333333),
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: const Color(0xFF333333),
            size: 24.sp,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: const Color(0xFF333333),
            size: 24.sp,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF666666),
          ),
          weekendStyle: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF666666),
          ),
        ),
        calendarStyle: CalendarStyle(
          // 今天
          todayDecoration: BoxDecoration(
            color: const Color(0xFF018CFF).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF018CFF),
            fontWeight: FontWeight.w500,
          ),
          // 选中的日期
          selectedDecoration: const BoxDecoration(
            color: Color(0xFF018CFF),
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(
            fontSize: 14.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          // 普通日期
          defaultTextStyle: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF333333),
          ),
          // 周末
          weekendTextStyle: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF333333),
          ),
          // 其他月份的日期
          outsideTextStyle: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF999999),
          ),
        ),
        // 自定义日期构建器 - 为有课的日期添加背景
        calendarBuilders: CalendarBuilders(
          // 默认日期构建器
          defaultBuilder: (context, date, focusedDay) {
            final dateStr = _formatDate(date);
            final hasDot = _dotDates.contains(dateStr);
            
            if (hasDot && !_isSameDay(date, _selectedDate)) {
              // 有课的日期显示背景色
              return Container(
                margin: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF018CFF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      child: Container(
                        width: 5.w,
                        height: 5.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFF018CFF),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return null;
          },
          // 选中日期的Marker
          markerBuilder: (context, date, events) {
            final dateStr = _formatDate(date);
            if (_dotDates.contains(dateStr) && _isSameDay(date, _selectedDate)) {
              return Positioned(
                bottom: 2,
                child: Container(
                  width: 5.w,
                  height: 5.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }
            return null;
          },
        ),
        // 点击日期
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDate = selectedDay;
            _showCalendar = false; // 关闭日历
          });
          // TODO: 刷新数据
        },
      ),
    );
  }
  
  /// 日历遮罩
  Widget _buildCalendarMask() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showCalendar = false;
        });
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
      ),
    );
  }
  
  // ========== 事件处理 ==========
  
  /// 查看课程（直播/录播）
  void _goLookCourse(Map<String, dynamic> lesson) {
    final teachingType = lesson['teaching_type'];
    final lessonId = lesson['lesson_id'];
    
    if (teachingType == '3') {
      // 录播课程 - 跳转视频播放页
      context.push(AppRoutes.videoIndex, extra: {
        'lesson_id': lessonId,
        'order_id': lesson['order_id'],
        'goods_id': lesson['goods_id'],
        'goods_pid': lesson['goods_pid'],
        'lesson_name': lesson['lesson_name'],
      });
    } else if (teachingType == '1') {
      // 直播课程 - 跳转直播页
      context.push(AppRoutes.liveIndex, extra: {
        'lesson_id': lessonId,
      });
    }
  }
  
  /// 跳转答题页
  void _goAnswer(Map<String, dynamic> item, Map<String, dynamic>? btn) {
    if (btn == null || btn['paper_version_id'] == null || btn['paper_version_id'] == '0') {
      return;
    }
    
    context.push(AppRoutes.makeQuestion, extra: {
      'paper_version_id': btn['paper_version_id'],
      'evaluation_type_id': btn['id'],
      'professional_id': btn['professional_id'],
      'goods_id': item['paper_goods_id'] ?? item['goods_id'],
      'order_id': item['order_id'],
      'system_id': item['system_id'],
      'order_detail_id': item['order_goods_detail_id'],
      'lesson_id': item['lesson_id'],
    });
  }
  
  /// 跳转课程详情
  void _goCourseDetail(Map<String, dynamic> course) {
    context.push(AppRoutes.courseDetail, extra: {
      'goods_id': course['goods_id'],
      'goods_pid': course['goods_pid'],
      'order_id': course['order_id'],
    });
  }

  // ========== 工具方法 ==========
  
  /// 获取本周日期列表
  List<DateTime> _getWeekDays(DateTime date) {
    final weekDay = date.weekday;
    final firstDayOfWeek = date.subtract(Duration(days: weekDay % 7));
    return List.generate(7, (index) => firstDayOfWeek.add(Duration(days: index)));
  }
  
  /// 判断是否同一天
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
  
  /// 格式化日期为字符串
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  
  /// 获取星期名称
  String _getWeekDayName(DateTime date) {
    const weekDays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    return weekDays[date.weekday % 7];
  }
  
  /// 获取授课形式名称
  String _getTeachingTypeName(String? type) {
    switch (type) {
      case '1':
        return '直播';
      case '2':
        return '面授';
      case '3':
        return '录播';
      default:
        return '未知';
    }
  }
  
  /// 获取授课形式颜色
  Color _getTeachingTypeColor(String? type) {
    switch (type) {
      case '1':
        return const Color(0xFFFF5E00); // 直播 - 橙色
      case '2':
        return const Color(0xFF4CAF50); // 面授 - 绿色
      case '3':
        return const Color(0xFF2196F3); // 录播 - 蓝色
      default:
        return const Color(0xFF999999);
    }
  }
  
  /// 获取授课形式显示名称（用于筛选器）
  String _getTeachingTypeDisplayName(String type) {
    switch (type) {
      case '1':
        return '直播';
      case '2':
        return '面授';
      case '3':
        return '录播';
      default:
        return '授课形式';
    }
  }
  
  /// Mock今日课程数据
  List<Map<String, dynamic>> _getMockTodayLessons() {
    return [
      {
        'lesson_id': '1001',
        'start_time': '09:00',
        'teaching_type': '3', // 录播
        'lesson_num': '第1节',
        'lesson_name': '口腔解剖学基础',
        'has_homework': true,
        'order_id': '456',
        'goods_id': '123',
        'goods_pid': '0',
        'homework_btn': {
          'id': '10',
          'name': '课前作业',
          'paper_version_id': '200',
          'professional_id': '1',
        },
      },
      {
        'lesson_id': '1002',
        'start_time': '14:00',
        'teaching_type': '1', // 直播
        'lesson_num': '第2节',
        'lesson_name': '牙体组织结构',
        'has_homework': false,
        'order_id': '457',
        'goods_id': '124',
        'goods_pid': '0',
      },
    ];
  }
  
  /// Mock课程列表数据
  List<Map<String, dynamic>> _getMockCourseList() {
    return [
      {
        'goods_id': '123',
        'goods_pid': '0',
        'order_id': '456',
        'paper_goods_id': '123',
        'system_id': '1',
        'order_goods_detail_id': '789',
        'teaching_type_name': '直播',
        'goods_name': '口腔执业医师精品课程',
        'class_date': '2025-11-25 周一',
        'teachers': [
          {
            'name': '张教授',
            'title': '主任医师',
            'avatar': 'https://picsum.photos/80/80?random=1',
          },
          {
            'name': '李老师',
            'title': '副教授',
            'avatar': 'https://picsum.photos/80/80?random=2',
          },
        ],
        'evaluation_type': [
          {
            'id': '1',
            'name': '开课测',
            'paper_version_id': '101',
            'professional_id': '1',
          },
          {
            'id': '2',
            'name': '评价',
            'paper_version_id': '102',
            'professional_id': '1',
          },
        ],
      },
      {
        'goods_id': '124',
        'goods_pid': '999',
        'goods_pid_name': '口腔医师全程班',
        'order_id': '457',
        'paper_goods_id': '124',
        'system_id': '1',
        'order_goods_detail_id': '790',
        'teaching_type_name': '录播',
        'goods_name': '口腔解剖学系统课程',
        'class_date': '2025-11-26 周二',
        'teachers': [
          {
            'name': '王教授',
            'title': '教授',
            'avatar': 'https://picsum.photos/80/80?random=3',
          },
        ],
        'evaluation_type': [
          {
            'id': '3',
            'name': '课后测',
            'paper_version_id': '103',
            'professional_id': '1',
          },
        ],
      },
    ];
  }
}
