import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';

import 'package:yakaixin_app/core/theme/app_colors.dart';
import 'package:yakaixin_app/core/theme/app_text_styles.dart';
import 'package:yakaixin_app/core/theme/app_spacing.dart';
import 'package:yakaixin_app/core/theme/app_radius.dart';
import 'package:yakaixin_app/core/utils/safe_type_converter.dart';
import 'package:yakaixin_app/features/wrong_book/models/wrong_question_model.dart';
import 'package:yakaixin_app/features/wrong_book/providers/wrong_book_provider.dart';
import 'package:yakaixin_app/features/question_bank/widgets/question/question_card.dart'; // ✅ 复用做题的组件
import 'package:yakaixin_app/features/question_bank/widgets/make_question/error_correction_dialog.dart'; // ✅ 纠错弹窗
import 'package:flutter_easyloading/flutter_easyloading.dart';

/// 错题本详情页
/// 对应小程序: wrongQuestionBook/wrongQuestionDetails.vue
class WrongBookDetailPage extends ConsumerStatefulWidget {
  final List<WrongQuestionModel> questions;
  final int initialIndex;
  final bool isReview;  // true-错题复查(做题模式), false-查看详情(直接显示答案)

  const WrongBookDetailPage({
    super.key,
    required this.questions,
    this.initialIndex = 0,
    this.isReview = false,
  });

  @override
  ConsumerState<WrongBookDetailPage> createState() => _WrongBookDetailPageState();
}

class _WrongBookDetailPageState extends ConsumerState<WrongBookDetailPage> {
  late PageController _pageController;
  late int _currentIndex;
  
  // ✅ 用于控制当前题目是否显示解析（每道题独立）
  final Map<int, bool> _showAnalysisMap = {};
  
  // ✅ 用于保存每道题的答案（错题复查模式）
  final Map<int, String> _userAnswersMap = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部导航栏
            _buildTopBar(),
            // 题目内容 - ✅ 使用QuestionCard组件
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.questions.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  return _buildQuestionCard(widget.questions[index]);
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
  Widget _buildTopBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 返回按钮
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, size: 24.sp, color: AppColors.textPrimary),
          ),
          // 进度显示
          Text(
            '${_currentIndex + 1}/${widget.questions.length}',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(width: 24.sp), // 占位保持居中
        ],
      ),
    );
  }

  /// 构建题目卡片 - ✅ 复用QuestionCard组件
  Widget _buildQuestionCard(WrongQuestionModel question) {
    // ✅ 转换数据格式为QuestionCard需要的格式
    final questionData = _convertToQuestionCardData(question);
    
    // ✅ 错题复查模式：使用保存的答案或点击"查看觧析"的标记
    if (widget.isReview) {
      if (_userAnswersMap.containsKey(_currentIndex)) {
        // ✅ 已答题：使用保存的答案
        questionData['user_answer'] = _userAnswersMap[_currentIndex];
      } else if (_showAnalysisMap[_currentIndex] ?? false) {
        // ✅ 未答题但点击了"查看觧析"
        questionData['user_answer'] = '__FORCE_SHOW__';
      }
    }
    
    // ✅ 返回包含题目卡片 + 纠错按钮的容器
    // 对应小程序 Line 116-118
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // 题目卡片
          QuestionCard(
            question: questionData,
            questionNumber: _currentIndex + 1,
            showAnswer: !widget.isReview,
            readOnly: !widget.isReview,
            // ✅ 答题回调：保存答案到 Map
            onAnswerChanged: widget.isReview ? (answer) {
              _userAnswersMap[_currentIndex] = answer;
              print('✅ 题目 $_currentIndex 答题: $answer, 保存到 _userAnswersMap');
              // ✅ 延迟执行 setState，避免在 QuestionCard 内部构建时触发重建导致数据丢失
              Future.microtask(() {
                if (mounted) {
                  setState(() {
                    // ✅ 只是为了触发重建，数据已经在上面保存了
                  });
                }
              });
            } : null,
          ),
          
          SizedBox(height: 20.h),
          
          // ✅ 试题纠错按钮（对应小程序 Line 116-118）
          _buildErrorCorrectionButton(question),
        ],
      ),
    );
  }

  /// 转换为QuestionCard需要的数据格式
  Map<String, dynamic> _convertToQuestionCardData(WrongQuestionModel q) {
    print('\n========== 开始转换题目数据 ==========');
    print('题目ID: ${q.id}');
    print('题目类型: ${q.type}');
    print('stemList长度: ${q.stemList?.length ?? 0}');
    
    // ✅ 解析选项 - 后端返回的是HTML字符串数组 ["<p>选项1</p>", "<p>选项2</p>"]
    List<Map<String, dynamic>> options = [];  // ✅ 修改为 dynamic
    if (q.stemList != null && q.stemList!.isNotEmpty) {
      final firstStem = q.stemList!.first;
      print('stemList[0].option: ${firstStem.option}');
      if (firstStem.option != null && firstStem.option!.isNotEmpty) {
        try {
          final List<dynamic> optionsJson = json.decode(firstStem.option!);
          print('✅ 解析后的optionsJson: $optionsJson');
          final labels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
          options = optionsJson.asMap().entries.map((entry) {
            final index = entry.key;
            final optText = entry.value.toString(); // ✅ 直接是HTML字符串
            return {
              'label': labels[index],
              'text': optText,  // ✅ QuestionOptions组件使用'text'字段
            };
          }).toList();
          print('✅ 成功解析到 ${options.length} 个选项:');
          for (var opt in options) {
            final value = opt['value']?.toString() ?? '';
            final preview = value.length > 30 ? value.substring(0, 30) + '...' : value;
            print('   ${opt['label']}: $preview');
          }
        } catch (e, stackTrace) {
          print('❌ 解析选项失败: $e');
          print('   原始数据: ${firstStem.option}');
          print('   错误堆栈: $stackTrace');
        }
      } else {
        print('❌ option字段为null或空');
      }
    } else {
      print('❌ stemList为空');
    }

    // ✅ 获取答案 - 转换为 "A,B" 格式
    String answer = '';
    if (q.stemList != null && q.stemList!.isNotEmpty) {
      final firstStem = q.stemList!.first;
      print('\nstemList[0].answer: ${firstStem.answer}');
      if (firstStem.answer != null && firstStem.answer!.isNotEmpty) {
        try {
          final List<dynamic> answerJson = json.decode(firstStem.answer!);
          print('✅ 解析后的answerJson: $answerJson');
          final labels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
          answer = answerJson.map((idx) {
            final i = int.tryParse(idx.toString()) ?? 0;
            return labels[i];
          }).join(',');
          print('✅ 最终答案: $answer');
        } catch (e) {
          print('❌ 解析答案失败: $e, 原始数据: ${firstStem.answer}');
        }
      } else {
        print('❌ answer字段为null或空');
      }
    }

    // ✅ 获取题干内容
    String questionContent = '';
    if (q.stemList != null && q.stemList!.isNotEmpty) {
      questionContent = q.stemList!.first.content ?? '';
      print('\n题干内容: ${questionContent.length > 50 ? questionContent.substring(0, 50) + '...' : questionContent}');
    } else {
      print('\n❌ 题干内容为空');
    }
    
    // ✅ 获取主题干 (thematic_stem)
    final thematicStem = q.thematicStem;
    if (thematicStem != null && thematicStem.isNotEmpty) {
      print('主题干: ${thematicStem.length > 50 ? thematicStem.substring(0, 50) + '...' : thematicStem}');
    }

    final result = {
      'id': q.id,
      'type': q.type,
      'question': questionContent,  // ✅ 使用 'question' 字段
      'thematic_stem': q.thematicStem,
      'options': options,  // ✅ Map<String, String> 格式
      'answer': answer,  // ✅ 字母格式 "A,B"
      'analysis': q.parse ?? '',
      'knowledge_ids_name': [q.knowledgeIdsName ?? ''],  // ✅ 数组格式
      'level': q.level,
      // ✅ 复查模式：不设置user_answer，让用户可以重新答题
      // ✅ 查看详情模式：也不设置user_answer，直接显示答案和解析
      'user_answer': null,
    };
    
    print('\n========== 转换后的数据 ==========');
    print('question: ${questionContent.length > 50 ? questionContent.substring(0, 50) + '...' : questionContent}');
    print('options数量: ${options.length}');
    print('answer: $answer');
    print('user_answer: ${result['user_answer']}');
    print('===================================\n');
    
    return result;
  }

  /// 底部工具栏
  Widget _buildBottomBar() {
    final currentQuestion = widget.questions[_currentIndex];
    final wrongAnswerBookId = currentQuestion.wrongAnswerBookId ?? '';
    
    // ✅ 从Provider中获取最新的题目状态
    final wrongBookState = ref.watch(wrongBookNotifierProvider);
    
    // ✅ 先在所有列表中查找最新状态
    WrongQuestionModel? latestQuestion;
    final allQuestions = [
      ...wrongBookState.allQuestions,
      ...wrongBookState.markedQuestions,
      ...wrongBookState.fallibleQuestions,
    ];
    
    for (final q in allQuestions) {
      if (q.wrongAnswerBookId == wrongAnswerBookId) {
        latestQuestion = q;
        break;
      }
    }
    
    // ✅ 使用最新状态的isMark，如果找不到则使用当前question的状态
    final isMark = SafeTypeConverter.toInt(
      (latestQuestion ?? currentQuestion).isMark
    ) == 1;
    
    print('🔍 底部栏状态: wrongAnswerBookId=$wrongAnswerBookId, isMark=$isMark, latestQuestion存在=${latestQuestion != null}');

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // ✅ 移出按钮（点击列表进入时显示）
            // 对应小程序Line 123-128: v-if="isReview == 'false'"
            if (!widget.isReview)
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _removeQuestion(currentQuestion),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: BorderSide(color: AppColors.border),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    '移出',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            
            if (!widget.isReview) SizedBox(width: 12.w),
            
            // ✅ 错题复查模式 - 只显示"查看觧析"按钮
            // 对应小程序Line 129-135: v-if="isReview == 'true'"
            if (widget.isReview)
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // ✅ 点击后设置当前题目的 _showAnalysis = true
                    setState(() {
                      _showAnalysisMap[_currentIndex] = true;
                    });
                    print('✅ 点击查看觧析，当前题目索引=$_currentIndex');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textWhite,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    elevation: 0,
                  ),
                  child: Text(
                    '查看觧析',
                    style: AppTextStyles.buttonMedium,
                  ),
                ),
              ),
            
            // ✅ 标记按钮（点击列表进入时显示）
            // 对应小程序Line 136-147
            if (!widget.isReview)
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _toggleMark(currentQuestion, isMark),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isMark ? AppColors.border : AppColors.warning,
                    foregroundColor: AppColors.textWhite,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    elevation: 0,
                  ),
                  child: Text(
                    isMark ? '取消标记' : '标记',
                    style: AppTextStyles.buttonMedium,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 移出错题
  Future<void> _removeQuestion(WrongQuestionModel question) async {
    try {
      await ref.read(wrongBookNotifierProvider.notifier).removeQuestion(
        wrongAnswerBookId: question.wrongAnswerBookId ?? '',
      );
      
      EasyLoading.showSuccess('操作成功');
      
      // 如果还有题目，跳转到下一题；否则返回
      if (widget.questions.length > 1) {
        if (_currentIndex >= widget.questions.length - 1 && _currentIndex > 0) {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      EasyLoading.showError('操作失败');
    }
  }

  /// 标记/取消标记
  Future<void> _toggleMark(WrongQuestionModel question, bool isMark) async {
    if (isMark) {
      // ✅ 已标记 → 取消标记（直接调用接口）
      try {
        await ref.read(wrongBookNotifierProvider.notifier).toggleMark(
          wrongAnswerBookId: question.wrongAnswerBookId ?? '',
          isMarked: true,  // 取消标记
        );
        
        EasyLoading.showSuccess('操作成功');
      } catch (e) {
        EasyLoading.showError('操作失败');
      }
    } else {
      // ✅ 未标记 → 弹出标签选择器
      _showMarkTagSelector(question);
    }
  }

  /// 显示标签选择器
  /// 对应小程序: filtrateModule = true
  void _showMarkTagSelector(WrongQuestionModel question) {
    final tags = [
      '思路错误',
      '理解错误',
      '概念不清',
      '审题不清',
    ];
    
    final selectedTags = <String>{};
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 标题栏
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.divider,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              '取消',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          Text(
                            '选择标签',
                            style: AppTextStyles.heading4,
                          ),
                          TextButton(
                            onPressed: selectedTags.isEmpty
                                ? null
                                : () {
                                    Navigator.pop(context);
                                    _confirmMarkWithTags(
                                      question,
                                      selectedTags.toList(),
                                    );
                                  },
                            child: Text(
                              '确定',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: selectedTags.isEmpty
                                    ? AppColors.textHint
                                    : AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // 标签列表
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Wrap(
                        spacing: 12.w,
                        runSpacing: 12.h,
                        children: tags.map((tag) {
                          final isSelected = selectedTags.contains(tag);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedTags.remove(tag);
                                } else {
                                  selectedTags.add(tag);
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withOpacity(0.1)
                                    : AppColors.inputBackground,
                                borderRadius: AppRadius.radiusSm,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                tag,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// 确认标记（带标签）
  /// 对应小程序: onSuccessClick
  Future<void> _confirmMarkWithTags(
    WrongQuestionModel question,
    List<String> tags,
  ) async {
    try {
      await ref.read(wrongBookNotifierProvider.notifier).toggleMark(
        wrongAnswerBookId: question.wrongAnswerBookId ?? '',
        isMarked: false,  // 标记
        markTab: tags.join(','),  // ✅ 逗号分隔的标签字符串
      );
      
      EasyLoading.showSuccess('操作成功');
    } catch (e) {
      EasyLoading.showError('操作失败');
    }
  }

  /// 构建纠错按钮
  /// 对应小程序 wrongQuestionDetails.vue Line 116-118
  Widget _buildErrorCorrectionButton(WrongQuestionModel question) {
    return GestureDetector(
      onTap: () => _showErrorCorrection(question),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: AppRadius.radiusMd,
        ),
        child: Center(
          child: Text(
            '试题纠错',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  /// 显示纠错弹窗
  /// 参照章节练习 make_question_page.dart Line 1043-1082
  void _showErrorCorrection(WrongQuestionModel question) {
    ErrorCorrectionDialog.show(
      context,
      onSubmit: (data) async {
        try {
          print('\n========== 📤 纠错数据 ==========');
          print('类型: ${data['err_type']} (${data['err_type'].runtimeType})');
          print('描述: ${data['description']}');
          print('图片: ${data['file_path']}');
          print('================================\n');
          
          // ✅ 获取题目信息
          final questionId = question.id?.toString() ?? '';
          final questionVersionId = question.stemList?.isNotEmpty == true
              ? (question.stemList!.first.questionVersionId?.toString() ?? '')
              : '';
          // ✅ 修复：version 为 0 时使用默认值 '1'（对照章节练习页面）
          final versionRaw = question.version?.toString() ?? '';
          final version = (versionRaw.isEmpty || versionRaw == '0') ? '1' : versionRaw;
          
          print('题目ID: $questionId (类型: ${questionId.runtimeType})');
          print('题目版本ID: $questionVersionId (类型: ${questionVersionId.runtimeType})');
          print('版本号: $version (原始值: $versionRaw)\n');
          
          if (questionId.isEmpty || questionVersionId.isEmpty) {
            EasyLoading.showError('题目信息不完整');
            return;
          }
          
          EasyLoading.show(status: '提交中...');
          
          // ✅ 调用纠错接口
          await ref.read(wrongBookNotifierProvider.notifier).submitErrorCorrection(
            questionId: questionId,
            questionVersionId: questionVersionId,
            version: version,
            errorType: data['err_type'] as String,
            errorContent: data['description'] as String,
            filePath: (data['file_path'] as List).cast<String>(),
          );
          
          print('✅ 纠错提交成功\n');
          
          // ✅ 延迟显示成功提示
          await Future.delayed(const Duration(milliseconds: 500));
          EasyLoading.showSuccess('感谢您的意见！');
        } catch (e, stackTrace) {
          print('❌ 纠错提交失败: $e');
          print('堆栈信息: $stackTrace\n');
          EasyLoading.showError('提交失败: $e');
        }
      },
    );
  }
}
