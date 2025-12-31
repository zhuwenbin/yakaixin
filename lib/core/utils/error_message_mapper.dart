import 'package:dio/dio.dart';

/// 错误消息映射工具
/// 将技术性错误转换为用户友好的提示
class ErrorMessageMapper {
  ErrorMessageMapper._();

  /// 将 DioException 转换为用户友好的错误提示
  static String mapDioException(DioException error) {
    // ✅ 优先级1: 使用拦截器已处理的错误信息（拦截器从后端 msg 字段提取）
    if (error.error != null && error.error is String) {
      final errorMsg = error.error as String;
      // ✅ 后端返回的业务错误信息（如"账号与密码不匹配"）不应该被过滤
      // 只有技术性错误才需要过滤
      if (!isTechnicalError(errorMsg)) {
        print('✅ [错误映射] 使用拦截器提取的错误信息: $errorMsg');
        return errorMsg;
      } else {
        print('⚠️ [错误映射] 错误信息被识别为技术性错误，继续查找其他来源: $errorMsg');
      }
    }

    // ✅ 优先级2: 从响应数据中提取错误信息（兜底）
    if (error.type == DioExceptionType.badResponse && error.response?.data is Map) {
      final data = error.response!.data as Map<String, dynamic>;
      final msg = data['msg'] ?? data['message'];
      if (msg != null) {
        String? extractedMsg;
        if (msg is String && msg.isNotEmpty && !isTechnicalError(msg)) {
          extractedMsg = msg;
        } else if (msg is List && msg.isNotEmpty) {
          final joinedMsg = msg.join(', ');
          if (!isTechnicalError(joinedMsg)) {
            extractedMsg = joinedMsg;
          }
        }
        if (extractedMsg != null) {
          print('✅ [错误映射] 从响应数据提取错误信息: $extractedMsg');
          return extractedMsg;
        }
      }
    }

    // ✅ 优先级3: 根据错误类型返回友好提示
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return '连接超时，请检查网络后重试';
        
      case DioExceptionType.sendTimeout:
        return '请求超时，请检查网络后重试';
        
      case DioExceptionType.receiveTimeout:
        return '服务器响应超时，请稍后重试';
        
      case DioExceptionType.badResponse:
        return _mapBadResponse(error);
        
      case DioExceptionType.cancel:
        return '请求已取消';
        
      case DioExceptionType.connectionError:
        return '网络连接失败，请检查网络设置';
        
      case DioExceptionType.badCertificate:
        return '安全证书验证失败';
        
      case DioExceptionType.unknown:
        return _mapUnknownError(error);
    }
  }

  /// 将普通 Exception 转换为用户友好提示
  static String mapException(Exception error) {
    // ✅ 如果是 DioException，应该使用 mapDioException
    if (error is DioException) {
      return mapDioException(error);
    }
    
    final errorMsg = error.toString();
    
    // 移除 "Exception: " 前缀
    final cleanMsg = errorMsg.replaceFirst('Exception: ', '');
    
    // 过滤技术性错误
    if (isTechnicalError(cleanMsg)) {
      return '操作失败，请稍后重试';
    }
    
    return cleanMsg;
  }

  /// 从任意错误对象提取用户友好的错误信息
  /// 用于 UI 层统一处理各种错误类型
  static String extractUserFriendlyMessage(Object error, [String defaultMessage = '加载失败']) {
    if (error is DioException) {
      return mapDioException(error);
    } else if (error is Exception) {
      return mapException(error);
    } else {
      // 普通错误对象
      final errorMsg = error.toString();
      if (isTechnicalError(errorMsg)) {
        return defaultMessage;
      }
      return errorMsg;
    }
  }

  /// 处理 badResponse 错误
  static String _mapBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    
    // ✅ 优先尝试从响应中提取后端返回的错误信息
    if (error.response?.data is Map) {
      final data = error.response!.data as Map<String, dynamic>;
      final msg = data['msg'] ?? data['message'];
      if (msg != null) {
        if (msg is String && msg.isNotEmpty && !isTechnicalError(msg)) {
          return msg;  // ← 后端业务错误优先级最高
        }
        if (msg is List && msg.isNotEmpty) {
          final joinedMsg = msg.join(', ');
          if (!isTechnicalError(joinedMsg)) {
            return joinedMsg;  // ← 后端业务错误优先级最高
          }
        }
      }
    }
    
    // ✅ 如果后端没有返回可用的错误信息，则根据 HTTP 状态码映射
    switch (statusCode) {
      case 400:
        return '请求参数错误';
      case 401:
        return '登录已失效，请重新登录';
      case 403:
        return '没有访问权限';
      case 404:
        return '请求的内容不存在';
      case 500:
        return '服务器错误，请稍后重试';
      case 502:
        return '服务器网关错误';
      case 503:
        return '服务暂时不可用，请稍后重试';
      case 504:
        return '服务器响应超时';
      default:
        return statusCode != null 
            ? '服务器错误($statusCode)，请稍后重试' 
            : '网络请求失败，请稍后重试';
    }
  }

  /// 处理 unknown 错误
  static String _mapUnknownError(DioException error) {
    final errorString = error.error?.toString() ?? '';
    
    // 网络连接错误
    if (errorString.contains('SocketException')) {
      return '网络连接失败，请检查网络设置';
    }
    
    // DNS 解析失败
    if (errorString.contains('Failed host lookup')) {
      return '无法连接到服务器，请检查网络';
    }
    
    // SSL 证书错误
    if (errorString.contains('CERTIFICATE_VERIFY_FAILED')) {
      return '安全连接失败';
    }
    
    // 其他未知错误
    return '网络异常，请稍后重试';
  }

  /// 判断是否为技术性错误（需要转换为友好提示）
  static bool isTechnicalError(String message) {
    final technicalKeywords = [
      'bad response',
      'Bad response',
      'type \'',
      'is not a subtype',
      'FormatException',
      'JsonUnsupportedObjectError',
      'SocketException',
      'HandshakeException',
      'XMLHttpRequest error',
      'Connection closed before full header was received',
      'Connection terminated during handshake',
      'CERTIFICATE_VERIFY_FAILED',
      'Failed host lookup',
      'DioException',
      'DioError',
      'null check operator',
      'RangeError',
      'StateError',
      'Unhandled Exception',
    ];
    
    return technicalKeywords.any((keyword) => message.contains(keyword));
  }

  /// 获取通用错误提示（兜底）
  static String get defaultErrorMessage => '哎呦，出错啦~~';
}
