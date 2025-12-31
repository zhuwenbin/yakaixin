# iOS 内购正确流程梳理与验证

**更新时间**: 2025-01-25  
**目的**: 梳理标准流程，验证当前实现，删除不必要的逻辑

---

## 🎯 标准 iOS 内购流程（Apple 官方）

### 完整时序图

```
用户操作                 应用层                  StoreKit              App Store 服务器
   │                      │                       │                        │
   │ 1. 点击购买           │                       │                        │
   │─────────────────────>│                       │                        │
   │                      │ 2. 查询产品            │                        │
   │                      │──────────────────────>│                        │
   │                      │<──────────────────────│                        │
   │                      │ 3. 产品信息返回        │                        │
   │                      │                       │                        │
   │                      │ 4. 发起购买请求        │                        │
   │                      │──────────────────────>│                        │
   │                      │ 5. 请求已发送 ✅       │                        │
   │                      │                       │                        │
   │                      │                       │ 6. 弹出支付确认框       │
   │<──────────────────────────────────────────────│                        │
   │                      │                       │                        │
   │ 7. 输入密码/Face ID   │                       │                        │
   │─────────────────────────────────────────────>│                        │
   │                      │                       │                        │
   │ 8. 点击"购买"         │                       │                        │
   │─────────────────────────────────────────────>│                        │
   │                      │                       │ 9. 验证账户            │
   │                      │                       │───────────────────────>│
   │                      │                       │<───────────────────────│
   │                      │                       │ 10. 扣款               │
   │                      │                       │───────────────────────>│
   │ 11. 提示：已购买      │                       │<───────────────────────│
   │<──────────────────────────────────────────────│                        │
   │                      │                       │                        │
   │                      │ 12. 回调：purchased ⚡ │                        │
   │                      │<──────────────────────│                        │
   │                      │ 13. 获取收据           │                        │
   │                      │<──────────────────────│                        │
   │                      │                       │                        │
   │                      │ 14. 验证收据            │                        │
   │                      │────────────────────────────────────────────────>│
   │                      │<────────────────────────────────────────────────│
   │                      │ 15. 验证成功            │                        │
   │                      │                       │                        │
   │                      │ 16. completePurchase() │                        │
   │                      │──────────────────────>│                        │
   │                      │ 17. 交易完成 ✅        │                        │
   │                      │                       │                        │
   │ 18. 显示成功提示      │                       │                        │
   │<─────────────────────│                       │                        │
```

---

## 📋 当前实现的流程

### confirm_payment_page.dart

```dart
Future<void> _handlePayment() async {
  // 步骤 1: 显示 Loading
  EasyLoading.show(status: '正在支付...');
  
  // 步骤 2: 创建 Completer（等待回调）
  final completer = Completer<PaymentResult>();
  bool isPurchaseCompleted = false;
  
  // 步骤 3: 发起支付
  await paymentService.pay(
    onResult: (success, errorMessage) {
      // 步骤 12: 收到回调
      completer.complete(...);
    },
  );
  
  // ❌ 问题：1.5秒后更新提示（不准确）
  Future.delayed(const Duration(milliseconds: 1500), () {
    EasyLoading.show(status: '正在验证...');  // ← 删除这个！
  });
  
  // 步骤 4: 等待回调
  await completer.future;  // ← 可能永远等待！
  
  // 步骤 5: 关闭 Loading
  EasyLoading.dismiss();
}
```

### iap_service.dart

```dart
// 步骤 3-5: 发起购买
Future<void> purchase({...}) async {
  // 3.1 生成产品ID
  final productId = getProductId(amount);
  
  // 3.2 查询产品
  final products = await queryProducts({productId});
  
  // 3.3 发送购买请求
  await _iap.buyConsumable(purchaseParam: param);
  
  debugPrint('购买请求已发送，等待用户确认');  // ← 只能到这里！
}

// 步骤 12-17: 处理回调
Future<void> _onPurchaseUpdate(List<PurchaseDetails> list) async {
  for (final purchaseDetails in list) {
    switch (purchaseDetails.status) {
      case PurchaseStatus.purchased:
        // 12. 支付成功
        // 13. 获取收据
        final receiptData = purchaseDetails.verificationData.serverVerificationData;
        
        // 14. 验证收据
        await _verifyAndFinishTransaction(purchaseDetails);
        break;
    }
  }
}

Future<void> _verifyAndFinishTransaction(purchaseDetails) async {
  // 13. 保存收据（安全备份）
  await IAPReceiptCache.saveFailedReceipt(...);
  
  // 14. 后台验证
  final result = await _verifyReceiptWithServer(...);
  
  if (result['success']) {
    // 15. 验证成功
    await IAPReceiptCache.removeFailedReceipt(...);
    
    // 16. 完成交易
    await _iap.completePurchase(purchaseDetails);
    
    // 17. 通知UI
    _paymentCallback?.call(true, null);
  }
}
```

---

## 🔴 当前存在的问题

### 问题 1: UI 提示不准确 ❌

```dart
// ❌ 错误：1.5秒后就显示"正在验证..."
Future.delayed(const Duration(milliseconds: 1500), () {
  EasyLoading.show(status: '正在验证...');
});

问题：
- 1.5秒时用户可能还在输入密码
- 根本还没完成支付
- 提示不准确，误导用户
```

### 问题 2: 没有超时保护 ❌

```dart
// ❌ 错误：永远等待回调
await completer.future;

问题：
- 如果回调丢失（StoreKit Bug）
- 会永远等待
- UI 一直显示 Loading
- 用户只能杀死应用
```

### 问题 3: 清理模式有缺陷 ⚠️

```dart
// iap_service.dart
if (_isCleaningMode) {
  if (purchaseDetails.status == PurchaseStatus.purchased) {
    // ⚠️ 问题：依赖 _currentOrderId
    if (_currentOrderId != null && _currentGoodsId != null) {
      await IAPReceiptCache.saveFailedReceipt(...);
    } else {
      debugPrint('⚠️ 订单信息不完整或收据为空，无法保存');  // ← 经常触发
    }
  }
  _iap.completePurchase(purchaseDetails);
  continue;
}

问题：
- 清理模式是启动时运行
- 此时 _currentOrderId 为 null（还没购买）
- 导致无法保存收据
- 收据丢失！
```

---

## ✅ 正确的流程应该是

### 修复后的 confirm_payment_page.dart

```dart
Future<void> _handlePayment() async {
  try {
    setState(() => _isPaying = true);
    
    // ✅ 步骤 1: 显示准确的提示
    EasyLoading.show(status: '请完成支付确认...');
    
    // ✅ 步骤 2: 创建 Completer
    final completer = Completer<wechat_pay.PaymentResult>();
    bool isPurchaseCompleted = false;
    bool isTimeout = false;
    
    // ✅ 步骤 3: 添加 30 秒超时保护
    final timeoutTimer = Timer(const Duration(seconds: 30), () {
      if (!completer.isCompleted && !isPurchaseCompleted) {
        isTimeout = true;
        debugPrint('⚠️ 支付超时，回调未收到');
        completer.complete(
          wechat_pay.PaymentResult.failed(
            '支付超时\n如已完成支付，请重启应用查看权限'
          )
        );
      }
    });
    
    // ✅ 步骤 4: 发起支付
    await _paymentService.pay(
      orderId: widget.flowId,
      goodsId: widget.goodsId,
      amount: widget.payableAmount,
      financeBodyId: widget.financeBodyId,
      studentId: studentId,
      goodsName: widget.goodsName,
      callback: (success, errorMessage) {
        if (!completer.isCompleted && !isTimeout) {
          timeoutTimer.cancel();
          isPurchaseCompleted = true;
          
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
    
    // ❌ 删除：不准确的延迟更新
    /*
    Future.delayed(const Duration(milliseconds: 1500), () {
      EasyLoading.show(status: '正在验证...');
    });
    */
    
    // ✅ 步骤 5: 等待回调或超时
    debugPrint('⏳ 等待支付结果（30秒超时）...');
    final result = await completer.future;
    
    // ✅ 步骤 6: 清理
    timeoutTimer.cancel();
    EasyLoading.dismiss();
    
    // ✅ 步骤 7: 处理结果
    if (!result.isSuccess) {
      EasyLoading.showError(result.errorMessage ?? '支付失败');
      return;
    }
    
    // ✅ 步骤 8: 成功处理
    if (mounted) {
      context.pop({'success': true, 'goods_id': widget.goodsId});
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        context.push('/pay-success', extra: {...});
      }
    }
    
  } catch (e) {
    debugPrint('❌ 支付异常: $e');
    EasyLoading.dismiss();
    EasyLoading.showError('支付失败: $e');
  } finally {
    if (mounted) {
      setState(() => _isPaying = false);
    }
  }
}
```

### 修复后的清理模式

```dart
// iap_service.dart
Future<void> _onPurchaseUpdate(List<PurchaseDetails> list) async {
  for (final purchaseDetails in list) {
    if (_isCleaningMode) {
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        debugPrint('⚠️ 清理模式检测到已购买交易');
        debugPrint('   产品ID: ${purchaseDetails.productID}');
        debugPrint('   交易ID: ${purchaseDetails.purchaseID}');
        
        // ✅ 修复：使用交易信息作为标识
        final receiptData = purchaseDetails.verificationData.serverVerificationData;
        if (receiptData.isNotEmpty) {
          await IAPReceiptCache.saveFailedReceipt(
            orderId: purchaseDetails.purchaseID ?? 'pending_${DateTime.now().millisecondsSinceEpoch}',
            goodsId: purchaseDetails.productID,
            financeBodyId: '',  // 清理模式时可以为空
            studentId: '',      // 清理模式时可以为空
            receiptData: receiptData,
            productId: purchaseDetails.productID,
            transactionId: purchaseDetails.purchaseID ?? '',
          );
          debugPrint('✅ 已保存收据到缓存（使用交易ID）');
        }
      }
      
      _iap.completePurchase(purchaseDetails);
      
      if (i == list.length - 1 && _cleaningCompleter != null) {
        _cleaningCompleter!.complete();
      }
      continue;
    }
    
    // 正常购买流程...
  }
}
```

---

## 📊 流程验证清单

### ✅ 正确的流程特征

| 步骤 | 检查项 | 当前状态 | 应该的状态 |
|------|--------|---------|-----------|
| **1. 发起购买** | 显示准确提示 | ❌ "正在支付..." | ✅ "请完成支付确认..." |
| **2. 等待用户操作** | UI 保持不变 | ❌ 1.5秒后变"正在验证" | ✅ 保持原提示 |
| **3. 用户确认支付** | StoreKit 处理 | ✅ 正常 | ✅ 正常 |
| **4. 收到回调** | 触发 callback | ✅ 正常（如果不丢失） | ✅ 正常 |
| **5. 验证收据** | 后台验证 | ✅ 正常 | ✅ 正常 |
| **6. 完成交易** | completePurchase | ✅ 正常 | ✅ 正常 |
| **7. 超时保护** | 30秒超时 | ❌ 没有 | ✅ 必须有 |
| **8. 清理模式** | 保存收据 | ⚠️ 依赖订单信息 | ✅ 使用交易信息 |

### ❌ 需要删除的逻辑

```dart
// 1. 删除不准确的延迟更新
Future.delayed(const Duration(milliseconds: 1500), () {
  EasyLoading.show(status: '正在验证...');  // ← 删除
  print('   💡 提示已更新：正在验证收据');   // ← 删除
});

// 2. 删除这些误导性的日志
print('   💡 提示已更新：正在验证收据');  // ← 删除
```

### ✅ 需要添加的逻辑

```dart
// 1. 添加超时保护
final timeoutTimer = Timer(const Duration(seconds: 30), () {
  if (!completer.isCompleted) {
    completer.complete(PaymentResult.failed('支付超时'));
  }
});

// 2. 修改清理模式保存逻辑
orderId: purchaseDetails.purchaseID ?? 'pending_${DateTime.now().millisecondsSinceEpoch}',

// 3. 添加超时日志
debugPrint('⏳ 等待支付结果（30秒超时）...');
```

---

## 🎯 标准流程总结

### 时间线（正常情况）

```
00:00  用户点击购买
       EasyLoading: "请完成支付确认..."
       
00:01  StoreKit 弹出支付框
       用户看到：价格、产品名称
       
00:02  用户输入密码
       
00:03  用户点击"购买"
       
00:04  Apple 处理支付
       
00:05  支付成功
       Apple 提示："您已购买"
       
00:06  触发回调：PurchaseStatus.purchased
       获取收据数据
       
00:07  保存收据到缓存
       
00:08  开始后台验证
       
00:09  验证成功
       删除缓存
       完成交易
       
00:10  EasyLoading.dismiss()
       显示："支付成功！"
```

### 时间线（异常情况 - 回调丢失）

```
00:00  用户点击购买
       EasyLoading: "请完成支付确认..."
       
00:01  StoreKit 弹出支付框
       
00:03  用户完成支付
       Apple 提示："您已购买"
       
00:04  ❌ 回调丢失
       
00:30  超时定时器触发 ✅
       EasyLoading.dismiss()
       显示："支付超时，如已完成支付，请重启应用查看权限"
       
重启应用:
       清理模式检测到 pending transaction
       保存收据（使用交易ID）✅
       自动补发验证
       权限开通 ✅
```

---

## ✅ 验证结论

### 当前流程的问题

1. ❌ **UI 提示不准确**
   - 1.5秒后就显示"正在验证"
   - 但此时用户可能还在输入密码
   
2. ❌ **没有超时保护**
   - 如果回调丢失会永远等待
   - 用户只能杀死应用
   
3. ⚠️ **清理模式有缺陷**
   - 依赖 _currentOrderId（启动时为 null）
   - 导致无法保存收据

### 需要的修改

1. ✅ 删除 1.5 秒延迟更新提示
2. ✅ 添加 30 秒超时保护
3. ✅ 修改清理模式使用交易ID保存

---

**更新时间**: 2025-01-25  
**状态**: 已识别问题，准备修复  
**优先级**: ⭐⭐⭐⭐⭐ 高优先级

