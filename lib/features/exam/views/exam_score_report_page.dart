import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:yakaixin_app/app/routes/app_routes.dart';
// import 已移除 - 现在使用API调用，MockInterceptor会自动处理Mock数据

/// 考试成绩报告页面 - 对应小程序 test/examScoreReporting.vue
/// 功能：显示考试成绩、答题详情、失分题目
class ExamScoreReportPage extends ConsumerStatefulWidget {
  final String paperVersionId;
  final String orderId;
  final String goodsId;
  final String title;
  final String professionalId;
  final String? recitationQuestionModel;

  const ExamScoreReportPage({
    super.key,
    required this.paperVersionId,
    required this.orderId,
    required this.goodsId,
    required this.title,
    required this.professionalId,
    this.recitationQuestionModel,
  });

  @override
  ConsumerState<ExamScoreReportPage> createState() => _ExamScoreReportPageState();
}

class _ExamScoreReportPageState extends ConsumerState<ExamScoreReportPage> {
  // 从 Mock数据文件获取数据
  // ⚠️ 以下 Mock 数据引用已废弃，需要改为通过 API 调用获取
  // TODO: 使用 Dio 调用 API，MockInterceptor 会自动返回 Mock 数据
  Map<String, dynamic> get _mockData => {}; // MockExamData.examReport;

  String _studentName = '张三';
  int _allRank = 500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildGradientBackground(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildGradientBackground() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 275.h,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2F69FF),
              Color(0xFF2F69FF),
              Colors.white,
            ],
            stops: [0.0, 0.38, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 16.h),
                  _buildScoreCard(),
                  _buildDetailCard(),
                  _buildAnswerDetails(),
                  _buildLostPointsTable(),
                  _buildFooter(),
                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ),
          _buildReanswerButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Icon(
                Icons.arrow_back_ios,
                size: 20.sp,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            '$_studentName的成绩报告',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// 成绩卡片
  Widget _buildScoreCard() {
    final sessionScore = _mockData['session_score'];
    final isPassed = sessionScore['is_pass'] == 1;
    final time = sessionScore['kaoshi_time'] as int;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '你的综合实力',
            style: TextStyle(
              fontSize: 11.sp,
              color: const Color(0xFF787E8F),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          const Color(0xFF2E68FF).withOpacity(0.3),
                        ],
                        stops: const [0.35, 0.35],
                      ),
                    ),
                    child: Text(
                      isPassed ? '及格' : '不及格',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF161F30),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildTimeAndRank(time, sessionScore['rank'], _allRank),
                  SizedBox(height: 8.h),
                  Text(
                    sessionScore['examination_round'] ?? '',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF161F30),
                    ),
                  ),
                ],
              ),
              _buildScoreBadge(sessionScore['score']),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeAndRank(int seconds, String rank, int allRank) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 10.sp,
          color: Colors.black.withOpacity(0.65),
        ),
        children: [
          if (hours > 0) ...[
            TextSpan(
              text: '$hours',
              style: const TextStyle(
                color: Color(0xFF3068FB),
                fontWeight: FontWeight.w500,
              ),
            ),
            const TextSpan(text: '时'),
          ],
          if (minutes > 0) ...[
            TextSpan(
              text: '$minutes',
              style: const TextStyle(
                color: Color(0xFF3068FB),
                fontWeight: FontWeight.w500,
              ),
            ),
            const TextSpan(text: '分'),
          ],
          TextSpan(
            text: '$secs',
            style: const TextStyle(
              color: Color(0xFF3068FB),
              fontWeight: FontWeight.w500,
            ),
          ),
          const TextSpan(text: '秒  全部院校排'),
          TextSpan(
            text: rank,
            style: const TextStyle(
              color: Color(0xFF3068FB),
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(text: '/$allRank'),
        ],
      ),
    );
  }

  Widget _buildScoreBadge(String score) {
    return Container(
      width: 87.5.w,
      height: 70.h,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: NetworkImage(
            'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/16967627423535267169676274235372918_%E7%BC%96%E7%BB%84%2014%E5%A4%87%E4%BB%BD%202%402x.png',
          ),
          fit: BoxFit.contain,
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Text(
            score,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2E68FF),
            ),
          ),
        ),
      ),
    );
  }

  /// 成绩明细卡片
  Widget _buildDetailCard() {
    final sessionScore = _mockData['session_score'];
    
    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 0),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '成绩明细',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF161F30),
            ),
          ),
          SizedBox(height: 11.h),
          _buildDetailGrid(sessionScore),
        ],
      ),
    );
  }

  Widget _buildDetailGrid(Map<String, dynamic> sessionScore) {
    final score = (double.tryParse(sessionScore['objective_item_score'] ?? '0') ?? 0) +
        (double.tryParse(sessionScore['subjective_item_score'] ?? '0') ?? 0);

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8FF),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDetailItem('得分', '${score.toStringAsFixed(0)}分'),
          _buildDetailItem('试卷满分', '${sessionScore['full_mark_score']}分'),
          _buildDetailItem('及格分', '${sessionScore['passing_score']}分'),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF787E8F),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF2E68FF),
          ),
        ),
      ],
    );
  }

  /// 答题详情
  Widget _buildAnswerDetails() {
    final details = _mockData['answer_question_details'] as List;

    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 0),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '答题详情',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF161F30),
            ),
          ),
          SizedBox(height: 13.h),
          ...details.map((detail) => _AnswerDetailItem(detail: detail)).toList(),
        ],
      ),
    );
  }

  /// 失分题目表格
  Widget _buildLostPointsTable() {
    final lostPoints = _mockData['lose_points_question'] as List;

    if (lostPoints.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 0),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '失分试题',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF161F30),
            ),
          ),
          SizedBox(height: 12.h),
          _buildTable(lostPoints),
        ],
      ),
    );
  }

  Widget _buildTable(List lostPoints) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD7E5FE)),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          ...lostPoints.map((item) => _buildTableRow(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      height: 35.h,
      decoration: const BoxDecoration(
        color: Color(0xFFF1F8FF),
        border: Border(
          bottom: BorderSide(color: Color(0xFFD7E5FE)),
        ),
      ),
      child: Row(
        children: [
          _buildTableCell('题号', flex: 2),
          _buildTableCell('得分', flex: 2),
          _buildTableCell('对应知识点', flex: 3),
        ],
      ),
    );
  }

  Widget _buildTableRow(Map<String, dynamic> item) {
    return Container(
      height: 35.h,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFD7E5FE)),
        ),
      ),
      child: Row(
        children: [
          _buildTableCell(item['sort'] ?? '-', flex: 2),
          _buildTableCell('${item['get_score']}/${item['score']}', flex: 2),
          _buildTableCell(item['knowledge'] ?? '-', flex: 3),
        ],
      ),
    );
  }

  Widget _buildTableCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF161F30),
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Text(
        '没有更多啦~',
        style: TextStyle(
          fontSize: 12.sp,
          color: const Color(0xFFCCCCCC),
        ),
      ),
    );
  }

  /// 重新答题按钮
  Widget _buildReanswerButton() {
    return Container(
      width: double.infinity,
      height: 80.h,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: _reanswer,
        child: Container(
          width: 200.w,
          height: 34.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF2E68FF),
            borderRadius: BorderRadius.circular(22.r),
          ),
          child: Text(
            '重新答题',
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _reanswer() {
    context.pushReplacement(
      AppRoutes.examinationing,
      extra: {
        'paper_version_id': widget.paperVersionId,
        'goods_id': widget.goodsId,
        'order_id': widget.orderId,
        'title': widget.title,
        'professional_id': widget.professionalId,
        'type': '8',
        'time': '${3600 * 2}',
        'recitation_question_model': widget.recitationQuestionModel,
      },
    );
  }
}

/// 答题详情项
class _AnswerDetailItem extends StatelessWidget {
  final Map<String, dynamic> detail;

  const _AnswerDetailItem({required this.detail});

  @override
  Widget build(BuildContext context) {
    final totalCount = detail['total_count'] ?? 0;
    final correctCount = detail['correct_count'] ?? 0;
    final wrongCount = detail['wrong_count'] ?? 0;
    final skipCount = detail['skip_count'] ?? 0;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              detail['question_type'] ?? '',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF262629),
              ),
            ),
          ),
          _buildStatItem('全部', totalCount, const Color(0xFF999999)),
          SizedBox(width: 16.w),
          _buildStatItem('正确', correctCount, const Color(0xFF04C140)),
          SizedBox(width: 16.w),
          _buildStatItem('错误', wrongCount, const Color(0xFFFF4D4F)),
          SizedBox(width: 16.w),
          _buildStatItem('跳过', skipCount, const Color(0xFF999999)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF999999),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
