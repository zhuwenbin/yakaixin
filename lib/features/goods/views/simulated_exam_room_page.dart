import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/widgets/common_state_widget.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/simulated_exam_room_provider.dart';
import '../models/goods_detail_model.dart';

/// P5-1-4 模拟考场页
/// 对应小程序: modules/jintiku/pages/test/simulatedExamRoom.vue
class SimulatedExamRoomPage extends ConsumerStatefulWidget {
  final String? productId;
  final String? professionalId;

  const SimulatedExamRoomPage({super.key, this.productId, this.professionalId});

  @override
  ConsumerState<SimulatedExamRoomPage> createState() =>
      _SimulatedExamRoomPageState();
}

class _SimulatedExamRoomPageState extends ConsumerState<SimulatedExamRoomPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.productId != null && widget.productId!.isNotEmpty) {
        ref
            .read(simulatedExamRoomNotifierProvider.notifier)
            .loadDetail(widget.productId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(simulatedExamRoomNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: state.isLoading
          ? _buildLoading()
          : state.error != null
          ? _buildError(state.error!)
          : state.goodsDetail != null
          ? _buildContent(state.goodsDetail!)
          : _buildEmpty(),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16.h),
          Text('加载中...', style: TextStyle(fontSize: 14.sp)),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    return CommonStateWidget.loadError(
      message: error,
      onRetry: () {
        if (widget.productId != null) {
          ref
              .read(simulatedExamRoomNotifierProvider.notifier)
              .refresh(widget.productId!);
        }
      },
    );
  }

  Widget _buildEmpty() {
    return CommonStateWidget.empty();
  }

  /// 主内容（对应小程序 Line 2-76）
  Widget _buildContent(GoodsDetailModel detail) {
    return SafeArea(
      child: Row(
        children: [
          // 左侧考生信息栏（对应小程序 Line 3-21）
          _buildLeftSidebar(detail),
          // 右侧内容区（对应小程序 Line 22-75）
          Expanded(child: _buildRightContent(detail)),
        ],
      ),
    );
  }

  /// 左侧考生信息栏（对应小程序 Line 3-21）
  /// 显示：姓名、准考证号、考场号、座位号（垂直文字）
  Widget _buildLeftSidebar(GoodsDetailModel detail) {
    // ✅ 获取用户信息
    final user = ref.watch(currentUserProvider);
    final studentName = user?.nickname?.isNotEmpty == true
        ? user!.nickname!
        : (user?.studentName ?? 'FELIXELICSI');
    final studentId = user?.studentId ?? '1001';
    
    // ✅ 生成准考证号、考场号、座位号（基于学生ID）
    final admissionNumber = studentId.length >= 4 
        ? studentId.substring(studentId.length - 4) 
        : studentId.padLeft(4, '0');
    final examRoomNumber = '01'; // 默认考场号
    final seatNumber = '01'; // 默认座位号

    return Container(
      width: 54.w, // 对应小程序 54upx
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: const Color(0xFFD9D9D9), width: 2.w),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildSidebarText('姓名：$studentName'),
          SizedBox(height: 60.h), // 对应小程序 margin-top: 60upx
          _buildSidebarText('准考证号：$admissionNumber'),
          SizedBox(height: 60.h),
          _buildSidebarText('考场号：$examRoomNumber'),
          SizedBox(height: 60.h),
          _buildSidebarText('座位号：$seatNumber'),
        ],
      ),
    );
  }

  /// 左侧边栏文字（垂直显示）
  /// 对应小程序: writing-mode: vertical-lr; text-orientation: sideways;
  Widget _buildSidebarText(String text) {
    return RotatedBox(
      quarterTurns: 3, // 逆时针旋转90度，实现垂直文字
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16.sp, // 对应小程序 16upx
          color: const Color(0xFF333333), // 对应小程序 color: #333
          letterSpacing: 0.5, // 对应小程序 letter-spacing: 0.5rem
          height: 1.0,
        ),
      ),
    );
  }

  /// 右侧内容区（对应小程序 Line 22-75）
  Widget _buildRightContent(GoodsDetailModel detail) {
    final isPurchased = detail.permissionStatus == '1';

    return Container(
      color: const Color(0xFFF5F5F5),
      child: Column(
        children: [
          // 头部（对应小程序 Line 23-31）
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 标题（对应小程序 Line 24-25）
                // 对应小程序: examTitle = `${this.info.year}${titleName}`
                Text(
                  _getExamTitle(detail),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40.sp, // 对应小程序 40upx
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 15.h), // 对应小程序 padding-top: 15upx
                // 副标题（对应小程序 Line 25）
                Text(
                  '模拟考场',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 44.sp, // 对应小程序 44upx
                    fontWeight: FontWeight.w700, // 对应小程序 font-weight: 700
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 80.h), // 对应小程序 padding-top: 80upx
                // 总分和时间（对应小程序 Line 28-31）
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '总分: ${_getFullMarkScore(detail)}分',
                      style: TextStyle(
                        fontSize: 26.sp, // 对应小程序 26upx
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 24.w), // 对应小程序 margin-right: 24upx
                    Text(
                      '时间: ${_getExamDuration(detail)}分钟',
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          // 考试统计表格区域（对应小程序 Line 33-60）
          if (detail.mkgoodsStatistics != null &&
              detail.mkgoodsStatistics!.typeCountMap != null &&
              detail.mkgoodsStatistics!.typeCountMap!.isNotEmpty)
            _buildQuestionTypeTable(detail.mkgoodsStatistics!),
          SizedBox(height: 10.h),
          // 注意事项（对应小程序 Line 63-70）
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '注意事项',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 12.h),
                _buildNoticeItem('1. 交卷后，显示分数及答案解析。'),
                SizedBox(height: 8.h),
                _buildNoticeItemWithHighlight('2. 每天每个科目只能进行', '1', '次考试。'),
                SizedBox(height: 8.h),
                _buildNoticeItem('3. 考试中途退出会保留做题记录。'),
              ],
            ),
          ),
          Spacer(),
          // 底部按钮（对应小程序 Line 72-74）
          _buildBottomButton(detail, isPurchased),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildNoticeItem(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade700),
    );
  }

  Widget _buildNoticeItemWithHighlight(
    String prefix,
    String highlight,
    String suffix,
  ) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade700),
        children: [
          TextSpan(text: prefix),
          TextSpan(
            text: highlight,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          TextSpan(text: suffix),
        ],
      ),
    );
  }

  /// 获取考试标题（对应小程序 Line 815-818）
  String _getExamTitle(GoodsDetailModel detail) {
    if (detail.examTitle != null && detail.examTitle!.isNotEmpty) {
      return detail.examTitle!;
    }
    // 对应小程序: `${this.info.year}${titleName}`
    final year = detail.year ?? '';
    final professionalName = detail.professionalIdName?.split('-').last ?? '口腔执业医师';
    return '$year$professionalName';
  }

  /// 获取满分（对应小程序 Line 798-799）
  String _getFullMarkScore(GoodsDetailModel detail) {
    final score = detail.mkgoodsStatistics?.fullMarkScore;
    if (score != null) {
      return score.toString();
    }
    return '600'; // 默认值
  }

  /// 获取考试时长（对应小程序 Line 798-799）
  String _getExamDuration(GoodsDetailModel detail) {
    final duration = detail.mkgoodsStatistics?.examDuration;
    if (duration != null) {
      return duration.toString();
    }
    return '150'; // 默认值
  }

  /// 构建题型数量表格（对应小程序 Line 33-60, 639-675）
  Widget _buildQuestionTypeTable(MockGoodsStatistics statistics) {
    final typeCountMap = statistics.typeCountMap;
    if (typeCountMap == null || typeCountMap.isEmpty) {
      return const SizedBox.shrink();
    }

    // ✅ 生成表头：["题型", "A1题", "A2题", ...]
    final headers = ['题型', ...typeCountMap.keys.map((k) => '${k}题')];
    
    // ✅ 生成表体：["数量", "97", "8", ...]
    final bodies = ['数量', ...typeCountMap.values.map((v) => v.toString())];

    // ✅ 计算每列宽度（对应小程序 computeWidths 方法）
    final widths = _computeWidths(headers);

    return Container(
      margin: EdgeInsets.only(
        left: 40.w,
        right: 40.w,
        top: 60.h, // 对应小程序 margin-top: 60upx
      ),
      child: Table(
        border: TableBorder(
          left: BorderSide(color: const Color(0xFFD9D9D9), width: 2.w),
          right: BorderSide(color: const Color(0xFFD9D9D9), width: 2.w),
          top: BorderSide(color: const Color(0xFFD9D9D9), width: 2.w),
          bottom: BorderSide(color: const Color(0xFFD9D9D9), width: 2.w),
          horizontalInside: BorderSide(color: const Color(0xFFD9D9D9), width: 2.w),
          verticalInside: BorderSide(color: const Color(0xFFD9D9D9), width: 2.w),
        ),
        columnWidths: Map.fromIterable(
          List.generate(headers.length, (i) => i),
          key: (i) => i,
          value: (i) => FlexColumnWidth(widths[i]),
        ),
        children: [
          // 表头
          TableRow(
            decoration: const BoxDecoration(color: Colors.white),
            children: headers.map((header) => _buildTableCell(header, isHeader: true)).toList(),
          ),
          // 表体
          TableRow(
            decoration: const BoxDecoration(color: Colors.white),
            children: bodies.map((body) => _buildTableCell(body, isHeader: false)).toList(),
          ),
        ],
      ),
    );
  }

  /// 计算列宽度（对应小程序 computeWidths 方法 Line 650-656）
  List<double> _computeWidths(List<String> names) {
    final lengths = names.map((n) => n.length).toList();
    final total = lengths.fold<int>(0, (sum, len) => sum + len);
    return lengths.map((len) => len / total).toList();
  }

  /// 构建表格单元格
  Widget _buildTableCell(String text, {required bool isHeader}) {
    return Container(
      height: 70.h, // 对应小程序 height: 70rpx
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 26.sp, // 对应小程序 font-size: 26rpx
          color: const Color(0xFF161F30), // 对应小程序 color: #161f30
          fontWeight: isHeader ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    );
  }

  /// 底部按钮（对应小程序 Line 72-74, 348-358）
  Widget _buildBottomButton(GoodsDetailModel detail, bool isPurchased) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _handleEnterExamRoom(detail, isPurchased),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF5402), // 对应小程序 background-color: #ff5402
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.r), // 对应小程序 border-radius: 100upx
            ),
            elevation: 0,
            minimumSize: Size(560.w, 96.h), // 对应小程序 width: 560upx, height: 96upx
          ),
          child: Text(
            '进入考场',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  /// 处理进入考场（对应小程序 Line 348-358）
  void _handleEnterExamRoom(GoodsDetailModel detail, bool isPurchased) {
    if (!isPurchased) {
      // 未购买 - 跳转到商品详情页（报名页）
      // 对应小程序: 显示购买弹窗（Line 350-351）
      final goodsId = detail.goodsId?.toString() ?? '';
      if (goodsId.isEmpty) {
        EasyLoading.showError('商品ID不能为空');
        return;
      }

      context.push(
        AppRoutes.courseGoodsDetail,
        extra: {'goods_id': goodsId},
      );
    } else {
      // 已购买 - 跳转考试详情页
      // 对应小程序: 显示选择考试科目弹窗（Line 353-356）
      final goodsId = detail.goodsId?.toString() ?? '';
      final title = detail.name ?? '模拟考试';
      
      context.push(
        AppRoutes.examInfo,
        extra: {
          'product_id': goodsId,
          'title': title,
          'page': 'goods_detail',
        },
      );
    }
  }
}
