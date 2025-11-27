import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import '../network/network_log_model.dart';
import '../network/network_logger_interceptor.dart';
import '../network/dio_client.dart';
import '../network/mock_interceptor.dart';
import '../../app/config/api_config.dart';

/// 网络调试悬浮窗
/// 功能:
/// 1. 悬浮在App最上层
/// 2. 可拖拽
/// 3. 可展开/折叠
/// 4. 显示所有网络请求
/// 5. 点击查看请求详情
class NetworkDebugOverlay extends ConsumerStatefulWidget {
  final Widget child;

  const NetworkDebugOverlay({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<NetworkDebugOverlay> createState() => _NetworkDebugOverlayState();
}

class _NetworkDebugOverlayState extends ConsumerState<NetworkDebugOverlay> {
  // 悬浮按钮位置
  Offset _position = Offset(20.w, 100.h);
  
  // 是否展开列表
  bool _isExpanded = false;
  
  // 是否显示环境选择器
  bool _showingEnvSelector = false;
  
  // Mock 开关状态
  bool _isMockEnabled = false;
  
  // 当前显示详情的日志
  NetworkLogModel? _selectedLog;

  @override
  void initState() {
    super.initState();
    print('=== NetworkDebugOverlay 初始化 ===');
    print('kDebugMode: $kDebugMode');
    print('ApiConfig.isDebug: ${ApiConfig.isDebug}');
    print('================================');
  }

  @override
  Widget build(BuildContext context) {
    final logs = ref.watch(networkLogsProvider);
    
    // 在 Debug 模式下才显示悬浮按钮
    if (!kDebugMode) {
      return widget.child;
    }

    return Stack(
      children: [
        // 原始页面
        widget.child,
        
        // 调试悬浮窗
        if (!_isExpanded)
          // 折叠状态 - 悬浮按钮
          Positioned(
            left: _position.dx,
            top: _position.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _position += details.delta;
                  // 限制范围
                  final screenWidth = MediaQuery.of(context).size.width;
                  final screenHeight = MediaQuery.of(context).size.height;
                  if (_position.dx < 0) _position = Offset(0, _position.dy);
                  if (_position.dx > screenWidth - 60.w) {
                    _position = Offset(screenWidth - 60.w, _position.dy);
                  }
                  if (_position.dy < 0) _position = Offset(_position.dx, 0);
                  if (_position.dy > screenHeight - 60.w) {
                    _position = Offset(_position.dx, screenHeight - 60.w);
                  }
                });
              },
              onTap: () {
                setState(() {
                  _isExpanded = true;
                });
              },
              child: _buildFloatingButton(logs.length),
            ),
          ),
        
        // 展开状态 - 请求列表
        if (_isExpanded)
          Positioned.fill(
            child: _buildLogList(logs),
          ),
        
        // 环境选择器弹窗
        if (_showingEnvSelector)
          Positioned.fill(
            child: _buildEnvSelectorOverlay(),
          ),
        
        // 请求详情弹窗
        if (_selectedLog != null)
          Positioned.fill(
            child: _buildLogDetailOverlay(_selectedLog!),
          ),
      ],
    );
  }

  /// 构建悬浮按钮
  Widget _buildFloatingButton(int requestCount) {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(30.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.network_check,
            color: Colors.white,
            size: 24.sp,
          ),
          SizedBox(height: 2.h),
          Text(
            '$requestCount',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建请求列表
  Widget _buildLogList(List<NetworkLogModel> logs) {
    return Material(
      color: Colors.black.withOpacity(0.9),
      child: SafeArea(
        child: Column(
          children: [
            // 标题栏
            Container(
              height: 50.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              color: Colors.black,
              child: Row(
                children: [
                  Text(
                    '网络调试 (${logs.length})',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // Mock 开关
                  IconButton(
                    icon: Icon(
                      _isMockEnabled ? Icons.science : Icons.science_outlined,
                      color: _isMockEnabled ? Colors.amber : Colors.white,
                      size: 20.sp,
                    ),
                    onPressed: _toggleMock,
                  ),
                  // 环境切换按钮
                  IconButton(
                    icon: Icon(Icons.settings, color: Colors.white, size: 20.sp),
                    onPressed: _showEnvSelector,
                  ),
                  // 清空按钮
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.white, size: 20.sp),
                    onPressed: () {
                      ref.read(networkLogsProvider.notifier).clearLogs();
                    },
                  ),
                  // 关闭按钮
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 20.sp),
                    onPressed: () {
                      setState(() {
                        _isExpanded = false;
                      });
                    },
                  ),
                ],
              ),
            ),
            
            // 环境信息栏
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              color: Colors.blue.shade900.withOpacity(0.3),
              child: Row(
                children: [
                  Icon(Icons.api, color: Colors.blue.shade300, size: 14.sp),
                  SizedBox(width: 8.w),
                  Text(
                    '当前环境: ${_getEnvName(ApiConfig.currentEnv)}',
                    style: TextStyle(
                      color: Colors.blue.shade300,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      ApiConfig.baseUrl,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            
            // Mock 状态栏
            if (_isMockEnabled)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                color: Colors.amber.shade900.withOpacity(0.3),
                child: Row(
                  children: [
                    Icon(Icons.science, color: Colors.amber.shade300, size: 14.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Mock 模式已启用',
                      style: TextStyle(
                        color: Colors.amber.shade300,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '所有请求将返回模拟数据',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
            
            // 请求列表
            Expanded(
              child: logs.isEmpty
                  ? Center(
                      child: Text(
                        '暂无网络请求',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14.sp,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      itemCount: logs.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        color: Colors.white10,
                      ),
                      itemBuilder: (context, index) {
                        final log = logs[index];
                        return _buildLogItem(log);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 切换 Mock 开关
  void _toggleMock() {
    setState(() {
      _isMockEnabled = !_isMockEnabled;
    });
    
    // 更新全局 Mock 状态
    ref.read(mockEnabledProvider.notifier).state = _isMockEnabled;
    
    // ✅ 动态添加/移除 Mock 拦截器
    final dioClient = ref.read(dioClientProvider);
    if (_isMockEnabled) {
      dioClient.enableMock();
    } else {
      dioClient.disableMock();
    }
    
    // 显示提示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isMockEnabled ? 'Mock 模式已开启' : 'Mock 模式已关闭'),
        duration: Duration(seconds: 1),
        backgroundColor: _isMockEnabled ? Colors.amber : Colors.grey,
      ),
    );
  }
  
  /// 显示环境选择器
  void _showEnvSelector() {
    setState(() {
      _showingEnvSelector = true;
    });
  }
  
  /// 构建环境选择器覆盖层
  Widget _buildEnvSelectorOverlay() {
    return Material(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          width: 320.w,
          margin: EdgeInsets.symmetric(horizontal: 30.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 标题
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white10,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      '切换接口环境',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white, size: 20.sp),
                      onPressed: () {
                        setState(() {
                          _showingEnvSelector = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              // 环境选项
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildEnvOption('prod', '生产环境', ApiConfig.baseUrlProd),
                    SizedBox(height: 12.h),
                    _buildEnvOption('test', '测试环境', ApiConfig.baseUrlTest),
                    SizedBox(height: 12.h),
                    _buildEnvOption('dev', '开发环境', ApiConfig.baseUrlDev),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// 构建环境选项
  Widget _buildEnvOption(String env, String name, String url) {
    final isSelected = ApiConfig.currentEnv == env;
    return InkWell(
      onTap: () {
        setState(() {
          // 切换环境
          ApiConfig.switchEnv(env);
          // 更新 Dio 的 baseUrl
          ref.read(dioClientProvider).updateBaseUrl();
          // 清空旧的日志
          ref.read(networkLogsProvider.notifier).clearLogs();
          // 关闭选择器
          _showingEnvSelector = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已切换到 $name\n$url'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.blue.shade700.withOpacity(0.3) 
              : Colors.grey.shade800,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                    size: 16.sp,
                  ),
                if (isSelected) SizedBox(width: 6.w),
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              url,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 获取环境名称
  String _getEnvName(String env) {
    switch (env) {
      case 'prod':
        return '生产环境';
      case 'test':
        return '测试环境';
      case 'dev':
        return '开发环境';
      default:
        return '未知';
    }
  }

  /// 构建单个请求项
  Widget _buildLogItem(NetworkLogModel log) {
    final statusColor = log.isSuccess
        ? Colors.green
        : log.errorMessage != null
            ? Colors.red
            : Colors.orange;

    return InkWell(
      onTap: () {
        _showLogDetail(log);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 第一行: 方法 + URL + 状态
            Row(
              children: [
                // 方法
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: _getMethodColor(log.method),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    log.method,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                // URL
                Expanded(
                  child: Text(
                    _getShortUrl(log.url),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                // 状态码
                if (log.statusCode != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      border: Border.all(color: statusColor, width: 1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      '${log.statusCode}',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 6.h),
            // 第二行: 时间 + 耗时
            Row(
              children: [
                Text(
                  _formatTime(log.timestamp),
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 11.sp,
                  ),
                ),
                if (log.duration != null) ...[
                  SizedBox(width: 12.w),
                  Text(
                    '耗时: ${log.duration!.inMilliseconds}ms',
                    style: TextStyle(
                      color: _getDurationColor(log.duration!),
                      fontSize: 11.sp,
                    ),
                  ),
                ],
                if (log.errorMessage != null) ...[
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      log.errorMessage!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 11.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 显示请求详情
  void _showLogDetail(NetworkLogModel log) {
    setState(() {
      _selectedLog = log;
    });
  }
  
  /// 构建请求详情覆盖层
  Widget _buildLogDetailOverlay(NetworkLogModel log) {
    return Material(
      color: Colors.black.withOpacity(0.3),
      child: GestureDetector(
        onTap: () {
          // 点击背景关闭
          setState(() {
            _selectedLog = null;
          });
        },
        child: Container(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {}, // 阻止事件冒泡
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
              child: Column(
                children: [
                  // 标题栏
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                      border: Border(
                        bottom: BorderSide(color: Colors.white10, width: 1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '请求详情',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white, size: 20.sp),
                          onPressed: () {
                            setState(() {
                              _selectedLog = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  // 详情内容
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(16.w),
                      children: [
                        _buildDetailSection('基本信息', [
                          _buildDetailRow('请求方法', log.method),
                          _buildDetailRow('请求URL', log.url),
                          if (log.statusCode != null)
                            _buildDetailRow('状态码', '${log.statusCode}'),
                          if (log.duration != null)
                            _buildDetailRow('耗时', '${log.duration!.inMilliseconds}ms'),
                          _buildDetailRow('时间', _formatTime(log.timestamp)),
                        ]),
                        
                        if (log.headers != null && log.headers!.isNotEmpty)
                          _buildDetailSection('请求头', [
                            _buildJsonView(log.headers!),
                          ]),
                        
                        if (log.queryParameters != null && log.queryParameters!.isNotEmpty)
                          _buildDetailSection('查询参数', [
                            _buildJsonView(log.queryParameters!),
                          ]),
                        
                        if (log.requestData != null)
                          _buildDetailSection('请求体', [
                            _buildJsonView(log.requestData is Map ? log.requestData : {'data': log.requestData.toString()}),
                          ]),
                        
                        if (log.responseData != null)
                          _buildDetailSection('响应体', [
                            _buildJsonView(log.responseData is Map ? log.responseData : {'data': log.responseData.toString()}),
                          ]),
                        
                        if (log.errorMessage != null)
                          _buildDetailSection('错误信息', [
                            _buildDetailRow('错误', log.errorMessage!),
                          ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  /// 构建详情区块
  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.blue.shade300,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
  
  /// 构建详情行
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 4.h),
          SelectableText(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建 JSON 视图
  Widget _buildJsonView(dynamic data) {
    String jsonStr;
    try {
      jsonStr = JsonEncoder.withIndent('  ').convert(data);
    } catch (e) {
      jsonStr = data.toString();
    }
    return SelectableText(
      jsonStr,
      style: TextStyle(
        color: Colors.greenAccent,
        fontSize: 11.sp,
        fontFamily: 'monospace',
      ),
    );
  }

  /// 获取方法颜色
  Color _getMethodColor(String method) {
    switch (method) {
      case 'GET':
        return Colors.blue;
      case 'POST':
        return Colors.green;
      case 'PUT':
        return Colors.orange;
      case 'DELETE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// 获取短URL
  String _getShortUrl(String url) {
    final uri = Uri.parse(url);
    return uri.path.isEmpty ? '/' : uri.path;
  }

  /// 格式化时间
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}';
  }

  /// 获取耗时颜色
  Color _getDurationColor(Duration duration) {
    if (duration.inMilliseconds < 500) return Colors.green;
    if (duration.inMilliseconds < 2000) return Colors.orange;
    return Colors.red;
  }
}

/// 请求详情Sheet
class _NetworkLogDetailSheet extends StatelessWidget {
  final NetworkLogModel log;

  const _NetworkLogDetailSheet({required this.log});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          child: Column(
            children: [
              // 标题栏
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  border: Border(
                    bottom: BorderSide(color: Colors.white10, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      '请求详情',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white, size: 20.sp),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              
              // 详情内容
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.all(16.w),
                  children: [
                    _buildSection('基本信息', [
                      _buildInfoRow('请求方法', log.method),
                      _buildInfoRow('请求URL', log.url),
                      if (log.statusCode != null)
                        _buildInfoRow('状态码', '${log.statusCode}'),
                      if (log.duration != null)
                        _buildInfoRow('耗时', '${log.duration!.inMilliseconds}ms'),
                      _buildInfoRow('时间', log.timestamp.toString()),
                    ]),
                    
                    if (log.headers != null && log.headers!.isNotEmpty)
                      _buildSection('请求头', [
                        _buildJsonView(log.headers!),
                      ]),
                    
                    if (log.queryParameters != null && log.queryParameters!.isNotEmpty)
                      _buildSection('查询参数', [
                        _buildJsonView(log.queryParameters!),
                      ]),
                    
                    if (log.requestData != null)
                      _buildSection('请求数据', [
                        _buildJsonView(_toMap(log.requestData)),
                      ]),
                    
                    if (log.responseData != null)
                      _buildSection('响应数据', [
                        _buildJsonView(_toMap(log.responseData)),
                      ]),
                    
                    if (log.errorMessage != null)
                      _buildSection('错误信息', [
                        Text(
                          log.errorMessage!,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12.sp,
                          ),
                        ),
                      ]),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12.sp,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJsonView(Map<String, dynamic> data) {
    try {
      final jsonStr = const JsonEncoder.withIndent('  ').convert(data);
      return SelectableText(
        jsonStr,
        style: TextStyle(
          color: Colors.greenAccent,
          fontSize: 11.sp,
          fontFamily: 'monospace',
        ),
      );
    } catch (e) {
      return Text(
        data.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
        ),
      );
    }
  }

  Map<String, dynamic> _toMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return {'value': data.toString()};
  }
}
