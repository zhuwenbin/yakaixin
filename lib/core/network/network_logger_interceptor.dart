import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'network_log_model.dart';

/// 网络日志拦截器
/// 记录所有网络请求到调试系统
class NetworkLoggerInterceptor extends Interceptor {
  final Ref ref;
  final Map<String, DateTime> _requestStartTimes = {};
  static const String _logIdKey = '_networkLogId';

  NetworkLoggerInterceptor(this.ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 创建日志记录
    final log = NetworkLogModel.fromRequest(options);

    // 使用 extra 传递稳定的唯一 ID（避免后续拦截器修改 options 导致 hashCode 变化）
    options.extra[_logIdKey] = log.id;

    // 记录请求开始时间
    _requestStartTimes[log.id] = DateTime.now();

    // ✅ 添加详细调试日志
    print('🌐 [网络日志] 开始请求: ${options.method} ${options.path}');
    print('🌐 [网络日志] 查询参数: ${options.queryParameters}');
    print('🌐 [网络日志] 唯一ID: ${log.id}');
    print('🌐 [网络日志] Extra: ${options.extra}');

    // 添加到日志列表
    ref.read(networkLogsProvider.notifier).addLog(log);

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 从 extra 读取稳定的 logId
    final logId = response.requestOptions.extra[_logIdKey] as String?;

    // 计算耗时
    final startTime = logId != null ? _requestStartTimes.remove(logId) : null;
    final duration = startTime != null ? DateTime.now().difference(startTime) : null;

    // ✅ 添加详细调试日志
    print('✅ [网络日志] 请求成功: ${response.requestOptions.method} ${response.requestOptions.path}');
    print('✅ [网络日志] 状态码: ${response.statusCode}');
    print('✅ [网络日志] 耗时: ${duration?.inMilliseconds}ms');
    print('✅ [网络日志] LogId: $logId');
    print('✅ [网络日志] Response Extra: ${response.requestOptions.extra}');

    // 更新日志
    if (logId != null) {
      ref.read(networkLogsProvider.notifier).updateLogWithResponse(
        logId,
        response,
        duration ?? Duration.zero,
      );
    } else {
      print('⚠️ [网络日志] 警告: 无法找到对应的请求记录!');
      print('⚠️ [网络日志] Response Extra: ${response.requestOptions.extra}');
      print('⚠️ [网络日志] Response Path: ${response.requestOptions.path}');
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 从 extra 读取稳定的 logId
    final logId = err.requestOptions.extra[_logIdKey] as String?;

    // 计算耗时
    final startTime = logId != null ? _requestStartTimes.remove(logId) : null;
    final duration = startTime != null ? DateTime.now().difference(startTime) : null;

    // ✅ 添加详细调试日志
    print('❌ [网络日志] 请求失败: ${err.requestOptions.method} ${err.requestOptions.path}');
    print('❌ [网络日志] 错误类型: ${err.type}');
    print('❌ [网络日志] 错误信息: ${err.error}');
    print('❌ [网络日志] LogId: $logId');
    print('❌ [网络日志] Error Extra: ${err.requestOptions.extra}');

    // 更新日志
    if (logId != null) {
      ref.read(networkLogsProvider.notifier).updateLogWithError(
        logId,
        err,
        duration ?? Duration.zero,
      );
    } else {
      print('⚠️ [网络日志] 警告: 无法找到对应的请求记录!');
      print('⚠️ [网络日志] Error Extra: ${err.requestOptions.extra}');
      print('⚠️ [网络日志] Error Path: ${err.requestOptions.path}');
    }

    super.onError(err, handler);
  }
}

/// 网络日志状态管理
class NetworkLogsNotifier extends StateNotifier<List<NetworkLogModel>> {
  NetworkLogsNotifier() : super([]);

  /// 添加日志（带去重检查）
  void addLog(NetworkLogModel log) {
    // ✅ 去重检查：100ms内相同URL+方法+查询参数的请求视为重复
    final now = DateTime.now();
    final isDuplicate = state.any((existing) {
      // 必须同时满足：URL相同、方法相同、查询参数相同、时间间隔小于100ms
      final isSameUrl = existing.url == log.url;
      final isSameMethod = existing.method == log.method;
      final isSameQuery = _isSameQueryParameters(existing.queryParameters, log.queryParameters);
      final isRecent = now.difference(existing.timestamp).inMilliseconds < 100;

      return isSameUrl && isSameMethod && isSameQuery && isRecent;
    });

    if (isDuplicate) {
      print('⚠️ [网络日志] 检测到重复请求，跳过记录: ${log.method} ${log.url}');
      print('⚠️ [网络日志] 查询参数: ${log.queryParameters}');
      return;
    }

    state = [log, ...state];
    // 最多保留500条记录
    if (state.length > 500) {
      state = state.sublist(0, 500);
    }
  }

  /// 比较两个查询参数是否相同
  bool _isSameQueryParameters(Map<String, dynamic>? a, Map<String, dynamic>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;

    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key]?.toString() != b[key]?.toString()) {
        return false;
      }
    }
    return true;
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
