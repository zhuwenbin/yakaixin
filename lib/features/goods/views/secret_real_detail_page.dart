import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../providers/secret_real_detail_provider.dart';
import '../models/goods_detail_model.dart';

/// P5-1-2 历年真题商品详情页（绝密真题）
/// 对应小程序: modules/jintiku/pages/test/secretRealDetail.vue
class SecretRealDetailPage extends ConsumerStatefulWidget {
  final String? productId;
  final String? professionalId;

  const SecretRealDetailPage({super.key, this.productId, this.professionalId});

  @override
  ConsumerState<SecretRealDetailPage> createState() =>
      _SecretRealDetailPageState();
}

class _SecretRealDetailPageState extends ConsumerState<SecretRealDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.productId != null && widget.productId!.isNotEmpty) {
        ref
            .read(secretRealDetailNotifierProvider.notifier)
            .loadDetail(widget.productId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(secretRealDetailNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        title: const Text('绝密真题'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: state.isLoading
          ? _buildLoading()
          : state.error != null
          ? _buildError(state.error!)
          : state.goodsDetail != null
          ? _buildContent(state.goodsDetail!)
          : _buildEmpty(),
      bottomNavigationBar: state.goodsDetail != null
          ? _buildBottomBar(state.goodsDetail!)
          : null,
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
    return Center(
      child: Padding(
        padding: EdgeInsets.all(50.h),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.red.shade300),
            SizedBox(height: 16.h),
            Text(error, textAlign: TextAlign.center),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                if (widget.productId != null) {
                  ref
                      .read(secretRealDetailNotifierProvider.notifier)
                      .refresh(widget.productId!);
                }
              },
              child: Text('重试'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Text('暂无数据', style: TextStyle(fontSize: 14.sp)),
    );
  }

  Widget _buildContent(GoodsDetailModel detail) {
    // 对应小程序 Line 2-52
    return Stack(
      children: [
        // 渐变背景（对应小程序 Line 3-5, CSS Line 701-709）
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFB8E8FC), // 浅蓝色
                  Color(0xFFF5F6F8), // 灰白色
                ],
              ),
            ),
          ),
        ),
        // 内容区域（对应小程序 Line 6-52）
        SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 45.h, 16.w, 0),
            child: Column(
              children: [
                // 绝密真题卡片（对应小程序 Line 7-47）
                Expanded(child: _buildCard(detail)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(GoodsDetailModel detail) {
    // 对应小程序 Line 7-47
    final questionNum = detail.tikuGoodsDetails?.questionNum?.toString() ?? '0';
    final examTime = detail.tikuGoodsDetails?.examTime ?? '';
    final doCount = detail.paperStatistics?.doCount?.toString() ?? '0';
    final accuracyRate =
        detail.paperStatistics?.totalAccuracyRate?.toString() ?? '0';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(30.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 专业名称（对应小程序 Line 11-14）
            Text(
              detail.professionalIdName ?? '口腔执业医师',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.h),
            // 绝密真题标签（对应小程序 Line 15）
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Color(0xFFFF5E00),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                '绝密真题',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            // 题目内容（对应小程序 Line 17-19）
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              width: double.infinity,
              child: Text(
                '题目内容：${detail.name ?? ''}',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 15.sp, color: Colors.black87),
              ),
            ),
            SizedBox(height: 16.h),
            Divider(color: Colors.grey.shade300),
            SizedBox(height: 16.h),
            // 详情列表（对应小程序 Line 22-44）
            _buildInfoRow('总题数', questionNum),
            SizedBox(height: 16.h),
            _buildInfoRow('做题次数', doCount),
            SizedBox(height: 16.h),
            _buildInfoRow('正确率', '$accuracyRate%'),
            SizedBox(height: 16.h),
            _buildInfoRowWithAction('错题', '查看错题', () {
              // TODO: 跳转错题本（对应小程序 Line 221-230）
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('错题本功能开发中...')));
            }),
            SizedBox(height: 16.h),
            _buildInfoRow('题库到期时间', examTime),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: TextStyle(fontSize: 15.sp, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 15.sp, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildInfoRowWithAction(
    String label,
    String actionText,
    VoidCallback onTap,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: TextStyle(fontSize: 15.sp, color: Colors.grey.shade600),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: TextStyle(
              fontSize: 15.sp,
              color: Color(0xFF2E68FF),
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }

  /// 底部按钮（对应小程序 Line 50, 211-220）
  Widget _buildBottomBar(GoodsDetailModel detail) {
    final isPurchased = detail.permissionStatus == '1';

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _handleAction(detail, isPurchased),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2E68FF),
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              elevation: 0,
            ),
            child: Text(
              isPurchased ? '开始冲刺做题' : '立即购买',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleAction(GoodsDetailModel detail, bool isPurchased) {
    if (isPurchased) {
      // 已购买 - 跳转考试页（对应小程序 Line 215）
      // pages/test/exam?id=${this.info.id}&recitation_question_model=${this.info.recitation_question_model}
      context.push(
        AppRoutes.testExam,
        extra: {
          'id': detail.goodsId?.toString(),
          'recitation_question_model': detail.recitationQuestionModel,
        },
      );
    } else {
      // 未购买 - 显示购买弹窗（对应小程序 Line 218，54-98）
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('购买功能开发中...')));
    }
  }
}
