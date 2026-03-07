import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'full_calendar.dart';

/// 日历下拉弹窗（和专业选择下拉动画效果一致）
/// 对应小程序: selectDate.vue
class CalendarDialog extends StatefulWidget {
  final DateTime selectedDate;
  final List<String> dotDates;
  final Function(DateTime) onDaySelected;
  final Function(DateTime) onPageChanged;
  final double? topOffset; // 弹窗顶部偏移量（可选）
  final Color datePrimaryColor;

  const CalendarDialog({
    super.key,
    required this.selectedDate,
    required this.dotDates,
    required this.onDaySelected,
    required this.onPageChanged,
    this.topOffset,
    this.datePrimaryColor = const Color(0xFF018CFF),
  });

  @override
  State<CalendarDialog> createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // ✅ 动画控制器（和专业选择下拉一致）
    _animationController = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // 开始动画
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 关闭弹窗
  void _close() async {
    await _animationController.reverse();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 计算弹窗顶部位置（和专业选择下拉一致）
    // 如果提供了 topOffset，使用提供的值；否则使用默认值（课程页面的情况）
    final dialogTop =
        widget.topOffset ??
        () {
          // ✅ 参照专业选择下拉的计算方式：
          // 专业选择：从 HomeHeader 容器底部开始 = statusBarHeight + 48.h + 1
          // 课程页面：从 WeekCalendar 容器底部开始
          //
          // 布局结构：
          // 1. AppBar: statusBarHeight + 44.h (包含 bottom padding 12.h)
          // 2. WeekCalendar 容器: 紧贴 AppBar 底部
          //    - padding top: 10.h
          //    - 内容高度: 42.h (Row 内容，包括"更多日期"按钮)
          //    - padding bottom: 10.h
          //    - 容器总高度: 62.h
          //
          // 计算过程（参照专业选择下拉）：
          // - AppBar 底部 = statusBarHeight + 44.h
          // - WeekCalendar 容器总高度 = 62.h
          // - WeekCalendar 容器底部 = statusBarHeight + 44.h + 62.h = statusBarHeight + 106.h
          // - 弹窗应该从容器底部 + 1像素开始（和专业选择下拉一致：从容器底部开始）
          final statusBarHeight = MediaQuery.of(context).padding.top;
          final appBarHeight = statusBarHeight + 44.h; // AppBar高度
          final weekCalendarTotalHeight =
              10.h + 42.h; // 周历容器总高度（padding top + 内容 + padding bottom）
          return appBarHeight + weekCalendarTotalHeight;
        }();

    return GestureDetector(
      onTap: _close,
      child: Stack(
        children: [
          // ✅ 遮罩从指定位置开始（和专业选择下拉一致）
          Positioned(
            top: dialogTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: FadeTransition(
              opacity: _animation,
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),
          ),
          // ✅ 内容区域从指定位置开始下拉（使用高度展开动画，和专业选择下拉一致）
          Positioned(
            top: dialogTop,
            left: 0,
            right: 0,
            child: SizeTransition(
              sizeFactor: _animation, // ✅ 高度展开动画（从0到1）
              axis: Axis.vertical,
              axisAlignment: -1.0, // 从顶部开始展开
              child: GestureDetector(
                onTap: () {}, // 阻止点击事件冒泡
                child: Container(
                  height: 500.h, // 日历高度
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: FullCalendar(
                      selectedDate: widget.selectedDate,
                      dotDates: widget.dotDates,
                      datePrimaryColor: widget.datePrimaryColor,
                      onDaySelected: (selectedDay) {
                        widget.onDaySelected(selectedDay);
                        _close();
                      },
                      onPageChanged: widget.onPageChanged,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 显示日历下拉弹窗
/// [topOffset] 弹窗顶部偏移量（可选）
/// 如果不提供，则使用默认值（从周历底部开始）
Future<void> showCalendarDialog(
  BuildContext context, {
  required DateTime selectedDate,
  required List<String> dotDates,
  required Function(DateTime) onDaySelected,
  required Function(DateTime) onPageChanged,
  Color datePrimaryColor = const Color(0xFF018CFF),
  double? topOffset,
}) {
  return showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) => CalendarDialog(
      selectedDate: selectedDate,
      dotDates: dotDates,
      onDaySelected: onDaySelected,
      onPageChanged: onPageChanged,
      datePrimaryColor: datePrimaryColor,
      topOffset: topOffset,
    ),
  );
}
