import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/storage/storage_service.dart';
import 'core/widgets/loading_hud.dart';
import 'core/widgets/network_debug_overlay.dart'; // 网络调试悬浮窗
import 'core/network/dio_client.dart'; // Dio客户端
import 'features/splash/splash_page.dart'; // 启动页

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    ProviderScope(
      overrides: [
        // 初始化StorageService
        storageServiceProvider.overrideWithValue(StorageService(prefs)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // 小程序rpx基准宽度750,为了1:1转换rpx到Flutter,使用750作为设计稿宽度
      // 小程序32rpx = Flutter 32.w (而不是16.w)
      designSize: const Size(750, 1624), // 基于iPhone X的2倍尺寸,与小程序rpx 1:1对应
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // 初始化HUD
        LoadingHUD.init();
        
        return MaterialApp(
          title: '牙开心题库',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          home: SplashPage(),
          // EasyLoading builder + 网络调试悬浮窗
          builder: (context, widget) {
            // 先应用 EasyLoading
            widget = EasyLoading.init()(context, widget);
            // 再包裹 NetworkDebugOverlay
            return NetworkDebugOverlay(child: widget ?? const SizedBox.shrink());
          },
        );
      },
    );
  }
}

/// 测试首页 - 用于测试网络调试系统
class _TestHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('牙开心题库'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '网络调试系统已就绪',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.h),
            Text(
              '点击左上角悬浮按钮查看网络请求',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
            SizedBox(height: 40.h),
            ElevatedButton(
              onPressed: () {
                // 测试网络请求
                ref.read(dioClientProvider).get('/api/test');
              },
              child: Text('测试网络请求'),
            ),
          ],
        ),
      ),
    );
  }
}
