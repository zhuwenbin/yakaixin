import 'package:dio/dio.dart';
import 'error_message_mapper.dart';

/// 统一错误处理类
/// 
/// 职责：
/// - 统一处理所有类型的错误（DioException、Exception、其他）
/// - 返回用户友好的错误信息
/// - Provider 层只需要调用 handle() 方法，无需关心错误类型
/// 
/// 使用示例：
/// ```dart
/// try {
///   // 业务逻辑
/// } catch (e) {
///   final errorMsg = ErrorHandler.handle(e);
///   state = state.copyWith(error: errorMsg);
/// }
/// ```
class ErrorHandler {
  ErrorHandler._();

  /// 统一处理错误，返回用户友好的错误信息
  /// 
  /// [error] - 任意类型的错误对象（DioException、Exception、其他）
  /// [defaultMessage] - 默认错误提示（当无法提取友好信息时使用）
  /// 
  /// 返回：用户友好的错误信息字符串
  static String handle(
    Object error, {
    String defaultMessage = '操作失败，请稍后重试',
  }) {
    // ✅ 优先级1: DioException（网络错误，已由拦截器处理）
    if (error is DioException) {
      return ErrorMessageMapper.mapDioException(error);
    }

    // ✅ 优先级2: Exception（业务异常）
    if (error is Exception) {
      return ErrorMessageMapper.mapException(error);
    }

    // ✅ 优先级3: 其他类型错误
    return ErrorMessageMapper.extractUserFriendlyMessage(error, defaultMessage);
  }

  /// 处理错误并返回结果（用于需要返回值的场景）
  /// 
  /// 例如：支付、下单等需要返回 Result 的场景
  /// 
  /// ```dart
  /// try {
  ///   // 业务逻辑
  ///   return Result.success(data);
  /// } catch (e) {
  ///   return ErrorHandler.handleAsResult(e, onError: (msg) => Result.error(msg));
  /// }
  /// ```
  static T handleAsResult<T>(
    Object error,
    T Function(String errorMessage) onError, {
    String defaultMessage = '操作失败，请稍后重试',
  }) {
    final errorMsg = handle(error, defaultMessage: defaultMessage);
    return onError(errorMsg);
  }

  /// 判断错误是否为网络错误
  static bool isNetworkError(Object error) {
    if (error is DioException) {
      return error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout;
    }
    return false;
  }

  /// 判断错误是否为业务错误（后端返回的错误信息）
  static bool isBusinessError(Object error) {
    if (error is DioException) {
      // 如果 error.error 是字符串且不是技术性错误，则是业务错误
      if (error.error is String) {
        final errorMsg = error.error as String;
        return !ErrorMessageMapper.isTechnicalError(errorMsg);
      }
    }
    return false;
  }
}

