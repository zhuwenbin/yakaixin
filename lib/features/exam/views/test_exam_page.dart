import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:yakaixin_app/core/theme/app_colors.dart';
import 'package:yakaixin_app/core/utils/safe_type_converter.dart';
import 'package:yakaixin_app/core/widgets/common_state_widget.dart';
import 'package:yakaixin_app/app/routes/app_routes.dart';
import 'package:yakaixin_app/app/config/api_config.dart';
import 'package:yakaixin_app/features/exam/providers/test_exam_provider.dart';
import 'package:yakaixin_app/features/exam/models/paper_model.dart';
import 'package:yakaixin_app/features/home/models/goods_model.dart';

/// P3-6 试卷详情 - 历史试卷/考试页
/// 对应小程序: pages/test/exam.vue
///
/// 参数:
/// - id: 商品ID
/// - professionalId: 专业ID
/// - recitationQuestionModel: 背诵模式 ('1'=开启 '2'=关闭)
class TestExamPage extends ConsumerStatefulWidget {
  final String? id;
  final String? professionalId;
  final dynamic recitationQuestionModel;

  const TestExamPage({
    super.key,
    this.id,
    this.professionalId,
    this.recitationQuestionModel,
  });

  @override
  ConsumerState<TestExamPage> createState() => _TestExamPageState();
}

class _TestExamPageState extends ConsumerState<TestExamPage> {
  @override
  void initState() {
    super.initState();
    // 对应小程序 onShow -> getGoodsDetail Line 104-106
    print('\n👍 TestExamPage initState');
    print('✅ 传入参数:');
    print('  - id: ${widget.id}');
    print('  - professionalId: ${widget.professionalId}');
    print('  - recitationQuestionModel: ${widget.recitationQuestionModel}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.id != null) {
        print('\n🚀 开始加载试卷数据: goodsId=${widget.id}');
        ref
            .read(testExamNotifierProvider.notifier)
            .loadExamData(goodsId: widget.id!);
      } else {
        print('\n⚠️ 错误: widget.id 为 null，无法加载数据');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final examState = ref.watch(testExamNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('试卷详情'), // 
        backgroundColor: AppColors.surface,
        elevation: 0, // 移除阴影
      ),
      backgroundColor: AppColors.background,
      body: _buildBody(examState),
    );
  }

  Widget _buildBody(TestExamState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return _buildError(state.error!);
    }

    if (state.goodsInfo == null) {
      return _buildEmpty();
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // 商品信息头部 (对应小程序 Line 3-21)
        _buildGoodsHeader(state.goodsInfo!),
        // 章节试卷列表 (对应小程序 Line 23-47)
        if (state.chapterPaperList.isNotEmpty)
          ...state.chapterPaperList.map(
            (chapter) => _buildChapterPaperSection(chapter),
          ),
        // 普通试卷列表 (对应小程序 Line 49-56)
        if (state.paperList.isNotEmpty) _buildPaperListSection(state.paperList),
        // 二维码区域 (对应小程序 Line 58)
        _buildQrcodeSection(),
        SizedBox(height: 40.h), // 小程序: 80rpx = 40.h (Line 60)
      ],
    );
  }

  /// 商品信息头部 (对应小程序 Line 3-21)
  Widget _buildGoodsHeader(GoodsModel goods) {
    // ✅ 对应小程序 exam.vue Line 9: completepath(info.material_intro_path)
    // 小程序使用 material_intro_path 作为封面图，并调用 completepath() 拼接完整URL
    String? coverImage = goods.materialIntroPath;
    
    if (coverImage == null || coverImage.isEmpty) {
      coverImage = 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/yakaixinshare.png';
      print('🖼️ [试卷页] 封面路径为空，使用默认图片: $coverImage');
    } else {
      // ✅ 调用 completeImageUrl 拼接完整URL（对应小程序 completepath()）
      final originalPath = coverImage;
      coverImage = ApiConfig.completeImageUrl(coverImage);
      print('🖼️ [试卷页] 封面路径处理后: $originalPath → $coverImage');
    }

    return Container(
      padding: EdgeInsets.all(16.w), // 小程序: 32rpx = 16.w
      color: AppColors.surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 封面图 (对应小程序 Line 4-12)
          // 小程序使用 material_intro_path 作为封面图，并调用 completepath() 拼接完整URL
          Container(
            width: 50.w, // 小程序: 100rpx = 50.w
            margin: EdgeInsets.only(right: 12.w), // 小程序: 24rpx = 12.w
            child: Image.network(
              coverImage,
                fit: BoxFit.fitWidth,
                errorBuilder: (context, error, stackTrace) {
                  print('❌ [试卷页] 封面图片加载失败: $coverImage, error: $error');
                  return Container(
                    width: 50.w,
                    height: 50.w,
                    color: AppColors.card,
                    child: Icon(
                      Icons.image,
                      color: AppColors.textHint,
                      size: 25.sp,
                    ),
                  );
                },
              ),
            ),
          // 商品信息 - 上下结构 (对应小程序 Line 13-20 .info-l)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 商品名称 (对应小程序 Line 14)
                Text(
                  goods.name ?? '',
                  style: TextStyle(
                    fontSize: 15.sp, // 小程序: 30rpx = 15.sp
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF262629),
                  ),
                ),
                SizedBox(height: 8.h), // 名称与标签之间的间距
                // 标签行 (对应小程序 Line 15-19 .tags)
                Row(
                  children: [
                    _buildTag(
                      _getNumText(goods),
                      isPrimary: true,
                    ), // Line 16: info.num_text
                    SizedBox(width: 6.w),
                    if (_getYearText(goods).isNotEmpty)
                      _buildTag(_getYearText(goods)), // Line 17: info.year
                    if (_getYearText(goods).isNotEmpty)
                      SizedBox(width: 6.w),
                    _buildTag(_getQuestionNumText(goods)), // Line 18: 共XX题
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 标签 Widget (对应小程序 Line 355-374)
  Widget _buildTag(String text, {bool isPrimary = false}) {
    return Container(
      height: 17.h, // 小程序: 34rpx = 17.h
      padding: EdgeInsets.symmetric(horizontal: 6.w), // 小程序: 12rpx = 6.w
      decoration: BoxDecoration(
        color: isPrimary
            ? const Color(0xFFEBF1FF)
            : const Color(0xFFF5F6FA), // 小程序 Line 363, 371
        borderRadius: BorderRadius.circular(2.r), // 小程序: 4rpx = 2.r
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 10.sp, // 小程序: 20rpx = 10.sp
            color: isPrimary
                ? AppColors.primary
                : const Color(
                    0xFF2C373D,
                  ).withOpacity(0.71), // 小程序 Line 367, 372
          ),
        ),
      ),
    );
  }

  /// 获取商品数量文本 (对应小程序 Line 177-190 info.num_text)
  String _getNumText(GoodsModel goods) {
    final type = SafeTypeConverter.toSafeString(goods.type);
    final tikuDetails = goods.tikuGoodsDetails;

    if (type == '8') {
      final paperNum = SafeTypeConverter.toInt(tikuDetails?.paperNum);
      return '共${paperNum}份';
    } else if (type == '10') {
      final examRoundNum = SafeTypeConverter.toInt(tikuDetails?.examRoundNum);
      return '共${examRoundNum}轮';
    } else {
      final questionNum = SafeTypeConverter.toInt(tikuDetails?.questionNum);
      return '共${questionNum}题';
    }
  }

  /// 获取年份文本 (对应小程序 Line 17 info.year)
  String _getYearText(GoodsModel goods) {
    // ✅ 从 year 字段获取（对应小程序 Line 190: this.info.year = num_text）
    final year = goods.year;
    if (year != null && year.isNotEmpty) {
      return year;
    }
    return ''; // 如果没有年份字段，不显示
  }

  /// 获取题目数量文本 (对应小程序 Line 18)
  String _getQuestionNumText(GoodsModel goods) {
    final questionNum = SafeTypeConverter.toInt(
      goods.tikuGoodsDetails?.questionNum,
    );
    return '共${questionNum}题';
  }

  /// 章节试卷区域 (对应小程序 Line 23-47)
  Widget _buildChapterPaperSection(ChapterPaperModel chapter) {
    return Container(
      margin: EdgeInsets.only(
        left: 12.w, // 小程序: 24rpx = 12.w
        right: 12.w,
        bottom: 10.h, // 小程序: 20rpx = 10.h (Line 46)
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFECF3FF), Color(0xFFFAFCFF), Color(0xFFFFFFFF)],
          stops: [0.0, 0.43, 1.0],
        ),
        borderRadius: BorderRadius.circular(6.r), // 小程序: 12rpx = 6.r
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 章节标题 (对应小程序 Line 25-27, 312-327)
          Padding(
            padding: EdgeInsets.all(16.w), // 小程序: 32rpx = 16.w
            child: Text(
              chapter.name ?? '',
              style: TextStyle(
                fontSize: 15.sp, // 小程序: 30rpx = 15.sp (Line 324)
                fontWeight: FontWeight.w500,
                color: const Color(0xFF262629),
              ),
            ),
          ),
          // 试卷列表 (对应小程序 Line 28-44)
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(6.r), // 小程序: 12rpx = 6.r
                bottomRight: Radius.circular(6.r),
              ),
            ),
            child: Column(
              children: List.generate(
                chapter.list.length,
                (index) => _buildChapterPaperItem(
                  chapter.list[index],
                  index + 1, // ✅ 序号从1开始（对应小程序 Line 109: let n = index + 1）
                  isLast: index == chapter.list.length - 1,
                  chapter: chapter, // ✅ 传递章节信息，用于跳转
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 章节试卷列表项 (对应小程序 Line 29-42)
  Widget _buildChapterPaperItem(
    PaperModel paper,
    int displayNumber, { // ✅ 这是显示的序号(1,2,3...)
    bool isLast = false,
    ChapterPaperModel? chapter,
  }) {
    final isCompleted = paper.paperExerciseId != '0';

    return InkWell(
      onTap: () => _handlePaperTap(paper, chapter),
      child: Container(
        height: 59.h, // 小程序: 118rpx = 59.h
        margin: EdgeInsets.symmetric(horizontal: 14.w), // 小程序: 28rpx = 14.w
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(color: const Color(0xFFE8E9EA), width: 1),
                ),
        ),
        child: Row(
          children: [
            // 序号 (对应小程序 Line 35-38)
            _buildPaperNumber(displayNumber),
            SizedBox(width: 8.w), // 小程序推测: 16rpx = 8.w
            // 试卷名称 (对应小程序 Line 39)
            Expanded(
              child: Text(
                paper.name ?? '',
                style: TextStyle(
                  fontSize: 14.sp, // 小程序: 28rpx = 14.sp
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF262629),
                ),
              ),
            ),
            // 按钮 (对应小程序 Line 40-41, 294-306)
            _buildPaperButton(isCompleted),
          ],
        ),
      ),
    );
  }

  /// 试卷序号 (对应小程序 Line 35-38 + num方法 Line 108-110)
  /// ⚠️ 注意：小程序代码有bug (Line 110: return n ? '0' + n : n)，实际应该是 n < 10 ? '0' + n : n
  Widget _buildPaperNumber(int number) {
    // ✅ 修复后的逻辑: n < 10 时补0，返回 '01', '02'...，否则返回 '10', '11'...
    // 小程序 Line 109: let n = index + 1
    // 小程序 Line 110: return n ? '0' + n : n (有bug，应该是 n < 10 ? '0' + n : n)
    final displayNum = number < 10 ? '0$number' : '$number';

    return SizedBox(
      width: 32.w, // 小程序: 64rpx = 32.w
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            displayNum,
            style: TextStyle(
              fontSize: 18.sp, // 小程序: 36rpx = 18.sp
              fontWeight: FontWeight.w600,
              color: const Color(0xFF424B57),
            ),
          ),
          // 橙色渐变下划线 (对应小程序 Line 275-287)
          // ⚠️ 注意：小程序是 270deg，即从右到左的渐变
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 22.w, // 小程序: 44rpx = 22.w
              height: 7.h, // 小程序: 14rpx = 7.h
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerRight, // ✅ 270deg = 从右到左
                  end: Alignment.centerLeft,
                  colors: [
                    Color(
                      0x00FFC31E,
                    ), // transparent orange (对应小程序 rgba(255, 195, 30, 0))
                    Color(0xFFFF900D), // 对应小程序 #ff900d
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 试卷按钮 (对应小程序 Line 294-306)
  Widget _buildPaperButton(bool isCompleted) {
    return Container(
      width: 80.w, // 小程序: 160rpx = 80.w
      height: 28.h, // 小程序: 56rpx = 28.h
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(32.r), // 小程序: 64rpx = 32.r
      ),
      child: Center(
        child: Text(
          isCompleted ? '查看报告' : '开始考试',
          style: TextStyle(
            fontSize: 14.sp, // 小程序: 28rpx = 14.sp
            fontWeight: FontWeight.w400,
            color: AppColors.textWhite,
          ),
        ),
      ),
    );
  }

  /// 普通试卷列表区域 (对应小程序 Line 49-56)
  Widget _buildPaperListSection(List<PaperModel> paperList) {
    return Column(
      children: [
        ...paperList.map((paper) => _buildPaperItem(paper)),
        SizedBox(height: 10.h), // 小程序: 20rpx = 10.h (Line 55)
      ],
    );
  }

  /// 普通试卷列表项 (对应小程序 Line 50-54, 217-246)
  Widget _buildPaperItem(PaperModel paper) {
    final isCompleted = paper.paperExerciseId != '0';

    return InkWell(
      onTap: () => _handlePaperTap(paper),
      child: Container(
        margin: EdgeInsets.only(
          left: 12.w, // 小程序: 24rpx = 12.w (Line 218)
          right: 12.w,
          top: 12.h, // 小程序: margin 24rpx 24rpx 0 24rpx (Line 218)
        ),
        padding: EdgeInsets.all(16.w), // 小程序: 32rpx = 16.w (Line 219)
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(
            6.r,
          ), // 小程序: 12px = 6.r (Line 224)
          boxShadow: [
            BoxShadow(
              color: const Color(
                0x0F1B2637,
              ), // rgba(27, 38, 55, 0.06) (Line 225)
              blurRadius: 15.r, // 小程序: 30rpx = 15.r
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          children: [
            // 试卷名称 (对应小程序 Line 227-231)
            Expanded(
              child: Text(
                paper.name ?? '',
                style: TextStyle(
                  fontSize: 14.sp, // 小程序: 28rpx = 14.sp (Line 229)
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF262629), // Line 230
                ),
              ),
            ),
            // 按钮 (对应小程序 Line 232-245)
            _buildPaperButton(isCompleted),
          ],
        ),
      ),
    );
  }

  /// 处理试卷点击 (对应小程序 Line 118-140)
  void _handlePaperTap(PaperModel paper, [ChapterPaperModel? chapter]) {
    final examState = ref.read(testExamNotifierProvider);
    final goodsInfo = examState.goodsInfo;
    if (goodsInfo == null) return;

    final isCompleted = paper.paperExerciseId != '0';
    final paperId = SafeTypeConverter.toSafeString(paper.id);
    final paperName = paper.name ?? '';

    // ✅ 获取 professional_id (对应小程序 Line 129-130)
    final professionalId = SafeTypeConverter.toSafeString(
      goodsInfo.professionalId,
      defaultValue: widget.professionalId ?? '',
    );

    // ✅ 获取 order_id (对应小程序 Line 127-128)
    final orderId = SafeTypeConverter.toSafeString(
      goodsInfo.permissionOrderId,
      defaultValue: '1', // 对应小程序 Line 196: permission_order_id = '1'
    );

    final goodsId = SafeTypeConverter.toSafeString(
      goodsInfo.goodsId,
      defaultValue: widget.id ?? '',
    );

    final recitationModel = SafeTypeConverter.toSafeString(
      widget.recitationQuestionModel,
      defaultValue: '2',
    );

    print('\n📝 [试卷点击]');
    print('  - 试卷名称: $paperName');
    print('  - 试卷ID: $paperId');
    print('  - 状态: ${isCompleted ? "已答题" : "未答题"}');
    print('  - paper_exercise_id: ${paper.paperExerciseId}');

    if (isCompleted) {
      // ✅ 已答题 → 跳转到成绩报告页 (对应小程序 Line 134-140)
      print('  → 跳转到成绩报告页');
      context.push(
        AppRoutes.examScoreReport,
        extra: {
          'professional_id': professionalId,
          'paper_version_id': paperId,
          'order_id': orderId,
          'goods_id': goodsId,
          'title': paperName,
          'recitation_question_model': recitationModel,
        },
      );
    } else {
      // ✅ 未答题 → 跳转到答题页 (对应小程序 Line 123-132)
      print('  → 跳转到答题页');
      context.push(
        AppRoutes.examinationing,
        extra: {
          'paper_version_id': paperId,
          'goods_id': goodsId,
          'order_id': orderId,
          'sub_order_id': 'ddd', // 对应小程序 Line 129
          'title': paperName,
          'professional_id': professionalId,
          'type': '8', // 对应小程序 Line 131
          'time_limit': 3600 * 2, // 对应小程序 Line 131: time=${3600 * 2}
          'recitation_question_model': recitationModel,
        },
      );
    }
  }

  Widget _buildError(String error) {
    return CommonStateWidget.loadError(
      message: error,
      onRetry: () {
        if (widget.id != null) {
          ref
              .read(testExamNotifierProvider.notifier)
              .loadExamData(goodsId: widget.id!);
        }
      },
    );
  }

  /// 二维码区域 (对应小程序 kf-qrcode 组件)
  Widget _buildQrcodeSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w), // 小程序: 24rpx = 12.w
      padding: EdgeInsets.only(bottom: 40.h), // 小程序: 80rpx = 40.h
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r), // 小程序: 24rpx = 12.r
      ),
      child: Column(
        children: [
          // 提示文字 (对应小程序 Line 3)
          Padding(
            padding: EdgeInsets.only(top: 20.h), // 小程序: 40rpx = 20.h
            child: Text(
              '扫码加牙开心刷题小助手，获取最新备考资料',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp, // 小程序: 28rpx = 14.sp
                fontWeight: FontWeight.w400,
                color: const Color(0xFF202020).withOpacity(0.85),
                height: 20.h / 14.sp, // 小程序: line-height 40rpx = 20.h
              ),
            ),
          ),
          // 二维码图片 (对应小程序 Line 4-9)
          Container(
            margin: EdgeInsets.only(top: 34.h), // 小程序: 68rpx = 34.h
            width: 155.w, // 小程序: 310rpx = 155.w
            height: 155.w,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: NetworkImage(
                  'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/46c2174185637060211201_%E5%BD%A2%E7%8A%B6%E7%BB%93%E5%90%88%402x.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Image.network(
                'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/WechatIMG357.jpg',
                width: 119.w, // 小程序: 238rpx = 119.w
                height: 119.w,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 119.w,
                  height: 119.w,
                  color: const Color(0xFFE4E8ED),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return CommonStateWidget.empty(
      message: '暂无试卷数据',
    );
  }
}
