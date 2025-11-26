import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:yakaixin_app/app/routes/app_routes.dart';

/// 考试中页面 - 对应小程序 examination/examinationing.vue
/// 功能：考试答题、倒计时、答题卡
class ExaminationingPage extends ConsumerStatefulWidget {
  final String paperVersionId;
  final String goodsId;
  final String orderId;
  final String title;
  final String professionalId;
  final String type;
  final int timeLimit; // 考试时长（秒）
  final String? recitationQuestionModel;

  const ExaminationingPage({
    super.key,
    required this.paperVersionId,
    required this.goodsId,
    required this.orderId,
    required this.title,
    required this.professionalId,
    required this.type,
    required this.timeLimit,
    this.recitationQuestionModel,
  });

  @override
  ConsumerState<ExaminationingPage> createState() => _ExaminationingPageState();
}

class _ExaminationingPageState extends ConsumerState<ExaminationingPage> {
  int _currentIndex = 0;
  int _remainingTime = 0;
  Timer? _timer;
  bool _showAnswerSheet = false;
  final PageController _pageController = PageController();

  // Mock 数据
  final List<Map<String, dynamic>> _mockQuestions = [
    {
      'question_id': 'q1',
      'sub_question_id': 'sq1',
      'question_number': 1,
      'type': '1', // 单选
      'stem': '牙齿的萌出顺序中，最先萌出的恒牙是？',
      'options': [
        {'key': 'A', 'value': '第一前磨牙'},
        {'key': 'B', 'value': '第一磨牙'},
        {'key': 'C', 'value': '中切牙'},
        {'key': 'D', 'value': '侧切牙'},
      ],
      'user_option': '',
      'doubt': false,
    },
    {
      'question_id': 'q2',
      'sub_question_id': 'sq2',
      'question_number': 2,
      'type': '2', // 多选
      'stem': '下列属于牙周组织的有？',
      'options': [
        {'key': 'A', 'value': '牙龈'},
        {'key': 'B', 'value': '牙周膜'},
        {'key': 'C', 'value': '牙骨质'},
        {'key': 'D', 'value': '牙槽骨'},
        {'key': 'E', 'value': '牙髓'},
      ],
      'user_option': '',
      'doubt': false,
    },
    {
      'question_id': 'q3',
      'sub_question_id': 'sq3',
      'question_number': 3,
      'type': '1',
      'stem': '牙本质过敏最常见的原因是？',
      'options': [
        {'key': 'A', 'value': '釉质缺损'},
        {'key': 'B', 'value': '牙本质暴露'},
        {'key': 'C', 'value': '牙髓炎'},
        {'key': 'D', 'value': '牙周炎'},
      ],
      'user_option': '',
      'doubt': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.timeLimit;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel();
        _showTimeUpDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await _showExitConfirmDialog();
        return shouldPop ?? false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          child: Stack(
            children: [
              _buildBody(),
              if (_showAnswerSheet) _buildAnswerSheetMask(),
              if (_showAnswerSheet) _buildAnswerSheet(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildHeader(),
        _buildSessionInfo(),
        _buildQuestionArea(),
        _buildBottomBar(),
      ],
    );
  }

  /// 顶部栏
  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _showSubmitDialog(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFF04C140),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                '交卷',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Text(
            '${_currentIndex + 1}/${_mockQuestions.length}',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF262629),
            ),
          ),
        ],
      ),
    );
  }

  /// 轮次信息
  Widget _buildSessionInfo() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '第1轮：${widget.title}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF262629),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '剩余考试时间：${_formatTime(_remainingTime)}',
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFFFF4D4F),
            ),
          ),
        ],
      ),
    );
  }

  /// 题目区域
  Widget _buildQuestionArea() {
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: _mockQuestions.length,
        itemBuilder: (context, index) {
          return _QuestionCard(
            question: _mockQuestions[index],
            onAnswerChanged: (answer) {
              setState(() {
                _mockQuestions[index]['user_option'] = answer;
              });
            },
          );
        },
      ),
    );
  }

  /// 底部操作栏
  Widget _buildBottomBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          _buildBottomButton(
            icon: 'assets/images/exam_answer_card.png',
            label: '答题卡',
            onTap: () {
              setState(() {
                _showAnswerSheet = true;
              });
            },
          ),
          SizedBox(width: 12.w),
          _buildBottomButton(
            icon: 'assets/images/exam_doubt.png',
            label: _mockQuestions[_currentIndex]['doubt'] ? '已标疑' : '标疑',
            isActive: _mockQuestions[_currentIndex]['doubt'],
            onTap: _toggleDoubt,
          ),
          const Spacer(),
          _buildNavButton('上一题', _previousQuestion),
          SizedBox(width: 12.w),
          _buildNavButton('下一题', _nextQuestion),
        ],
      ),
    );
  }

  Widget _buildBottomButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Icon(
              Icons.grid_view,
              size: 20.sp,
              color: isActive ? const Color(0xFF018CFF) : Colors.grey,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: isActive ? const Color(0xFF018CFF) : const Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80.w,
        height: 36.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF2E68FF),
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// 答题卡遮罩
  Widget _buildAnswerSheetMask() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showAnswerSheet = false;
        });
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
      ),
    );
  }

  /// 答题卡
  Widget _buildAnswerSheet() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 400.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
        ),
        child: Column(
          children: [
            _buildAnswerSheetHeader(),
            Expanded(
              child: _buildAnswerSheetGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerSheetHeader() {
    final answeredCount = _mockQuestions.where((q) => q['user_option'].toString().isNotEmpty).length;
    final doubtCount = _mockQuestions.where((q) => q['doubt'] == true).length;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE8E9EA),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            '答题卡',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF262629),
            ),
          ),
          const Spacer(),
          Text(
            '已答：$answeredCount  标疑：$doubtCount',
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerSheetGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 1,
      ),
      itemCount: _mockQuestions.length,
      itemBuilder: (context, index) {
        final question = _mockQuestions[index];
        final isAnswered = question['user_option'].toString().isNotEmpty;
        final isDoubt = question['doubt'] == true;
        final isCurrent = index == _currentIndex;

        return GestureDetector(
          onTap: () {
            setState(() {
              _currentIndex = index;
              _showAnswerSheet = false;
            });
            _pageController.jumpToPage(index);
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isCurrent
                  ? const Color(0xFF018CFF)
                  : isAnswered
                      ? const Color(0xFF04C140)
                      : Colors.white,
              border: Border.all(
                color: isDoubt ? const Color(0xFFFF4D4F) : const Color(0xFFE8E9EA),
                width: isDoubt ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              '${index + 1}',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: (isCurrent || isAnswered) ? Colors.white : const Color(0xFF262629),
              ),
            ),
          ),
        );
      },
    );
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextQuestion() {
    if (_currentIndex < _mockQuestions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _showSubmitDialog();
    }
  }

  void _toggleDoubt() {
    setState(() {
      _mockQuestions[_currentIndex]['doubt'] = !_mockQuestions[_currentIndex]['doubt'];
    });
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<bool?> _showExitConfirmDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认退出？'),
        content: const Text('您还没有交卷，确定退出吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('温馨提示'),
        content: const Text('您的考试时间已到，请交卷'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('退出考试'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _submitExam();
            },
            child: const Text('确认交卷'),
          ),
        ],
      ),
    );
  }

  void _showSubmitDialog() {
    final unansweredCount = _mockQuestions
        .where((q) => q['user_option'].toString().isEmpty)
        .length;

    final message = unansweredCount > 0
        ? '还有$unansweredCount道题未作答，确定要交卷吗？'
        : '确定要交卷吗？';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认交卷？'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(unansweredCount > 0 ? '继续做题' : '再看看'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _submitExam();
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }

  void _submitExam() {
    _timer?.cancel();
    
    // TODO: 提交答案到服务器
    
    // 跳转到交卷成功页
    context.pushReplacement(
      AppRoutes.submitSuccess,
      extra: {
        'session_name': widget.title,
        'mock_name': widget.title,
      },
    );
  }
}

/// 题目卡片
class _QuestionCard extends StatefulWidget {
  final Map<String, dynamic> question;
  final Function(String) onAnswerChanged;

  const _QuestionCard({
    required this.question,
    required this.onAnswerChanged,
  });

  @override
  State<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<_QuestionCard> {
  String _selectedAnswer = '';
  final Set<String> _multipleAnswers = {};

  @override
  void initState() {
    super.initState();
    _selectedAnswer = widget.question['user_option'] ?? '';
    if (widget.question['type'] == '2' && _selectedAnswer.isNotEmpty) {
      _multipleAnswers.addAll(_selectedAnswer.split(','));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSingleChoice = widget.question['type'] == '1';

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuestionStem(),
            SizedBox(height: 16.h),
            ..._buildOptions(isSingleChoice),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionStem() {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 15.sp,
          color: const Color(0xFF262629),
          height: 1.5,
        ),
        children: [
          TextSpan(
            text: '${widget.question['question_number']}. ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF018CFF),
            ),
          ),
          TextSpan(text: widget.question['stem'] ?? ''),
        ],
      ),
    );
  }

  List<Widget> _buildOptions(bool isSingleChoice) {
    final options = widget.question['options'] as List<dynamic>? ?? [];

    return options.map((option) {
      final key = option['key'] as String;
      final value = option['value'] as String;
      final isSelected = isSingleChoice
          ? _selectedAnswer == key
          : _multipleAnswers.contains(key);

      return GestureDetector(
        onTap: () => _handleOptionTap(key, isSingleChoice),
        child: Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE6F4FF) : const Color(0xFFF5F6FA),
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(
              color: isSelected ? const Color(0xFF018CFF) : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: isSingleChoice ? BoxShape.circle : BoxShape.rectangle,
                  borderRadius: isSingleChoice ? null : BorderRadius.circular(4.r),
                  color: isSelected ? const Color(0xFF018CFF) : Colors.white,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF018CFF) : const Color(0xFFD9D9D9),
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        isSingleChoice ? Icons.circle : Icons.check,
                        size: 12.sp,
                        color: Colors.white,
                      )
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  '$key. $value',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF262629),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  void _handleOptionTap(String key, bool isSingleChoice) {
    setState(() {
      if (isSingleChoice) {
        _selectedAnswer = key;
        widget.onAnswerChanged(key);
      } else {
        if (_multipleAnswers.contains(key)) {
          _multipleAnswers.remove(key);
        } else {
          _multipleAnswers.add(key);
        }
        final answer = _multipleAnswers.toList()..sort();
        widget.onAnswerChanged(answer.join(','));
      }
    });
  }
}
