import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';

/// 关于我们页面
/// 参照小程序设计，展示应用信息和协议链接
class AboutUsPage extends ConsumerStatefulWidget {
  const AboutUsPage({super.key});

  @override
  ConsumerState<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends ConsumerState<AboutUsPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = 'v${packageInfo.version}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('关于我们'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40.h),
            
            // 应用图标
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Image.asset(
                  'assets/images/app_icon.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // 如果图标不存在，显示占位图标
                    return Container(
                      color: const Color(0xFF2E68FF),
                      child: Icon(
                        Icons.school,
                        size: 60.sp,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // 应用名称
            Text(
              '金医圣',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF161F30),
              ),
            ),
            
            SizedBox(height: 8.h),
            
            // 版本号
            Text(
              _version,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF787E8F),
              ),
            ),
            
            SizedBox(height: 40.h),
            
            // 应用简介
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Text(
                '金医圣 APP 是为广大医考、药考、护考生打造的在线学习应用。\n\n'
                '用户可以随时随地在线学习、下载学习全年、全阶段免费网课、教辅直播课。在学习过程中有任何问题可以随时在线咨询教辅老师。\n\n'
                '在线题库为用户提供了海量的章节练习题、历年真题、模拟考场等，有效的检验、巩固学习效果。\n\n'
                '图书商城为用户提供了各阶段学习的图书、学习包等。\n\n'
                '金医圣致力于打造医学教育云平台，为每个用户提供平等的教育机会。',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.8,
                  color: const Color(0xFF161F30),
                ),
              ),
            ),
            
            SizedBox(height: 60.h),
            
            // 协议链接
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    context.push(AppRoutes.userServiceAgreement);
                  },
                  child: Text(
                    '《用户协议》',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF52C41A),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Text(
                  ' 和 ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF787E8F),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.push(AppRoutes.privacyPolicy);
                  },
                  child: Text(
                    '《隐私协议》',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF52C41A),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 40.h),
            
            // 版权信息
            Text(
              'Copyright@2006 - ${DateTime.now().year}',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFFCCCCCC),
              ),
            ),
            
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
