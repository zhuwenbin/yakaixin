import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yakaixin_app/core/theme/app_colors.dart';
import 'package:yakaixin_app/core/theme/app_text_styles.dart';
import '../providers/collection_provider.dart';

/// 题型选择器
/// 对应小程序: components/collect/select-question-type.vue
class QuestionTypeSelector extends ConsumerStatefulWidget {
  final String selectedType;
  final String selectedName;
  final VoidCallback onClose;
  final Function(String type, String name) onConfirm;

  const QuestionTypeSelector({
    super.key,
    required this.selectedType,
    required this.selectedName,
    required this.onClose,
    required this.onConfirm,
  });

  @override
  ConsumerState<QuestionTypeSelector> createState() => _QuestionTypeSelectorState();
}

class _QuestionTypeSelectorState extends ConsumerState<QuestionTypeSelector> {
  String _selectedType = '';
  String _selectedName = '';
  List<Map<String, String>> _questionTypes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.selectedType;
    _selectedName = widget.selectedName;
    _loadQuestionTypes();
  }

  Future<void> _loadQuestionTypes() async {
    try {
      final service = ref.read(collectionServiceProvider);
      final types = await service.getQuestionTypes();
      setState(() {
        _questionTypes = types;
        _isLoading = false;
      });
    } catch (e) {
      print('加载题型失败: $e');
      setState(() {
        _isLoading = false;
        // 使用默认题型列表
        _questionTypes = [
          {'id': '1', 'label': 'A1'},
          {'id': '2', 'label': 'A2'},
          {'id': '3', 'label': 'A3'},
          {'id': '4', 'label': 'A4'},
          {'id': '5', 'label': 'B1'},
          {'id': '6', 'label': 'B2'},
          {'id': '7', 'label': 'X'},
        ];
      });
    }
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
                    
                    // 题型列表
                    Flexible(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _buildQuestionTypeGrid(),
                    ),
                    
                    // 底部按钮
                    _buildFooterButtons(),
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
        '选择题型',
        style: AppTextStyles.bodyLarge.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// 题型网格
  /// 对应小程序: Line 4-14
  Widget _buildQuestionTypeGrid() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(12.w),
      child: Wrap(
        spacing: 11.w,
        runSpacing: 16.h,
        children: _questionTypes.map((type) {
          final id = type['id'] ?? '';
          final label = type['label'] ?? '';
          final isSelected = _selectedType == id;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedType = id;
                _selectedName = label;
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
      ),
    );
  }

  /// 底部按钮
  /// 对应小程序: Line 16-18
  Widget _buildFooterButtons() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 19.h,
      ),
      child: Row(
        children: [
          // 重置按钮
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedType = '';
                  _selectedName = '';
                });
              },
              child: Container(
                height: 44.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFECEEF0),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(22.r),
                  ),
                ),
                child: Text(
                  '重置',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 14.sp,
                    color: const Color(0xFF03203D),
                  ),
                ),
              ),
            ),
          ),
          
          // 确定按钮
          Expanded(
            child: GestureDetector(
              onTap: () {
                widget.onConfirm(_selectedType, _selectedName);
              },
              child: Container(
                height: 44.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(22.r),
                  ),
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
          ),
        ],
      ),
    );
  }
}
