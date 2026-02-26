import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yakaixin_app/core/theme/app_colors.dart';
import 'package:yakaixin_app/core/theme/app_text_styles.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart'; // ✅ 添加 EasyLoading
import 'dart:convert';
import '../models/collection_question_model.dart';
import '../../question_bank/widgets/question/question_card_swiper.dart';
import '../../question_bank/widgets/make_question/error_correction_dialog.dart';
import '../providers/collection_provider.dart';

/// 收藏详情页面
/// 对应小程序: collect/detail.vue
///
/// 功能:
/// - 页面切换 (PageView 滑动)
/// - 题目进度显示 (1/10)
/// - 收藏/取消收藏
/// - 纠错
class CollectionDetailPage extends ConsumerStatefulWidget {
  final List<CollectionQuestionModel> questions; // 题目列表
  final int initialIndex; // 初始索引

  const CollectionDetailPage({
    super.key,
    required this.questions,
    this.initialIndex = 0,
  });

  @override
  ConsumerState<CollectionDetailPage> createState() =>
      _CollectionDetailPageState();
}

class _CollectionDetailPageState extends ConsumerState<CollectionDetailPage> {
  late int _currentIndex;
  late List<Map<String, dynamic>> _questionData;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _questionData = _convertToQuestionData(widget.questions);
  }

  /// 将 CollectionQuestionModel 转换为做题组件所需的格式
  /// 一拆多题：多子题拆成多条，一题一页滑动，带 original_index 供收藏/纠错用
  List<Map<String, dynamic>> _convertToQuestionData(
    List<CollectionQuestionModel> questions,
  ) {
    final List<Map<String, dynamic>> result = [];
    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      if (q.stemList.isEmpty) continue;
      for (int j = 0; j < q.stemList.length; j++) {
        final stem = q.stemList[j];
        result.add(_oneStemToMap(q, stem, originalIndex: i, stemIndex: j));
      }
    }
    return result;
  }

  Map<String, dynamic> _oneStemToMap(
    CollectionQuestionModel q,
    dynamic stem, {
    required int originalIndex,
    required int stemIndex,
  }) {
    List<Map<String, dynamic>> options = [];
    if (stem.option != null && stem.option.isNotEmpty) {
      try {
        final optionData = jsonDecode(stem.option);
        if (optionData is List) {
          options = optionData.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final label = String.fromCharCode(65 + index);
            final text = item is String
                ? item
                : (item['text'] ?? item.toString());
            return {'label': label, 'text': text};
          }).toList();
        }
      } catch (e) {
        print('❌ 解析选项失败: $e');
      }
    }
    String answer = '';
    final answerData = stem.answer;
    if (answerData != null && answerData.isNotEmpty) {
      try {
        final List<dynamic> answerList = (answerData is String)
            ? (jsonDecode(answerData) as List)
            : (answerData as List);
        answer = answerList
            .map((idx) {
              final index = int.tryParse(idx.toString()) ?? 0;
              return String.fromCharCode(65 + index);
            })
            .join('');
      } catch (e) {
        answer = answerData.toString();
      }
    }
    return {
      'id': q.id,
      'type': q.type,
      'type_name': q.typeName,
      'level': q.level,
      'thematic_stem': q.thematicStem,
      'question': stem.content ?? '',
      'options': options,
      'answer': answer,
      'analysis': q.parse ?? '',
      'is_collect': q.isCollect,
      'question_version_id': stem.questionVersionId,
      'knowledge_ids_name': q.knowledgeIdsName,
      'original_index': originalIndex,
      'stem_index': stemIndex,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部导航栏
            _buildTopBar(),

            // 题目内容区域
            Expanded(
              child: QuestionCardSwiper(
                questions: _questionData,
                initialIndex: _currentIndex,
                showAnswer: true, // ✅ 收藏详情页显示答案（背题模式）
                autoNext: false, // 不自动跳转
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),

            // 底部工具栏
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  /// 顶部导航栏
  /// 对应小程序: Line 5-16
  Widget _buildTopBar() {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: Row(
        children: [
          // 返回按钮（图标用 .w 与布局一致，不用 .sp 避免受字体缩放影响）
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Icon(
                Icons.arrow_back_ios,
                size: 20.w,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // 题目进度（一拆多题后按展开条数显示）
          Expanded(
            child: Center(
              child: Text(
                '${_currentIndex + 1}/${_questionData.length}',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontSize: 16.sp,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),

          // 占位，保持居中
          SizedBox(width: 40.w),
        ],
      ),
    );
  }

  /// 底部工具栏
  /// 对应小程序: Line 28-42 (bottom-utils)
  Widget _buildBottomBar() {
    final currentData = _questionData[_currentIndex];
    final isCollected = currentData['is_collect'] == '1';
    final originalIndex = currentData['original_index'] as int? ?? 0;
    final currentQuestion = widget.questions[originalIndex];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // 收藏/取消收藏
            _buildToolButton(
              icon: isCollected ? Icons.star : Icons.star_border,
              label: '收藏',
              color: isCollected ? Colors.amber : AppColors.textSecondary,
              onTap: () {
                _toggleCollect(currentQuestion);
              },
            ),

            // 纠错
            _buildToolButton(
              icon: Icons.error_outline,
              label: '纠错',
              color: AppColors.textSecondary,
              onTap: () {
                _showErrorCorrection(currentQuestion);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 工具按钮
  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20.sp, color: color),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 12.sp,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// 收藏/取消收藏
  void _toggleCollect(CollectionQuestionModel question) {
    final notifier = ref.read(collectionNotifierProvider.notifier);

    // ✅ 从 _questionData 读取当前状态（确保状态同步）
    final currentStatus =
        _questionData[_currentIndex]['is_collect']?.toString() ?? '2';
    final newStatus = currentStatus == '1' ? '2' : '1';

    print('✅ [收藏按钮] 点击，当前状态: $currentStatus, 新状态: $newStatus');

    // ✅ 更新 _questionData （用于 UI 显示）
    if (_currentIndex >= 0 && _currentIndex < _questionData.length) {
      _questionData[_currentIndex]['is_collect'] = newStatus;

      print(
        '✅ [收藏按钮] 更新 _questionData[$_currentIndex][is_collect] = $newStatus',
      );

      // ✅ 触发UI更新
      setState(() {});
    }

    // ✅ 当前小题的 question_version_id（一拆多题后每页对应一个子题）
    final questionVersionId = (_questionData[_currentIndex]['question_version_id']?.toString() ?? '').trim();

    if (questionVersionId.isNotEmpty) {
      print(
        '✅ [收藏接口] 调用 toggleCollect: questionVersionId=$questionVersionId, status=$newStatus',
      );

      notifier.toggleCollect(
        questionVersionId: questionVersionId,
        status: newStatus,
      );
    } else {
      print('❌ [收藏接口] questionVersionId 为空，无法调用接口');
    }

    // ✅ 使用 EasyLoading 显示提示
    if (newStatus == '1') {
      EasyLoading.showSuccess('收藏成功');
    } else {
      EasyLoading.showToast('取消收藏');
    }
  }

  /// 纠错
  void _showErrorCorrection(CollectionQuestionModel question) {
    ErrorCorrectionDialog.show(
      context,
      onSubmit: (data) {
        final questionVersionId = (_questionData[_currentIndex]['question_version_id']?.toString() ?? '').trim();

        if (questionVersionId.isNotEmpty) {
          ref
              .read(collectionNotifierProvider.notifier)
              .submitErrorCorrection(
                questionVersionId: questionVersionId,
                errorContent: data['description'] ?? '',
                errorType: data['err_type'] ?? '',
                filePath: (data['file_path'] as List?)?.cast<String>() ?? [],
              );

          // ✅ 使用 EasyLoading 显示成功提示
          EasyLoading.showSuccess('感谢您的意见！');
        }
      },
    );
  }
}
