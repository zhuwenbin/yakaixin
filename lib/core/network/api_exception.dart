/// API异常类
/// 对应小程序错误处理
class ApiException implements Exception {
  final String message;
  final int? code;
  final dynamic data;

  ApiException({
    required this.message,
    this.code,
    this.data,
  });

  @override
  String toString() {
    return 'ApiException: $message (code: $code)';
  }
}

/// 网络异常
class NetworkException extends ApiException {
  NetworkException({
    required super.message,
    super.code,
    super.data,
  });
}

/// 业务异常
class BusinessException extends ApiException {
  BusinessException({
    required super.message,
    super.code,
    super.data,
  });
}

/// 登录失效异常
class UnauthorizedException extends ApiException {
  UnauthorizedException({
    super.message = '登录已失效,请重新登录',
    super.code = 100002,
    super.data,
  });
}
