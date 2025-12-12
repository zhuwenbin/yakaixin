import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/storage/storage_service.dart';
import 'core/widgets/loading_hud.dart';
import 'core/widgets/network_debug_overlay.dart';
import 'core/network/dio_client.dart';
import 'core/config/debug_config.dart';
import 'features/payment/services/unified_payment_service.dart';
import 'app/routes/app_router.dart';
import 'app/constants/app_constants.dart';
import 'app/config/api_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ✅ 1. 初始化 SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final storage = StorageService(prefs);
  
  // ✅ 2. 初始化 ApiConfig
  ApiConfig.init(storage);
  
  // ✅ 3. 初始化中文日期格式
  await initializeDateFormatting('zh_CN', null);
  
  // ✅ 4. 初始化统一支付服务（微信 + iOS内购）
  // 注意：这里不能使用ref，所以先跳过
  // 初始化会在首次使用时自动执行
  
  print('🚀 应用初始化完成');
  
  // ✅ 5. 启动应用（传递 storage override）
  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storage),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听路由 Provider
    final router = ref.watch(appRouterProvider);
    
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X 设计稿尺寸(正确配置)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // 初始化HUD
        LoadingHUD.init();
        
        return MaterialApp.router(
          title: AppConstants.appName,
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
          routerConfig: router,
          // EasyLoading builder + 网络调试悬浮窗
          builder: (context, widget) {
            // 确保 widget 不为 null
            if (widget == null) return const SizedBox.shrink();
            
            // 先包裹 NetworkDebugOverlay
            widget = NetworkDebugOverlay(child: widget);
            // 再应用 EasyLoading
            widget = EasyLoading.init()(context, widget);
            
            return widget;
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
