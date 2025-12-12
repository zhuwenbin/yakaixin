# 📋 iOS 内购票据保存说明

## 票据数据来源

票据（Receipt）是由 Apple 系统生成的 Base64 编码字符串，包含完整的购买信息。

### 获取方式

```dart
// 1. 从本地 App Store 读取
final receiptData = await SKReceiptManager.retrieveReceiptData();

// 2. 如果为空，刷新后重新获取
if (receiptData == null || receiptData.isEmpty) {
  await SKRequestMaker().startRefreshReceiptRequest();
  final newReceiptData = await SKReceiptManager.retrieveReceiptData();
}
```

---

## 票据保存位置

### 1. 自动保存到 txt 文件

**文件路径** (应用文档目录):
```
iOS: /var/mobile/Containers/Data/Application/<UUID>/Documents/piaoju.txt
Android: /data/user/0/com.yakaixin.yakaixin/app_flutter/piaoju.txt
```

**触发时机**:
- ✅ 每次成功获取票据后自动保存
- ✅ 在 `_verifyAndFinishTransaction()` 方法中的第476行调用
- ✅ 在清理模式下也会保存（用于调试）

**实现代码** (iap_service.dart 第718-740行):
```dart
Future<void> _saveReceiptToFile(String receiptData) async {
  // ✅ 使用应用文档目录（iOS/Android 通用）
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/piaoju.txt';
  
  final file = File(filePath);
  await file.writeAsString(receiptData);
  
  print('✅ 票据数据已成功写入文件！');
  print('   文件大小: ${receiptData.length} 字符');
  print('   存储位置: 应用文档目录/piaoju.txt');
  print('   完整路径: $filePath');
}
```

**如何查看文件**:

1. **iOS 模拟器**:
   ```bash
   # 查看应用文档目录
   # 从日志中复制完整路径，然后:
   cat /var/mobile/Containers/Data/Application/<UUID>/Documents/piaoju.txt
   ```

2. **iOS 真机**:
   - 使用 Xcode -> Window -> Devices and Simulators
   - 选择设备 -> 选择应用
   - 下载 Container -> 查看 Documents/piaoju.txt

3. **Android**:
   ```bash
   adb shell run-as com.yakaixin.yakaixin cat app_flutter/piaoju.txt
   ```

---

### 2. 保存到本地缓存（用于补发重试）

**存储方式**：SharedPreferences

**触发时机**：
- ✅ 后端验证失败时保存
- ✅ 用于后续自动补发重试

**实现代码**（iap_service.dart 第543-556行）：
```dart
if (receiptData != null && receiptData.isNotEmpty) {
  await IAPReceiptCache.saveFailedReceipt(
    orderId: _currentOrderId!,
    goodsId: _currentGoodsId!,
    studentId: _currentStudentId!,
    receiptData: receiptData,  // ← 票据数据
    productId: purchaseDetails.productID,
    transactionId: purchaseDetails.purchaseID ?? '',
  );
}
```

---

### 3. 打印到控制台日志

**触发时机**：
- ✅ 第一次获取时打印（第657行）
- ✅ 刷新后重新获取时打印（第683行）
- ✅ 日志输出完整票据内容

**日志格式**：
```
🎯 第一次获取的收据数据:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
MIIUVQYJKoZIhvcNAQcCoIIURjCCFEICAQExDzANBglghkgBZQ...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 票据数据用途

### 1. 发送给后端验证

**接口**：`POST /c/pay/iap/verify`

**请求参数**：
```dart
{
  "order_id": "订单ID",
  "goods_id": "商品ID",
  "receipt_data": "Base64编码的票据数据",  // ← 票据
  "transaction_id": "苹果交易ID",
  "product_id": "com.yakaixin.yakaixin.123",
  "student_id": "学生ID"
}
```

**代码位置**：iap_service.dart 第477-484行

---

### 2. 补发重试机制

当后端验证失败时：
1. ✅ 票据保存到 SharedPreferences
2. ✅ 应用启动时自动检查
3. ✅ 自动重试验证请求
4. ✅ 验证成功后清除缓存

**补发入口**：
- 应用启动时调用 `retryFailedReceipts()`
- 进入个人中心时调用

---

## 票据数据格式

### Base64 编码字符串

```
MIIUVQYJKoZIhvcNAQcCoIIURjCCFEICAQExDzANBglghkgBZQMEAgEFADCCA3wGCSqGSIb3DQEHAaCC...
```

### 包含信息

- ✅ 交易ID（Transaction ID）
- ✅ 产品ID（Product ID）
- ✅ 购买时间（Purchase Date）
- ✅ 购买数量（Quantity）
- ✅ 应用Bundle ID
- ✅ 收据签名（用于验证真实性）

---

## 日志追踪

### 在 Terminal 日志中查找票据

**搜索关键字**：
- `🎯 第一次获取的收据数据`
- `🎯 第二次获取的收据数据`
- `验证数据:`
- `本地验证:`

**示例日志**（Terminal 487-496）：
```
flutter: 📦 处理购买更新 1/1
flutter:    购买状态: PurchaseStatus.restored
flutter:    产品ID: com.yakaixin.yakaixin.595918548996463431
flutter:    交易ID: 2000001079476252
flutter:    验证数据: MIIUVQYJKoZIhvcNAQcCoIIURjCCFEICAQExDzANBglghkgBZQ...
flutter:    本地验证: MIIUVQYJKoZIhvcNAQcCoIIURjCCFEICAQExDzANBglghkgBZQ...
```

---

## 文件使用说明

### 查看票据文件

**iOS 模拟器**:
```bash
# 从日志中找到完整路径，然后:
cat /var/mobile/Containers/Data/Application/<UUID>/Documents/piaoju.txt
```

**iOS 真机**:
1. 打开 Xcode
2. Window -> Devices and Simulators
3. 选择设备 -> 选择应用 "YaKaiXin"
4. 下载 Container
5. 查看 `Documents/piaoju.txt`

**Android**:
```bash
adb shell run-as com.yakaixin.yakaixin cat app_flutter/piaoju.txt
```

### 文件内容

- ✅ 完整的 Base64 编码票据数据
- ✅ 每次购买都会覆盖更新
- ✅ 仅包含最新一次的票据
- ✅ 存储在应用文档目录（私有，安全）

### 注意事项

⚠️ **敏感数据**:
- 票据文件包含购买信息
- 存储在应用文档目录（私有空间）
- 卸载应用时会自动删除
- 不要分享给他人

⚠️ **文件路径**:
- iOS 每次安装应用，UUID 会变化
- 使用 `getApplicationDocumentsDirectory()` 获取
- 日志中会打印完整路径
- 需要从日志中复制实际路径

⚠️ **开发调试**:
- 票据保存仅用于调试
- 生产环境不应依赖此文件
- 建议使用日志查看票据内容

---

## 相关代码文件

| 文件 | 说明 |
|------|------|
| `iap_service.dart` | iOS 内购服务（包含票据获取和保存） |
| `balance_service.dart` | 后端验证接口调用 |
| `iap_receipt_cache.dart` | 票据缓存管理（补发重试） |
| `piaoju.txt` | 票据数据文件（自动生成） |

---

## 开发建议

### 调试时查看票据

1. ✅ 查看控制台日志（完整票据内容）
2. ✅ 打开 `piaoju.txt` 文件查看
3. ✅ 使用在线 Base64 解码工具解析（仅用于调试）

### 验证票据数据

```bash
# 从日志中获取完整路径，然后查看
# iOS 模拟器示例:
cat /var/mobile/Containers/Data/Application/ABC123.../Documents/piaoju.txt

# 查看文件大小
ls -lh /var/mobile/Containers/Data/Application/ABC123.../Documents/piaoju.txt
```

---

**最后更新时间**: 2025-11-25
**相关文档**: iOS内购日志说明.md, iOS内购标准化流程.md
