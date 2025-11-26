import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'network_log_model.dart';

/// 网络日志拦截器
/// 记录所有网络请求到调试系统
class NetworkLoggerInterceptor extends Interceptor {
  final Ref ref;
  final Map<String, DateTime> _requestStartTimes = {};
  final Map<String, String> _requestLogIds = {}; // 保存请求hashCode到logId的映射

  NetworkLoggerInterceptor(this.ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 记录请求开始时间
    final requestKey = options.hashCode.toString();
    _requestStartTimes[requestKey] = DateTime.now();

    // 创建日志记录
    final log = NetworkLogModel.fromRequest(options);
    
    // 保存 requestKey 到 logId 的映射
    _requestLogIds[requestKey] = log.id;
    
    // 添加到日志列表
    ref.read(networkLogsProvider.notifier).addLog(log);

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 计算耗时
    final requestKey = response.requestOptions.hashCode.toString();
    final startTime = _requestStartTimes.remove(requestKey);
    final duration = startTime != null ? DateTime.now().difference(startTime) : null;
    
    // 获取对应的 logId
    final logId = _requestLogIds.remove(requestKey);

    // 更新日志
    if (logId != null) {
      ref.read(networkLogsProvider.notifier).updateLogWithResponse(
        logId,
        response,
        duration ?? Duration.zero,
      );
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 计算耗时
    final requestKey = err.requestOptions.hashCode.toString();
    final startTime = _requestStartTimes.remove(requestKey);
    final duration = startTime != null ? DateTime.now().difference(startTime) : null;
    
    // 获取对应的 logId
    final logId = _requestLogIds.remove(requestKey);

    // 更新日志
    if (logId != null) {
      ref.read(networkLogsProvider.notifier).updateLogWithError(
        logId,
        err,
        duration ?? Duration.zero,
      );
    }

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

  /// 更新日志(响应) - 使用 logId 匹配
  void updateLogWithResponse(String logId, Response response, Duration duration) {
    state = state.map((log) {
      if (log.id == logId) {
        return log.updateWithResponse(response, duration);
      }
      return log;
    }).toList();
  }

  /// 更新日志(错误) - 使用 logId 匹配
  void updateLogWithError(String logId, DioException error, Duration duration) {
    state = state.map((log) {
      if (log.id == logId) {
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
