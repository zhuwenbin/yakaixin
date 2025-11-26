/// 应用全局常量配置
/// 统一管理所有的全局静态变量
class AppConstants {
  // ==================== 应用信息 ====================
  
  /// 应用名称
  static const String appName = '牙开心题库';
  
  /// 应用版本号
  static const String appVersion = '1.4.14';
  
  /// 应用包名 (iOS Bundle ID / Android Package Name)
  static const String appPackageName = 'com.yakaixin.app';
  
  // ==================== 微信配置 ====================
  
  /// 微信开放平台 APP_ID (用于微信支付、分享等功能)
  static const String wechatAppId = 'wx832d03ed24df9a75';
  
  /// 微信小程序原始ID (用于跳转小程序等)
  static const String wechatMiniProgramAppId = 'wxf787cf63760d80a0';
  
  /// iOS Universal Link (微信支付iOS必需)
  static const String wechatUniversalLink = 'https://yakaixin.yunsop.com/';
  
  // ==================== 平台配置 ====================
  
  /// 平台ID (对应小程序 VUE_APP_PLATFORMID)
  static const String platformId = '409974729504527968';
  
  /// 商户ID (对应小程序 VUE_APP_MERCHANTID)
  static const String merchantId = '408559575579495187';
  
  /// 品牌ID (对应小程序 VUE_APP_BRANDID)
  static const String brandId = '408559632588540691';
  
  /// 渠道ID (对应小程序 VUE_APP_CHANNELID)
  static const String channelId = '515957991174840396';
  
  /// 扩展UID (对应小程序 VUE_APP_EXTENDUID)
  static const String extendUid = '508948528815416786';
  
  /// 货架平台ID (对应小程序 shelf_platform_id)
  static const String shelfPlatformId = '480130129201204499';
  
  // ==================== 登录配置 ====================
  
  /// 短信验证码场景值 (对应小程序 scene)
  /// 1: 注册, 2: 登录, 3: 绑定手机, 4: 修改手机, 5: 找回密码
  static const int smsSceneLogin = 2;
  static const int smsSceneRegister = 1;
  static const int smsSceneBindPhone = 3;
  static const int smsSceneChangePhone = 4;
  static const int smsSceneResetPassword = 5;
  
  /// 短信验证码有效期(秒)
  static const int smsCodeExpireTime = 60;
  
  /// Token过期时间(天)
  static const int tokenExpireDays = 30;
  
  // ==================== 答题配置 ====================
  
  /// 每次答题的题目数量
  static const int questionsPerSession = 20;
  
  /// 答题倒计时时长(秒) - 考试模式
  static const int examCountdownSeconds = 3600; // 60分钟
  
  /// 收藏题目最大数量
  static const int maxCollectedQuestions = 1000;
  
  /// 错题本最大数量
  static const int maxWrongQuestions = 1000;
  
  // ==================== UI配置 ====================
  
  /// 主题色
  static const int primaryColorValue = 0xFF3B82F6; // 蓝色
  
  /// 成功色
  static const int successColorValue = 0xFF10B981; // 绿色
  
  /// 警告色
  static const int warningColorValue = 0xFFF59E0B; // 橙色
  
  /// 错误色
  static const int errorColorValue = 0xFFEF4444; // 红色
  
  /// 默认头像占位图
  static const String defaultAvatarUrl = 'assets/images/default_avatar.png';
  
  /// 默认课程封面占位图
  static const String defaultCourseCoverUrl = 'assets/images/default_course.png';
  
  /// 网络请求超时时长(秒)
  static const int networkTimeoutSeconds = 30;
  
  /// 图片加载失败重试次数
  static const int imageRetryCount = 3;
  
  /// 下拉刷新触发距离
  static const double refreshTriggerDistance = 80.0;
  
  /// 上拉加载触发距离
  static const double loadMoreTriggerDistance = 50.0;
  
  // ==================== 分页配置 ====================
  
  /// 默认每页数量
  static const int defaultPageSize = 20;
  
  /// 题库列表每页数量
  static const int questionBankPageSize = 10;
  
  /// 课程列表每页数量
  static const int coursePageSize = 15;
  
  /// 订单列表每页数量
  static const int orderPageSize = 10;
  
  // ==================== 缓存配置 ====================
  
  /// 缓存版本号
  static const String cacheVersion = '1.0.0';
  
  /// 图片缓存最大数量
  static const int maxImageCacheCount = 100;
  
  /// 图片缓存最大大小(MB)
  static const int maxImageCacheSizeMB = 100;
  
  /// 数据缓存过期时间(小时)
  static const int dataCacheExpireHours = 24;
  
  // ==================== 支付配置 ====================
  
  /// 支付超时时长(秒)
  static const int paymentTimeoutSeconds = 300; // 5分钟
  
  /// 订单自动取消时长(分钟)
  static const int orderAutoCancelMinutes = 30;
  
  /// 最小支付金额(元)
  static const double minPaymentAmount = 0.01;
  
  /// 最大支付金额(元)
  static const double maxPaymentAmount = 999999.99;
  
  // ==================== 文件上传配置 ====================
  
  /// 允许上传的图片格式
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'gif'];
  
  /// 图片最大上传大小(MB)
  static const int maxImageUploadSizeMB = 10;
  
  /// 视频最大上传大小(MB)
  static const int maxVideoUploadSizeMB = 100;
  
  // ==================== 第三方服务配置 ====================
  
  /// 阿里云OSS域名
  static const String ossBaseUrl = 'https://yakaixin-oss.oss-cn-hangzhou.aliyuncs.com';
  
  /// 客服热线
  static const String customerServicePhone = '400-123-4567';
  
  /// 客服工作时间
  static const String customerServiceTime = '周一至周五 9:00-18:00';
  
  /// 官网地址
  static const String officialWebsite = 'https://www.yakaixin.com';
  
  /// 用户协议URL
  static const String userAgreementUrl = 'https://www.yakaixin.com/agreement';
  
  /// 隐私政策URL
  static const String privacyPolicyUrl = 'https://www.yakaixin.com/privacy';
  
  // ==================== 调试配置 ====================
  
  /// 是否显示网络日志
  static const bool showNetworkLog = true;
  
  /// 是否显示性能日志
  static const bool showPerformanceLog = false;
  
  /// 是否启用Mock数据
  static const bool enableMockData = false;
  
  /// Mock延迟时长(毫秒)
  static const int mockDelayMs = 500;
  
  // ==================== 正则表达式 ====================
  
  /// 手机号正则
  static const String phoneRegex = r'^1[3-9]\d{9}$';
  
  /// 邮箱正则
  static const String emailRegex = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
  
  /// 身份证号正则
  static const String idCardRegex = r'^\d{17}[\dXx]$';
  
  /// 密码正则(6-20位,包含字母和数字)
  static const String passwordRegex = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,20}$';
  
  // ==================== 错误提示 ====================
  
  /// 网络错误提示
  static const String networkErrorMsg = '网络连接失败,请检查网络设置';
  
  /// 服务器错误提示
  static const String serverErrorMsg = '服务器开小差了,请稍后再试';
  
  /// 数据为空提示
  static const String emptyDataMsg = '暂无数据';
  
  /// 登录过期提示
  static const String tokenExpiredMsg = '登录已过期,请重新登录';
  
  /// 权限不足提示
  static const String permissionDeniedMsg = '权限不足,请联系管理员';
  
  // ==================== 动画时长 ====================
  
  /// 页面过渡动画时长(毫秒)
  static const int pageTransitionMs = 300;
  
  /// 对话框淡入动画时长(毫秒)
  static const int dialogFadeInMs = 200;
  
  /// 列表项动画时长(毫秒)
  static const int listItemAnimationMs = 150;
  
  /// 按钮点击反馈时长(毫秒)
  static const int buttonFeedbackMs = 100;
}
