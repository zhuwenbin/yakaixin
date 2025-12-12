import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_radius.dart';

/// 周历日历组件
/// 对应小程序: 上课页的周历选择器
class WeekCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final List<String> dotDates;
  final Function(DateTime) onDateSelected;
  final VoidCallback onShowFullCalendar;
  final LayerLink layerLink;

  const WeekCalendar({
    super.key,
    required this.selectedDate,
    required this.dotDates,
    required this.onDateSelected,
    required this.onShowFullCalendar,
    required this.layerLink,
  });

  @override
  Widget build(BuildContext context) {
    final weekDays = _getCurrentWeek(selectedDate);

    return CompositedTransformTarget(
      link: layerLink,
      child: Container(
        color: AppColors.surface,
        padding: EdgeInsets.fromLTRB(7.w, 10.h, 0, 10.h),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 42.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: weekDays
                      .map(
                        (day) => _WeekDayItem(
                          day: day,
                          selectedDate: selectedDate,
                          dotDates: dotDates,
                          onTap: () => onDateSelected(day),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            _MoreDatesButton(onTap: onShowFullCalendar),
          ],
        ),
      ),
    );
  }

  List<DateTime> _getCurrentWeek(DateTime date) {
    final weekDay = date.weekday % 7;
    final sunday = date.subtract(Duration(days: weekDay));
    return List.generate(7, (i) => sunday.add(Duration(days: i)));
  }
}

/// 周历单个日期项
class _WeekDayItem extends StatelessWidget {
  final DateTime day;
  final DateTime selectedDate;
  final List<String> dotDates;
  final VoidCallback onTap;

  const _WeekDayItem({
    required this.day,
    required this.selectedDate,
    required this.dotDates,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = isSameDay(day, selectedDate);
    final isToday = isSameDay(day, DateTime.now());
    final hasDot = dotDates.contains(formatDate(day));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45.w,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: AppRadius.radiusSm,
        ),
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isToday ? '今天' : getWeekDayName(day),
              style: AppTextStyles.labelSmall.copyWith(
                color: isSelected ? AppColors.textWhite : AppColors.textHint,
                height: 1.1,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              isSelected
                  ? '${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}'
                  : day.day.toString(),
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
                height: 1.1,
              ),
            ),
            if (hasDot) SizedBox(height: 3.h),
            if (hasDot)
              Container(
                width: 5.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.textWhite : AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String getWeekDayName(DateTime date) {
    const weekDays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    return weekDays[date.weekday % 7];
  }
}

/// "更多日期"按钮
class _MoreDatesButton extends StatelessWidget {
  final VoidCallback onTap;

  const _MoreDatesButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 51.w,
        height: 42.h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFAFCFF), Color(0xFFFFFFFF)],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x38E8EAEF),
              offset: Offset(-2, 0),
              blurRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '更多',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
              ),
              Text(
                '日期',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
