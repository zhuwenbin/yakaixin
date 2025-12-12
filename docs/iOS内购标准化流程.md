# iOS 内购标准化流程

## 📌 产品ID规则

**标准格式**: `bundle_id.goods_id`

**示例**:
```
Bundle ID:      com.yakaixin.yakaixin
商品ID (后台):   123
产品ID (苹果):   com.yakaixin.yakaixin.123
```

---

## 🔄 完整购买流程

### 1. 用户选择商品

用户在应用中浏览商品列表，选择要购买的商品。

**商品数据来源**: `/c/goods/v2`
```json
{
  "id": "123",              // 商品ID
  "name": "2024年护士资格考试题库",
  "amount": "298.00",       // 价格
  "type": "18"              // 类型：18-题库, 8-试卷, 10-模拟考试
}
```

### 2. 创建订单

调用后台接口创建订单，获取 `order_id`。

**接口**: 根据业务逻辑创建订单
**返回**: `order_id`

### 3. 生成苹果产品ID

```dart
// 代码中自动生成
String productId = getProductId(goodsId);
// 结果: "com.yakaixin.yakaixin.123"
```

### 4. 查询苹果产品信息

向 App Store 查询产品详情（价格、标题、描述）。

```dart
final products = await queryProducts({productId});
final product = products.first;

print('产品标题: ${product.title}');
print('产品价格: ${product.price}');
```

**日志示例**:
```
🔍 开始查询产品...
   产品ID列表: {com.yakaixin.yakaixin.123}
📊 查询结果:
   找到产品数: 1
✅ 找到的产品详情:
   - ID: com.yakaixin.yakaixin.123
     标题: 2024年护士资格考试题库
     价格: ¥298.00
```

### 5. 发起苹果支付

调用 StoreKit API 发起购买请求。

```dart
final purchaseParam = PurchaseParam(
  productDetails: product,
  applicationUserName: studentId,  // 用户ID
);

await _iap.buyNonConsumable(purchaseParam: purchaseParam);
```

**日志示例**:
```
💳 步骤2: 发起购买...
✅ 购买请求已发送，等待用户确认...
```

### 6. 用户确认支付

用户在系统弹窗中确认购买：
- Face ID / Touch ID 验证
- 或输入 Apple ID 密码

### 7. 接收购买回调

```dart
void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
  for (final purchaseDetails in purchaseDetailsList) {
    switch (purchaseDetails.status) {
      case PurchaseStatus.purchased:
        // ✅ 购买成功
        _verifyAndFinishTransaction(purchaseDetails);
        break;
      case PurchaseStatus.error:
        // ❌ 购买失败
        break;
      case PurchaseStatus.canceled:
        // 🚫 用户取消
        break;
    }
  }
}
```

**日志示例**:
```
📬 收到购买更新: purchased
✅ 购买成功！开始验证收据...
```

### 8. 获取收据数据

从 App Store 获取购买收据（Base64编码）。

```dart
final receiptData = await SKReceiptManager.retrieveReceiptData();
```

**日志示例**:
```
🔐 步骤3: 验证收据...
✅ 收据获取成功，长度: 2048
```

### 9. 后端验证收据

将收据发送到后端验证，后端会向苹果服务器验证收据真实性。

```dart
await _paymentService.verifyIAPReceipt(
  orderId: orderId,
  goodsId: goodsId,
  receiptData: receiptData,
  transactionId: purchaseDetails.purchaseID,
  productId: purchaseDetails.productID,
  studentId: studentId,
);
```

**后端接口**: `POST /c/pay/iap/verify`

**请求参数**:
```json
{
  "order_id": "order_123456",
  "goods_id": "123",
  "receipt_data": "MIITvAYJKoZIhvc...",
  "transaction_id": "1000000876543210",
  "product_id": "com.yakaixin.yakaixin.123",
  "student_id": "user_789"
}
```

**日志示例**:
```
🌐 步骤4: 调用后端验证...
✅ 收据验证成功，权限已开通
```

### 10. 完成交易

通知 Apple 交易已完成，避免重复购买。

```dart
await _iap.completePurchase(purchaseDetails);
```

**日志示例**:
```
✔️ 步骤5: 结束交易...
🎉 ========== 内购流程完成 ==========
```

---

## 📊 数据流向图

```
┌─────────────┐
│   用户选择    │
│   商品       │
└──────┬──────┘
       │
       ▼
┌─────────────┐      ┌─────────────┐
│  创建订单    │ ──→  │  后台返回    │
│             │      │  order_id   │
└──────┬──────┘      └─────────────┘
       │
       ▼
┌─────────────────────────────┐
│  生成产品ID                  │
│  com.yakaixin.yakaixin.123  │
└──────┬──────────────────────┘
       │
       ▼
┌─────────────┐      ┌─────────────┐
│  查询产品    │ ──→  │  App Store  │
│  详情       │      │  返回价格    │
└──────┬──────┘      └─────────────┘
       │
       ▼
┌─────────────┐
│  发起购买    │
│  请求       │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  用户确认    │
│  支付       │
└──────┬──────┘
       │
       ▼
┌─────────────┐      ┌─────────────┐
│  获取收据    │ ──→  │  App Store  │
│             │      │  返回收据    │
└──────┬──────┘      └─────────────┘
       │
       ▼
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│  后端验证    │ ──→  │  后台转发    │ ──→  │  Apple验证   │
│  收据       │      │  到Apple    │      │  服务器      │
└──────┬──────┘      └─────────────┘      └─────────────┘
       │
       ▼
┌─────────────┐
│  开通权限    │
│  完成交易    │
└─────────────┘
```

---

## 🔑 关键代码实现

### 产品ID生成

```dart
// lib/features/payment/services/iap_service.dart

/// 生成苹果产品ID
/// 
/// 规则：bundle_id.goods_id
/// 例如：goods_id = "123" → product_id = "com.yakaixin.yakaixin.123"
String getProductId(String goodsId) {
  const bundleId = 'com.yakaixin.yakaixin';
  return '$bundleId.$goodsId';
}
```

### 购买方法

```dart
/// 发起购买
/// 
/// 参数：
/// - orderId: 订单ID（必需）
/// - goodsId: 商品ID（必需，用于生成苹果产品ID）
/// - studentId: 学生ID（必需）
/// - goodsName: 商品名称（可选，用于展示）
Future<bool> purchase({
  required String orderId,
  required String goodsId,
  required String studentId,
  String? goodsName,
}) async {
  // 1. 生成产品ID
  final productId = getProductId(goodsId);
  
  // 2. 查询产品信息
  final products = await queryProducts({productId});
  if (products.isEmpty) {
    throw Exception('未找到产品ID: $productId');
  }
  
  // 3. 发起购买
  final purchaseParam = PurchaseParam(
    productDetails: products.first,
    applicationUserName: studentId,
  );
  
  return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
}
```

---

## 🛠️ App Store Connect 配置

### 创建内购产品

1. **产品ID**: `com.yakaixin.yakaixin.{goods_id}`
   - 示例: `com.yakaixin.yakaixin.123`

2. **价格等级**: 必须与后台商品价格一致
   - ¥1.00 = Tier 1
   - ¥298.00 = Tier 298

3. **本地化信息**（中文简体）:
   - 显示名称: `2024年护士资格考试题库`
   - 描述: `包含3580道精选题目，助你轻松通过考试`

4. **提交审核**: 产品状态必须为"等待审核"或"已批准"才能在沙盒环境测试

### Bundle ID 配置

确保以下配置一致：
- App Store Connect 应用 Bundle ID
- Xcode 项目 Bundle ID
- 代码中的 `bundleId` 常量

---

## 🧪 测试清单

### 准备工作

- [ ] ✅ 从后台获取商品列表
- [ ] ✅ 在 App Store Connect 为每个商品创建对应的内购产品
- [ ] ✅ 产品ID格式正确: `com.yakaixin.yakaixin.{goods_id}`
- [ ] ✅ 价格与后台一致
- [ ] ✅ 产品已提交审核
- [ ] ✅ 创建沙盒测试账号
- [ ] ✅ 设备登录沙盒账号

### 测试步骤

1. **查询产品**:
   ```
   ✅ 日志显示: "找到产品数: 1"
   ✅ 产品价格正确
   ```

2. **发起购买**:
   ```
   ✅ 显示 Apple 支付弹窗
   ✅ 价格显示正确
   ```

3. **完成支付**:
   ```
   ✅ 收据验证成功
   ✅ 权限已开通
   ✅ 交易已完成
   ```

4. **验证结果**:
   ```
   ✅ 用户可以访问购买的内容
   ✅ 后台订单状态更新
   ```

---

## ❓ 常见问题

### Q: 产品ID必须包含 Bundle ID 吗？
**A**: 是的，这是标准化规则。`product_id = bundle_id.goods_id`

### Q: 如果后台商品ID很长怎么办？
**A**: 没关系，苹果产品ID支持长ID。例如: `com.yakaixin.yakaixin.595918548996463431`

### Q: 价格必须完全一致吗？
**A**: 是的！后台 `amount` 字段和 App Store Connect 价格等级必须对应。

### Q: 可以动态创建产品吗？
**A**: 不可以。所有产品必须在 App Store Connect 中预先创建。

### Q: 测试时需要真实付费吗？
**A**: 不需要。沙盒环境所有交易都是模拟的。

---

## 📚 相关文档

- [iOS内购配置检查清单](./iOS内购配置检查清单.md)
- [Apple 官方文档 - In-App Purchase](https://developer.apple.com/in-app-purchase/)
- [Flutter in_app_purchase 插件](https://pub.dev/packages/in_app_purchase)

---

**更新时间**: 2025-01-25  
**产品ID规则**: `bundle_id.goods_id`  
**Bundle ID**: `com.yakaixin.yakaixin`
