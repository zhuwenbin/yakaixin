# 统一支付流程管理器

## 📋 概述

`PaymentFlowManager` 是一个统一管理所有支付场景的工具类，旨在：
- ✅ 减少重复代码
- ✅ 统一支付流程处理
- ✅ 支持成功/失败的回调
- ✅ 自动处理页面跳转和刷新

---

## 🎯 核心功能

### 1. 统一的支付流程

```
用户点击购买
    ↓
PaymentFlowManager.startPaymentFlow()
    ↓
获取用户信息（自动）
    ↓
创建订单（自动）
    ↓
根据订单结果分支处理:
    - 0元订单 → 刷新页面 → 跳转支付成功页
    - 需支付 → 跳转确认订单页 → 等待支付结果 → 刷新页面
    - 失败 → 显示错误
```

### 2. 支持的回调

- `onSuccess`: 支付成功回调
- `onError`: 支付失败回调

---

## 📖 使用方法

### 方式1：使用扩展方法（推荐）

```dart
import 'package:yakaixin_app/core/payment/payment_flow_manager.dart';

class MyGoodsDetailPage extends ConsumerWidget {
  Future<void> _handlePurchase() async {
    // ✅ 使用context.startPayment()扩展方法
    await context.startPayment(
      ref: ref,
      goodsId: '123',
      goodsMonthsPriceId: '456',
      months: '12',
      payableAmount: 299.0,
      goodsName: '秘卷真题',
      professionalIdName: '口腔执业医师',
      refreshGoodsId: '123',
      isLearnButton: 1,
      onSuccess: () {
        // 自定义成功处理
        ref.read(goodsDetailProvider.notifier).refresh(goodsId);
      },
      onError: (error) {
        // 自定义错误处理
        print('支付失败: $error');
      },
    );
  }
}
```

### 方式2：直接使用Manager

```dart
import 'package:yakaixin_app/core/payment/payment_flow_manager.dart';

class MyGoodsDetailPage extends ConsumerWidget {
  Future<void> _handlePurchase() async {
    final manager = PaymentFlowManager(ref: ref, context: context);
    
    await manager.startPaymentFlow(
      goodsId: '123',
      goodsMonthsPriceId: '456',
      months: '12',
      payableAmount: 299.0,
      goodsName: '秘卷真题',
      onSuccess: () {
        // 支付成功回调
      },
      onError: (error) {
        // 支付失败回调
      },
    );
  }
}
```

---

## 📝 参数说明

### 必需参数

| 参数 | 类型 | 说明 |
|-----|------|------|
| `goodsId` | String | 商品ID |
| `goodsMonthsPriceId` | String | 价格方案ID |
| `months` | String | 购买月数 |
| `payableAmount` | double | 应付金额 |
| `goodsName` | String | 商品名称（用于确认订单页显示） |

### 可选参数

| 参数 | 类型 | 默认值 | 说明 |
|-----|------|--------|------|
| `professionalIdName` | String? | null | 专业名称（用于支付成功页） |
| `refreshGoodsId` | String? | null | 需要刷新的商品ID（通常与goodsId相同） |
| `isLearnButton` | int? | 0 | 支付成功页按钮类型（1=去学习，0=开始测验） |
| `onSuccess` | VoidCallback? | null | 支付成功回调 |
| `onError` | ValueChanged<String>? | null | 支付失败回调 |

---

## 🔄 完整示例

### 示例1: 秘卷真题支付

```dart
// lib/features/goods/views/secret_real_detail_page.dart

import 'package:yakaixin_app/core/payment/payment_flow_manager.dart';

Future<void> _startPurchaseFlow(GoodsDetailModel detail) async {
  // 获取选中的价格信息
  final selectedPrice = detail.prices[0];
  final payableAmount = double.tryParse(selectedPrice.salePrice ?? '0') ?? 0;
  final goodsId = SafeTypeConverter.toSafeString(detail.goodsId);
  
  // 使用统一支付流程管理器
  await context.startPayment(
    ref: ref,
    goodsId: goodsId,
    goodsMonthsPriceId: selectedPrice.goodsMonthsPriceId ?? '',
    months: SafeTypeConverter.toSafeString(selectedPrice.month, defaultValue: '0'),
    payableAmount: payableAmount,
    goodsName: detail.name ?? '秘卷真题',
    professionalIdName: detail.professionalIdName,
    refreshGoodsId: goodsId,
    isLearnButton: 1,  // 支付成功页显示"去学习"按钮
    onSuccess: () {
      // 支付成功：刷新商品详情
      ref.read(secretRealDetailNotifierProvider.notifier).refresh(goodsId);
    },
    onError: (error) {
      // 支付失败：记录日志
      print('❌ [秘卷真题] 支付失败: $error');
    },
  );
}
```

### 示例2: 课程商品支付

```dart
// lib/features/goods/views/course_goods_detail_page.dart

import 'package:yakaixin_app/core/payment/payment_flow_manager.dart';

Future<void> _handlePurchase() async {
  final selectedPrice = _goodsDetail.prices[_selectedPriceIndex];
  
  await context.startPayment(
    ref: ref,
    goodsId: widget.goodsId!,
    goodsMonthsPriceId: selectedPrice.goodsMonthsPriceId ?? '',
    months: SafeTypeConverter.toSafeString(selectedPrice.month, defaultValue: '0'),
    payableAmount: double.tryParse(selectedPrice.salePrice ?? '0') ?? 0,
    goodsName: _goodsDetail.name ?? '课程',
    professionalIdName: _goodsDetail.professionalIdName,
    refreshGoodsId: widget.goodsId,
    isLearnButton: 0,  // 支付成功页显示"开始测验"按钮
    onSuccess: () async {
      // 支付成功：重新加载商品详情
      await _loadGoodsDetail();
      EasyLoading.showSuccess('购买成功');
    },
    onError: (error) {
      // 支付失败：显示错误提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    },
  );
}
```

### 示例3: 订单列表再次支付

```dart
// lib/features/order/views/my_order_page.dart

import 'package:yakaixin_app/core/payment/payment_flow_manager.dart';

Future<void> _handleRePayment(OrderModel order) async {
  await context.startPayment(
    ref: ref,
    goodsId: order.goodsId,
    goodsMonthsPriceId: order.goodsMonthsPriceId,
    months: order.months ?? '0',
    payableAmount: double.tryParse(order.realAmount ?? '0') ?? 0,
    goodsName: order.goodsName ?? '商品',
    onSuccess: () {
      // 支付成功：刷新订单列表
      ref.read(orderListProvider('1').notifier).refresh();
      EasyLoading.showSuccess('支付成功');
    },
    onError: (error) {
      EasyLoading.showError('支付失败: $error');
    },
  );
}
```

---

## ⚙️ 内部流程说明

### 1. 用户信息获取（自动）

```dart
// 内部自动从StorageService获取
final userInfo = storage.getJson(StorageKeys.userInfo);
final studentId = userInfo?['student_id'] ?? '';
final employeeId = userInfo?['employee_id'] ?? '';
```

### 2. 创建订单（自动）

```dart
// 内部自动调用OrderProvider创建订单
final result = await orderNotifier.createOrder(
  goodsId: goodsId,
  goodsMonthsPriceId: goodsMonthsPriceId,
  months: months,
  payableAmount: payableAmount,
  studentId: studentId,
  employeeId: employeeId,
);
```

### 3. 处理订单结果（自动）

```dart
result.when(
  freeOrder: (orderId) {
    // 0元订单：刷新 → 跳转成功页
  },
  needPayment: (orderId, flowId) {
    // 需支付：跳转确认订单页 → 等待结果 → 刷新
  },
  error: (errorMsg) {
    // 失败：显示错误
  },
);
```

---

## 🔄 页面刷新机制

### onSuccess回调中刷新

支付成功后，通过`onSuccess`回调刷新对应的Provider：

```dart
await context.startPayment(
  // ... 其他参数
  onSuccess: () {
    // 方案1: 刷新商品详情Provider
    ref.read(goodsDetailNotifierProvider.notifier).refresh(goodsId);
    
    // 方案2: 刷新订单列表Provider
    ref.read(orderListProvider('1').notifier).refresh();
    
    // 方案3: 自定义刷新逻辑
    _loadData();
  },
);
```

---

## 🎨 自定义处理

### 只需要简单提示

```dart
await context.startPayment(
  ref: ref,
  goodsId: goodsId,
  // ... 其他必需参数
  onSuccess: () {
    // 不刷新页面，只显示提示
    EasyLoading.showSuccess('购买成功');
  },
);
```

### 需要跳转到其他页面

```dart
await context.startPayment(
  ref: ref,
  goodsId: goodsId,
  // ... 其他必需参数
  onSuccess: () {
    // 支付成功后跳转到课程页
    ref.read(mainTabIndexProvider.notifier).state = 2;
    context.go(AppRoutes.mainTab);
  },
);
```

### 需要复杂的业务逻辑

```dart
await context.startPayment(
  ref: ref,
  goodsId: goodsId,
  // ... 其他必需参数
  onSuccess: () async {
    // 1. 刷新商品详情
    await ref.read(goodsDetailNotifierProvider.notifier).refresh(goodsId);
    
    // 2. 记录埋点
    await trackPurchaseSuccess(goodsId);
    
    // 3. 显示引导弹窗
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => GuideDialog(),
      );
    }
  },
);
```

---

## ✅ 优势总结

### Before（重复代码）

每个页面都要写：
```dart
// 1. 获取用户信息
final storage = ref.read(storageServiceProvider);
final userInfo = storage.getJson(StorageKeys.userInfo);
// ...

// 2. 创建订单
final result = await orderNotifier.createOrder(...);

// 3. 处理结果
result.when(
  freeOrder: (orderId) {
    // 刷新 + 跳转
  },
  needPayment: (orderId, flowId) {
    // 跳转确认页 + 等待结果 + 刷新
  },
  error: (errorMsg) {
    // 显示错误
  },
);
```

**问题**：
- ❌ 重复代码太多
- ❌ 每个页面都要处理相同的逻辑
- ❌ 难以维护和修改

### After（统一管理器）

每个页面只需写：
```dart
await context.startPayment(
  ref: ref,
  goodsId: goodsId,
  goodsMonthsPriceId: goodsMonthsPriceId,
  months: months,
  payableAmount: payableAmount,
  goodsName: goodsName,
  onSuccess: () {
    // 自定义成功处理
  },
);
```

**优势**：
- ✅ 代码减少 80%
- ✅ 逻辑统一，易于维护
- ✅ 支持灵活的回调定制
- ✅ 自动处理错误和提示

---

## 📚 适用场景

| 场景 | 是否适用 | 说明 |
|-----|---------|------|
| 商品详情页购买 | ✅ | 推荐使用 |
| 订单列表再次支付 | ✅ | 推荐使用 |
| 购物车批量支付 | ✅ | 推荐使用 |
| 会员续费 | ✅ | 推荐使用 |
| 充值 | ⚠️ | 可能需要额外定制 |
| 积分兑换 | ❌ | 不涉及支付流程 |

---

## 🔧 扩展建议

如果需要支持更多场景，可以扩展 `PaymentFlowManager`：

### 1. 添加新的回调

```dart
// payment_flow_manager.dart

/// 开始支付流程
Future<void> startPaymentFlow({
  // ... 现有参数
  VoidCallback? onBeforeCreate,  // 🆕 创建订单前回调
  VoidCallback? onCreated,       // 🆕 订单创建成功回调
  VoidCallback? onPaymentStart,  // 🆕 支付开始回调
}) async {
  // ...
}
```

### 2. 支持更多支付方式

```dart
// payment_flow_manager.dart

enum PaymentMethod {
  wechat,  // 微信支付
  alipay,  // 支付宝支付
  apple,   // Apple Pay
}

Future<void> startPaymentFlow({
  // ... 现有参数
  PaymentMethod paymentMethod = PaymentMethod.wechat,
}) async {
  // ...
}
```

---

## 📞 技术支持

如有问题或建议，请联系团队成员或在项目文档中提Issue。
