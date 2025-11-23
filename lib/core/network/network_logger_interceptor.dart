import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'network_log_model.dart';

/// 网络日志拦截器
/// 记录所有网络请求到调试系统
class NetworkLoggerInterceptor extends Interceptor {
  final Ref ref;
  final Map<String, DateTime> _requestStartTimes = {};

  NetworkLoggerInterceptor(this.ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 记录请求开始时间
    _requestStartTimes[options.hashCode.toString()] = DateTime.now();

    // 创建日志记录
    final log = NetworkLogModel.fromRequest(options);
    
    // 添加到日志列表
    ref.read(networkLogsProvider.notifier).addLog(log);

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 计算耗时
    final startTime = _requestStartTimes.remove(response.requestOptions.hashCode.toString());
    final duration = startTime != null ? DateTime.now().difference(startTime) : null;

    // 更新日志
    ref.read(networkLogsProvider.notifier).updateLogWithResponse(
      response.requestOptions.uri.toString(),
      response,
      duration ?? Duration.zero,
    );

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 计算耗时
    final startTime = _requestStartTimes.remove(err.requestOptions.hashCode.toString());
    final duration = startTime != null ? DateTime.now().difference(startTime) : null;

    // 更新日志
    ref.read(networkLogsProvider.notifier).updateLogWithError(
      err.requestOptions.uri.toString(),
      err,
      duration ?? Duration.zero,
    );

    super.onError(err, handler);
  }
}

/// 网络日志状态管理
class NetworkLogsNotifier extends StateNotifier<List<NetworkLogModel>> {
  NetworkLogsNotifier() : super([]);

  /// 添加日志
  void addLog(NetworkLogModel log) {
    state = [log, ...state];
    // 最多保留100条记录
    if (state.length > 100) {
      state = state.sublist(0, 100);
    }
  }

  /// 更新日志(响应)
  void updateLogWithResponse(String url, Response response, Duration duration) {
    state = state.map((log) {
      if (log.url == url && log.statusCode == null) {
        return log.updateWithResponse(response, duration);
      }
      return log;
    }).toList();
  }

  /// 更新日志(错误)
  void updateLogWithError(String url, DioException error, Duration duration) {
    state = state.map((log) {
      if (log.url == url && log.statusCode == null) {
        return log.updateWithError(error, duration);
      }
      return log;
    }).toList();
  }

  /// 清空日志
  void clearLogs() {
    state = [];
  }
}

/// 网络日志Provider
final networkLogsProvider = StateNotifierProvider<NetworkLogsNotifier, List<NetworkLogModel>>((ref) {
  return NetworkLogsNotifier();
});
