import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'time_range_selector.dart';

/// 时间范围选择器 Dialog
/// 对应小程序: components/collect/select-time-range.vue + picker-shell.vue
/// 
/// 动画效果：底部弹出对话框动画
/// - 内容从屏幕底部向上滑出（SlideTransition）
/// - 遮罩同时淡入显示（FadeTransition）
/// - 动画参数：时长 250ms，曲线 easeInOut
/// 
/// 标准描述："使用底部弹出对话框动画，内容从底部向上滑出，遮罩淡入，动画时长 250ms，曲线 easeInOut"
/// 参考文档：docs/ANIMATION_STANDARD.md
class TimeRangeSelectorDialog extends StatefulWidget {
  final String selectedRange;
  final String selectedName;
  final String? startDate;
  final String? endDate;

  const TimeRangeSelectorDialog({
    super.key,
    required this.selectedRange,
    required this.selectedName,
    this.startDate,
    this.endDate,
  });

  @override
  State<TimeRangeSelectorDialog> createState() => _TimeRangeSelectorDialogState();
}

class _TimeRangeSelectorDialogState extends State<TimeRangeSelectorDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    // ✅ 动画控制器（与专业选择一致）
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
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
    return GestureDetector(
      onTap: _close,
      child: Stack(
        children: [
          // ✅ 遮罩（全屏，从底部开始）
          Positioned.fill(
            child: FadeTransition(
              opacity: _animation, // ✅ 使用与专业选择相同的动画参数
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          ),
          // ✅ 内容区域从底部向上滑动（使用 SlideTransition）
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0), // ✅ 从底部开始（y=1.0 表示完全在屏幕外）
                end: Offset.zero, // ✅ 滑动到正常位置
              ).animate(_animation), // ✅ 使用与专业选择相同的动画参数
              child: GestureDetector(
                onTap: () {}, // 阻止点击事件冒泡
                child: Container(
                  constraints: BoxConstraints(maxHeight: 500.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12.r), // ✅ 对应小程序 border-radius: 24rpx 24rpx 0px 0px
                    ),
                  ),
                  child: TimeRangeSelector(
                    selectedRange: widget.selectedRange,
                    selectedName: widget.selectedName,
                    startDate: widget.startDate,
                    endDate: widget.endDate,
                    onClose: _close,
                    onConfirm: (range, name, startDate, endDate) {
                      _close();
                      // ✅ 通过 Navigator 返回结果
                      Navigator.of(context).pop({
                        'range': range,
                        'name': name,
                        'startDate': startDate,
                        'endDate': endDate,
                      });
                    },
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

/// 显示时间范围选择器 Dialog
/// 从底部弹出，使用与专业选择相同的动画参数
Future<Map<String, dynamic>?> showTimeRangeSelectorDialog(
  BuildContext context, {
  required String selectedRange,
  required String selectedName,
  String? startDate,
  String? endDate,
}) {
  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierColor: Colors.transparent, // ✅ 使用透明背景，自己控制遮罩
    builder: (context) => TimeRangeSelectorDialog(
      selectedRange: selectedRange,
      selectedName: selectedName,
      startDate: startDate,
      endDate: endDate,
    ),
  );
}

