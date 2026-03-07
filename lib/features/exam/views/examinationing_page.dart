import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakaixin_app/app/constants/storage_keys.dart';
import 'package:yakaixin_app/app/routes/app_routes.dart';
import 'package:yakaixin_app/core/theme/app_colors.dart';
import 'package:yakaixin_app/core/theme/app_text_styles.dart';
import 'package:yakaixin_app/core/style/app_style_provider.dart';
import 'package:yakaixin_app/core/utils/safe_type_converter.dart';
import 'package:yakaixin_app/core/widgets/confirm_dialog.dart';
import 'package:yakaixin_app/features/exam/models/question_model.dart';
import 'package:yakaixin_app/features/exam/providers/examinationing_provider.dart';

/// 考试中页面 - 对应小程序 examination/examinationing.vue
/// 功能：考试答题、倒计时、答题卡；每日一练支持答题/背题模式
///
/// 入口与类型：
/// - 模拟考试 / 历年真题 → 试卷详情(TestExam) → 开始考试 → 本页为 **type=8 试卷答题**
/// - 每日一练 → 开始做题 → 本页可带 recitation_question_model=1 显示答题/背题 Tab
/// 布局与样式对齐小程序：头部交卷左、题号居中；Session/时间条；底部答题卡/标疑/上一题/下一题
///
/// 答题卡/标疑图标（小程序 test.vue 同款，750rpx→375 故 17.w×20.w）
const String _kAnswerCardIconUrl =
    'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/16950896298723a451695089629872551_dtk.png';
const String _kDoubtIconUrl =
    'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/16967375279005243169673752790025047_%E5%85%A8%E9%83%A8%E8%A7%A3%E6%9E%90%E5%A4%87%E4%BB%BD%205%402x.png';
const String _kDoubtActiveIconUrl =
    'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/16956222038717b4a169562220387182065_%E7%BC%96%E7%BB%84%205%E5%A4%87%E4%BB%BD%402x.png';
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

const int _recitationModeAnswer = 1;
const int _recitationModeRecite = 2;

class _ExaminationingPageState extends ConsumerState<ExaminationingPage> {
  bool _showAnswerSheet = false;
  final PageController _pageController = PageController();
  int _recitationMode = _recitationModeAnswer;

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
    final examinationingState = ref.watch(examinationingNotifierProvider);
    final tokens = ref.watch(appStyleTokensProvider);

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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            _buildBody(examinationingState, tokens),
            if (_showAnswerSheet) _buildAnswerSheetMask(),
            if (_showAnswerSheet) _buildAnswerSheet(tokens),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(ExaminationingState state, dynamic tokens) {
    return Column(
      children: [
        _buildHeader(state, tokens),
        _buildSessionInfo(state, tokens),
        _buildQuestionArea(state, tokens),
        _buildBottomBar(state, tokens),
      ],
    );
  }

  bool get _isRecitationEnabled {
    final v = widget.recitationQuestionModel;
    return v == '1' || (v != null && v.toString() == '1');
  }

  Widget _buildHeader(ExaminationingState state, dynamic tokens) {
    if (_isRecitationEnabled) {
      return _buildRecitationHeader(state, tokens);
    }
    return _buildNormalHeader(state, tokens);
  }

  /// 普通模式头部（对应小程序 .priview-time：交卷绝对左侧，题号居中，96rpx 高）
  Widget _buildNormalHeader(ExaminationingState state, dynamic tokens) {
    return Container(
      height: 48.h, // 小程序 96rpx = 48.h
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: const Color(0xFFEEEEEE), width: 1)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 交卷：绝对左侧（小程序 .success position absolute left 40rpx）
          Positioned(
            left: 20.w, // 40rpx = 20.w
            top: 0,
            bottom: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => _showSubmitDialog(),
                child: Container(
                  width: 60.w, // 120rpx = 60.w
                  height: 22.h, // 44rpx = 22.h
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: tokens.colors.primary,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '交卷',
                    style: TextStyle(
                      fontSize: 12.sp, // 24rpx = 12.sp
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 题号居中（小程序 .nums 在 center）
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16.sp, color: const Color(0xFF000000), fontWeight: FontWeight.w500),
              children: [
                TextSpan(text: '${state.currentIndex + 1}'),
                TextSpan(text: '/${state.questions.length}', style: TextStyle(color: const Color(0xFF949494))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecitationHeader(ExaminationingState state, dynamic tokens) {
    final showSubmit = _recitationMode == _recitationModeAnswer;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          if (showSubmit)
            GestureDetector(
              onTap: () => _showSubmitDialog(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: tokens.colors.primary,
                  borderRadius: BorderRadius.circular(8.r),
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
          const Spacer(),
          Container(
            width: 125.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: const Color(0xFFC6BFBF),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                _buildRecitationTab('答题', _recitationModeAnswer),
                _buildRecitationTab('背题', _recitationModeRecite),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildRecitationTab(String label, int mode) {
    final isActive = _recitationMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onRecitationTabTap(mode),
        child: Container(
          height: 30.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFF0F0F0) : const Color(0xFFC6BFBF),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: isActive ? const Color(0xFF666666) : Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onRecitationTabTap(int mode) async {
    if (_recitationMode == mode) return;
    final content = mode == _recitationModeAnswer
        ? '确认切换到答题模式吗？'
        : '确认切换到背题模式吗？';
    final confirmed = await ConfirmDialog.show(
      context,
      title: '提示',
      content: content,
      confirmText: '确定',
      cancelText: '取消',
    );
    if (confirmed != true) return;
    setState(() => _recitationMode = mode);
    ref.read(examinationingNotifierProvider.notifier).resetRemainingTime();
  }

  Widget _buildSessionInfo(ExaminationingState state, dynamic tokens) {
    final showTime =
        !_isRecitationEnabled || _recitationMode != _recitationModeRecite;
    if (_isRecitationEnabled) {
      return _buildRecitationSessionInfo(state, showTime, tokens);
    }
    return _buildNormalSessionInfo(state, showTime, tokens);
  }

  Widget _buildRecitationSessionInfo(
      ExaminationingState state, bool showTime, dynamic tokens) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 60.w),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF000000),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: 60.w,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${state.currentIndex + 1}/${state.questions.length}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (showTime) ...[
            SizedBox(height: 4.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(color: tokens.colors.tagBg),
              alignment: Alignment.center,
              child: Text(
                '剩余考试时间：${_formatTime(state.remainingTime)}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: tokens.colors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 普通模式 Session 信息（对应小程序 .title 32rpx/94rpx高 + .time 24rpx/64rpx高 #f5f8ff）
  Widget _buildNormalSessionInfo(
      ExaminationingState state, bool showTime, dynamic tokens) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 47.h, // 小程序 .title height 94rpx = 47.h
            child: Center(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16.sp, // 32rpx = 16.sp
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF000000),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (showTime)
            Container(
              width: double.infinity,
              height: 32.h, // 小程序 .time height 64rpx = 32.h
              decoration: BoxDecoration(color: tokens.colors.tagBg),
              alignment: Alignment.center,
              child: Text(
                '剩余考试时间：${_formatTime(state.remainingTime)}',
                style: TextStyle(
                  fontSize: 12.sp, // 24rpx = 12.sp
                  fontWeight: FontWeight.w400,
                  color: tokens.colors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 题目区域
  Widget _buildQuestionArea(ExaminationingState state, dynamic tokens) {
    if (state.questions.isEmpty) {
      return const Expanded(child: Center(child: Text('暂无试题')));
    }

    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          ref.read(examinationingNotifierProvider.notifier).goToQuestion(index);
        },
        itemCount: state.questions.length,
        itemBuilder: (context, index) {
          final question = state.questions[index];
          final showAnswer = _isRecitationEnabled &&
              _recitationMode == _recitationModeRecite;
          return _QuestionCard(
            question: question,
            showAnswer: showAnswer,
            primaryColor: tokens.colors.primary,
            tagBg: tokens.colors.tagBg,
            cardLightBg: tokens.colors.cardLightBg,
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

  Widget _buildBottomBar(ExaminationingState state, dynamic tokens) {
    final currentQuestion = state.questions.isNotEmpty
        ? state.questions[state.currentIndex]
        : null;
    final isReciteOnly =
        _isRecitationEnabled && _recitationMode == _recitationModeRecite;

    // 对应小程序 .utils：height 158rpx，padding-top 36rpx padding-bottom 42rpx，图标 34rpx×40rpx
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 18.h, // 36rpx = 18.h
        bottom: 21.h, // 42rpx = 21.h
      ),
      child: Row(
        children: [
          if (!isReciteOnly) ...[
            _buildBottomButton(
              label: '答题卡',
              iconUrl: _kAnswerCardIconUrl,
              onTap: () {
                setState(() => _showAnswerSheet = true);
              },
            ),
            SizedBox(width: 12.w),
            _buildBottomButton(
              label: currentQuestion?.doubt == true ? '已标疑' : '标疑',
              iconUrl: _kDoubtIconUrl,
              iconActiveUrl: _kDoubtActiveIconUrl,
              isActive: currentQuestion?.doubt ?? false,
              onTap: () {
                ref.read(examinationingNotifierProvider.notifier).toggleDoubt();
              },
            ),
          ],
          const Spacer(),
          _buildNavButton(tokens.colors.primary, '上一题', false, () {
            ref
                .read(examinationingNotifierProvider.notifier)
                .previousQuestion();
          }),
          SizedBox(width: 12.w),
          _buildNavButton(tokens.colors.primary, '下一题', true, () {
            ref.read(examinationingNotifierProvider.notifier).nextQuestion();
          }),
        ],
      ),
    );
  }

  Widget _buildBottomButton({
    required String label,
    String? iconUrl,
    String? iconActiveUrl,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    final url = (isActive && iconActiveUrl != null && iconActiveUrl.isNotEmpty)
        ? iconActiveUrl
        : (iconUrl ?? '');
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (url.isNotEmpty)
            SizedBox(
              width: 17.w, // 小程序 34rpx = 17.w
              height: 20.h, // 小程序 40rpx = 20.h
              child: Image.network(
                url,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.grid_view,
                  size: 20.sp,
                  color: isActive
                      ? const Color(0xFFFB9E0C)
                      : const Color(0xFF666666),
                ),
              ),
            )
          else
            Icon(
              Icons.grid_view,
              size: 20.sp,
              color: isActive
                  ? const Color(0xFFFB9E0C)
                  : const Color(0xFF666666),
            ),
            SizedBox(height: 7.h), // 小程序 image margin-bottom 14rpx = 7.h
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp, // 24rpx = 12.sp，小程序 color rgba(41,65,90,0.75)
                color: isActive
                    ? const Color(0xFFFB9E0C)
                    : const Color(0xFF29415A).withOpacity(0.75),
              ),
            ),
        ],
      ),
    );
  }

  /// 上一题/下一题（对应小程序 .btn 192rpx×80rpx、40rpx 圆角、26rpx；上一题描边、下一题实心）
  Widget _buildNavButton(
      Color primaryColor, String label, bool isPrimary, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r), // 40rpx = 20.r
      child: Container(
        width: 96.w, // 192rpx = 96.w
        height: 40.h, // 80rpx = 40.h
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: primaryColor, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp, // 26rpx = 13.sp
            color: isPrimary ? Colors.white : primaryColor,
            fontWeight: FontWeight.w400,
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
  Widget _buildAnswerSheet(dynamic tokens) {
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
            Expanded(child: _buildAnswerSheetGrid(tokens)),
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

  Widget _buildAnswerSheetGrid(dynamic tokens) {
    final state = ref.watch(examinationingNotifierProvider);

    return Column(
      children: [
        // ✅ 图例说明（对应小程序 answer-sheet.vue Line 3-16）
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend(tokens.colors.primary, '已做'),
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
                        ? tokens.colors.cardLightBg
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
                          ? tokens.colors.primary
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

  void _showSubmitDialog() {
    final state = ref.read(examinationingNotifierProvider);
    final tokens = ref.read(appStyleTokensProvider);
    final unansweredCount = state.questions
        .where((q) => q.userOption == null || q.userOption!.isEmpty)
        .length;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
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
              // ✅ 剩余考试时间（主题色文字）
              Text(
                '剩余考试时间：${_formatTime(state.remainingTime)}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: tokens.colors.primary,
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
                      onPressed: () => Navigator.pop(dialogContext),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tokens.colors.primary,
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
                        Navigator.pop(dialogContext);
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
    final tokens = ref.read(appStyleTokensProvider);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
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
                  color: tokens.colors.primary,
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
                        Navigator.pop(dialogContext);
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tokens.colors.primary,
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
                        Navigator.pop(dialogContext);
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

/// 题目卡片（背题模式 showAnswer 时显示正确答案、名师解析、知识点）
class _QuestionCard extends StatefulWidget {
  final QuestionModel question;
  final bool showAnswer;
  final Color primaryColor;
  final Color tagBg;
  final Color cardLightBg;
  final Function(List<String>) onAnswerChanged;

  const _QuestionCard({
    required this.question,
    this.showAnswer = false,
    required this.primaryColor,
    required this.tagBg,
    required this.cardLightBg,
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
    _selectedAnswer = widget.question.userOption ?? '';
    if (widget.question.type == '2' && _selectedAnswer.isNotEmpty) {
      _multipleAnswers.addAll(_selectedAnswer.split(','));
    }
  }

  static List<String> _parseCorrectAnswerLetters(String? answerJson) {
    if (answerJson == null || answerJson.isEmpty) return [];
    try {
      final list = jsonDecode(answerJson) as List<dynamic>?;
      if (list == null) return [];
      const letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
      return list
          .map((e) => SafeTypeConverter.toInt(e, defaultValue: -1))
          .where((i) => i >= 0 && i < letters.length)
          .map((i) => letters[i])
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSingleChoice = widget.question.type == '1';
    final firstStem = widget.question.stemList.isNotEmpty
        ? widget.question.stemList.first
        : null;
    final correctLetters = widget.showAnswer && firstStem != null
        ? _parseCorrectAnswerLetters(firstStem.answer)
        : <String>[];

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
            ..._buildOptions(isSingleChoice, correctLetters,
                primaryColor: widget.primaryColor,
                tagBg: widget.tagBg,
                cardLightBg: widget.cardLightBg),
            if (widget.showAnswer) ...[
              SizedBox(height: 16.h),
              _buildRecitationAnswerSection(correctLetters),
              if (widget.question.parse != null &&
                  widget.question.parse!.isNotEmpty) ...[
                SizedBox(height: 24.h),
                _buildRecitationAnalysisSection(),
              ],
              SizedBox(height: 24.h),
              _buildRecitationKnowledgeSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecitationAnswerSection(List<String> correctLetters) {
    final text =
        correctLetters.isEmpty ? '—' : correctLetters.join(',');
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          Text(
            '正确答案',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: AppTextStyles.bodyLarge.copyWith(
              color: widget.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecitationAnalysisSection() {
    final parse = widget.question.parse ?? '';
    final content = parse.isEmpty ? '暂无解析' : parse;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: widget.primaryColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '名师解析',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: widget.primaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Html(
          data: content,
          style: {
            'body': Style(
              margin: Margins.zero,
              padding: HtmlPaddings.zero,
              fontSize: FontSize(14.sp),
              color: AppColors.textSecondary,
              lineHeight: const LineHeight(1.6),
            ),
            'p': Style(margin: Margins.zero, padding: HtmlPaddings.zero),
          },
        ),
      ],
    );
  }

  Widget _buildRecitationKnowledgeSection() {
    final points = widget.question.knowledgeIdsName ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: widget.primaryColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '知识点',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: widget.primaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 11.h),
        Text(
          points.isEmpty ? '暂无相关知识点' : points.join('  '),
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF333333),
            height: 1.54,
          ),
        ),
      ],
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
        color: widget.primaryColor,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  List<Widget> _buildOptions(bool isSingleChoice, List<String> correctLetters,
      {required Color primaryColor,
      required Color tagBg,
      required Color cardLightBg}) {
    final firstStem = widget.question.stemList.isNotEmpty
        ? widget.question.stemList.first
        : null;
    if (firstStem == null || firstStem.option == null) {
      return [];
    }

    final List<dynamic> options = [];
    try {
      options.addAll(jsonDecode(firstStem.option!) as List);
    } catch (e) {
      return [];
    }

    const selectList = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];

    return options.asMap().entries.map((entry) {
      final index = entry.key;
      final optionContent = entry.value as String;
      final key = selectList[index];
      final isSelected = isSingleChoice
          ? _selectedAnswer == key
          : _multipleAnswers.contains(key);
      final isCorrectAnswer =
          widget.showAnswer && correctLetters.contains(key);

      return GestureDetector(
        onTap: () => _handleOptionTap(key, isSingleChoice),
        child: Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          decoration: BoxDecoration(
            color: isCorrectAnswer
                ? cardLightBg
                : isSelected
                    ? primaryColor.withValues(alpha: 0.18)
                    : Colors.white,
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(
              color: isCorrectAnswer
                  ? primaryColor
                  : isSelected
                      ? primaryColor
                      : const Color(0xFFECECEC),
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
        final indexedAnswer =
            _multipleAnswers
                .map((letter) => _convertLetterToIndex(letter))
                .toList()
              ..sort();
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
