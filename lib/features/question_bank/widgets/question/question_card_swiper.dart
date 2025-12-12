import 'package:flutter/material.dart';
import 'question_card.dart';

/// 题目轮播组件
/// 
/// 对应小程序: chapter-exercise-question-swiper-new.vue
/// 
/// 功能:
/// - PageView 实现题目滑动切换
/// - 预加载前后1题（性能优化）
/// - 自动保存答案
/// - 页面切换回调
/// - ✅ 答对自动跳转下一题
/// 
/// 使用场景:
/// - 章节练习
/// - 每日一测
/// - 模拟考试
class QuestionCardSwiper extends StatefulWidget {
  final List<Map<String, dynamic>> questions;  // 题目列表
  final int initialIndex;                      // 初始题目索引
  final bool showAnswer;                       // 是否显示答案
  final ValueChanged<int>? onPageChanged;      // 页面切换回调
  final ValueChanged<Map<String, dynamic>>? onAnswerChanged;  // 答案变化回调
  final bool autoNext;                         // ✅ 答对是否自动跳转下一题
  
  const QuestionCardSwiper({
    required this.questions,
    this.initialIndex = 0,
    this.showAnswer = false,
    this.onPageChanged,
    this.onAnswerChanged,
    this.autoNext = true,  // ✅ 默认开启自动跳转
    super.key,
  });

  @override
  State<QuestionCardSwiper> createState() => _QuestionCardSwiperState();
}

class _QuestionCardSwiperState extends State<QuestionCardSwiper> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(
      initialPage: widget.initialIndex,
      viewportFraction: 1.0,  // 每页占满全屏
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return const Center(
        child: Text('暂无题目'),
      );
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: widget.questions.length,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
        widget.onPageChanged?.call(index);
      },
      itemBuilder: (context, index) {
        return QuestionCard(
          question: widget.questions[index],
          questionNumber: index + 1,
          showAnswer: widget.showAnswer,
          readOnly: widget.showAnswer,  // ✅ 背题模式：只读，不能做题
          // ✅ 删除 showAnalysis，QuestionCard 已自动管理
          onAnswerChanged: (answer) {
            // 保存答案到题目数据
            widget.questions[index]['user_answer'] = answer;
            
            // ✅ 判断答案是否正确
            final correctAnswer = widget.questions[index]['answer']?.toString() ?? '';
            final isCorrect = _checkAnswer(answer, correctAnswer);
            widget.questions[index]['is_correct'] = isCorrect;
            
            // 通知父组件答案变化
            widget.onAnswerChanged?.call({
              'index': index,
              'questionId': widget.questions[index]['id'],
              'answer': answer,
              'isCorrect': isCorrect,
            });
            
            // ✅ 答对且开启自动跳转，延迟500ms跳转下一题
            if (widget.autoNext && isCorrect) {
              Future.delayed(Duration(milliseconds: 500), () {
                nextQuestion();
              });
            }
          },
        );
      },
    );
  }

  /// 跳转到指定题目
  void jumpToQuestion(int index) {
    if (index >= 0 && index < widget.questions.length) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// 下一题
  void nextQuestion() {
    if (_currentIndex < widget.questions.length - 1) {
      jumpToQuestion(_currentIndex + 1);
    }
  }

  /// 上一题
  void previousQuestion() {
    if (_currentIndex > 0) {
      jumpToQuestion(_currentIndex - 1);
    }
  }

  /// 获取当前题目索引
  int get currentIndex => _currentIndex;
  
  /// ✅ 检查答案是否正确
  bool _checkAnswer(String userAnswer, String correctAnswer) {
    if (userAnswer.isEmpty || correctAnswer.isEmpty) {
      return false;
    }
    
    // 单选题：直接比较
    if (userAnswer.length == 1) {
      return userAnswer == correctAnswer;
    }
    
    // 多选题：排序后比较
    final userAnswerSorted = userAnswer.split('').toList()..sort();
    final correctAnswerSorted = correctAnswer.split('').toList()..sort();
    
    return userAnswerSorted.join() == correctAnswerSorted.join();
  }
}
