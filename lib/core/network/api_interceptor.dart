import 'dart:convert';
import 'package:dio/dio.dart';
import '../../app/config/api_config.dart';
import '../../app/constants/storage_keys.dart';
import '../storage/storage_service.dart';

/// API拦截器
/// 对应小程序: src/api/request.js, src/modules/jintiku/utils/request.js
/// 功能:
/// 1. 添加Basic认证
/// 2. 添加Token
/// 3. 添加默认参数(platform_id, merchant_id等)
/// 4. 统一错误处理
class ApiInterceptor extends Interceptor {
  final StorageService _storage;

  ApiInterceptor(this._storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 1. 添加Basic认证 (对应小程序 Basic s2b2c2b:qOEffNlL...)
    final basicAuth = 'Basic ${base64Encode(
      utf8.encode('${ApiConfig.basicKey}:${ApiConfig.basicValue}')
    )}';
    options.headers['Authorization'] = basicAuth;

    // 2. 添加 x-merchant-id 和 x-brand-id (对应小程序 setBasic)
    // ✅ Base64 编码，与小程序保持一致
    options.headers['x-merchant-id'] = base64Encode(
      utf8.encode(ApiConfig.merchantId)
    );
    options.headers['x-brand-id'] = base64Encode(
      utf8.encode(ApiConfig.brandId)
    );

    // 3. 添加 x-platform-id (对应小程序 setPlatForm)
    // ✅ 使用 shelf_platform_id
    options.headers['x-platform-id'] = base64Encode(
      utf8.encode(ApiConfig.shelfPlatformId)
    );

    // 4. 添加Token (如果已登录)
    final token = _storage.getString(StorageKeys.token);
    if (token != null && token.isNotEmpty) {
      // ✅ 使用 x-token 而非 token，与小程序保持一致
      options.headers['x-token'] = token;
    }

    // 5. 添加 x-menu-identy (对应小程序 setIdentify)
    // TODO: 菜单标识需要根据当前路由动态获取，暂时设置为 0
    options.headers['x-menu-identy'] = base64Encode(utf8.encode('0'));

    // 6. 设置 Content-Type (对应小程序 request.js:103-109)
    if (!options.headers.containsKey('Content-Type') && !options.headers.containsKey('content-type')) {
      if (options.method == 'POST' || options.method == 'PUT') {
        options.headers['content-type'] = 'application/x-www-form-urlencoded';
      } else {
        options.headers['content-type'] = 'application/text';
      }
    }

    // 3. 添加默认参数到请求体(POST)或查询参数(GET)
    // 对应小程序中每个接口都会带的参数
    // 但是某些接口不需要这些参数，例如 /b/base/sms/sendcode
    final skipDefaultParams = [
      '/b/base/sms/sendcode',  // 发送验证码接口只需要 phone 和 scene
    ];
    
    // 使用 uri.path 获取完整路径（包含baseUrl后的路径）
    final fullPath = options.uri.path;
    final shouldSkipDefaultParams = skipDefaultParams.any(
      (path) => fullPath.endsWith(path) || fullPath.contains(path)
    );
    
    if (!shouldSkipDefaultParams) {
      final defaultParams = {
        'platform_id': ApiConfig.platformId,
        'merchant_id': ApiConfig.merchantId,
        'brand_id': ApiConfig.brandId,
        'channel_id': ApiConfig.channelId,
        'extend_uid': ApiConfig.extendUid,
      };

      if (options.method == 'GET') {
        // GET请求: 添加到queryParameters
        options.queryParameters.addAll(defaultParams);
      } else if (options.method == 'POST' || options.method == 'PUT') {
        // POST/PUT请求: 添加到data
        if (options.data is Map) {
          (options.data as Map).addAll(defaultParams);
        } else if (options.data is FormData) {
          // FormData类型,添加到fields
          final formData = options.data as FormData;
          defaultParams.forEach((key, value) {
            formData.fields.add(MapEntry(key, value));
          });
        } else {
          // 其他情况,转换为Map
          options.data = {
            ...defaultParams,
            if (options.data != null) 'data': options.data,
          };
        }
      }
    }

    // 注意：已移除终端日志输出，请求详情请在调试面板中查看

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 注意：已移除终端日志输出，响应详情请在调试面板中查看

    // 小程序统一响应格式检查
    // 对应: src/utlis/request.js 和 src/modules/jintiku/api/request.js
    // 响应格式: {code: 100000, msg: [...], data: ...}
    if (response.data is Map) {
      final data = response.data as Map<String, dynamic>;
      
      // 检查业务错误码
      if (data.containsKey('code')) {
        final code = data['code'];
        
        // 小程序中: code == 100000 或 code == 0 表示成功
        // 对应: normal_code = 100000 (src/modules/jintiku/api/request.js:92)
        if (code != 100000 && code != 0) {
          // 业务失败
          final msg = data['msg'];
          final errorMessage = _extractErrorMessage(msg);
          
          // 特殊错误码处理
          if (code == 100002) {
            // 登录失效 (对应小程序: handlerStatusCode[100002])
            _handleLoginExpired();
          }
          
          handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              error: errorMessage,
              type: DioExceptionType.badResponse,
              response: response,
            ),
          );
          return;
        }
      }
    }

    super.onResponse(response, handler);
  }

  /// 提取错误消息
  /// msg可能是字符串或数组
  String _extractErrorMessage(dynamic msg) {
    if (msg == null) return '哎呦,出错啦~~';
    
    if (msg is String) {
      return msg.isEmpty ? '哎呦,出错啦~~' : msg;
    }
    
    if (msg is List) {
      if (msg.isEmpty) return '哎呦,出错啦~~';
      return msg.join(', ');
    }
    
    return '哎呦,出错啦~~';
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 注意：已移除终端错误日志输出，错误详情请在调试面板中查看

    // 网络错误统一提示: "哎呦,出错啦~~" (对应小程序)
    String errorMessage = '哎呦,出错啦~~';
    
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = '网络超时,请稍后重试';
        break;
      case DioExceptionType.badResponse:
        if (err.response?.statusCode == 401) {
          errorMessage = '未授权,请登录';
          _handleLoginExpired();
        } else if (err.response?.statusCode == 404) {
          errorMessage = '请求的资源不存在';
        } else if (err.response?.statusCode == 500) {
          errorMessage = '服务器错误';
        } else {
          // 尝试从响应中获取错误信息
          if (err.response?.data is Map) {
            final data = err.response!.data as Map<String, dynamic>;
            errorMessage = data['message'] ?? data['msg'] ?? errorMessage;
          }
        }
        break;
      case DioExceptionType.cancel:
        errorMessage = '请求已取消';
        break;
      case DioExceptionType.unknown:
        if (err.error != null && err.error.toString().contains('SocketException')) {
          errorMessage = '网络连接失败,请检查网络';
        }
        break;
      default:
        break;
    }

    // 创建新的DioException,包含处理后的错误信息
    final newError = DioException(
      requestOptions: err.requestOptions,
      error: errorMessage,
      type: err.type,
      response: err.response,
    );

    super.onError(newError, handler);
  }

  /// 处理登录失效
  /// 对应小程序: 清除token,跳转登录页
  void _handleLoginExpired() {
    // 注意：已移除终端日志输出
    _storage.remove(StorageKeys.token);
    _storage.remove(StorageKeys.userInfo);
    // TODO: 跳转到登录页 (需要在Provider中实现)
  }
}
