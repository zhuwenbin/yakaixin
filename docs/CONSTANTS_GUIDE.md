# 全局常量配置说明

## 概述

项目中所有的全局静态变量统一管理在以下文件中:

- **`lib/app/constants/app_constants.dart`** - 应用全局常量(主配置文件)
- **`lib/app/constants/storage_keys.dart`** - 本地存储Key
- **`lib/app/config/api_config.dart`** - API配置(环境、URL等)

## 使用方式

### 1. 导入常量

```dart
// 方式1: 导入单个文件
import 'package:yakaixin_app/app/constants/app_constants.dart';

// 方式2: 导入所有常量(推荐)
import 'package:yakaixin_app/app/constants/constants.dart';

// 方式3: 导入API配置
import 'package:yakaixin_app/app/config/api_config.dart';
```

### 2. 使用示例

```dart
// 使用微信配置
await PaymentService.initWechat();
print('微信AppID: ${AppConstants.wechatAppId}');

// 使用应用信息
Text(AppConstants.appName);
Text('版本: ${AppConstants.appVersion}');

// 使用平台配置
final platformId = AppConstants.platformId;
final merchantId = AppConstants.merchantId;

// 使用分页配置
final pageSize = AppConstants.defaultPageSize;

// 使用颜色配置
Color primaryColor = Color(AppConstants.primaryColorValue);

// 使用正则表达式
bool isValidPhone = RegExp(AppConstants.phoneRegex).hasMatch(phone);

// 使用Storage Key
await storage.setString(StorageKeys.token, token);
final token = storage.getString(StorageKeys.token);

// 使用API配置
final baseUrl = ApiConfig.baseUrl;
final wechatMiniProgramAppId = ApiConfig.wechatMiniProgramAppId;
```

## 配置项分类

### 应用信息
- `appName` - 应用名称
- `appVersion` - 应用版本号
- `appPackageName` - 应用包名

### 微信配置
- `wechatAppId` - **微信开放平台AppID** (用于支付、分享) = `wx832d03ed24df9a75`
- `wechatMiniProgramAppId` - 微信小程序AppID = `wxf787cf63760d80a0`
- `wechatUniversalLink` - iOS Universal Link

### 平台配置
- `platformId` - 平台ID
- `merchantId` - 商户ID
- `brandId` - 品牌ID
- `channelId` - 渠道ID
- `extendUid` - 扩展UID
- `shelfPlatformId` - 货架平台ID

### 登录配置
- `smsSceneLogin` - 短信验证码场景(登录)
- `smsSceneRegister` - 短信验证码场景(注册)
- `smsCodeExpireTime` - 验证码有效期
- `tokenExpireDays` - Token过期时间

### 答题配置
- `questionsPerSession` - 每次答题数量
- `examCountdownSeconds` - 考试倒计时
- `maxCollectedQuestions` - 收藏题目最大数
- `maxWrongQuestions` - 错题本最大数

### UI配置
- `primaryColorValue` - 主题色
- `successColorValue` - 成功色
- `warningColorValue` - 警告色
- `errorColorValue` - 错误色
- `defaultAvatarUrl` - 默认头像
- `networkTimeoutSeconds` - 网络超时时长

### 分页配置
- `defaultPageSize` - 默认每页数量 = 20
- `questionBankPageSize` - 题库每页数量 = 10
- `coursePageSize` - 课程每页数量 = 15
- `orderPageSize` - 订单每页数量 = 10

### 支付配置
- `paymentTimeoutSeconds` - 支付超时(秒)
- `orderAutoCancelMinutes` - 订单自动取消(分钟)
- `minPaymentAmount` - 最小支付金额
- `maxPaymentAmount` - 最大支付金额

### 正则表达式
- `phoneRegex` - 手机号正则
- `emailRegex` - 邮箱正则
- `idCardRegex` - 身份证号正则
- `passwordRegex` - 密码正则

### 错误提示
- `networkErrorMsg` - 网络错误提示
- `serverErrorMsg` - 服务器错误提示
- `emptyDataMsg` - 数据为空提示
- `tokenExpiredMsg` - 登录过期提示

## 环境配置 (ApiConfig)

### 切换环境

```dart
// 仅在Debug模式下可用
ApiConfig.switchEnv('test');  // 切换到测试环境
ApiConfig.switchEnv('prod');  // 切换到生产环境
ApiConfig.switchEnv('dev');   // 切换到开发环境

// 获取当前环境
final env = ApiConfig.currentEnv;

// 获取当前BaseURL
final baseUrl = ApiConfig.baseUrl;
```

### 环境说明

- **prod** (生产环境): `https://yakaixin.yunsop.com/api`
- **test** (测试环境): `https://xypaytest.jinyingjie.com/api`
- **dev** (开发环境): `/api` (需要配置本地代理)

## 注意事项

1. **微信AppID区分**:
   - `AppConstants.wechatAppId` = `wx832d03ed24df9a75` - 用于**微信支付、分享**等原生功能
   - `ApiConfig.wechatMiniProgramAppId` = `wxf787cf63760d80a0` - 用于**跳转小程序**等

2. **常量命名规范**:
   - 类名使用 `PascalCase`: `AppConstants`
   - 常量名使用 `camelCase`: `wechatAppId`
   - 颜色值常量后缀 `Value`: `primaryColorValue`
   - 正则表达式后缀 `Regex`: `phoneRegex`
   - 错误提示后缀 `Msg`: `networkErrorMsg`

3. **不要硬编码**:
   ```dart
   // ❌ 错误 - 硬编码
   if (phoneNumber.length == 11) { }
   
   // ✅ 正确 - 使用常量
   if (RegExp(AppConstants.phoneRegex).hasMatch(phoneNumber)) { }
   ```

4. **添加新常量**:
   - 在 `app_constants.dart` 中对应分类下添加
   - 添加注释说明用途
   - 更新本README文档

## 初始化

在 `main.dart` 中已自动初始化:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化微信SDK (使用 AppConstants.wechatAppId)
  await PaymentService.initWechat();
  
  // ... 其他初始化
}
```

## 修改记录

- **2024-01-XX**: 创建 `app_constants.dart`,统一管理全局常量
- **2024-01-XX**: 更新微信AppID为 `wx832d03ed24df9a75`
- **2024-01-XX**: 添加支付相关配置常量
