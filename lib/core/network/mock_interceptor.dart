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
        // 模拟网络延迟 (200-500ms)
        await Future.delayed(Duration(milliseconds: 200 + (DateTime.now().millisecond % 300)));
        
        handler.resolve(mockResponse);
        return;
      }
    } catch (e) {
      print('⚠️ Mock数据获取失败: $e');
    }

    // 如果没有对应的Mock数据，继续正常请求
    handler.next(options);
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
    
    // 从Mock路由表获取数据
    final mockData = MockDataRouter.getMockData(path, method);
    
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
final mockEnabledProvider = StateProvider<bool>((ref) => false);
