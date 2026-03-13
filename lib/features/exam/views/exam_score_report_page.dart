import 'dart:convert'; // ✅ 用于json.decode
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:yakaixin_app/app/routes/app_routes.dart';
import 'package:yakaixin_app/core/network/dio_client.dart';
import 'package:yakaixin_app/features/exam/widgets/rank_header.dart'; // ✅ 导入排行榜组件
import 'package:yakaixin_app/features/auth/providers/auth_provider.dart'; // ✅ 获取用户信息
import '../../../../app/config/api_config.dart';
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
  /// 测评（课前测/课后测）成绩报告需传，对应小程序 answerResult getScorereporting
  final String? systemId;

  const ExamScoreReportPage({
    super.key,
    required this.paperVersionId,
    required this.orderId,
    required this.goodsId,
    required this.title,
    required this.professionalId,
    this.recitationQuestionModel,
    this.systemId,
  });

  @override
  ConsumerState<ExamScoreReportPage> createState() =>
      _ExamScoreReportPageState();
}

class _ExamScoreReportPageState extends ConsumerState<ExamScoreReportPage> {
  // ✅ 成绩数据
  Map<String, dynamic> _reportData = {};
  bool _isLoading = true;
  String? _errorMessage;

  // ✅ 排行榜数据
  List<Map<String, dynamic>> _rankData = [];
  int _allRank = 0;

  @override
  void initState() {
    super.initState();
    _loadScoreReport();
    _loadRankData(); // ✅ 加载排行榜数据
  }

  /// 获取用户昵称 - 对应小程序 Line 256-260
  String _getStudentName() {
    final user = ref.watch(currentUserProvider);
    if (user == null) return '用户';
    // ✅ 优先使用昵称，其次使用学生姓名
    return user.nickname?.isNotEmpty == true
        ? user.nickname!
        : (user.studentName ?? '用户');
  }

  /// 加载成绩报告数据
  /// 对应小程序: examScoreReporting.vue Line 210-236
  /// API: chapter.js Line 28-34 (GET /c/tiku/servicehall/scorereporting)
  Future<void> _loadScoreReport() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dio = ref.read(dioClientProvider);

      // ✅ 调用成绩报告接口
      // 对应小程序: scorereporting(data) Line 216
      // ⚠️ 注意：使用 GET 请求，参数在 queryParameters 中
      final queryParams = <String, String>{
        'paper_version_id': widget.paperVersionId,
        'master_order_id': widget.orderId,
        'goods_id': widget.goodsId,
      };
      if (widget.systemId != null && widget.systemId!.isNotEmpty) {
        queryParams['teaching_system_relation_id'] = widget.systemId!;
      }
      final response = await dio.get(
        '/c/tiku/servicehall/scorereporting',
        queryParameters: queryParams,
      );

      if (response.data['code'] == 100000) {
        setState(() {
          _reportData = response.data['data'] ?? {};
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.data['msg']?.first ?? '加载成绩报告失败';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '加载失败: $e';
        _isLoading = false;
      });
    }
  }

  /// 加载排行榜数据
  /// 对应小程序: examScoreReporting.vue Line 168-184
  /// API: index.js Line 201-207 (GET /c/tiku/paper/ranking)
  Future<void> _loadRankData() async {
    try {
      final dio = ref.read(dioClientProvider);

      final response = await dio.get(
        '/c/tiku/paper/ranking', // ✅ 修正: 小程序使用 /c/tiku/paper/ranking 而不是 /c/exam/ranking
        queryParameters: {
          'page': 1,
          'size': 3,
          'paper_version_id': widget.paperVersionId,
          'goods_id': widget.goodsId,
        },
      );

      if (response.data['code'] == 100000) {
        final data = response.data['data'];
        setState(() {
          _rankData = ((data['list'] ?? []) as List)
              .cast<Map<String, dynamic>>();
          _allRank = _toInt(data['total']);
        });
      }
    } catch (e) {
      // 排行榜加载失败不影响主内容
      print('加载排行榜失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // ✅ 页面背景色
      body: Stack(
        children: [
          _buildGradientBackground(),
          // ✅ 根据加载状态显示不同内容
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_errorMessage != null)
            _buildError()
          else
            _buildContent(),

          // ✅ 底部固定按钮 - 对应小程序 Line 103
          if (!_isLoading && _errorMessage == null) _buildReanswerButton(),
        ],
      ),
    );
  }

  /// 错误状态
  Widget _buildError() {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage ?? '加载失败',
              style: TextStyle(fontSize: 14.sp, color: Colors.red),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _loadScoreReport,
              child: const Text('重新加载'),
            ),
          ],
        ),
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
            colors: [Color(0xFF2F69FF), Color(0xFF2F69FF), Colors.white],
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
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              child: Column(
                children: [
                  // 排行榜 - 对应小程序 Line 12
                  RankHeader(
                    rankData: _rankData,
                    showRankButton: true,
                    onRankButtonTap: _goRankList,
                  ),

                  // 成绩卡片 - 对应小程序 Line 13-36
                  // ✅ 使用负margin向上偏移,压在排行榜上
                  Transform.translate(
                    offset: Offset(0, -5.h),
                    child: _buildScoreCard(),
                  ),

                  // 后续内容向上收紧
                  Transform.translate(
                    offset: Offset(0, -30.h),
                    child: Column(
                      children: [
                        SizedBox(height: 16.h),

                        // 成绩明细 - 对应小程序 Line 37-65
                        _buildDetailCard(),
                        SizedBox(height: 16.h),

                        // 答题详情 - 对应小程序 Line 66-70
                        _buildAnswerDetails(),
                        SizedBox(height: 16.h),

                        // 失分试题 - 对应小程序 Line 71-99
                        _buildLostPointsTable(),

                        // 底部提示 - 对应小程序 Line 100
                        _buildFooter(),
                        SizedBox(height: 120.h), // 留出底部按钮空间
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    // ✅ 获取用户昵称 (对应小程序 Line 7, 256-260)
    final studentName = _getStudentName();

    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          // 返回按钮 - 对应小程序 Line 5
          GestureDetector(
            onTap: () => context.pop(),
            child: Icon(Icons.arrow_back_ios, size: 20.sp, color: Colors.white),
          ),
          Expanded(
            child: Center(
              child: Text(
                '$studentName的成绩报告',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // 右侧占位,保持标题居中
          SizedBox(width: 20.sp),
        ],
      ),
    );
  }

  /// 成绩卡片 - 对应小程序 Line 13-36
  Widget _buildScoreCard() {
    final sessionScore = _reportData['session_score'] ?? {};

    // ✅ 使用安全类型转换（遵循 data_type_safety.md）
    final isPassed = _toInt(sessionScore['is_pass']) == 1;
    final time = _toInt(sessionScore['kaoshi_time']);
    final rank = _toSafeString(sessionScore['rank']);
    final score = _toSafeString(sessionScore['score']);

    // ✅ 对应小程序 Line 13-36: .evaluate 容器使用 Stack 布局,分数徽章绝对定位
    // 预留右侧空间，避免「时间」「全部院校排」被分数徽章遮挡
    final double rightPadding = 87.5.w + 17.w; // 与右上角分数徽章宽度+right一致

    return Container(
      padding: EdgeInsets.all(10.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(right: rightPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 对应小程序 Line 14: title_text
                Text(
                  '你的综合实力',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF787E8F),
                  ),
                ),
                SizedBox(height: 10.h),

                // 对应小程序 Line 15-18: .evaluate_text 半遮盖背景
                // 小程序: background-image: linear-gradient(to top, #2e68ff 35%, white 35%); 即底部 35% 蓝色、上方白色
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: const [Color(0xFF2E68FF), Colors.white],
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

                // 对应小程序 Line 19-30: bottom-text (时间和排名) - 预留右侧空间后不再被徽章遮挡
                _buildTimeAndRank(time, rank, _allRank),
                SizedBox(height: 8.h),

                // 对应小程序 Line 31: session (考试场次)
                Text(
                  _toSafeString(sessionScore['examination_round']),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF161F30),
                  ),
                ),
              ],
            ),
          ),

          // ✅ 右上角分数徽章 - 对应小程序 Line 396-419
          // position: absolute; top: 30rpx; right: 34rpx;
          Positioned(
            top: 15.h, // 30rpx → 15.h
            right: 17.w, // 34rpx → 17.w
            child: _buildScoreBadge(score),
          ),
        ],
      ),
    );
  }

  /// 安全转换为 int
  int _toInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }

  /// 安全转换为 String
  String _toSafeString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    if (value is String) return value;
    return value.toString();
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

  /// 分数徽章组件 - 对应小程序 Line 396-419
  Widget _buildScoreBadge(String score) {
    // ✅ 小程序尺寸: width: 175rpx; height: 140rpx;
    // 转换: 175 / 2 = 87.5.w, 140 / 2 = 70.h
    return Container(
      width: 87.5.w, // 175rpx → 87.5.w
      height: 70.h, // 140rpx → 70.h
      decoration: BoxDecoration(
        image: DecorationImage(
          // ✅ 使用小程序完整图片URL
          image: NetworkImage(
            'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/16967627423535267169676274235372918_%E7%BC%96%E7%BB%84%2014%E5%A4%87%E4%BB%BD%202%402x.png',
          ),
          fit: BoxFit.fill, // ✅ 使用fill确保图片填充容器
        ),
      ),
      // ✅ 小程序: .grade_number 使用 margin-top: 40rpx 和 text-align: center
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20.h), // margin-top: 40rpx → 20.h
          Text(
            score,
            textAlign: TextAlign.center, // text-align: center
            style: TextStyle(
              fontSize: 15.sp, // 30rpx → 15.sp
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2E68FF),
            ),
          ),
        ],
      ),
    );
  }

  /// 成绩明细卡片
  Widget _buildDetailCard() {
    final sessionScore = _reportData['session_score'] ?? {};

    return Container(
      // margin: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 0),
      width: double.infinity,
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

  /// 成绩明细 - 与小程序 examScoreReporting.vue getScore 一致
  /// 得分 = 客观题分 + (is_correct==1 时主观题分)；0 显示 "-分"
  /// 试卷满分/及格分：空值显示 "-分"
  Widget _buildDetailGrid(Map<String, dynamic> sessionScore) {
    double score = 0;
    final objective =
        double.tryParse(
          sessionScore['objective_item_score']?.toString() ?? '0',
        ) ??
        0;
    score += objective;
    if (_toInt(sessionScore['is_correct']) == 1) {
      final subjective =
          double.tryParse(
            sessionScore['subjective_item_score']?.toString() ?? '0',
          ) ??
          0;
      score += subjective;
    }
    final scoreStr = score == 0 ? '-分' : '${score.toStringAsFixed(0)}分';
    final fullMark = sessionScore['full_mark_score']?.toString();
    final passing = sessionScore['passing_score']?.toString();
    final fullMarkStr = (fullMark == null || fullMark.isEmpty)
        ? '-分'
        : '${fullMark}分';
    final passingStr = (passing == null || passing.isEmpty)
        ? '-分'
        : '${passing}分';

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8FF),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDetailItem('得分', scoreStr),
          _buildDetailItem('试卷满分', fullMarkStr),
          _buildDetailItem('及格分', passingStr),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13.sp, color: const Color(0xFF787E8F)),
        ),
        SizedBox(height: 10.h),
        Text(
          value,
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF2E68FF)),
        ),
      ],
    );
  }

  /// 答题详情 - 对应小程序 Line 66-70, answer-particulars.vue
  Widget _buildAnswerDetails() {
    final details = (_reportData['answer_question_details'] ?? []) as List;
    final isCorrect = _reportData['session_score']?['is_correct'];

    if (details.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      width: double.infinity,
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
          // ✅ 对应小程序 answer-particulars.vue Line 3-30
          // 遍历每种题型,显示标题和每道题的详细内容
          ...details.asMap().entries.map((entry) {
            final index = entry.key;
            final detail = entry.value;
            return _buildQuestionTypeSection(index, detail, isCorrect);
          }).toList(),
        ],
      ),
    );
  }

  /// 题型章节 - 对应小程序 answer-particulars.vue Line 5-17
  Widget _buildQuestionTypeSection(
    int index,
    Map<String, dynamic> detail,
    dynamic isCorrect,
  ) {
    final questionTypeName = _toSafeString(detail['question_type_name']);
    final questionType = _toSafeString(detail['question_type']);
    final questionNum = _toInt(detail['question_num']);
    final sumScore = _toSafeString(detail['sum_score']);
    final questionList = (detail['question_list'] ?? []) as List;

    // ✅ 题型标题: "一、单选题(共10题),共20分"
    // 对应小程序 Line 5-17: formatNumber + question_type_name + question_num + sum_score
    final chineseNumber = _formatChineseNumber(index + 1);
    final typeSuffix =
        (questionType != '8' &&
            questionType != '9' &&
            questionType != '10' &&
            questionType != '11')
        ? '题'
        : '';
    final headline =
        '$chineseNumber、$questionTypeName$typeSuffix(共${questionNum}题),共${sumScore}分';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ 对应小程序 Line 5: .headline
        Padding(
          padding: EdgeInsets.only(top: 22.h),
          child: Text(
            headline,
            style: TextStyle(
              fontSize: 14.sp, // 28rpx → 14.sp
              color: const Color(0xFF161F30),
            ),
          ),
        ),
        // ✅ 对应小程序 Line 18-29: 每道题的详细内容
        ...questionList.asMap().entries.map((entry) {
          final questionIndex = entry.key;
          final question = entry.value;
          return _buildQuestionItem(question, questionIndex, isCorrect);
        }).toList(),
      ],
    );
  }

  /// 单道题目详情 - 对应小程序 question-tmp.vue
  Widget _buildQuestionItem(
    Map<String, dynamic> question,
    int questionIndex,
    dynamic isCorrect,
  ) {
    final sort = _toSafeString(question['sort']);
    final questionType = _toSafeString(question['type']);
    final stemList = (question['stem_list'] ?? []) as List;
    final parse = _toSafeString(question['parse']);
    final knowledgeIdsName = _toSafeString(question['knowledge_ids_name']);
    final level = _toInt(question['level']);

    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEEEEEE)),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ 题目标题 - 对应小程序 Line 11-38
          _buildQuestionTitle(sort, stemList),

          // ✅ 遍历每个小题 - 对应小程序 Line 61-173
          ...stemList.asMap().entries.map((entry) {
            final stemIndex = entry.key;
            final stem = entry.value;
            return _buildStemItem(stem, stemIndex, questionType, isCorrect);
          }).toList(),

          // ✅ 解析 - 对应小程序 Line 175-179
          _buildExplainBox('解析：', parse.isNotEmpty ? parse : '暂无解析'),

          // ✅ 知识点 - 对应小程序 Line 193-201
          _buildExplainBox(
            '知识点：',
            knowledgeIdsName.isNotEmpty ? knowledgeIdsName : '暂无',
          ),

          // ✅ 难易度 - 对应小程序 Line 202-218
          _buildDifficultyLevel(level),
        ],
      ),
    );
  }

  /// 题目标题 - 对应小程序 Line 11-38
  Widget _buildQuestionTitle(String sort, List stemList) {
    if (stemList.isEmpty) return const SizedBox.shrink();

    final firstStem = stemList[0];
    final content = _toSafeString(firstStem['content']);

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$sort、',
            style: TextStyle(
              fontSize: 13.sp, // 26rpx → 13.sp
              color: const Color(0xFF161F30),
            ),
          ),
          Expanded(
            child: Text(
              content.isNotEmpty ? _stripHtmlTags(content) : '本题暂无题目',
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF161F30)),
            ),
          ),
        ],
      ),
    );
  }

  /// 小题项 - 对应小程序 Line 61-173
  Widget _buildStemItem(
    Map<String, dynamic> stem,
    int stemIndex,
    String questionType,
    dynamic isCorrect,
  ) {
    final options = (stem['option'] is String)
        ? _parseJsonList(stem['option'])
        : (stem['option'] ?? []) as List;
    final answer = (stem['answer'] is String)
        ? _parseJsonList(stem['answer'])
        : (stem['answer'] ?? []) as List;
    final subAnswer = (stem['sub_answer'] is String)
        ? _parseJsonList(stem['sub_answer'])
        : (stem['sub_answer'] ?? []) as List;
    final answerStatus = _toInt(stem['answer_status']);
    final getScore = _toSafeString(stem['get_score']);
    final isSubjective = _isSubjective(questionType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ 选项 - 对应小程序 Line 85-90 (客观题)
        if (!isSubjective && options.isNotEmpty) _buildOptions(options),

        // ✅ 主观题作答 - 对应小程序 Line 91-102
        if (isSubjective) _buildSubjectiveAnswer(subAnswer),

        // ✅ 答题状态和得分 - 对应小程序 Line 103-136
        _buildAnswerStatus(answerStatus, getScore, isSubjective, isCorrect),

        // ✅ 答案对比 - 对应小程序 Line 137-173 (客观题)
        if (!isSubjective)
          _buildAnswerComparison(answer, subAnswer, answerStatus, questionType),

        SizedBox(height: 12.h),
      ],
    );
  }

  /// 选项列表 - 对应小程序 Line 85-90
  Widget _buildOptions(List options) {
    const selectList = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];

    return Column(
      children: options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;

        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${selectList[index]}. ',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF161F30),
                ),
              ),
              Expanded(
                child: Text(
                  _stripHtmlTags(option.toString()),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF161F30),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// 主观题作答 - 对应小程序 Line 91-102
  Widget _buildSubjectiveAnswer(List subAnswer) {
    return Container(
      margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '作答：',
            style: TextStyle(fontSize: 13.sp, color: const Color(0xFF161F30)),
          ),
          Expanded(
            child: Text(
              subAnswer.isNotEmpty ? subAnswer.join('') : '未作答',
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF666666)),
            ),
          ),
        ],
      ),
    );
  }

  /// 答题状态和得分 - 对应小程序 Line 103-136
  Widget _buildAnswerStatus(
    int answerStatus,
    String getScore,
    bool isSubjective,
    dynamic isCorrect,
  ) {
    Color statusColor;
    Color scoreColor;
    String statusText;

    // 与小程序 questionTmp.vue .correct/.error/.half 一致
    switch (answerStatus) {
      case 1: // 正确
        statusColor = const Color(0xFF2E68FF);
        scoreColor = const Color(0xFF2E68FF);
        statusText = '正确';
        break;
      case 2: // 错误
        statusColor = const Color(0xFFF04F54);
        scoreColor = const Color(0xFFF04F54);
        statusText = '错误';
        break;
      case 3: // 半对
        statusColor = const Color(0xFFF99300);
        scoreColor = const Color(0xFFF99300);
        statusText = '半对';
        break;
      default:
        statusColor = const Color(0xFF999999);
        scoreColor = const Color(0xFF999999);
        statusText = '--';
    }

    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
      child: Row(
        children: [
          // ✅ 答题状态标签 - 参照小程序 questionTmp.vue .is_right_button（实心背景、白字、50×28）
          if (answerStatus != 0)
            Container(
              width: 50.w,
              height: 28.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFFFFFFFF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          SizedBox(width: 12.w),
          // ✅ 得分（标签与分值同色）
          Text(
            '得分：',
            style: TextStyle(fontSize: 13.sp, color: scoreColor),
          ),
          Text(
            _getScoreText(isSubjective, isCorrect, getScore),
            style: TextStyle(fontSize: 13.sp, color: scoreColor),
          ),
        ],
      ),
    );
  }

  /// 获取得分文本
  String _getScoreText(bool isSubjective, dynamic isCorrect, String getScore) {
    if (!isSubjective) {
      return '${getScore}分';
    } else if (isCorrect == 1) {
      return '${getScore}分';
    } else {
      return '待阅卷';
    }
  }

  /// 答案对比 - 对应小程序 Line 137-173
  Widget _buildAnswerComparison(
    List answer,
    List subAnswer,
    int answerStatus,
    String questionType,
  ) {
    const selectList = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];

    // 转换答案为字母
    final answerNames = answer.map((a) {
      final index = int.tryParse(a.toString()) ?? 0;
      return index < selectList.length ? selectList[index] : a.toString();
    }).toList();

    final subAnswerNames = subAnswer.map((a) {
      final index = int.tryParse(a.toString()) ?? 0;
      return index < selectList.length ? selectList[index] : a.toString();
    }).toList();

    // ✅ 正确答案、您的答案 一行显示
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (answerStatus != 1) ...[
          Text(
            '正确答案：',
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF3068FB),
            ),
          ),
          Text(
            answerNames.join('、'),
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF3068FB),
            ),
          ),
          SizedBox(width: 16.w),
        ],
        Text(
          '您的答案：',
          style: TextStyle(fontSize: 13.sp, color: const Color(0xFF000000)),
        ),
        Flexible(
          child: Text(
            subAnswerNames.isNotEmpty ? subAnswerNames.join('、') : '未作答',
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF000000),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// 解析框 - 对应小程序 Line 175-201
  Widget _buildExplainBox(String label, String content) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF161F30),
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              _stripHtmlTags(content),
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF666666)),
            ),
          ),
        ],
      ),
    );
  }

  /// 难易度 - 对应小程序 Line 202-218
  Widget _buildDifficultyLevel(int level) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Row(
        children: [
          Text(
            '难易度：',
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF161F30),
              fontWeight: FontWeight.w500,
            ),
          ),
          ...List.generate(5, (index) {
            final isFilled = index < level;
            return Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: Icon(
                Icons.star,
                size: 16.sp,
                color: isFilled
                    ? const Color(0xFFFAAD14)
                    : const Color(0xFFE0E0E0),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// 判断是否为主观题 - 对应小程序 utils/index.js isSubjective
  bool _isSubjective(String type) {
    return type == '8' || type == '10' || type == '14';
  }

  /// 去除HTML标签
  String _stripHtmlTags(String htmlString) {
    if (htmlString.isEmpty) return htmlString;

    return htmlString
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .trim();
  }

  /// 安全解析JSON列表
  List _parseJsonList(dynamic value) {
    if (value == null) return [];
    if (value is List) return value;
    if (value is String) {
      try {
        final parsed = json.decode(value);
        return parsed is List ? parsed : [];
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  /// 格式化中文数字 - 对应小程序 answer-particulars.vue Line 53-78
  String _formatChineseNumber(int num) {
    const chineseNumbers = [
      '零',
      '一',
      '二',
      '三',
      '四',
      '五',
      '六',
      '七',
      '八',
      '九',
      '十',
    ];

    if (num <= 10) {
      return chineseNumbers[num];
    } else if (num > 10 && num < 100) {
      final unit = num % 10;
      final decade = num ~/ 10;
      return '${chineseNumbers[decade]}十${unit == 0 ? '' : chineseNumbers[unit]}';
    }
    return num.toString();
  }

  /// 失分题目表格 - 对应小程序 Line 71-99
  Widget _buildLostPointsTable() {
    final lostPoints = (_reportData['lose_points_question'] ?? []) as List;

    // ✅ 判断是否显示失分题目（只显示客观题）
    final details = (_reportData['answer_question_details'] ?? []) as List;
    bool hasObjectiveQuestions = false;
    for (var detail in details) {
      final questionType = _toSafeString(detail['question_type']);
      // 非主观题（不是 8, 10, 14）
      if (questionType != '8' && questionType != '10' && questionType != '14') {
        hasObjectiveQuestions = true;
        break;
      }
    }

    if (!hasObjectiveQuestions) {
      return const SizedBox.shrink();
    }

    return Container(
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

          // 对应小程序 Line 74-98
          if (lostPoints.isNotEmpty)
            _buildTable(lostPoints)
          else
            // 无失分题目时显示图片
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 11.h),
                child: Image.network(
                  ApiConfig.completeImageUrl(
                    'public/datatpls/%E7%BC%96%E7%BB%84%2010%402x.png',
                  ),
                  width: 192.w,
                  height: 22.h,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
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
        border: Border(bottom: BorderSide(color: Color(0xFFD7E5FE))),
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
        border: Border(bottom: BorderSide(color: Color(0xFFD7E5FE))),
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
          style: TextStyle(fontSize: 13.sp, color: const Color(0xFF161F30)),
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
        style: TextStyle(fontSize: 12.sp, color: const Color(0xFFCCCCCC)),
      ),
    );
  }

  /// 重新答题按钮 - 对应小程序 Line 538-554
  Widget _buildReanswerButton() {
    return Positioned(
      bottom: 20.h,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: _reanswer,
          child: Container(
            width: 225.w, // 对应小程序 60% 屏幕宽度
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
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _reanswer() {
    // ✅ 对应小程序: examScoreReporting.vue Line 237-246
    // 重新答题，跳转到答题页面
    // ✅ 路由跳转逻辑:
    // 1. 点击试卷 → 开始考试 → 跳转到答题页 (examinationing)
    // 2. 答题页 → 交卷 → 跳转到成绩报告页 (examScoreReport)
    // 3. 成绩报告页 → 重新答题 → 使用 pushReplacement 替换为答题页
    // 4. 答题页 → 再次交卷 → 使用 pushReplacement 替换为成绩报告页

    print('\n🔄 [重新答题]');
    print('  → 使用 pushReplacement 跳转到答题页');

    context.pushReplacement(
      AppRoutes.examinationing,
      extra: {
        'paper_version_id': widget.paperVersionId,
        'goods_id': widget.goodsId,
        'order_id': widget.orderId,
        'title': widget.title,
        'professional_id': widget.professionalId,
        'type': '8', // ✅ 试卷类型
        'time_limit': 3600 * 2, // ✅ 2小时
        'recitation_question_model': widget.recitationQuestionModel,
      },
    );
  }

  /// 跳转到排行榜页面 - 对应小程序 Line 164-167
  void _goRankList() {
    context.push(
      AppRoutes.rankList,
      extra: {
        'paper_version_id': widget.paperVersionId,
        'goods_id': widget.goodsId,
      },
    );
  }
}
