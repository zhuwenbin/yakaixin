import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yakaixin_app/core/theme/app_colors.dart';
import 'package:yakaixin_app/core/theme/app_text_styles.dart';

/// 时间范围选择器
/// 对应小程序: components/collect/select-time-range.vue
class TimeRangeSelector extends StatefulWidget {
  final String selectedRange;
  final String selectedName;
  final String? startDate;
  final String? endDate;
  final VoidCallback onClose;
  final Function(String range, String name, String? startDate, String? endDate) onConfirm;

  const TimeRangeSelector({
    super.key,
    required this.selectedRange,
    required this.selectedName,
    this.startDate,
    this.endDate,
    required this.onClose,
    required this.onConfirm,
  });

  @override
  State<TimeRangeSelector> createState() => _TimeRangeSelectorState();
}

class _TimeRangeSelectorState extends State<TimeRangeSelector> {
  String _selectedRange = '';
  String _selectedName = '';
  String? _startDate;
  String? _endDate;

  final List<Map<String, String>> _timeRanges = [
    {'id': '0', 'label': '全部'},
    {'id': '1', 'label': '近3天'},
    {'id': '2', 'label': '一周内'},
    {'id': '3', 'label': '一月内'},
    {'id': '4', 'label': '自定义'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedRange = widget.selectedRange;
    _selectedName = widget.selectedName;
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClose,
      child: Material(
        color: Colors.black54,
        child: GestureDetector(
          onTap: () {}, // 阻止事件冒泡
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: double.infinity,
                constraints: BoxConstraints(maxHeight: 500.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12.r),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 标题
                    _buildHeader(),
                    
                    // 时间范围选项
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTimeRangeOptions(),
                            
                            // 自定义时间选择
                            if (_selectedRange == '4')
                              _buildCustomDatePicker(),
                          ],
                        ),
                      ),
                    ),
                    
                    // 确定按钮
                    _buildConfirmButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 标题栏
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFEEEEEE),
            width: 1,
          ),
        ),
      ),
      child: Text(
        '选择时间',
        style: AppTextStyles.bodyLarge.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// 时间范围选项
  /// 对应小程序: Line 5-15
  Widget _buildTimeRangeOptions() {
    return Wrap(
      spacing: 5.5.w,
      runSpacing: 16.h,
      children: _timeRanges.map((range) {
        final id = range['id'] ?? '';
        final label = range['label'] ?? '';
        final isSelected = _selectedRange == id;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedRange = id;
              _selectedName = label;
              if (id != '4') {
                _startDate = null;
                _endDate = null;
              }
            });
          },
          child: Container(
            width: 107.w,
            height: 34.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected 
                  ? const Color(0xFFEBF1FF) 
                  : const Color(0xFFF6F7F8),
              border: isSelected 
                  ? Border.all(color: AppColors.primary, width: 1.r)
                  : null,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 12.sp,
                color: isSelected 
                    ? AppColors.primary 
                    : const Color(0xFF161F30),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 自定义日期选择器
  /// 对应小程序: Line 16-40
  Widget _buildCustomDatePicker() {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      child: Row(
        children: [
          // 开始日期
          Expanded(
            child: GestureDetector(
              onTap: () => _selectDate(isStart: true),
              child: Container(
                height: 44.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F7F8),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  _startDate ?? '请选择开始时间',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 14.sp,
                    color: _startDate != null 
                        ? AppColors.textPrimary 
                        : AppColors.textHint,
                  ),
                ),
              ),
            ),
          ),
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              '：',
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 14.sp,
              ),
            ),
          ),
          
          // 结束日期
          Expanded(
            child: GestureDetector(
              onTap: () => _selectDate(isStart: false),
              child: Container(
                height: 44.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F7F8),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  _endDate ?? '请选择结束时间',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 14.sp,
                    color: _endDate != null 
                        ? AppColors.textPrimary 
                        : AppColors.textHint,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 选择日期
  Future<void> _selectDate({required bool isStart}) async {
    final now = DateTime.now();
    final initialDate = isStart 
        ? (_startDate != null ? DateTime.tryParse(_startDate!) : now)
        : (_endDate != null ? DateTime.tryParse(_endDate!) : now);
    
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: DateTime(now.year - 60),
      lastDate: DateTime(now.year + 2),
      locale: const Locale('zh', 'CN'),
    );
    
    if (selectedDate != null) {
      setState(() {
        final formattedDate = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
        if (isStart) {
          _startDate = formattedDate;
        } else {
          _endDate = formattedDate;
        }
      });
    }
  }

  /// 确定按钮
  /// 对应小程序: Line 42-44
  Widget _buildConfirmButton() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 19.h,
      ),
      child: GestureDetector(
        onTap: () {
          // 验证自定义时间
          if (_selectedRange == '4') {
            if (_startDate == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('请选择开始时间！')),
              );
              return;
            }
            if (_endDate == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('请选择结束时间！')),
              );
              return;
            }
          }
          
          widget.onConfirm(
            _selectedRange,
            _selectedName,
            _startDate,
            _endDate,
          );
        },
        child: Container(
          width: double.infinity,
          height: 44.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(22.r),
          ),
          child: Text(
            '确定',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 14.sp,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
