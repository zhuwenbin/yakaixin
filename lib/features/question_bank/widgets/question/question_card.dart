import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'question_stem.dart';
import 'question_options.dart';
import 'question_analysis.dart';

/// 单题卡片组件
/// 
/// 组合了:
/// - QuestionStem (题干)
/// - QuestionOptions (选项)
/// - QuestionAnalysis (解析)
/// 
/// 使用场景:
/// - 章节练习
/// - 每日一测
/// - 模拟考试
/// - 查看错题
class QuestionCard extends StatefulWidget {
  final Map<String, dynamic> question;  // 题目数据
  final int questionNumber;             // 题号（1,2,3...）
  final bool showAnswer;                // 是否显示答案
  final bool readOnly;                  // 是否只读模式
  final ValueChanged<String>? onAnswerChanged;  // 答案变化回调
  final VoidCallback? onShowAnalysis;   // ✅ 查看解析回调（用于错题复查模式）
  
  const QuestionCard({
    required this.question,
    required this.questionNumber,
    this.showAnswer = false,
    this.readOnly = false,
    this.onAnswerChanged,
    this.onShowAnalysis,  // ✅ 新增参数
    super.key,
  });
  
  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  // ✅ 是否显示解析（答题后自动显示）
  bool _showAnalysis = false;
  
  @override
  void initState() {
    super.initState();
    // ✅ 初始化觨析显示状态
    final userAnswer = widget.question['user_answer']?.toString() ?? '';
    
    // 1. readOnly=true && showAnswer=true → 立即显示（查看详情模式）
    // 2. readOnly=false && showAnswer=false → 答题后显示（做题模式）
    // 3. 已有答案 → 显示触析
    _showAnalysis = (widget.readOnly && widget.showAnswer) || userAnswer.isNotEmpty;
  }
  
  /// ✅ 强制显示触析（由父组件通过 onShowAnalysis 调用）
  void _forceShowAnalysis() {
    if (!_showAnalysis) {
      setState(() {
        _showAnalysis = true;
      });
    }
  }
  
  @override
  void didUpdateWidget(QuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // ✅ 当 user_answer 改变时，重置高亮状态
    final oldAnswer = oldWidget.question['user_answer']?.toString() ?? '';
    final newAnswer = widget.question['user_answer']?.toString() ?? '';
    
    if (oldAnswer != newAnswer) {
      // ✅ 使用 WidgetsBinding.addPostFrameCallback 确保在下一帧更新
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _showAnalysis = newAnswer.isNotEmpty;
          });
        }
      });
    }
  }
  
  /// ✅ 处理答案变化
  void _handleAnswerChanged(String answer) {
    // 1. 答题后自动显示解析
    if (!_showAnalysis && answer.isNotEmpty) {
      setState(() {
        _showAnalysis = true;
      });
    }
    
    // 2. 调用父组件回调
    widget.onAnswerChanged?.call(answer);
  }
  
  @override
  Widget build(BuildContext context) {
    final questionType = widget.question['type']?.toString() ?? '1';
    final questionContent = widget.question['question']?.toString() ?? '';
    final options = (widget.question['options'] as List<dynamic>?)
        ?.cast<Map<String, dynamic>>() ?? [];
    final userAnswer = widget.question['user_answer']?.toString() ?? '';
    final correctAnswer = widget.question['answer']?.toString() ?? '';
    final analysis = widget.question['analysis']?.toString() ?? '';
    final thematicStem = widget.question['thematic_stem']?.toString();
    final typeName = widget.question['type_name']?.toString();
    final isMultiple = widget.question['is_multiple'] == true || questionType == '2';
    
    // ✅ 同步 _showAnalysis 状态：根据 userAnswer、readOnly、showAnswer 实时更新
    final shouldShowAnalysis = (widget.readOnly && widget.showAnswer) || userAnswer.isNotEmpty;
    print('🔍 QuestionCard build: userAnswer="$userAnswer", readOnly=${widget.readOnly}, showAnswer=${widget.showAnswer}');
    print('   shouldShowAnalysis=$shouldShowAnalysis, _showAnalysis=$_showAnalysis');
    
    if (_showAnalysis != shouldShowAnalysis) {
      print('   ⚠️ 检测到状态不一致，准备更新 _showAnalysis 为 $shouldShowAnalysis');
      // ✅ 使用 addPostFrameCallback 避免在 build 中调用 setState
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _showAnalysis != shouldShowAnalysis) {
          setState(() {
            _showAnalysis = shouldShowAnalysis;
            print('   ✅ 已更新 _showAnalysis = $_showAnalysis');
          });
        }
      });
    }
    
    // ✅ 获取B1配伍题相关信息
    final isB1Group = widget.question['is_b1_group'] == true;
    final b1GroupNumber = widget.question['b1_group_number'] as int? ?? 0;
    final b1SubIndex = widget.question['b1_sub_index'] as int? ?? 0;
    final b1GroupSize = widget.question['b1_group_size'] as int? ?? 0;
    
    // ✅ 获取全站统计信息
    final statistics = widget.question['statistics'] as Map<String, dynamic>?;
    
    // ✅ 获取知识点列表（knowledge_ids_name）
    List<String> knowledgePoints = [];
    final knowledgeIdsName = widget.question['knowledge_ids_name'];
    if (knowledgeIdsName != null) {
      if (knowledgeIdsName is List) {
        knowledgePoints = knowledgeIdsName
            .where((item) => item != null)
            .map((item) => item.toString())
            .toList();
      }
    }
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 题干组件
          QuestionStem(
            questionNumber: widget.questionNumber,
            questionType: questionType,
            questionContent: questionContent,
            typeName: typeName,
            thematicStem: thematicStem,
            isMultiple: isMultiple,
            isB1Group: isB1Group,
            b1GroupNumber: b1GroupNumber,
            b1SubIndex: b1SubIndex,
            b1GroupSize: b1GroupSize,
          ),
          
          SizedBox(height: 20.h),
          
          // 2. 选项组件
          QuestionOptions(
            questionType: questionType,
            options: options,
            // ✅ 修复：当 userAnswer = '__FORCE_SHOW__' 时，不传递 userAnswer，避免显示错误高亮
            userAnswer: (userAnswer.isEmpty || userAnswer == '__FORCE_SHOW__') ? null : userAnswer,
            correctAnswer: correctAnswer,
            showAnswer: _showAnalysis,  // ✅ 使用内部状态控制高亮
            readOnly: widget.readOnly,
            onAnswerChanged: _handleAnswerChanged,  // ✅ 使用内部处理方法
          ),
          
          // 3. 解析组件（答题后自动显示）
          if (_showAnalysis) ...[
            SizedBox(height: 24.h),
            QuestionAnalysis(
              correctAnswer: correctAnswer,
              analysis: analysis,
              userAnswer: userAnswer.isEmpty ? null : userAnswer,
              isCorrect: widget.question['is_correct'] as bool?,
              statistics: statistics,
              knowledgePoints: knowledgePoints,  // ✅ 传递知识点
              showStatistics: true,  // ✅ 显示全站统计
              // ✅ 修复：只在非只读模式下显示"您的答案"
              // 场景1: readOnly=true（背题模式/查看详情模式） → 不显示"您的答案"
              // 场景2: readOnly=false 且 userAnswer='__FORCE_SHOW__'（错题复查点击"查看解析"） → 不显示"您的答案"
              // 场景3: readOnly=false 且 userAnswer='A'（正常答题） → 显示"您的答案"
              showUserAnswer: !widget.readOnly && userAnswer.isNotEmpty && userAnswer != '__FORCE_SHOW__',
            ),
          ],
        ],
      ),
    );
  }
}
