import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../home/services/goods_service.dart';
import '../../../app/config/api_config.dart';
import '../../../core/utils/toast_util.dart';

/// 意见反馈页面（仅前端展示与虚拟提交，不实际上报）
/// 入口：我的 - 设置 - 意见反馈
class FeedbackPage extends ConsumerStatefulWidget {
  const FeedbackPage({super.key});

  @override
  ConsumerState<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends ConsumerState<FeedbackPage> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  static const int _maxContentLength = 500;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _contentController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  /// 通过请求首页商品接口判断是否有可用网络
  Future<bool> _hasNetwork() async {
    try {
      final goodsService = ref.read(goodsServiceProvider);
      await goodsService.getGoodsList(
        shelfPlatformId: ApiConfig.shelfPlatformId,
        professionalId: '524033912737962623',
        type: '18',
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _submit() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      ToastUtil.showCenterBlack('请填写反馈内容');
      return;
    }
    if (content.length > _maxContentLength) {
      ToastUtil.showCenterBlack('反馈内容不能超过$_maxContentLength字');
      return;
    }

    final hasNetwork = await _hasNetwork();
    if (!hasNetwork) {
      if (mounted) ToastUtil.showCenterBlack('请检查网络连接');
      return;
    }

    setState(() => _isSubmitting = true);

    await Future<void>.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    _contentController.clear();
    _contactController.clear();
    ToastUtil.showCenterBlack('提交成功，感谢您的反馈');
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        title: const Text('意见反馈'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.h),
            Text(
              '请描述您的问题或建议，我们会认真阅读每一条反馈。',
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF787E8F),
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '反馈内容 *',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF161F30),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: _contentController,
                    maxLines: 5,
                    maxLength: _maxContentLength,
                    decoration: InputDecoration(
                      hintText: '请输入您的问题或建议…',
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFFBDBDBD),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    '联系方式（选填）',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF161F30),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: _contactController,
                    decoration: InputDecoration(
                      hintText: '手机号或邮箱，便于我们回复您',
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFFBDBDBD),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            SizedBox(
              height: 46.h,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: _isSubmitting
                    ? SizedBox(
                        width: 22.w,
                        height: 22.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('提交'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
