# iOS 内购验证流程说明

**当前验证方式**: ✅ 后台验证（生产环境）  
**验证模式配置**: `_useServerVerification = true`  
**更新时间**: 2025-01-25

---

## 📋 验证流程概览

```
用户购买成功
    ↓
获取收据数据 (Receipt)
    ↓
发送到后台服务器验证
    ↓
后台服务器 → Apple验证服务器
    ↓
验证成功 → 开通权限 → 完成交易
    ↓
通知UI支付成功
```

---

## 🔄 完整验证流程

### 1. 用户购买成功

**触发时机**: 用户在系统弹窗中确认购买后

```dart
// 购买状态回调
case PurchaseStatus.purchased:
  debugPrint('购买状态：成功');
  _verifyAndFinishTransaction(purchaseDetails);
  break;
```

### 2. 获取收据数据

**位置**: `_verifyAndFinishTransaction` 方法

```dart
// 获取收据数据
receiptData = purchaseDetails.verificationData.serverVerificationData;

if (receiptData.isEmpty) {
  debugPrint('收据数据为空');
  await _iap.completePurchase(purchaseDetails);
  return;
}
```

**收据数据说明**:
- 格式: Base64 编码的字符串
- 内容: 包含用户所有历史购买记录（不仅仅是当前购买）
- 长度: 通常几千到几万字符

### 3. 选择验证方式

**配置**: `_useServerVerification = true` (后台验证)

```dart
// 根据配置选择验证方式
if (_useServerVerification) {
  // 🔥 后台验证（生产环境）
  debugPrint('开始后台验证...');
  final verifyResult = await _verifyReceiptWithServer(
    receiptData: receiptData,
    orderId: _currentOrderId!,
    financeBodyId: _currentFinanceBodyId!,
    productId: purchaseDetails.productID,      // ✅ 产品ID
    transactionId: purchaseDetails.purchaseID ?? '',  // ✅ 交易ID
  );
} else {
  // 🧪 本地验证（测试阶段，已废弃）
  debugPrint('开始苹果SDK本地验证...');
  final verifyResult = await _verifyReceiptWithApple(receiptData);
}
```

### 4. 后台验证请求

**接口**: `POST /c/pay/applepay`

**请求参数**:

```dart
final response = await _dioClient.post(
  '/c/pay/applepay',
  data: {
    'receipt_data': receiptData,                    // ✅ Apple收据（Base64）
    'flow_id': int.tryParse(orderId) ?? 0,          // ✅ 流水ID
    'finance_body_id': int.tryParse(financeBodyId) ?? 0,  // ✅ 财务主体ID
    'product_id': productId,                       // ✅ 当前购买的产品ID
    'transaction_id': transactionId,               // ✅ 当前交易ID
  },
);
```

**参数说明**:

| 参数 | 类型 | 说明 | 示例 |
|------|------|------|------|
| `receipt_data` | String | Apple收据（Base64编码） | `MIIUVQYJKoZIhvcNAQcC...` |
| `flow_id` | int | 流水ID（订单ID） | `123456789` |
| `finance_body_id` | int | 财务主体ID | `789` |
| `product_id` | String | 当前购买的产品ID | `com.yakaixin.yakaixin.9.9` |
| `transaction_id` | String | 当前交易ID | `2000001080123456` |

### 5. 后台服务器验证流程

**后台服务器需要执行**:

```python
def verify_receipt(receipt_data, flow_id, finance_body_id, product_id, transaction_id):
    # 1. 发送收据到Apple验证服务器
    apple_response = send_to_apple_verify_server(receipt_data)
    
    # 2. Apple返回所有历史购买记录
    all_purchases = apple_response['receipt']['in_app']
    # 例如：
    # [
    #   {
    #     'product_id': 'com.yakaixin.yakaixin.9.9',
    #     'transaction_id': '2000001079476252',
    #     'purchase_date': '2025-01-20'
    #   },
    #   {
    #     'product_id': 'com.yakaixin.yakaixin.19.9',
    #     'transaction_id': '2000001080123456',  # ← 当前交易
    #     'purchase_date': '2025-01-25'
    #   }
    # ]
    
    # 3. ✅ 根据 transaction_id 找到当前交易
    current_purchase = find_by_transaction_id(all_purchases, transaction_id)
    
    # 4. ✅ 验证 product_id 是否匹配
    if current_purchase['product_id'] != product_id:
        return error("产品ID不匹配")
    
    # 5. ✅ 验证通过，开通权限
    grant_permission(flow_id, product_id, transaction_id)
    
    # 6. ✅ 返回成功
    return {
        'code': 100000,
        'msg': ['验证成功'],
        'data': {...}
    }
```

### 6. 验证结果处理

**成功情况**:

```dart
if (code == 100000) {
  debugPrint('后台验证成功');
  
  // 完成交易
  await _iap.completePurchase(purchaseDetails);
  
  // 通知UI支付成功
  final cb = _paymentCallback;
  _paymentCallback = null;
  cb?.call(true, null);
  
  // 清理临时数据
  _currentOrderId = null;
  _currentGoodsId = null;
  _currentFinanceBodyId = null;
  _currentStudentId = null;
  
  debugPrint('内购流程完成');
}
```

**失败情况**:

```dart
if (code != 100000) {
  final errorMsg = result['msg'] is List 
      ? (result['msg'] as List).first.toString() 
      : result['msg']?.toString() ?? '验证失败';
  
  // 保存验证失败的收据到缓存
  await IAPReceiptCache.saveFailedReceipt(
    orderId: _currentOrderId!,
    goodsId: _currentGoodsId!,
    financeBodyId: _currentFinanceBodyId!,
    studentId: _currentStudentId!,
    receiptData: receiptData,
    productId: purchaseDetails.productID,
    transactionId: purchaseDetails.purchaseID ?? '',
  );
  
  // 完成交易（避免阻塞）
  await _iap.completePurchase(purchaseDetails);
  
  // 通知UI验证失败
  cb?.call(false, '收据验证失败，已保存数据，将自动重试: $errorMsg');
}
```

---

## 🔄 自动重试机制

### 补发验证失败的收据

**触发时机**:
- 应用启动时
- 进入个人中心时

**实现位置**: `retryFailedReceipts()` 方法

```dart
Future<void> retryFailedReceipts() async {
  // 1. 获取所有验证失败的收据
  final failedReceipts = await IAPReceiptCache.getFailedReceipts();
  
  if (failedReceipts.isEmpty) {
    return;
  }
  
  // 2. 逐个重试验证
  for (final receipt in failedReceipts) {
    try {
      final verifyResult = await _verifyReceiptWithServer(
        receiptData: receipt['receiptData'],
        orderId: receipt['orderId'],
        financeBodyId: receipt['financeBodyId'],
        productId: receipt['productId'],
        transactionId: receipt['transactionId'],
      );
      
      if (verifyResult['success']) {
        // ✅ 验证成功，清除缓存
        await IAPReceiptCache.removeFailedReceipt(receipt['orderId']);
      }
    } catch (e) {
      // ❌ 验证仍然失败，保留在缓存中
      debugPrint('验证仍然失败: $e');
    }
  }
}
```

---

## 📊 验证流程时序图

```
┌─────────┐      ┌──────────┐      ┌──────────┐      ┌──────────┐
│  用户    │      │  Flutter │      │  后台服务器 │      │  Apple   │
└────┬────┘      └────┬─────┘      └────┬─────┘      └────┬─────┘
     │                │                 │                 │
     │  1. 确认购买    │                 │                 │
     ├──────────────>│                 │                 │
     │                │                 │                 │
     │                │  2. 获取收据     │                 │
     │                │<────────────────┤                 │
     │                │                 │                 │
     │                │  3. 发送验证请求 │                 │
     │                ├────────────────>│                 │
     │                │                 │                 │
     │                │                 │  4. 验证收据    │
     │                │                 ├────────────────>│
     │                │                 │                 │
     │                │                 │  5. 返回验证结果 │
     │                │                 │<────────────────┤
     │                │                 │                 │
     │                │                 │  6. 开通权限    │
     │                │                 │  (内部处理)     │
     │                │                 │                 │
     │                │  7. 返回验证结果 │                 │
     │                │<────────────────┤                 │
     │                │                 │                 │
     │  8. 支付成功    │                 │                 │
     │<───────────────┤                 │                 │
     │                │                 │                 │
```

---

## 🔍 关键参数说明

### 为什么需要 `product_id` 和 `transaction_id`？

**问题**: Apple收据包含所有历史购买记录，不仅仅是当前购买

**示例收据结构**:

```json
{
  "receipt": {
    "bundle_id": "com.yakaixin.yakaixin",
    "in_app": [
      {
        "product_id": "com.yakaixin.yakaixin.9.9",
        "transaction_id": "2000001079476252",
        "purchase_date": "2025-01-20"
      },
      {
        "product_id": "com.yakaixin.yakaixin.19.9",
        "transaction_id": "2000001080123456",  // ← 当前购买
        "purchase_date": "2025-01-25"
      }
    ]
  }
}
```

**解决方案**:
- ✅ 通过 `transaction_id` 精确定位当前交易
- ✅ 通过 `product_id` 验证产品匹配
- ✅ 避免重复处理历史购买
- ✅ 准确关联订单流水

---

## 📝 日志输出示例

### 正常验证流程日志

```
flutter: 开始验证收据流程
flutter: 票据服务数据: MIIUVQYJKoZIhvcNAQcC...
flutter: 开始后台验证...
flutter: 后台验证：开始
flutter: 流水ID: 123456789
flutter: 财务主体ID: 789
flutter: 产品ID: com.yakaixin.yakaixin.9.9
flutter: 交易ID: 2000001080123456
flutter: 票据数据长度: 2048 字符
flutter: 后台验证响应: 200
flutter: 响应数据: {code: 100000, msg: [验证成功], data: {...}}
flutter: 后台验证成功 - 订单ID: 123456789
flutter: 内购流程完成
```

### 验证失败日志

```
flutter: 开始验证收据流程
flutter: 开始后台验证...
flutter: 后台验证响应: 200
flutter: 响应数据: {code: 100001, msg: [验证失败: 产品ID不匹配]}
flutter: 验证收据失败: Exception: 后台验证失败: 验证失败: 产品ID不匹配
flutter: 保存验证失败的收据到缓存
flutter: 收据验证失败，已保存数据，将自动重试: Exception: 后台验证失败: 验证失败: 产品ID不匹配
```

---

## ✅ 验证清单

### 前端检查项

- [x] ✅ 获取收据数据
- [x] ✅ 发送验证请求（包含所有必需参数）
- [x] ✅ 处理验证结果
- [x] ✅ 保存验证失败的收据
- [x] ✅ 自动重试验证失败的收据

### 后台检查项

- [ ] ✅ 接收验证请求
- [ ] ✅ 发送收据到Apple验证服务器
- [ ] ✅ 根据 `transaction_id` 定位当前交易
- [ ] ✅ 验证 `product_id` 是否匹配
- [ ] ✅ 开通用户权限
- [ ] ✅ 返回验证结果

---

## ⚠️ 注意事项

### 1. 验证模式配置

**当前配置**: `_useServerVerification = true` (后台验证)

```dart
// 验证模式：true=后台验证，false=本地验证（保留用于测试）
static const bool _useServerVerification = true;
```

**说明**:
- ✅ 生产环境必须使用后台验证
- ⚠️ 本地验证仅用于测试，已废弃

### 2. 收据数据完整性

**检查项**:
- ✅ 收据数据不能为空
- ✅ 订单信息必须完整（orderId, goodsId, studentId）
- ✅ 产品ID和交易ID必须存在

### 3. 错误处理

**失败处理策略**:
- ✅ 验证失败时保存收据到缓存
- ✅ 应用启动时自动重试
- ✅ 避免阻塞用户操作（完成交易）

### 4. 产品ID格式

**当前格式**: `com.yakaixin.yakaixin.{价格}`

**示例**:
- `com.yakaixin.yakaixin.9.9` (价格 ¥9.9)
- `com.yakaixin.yakaixin.19.9` (价格 ¥19.9)
- `com.yakaixin.yakaixin.298` (价格 ¥298)

---

## 📚 相关文档

- [iOS内购标准化流程](./iOS内购标准化流程.md)
- [票据验证参数完善说明](./票据验证参数完善说明.md)
- [内购流程检查报告](./内购流程检查报告.md)

---

**文档更新时间**: 2025-01-25  
**验证方式**: 后台验证（生产环境）

