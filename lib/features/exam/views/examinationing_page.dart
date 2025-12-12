import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakaixin_app/app/constants/storage_keys.dart';
import 'package:yakaixin_app/app/routes/app_routes.dart'; // ✅ 导入 AppRoutes
import 'package:yakaixin_app/features/exam/models/question_model.dart';
import 'package:yakaixin_app/features/exam/providers/examinationing_provider.dart';

/// 考试中页面 - 对应小程序 examination/examinationing.vue
/// 功能：考试答题、倒计时、答题卡
///
/// ✅ 完整MVVM架构：
/// - Model: QuestionModel (question_model.dart)
/// - Service: ExamService.getQuestionList/getStudentExamInfo/submitAnswer
/// - ViewModel: ExaminationingNotifier (examinationing_provider.dart)
/// - View: ExaminationingPage (本文件)
class ExaminationingPage extends ConsumerStatefulWidget {
  final String paperVersionId;
  final String goodsId;
  final String orderId;
  final String title;
  final String professionalId;
  final String evaluationTypeId; // ✅ 测评分类ID
  final String type;
  final int timeLimit; // 考试时长（秒）（备用，优先使用API返回的时间）
  final String? recitationQuestionModel;

  const ExaminationingPage({
    super.key,
    required this.paperVersionId,
    required this.goodsId,
    required this.orderId,
    required this.title,
    required this.professionalId,
    required this.evaluationTypeId, // ✅ 测评分类ID
    required this.type,
    required this.timeLimit,
    this.recitationQuestionModel,
  });

  @override
  ConsumerState<ExaminationingPage> createState() => _ExaminationingPageState();
}

class _ExaminationingPageState extends ConsumerState<ExaminationingPage> {
  bool _showAnswerSheet = false;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // ✅ 页面初始化：加载试题
    Future.microtask(() {
      ref
          .read(examinationingNotifierProvider.notifier)
          .loadQuestions(
            examinationId: widget.goodsId,
            examinationSessionId: widget.orderId,
            professionalId: widget.professionalId,
            paperVersionId: widget.paperVersionId,
            type: widget.type,
            timeLimit: widget.timeLimit, // ✅ 传入考试时长（秒）
          );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    // ❌ 不要在这里调用 provider.dispose()，Riverpod 会自动管理
    // ref.read(examinationingNotifierProvider.notifier).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 监听答题状态
    final examinationingState = ref.watch(examinationingNotifierProvider);

    // ✅ 修复题目切换：监听 currentIndex 变化，同步 PageController
    ref.listen<int>(
      examinationingNotifierProvider.select((state) => state.currentIndex),
      (previous, next) {
        if (_pageController.hasClients &&
            next != _pageController.page?.round()) {
          _pageController.jumpToPage(next);
        }
      },
    );

    // ✅ 监听交卷成功，跳转到成绩报告页面
    // 对应小程序: test.vue Line 442-444 (直接跳转到成绩报告)
    // ✅ 路由跳转逻辑:
    // 1. 点击试卷 → 开始考试 → 跳转到答题页 (examinationing)
    // 2. 答题页 → 交卷 → 使用 pushReplacement 替换为成绩报告页
    // 3. 成绩报告页 → 重新答题 → 使用 pushReplacement 替换为答题页
    // 4. 答题页 → 再次交卷 → 使用 pushReplacement 替换为成绩报告页
    ref.listen<ExaminationingState>(examinationingNotifierProvider, (
      previous,
      next,
    ) {
      if (next.isSubmitted && !next.isLoading) {
        // 交卷成功，跳转到成绩报告页面
        // ✅ 使用 pushReplacement 替换当前页面，点击返回时不会回到答题页
        print('\n📝 [交卷成功]');
        print('  → 使用 pushReplacement 跳转到成绩报告页');
        
        context.pushReplacement(
          AppRoutes.examScoreReport,
          extra: {
            'paper_version_id': widget.paperVersionId,
            'order_id': widget.orderId,
            'goods_id': widget.goodsId,
            'title': widget.title,
            'professional_id': widget.professionalId,
            'recitation_question_model': widget.recitationQuestionModel,
          },
        );
      }

      // ✅ 显示错误提示（防止反复弹出）
      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            duration: const Duration(seconds: 3), // ✅ 3秒后自动消失
          ),
        );
      }

      // ✅ 监听倒计时结束（对应小程序 Line 218-252）
      if (previous != null &&
          previous.remainingTime > 0 &&
          next.remainingTime == 0 &&
          !next.isSubmitted) {
        // 时间到，显示强制交卷对话框
        Future.microtask(() => _showTimeUpDialog());
      }
    });
    // ✅ 显示加载状态
    if (examinationingState.isLoading &&
        examinationingState.questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // ✅ 显示错误状态
    if (examinationingState.error != null &&
        examinationingState.questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('加载失败: ${examinationingState.error}'),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('返回'),
              ),
            ],
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _showExitConfirmDialog();
        if (shouldPop == true && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          child: Stack(
            children: [
              _buildBody(examinationingState),
              if (_showAnswerSheet) _buildAnswerSheetMask(),
              if (_showAnswerSheet) _buildAnswerSheet(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(ExaminationingState state) {
    return Column(
      children: [
        _buildHeader(state),
        _buildSessionInfo(state),
        _buildQuestionArea(state),
        _buildBottomBar(state),
      ],
    );
  }

  /// 顶部栏
  Widget _buildHeader(ExaminationingState state) {
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
                color: const Color.fromARGB(255, 54, 63, 223),
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
            '${state.currentIndex + 1}/${state.questions.length}',
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

  Widget _buildSessionInfo(ExaminationingState state) {
    return Container(
      width: double.infinity,

      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${widget.title}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF262629),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '剩余考试时间：${_formatTime(state.remainingTime)}',
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFFFF4D4F)),
          ),
        ],
      ),
    );
  }

  /// 题目区域
  Widget _buildQuestionArea(ExaminationingState state) {
    if (state.questions.isEmpty) {
      return const Expanded(child: Center(child: Text('暂无试题')));
    }

    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // ✅ 禁用滑动，只能通过按钮切换
        onPageChanged: (index) {
          // 禁止 PageView 自己改变索引，只能通过按钮
        },
        itemCount: state.questions.length,
        itemBuilder: (context, index) {
          final question = state.questions[index];
          return _QuestionCard(
            question: question,
            onAnswerChanged: (answer) {
              ref
                  .read(examinationingNotifierProvider.notifier)
                  .selectAnswer(answer);
            },
          );
        },
      ),
    );
  }

  /// 底部操作栏
  Widget _buildBottomBar(ExaminationingState state) {
    final currentQuestion = state.questions.isNotEmpty
        ? state.questions[state.currentIndex]
        : null;

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
            label: currentQuestion?.doubt == true ? '已标疑' : '标疑',
            isActive: currentQuestion?.doubt ?? false,
            onTap: () {
              ref.read(examinationingNotifierProvider.notifier).toggleDoubt();
            },
          ),
          const Spacer(),
          _buildNavButton('上一题', () {
            ref
                .read(examinationingNotifierProvider.notifier)
                .previousQuestion();
          }),
          SizedBox(width: 12.w),
          _buildNavButton('下一题', () {
            ref.read(examinationingNotifierProvider.notifier).nextQuestion();
          }),
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
              color: isActive
                  ? const Color(0xFF018CFF)
                  : const Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
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
      child: Container(color: Colors.black.withValues(alpha: 0.5)),
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
            Expanded(child: _buildAnswerSheetGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerSheetHeader() {
    final state = ref.watch(examinationingNotifierProvider);
    final answeredCount = state.questions
        .where((q) => q.userOption != null && q.userOption!.isNotEmpty)
        .length;
    final doubtCount = state.questions.where((q) => q.doubt).length;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE8E9EA), width: 1),
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
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF666666)),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerSheetGrid() {
    final state = ref.watch(examinationingNotifierProvider);

    return Column(
      children: [
        // ✅ 图例说明（对应小程序 answer-sheet.vue Line 3-16）
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend(const Color(0xFF567DFA), '已做'),
              SizedBox(width: 47.w),
              _buildLegend(const Color(0xFFE4E4E4), '未做'),
              SizedBox(width: 47.w),
              _buildLegend(const Color(0xFFFB9E0C), '标疑'),
            ],
          ),
        ),
        // ✅ 题目网格（圆形样式，对应小程序 Line 106-135）
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 25.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 22.h,
              crossAxisSpacing: 32.w,
              childAspectRatio: 1,
            ),
            itemCount: state.questions.length,
            itemBuilder: (context, index) {
              final question = state.questions[index];
              final isAnswered =
                  question.userOption != null &&
                  question.userOption!.isNotEmpty;
              final isDoubt = question.doubt;

              return GestureDetector(
                onTap: () {
                  ref
                      .read(examinationingNotifierProvider.notifier)
                      .goToQuestion(index);
                  setState(() {
                    _showAnswerSheet = false;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    // ✅ 圆形（borderRadius: 50%）
                    shape: BoxShape.circle,
                    // ✅ 颜色对应小程序：
                    // done: #E7F3FE (已做-蓝色浅背景)
                    // doubt: #FB9E0C (标疑-橙色)
                    // default: #F6F6F6 (未做-灰色)
                    color: isDoubt
                        ? const Color(0xFFFB9E0C)
                        : isAnswered
                        ? const Color(0xFFE7F3FE)
                        : const Color(0xFFF6F6F6),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      // ✅ 文字颜色：
                      // doubt: #FFFFFF (标疑-白色)
                      // done: #567DFA (已做-蓝色)
                      // default: #000000 (未做-黑色)
                      color: isDoubt
                          ? Colors.white
                          : isAnswered
                          ? const Color(0xFF567DFA)
                          : Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// 答题卡图例
  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF333333)),
        ),
      ],
    );
  }

  // 这些方法已经通过Provider处理，不再需要本地实现

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

  void _showSubmitDialog() {
    final state = ref.read(examinationingNotifierProvider);
    final unansweredCount = state.questions
        .where((q) => q.userOption == null || q.userOption!.isEmpty)
        .length;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ 标题（对应小程序图片）
              Text(
                '确认交卷?',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF000000),
                ),
              ),
              SizedBox(height: 16.h),
              // ✅ 剩余考试时间（蓝色文字）
              Text(
                '剩余考试时间：${_formatTime(state.remainingTime)}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF387DFC),
                ),
              ),
              SizedBox(height: 24.h),
              // ✅ 提示文字
              Text(
                unansweredCount > 0
                    ? '还有$unansweredCount道题未作答，确定要交卷吗？'
                    : '确定要交卷吗？',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF666666),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              // ✅ 按钮（对应小程序图片）
              Row(
                children: [
                  // ✅ 左侧：继续做题（蓝色实心按钮）
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF387DFC),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                      ),
                      child: Text('继续做题', style: TextStyle(fontSize: 15.sp)),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // ✅ 右侧：确认（白色边框按钮）
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        // ✅ 从 SharedPreferences 中获取 studentId
                        final prefs = await SharedPreferences.getInstance();
                        final studentId =
                            prefs.getString(StorageKeys.studentId) ?? '';

                        // 调用Provider的提交方法（包含所有必填参数）
                        ref
                            .read(examinationingNotifierProvider.notifier)
                            .submitAnswers(
                              goodsId: widget.goodsId,
                              orderId: widget.orderId,
                              productId: widget
                                  .paperVersionId, // ✅ product_id = goods_id
                              professionalId: widget.professionalId,
                              type: widget.type,
                              userId: studentId, // ✅ user_id
                              studentId: studentId, // ✅ student_id
                              totalTime: widget.timeLimit,
                            );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF666666),
                        side: const BorderSide(
                          color: Color(0xFFDDDDDD),
                          width: 1,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                      ),
                      child: Text('确认', style: TextStyle(fontSize: 15.sp)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTimeUpDialog() {
    final state = ref.read(examinationingNotifierProvider);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ 标题（对应小程序 Line 236）
              Text(
                '温馨提示',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF000000),
                ),
              ),
              SizedBox(height: 16.h),
              // ✅ 剩余考试时间（显示 00:00:00）
              Text(
                '剩余考试时间：${_formatTime(state.remainingTime)}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF387DFC),
                ),
              ),
              SizedBox(height: 24.h),
              // ✅ 提示文字（对应小程序 Line 237）
              Text(
                '您的考试时间已到，请交卷',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF666666),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              // ✅ 按钮（对应小程序 Line 238-239）
              Row(
                children: [
                  // ✅ 左侧：退出考试（蓝色实心按钮）
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF387DFC),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                      ),
                      child: Text('退出考试', style: TextStyle(fontSize: 15.sp)),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // ✅ 右侧：确认交卷（白色边框按钮）
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        // ✅ 从 SharedPreferences 中获取 studentId
                        final prefs = await SharedPreferences.getInstance();
                        final studentId =
                            prefs.getString(StorageKeys.studentId) ?? '';

                        // 调用Provider的提交方法（包含所有必填参数）
                        ref
                            .read(examinationingNotifierProvider.notifier)
                            .submitAnswers(
                              goodsId: widget.goodsId,
                              orderId: widget.orderId,
                              productId:
                                  widget.goodsId, // ✅ product_id = goods_id
                              professionalId: widget.professionalId,
                              type: widget.type,
                              userId: studentId, // ✅ user_id
                              studentId: studentId, // ✅ student_id
                              totalTime: widget.timeLimit,
                            );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF666666),
                        side: const BorderSide(
                          color: Color(0xFFDDDDDD),
                          width: 1,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                      ),
                      child: Text('确认交卷', style: TextStyle(fontSize: 15.sp)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 题目卡片
class _QuestionCard extends StatefulWidget {
  final QuestionModel question;
  final Function(List<String>) onAnswerChanged;

  const _QuestionCard({required this.question, required this.onAnswerChanged});

  @override
  State<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<_QuestionCard> {
  String _selectedAnswer = '';
  final Set<String> _multipleAnswers = {};

  @override
  void initState() {
    super.initState();
    _selectedAnswer = widget.question.userOption ?? '';
    if (widget.question.type == '2' && _selectedAnswer.isNotEmpty) {
      _multipleAnswers.addAll(_selectedAnswer.split(','));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSingleChoice = widget.question.type == '1';

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
    final firstStem = widget.question.stemList.isNotEmpty
        ? widget.question.stemList.first
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ 题型显示（对应小程序 Line 8-10）
        _buildQuestionType(),
        SizedBox(height: 12.h),
        // 题号 + 题干内容
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 题号
            Text(
              '${widget.question.questionNumber}、',
              style: TextStyle(
                fontSize: 16.sp, // ✅ 对应小程序 32rpx (Line 327)
                fontWeight: FontWeight.normal, // ✅ 小程序题号不加粗 (Line 342)
                color: const Color(0xFF000000), // ✅ 纯黑色 (Line 342)
                height: 1.5,
              ),
            ),
            // 题干内容（HTML渲染）
            Expanded(
              child: Html(
                data: firstStem?.content ?? '',
                style: {
                  "body": Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                    fontSize: FontSize(16.sp), // ✅ 对应小程序 32rpx
                    color: const Color(0xFF000000), // ✅ 纯黑色
                    lineHeight: const LineHeight(1.5),
                  ),
                  "p": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 题型显示（对应小程序 select-question.vue Line 8-10）
  Widget _buildQuestionType() {
    // ✅ 直接使用后端返回的 type_name 字段（如 "A1", "A2" 等）
    final typeName = widget.question.typeName ?? '题型';

    return Text(
      '[$typeName题型]', // ✅ 显示格式：[A1题型]
      style: TextStyle(
        fontSize: 16.sp, // ✅ 对应小程序 32rpx (Line 327)
        color: const Color(0xFF387DFC), // ✅ 对应小程序蓝色 (Line 332)
        fontWeight: FontWeight.normal,
      ),
    );
  }

  List<Widget> _buildOptions(bool isSingleChoice) {
    final firstStem = widget.question.stemList.isNotEmpty
        ? widget.question.stemList.first
        : null;
    if (firstStem == null || firstStem.option == null) {
      return [];
    }

    // 解析JSON字符串选项 - option是String数组，不是Map数组
    final List<dynamic> options = [];
    try {
      options.addAll(jsonDecode(firstStem.option!) as List);
    } catch (e) {
      return [];
    }

    // 选项标签列表 A, B, C, D...
    const selectList = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];

    return options.asMap().entries.map((entry) {
      final index = entry.key;
      final optionContent = entry.value as String; // 选项是纯String，不是Map
      final key = selectList[index]; // A, B, C, D...
      final isSelected = isSingleChoice
          ? _selectedAnswer == key
          : _multipleAnswers.contains(key);

      return GestureDetector(
        onTap: () => _handleOptionTap(key, isSingleChoice),
        child: Container(
          margin: EdgeInsets.only(bottom: 16.h), // ✅ 对应小程序 32rpx (Line 355)
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 15.h,
          ), // ✅ 对应小程序 40rpx/15px (Line 354)
          decoration: BoxDecoration(
            // ✅ 选中状态背景 rgba(124, 191, 247, 0.18) (Line 378)
            color: isSelected
                ? const Color(0x2E7CBFF7) // rgba(124, 191, 247, 0.18)
                : Colors.white,
            // ✅ 圆角 50rpx (Line 350)
            borderRadius: BorderRadius.circular(25.r),
            // ✅ 边框：选中蓝色，未选中浅灰 (Line 351, 377)
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF567DFA) // 选中：蓝色边框
                  : const Color(0xFFECECEC), // 未选中：浅灰边框
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ✅ 选项标签 (A/B/C/D) - 对应小程序 Line 356-360
              Text(
                key,
                style: TextStyle(
                  fontSize: 16.sp, // ✅ 小程序未明确，使用 32rpx
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF333333),
                ),
              ),
              SizedBox(width: 14.w), // ✅ 对应小程序 28rpx (Line 359)
              // ✅ 竖线分隔符 - 对应小程序 Line 362-367
              Container(
                width: 1,
                height: 16.h, // ✅ 对应小程序 32rpx (Line 364)
                color: const Color(0xFFCACACA), // ✅ 对应小程序 (Line 365)
              ),
              SizedBox(width: 14.w), // ✅ 对应小程序 28rpx (Line 366)
              // ✅ 选项内容（HTML渲染）- 对应小程序 Line 368-371
              Expanded(
                child: Html(
                  data: optionContent,
                  style: {
                    "body": Style(
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                      fontSize: FontSize(16.sp), // ✅ 对应小程序 32rpx (Line 370)
                      color: const Color(0xFF262629),
                    ),
                    "p": Style(
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                    ),
                  },
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
        // ✅ 转换为数字索引字符串: A→"0", B→"1", C→"2" (对应小程序 test.vue Line 410-415)
        final index = _convertLetterToIndex(key);
        widget.onAnswerChanged([index]);
      } else {
        if (_multipleAnswers.contains(key)) {
          _multipleAnswers.remove(key);
        } else {
          _multipleAnswers.add(key);
        }
        // ✅ 转换为数字索引字符串数组: ["A", "B"] → ["0", "1"] (对应小程序)
        final answer = _multipleAnswers.toList()
          ..sort()
          ..map((letter) => _convertLetterToIndex(letter)).toList();
        final indexedAnswer = _multipleAnswers.map((letter) => _convertLetterToIndex(letter)).toList()..sort();
        widget.onAnswerChanged(indexedAnswer);
      }
    });
  }

  /// 将字母转换为数字索引字符串: A→"0", B→"1", C→"2", D→"3" ...
  /// 对应小程序 test.vue Line 414: String(jtem)
  String _convertLetterToIndex(String letter) {
    const selectList = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
    final index = selectList.indexOf(letter);
    return index.toString();
  }
}
