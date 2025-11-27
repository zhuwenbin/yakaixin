import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yakaixin_app/app/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
// import 已移除 - 现在使用API调用，MockInterceptor会自动处理Mock数据

/// 考试页面 - 对应小程序 test/exam.vue
/// 功能：显示考试商品详情及试卷列表
class ExamPage extends ConsumerStatefulWidget {
  final String goodsId;
  final String professionalId;
  final String? recitationQuestionModel; // 是否开启背题 1开启 2关闭

  const ExamPage({
    super.key,
    required this.goodsId,
    required this.professionalId,
    this.recitationQuestionModel = '2',
  });

  @override
  ConsumerState<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends ConsumerState<ExamPage> {
  // 从 Mock数据文件获取数据
  // ⚠️ 以下 Mock 数据引用已废弃，需要改为通过 API 调用获取
  // TODO: 使用 Dio 调用 API，MockInterceptor 会自动返回 Mock 数据
  Map<String, dynamic> get _mockInfo => {}; // MockExamData.examInfo;
  List<Map<String, dynamic>> get _mockPaperList => []; // MockExamData.examList;
  
  // TODO: 章节试卷列表，等待Mock数据完善
  List<Map<String, dynamic>> get _mockChapterPaperList => [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('考试'),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildInfoSection(),
          if (_mockInfo['data_type'] == '3') ..._buildChapterPaperList(),
          if (_mockInfo['data_type'] == '1') ..._buildPaperList(),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  /// 商品信息部分
  Widget _buildInfoSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_mockInfo['material_intro_path'] != null &&
              _mockInfo['material_intro_path'].toString().isNotEmpty)
            _buildCoverImage(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                SizedBox(height: 12.h),
                _buildTags(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverImage() {
    return Container(
      width: 50.w,
      height: 50.w,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Image.network(
        _mockInfo['material_intro_path'],
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.image, size: 24.sp, color: Colors.grey);
        },
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      _mockInfo['name'] ?? '',
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF262629),
      ),
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 6.w,
      runSpacing: 8.h,
      children: [
        _buildTag(_mockInfo['num_text'] ?? '', isHighlight: true),
        _buildTag(_mockInfo['year'] ?? ''),
        _buildTag(
            '共${_mockInfo['tiku_goods_details']['question_num'] ?? 0}题'),
      ],
    );
  }

  Widget _buildTag(String text, {bool isHighlight = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isHighlight ? const Color(0xFFEBF1FF) : const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(2.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          color: isHighlight
              ? const Color(0xFF2E68FF)
              : const Color(0xFF2C373D).withOpacity(0.71),
        ),
      ),
    );
  }

  /// 章节试卷列表
  List<Widget> _buildChapterPaperList() {
    return _mockChapterPaperList.map((chapter) {
      return _ChapterPaperSection(
        chapter: chapter,
        onItemTap: _handlePaperTap,
      );
    }).toList();
  }

  /// 普通试卷列表
  List<Widget> _buildPaperList() {
    return _mockPaperList.map((paper) {
      return _PaperListItem(
        paper: paper,
        onTap: () => _handlePaperTap(paper, null),
      );
    }).toList();
  }

  /// 处理试卷点击
  void _handlePaperTap(Map<String, dynamic> paper, Map<String, dynamic>? chapter) {
    final isStarted = paper['paper_exercise_id'] != '0';

    if (isStarted) {
      // 查看报告
      context.push(
        AppRoutes.examScoreReport,
        extra: {
          'professional_id': _mockInfo['professional_id'],
          'paper_version_id': paper['id'],
          'order_id': _mockInfo['permission_order_id'],
          'goods_id': _mockInfo['id'],
          'title': paper['name'],
          'recitation_question_model': widget.recitationQuestionModel,
        },
      );
    } else {
      // 开始考试
      context.push(
        AppRoutes.examinationing,
        extra: {
          'paper_version_id': paper['id'],
          'goods_id': widget.goodsId,
          'order_id': _mockInfo['permission_order_id'],
          'sub_order_id': 'ddd',
          'title': paper['name'],
          'professional_id': _mockInfo['professional_id'],
          'type': '8',
          'time': '${3600 * 2}',
          'recitation_question_model': widget.recitationQuestionModel,
        },
      );
    }
  }
}

/// 章节试卷分组
class _ChapterPaperSection extends StatelessWidget {
  final Map<String, dynamic> chapter;
  final Function(Map<String, dynamic>, Map<String, dynamic>) onItemTap;

  const _ChapterPaperSection({
    required this.chapter,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFECF3FF),
            Color(0xFFFAFCFF),
            Colors.white,
          ],
          stops: [0.0, 0.43, 1.0],
        ),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildPaperList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          chapter['name'] ?? '',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF262629),
          ),
        ),
      ),
    );
  }

  Widget _buildPaperList() {
    final papers = chapter['list'] as List<dynamic>? ?? [];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: papers.asMap().entries.map((entry) {
          final index = entry.key;
          final paper = entry.value as Map<String, dynamic>;
          final isLast = index == papers.length - 1;

          return _ChapterPaperItem(
            paper: paper,
            index: index,
            showDivider: !isLast,
            onTap: () => onItemTap(paper, chapter),
          );
        }).toList(),
      ),
    );
  }
}

/// 章节试卷项
class _ChapterPaperItem extends StatelessWidget {
  final Map<String, dynamic> paper;
  final int index;
  final bool showDivider;
  final VoidCallback onTap;

  const _ChapterPaperItem({
    required this.paper,
    required this.index,
    required this.showDivider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isStarted = paper['paper_exercise_id'] != '0';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 59.h,
        margin: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          border: showDivider
              ? Border(
                  bottom: BorderSide(
                    color: const Color(0xFFE8E9EA),
                    width: 1,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            _buildIndexNumber(),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                paper['name'] ?? '',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF262629),
                ),
              ),
            ),
            _buildActionButton(isStarted),
          ],
        ),
      ),
    );
  }

  Widget _buildIndexNumber() {
    return SizedBox(
      width: 32.w,
      child: Stack(
        children: [
          Text(
            '0${index + 1}',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF424B57),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 22.w,
              height: 7.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color(0xFFFFC31E).withOpacity(0),
                    const Color(0xFFFF900D),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(bool isStarted) {
    return Container(
      width: 80.w,
      height: 28.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF2E68FF),
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Text(
        isStarted ? '查看报告' : '开始考试',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// 普通试卷项
class _PaperListItem extends StatelessWidget {
  final Map<String, dynamic> paper;
  final VoidCallback onTap;

  const _PaperListItem({
    required this.paper,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isStarted = paper['paper_exercise_id'] != '0';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1B2637).withOpacity(0.06),
              blurRadius: 15.r,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                paper['name'] ?? '',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF262629),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              width: 80.w,
              height: 28.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF2E68FF),
                borderRadius: BorderRadius.circular(32.r),
              ),
              child: Text(
                isStarted ? '查看报告' : '开始考试',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
