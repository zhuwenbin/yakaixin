import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../providers/exam_info_provider.dart';
import '../models/exam_info_detail_model.dart';

/// P3-2 模考详情 - 模考信息
/// 对应小程序: pages/modelExaminationCompetition/examInfo
/// 
/// 参数:
/// - productId: 商品ID
/// - title: 商品标题
/// - page: 来源页面 ('home')
class ExamInfoPage extends ConsumerStatefulWidget {
  final String? productId;
  final String? title;
  final String? page;
  
  const ExamInfoPage({
    super.key,
    this.productId,
    this.title,
    this.page,
  });

  @override
  ConsumerState<ExamInfoPage> createState() => _ExamInfoPageState();
}

class _ExamInfoPageState extends ConsumerState<ExamInfoPage> {
  String? _selectedMockExamId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (widget.productId == null) return;
    
    final authState = ref.read(authProvider);
    final professionalId = authState.currentMajor?.majorId;
    
    await ref.read(examInfoNotifierProvider.notifier).loadExamInfo(
      productId: widget.productId!,
      mockExamId: _selectedMockExamId,
      professionalId: professionalId,
    );
  }

  /// 数字转中文（一、二、三...）
  /// 对应小程序: examInfo.vue transform() Line 246-260
  String _transformNumber(int number) {
    const list = ['一', '二', '三', '四', '五', '六', '七', '八', '九', '十'];
    if (number >= 0 && number < list.length) {
      return list[number];
    }
    return '${number + 1}';
  }

  /// 处理轮次操作（报名/进入考场/查看成绩）
  /// 对应小程序: examInfo.vue sinUp() Line 133-201
  Future<void> _handleRoundAction(ExamRoundModel round, int index) async {
    final state = ref.read(examInfoNotifierProvider);
    final detail = state.detail;
    if (detail == null) return;

    // status == '2': 未报名，请求报名接口
    if (round.status == '2') {
      final success = await ref.read(examInfoNotifierProvider.notifier).signup(round.mockId);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('报名成功！')),
        );
      }
      return;
    }

    // status == '4': 补考还未开启
    if (round.status == '4') {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('补考还未开启哦！')),
        );
      }
      return;
    }

    // btn_is_enable == '2': 该场模考未开始
    if (round.btnIsEnable == '2') {
      return;
    }

    // status == '1' || status == '5': 已报名/补考，进入考场
    if (round.status == '1' || round.status == '5') {
      final currentRound = detail.examRounds[index];
      final mockExam = detail.mockExam;
      
      // 计算剩余时间
      final now = DateTime.now();
      final endTime = DateTime.parse(currentRound.endTime);
      final startTime = DateTime.parse(currentRound.startTime);
      
      int remainingTime;
      if (currentRound.status == '5') {
        // 补考：使用总时长
        remainingTime = endTime.difference(startTime).inSeconds;
      } else {
        // 正常考试：使用剩余时间
        remainingTime = endTime.difference(now).inSeconds;
        if (remainingTime < 0) remainingTime = 0;
      }
      
      // 总时长
      final totalTime = endTime.difference(startTime).inSeconds;
      
      // 跳转到考试须知页
      // 对应小程序: examInfo.vue Line 174-185
      context.push(AppRoutes.examNotice, extra: {
        'id': mockExam.id,
        'eid': currentRound.id,
        'pid': mockExam.professionalId,
        'pvid': currentRound.examPaperId,
        'session': _transformNumber(index),
        'session_name': currentRound.subjectName,
        'time': remainingTime,
        'totalTime': totalTime,
        'mock_name': currentRound.examRoundName,
        'status': currentRound.status,
      });
      return;
    }

    // status == '3': 查看成绩
    if (round.status == '3') {
      // 跳转到成绩报告页
      // 对应小程序: examInfo.vue Line 191-194
      // 注意：小程序使用 /c/tiku/exam/scorereporting，但 ExamScoreReportPage 使用 /c/tiku/servicehall/scorereporting
      // 先传递可用参数，如果接口不匹配需要后续调整
      final detail = ref.read(examInfoNotifierProvider).detail;
      if (detail != null) {
        context.push(AppRoutes.examScoreReport, extra: {
          'paper_version_id': round.examPaperId,
          'order_id': round.id, // 使用 examination_session_id 作为 order_id
          'goods_id': round.mockId, // 使用 examination_id 作为 goods_id
          'title': round.examRoundName,
          'professional_id': detail.mockExam.professionalId,
        });
      }
      return;
    }
  }

  /// 处理当前模考操作
  /// 对应小程序: examInfo.vue goCurrentDetai() Line 203-208
  void _handleCurrentAction() {
    final state = ref.read(examInfoNotifierProvider);
    final detail = state.detail;
    if (detail == null) return;

    if (detail.mockStatus == '5') {
      // 找到当前可操作的轮次
      final currentIndex = detail.examRounds.indexWhere(
        (e) => e.status == '1' || e.status == '5',
      );
      if (currentIndex >= 0) {
        _handleRoundAction(detail.examRounds[currentIndex], currentIndex);
      }
    }
  }

  /// 切换其他模考
  /// 对应小程序: examInfo.vue other() Line 242-245
  Future<void> _switchOtherMockExam(MockExamListItemModel item) async {
    setState(() {
      _selectedMockExamId = item.id;
    });
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(examInfoNotifierProvider);
    final detail = state.detail;

    // 处理副作用（错误提示）
    ref.listen<ExamInfoState>(
      examInfoNotifierProvider,
      (previous, next) {
        if (next.error != null && previous?.error != next.error && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.error!)),
          );
        }
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title ?? '模考详情'),
        backgroundColor: Colors.white,
        actions: [
          // ✅ 帮助按钮 - 对应小程序: .help
          // position: fixed, right: 30rpx = 15.w, top: 20rpx = 10.h
          // font-size: 28rpx = 14.sp
          // 注意：小程序是 fixed 定位在右上角，Flutter 中放在 AppBar actions 中
          TextButton(
            onPressed: () {
              // 对应小程序: examInfo.vue Line 90-93
              context.push(AppRoutes.examHelp);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w), // ✅ right: 30rpx = 15.w
              child: Text(
                '帮助',
                style: TextStyle(
                  fontSize: 14.sp, // ✅ 28rpx / 2 = 14.sp
                  fontWeight: FontWeight.w400, // ✅ PingFangSC-Regular
                  color: const Color(0xFF999999),
                  height: 1.0, // ✅ line-height: 28rpx = 1.0
                ),
              ),
            ),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : detail == null
              ? Center(
                  child: Text(
                    state.error ?? '暂无数据',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async => _loadData(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // 标题
                        _buildTitle(detail.mockExam.mockName),
                        
                        // 考试时间
                        _buildTime(detail.mockExam),
                        SizedBox(height: 10.h), // ✅ 对应小程序 margin-bottom: 20rpx = 10.h
                        
                        // 考试轮次表格
                        _buildExamRoundsTable(detail.examRounds),
                        
                        // 报名人数
                        // ✅ 对应小程序: .current-num
                        // margin-top: 40rpx = 20.h, margin-bottom: 40rpx = 20.h
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: _buildSignUpCount(detail.signUpCount),
                        ),
                        
                        // 操作按钮
                        _buildActionButton(detail),
                        
                        // 全部模考入口（page != 'home' 时显示）
                        if (widget.page != 'home') ...[
                          SizedBox(height: 30.h), // ✅ margin-top: 60rpx = 30.h
                          _buildDivider(),
                          _buildAllMockExamEntry(context),
                          _buildOtherMockExamTitle(),
                          SizedBox(height: 20.h), // ✅ margin-top: 40rpx = 20.h
                          _buildOtherMockExamList(detail.mockList),
                        ],
                        
                        SizedBox(height: 100.h),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildTitle(String title) {
    // ✅ 对应小程序: .mian-title
    // margin-top: 58rpx = 29.h, margin-bottom: 58rpx = 29.h
    // font-size: 32rpx = 16.sp
    return Padding(
      padding: EdgeInsets.only(top: 29.h, bottom: 29.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp, // ✅ 32rpx / 2 = 16.sp
          fontWeight: FontWeight.normal, // ✅ AppleSystemUIFont 默认字重
          color: const Color(0xFF333333),
          height: 1.0, // ✅ line-height: 32rpx = 1.0
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTime(MockExamModel mockExam) {
    // ✅ 对应小程序: .time
    // font-size: 24rpx = 12.sp, margin-bottom: 20rpx = 10.h
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '考试时间：',
          style: TextStyle(
            fontSize: 12.sp, // ✅ 24rpx / 2 = 12.sp
            fontWeight: FontWeight.w400, // ✅ PingFangSC-Regular
            color: const Color(0xFF999999),
            height: 1.0, // ✅ line-height: 24rpx = 1.0
          ),
        ),
        Text(
          '${mockExam.startTime}—${mockExam.endTime}',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF387DFC), // ✅ main-color
            height: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildExamRoundsTable(List<ExamRoundModel> rounds) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
      ),
      child: Column(
        children: rounds.asMap().entries.map((entry) {
          final index = entry.key;
          final round = entry.value;
          // ✅ 对应小程序: :class="{ active: status == '3' }"
          // active 状态是已参考（已考试），不是可进入考场
          final isActive = round.status == '3';
          final isLast = index == rounds.length - 1;
          
          return _buildTableRow(round, index, isActive, isLast);
        }).toList(),
      ),
    );
  }

  Widget _buildTableRow(ExamRoundModel round, int index, bool isActive, bool isLast) {
    // ✅ 对应小程序: .table .tr .td
    // height: 120rpx = 60.h
    // 第一列: width: 200rpx, font-size: 20rpx = 10.sp
    // 第二列: width: 276rpx, font-size: 28rpx = 14.sp
    // 第三列: width: 190rpx
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFEEEEEE),
            width: isLast ? 0 : 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // 时间列（第一列）
          // ✅ width: 200rpx, font-size: 20rpx = 10.sp
          Expanded(
            flex: 2,
            child: Container(
              height: 60.h, // ✅ 120rpx / 2 = 60.h
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(color: Color(0xFFEEEEEE), width: 1),
                ),
              ),
              child: Text(
                '${round.startTime}-${round.endTime}',
                style: TextStyle(
                  fontSize: 10.sp, // ✅ 20rpx / 2 = 10.sp
                  color: const Color(0xFF333333),
                  height: 1.0, // ✅ line-height: 40rpx ≈ 1.0
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // 轮次名称列（第二列）
          // ✅ width: 276rpx, font-size: 28rpx = 14.sp
          Expanded(
            flex: 3,
            child: Container(
              height: 60.h,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(color: Color(0xFFEEEEEE), width: 1),
                ),
              ),
              child: Text(
                round.examRoundName,
                style: TextStyle(
                  fontSize: 14.sp, // ✅ 28rpx / 2 = 14.sp
                  color: const Color(0xFF333333),
                  height: 1.0,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // 操作按钮列（第三列）
          // ✅ width: 190rpx
          Expanded(
            flex: 2,
            child: Container(
              height: 60.h,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () => _handleRoundAction(round, index),
                child: Container(
                  width: 75.w, // ✅ 150rpx / 2 = 75.w
                  height: 30.h, // ✅ 60rpx / 2 = 30.h
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFF387DFC) : Colors.transparent,
                    border: Border.all(
                      color: const Color(0xFF387DFC),
                      width: 1, // ✅ 2rpx ≈ 1
                    ),
                    borderRadius: BorderRadius.circular(15.r), // ✅ 30rpx / 2 = 15.r
                  ),
                  child: Text(
                    _getButtonText(round),
                    style: TextStyle(
                      fontSize: 14.sp, // ✅ 28rpx / 2 = 14.sp
                      fontWeight: FontWeight.w500, // ✅ PingFangSC-Medium
                      color: isActive ? Colors.white : const Color(0xFF387DFC),
                      height: 1.0, // ✅ line-height: 60rpx ≈ 1.0
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText(ExamRoundModel round) {
    if (round.btnIsEnable == '1' && (round.status == '1' || round.status == '5')) {
      return '进入考场';
    }
    return round.statusName;
  }

  Widget _buildSignUpCount(String count) {
    // ✅ 对应小程序: .current-num
    // font-size: 24rpx = 12.sp
    // 数字: color: #333, margin: 0 6rpx = 3.w
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '已有',
          style: TextStyle(
            fontSize: 12.sp, // ✅ 24rpx / 2 = 12.sp
            fontWeight: FontWeight.w400, // ✅ PingFangSC-Regular
            color: const Color(0xFF999999),
            height: 1.0, // ✅ line-height: 24rpx = 1.0
          ),
        ),
        SizedBox(width: 3.w), // ✅ margin: 0 6rpx = 3.w
        Text(
          count,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF333333), // ✅ 数字颜色不同
            height: 1.0,
          ),
        ),
        SizedBox(width: 3.w),
        Text(
          '人报名',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF999999),
            height: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(ExamInfoDetailModel detail) {
    // ✅ 对应小程序: .btn .buutton
    // width: 320rpx = 160.w, height: 80rpx = 40.h
    // border-radius: 45rpx = 22.5.r
    // font-size: 32rpx = 16.sp
    final isActive = detail.mockStatus == '5';
    
    return GestureDetector(
      onTap: isActive ? _handleCurrentAction : null,
      child: Container(
        width: 160.w, // ✅ 320rpx / 2 = 160.w
        height: 40.h, // ✅ 80rpx / 2 = 40.h
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF387DFC) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(22.5.r), // ✅ 45rpx / 2 = 22.5.r
        ),
        child: Text(
          detail.mockStatusName,
          style: TextStyle(
            fontSize: 16.sp, // ✅ 32rpx / 2 = 16.sp
            fontWeight: FontWeight.w400, // ✅ PingFangSC-Regular
            color: isActive ? Colors.white : const Color(0xFF999999),
            height: 0.875, // ✅ line-height: 28rpx / 32rpx ≈ 0.875
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    // ✅ 对应小程序: .line
    // width: 100%, height: 16rpx = 8.h, background: #f5f5f5
    // margin-top: 60rpx = 30.h
    return Container(
      width: double.infinity,
      height: 8.h, // ✅ 16rpx / 2 = 8.h
      color: const Color(0xFFF5F5F5),
    );
  }

  Widget _buildAllMockExamEntry(BuildContext context) {
    // ✅ 对应小程序: .all
    // height: 125rpx = 62.5.h, padding: 0 40rpx = 20.w
    // image: width: 50rpx = 25.w, height: 50rpx = 25.w, margin-right: 19rpx = 9.5.w
    // title: font-size: 30rpx = 15.sp, margin-bottom: 16rpx = 8.h
    // desc: font-size: 24rpx = 12.sp
    // right icon: width: 36rpx = 18.w
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w), // ✅ 40rpx / 2 = 20.w
        height: 62.5.h, // ✅ 125rpx / 2 = 62.5.h
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.network(
                  'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/16969200277943d26169692002779427480_4.png',
                  width: 25.w, // ✅ 50rpx / 2 = 25.w
                  height: 25.w,
                  errorBuilder: (_, __, ___) => Icon(Icons.list, size: 25.w),
                ),
                SizedBox(width: 9.5.w), // ✅ 19rpx / 2 = 9.5.w
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '全部模考',
                      style: TextStyle(
                        fontSize: 15.sp, // ✅ 30rpx / 2 = 15.sp
                        fontWeight: FontWeight.w400, // ✅ PingFangSC-Regular
                        color: const Color(0xFF333333),
                        height: 1.0, // ✅ line-height: 30rpx = 1.0
                      ),
                    ),
                    SizedBox(height: 8.h), // ✅ margin-bottom: 16rpx = 8.h
                    Text(
                      '参加往期错过的模考/查看往期成绩',
                      style: TextStyle(
                        fontSize: 12.sp, // ✅ 24rpx / 2 = 12.sp
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF999999),
                        height: 1.0, // ✅ line-height: 24rpx = 1.0
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Image.network(
              'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/1669357686810b313166935768681084385_right.png',
              width: 18.w, // ✅ 36rpx / 2 = 18.w
              errorBuilder: (_, __, ___) => Icon(
                Icons.chevron_right,
                size: 18.sp,
                color: const Color(0xFF787E8F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherMockExamTitle() {
    // ✅ 对应小程序: .ohter
    // background: #f5f5f5, padding-left: 40rpx = 20.w
    // height: 80rpx = 40.h
    // font-size: 30rpx = 15.sp
    return Container(
      padding: EdgeInsets.only(left: 20.w), // ✅ 40rpx / 2 = 20.w
      height: 40.h, // ✅ 80rpx / 2 = 40.h
      alignment: Alignment.centerLeft,
      color: const Color(0xFFF5F5F5),
      child: Text(
        '其他模考',
        style: TextStyle(
          fontSize: 15.sp, // ✅ 30rpx / 2 = 15.sp
          fontWeight: FontWeight.w400, // ✅ PingFangSC-Regular
          color: const Color(0xFF333333),
          height: 1.4, // ✅ line-height: 42rpx / 30rpx ≈ 1.4
        ),
      ),
    );
  }

  Widget _buildOtherMockExamList(List<MockExamListItemModel> list) {
    // ✅ 对应小程序: .other-lists .other-list
    // display: flex, overflow-x: scroll
    // margin-top: 40rpx = 20.h, padding: 0 20rpx = 10.w
    // item: width: 440rpx = 220.w, height: 210rpx = 105.h
    // background: #f2f2f2, border-radius: 20rpx = 10.r
    // padding: 22rpx 30rpx = 11.w 15.w, margin-right: 24rpx = 12.w
    // title: font-size: 32rpx = 16.sp, margin-bottom: 36rpx = 18.h
    // active: background-color: #d7e5ff
    if (list.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 105.h, // ✅ 210rpx / 2 = 105.h
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 10.w), // ✅ 20rpx / 2 = 10.w
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          final isSelected = item.id == _selectedMockExamId;
          
          return GestureDetector(
            onTap: () => _switchOtherMockExam(item),
            child: Container(
              width: 220.w, // ✅ 440rpx / 2 = 220.w
              height: 105.h,
              margin: EdgeInsets.only(right: 12.w), // ✅ 24rpx / 2 = 12.w
              padding: EdgeInsets.symmetric(
                horizontal: 15.w, // ✅ 30rpx / 2 = 15.w
                vertical: 11.w, // ✅ 22rpx / 2 = 11.w
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFD7E5FF) // ✅ active 状态
                    : const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(10.r), // ✅ 20rpx / 2 = 10.r
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.mockName,
                    style: TextStyle(
                      fontSize: 16.sp, // ✅ 32rpx / 2 = 16.sp
                      fontWeight: FontWeight.w400, // ✅ PingFangSC-Regular
                      color: const Color(0xFF333333),
                      height: 1.3125, // ✅ line-height: 42rpx / 32rpx ≈ 1.3125
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 18.h), // ✅ margin-bottom: 36rpx = 18.h
                  Row(
                    children: [
                      Text(
                        '模考时间：',
                        style: TextStyle(
                          fontSize: 12.sp, // ✅ 24rpx / 2 = 12.sp
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF999999),
                        ),
                      ),
                      Text(
                        item.startTime,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
