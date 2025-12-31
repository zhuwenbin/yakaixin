# iOS 内购流程梳理与修复

**更新时间**: 2025-01-25  
**问题**: 支付完成后一直显示"正在验证"，没有超时保护

---

## 🔴 确认的问题

### 用户反馈

```
第一次支付有问题：
1. 输入支付密码 ✅
2. 点击系统的"完成支付"按钮（沙盒弹框）✅
3. 系统提示："您已支付完成" ✅
4. 但应用还在显示"正在验证..." ❌
5. 一直卡住，没有任何反应 ❌
```

### 根本原因

```
1. ❌ 不必要的延迟提示
   - 1.5秒后自动显示"正在验证..."
   - 但这时用户可能还在输入密码
   - 提示不准确

2. ❌ 没有超时保护
   - 如果回调丢失
   - UI 会永远显示"正在验证..."
   - 用户无法操作

3. ⚠️ StoreKit 回调可能丢失
   - 沙盒环境不稳定
   - 偶尔会出现回调丢失
   - 代码没有兜底机制
```

---

## ✅ 正确的 iOS 内购流程

### 标准流程（Apple 官方）

```
┌──────────────────────────────────────────┐
│ 1. 应用启动                               │
└─────────────┬────────────────────────────┘
              ↓
┌──────────────────────────────────────────┐
│ 2. 初始化内购 (initialize)                │
│    - 检查平台                             │
│    - 监听购买流 (purchaseStream)          │
│    - 清理 pending transactions            │
└─────────────┬────────────────────────────┘
              ↓
┌──────────────────────────────────────────┐
│ 3. 用户点击购买                           │
└─────────────┬────────────────────────────┘
              ↓
┌──────────────────────────────────────────┐
│ 4. 查询产品信息 (queryProducts)           │
│    - 根据 productId 查询                  │
│    - 确认产品存在且可购买                 │
└─────────────┬────────────────────────────┘
              ↓
┌──────────────────────────────────────────┐
│ 5. 发起购买请求 (buyConsumable)           │
│    - 调用 StoreKit                        │
│    - 返回成功（仅表示请求已发送）          │
└─────────────┬────────────────────────────┘
              ↓
┌──────────────────────────────────────────┐
│ 6. StoreKit 弹出支付确认框                │
│    - 显示产品信息和价格                   │
│    - 等待用户操作                         │
│    ⚠️ 这个阶段应用无法控制                │
└─────────────┬────────────────────────────┘
              ↓
┌──────────────────────────────────────────┐
│ 7. 用户操作                               │
│    ├─ 点击"购买" → 继续                   │
│    ├─ 点击"取消" → 取消                   │
│    └─ 输入密码/Face ID → 验证             │
└─────────────┬────────────────────────────┘
              ↓
┌──────────────────────────────────────────┐
│ 8. 支付处理（Apple 服务器）               │
│    - 验证用户身份                         │
│    - 扣款处理                             │
│    - 生成交易记录                         │
│    ⚠️ 这个阶段应用无法控制                │
└─────────────┬────────────────────────────┘
              ↓
┌──────────────────────────────────────────┐
│ 9. 支付结果回调 (_onPurchaseUpdate)       │
│    ⚡ 关键步骤！应用在这里收到结果         │
│                                           │
│    状态可能是：                            │
│    ├─ pending: 处理中                     │
│    ├─ purchased: ✅ 支付成功              │
│    ├─ error: ❌ 支付失败                  │
│    └─ canceled: 用户取消                  │
└─────────────┬────────────────────────────┘
              ↓
┌──────────────────────────────────────────┐
│ 10. 验证收据（如果支付成功）               │
│     - 立即保存收据到缓存（安全备份）       │
│     - 发送收据到后台服务器验证             │
│     - 等待验证结果                        │
└─────────────┬────────────────────────────┘
              ↓
┌──────────────────────────────────────────┐
│ 11. 完成交易                              │
│     验证成功：                             │
│     ├─ 删除缓存的收据                     │
│     ├─ 调用 completePurchase()            │
│     ├─ 开通用户权限                       │
│     └─ 通知 UI 成功                       │
│                                           │
│     验证失败：                             │
│     ├─ 保留缓存的收据                     │
│     ├─ 调用 completePurchase()            │
│     └─ 下次启动自动补发                   │
└─────────────┬────────────────────────────┘
              ↓
┌──────────────────────────────────────────┐
│ 12. UI 更新                               │
│     - 关闭 Loading                        │
│     - 显示成功/失败提示                   │
│     - 跳转到相应页面                      │
└──────────────────────────────────────────┘
```

---

## 🔍 当前代码问题分析

### 问题 1: 不准确的延迟提示

**当前代码（confirm_payment_page.dart）**：

```dart
// ❌ 问题代码
EasyLoading.show(status: '正在支付...');

await paymentService.pay(...);

// ❌ 1.5秒后自动更新为"正在验证..."
Future.delayed(const Duration(milliseconds: 1500), () {
  if (!completer.isCompleted && !isPurchaseCompleted) {
    EasyLoading.show(status: '正在验证...');
    print('   💡 提示已更新：正在验证收据');
  }
});

await completer.future;  // 等待回调
```

**问题**：
- 1.5秒时，用户可能还在看支付确认框
- 或者刚开始输入密码
- 根本还没完成支付
- 就显示"正在验证..."了

**时间线**：
```
00:00  点击购买 → "正在支付..."
00:01  弹出支付框
00:01  ❌ "正在验证..." (但用户还没输入密码！)
00:05  用户输入密码
00:08  点击"购买"
00:10  支付完成
```

### 问题 2: 没有超时保护

**当前代码**：

```dart
await completer.future;  // ❌ 无限等待
```

**问题**：
- 如果 StoreKit 回调丢失
- completer 永远不会 complete
- UI 一直显示"正在验证..."
- 没有任何超时机制

### 问题 3: 清理模式的限制

**当前代码（iap_service.dart）**：

```dart
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
- 清理模式在购买之前运行（应用启动时）
- 只有 3 秒超时
- 如果当前正在购买的交易回调丢失
- 清理模式无法帮助
- 因为清理模式已经在 3 秒前完成了

---

## 🔧 修复方案

### 修复 1: 删除不准确的延迟提示

**修改 confirm_payment_page.dart**：

```dart
// ✅ 修复后的代码

// 显示初始提示
EasyLoading.show(status: '请完成支付确认...');

// ❌ 删除这段不准确的延迟更新
/*
Future.delayed(const Duration(milliseconds: 1500), () {
  if (!completer.isCompleted && !isPurchaseCompleted) {
    EasyLoading.show(status: '正在验证...');
    print('   💡 提示已更新：正在验证收据');
  }
});
*/

// 发起支付
await paymentService.pay(
  callback: (success, errorMessage) {
    // ✅ 只在回调时更新 UI
    if (!completer.isCompleted) {
      completer.complete(...);
    }
  },
);

// 等待回调
await completer.future;
```

### 修复 2: 添加超时保护

**添加 30 秒超时**：

```dart
// ✅ 添加超时保护

bool isTimeout = false;
Timer? timeoutTimer;

timeoutTimer = Timer(const Duration(seconds: 30), () {
  if (!completer.isCompleted && !isPurchaseCompleted) {
    debugPrint('⚠️ 支付超时，回调未收到');
    isTimeout = true;
    
    completer.complete(
      wechat_pay.PaymentResult.failed(
        '支付超时\n如已完成支付，请重启应用查看权限'
      )
    );
  }
});

// 发起支付
await paymentService.pay(
  callback: (success, errorMessage) {
    if (!completer.isCompleted && !isTimeout) {
      timeoutTimer?.cancel();  // ✅ 取消超时
      completer.complete(...);
    }
  },
);

// 等待回调或超时
await completer.future;
timeoutTimer?.cancel();
```

### 修复 3: 改进 UI 提示

**更准确的提示文案**：

```dart
// ✅ 改进提示文案

// 初始提示（更准确）
EasyLoading.show(status: '请完成支付确认...');

// 超时提示（更有帮助）
'支付超时\n如已完成支付，请重启应用查看权限'
```

---

## ✅ 修复后的完整流程

### 用户视角

```
1. 点击"确认支付"
   ↓
   UI: "请完成支付确认..."
   
2. 弹出支付框
   ↓
   UI: 仍然"请完成支付确认..."
   
3. 输入密码/Face ID
   ↓
   UI: 仍然"请完成支付确认..."
   
4. 点击"购买"
   ↓
   UI: 仍然"请完成支付确认..."
   
5. 支付成功，收到回调
   ↓
   UI: 关闭 Loading → "支付成功！"
   
或者：

5. 30 秒后仍无回调
   ↓
   UI: 关闭 Loading → "支付超时\n如已完成支付，请重启应用查看权限"
```

### 代码流程

```dart
// 完整的修复后流程

Future<void> _handlePayment() async {
  try {
    setState(() => _isPaying = true);
    
    // 1️⃣ 显示准确的提示
    EasyLoading.show(status: '请完成支付确认...');
    
    // 2️⃣ 创建超时保护
    bool isTimeout = false;
    Timer? timeoutTimer;
    
    timeoutTimer = Timer(const Duration(seconds: 30), () {
      if (!completer.isCompleted && !isPurchaseCompleted) {
        debugPrint('⚠️ 支付超时');
        isTimeout = true;
        completer.complete(
          wechat_pay.PaymentResult.failed(
            '支付超时\n如已完成支付，请重启应用查看权限'
          )
        );
      }
    });
    
    // 3️⃣ 创建 Completer
    final completer = Completer<wechat_pay.PaymentResult>();
    bool isPurchaseCompleted = false;
    
    // 4️⃣ 发起支付
    await paymentService.pay(
      orderId: widget.orderId,
      flowId: widget.flowId,
      goodsId: widget.goodsId,
      financeBodyId: widget.financeBodyId,
      amount: widget.payableAmount,
      studentId: studentId,
      goodsName: widget.goodsName,
      onResult: (success, errorMessage) {
        // 5️⃣ 收到回调
        if (!completer.isCompleted && !isTimeout) {
          timeoutTimer?.cancel();  // 取消超时
          isPurchaseCompleted = true;
          
          debugPrint('\n👉 收到内购结果回调');
          debugPrint('   成功: $success');
          debugPrint('   错误: $errorMessage');
          
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
    
    // 6️⃣ 等待回调或超时
    debugPrint('   ⏳ 等待支付结果（30秒超时）...');
    final result = await completer.future;
    timeoutTimer?.cancel();
    
    // 7️⃣ 关闭 Loading
    EasyLoading.dismiss();
    
    // 8️⃣ 处理结果
    if (!result.isSuccess) {
      EasyLoading.showError(result.errorMessage ?? '支付失败');
      return;
    }
    
    // 9️⃣ 成功处理
    debugPrint('\n✅ 支付成功！');
    context.pop({'success': true});
    
  } catch (e) {
    debugPrint('\n❌ 支付异常: $e');
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

## 📊 修复对比

### 修复前 ❌

| 问题 | 表现 | 影响 |
|------|------|------|
| 提示不准确 | 1.5秒后就显示"正在验证" | 用户困惑 |
| 没有超时 | 回调丢失时永远卡住 | 用户无法操作 |
| 体验差 | 不知道发生了什么 | 用户焦虑 |

### 修复后 ✅

| 改进 | 效果 | 好处 |
|------|------|------|
| 准确提示 | "请完成支付确认..." | 用户明白 |
| 30秒超时 | 自动检测并提示 | 用户可操作 |
| 体验好 | 清晰的引导 | 用户放心 |

---

## 🎯 下一步：实施修复

### 需要修改的文件

1. **confirm_payment_page.dart**
   - 删除延迟提示
   - 添加超时保护
   - 改进提示文案

2. **不需要修改**
   - iap_service.dart（清理模式已经正确）
   - unified_payment_service.dart（逻辑已经正确）

### 修改重点

```dart
// confirm_payment_page.dart

// ❌ 删除
Future.delayed(const Duration(milliseconds: 1500), () {
  EasyLoading.show(status: '正在验证...');
});

// ✅ 添加
Timer(const Duration(seconds: 30), () {
  if (!completer.isCompleted) {
    completer.complete(失败);
  }
});
```

---

## ✅ 验证清单

### 修复完成后验证

- [ ] 删除了 1.5 秒延迟提示
- [ ] 添加了 30 秒超时保护
- [ ] 改进了提示文案
- [ ] 测试正常购买流程
- [ ] 测试超时场景
- [ ] 测试回调丢失场景

---

**准备好了吗？让我帮你实施这些修复！** 🚀

