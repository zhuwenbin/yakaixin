import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 做题页面
/// 对应小程序: src/modules/jintiku/pages/makeQuestion/makeQuestion.vue
class MakeQuestionPage extends ConsumerStatefulWidget {
  final Map<String, dynamic>? extra;

  const MakeQuestionPage({
    this.extra,
    super.key,
  });

  @override
  ConsumerState<MakeQuestionPage> createState() => _MakeQuestionPageState();
}

class _MakeQuestionPageState extends ConsumerState<MakeQuestionPage> {
  int _currentIndex = 0;
  bool _showAnswer = false;
  bool _showOnlyError = false;

  // Mock题目数据
  final List<Map<String, dynamic>> _questions = [
    {
      'id': '1',
      'question': '牙釉质的主要成分是？',
      'type': '1', // 1=单选 2=多选 3=判断
      'options': [
        {'label': 'A', 'text': '羟基磷灰石'},
        {'label': 'B', 'text': '胶原蛋白'},
        {'label': 'C', 'text': '钙盐'},
        {'label': 'D', 'text': '磷酸钙'},
      ],
      'answer': 'A',
      'analysis': '牙釉质的主要成分是羟基磷灰石，约占釉质重量的96%。',
      'user_answer': null,
      'is_correct': null,
    },
    {
      'id': '2',
      'question': '牙本质小管的走向是？',
      'type': '1',
      'options': [
        {'label': 'A', 'text': '从牙髓向外放射'},
        {'label': 'B', 'text': '从外向牙髓放射'},
        {'label': 'C', 'text': '平行排列'},
        {'label': 'D', 'text': '无规则分布'},
      ],
      'answer': 'A',
      'analysis': '牙本质小管从牙髓腔向外呈放射状排列，贯穿整个牙本质层。',
      'user_answer': null,
      'is_correct': null,
    },
    {
      'id': '3',
      'question': '牙周膜的主要功能包括（多选）',
      'type': '2', // 多选
      'options': [
        {'label': 'A', 'text': '固定牙齿'},
        {'label': 'B', 'text': '缓冲咬合压力'},
        {'label': 'C', 'text': '营养作用'},
        {'label': 'D', 'text': '感觉作用'},
      ],
      'answer': 'ABCD',
      'analysis': '牙周膜具有固定、支持、营养、感觉和修复等多种功能。',
      'user_answer': null,
      'is_correct': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部栏
            _buildTopBar(),
            // 题目内容
            Expanded(
              child: PageView.builder(
                itemCount: _questions.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                    _showAnswer = false;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildQuestionContent(_questions[index]);
                },
              ),
            ),
            // 底部操作栏
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  /// 构建顶部栏
  Widget _buildTopBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
        ),
      ),
      child: Row(
        children: [
          // 返回按钮
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, size: 24.sp),
          ),
          Spacer(),
          // 只看错题
          if (_questions.any((q) => q['is_correct'] == false))
            GestureDetector(
              onTap: () {
                setState(() {
                  _showOnlyError = !_showOnlyError;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: _showOnlyError ? Color(0xFFFF5E00) : Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Text(
                  _showOnlyError ? '全部' : '只看错题',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: _showOnlyError ? Colors.white : Color(0xFF666666),
                  ),
                ),
              ),
            ),
          SizedBox(width: 12.w),
          // 题号
          Text(
            '${_currentIndex + 1}/${_questions.length}',
            style: TextStyle(
              fontSize: 15.sp,
              color: Color(0xFF333333),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建题目内容
  Widget _buildQuestionContent(Map<String, dynamic> question) {
    final questionType = question['type'] as String;
    final isMultiple = questionType == '2';

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 题型标签
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Color(0xFFE3EBFF),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              isMultiple ? '多选题' : '单选题',
              style: TextStyle(
                fontSize: 11.sp,
                color: Color(0xFF2E68FF),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // 题目
          Text(
            question['question'] as String,
            style: TextStyle(
              fontSize: 16.sp,
              color: Color(0xFF333333),
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20.h),
          // 选项
          ...(question['options'] as List<Map<String, dynamic>>).map(
            (option) => _buildOption(question, option),
          ),
          // 答案解析
          if (_showAnswer) ...[
            SizedBox(height: 24.h),
            _buildAnalysis(question),
          ],
        ],
      ),
    );
  }

  /// 构建选项
  Widget _buildOption(Map<String, dynamic> question, Map<String, dynamic> option) {
    final label = option['label'] as String;
    final text = option['text'] as String;
    final userAnswer = question['user_answer'] as String?;
    final correctAnswer = question['answer'] as String;

    final isSelected = userAnswer?.contains(label) ?? false;
    final isCorrect = correctAnswer.contains(label);
    final showResult = _showAnswer && userAnswer != null;

    Color backgroundColor;
    Color borderColor;
    Color textColor;

    if (showResult) {
      if (isSelected) {
        // 用户选择的答案
        backgroundColor = isCorrect ? Color(0xFFE8F5E9) : Color(0xFFFFEBEE);
        borderColor = isCorrect ? Color(0xFF4CAF50) : Color(0xFFE74C3C);
        textColor = isCorrect ? Color(0xFF4CAF50) : Color(0xFFE74C3C);
      } else if (isCorrect) {
        // 正确答案（但用户未选）
        backgroundColor = Color(0xFFE8F5E9);
        borderColor = Color(0xFF4CAF50);
        textColor = Color(0xFF4CAF50);
      } else {
        backgroundColor = Colors.white;
        borderColor = Color(0xFFE5E5E5);
        textColor = Color(0xFF666666);
      }
    } else {
      backgroundColor = isSelected ? Color(0xFFE3EBFF) : Colors.white;
      borderColor = isSelected ? Color(0xFF4A90E2) : Color(0xFFE5E5E5);
      textColor = isSelected ? Color(0xFF4A90E2) : Color(0xFF333333);
    }

    return GestureDetector(
      onTap: () {
        if (!_showAnswer) {
          setState(() {
            final questionType = question['type'] as String;
            if (questionType == '2') {
              // 多选
              final currentAnswer = userAnswer ?? '';
              if (currentAnswer.contains(label)) {
                question['user_answer'] = currentAnswer.replaceAll(label, '');
              } else {
                question['user_answer'] = currentAnswer + label;
              }
            } else {
              // 单选
              question['user_answer'] = label;
            }
          });
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            // 选项标签
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: borderColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // 选项文本
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: textColor,
                  height: 1.4,
                ),
              ),
            ),
            // 正确/错误图标
            if (showResult && (isSelected || isCorrect))
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Color(0xFF4CAF50) : Color(0xFFE74C3C),
                size: 20.sp,
              ),
          ],
        ),
      ),
    );
  }

  /// 构建答案解析
  Widget _buildAnalysis(Map<String, dynamic> question) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0xFFFFF9E6),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Color(0xFFFFA726), size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                '答案解析',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '正确答案：${question['answer']}',
            style: TextStyle(
              fontSize: 14.sp,
              color: Color(0xFF4CAF50),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            question['analysis'] as String,
            style: TextStyle(
              fontSize: 14.sp,
              color: Color(0xFF666666),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建底部操作栏
  Widget _buildBottomBar() {
    final currentQuestion = _questions[_currentIndex];
    final hasAnswer = currentQuestion['user_answer'] != null;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE5E5E5), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 答题卡
          _buildBottomButton(
            icon: Icons.grid_view,
            label: '答题卡',
            onTap: () {
              // TODO: 显示答题卡
            },
          ),
          SizedBox(width: 12.w),
          // 收藏
          _buildBottomButton(
            icon: Icons.favorite_border,
            label: '收藏',
            onTap: () {
              // TODO: 收藏题目
            },
          ),
          SizedBox(width: 12.w),
          // 查看解析 / 提交答案
          Expanded(
            child: ElevatedButton(
              onPressed: hasAnswer
                  ? () {
                      setState(() {
                        if (_showAnswer) {
                          // 下一题
                          if (_currentIndex < _questions.length - 1) {
                            _currentIndex++;
                            _showAnswer = false;
                          }
                        } else {
                          // 显示解析
                          final answer = currentQuestion['answer'] as String;
                          final userAnswer = currentQuestion['user_answer'] as String;
                          currentQuestion['is_correct'] = answer == userAnswer;
                          _showAnswer = true;
                        }
                      });
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4A90E2),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Color(0xFFE0E0E0),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
              ),
              child: Text(
                _showAnswer
                    ? (_currentIndex < _questions.length - 1 ? '下一题' : '完成')
                    : '查看解析',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建底部按钮
  Widget _buildBottomButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18.sp, color: Color(0xFF666666)),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
