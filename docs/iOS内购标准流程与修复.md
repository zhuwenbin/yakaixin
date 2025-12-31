# iOS 内购标准流程与修复方案

**更新时间**: 2025-01-25  
**问题**: 支付完成后回调丢失，UI 一直显示"正在验证"  
**目标**: 梳理正确流程，删除不必要逻辑，添加超时保护

---

## 📋 Apple 官方标准流程

### 完整流程图

```
┌─────────────────────────────────────────────────────────┐
│  步骤 1: 应用启动 - 初始化                               │
├─────────────────────────────────────────────────────────┤
│  1. 检查 InAppPurchase.isAvailable()                    │
│  2. 监听购买流：purchaseStream.listen(_onPurchaseUpdate) │
│  3. 清理 pending transactions (可选但推荐)               │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│  步骤 2: 用户点击购买                                    │
├─────────────────────────────────────────────────────────┤
│  1. 查询产品信息：queryProductDetails()                  │
│  2. 发起购买：buyConsumable(product)                     │
│  3. ⚡ 立即返回（非阻塞）                                │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│  步骤 3: StoreKit 处理（应用无法控制）                   │
├─────────────────────────────────────────────────────────┤
│  1. StoreKit 弹出支付确认框                              │
│  2. 用户输入密码/Face ID                                 │
│  3. Apple 服务器处理支付                                 │
│  4. 支付成功/失败/取消                                   │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│  步骤 4: 购买状态回调（关键！）                          │
├─────────────────────────────────────────────────────────┤
│  ⚡ 触发：_onPurchaseUpdate(purchaseDetailsList)         │
│                                                          │
│  状态判断：                                              │
│  ├─ pending: 正在处理                                   │
│  ├─ purchased: ✅ 支付成功 → 步骤 5                     │
│  ├─ error: ❌ 支付失败                                  │
│  ├─ canceled: 用户取消                                  │
│  └─ restored: 恢复购买（消耗型商品不应出现）             │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│  步骤 5: 验证收据（purchased 状态）                      │
├─────────────────────────────────────────────────────────┤
│  1. 获取收据：purchaseDetails.verificationData           │
│  2. 💾 立即保存收据到本地缓存（安全备份）                │
│  3. 发送到后台服务器验证                                 │
│  4. 等待验证结果                                         │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│  步骤 6: 完成交易                                        │
├─────────────────────────────────────────────────────────┤
│  验证成功：                                              │
│  ├─ 删除本地缓存的收据                                   │
│  ├─ completePurchase(purchaseDetails)                   │
│  ├─ 通知 UI：支付成功                                    │
│  └─ 用户权限已开通                                       │
│                                                          │
│  验证失败：                                              │
│  ├─ 保留本地缓存的收据                                   │
│  ├─ completePurchase(purchaseDetails) (避免重复扣款)    │
│  └─ 下次启动自动补发验证                                 │
└─────────────────────────────────────────────────────────┘
```

---

## 🔍 当前实现问题分析

### 问题 1: UI 提示不准确 ❌

**代码位置**: `confirm_payment_page.dart` Line 123-129

```dart
// ❌ 问题代码
Future.delayed(const Duration(milliseconds: 1500), () {
  if (!completer.isCompleted && !isPurchaseCompleted) {
    // 1.5秒后就显示"正在验证"
    EasyLoading.show(status: '正在验证...');
    print('   💡 提示已更新：正在验证收据');
  }
});
```

**问题**：
- 1.5 秒时用户可能还在输入密码
- 根本还没支付完成
- 提示不准确，误导用户

**正确做法**：
- 保持"请完成支付确认..."
- 只在收到回调后才更新提示

---

### 问题 2: 无超时保护 ❌

**代码位置**: `confirm_payment_page.dart` Line 132-133

```dart
// ❌ 问题代码
print('   ⏳ 等待支付结果...');
final result = await completer.future;  // ← 永远等待，无超时！
```

**问题**：
- 如果回调丢失，会永远等待
- UI 一直显示 Loading
- 用户无法操作

**正确做法**：
- 添加 30 秒超时
- 超时后提示用户重启应用

---

### 问题 3: 清理模式可能不够健壮 ⚠️

**代码位置**: `iap_service.dart` Line 105-129

```dart
// 当前代码
Future<void> _clearPendingTransactions() async {
  _isCleaningMode = true;
  await _iap.restorePurchases();
  
  try {
    await _cleaningCompleter!.future.timeout(const Duration(seconds: 3));
  } catch (e) {
    debugPrint('清理超时，可能没有待处理交易');
  }
  
  _isCleaningMode = false;
}
```

**问题**：
- 如果清理模式时有回调，但 `_currentOrderId` 等信息为空
- 无法保存收据（Line 389-391 的检查）
- 收据丢失

**正确做法**：
- 清理模式不应依赖 `_currentOrderId`
- 使用 transaction ID 作为临时标识
- 或者直接验证，不保存

---

## ✅ 修复方案

### 修复 1: 删除不准确的延迟更新

```dart
// confirm_payment_page.dart

// ❌ 删除这段代码
/*
Future.delayed(const Duration(milliseconds: 1500), () {
  if (!completer.isCompleted && !isPurchaseCompleted) {
    EasyLoading.show(status: '正在验证...');
    print('   💡 提示已更新：正在验证收据');
  }
});
*/

// ✅ 保持初始提示
EasyLoading.show(status: '请完成支付确认...');
```

---

### 修复 2: 添加超时保护

```dart
// confirm_payment_page.dart

Future<void> _handlePayment() async {
  try {
    setState(() => _isPaying = true);
    
    // ✅ 显示提示
    EasyLoading.show(status: '请完成支付确认...');
    
    final completer = Completer<wechat_pay.PaymentResult>();
    bool isPurchaseCompleted = false;
    bool isTimeout = false;
    
    // ✅ 添加 30 秒超时
    Timer? timeoutTimer;
    timeoutTimer = Timer(const Duration(seconds: 30), () {
      if (!completer.isCompleted && !isPurchaseCompleted) {
        isTimeout = true;
        debugPrint('⚠️ 支付超时（30秒无回调）');
        
        completer.complete(
          wechat_pay.PaymentResult.failed(
            '支付超时\n\n如已完成支付，请重启应用查看权限'
          )
        );
      }
    });
    
    // 发起购买
    await _paymentService.pay(
      orderId: widget.flowId,
      goodsId: widget.goodsId,
      amount: widget.payableAmount,
      financeBodyId: widget.financeBodyId,
      studentId: studentId,
      goodsName: widget.goodsName,
      callback: (success, errorMessage) {
        if (!completer.isCompleted && !isTimeout) {
          timeoutTimer?.cancel();  // ✅ 取消超时
          isPurchaseCompleted = true;
          
          debugPrint('👉 收到内购结果回调');
          debugPrint('   成功: $success');
          if (errorMessage != null) {
            debugPrint('   错误: $errorMessage');
          }
          
          if (success) {
            completer.complete(wechat_pay.PaymentResult.succeeded());
          } else {
            completer.complete(
              wechat_pay.PaymentResult.failed(errorMessage ?? '内购失败')
            );
          }
        }
      },
    );
    
    // 等待回调或超时
    print('   ⏳ 等待支付结果...');
    final result = await completer.future;
    
    // 关闭 Loading
    if (!isTimeout) {
      EasyLoading.dismiss();
    }
    
    if (!result.isSuccess) {
      EasyLoading.showError(
        result.errorMessage ?? '支付失败',
        duration: Duration(seconds: 3),
      );
      return;
    }
    
    // 成功处理...
    
  } catch (e) {
    print('\n❌ 支付异常: $e');
    EasyLoading.dismiss();
    EasyLoading.showError('支付失败: $e');
  } finally {
    if (mounted) {
      setState(() => _isPaying = false);
    }
  }
}
```

---

### 修复 3: 优化清理模式

```dart
// iap_service.dart

Future<void> _clearPendingTransactions() async {
  try {
    debugPrint('清理模式：开始');

    _isCleaningMode = true;
    _cleaningCompleter = Completer<void>();

    // 触发恢复购买
    await _iap.restorePurchases();

    try {
      // 等待 5 秒（给足够时间处理）
      await _cleaningCompleter!.future.timeout(const Duration(seconds: 5));
      debugPrint('清理模式：检测到交易并已处理');
    } catch (e) {
      debugPrint('清理超时，可能没有待处理交易');
    }

    _isCleaningMode = false;
    _cleaningCompleter = null;

    debugPrint('清理模式：完成');
  } catch (e) {
    debugPrint('清理交易错误: $e');
    _isCleaningMode = false;
    _cleaningCompleter = null;
  }
}
```

---

### 修复 4: 清理模式回调优化

```dart
// iap_service.dart - _onPurchaseUpdate 方法

// 清理模式：检查是否为已购买状态
if (_isCleaningMode) {
  // ✅ 如果是购买成功状态，尝试验证或保存
  if (purchaseDetails.status == PurchaseStatus.purchased) {
    debugPrint('⚠️ 清理模式检测到已购买交易');
    debugPrint('   产品ID: ${purchaseDetails.productID}');
    debugPrint('   交易ID: ${purchaseDetails.purchaseID}');
    
    final receiptData = purchaseDetails.verificationData.serverVerificationData;
    
    // ✅ 方案 1: 如果有订单信息，保存到缓存
    if (receiptData.isNotEmpty && 
        _currentOrderId != null && 
        _currentGoodsId != null) {
      debugPrint('   保存收据到缓存（有订单信息）');
      await IAPReceiptCache.saveFailedReceipt(
        orderId: _currentOrderId!,
        goodsId: _currentGoodsId!,
        financeBodyId: _currentFinanceBodyId ?? '',
        studentId: _currentStudentId ?? '',
        receiptData: receiptData,
        productId: purchaseDetails.productID,
        transactionId: purchaseDetails.purchaseID ?? '',
      );
      debugPrint('✅ 已保存收据到缓存，下次启动时自动验证');
    } 
    // ✅ 方案 2: 没有订单信息，使用交易 ID 作为临时标识
    else if (receiptData.isNotEmpty && purchaseDetails.purchaseID != null) {
      debugPrint('   保存收据到缓存（使用交易ID）');
      await IAPReceiptCache.saveFailedReceipt(
        orderId: purchaseDetails.purchaseID!,  // ← 使用交易ID
        goodsId: purchaseDetails.productID,
        financeBodyId: '',
        studentId: '',
        receiptData: receiptData,
        productId: purchaseDetails.productID,
        transactionId: purchaseDetails.purchaseID!,
      );
      debugPrint('✅ 已保存收据（临时标识），下次启动时自动验证');
    } else {
      debugPrint('⚠️ 收据为空或无交易ID，无法保存');
    }
  }
  
  // 完成交易
  _iap.completePurchase(purchaseDetails);
  
  // 通知清理完成
  if (i == purchaseDetailsList.length - 1 &&
      _cleaningCompleter != null &&
      !_cleaningCompleter!.isCompleted) {
    _cleaningCompleter!.complete();
  }
  continue;
}
```

---

## 📋 完整的正确流程

### 应用启动

```
1. 初始化 InAppPurchase
   ↓
2. 监听 purchaseStream
   ↓
3. 清理模式（5秒超时）
   ├─ 有回调：保存收据 → 完成交易
   └─ 无回调：超时结束
   ↓
4. 自动补发缓存的收据
```

### 用户购买

```
1. 点击购买按钮
   ↓
2. UI 显示："请完成支付确认..."
   ↓
3. 发起购买请求（非阻塞）
   ↓
4. 设置 30 秒超时
   ↓
5. 等待回调或超时
```

### StoreKit 处理

```
1. 弹出支付确认框
   ↓
2. 用户输入密码/Face ID
   ↓
3. Apple 服务器处理
   ↓
4. 触发回调：_onPurchaseUpdate
```

### 收到回调

```
1. 状态判断
   ├─ purchased: 继续处理
   ├─ error: 显示错误
   ├─ canceled: 显示取消
   └─ pending: 等待
   ↓
2. 获取收据数据
   ↓
3. 💾 立即保存到缓存
   ↓
4. 后台服务器验证
   ↓
5. 验证成功
   ├─ 删除缓存
   ├─ 完成交易
   └─ 通知 UI: 成功
   ↓
6. 验证失败
   ├─ 保留缓存
   ├─ 完成交易（避免重复扣款）
   └─ 下次启动补发
```

### 超时处理

```
30 秒无回调
   ↓
取消超时定时器
   ↓
完成 Completer
   ↓
关闭 Loading
   ↓
显示错误："支付超时，如已完成支付请重启应用"
```

---

## ✅ 修复后的预期效果

### 正常流程

```
用户点击购买
    ↓
"请完成支付确认..." (0-5秒)
    ↓
用户输入密码
    ↓
支付成功
    ↓
收到回调 (5-8秒)
    ↓
关闭 Loading
    ↓
"支付成功！" ✅
```

### 异常流程（回调丢失）

```
用户点击购买
    ↓
"请完成支付确认..." (0-30秒)
    ↓
用户输入密码
    ↓
支付成功
    ↓
❌ 回调丢失
    ↓
30 秒超时触发
    ↓
关闭 Loading
    ↓
显示："支付超时，如已完成支付请重启应用"
    ↓
用户重启应用
    ↓
清理模式检测到 pending transaction
    ↓
自动验证并开通 ✅
```

---

## 🔧 需要修改的文件

### 1. confirm_payment_page.dart

**修改内容**：
- ❌ 删除 1.5 秒延迟更新
- ✅ 添加 30 秒超时保护
- ✅ 修改提示为"请完成支付确认..."

### 2. iap_service.dart

**修改内容**：
- ✅ 清理模式超时改为 5 秒
- ✅ 清理模式回调优化（支持无订单信息的情况）
- ✅ 添加更详细的日志

---

## 📊 对比表

| 项目 | 修改前 | 修改后 |
|------|--------|--------|
| **UI 提示** | "正在支付..." → "正在验证..." | "请完成支付确认..." |
| **超时保护** | ❌ 无 | ✅ 30 秒 |
| **清理模式超时** | 3 秒 | 5 秒 |
| **清理模式回调** | 依赖订单信息 | 支持无订单信息 |
| **用户体验** | 可能卡死 | 超时后有提示 |

---

## ✅ 总结

### 删除的逻辑

```
❌ 1.5 秒延迟更新 UI 提示（不准确）
```

### 添加的逻辑

```
✅ 30 秒超时保护
✅ 超时后的用户提示
✅ 清理模式优化（支持无订单信息）
✅ 更详细的日志
```

### 流程验证

```
✅ 应用启动：初始化 → 清理模式 → 补发
✅ 用户购买：发起 → 等待 → 回调 → 验证 → 完成
✅ 异常处理：超时 → 提示 → 重启 → 自动补发
✅ 清理模式：检测 → 保存 → 完成 → 后续补发
```

**流程正确，需要按上述方案修复！** ✅

