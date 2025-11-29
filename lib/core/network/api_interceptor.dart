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
    // ✅ 对应小程序 request.js Line 64-74, 142-150
    // ⚠️ 白名单检查：基于 URL 判断是否需要添加用户参数
    // 对应小程序: noCheckoutLogin 配置 (httpRequestConfig.js Line 10-28)
    
    // ⚠️ 白名单：这些接口不需要强制登录（游客可访问）
    // ⚠️ 但是！如果用户已登录，仍然会添加 user_id/student_id 参数
    // ⚠️ 这样后端才能返回个性化数据（如 permission_status）
    // final noCheckoutLogin = [
    //   '/b/base/sms/sendcode',       // 发送验证码
    //   '/c/student/openid',           // 获取 openid
    //   '/c/student/login',            // 登录
    //   '/c/student/mobile',           // 获取手机号
    //   '/c/student/appoint/detail',   // 预约详情
    //   '/c/base/sms/sendcode',        // 发送验证码（C端）
    //   '/c/student/smslogin',         // 验证码登录
    //   '/c/tiku/homepage/chapterpackage/tree',  // 章节包树
    //   '/c/tiku/homepage/recommend/chapterpackage',  // 推荐章节包
    //   '/o/base/url/param/json',      // URL参数配置
    //   '/c/marketing/wechatshare/qrcode',  // 微信分享二维码
    //   '/c/marketing/wechatshare/qrcode/decodescene',  // 解码场景值
    // ];
    
    // 获取当前请求的路径
    // final requestPath = options.uri.path;
    
    // 检查是否在白名单中
    // final isInWhitelist = noCheckoutLogin.any((path) => requestPath.contains(path));
    
    // 获取当前参数（用于检查是否已经存在 user_id 或 no_user_id）
    Map<String, dynamic> currentParams = {};
    if (options.method == 'GET') {
      currentParams = Map<String, dynamic>.from(options.queryParameters);
    } else if (options.data is Map) {
      currentParams = Map<String, dynamic>.from(options.data as Map);
    }
    
    // ✅ 第一步：添加基础默认参数（所有接口都需要）
    final baseParams = {
      'platform_id': ApiConfig.platformId,
      'merchant_id': ApiConfig.merchantId,
      'brand_id': ApiConfig.brandId,
      'channel_id': ApiConfig.channelId,
      'extend_uid': ApiConfig.extendUid,
    };
    
    // ✅ 第二步：添加用户相关参数
    // 对应小程序: data.no_user_id !== "1"
    // ⚠️ 关键修复: 已登录用户总是添加 user_id 和 student_id，不管是否在白名单中
    // ⚠️ 这样商品详情等接口才能正确返回 permission_status
    final shouldAddUserParams = !currentParams.containsKey('user_id') && 
                                currentParams['no_user_id'] != "1";
    
    final studentId = _storage.getString(StorageKeys.studentId);
    
    Map<String, dynamic> userParams = {};
    
    // ✅ 如果已登录 && 没有显式禁止添加用户参数，则添加
    if (shouldAddUserParams && studentId != null && studentId.isNotEmpty) {
      userParams = {
        'user_id': studentId,
        'student_id': studentId,
      };
      print('👤 [API拦截器] 添加用户参数: user_id=$studentId, student_id=$studentId');
    } else {
      print('⚠️ [API拦截器] 未添加用户参数: shouldAdd=$shouldAddUserParams, studentId=${studentId ?? "null"}');
    } 
    
    // ✅ 第三步：添加专业 ID（根据白名单检查）
    // 对应小程序: data.no_professional_id !== "1"
    final shouldAddProfessionalId = !currentParams.containsKey('professional_id') && 
                                     currentParams['no_professional_id'] != "1";
    
    final majorId = _storage.getString(StorageKeys.currentMajorId);
    Map<String, dynamic> professionalParams = {};
    
    if (shouldAddProfessionalId && majorId != null && majorId.isNotEmpty) {
      professionalParams = {
        'professional_id': majorId,
      };
    } 
    
    // ✅ 合并所有默认参数
    final allDefaultParams = {
      ...baseParams,
      ...userParams,
      ...professionalParams,
    };
    
    // 添加到请求中
    if (options.method == 'GET') {
      // GET请求: 添加到queryParameters
      options.queryParameters.addAll(allDefaultParams);
      print('🔍 [API拦截器] ${options.method} ${options.uri.path}');
      print('📦 [API参数] ${options.queryParameters}');
    } else if (options.method == 'POST' || options.method == 'PUT') {
      // POST/PUT请求: 添加到data
      if (options.data is Map) {
        // ✅ 修复类型转换：创建新的 Map 而不是直接修改
        final currentData = Map<String, dynamic>.from(options.data as Map);
        currentData.addAll(allDefaultParams);
        options.data = currentData;
      } else if (options.data is FormData) {
        // FormData类型,添加到fields
        final formData = options.data as FormData;
        allDefaultParams.forEach((key, value) {
          formData.fields.add(MapEntry(key, value));
        });
      } else {
        // 其他情况,转换为Map
        options.data = {
          ...allDefaultParams,
          if (options.data != null) 'data': options.data,
        };
      }
    }


    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {

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
    // ⚠️ 临时调试：打印错误详情
    print('❌ [API错误] ${err.requestOptions.method} ${err.requestOptions.uri.path}');
    print('❌ [错误类型] ${err.type}');
    print('❌ [错误信息] ${err.error}');
    print('❌ [响应数据] ${err.response?.data}');
    print('❌ [响应状态码] ${err.response?.statusCode}');

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
