import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../collection/widgets/time_range_selector_dialog.dart';

/// 收藏页面
/// 对应小程序: src/modules/jintiku/pages/collect/index.vue
class CollectPage extends ConsumerStatefulWidget {
  const CollectPage({super.key});

  @override
  ConsumerState<CollectPage> createState() => _CollectPageState();
}

class _CollectPageState extends ConsumerState<CollectPage> {
  String _selectedQuestionType = '';
  String _selectedTimeRange = '全部';
  String _selectedTimeRangeId = '0';
  String? _startDate;
  String? _endDate;

  // 从 Mock数据文件获取数据
  List<Map<String, dynamic>> get _collectQuestions => [];
  // ⚠️ 以下 Mock 数据引用已废弃，需要改为通过 API 调用获取
  // TODO: 使用 Dio 调用 API，MockInterceptor 会自动返回 Mock 数据
  // TODO: 从收藏题目 API 中解析数据

  @override
  Widget build(BuildContext context) {
    final filteredQuestions = _getFilteredQuestions();
    final groupedQuestions = _groupQuestionsByType(filteredQuestions);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('收藏'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 筛选栏
          _buildFilterBar(),
          // 收藏列表
          Expanded(
            child: filteredQuestions.isEmpty
                ? _buildEmptyState()
                : ListView(
                    padding: EdgeInsets.all(12.w),
                    children: groupedQuestions.entries.map((entry) {
                      return _buildQuestionTypeGroup(
                        entry.key,
                        entry.value,
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  /// 构建筛选栏
  Widget _buildFilterBar() {
    return Container(
      padding: AppSpacing.horizontalMd.add(EdgeInsets.symmetric(vertical: 12.h)),
      color: AppColors.surface,
      child: Row(
        children: [
          // 题型筛选
          Expanded(
            child: _buildFilterButton(
              label: _selectedQuestionType.isEmpty ? '题型' : _selectedQuestionType,
              onTap: () => _showQuestionTypeDialog(),
            ),
          ),
          SizedBox(width: 12.w),
          // 时间筛选
          Expanded(
            child: _buildFilterButton(
              label: _selectedTimeRange,
              onTap: () => _showTimeRangeDialog(),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建筛选按钮
  Widget _buildFilterButton({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: AppRadius.radiusSm,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppTextStyles.bodyMedium,
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16.sp,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建题型分组
  Widget _buildQuestionTypeGroup(String typeName, List<Map<String, dynamic>> questions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 题型标题
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Text(
            '$typeName题型',
            style: AppTextStyles.heading4,
          ),
        ),
        // 题目列表
        ...questions.map((question) => _buildQuestionItem(question)),
      ],
    );
  }

  /// 构建单个收藏题目
  Widget _buildQuestionItem(Map<String, dynamic> question) {
    return GestureDetector(
      onTap: () {
        // 跳转到题目详情
        context.push(AppRoutes.makeQuestion, extra: {
          'question_id': question['id'],
          'from': 'collect',
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.radiusSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 题目内容
            Text(
              question['question'] as String,
              style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12.h),
            // 底部信息
            Row(
              children: [
                // 时间
                Text(
                  (question['created_at'] as String).substring(0, 16),
                  style: AppTextStyles.labelMedium,
                ),
                Spacer(),
                // 难易度
                Row(
                  children: List.generate(5, (index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 4.w),
                      child: Icon(
                        Icons.star,
                        size: 14.sp,
                        color: index < (question['level'] as int)
                            ? AppColors.warning
                            : AppColors.border,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80.sp,
            color: AppColors.border,
          ),
          SizedBox(height: AppSpacing.mdV),
          Text(
            '没有任何收藏呢~',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  /// 显示题型筛选弹窗（与我的收藏、错题本统一样式：遮罩+底部卡片+标签选项）
  void _showQuestionTypeDialog() {
    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => _QuestionTypeOverlay(
        selectedType: _selectedQuestionType.isEmpty ? '全部' : _selectedQuestionType,
        onConfirm: (type) {
          setState(() {
            _selectedQuestionType = type == '全部' ? '' : type;
          });
          Navigator.of(context).pop();
        },
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  /// 显示时间范围筛选弹窗（使用统一样式 showTimeRangeSelectorDialog）
  void _showTimeRangeDialog() async {
    final result = await showTimeRangeSelectorDialog(
      context,
      selectedRange: _selectedTimeRangeId,
      selectedName: _selectedTimeRange,
      startDate: _startDate,
      endDate: _endDate,
    );
    if (result != null) {
      setState(() {
        _selectedTimeRangeId = result['range'] as String;
        _selectedTimeRange = result['name'] as String;
        _startDate = result['startDate'] as String?;
        _endDate = result['endDate'] as String?;
      });
    }
  }

  /// 获取过滤后的题目列表
  List<Map<String, dynamic>> _getFilteredQuestions() {
    var questions = _collectQuestions;

    // 按题型筛选
    if (_selectedQuestionType.isNotEmpty) {
      questions = questions.where((q) => q['type_name'] == _selectedQuestionType).toList();
    }

    // TODO: 按时间范围筛选

    return questions;
  }

  /// 按题型分组
  Map<String, List<Map<String, dynamic>>> _groupQuestionsByType(
    List<Map<String, dynamic>> questions,
  ) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    
    for (var question in questions) {
      final typeName = question['type_name'] as String;
      if (!grouped.containsKey(typeName)) {
        grouped[typeName] = [];
      }
      grouped[typeName]!.add(question);
    }

    return grouped;
  }
}

/// 题型选择浮层（与我的收藏 QuestionTypeSelector 统一样式）
class _QuestionTypeOverlay extends StatefulWidget {
  final String selectedType;
  final void Function(String type) onConfirm;
  final VoidCallback onClose;

  const _QuestionTypeOverlay({
    required this.selectedType,
    required this.onConfirm,
    required this.onClose,
  });

  @override
  State<_QuestionTypeOverlay> createState() => _QuestionTypeOverlayState();
}

class _QuestionTypeOverlayState extends State<_QuestionTypeOverlay> {
  late String _selectedType;
  static const _questionTypes = ['全部', '单选', '多选', '判断'];

  @override
  void initState() {
    super.initState();
    _selectedType = widget.selectedType;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClose,
      child: Material(
        color: Colors.black54,
        child: GestureDetector(
          onTap: () {},
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
                    _buildHeader(),
                    Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Wrap(
                        spacing: 11.w,
                        runSpacing: 16.h,
                        children: _questionTypes.map((type) {
                          final isSelected = _selectedType == type;
                          return GestureDetector(
                            onTap: () {
                              setState(() => _selectedType = type);
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
                                    ? Border.all(
                                        color: AppColors.primary,
                                        width: 1.r,
                                      )
                                    : null,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Text(
                                type,
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
                    ),
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

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(0xFFEEEEEE), width: 1),
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

  Widget _buildFooterButtons() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 19.h),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedType = '全部');
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
          Expanded(
            child: GestureDetector(
              onTap: () => widget.onConfirm(_selectedType),
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
