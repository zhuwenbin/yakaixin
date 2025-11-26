import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/storage/storage_service.dart';
import 'core/widgets/loading_hud.dart';
import 'core/widgets/network_debug_overlay.dart';
import 'core/network/dio_client.dart';
import 'app/routes/app_router.dart';

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
      designSize: const Size(375, 812), // iPhone X 设计稿尺寸(正确配置)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // 初始化HUD
        LoadingHUD.init();
        
        return MaterialApp.router(
          title: '牙开心题库',
          debugShowCheckedModeBanner: false,
          // 添加本地化支持
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('zh', 'CN'), // 中文
          ],
          locale: const Locale('zh', 'CN'),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          routerConfig: appRouter,
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
