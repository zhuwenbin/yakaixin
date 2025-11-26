import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// 交卷成功页面 - 对应小程序 examination/submitSuccess.vue
/// 功能：显示交卷成功信息
class SubmitSuccessPage extends ConsumerWidget {
  final String sessionName;
  final String mockName;

  const SubmitSuccessPage({
    super.key,
    required this.sessionName,
    required this.mockName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('交卷成功'),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 189.h),
          _buildSuccessIcon(),
          SizedBox(height: 30.h),
          _buildSuccessText(),
          SizedBox(height: 10.h),
          _buildUserInfo(),
          const Spacer(),
          _buildReturnButton(context),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        color: const Color(0xFF04C140).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.check_circle,
        size: 60.sp,
        color: const Color(0xFF04C140),
      ),
    );
  }

  Widget _buildSuccessText() {
    return Text(
      '交卷成功!',
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF000000),
      ),
    );
  }

  Widget _buildUserInfo() {
    // Mock 用户数据
    final userName = '张三';
    final userId = '123456';

    return Column(
      children: [
        _buildInfoRow('考生姓名：', userName),
        _buildInfoRow('ID：', userId),
        _buildInfoRow('考试名称：', mockName),
        _buildInfoRow('考试轮次：', sessionName),
      ],
    );
  }

  Widget _buildInfoRow(String title, String content) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 11.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF161F30),
            ),
          ),
          Text(
            content,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF787E8F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReturnButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 返回到考试列表或主页
        context.pop();
      },
      child: Container(
        width: 200.w,
        height: 36.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF2E68FF),
          borderRadius: BorderRadius.circular(17.r),
        ),
        child: Text(
          '返回考试日程',
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
