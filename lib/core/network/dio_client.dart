import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/config/api_config.dart';
import '../../app/constants/storage_keys.dart';
import '../storage/storage_service.dart';
import '../utils/logger.dart';
import 'api_interceptor.dart';
import 'network_logger_interceptor.dart';
import 'mock_interceptor.dart';

/// Dio客户端封装
/// 对应小程序: src/api/request.js, src/modules/jintiku/utils/request.js
class DioClient {
  late Dio _dio;
  final StorageService _storage;
  final Ref? _ref; // 用于网络日志
  MockInterceptor? _mockInterceptor; // ✅ 保存 Mock 拦截器引用

  DioClient(this._storage, [this._ref]) {
    _initDio();
  }

  /// 初始化 Dio 实例
  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
        // 对应小程序 POST默认: application/x-www-form-urlencoded
        contentType: Headers.formUrlEncodedContentType,
        headers: {'Accept': 'application/json'},
      ),
    );

    // ✅ Debug模式下忽略SSL证书验证（iOS模拟器访问HTTPS必需）
    if (ApiConfig.isDebug) {
      (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        
        // ✅ 忽略SSL证书验证
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        
        print('✅ Debug模式: 已忽略SSL证书验证（允许访问测试环境HTTPS）');


        // client.findProxy = (uri) {
        //     return 'PROXY 192.168.3.23:8888';
        //   };
        return client;
      };
    }

    // 添加拦截器（顺序很重要！）
    // 1. 网络日志拦截器（最优先，记录所有请求）
    if (_ref != null && ApiConfig.isDebug) {
      _dio.interceptors.add(NetworkLoggerInterceptor(_ref));
    }

    // 2. Mock拦截器（只在 Debug 模式下初始化）
    // ✅ 默认不添加，使用真实 API
    // 可在调试面板手动开启 Mock 模式
    if (_ref != null && ApiConfig.isDebug) {
      _mockInterceptor = MockInterceptor(_ref);
      // 检查初始 Mock 状态（默认为 false）
      final isMockEnabled = _ref.read(mockEnabledProvider);
      if (isMockEnabled) {
        _dio.interceptors.add(_mockInterceptor!);
        print('✅ Mock拦截器已启用');
      } else {
        print('✅ 使用真实 API（Mock 模式关闭）');
      }
    }

    // 3. API拦截器（添加token、签名等）
    _dio.interceptors.add(ApiInterceptor(_storage));

    // 注意：已移除 LogInterceptor，避免终端输出过多日志
    // 网络请求详情请在调试面板中查看
  }

  /// 更新 baseUrl (用于环境切换)
  void updateBaseUrl() {
    _dio.options.baseUrl = ApiConfig.baseUrl;
    print('🔄 Dio baseUrl 已更新: ${_dio.options.baseUrl}');
  }

  /// ✅ 启用 Mock 模式
  void enableMock() {
    if (!ApiConfig.isDebug) {
      print('⚠️ Mock模式仅在Debug模式下可用');
      return;
    }

    if (_mockInterceptor != null &&
        !_dio.interceptors.contains(_mockInterceptor)) {
      _dio.interceptors.add(_mockInterceptor!);
      print('✅ Mock拦截器已启用');
    }
  }

  /// ✅ 禁用 Mock 模式
  void disableMock() {
    if (_mockInterceptor != null &&
        _dio.interceptors.contains(_mockInterceptor)) {
      _dio.interceptors.remove(_mockInterceptor);
      print('🔴 Mock拦截器已禁用');
    }
  }

  Dio get dio => _dio;

  /// GET请求
  /// 对应小程序: flyio.get / uni.request({method: 'GET'})
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// POST请求
  /// 对应小程序: flyio.post / uni.request({method: 'POST'})
  /// 默认Content-Type: application/x-www-form-urlencoded
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// PUT请求
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE请求
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 上传文件
  Future<Response<T>> upload<T>(
    String path,
    FormData formData, {
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: formData,
        options:
            options?.copyWith(contentType: 'multipart/form-data') ??
            Options(contentType: 'multipart/form-data'),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 下载文件
  Future<Response> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    try {
      return await _dio.download(
        urlPath,
        savePath,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      rethrow;
    }
  }
}

/// Dio Provider
final dioClientProvider = Provider<DioClient>((ref) {
  final storage = ref.read(storageServiceProvider);
  return DioClient(storage, ref);
});
