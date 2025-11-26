# 支付功能测试指南

## 🎯 测试目标

验证Flutter应用的微信支付流程能正常调起微信支付页面,确保支付流程走通。

## 📋 测试准备

### 1. 确保Mock模式已开启

支付测试使用Mock数据,无需真实后端接口:

```dart
// 在 lib/core/network/dio_client.dart 中确认
final mockEnabledProvider = StateProvider<bool>((ref) => true); // ✅ 设置为true
```

### 2. 微信SDK配置检查

已配置微信AppID:
- **开放平台AppID**: `wx832d03ed24df9a75`
- **Universal Link**: `https://yakaixin.yunsop.com/`

在 `main.dart` 中已自动初始化:
```dart
await PaymentService.initWechat();
```

## 🧪 测试步骤

### 方式1: 从课程商品详情页测试

1. **启动应用**
   ```bash
   cd /Users/mac/Desktop/vueToFlutter/yakaixin_app
   flutter run
   ```

2. **进入课程详情页**
   - 方式A: 从首页点击课程商品卡片
   - 方式B: 直接导航到 `/course-goods-detail`
   
3. **查看商品信息**
   - 商品名称: `2024口腔执业医师题库`
   - 价格: `¥299.00`
   - 权限状态: 未购买 (显示"立即报名"按钮)

4. **点击"立即报名"按钮**
   
   系统将自动执行以下流程:

   ```
   📱 支付流程开始
   ↓
   💳 步骤1: 创建订单
   API: POST /c/order/v2
   Mock返回: { order_id, flow_id, order_no }
   ↓
   💳 步骤2: 获取支付账户
   API: GET /c/config/finance/account
   Mock返回: 微信支付账户ID
   ↓
   💳 步骤3: 获取微信支付参数
   API: POST /c/pay/wechatpay/jsapi
   Mock返回: { appId, timeStamp, nonceStr, package, sign, ... }
   ↓
   💳 步骤4: 调起微信支付
   调用: PaymentService.requestWechatPayment()
   期待: 跳转到微信支付页面
   ```

5. **验证支付调起**
   - ✅ 应该能跳转到微信支付页面
   - ✅ 或者显示微信未安装/不支持的提示

## 📝 测试日志说明

### 正常流程日志输出

```bash
# 初始化
🚀 应用初始化完成
🚀 应用名称: 牙开心题库
🚀 应用版本: 1.4.14
💳 微信SDK初始化成功
💳 AppID: wx832d03ed24df9a75

# 点击"立即报名"
💳 开始支付流程:
💳 商品ID: 555343665594113147
💳 价格: 299.0
💳 月价格ID: 555343665594178683
💳 月数: 6

# 步骤1: 创建订单
🧪 Mock拦截: POST /c/order/v2
💳 创建订单成功: orderId=555343665594178686, flowId=123456789012345678

# 步骤2: 获取支付账户
🧪 Mock拦截: GET /c/config/finance/account
💳 获取支付账户成功: accountId=408559632588540699

# 步骤3: 获取支付参数
🧪 Mock拦截: POST /c/pay/wechatpay/jsapi

# 步骤4: 调起微信支付
💳 调起微信支付...
💳 AppID: wx832d03ed24df9a75
💳 包名: prepay_id=wx20241125123456789012345678901234
```

### 可能出现的情况

#### 情况1: 微信支付成功 ✅
```bash
💳 支付成功!
💳 支付成功,跳转支付成功页
```
- 跳转到支付成功页面
- 显示商品信息和"去学习"按钮

#### 情况2: 用户取消支付 ℹ️
```bash
💳 支付失败或取消
💳 错误码: -2
💳 错误信息: 用户取消支付
```
- 留在当前页面
- 显示Toast: "支付失败"

#### 情况3: 支付出错 ❌
```bash
💳 支付失败: [错误信息]
💳 支付异常: [详细错误]
```
- 检查微信SDK是否正确初始化
- 检查微信AppID是否正确
- 检查Universal Link配置

## 🔧 Mock数据说明

### 商品信息
位置: `lib/core/mock/data/course_goods_profile_mock_data.dart`

```dart
{
  'id': '555343665594113147',
  'name': '2024口腔执业医师题库',
  'sale_price': '299.00',
  'permission_status': '2', // 2=未购买
  'goods_months_price_id': '555343665594178683',
  'month': 6,
}
```

### 创建订单响应
```dart
{
  'code': 100000,
  'data': {
    'order_id': '555343665594178686',
    'flow_id': '123456789012345678',
    'order_no': 'YKX202411251234567891',
  }
}
```

### 微信支付参数
```dart
{
  'code': 100000,
  'data': {
    'app_id': 'wx832d03ed24df9a75',
    'time_stamp': '1732502400',
    'nonce_str': 'abcdef1234567890',
    'package': 'prepay_id=wx20241125123456789012345678901234',
    'sign_type': 'MD5',
    'pay_sign': 'ABCDEF1234567890ABCDEF1234567890',
    'partner_id': '1234567890',
    'prepay_id': 'wx20241125123456789012345678901234',
  }
}
```

## ✅ 验证要点

### 必须验证的点

1. **支付按钮显示正确**
   - 未购买商品显示"立即报名"
   - 已购买商品显示"去学习"

2. **支付流程完整**
   - 能正常创建订单(Mock)
   - 能正常获取支付参数(Mock)
   - 能调起微信支付SDK

3. **错误处理**
   - 网络错误有友好提示
   - 支付取消有正确反馈
   - 支付失败有重试机制

4. **日志输出清晰**
   - 每个步骤都有日志标记
   - 关键参数都有输出
   - 错误信息详细准确

## 🚀 实际支付测试(需要后端支持)

当后端接口可用时,将Mock模式关闭:

```dart
// lib/core/network/dio_client.dart
final mockEnabledProvider = StateProvider<bool>((ref) => false);
```

然后执行相同的测试步骤,此时将调用真实API。

### 真实支付注意事项

1. **微信商户号配置**
   - 确保后端配置了正确的商户号
   - 确保商户号已开通微信支付

2. **测试金额**
   - 使用小额金额测试(如0.01元)
   - 测试后及时退款

3. **iOS配置**
   - Universal Link必须正确配置
   - 需要上传到真实服务器

4. **Android配置**
   - 需要在微信开放平台配置应用签名
   - 需要使用正式签名的包测试

## 📞 问题排查

### 问题1: 微信未安装

**现象**: 提示"未安装微信"或"不支持微信支付"

**解决**:
- iOS: 确保设备已安装微信
- Android: 确保设备已安装微信

### 问题2: 支付参数错误

**现象**: 微信返回"签名错误"或"参数错误"

**检查**:
1. AppID是否正确
2. 时间戳格式是否正确
3. Sign签名是否正确
4. Package格式是否正确

### 问题3: 无法跳转微信

**现象**: 点击支付无反应

**检查**:
1. URL Scheme配置 (iOS)
2. Universal Link配置 (iOS)
3. 应用签名配置 (Android)
4. 微信SDK初始化是否成功

## 📚 相关文件

- 支付服务: `lib/core/payment/payment_service.dart`
- 支付Provider: `lib/features/order/providers/payment_provider.dart`
- 课程详情页: `lib/features/goods/views/course_goods_detail_page.dart`
- Mock数据: `lib/core/mock/data/course_goods_profile_mock_data.dart`
- Mock路由: `lib/core/mock/mock_data_router.dart`
- 全局配置: `lib/app/constants/app_constants.dart`

## 🎉 测试成功标志

看到以下输出表示支付流程已走通:

```bash
💳 支付成功!
💳 支付成功,跳转支付成功页
```

或者能正常调起微信支付页面(即使最后取消支付),都说明集成成功! 🎊
