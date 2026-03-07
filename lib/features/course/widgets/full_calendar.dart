import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// 完整日历组件
/// 从周历下方展开的完整月历
class FullCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final List<String> dotDates;
  final Function(DateTime) onDaySelected;
  final Function(DateTime)? onPageChanged;
  final Color datePrimaryColor;

  const FullCalendar({
    super.key,
    required this.selectedDate,
    required this.dotDates,
    required this.onDaySelected,
    this.onPageChanged,
    this.datePrimaryColor = AppColors.courseDatePrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Stack(
        children: [
          TableCalendar(
        locale: 'zh_CN',
        firstDay: DateTime(2020, 1, 1),
        lastDay: DateTime(2030, 12, 31),
        focusedDay: selectedDate,
        selectedDayPredicate: (day) => isSameDay(day, selectedDate),
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        headerStyle: _buildHeaderStyle(),
        calendarStyle: _buildCalendarStyle(),
        daysOfWeekStyle: _buildDaysOfWeekStyle(),
        calendarBuilders: _buildCalendarBuilders(),
        onDaySelected: (selectedDay, focusedDay) {
          onDaySelected(selectedDay);
        },
        onPageChanged:
            onPageChanged != null ? (focusedDay) => onPageChanged!(focusedDay) : null,
          ),
          // ✅ "今日"按钮（覆盖在日历头部右上角）
          // 对应小程序: uni-calendar.vue .uni-calendar__backtoday
          // 位置：absolute, right: 12px, top: 25rpx (相对于 header 容器)
          Positioned(
            right: 6.w, // ✅ 对应小程序 right: 12px (6.w)
            top: 12.5.h, // ✅ 对应小程序 top: 25rpx (12.5.h) - 相对于日历头部
            child: _buildTodayButton(),
          ),
        ],
      ),
    );
  }

  /// 构建"今日"按钮
  /// 对应小程序: uni-calendar.vue .uni-calendar__backtoday 和 backToday() 方法
  Widget _buildTodayButton() {
    final today = DateTime.now();
    final isTodayMonth = selectedDate.year == today.year && selectedDate.month == today.month;
    
    return GestureDetector(
      onTap: () {
        // ✅ 回到今天（对应小程序 backToday() 方法）
        onDaySelected(today);
        // 如果今天不在当前显示的月份，切换到今天的月份
        if (!isTodayMonth && onPageChanged != null) {
          onPageChanged!(today);
        }
      },
      child: Container(
        height: 22.h, // ✅ 对应小程序 height: 22px
        width: 52.w, // ✅ 对应小程序 width: 52px
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: datePrimaryColor, // 对应小程序 #018CFF
          borderRadius: BorderRadius.circular(25.r), // 对应小程序 border-radius: 25px
        ),
        child: Text(
          '今日',
          style: TextStyle(
            fontSize: 12.sp, // ✅ 对应小程序 font-size: 12px
            fontWeight: FontWeight.normal, // ✅ 对应小程序 font-weight: 400
            color: Colors.white, // ✅ 对应小程序 color: #FFFFFF
          ),
        ),
      ),
    );
  }

  HeaderStyle _buildHeaderStyle() {
    return HeaderStyle(
      formatButtonVisible: false,
      titleCentered: true,
      titleTextFormatter: (date, locale) {
        return '${date.year}年${date.month}月';
      },
      titleTextStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      leftChevronIcon: Icon(
        Icons.chevron_left,
        color: AppColors.textPrimary,
        size: 24.sp,
      ),
      rightChevronIcon: Icon(
        Icons.chevron_right,
        color: AppColors.textPrimary,
        size: 24.sp,
      ),
      // ✅ 设置 header 的 padding，为"今日"按钮留出空间
      leftChevronMargin: EdgeInsets.only(left: 8.w),
      rightChevronMargin: EdgeInsets.only(right: 60.w), // ✅ 为"今日"按钮留出空间（52px + 8px margin）
      headerPadding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h), // ✅ 对应小程序 header padding
    );
  }

  CalendarStyle _buildCalendarStyle() {
    return CalendarStyle(
      todayDecoration: BoxDecoration(
        color: datePrimaryColor.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      selectedDecoration: BoxDecoration(
        color: datePrimaryColor,
        shape: BoxShape.circle,
      ),
      todayTextStyle: TextStyle(
        color: datePrimaryColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      selectedTextStyle: TextStyle(
        color: AppColors.textWhite,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      defaultTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 14.sp,
      ),
      weekendTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 14.sp,
      ),
      outsideTextStyle: TextStyle(
        color: AppColors.textDisabled,
        fontSize: 14.sp,
      ),
    );
  }

  DaysOfWeekStyle _buildDaysOfWeekStyle() {
    return DaysOfWeekStyle(
      weekdayStyle: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary),
      weekendStyle: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary),
    );
  }

  CalendarBuilders _buildCalendarBuilders() {
    return CalendarBuilders(
      dowBuilder: (context, day) {
        final text = DateFormat.E('zh_CN').format(day);
        return Center(
          child: Text(
            text,
            style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary),
          ),
        );
      },
      markerBuilder: (context, date, events) {
        final dateStr =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        if (dotDates.contains(dateStr)) {
          return Positioned(
            bottom: 4.h,
            child: Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                color: datePrimaryColor,
                shape: BoxShape.circle,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
