import 'package:dio/dio.dart';

/// 网络请求日志Model
/// 用于调试系统记录所有网络请求
class NetworkLogModel {
  final String id; // 唯一ID
  final DateTime timestamp; // 时间戳
  final String method; // 请求方法 GET/POST/PUT/DELETE
  final String url; // 完整URL
  final Map<String, dynamic>? headers; // 请求头
  final dynamic requestData; // 请求数据
  final Map<String, dynamic>? queryParameters; // 查询参数
  final int? statusCode; // 响应状态码
  final dynamic responseData; // 响应数据
  final String? errorMessage; // 错误信息
  final Duration? duration; // 请求耗时
  final bool isSuccess; // 是否成功

  NetworkLogModel({
    required this.id,
    required this.timestamp,
    required this.method,
    required this.url,
    this.headers,
    this.requestData,
    this.queryParameters,
    this.statusCode,
    this.responseData,
    this.errorMessage,
    this.duration,
    required this.isSuccess,
  });

  /// 从RequestOptions创建
  factory NetworkLogModel.fromRequest(RequestOptions options) {
    return NetworkLogModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      method: options.method,
      url: options.uri.toString(),
      headers: options.headers.map((key, value) => MapEntry(key, value.toString())),
      requestData: options.data,
      queryParameters: options.queryParameters,
      isSuccess: false,
    );
  }

  /// 更新响应
  NetworkLogModel updateWithResponse(Response response, Duration duration) {
    return NetworkLogModel(
      id: id,
      timestamp: timestamp,
      method: method,
      url: url,
      // ✅ 使用 response.requestOptions.headers 获取完整的 headers（包括拦截器添加的）
      headers: response.requestOptions.headers.map((key, value) => MapEntry(key, value.toString())),
      requestData: requestData,
      queryParameters: queryParameters,
      statusCode: response.statusCode,
      responseData: response.data,
      duration: duration,
      isSuccess: response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300,
    );
  }

  /// 更新错误
  NetworkLogModel updateWithError(DioException error, Duration duration) {
    return NetworkLogModel(
      id: id,
      timestamp: timestamp,
      method: method,
      url: url,
      // ✅ 使用 error.requestOptions.headers 获取完整的 headers（包括拦截器添加的）
      headers: error.requestOptions.headers.map((key, value) => MapEntry(key, value.toString())),
      requestData: requestData,
      queryParameters: queryParameters,
      statusCode: error.response?.statusCode,
      responseData: error.response?.data,
      errorMessage: error.error?.toString() ?? error.message,
      duration: duration,
      isSuccess: false,
    );
  }

  /// 获取状态文字
  String get statusText {
    if (isSuccess) return '成功';
    if (errorMessage != null) return '失败';
    return '请求中';
  }

  /// 获取状态颜色
  String get statusColor {
    if (isSuccess) return '#4CAF50'; // 绿色
    if (errorMessage != null) return '#F44336'; // 红色
    return '#FF9800'; // 橙色
  }
}
