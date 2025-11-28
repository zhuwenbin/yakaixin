import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../mock/mock_data_router.dart';

/// Mock数据拦截器
/// 当Mock开关开启时，拦截网络请求并返回Mock数据
class MockInterceptor extends Interceptor {
  final Ref ref;

  MockInterceptor(this.ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 检查Mock开关是否开启
    final isMockEnabled = ref.read(mockEnabledProvider);
    
    if (!isMockEnabled) {
      // Mock关闭，继续正常请求
      handler.next(options);
      return;
    }

    // Mock开启，返回模拟数据
    try {
      final mockResponse = await _getMockResponse(options);
      
      if (mockResponse != null) {
        // ✅ 使用可配置的网络延迟模拟
        await _simulateNetworkDelay();
        
        handler.resolve(mockResponse);
        return;
      }
    } catch (e) {
      print('⚠️ Mock数据获取失败: $e');
    }

    // 如果没有对应的Mock数据，继续正常请求
    handler.next(options);
  }

  /// 模拟网络延迟
  Future<void> _simulateNetworkDelay() async {
    final delayMode = ref.read(mockDelayProvider);
    int delayMs;
    
    switch (delayMode) {
      case MockDelayMode.none:
        return; // 无延迟
        
      case MockDelayMode.fast:
        // 快速网络: 50-100ms
        delayMs = 50 + Random().nextInt(50);
        break;
        
      case MockDelayMode.normal:
        // 正常网络: 200-500ms
        delayMs = 200 + Random().nextInt(300);
        break;
        
      case MockDelayMode.slow:
        // 慢速网络: 1-3s
        delayMs = 1000 + Random().nextInt(2000);
        break;
        
      case MockDelayMode.unstable:
        // 不稳定网络: 30% 概率慢速
        final isSlowNetwork = Random().nextDouble() < 0.3;
        delayMs = isSlowNetwork
            ? 2000 + Random().nextInt(3000)  // 2-5s
            : 100 + Random().nextInt(200);   // 100-300ms
        break;
    }
    
    print('⏱️ Mock延迟: ${delayMs}ms (模式: ${delayMode.name})');
    await Future.delayed(Duration(milliseconds: delayMs));
  }

  /// 根据请求获取Mock响应
  Future<Response?> _getMockResponse(RequestOptions options) async {
    // 构建完整的请求路径(包含查询参数)
    String path = options.path;
    
    // 如果有queryParameters,添加到path中
    if (options.queryParameters.isNotEmpty) {
      final queryString = options.queryParameters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      path = '$path?$queryString';
    }
    
    final method = options.method;
    
    print('🧪 Mock拦截: $method $path');
    
    // 从 Mock路由表获取数据（异步）
    final mockData = await MockDataRouter.getMockData(path, method);
    
    if (mockData == null) {
      print('⚠️ 未找到Mock数据: $path');
      return null;
    }

    // 构造Mock响应
    return Response(
      requestOptions: options,
      data: mockData,
      statusCode: 200,
      statusMessage: 'OK (Mock)',
      headers: Headers.fromMap({
        'content-type': ['application/json'],
        'x-mock': ['true'],
      }),
    );
  }
}

/// Mock开关状态Provider
/// ✅ 默认关闭 Mock，使用真实 API
/// 可在调试面板手动开启 Mock 模式进行测试
final mockEnabledProvider = StateProvider<bool>((ref) => false);

/// Mock延迟模式Provider
final mockDelayProvider = StateProvider<MockDelayMode>((ref) => MockDelayMode.normal);

/// Mock延迟模式
enum MockDelayMode {
  none,      // 无延迟
  fast,      // 快速网络 (50-100ms)
  normal,    // 正常网络 (200-500ms)
  slow,      // 慢速网络 (1-3s)
  unstable,  // 不稳定网络 (30%概率慢速)
}
