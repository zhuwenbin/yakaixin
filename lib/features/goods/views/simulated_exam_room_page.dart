import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/widgets/common_state_widget.dart';
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
  Widget _buildLeftSidebar(GoodsDetailModel detail) {
    return Container(
      width: 115.w,
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 专业名称（对应小程序没有，根据截图添加）
          Text(
            detail.professionalIdName ?? '口腔执业医师',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20.h),
          Divider(color: Colors.grey.shade300),
          SizedBox(height: 20.h),
          // 满分（对应截图）
          _buildSidebarItem('满分', '600分'),
          SizedBox(height: 20.h),
          // 时长（对应截图）
          _buildSidebarItem('时长', '150分钟'),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
        ),
        SizedBox(height: 6.h),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题（对应小程序 Line 24）
                Text(
                  detail.name ?? '',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                // 副标题（对应小程序 Line 25）
                Text(
                  '查漏补缺 直击重点',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 16.h),
                // 总分和时间（对应小程序 Line 28-31）
                Row(
                  children: [
                    Text(
                      '总分: 600分',
                      style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      '时间: 150分钟',
                      style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          // 考试统计表格区域（对应小程序 Line 33-60）
          // 注意：小程序中表格数据来自 mkgoods_statistics，这里暂时占位
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.description,
                  size: 48.sp,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 12.h),
                Text(
                  '考试列表功能开发中...',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
                SizedBox(height: 6.h),
                Text(
                  '需要额外接口支持',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
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

  /// 底部按钮（对应小程序 Line 72-74, 348-358）
  Widget _buildBottomButton(GoodsDetailModel detail, bool isPurchased) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _handleEnterExamRoom(detail, isPurchased),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2E68FF),
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            elevation: 0,
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
