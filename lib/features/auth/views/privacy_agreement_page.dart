import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../app/constants/storage_keys.dart';
import '../../../core/storage/storage_service.dart';
import '../../../app/routes/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 隐私保护说明页 - 首次安装必须弹出
/// 参照 iOS PrivacyProtectVC 实现
/// 小米应用商店要求：应用首次运行须展示隐私政策弹窗
class PrivacyAgreementPage extends ConsumerStatefulWidget {
  const PrivacyAgreementPage({super.key});

  @override
  ConsumerState<PrivacyAgreementPage> createState() =>
      _PrivacyAgreementPageState();
}

class _PrivacyAgreementPageState extends ConsumerState<PrivacyAgreementPage> {
  static const Color _primaryColor = Color(0xFF387DFC);

  Future<void> _onAgree() async {
    final storage = ref.read(storageServiceProvider);
    await storage.setBool(StorageKeys.agreePrivacyProtect, true);
    if (!mounted) return;
    context.go(AppRoutes.mainTab);
  }

  void _onDisagree() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('提示'),
        content: const Text(
          '不同意将无法使用我们的产品和服务，并会退出APP',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              exit(0);
            },
            child: Text(
              '不同意并退出',
              style: TextStyle(color: _primaryColor),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _onAgree();
            },
            style: FilledButton.styleFrom(backgroundColor: _primaryColor),
            child: const Text('同意'),
          ),
        ],
      ),
    );
  }

  void _onOpenPrivacyPolicy() {
    context.push(AppRoutes.privacyPolicy);
  }

  @override
  Widget build(BuildContext context) {
    const String privacyText =
        '欢迎使用牙开心APP！为给您提供优质的服务、控制业务风险、保障信息和资金安全，本应用使用过程中，需要联网，需要在必要范围内收集、使用您的个人信息。请您在使用前仔细阅读《隐私协议》条款，同意后开启我们的服务。\n\n本应用在使用期间，我们需要申请获取您的系统权限，我们将在首次调用时逐项询问您是否允许使用该权限，也可以在您的设备系统"设置"里管理相关权限。';

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.white,
              ),
            ),
          ),
          Container(
            color: Colors.black.withValues(alpha: 0.4),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30.w),
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '隐私协议',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 240.h),
                    child: SingleChildScrollView(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: const Color(0xFF333333),
                            height: 1.5,
                          ),
                          children: _buildTextSpans(privacyText),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _onDisagree,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _primaryColor,
                            side: const BorderSide(color: _primaryColor),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22.r),
                            ),
                          ),
                          child: const Text('不同意'),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: FilledButton(
                          onPressed: _onAgree,
                          style: FilledButton.styleFrom(
                            backgroundColor: _primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22.r),
                            ),
                          ),
                          child: const Text('同意'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _buildTextSpans(String text) {
    const String privacyLink = '《隐私协议》';

    final List<TextSpan> spans = <TextSpan>[];
    final int start = text.indexOf(privacyLink);
    final int end = start + privacyLink.length;
    int lastEnd = 0;

    final List<({int start, int end, void Function() onTap})> links = [
      if (start >= 0)
        (start: start, end: end, onTap: _onOpenPrivacyPolicy),
    ];
    links.sort((a, b) => a.start.compareTo(b.start));

    for (final link in links) {
      if (link.start < 0) continue;
      if (link.start > lastEnd) {
        spans.add(
          TextSpan(text: text.substring(lastEnd, link.start)),
        );
      }
      spans.add(
        TextSpan(
          text: text.substring(link.start, link.end),
          style: const TextStyle(
            color: _primaryColor,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = link.onTap,
        ),
      );
      lastEnd = link.end;
    }
    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }
    return spans;
  }
}
