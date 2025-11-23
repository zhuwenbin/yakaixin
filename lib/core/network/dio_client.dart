import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/config/api_config.dart';
import '../../app/constants/storage_keys.dart';
import '../storage/storage_service.dart';
import '../utils/logger.dart';
import 'api_interceptor.dart';
import 'network_logger_interceptor.dart';

/// Dio客户端封装
/// 对应小程序: src/api/request.js, src/modules/jintiku/utils/request.js
class DioClient {
  late Dio _dio;
  final StorageService _storage;
  final Ref? _ref; // 用于网络日志

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
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    // 添加拦截器
    _dio.interceptors.add(ApiInterceptor(_storage));
    
    // 添加网络日志拦截器 (在 Debug 模式下始终启用)
    if (_ref != null && ApiConfig.isDebug) {
      _dio.interceptors.add(NetworkLoggerInterceptor(_ref));
    }
    
    // 注意：已移除 LogInterceptor，避免终端输出过多日志
    // 网络请求详情请在调试面板中查看
  }
  
  /// 更新 baseUrl (用于环境切换)
  void updateBaseUrl() {
    _dio.options.baseUrl = ApiConfig.baseUrl;
    print('🔄 Dio baseUrl 已更新: ${_dio.options.baseUrl}');
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
        options: options?.copyWith(
          contentType: 'multipart/form-data',
        ) ?? Options(contentType: 'multipart/form-data'),
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
