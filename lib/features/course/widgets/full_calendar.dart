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

  const FullCalendar({
    super.key,
    required this.selectedDate,
    required this.dotDates,
    required this.onDaySelected,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: TableCalendar(
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
    );
  }

  CalendarStyle _buildCalendarStyle() {
    return CalendarStyle(
      todayDecoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      selectedDecoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      todayTextStyle: TextStyle(
        color: AppColors.primary,
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
              decoration: const BoxDecoration(
                color: Color(0xFFFF6B6B),
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
