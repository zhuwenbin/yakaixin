# CommonStateWidget 统一状态组件

## 📋 概述

`CommonStateWidget` 是一个统一的错误/空状态展示组件，用于在整个应用中保持一致的用户体验。

### ✅ 解决的问题

- ❌ **之前**: 每个页面的错误提示、空状态样式不统一
- ❌ **之前**: 断网后不同页面显示效果不一致
- ✅ **现在**: 统一的UI风格、统一的交互逻辑

---

## 🎯 支持的场景

### 1. 错误场景
- 网络错误（断网、超时）
- 加载失败（服务器错误、接口异常）
- 自定义错误消息

### 2. 空数据场景
- 通用空数据
- 暂无订单
- 暂无课程
- 暂无收藏
- 暂无错题

---

## 📦 使用方法

### 场景1: 网络错误（断网）

```dart
CommonStateWidget.networkError(
  onRetry: () {
    ref.read(myProvider.notifier).refresh();
  },
)
```

**效果**:
- 图标: WiFi关闭图标
- 标题: "网络连接失败"
- 消息: "请检查网络设置后重试"
- 按钮: "重试"按钮（带刷新图标）

---

### 场景2: 加载失败（服务器错误）

```dart
CommonStateWidget.loadError(
  message: '服务器繁忙，请稍后重试',
  onRetry: () {
    ref.read(myProvider.notifier).refresh();
  },
)
```

**效果**:
- 图标: 错误图标
- 标题: "加载失败"
- 消息: 自定义消息（或默认"请稍后重试"）
- 按钮: "重试"按钮

---

### 场景3: 自定义错误

```dart
CommonStateWidget.error(
  title: '支付失败',
  message: '订单已过期，请重新下单',
  onRetry: () {
    Navigator.pop(context);
  },
)
```

**效果**:
- 图标: 错误图标
- 标题: 自定义标题
- 消息: 自定义消息
- 按钮: "重试"按钮

---

### 场景4: 空数据

```dart
CommonStateWidget.empty(
  message: '暂无搜索结果',
)
```

**效果**:
- 图片: 默认空状态图片
- 消息: 自定义消息（或默认"暂无数据"）
- 无按钮

---

### 场景5: 暂无订单

```dart
CommonStateWidget.noOrder()
```

**效果**:
- 图片: 订单空状态图片
- 消息: "暂无订单！"
- 无按钮

---

### 场景6: 暂无课程

```dart
CommonStateWidget.noCourse(
  onAction: () {
    // 跳转到课程Tab
    context.go('/main-tab');
    ref.read(mainTabIndexProvider.notifier).state = 2;
  },
)
```

**效果**:
- 图片: 课程空状态图片
- 消息: "未找到符合的学习内容"
- 按钮: "去看课程"按钮

---

### 场景7: 暂无收藏

```dart
CommonStateWidget.noCollection()
```

---

### 场景8: 暂无错题

```dart
CommonStateWidget.noWrongQuestion()
```

**效果**:
- 图标: 对勾图标
- 消息: "暂无错题~"
- 无按钮

---

## 🔧 完整应用示例

### 示例1: 在订单页面中使用

```dart
class MyOrderPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(orderListProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('我的订单')),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            // ✅ 空状态
            return CommonStateWidget.noOrder();
          }
          return ListView.builder(/* ... */);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          // ✅ 错误状态
          return CommonStateWidget.loadError(
            message: error.toString(),
            onRetry: () => ref.read(orderListProvider.notifier).refresh(),
          );
        },
      ),
    );
  }
}
```

---

### 示例2: 在商品详情页中使用

```dart
class GoodsDetailPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(goodsDetailProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('商品详情')),
      body: state.isLoading
          ? _buildLoading()
          : state.error != null
              ? CommonStateWidget.loadError(
                  message: state.error!,
                  onRetry: () {
                    ref.read(goodsDetailProvider.notifier).refresh();
                  },
                )
              : state.goodsDetail != null
                  ? _buildContent(state.goodsDetail!)
                  : CommonStateWidget.empty(),
    );
  }
}
```

---

### 示例3: 处理断网场景

```dart
// 在AsyncValue的error中判断错误类型
asyncValue.when(
  data: (data) => /* ... */,
  loading: () => /* ... */,
  error: (error, stack) {
    // ✅ 判断是否是网络错误
    if (error.toString().contains('网络') || 
        error.toString().contains('connection')) {
      return CommonStateWidget.networkError(
        onRetry: () => refresh(),
      );
    }
    
    // ✅ 其他错误
    return CommonStateWidget.loadError(
      message: error.toString(),
      onRetry: () => refresh(),
    );
  },
)
```

---

## 🎨 自定义扩展

如果需要添加新的预设类型：

1. 在 `CommonStateType` 枚举中添加新类型
2. 在 `_getConfig()` 方法的 switch 中添加配置
3. 添加对应的工厂方法

```dart
// 1. 添加枚举
enum CommonStateType {
  // ... 现有类型
  noMessage,  // ✅ 新增
}

// 2. 添加配置
case CommonStateType.noMessage:
  return _StateConfig(
    imageUrl: ApiConfig.completeImageUrl('your-image.png'),
    message: '暂无消息',
  );

// 3. 添加工厂方法
factory CommonStateWidget.noMessage() {
  return const CommonStateWidget(
    type: CommonStateType.noMessage,
  );
}
```

---

## 📌 注意事项

### ✅ DO（应该做的）

1. **统一使用**: 所有错误和空状态都使用 `CommonStateWidget`
2. **提供重试**: 网络错误、加载失败等场景提供 `onRetry` 回调
3. **语义化消息**: 使用用户能理解的错误消息，不要显示技术错误

```dart
// ✅ 正确
CommonStateWidget.loadError(
  message: '加载失败，请稍后重试',
  onRetry: () => refresh(),
)

// ❌ 错误
CommonStateWidget.loadError(
  message: 'DioException [connection error]: null',
  onRetry: () => refresh(),
)
```

### ❌ DON'T（不应该做的）

1. **不要重复造轮子**: 不要在页面中自己写错误/空状态UI
2. **不要忽略错误**: 所有错误都应该有友好提示
3. **不要遗漏重试**: 用户可恢复的错误必须提供重试按钮

---

## 🔗 相关文档

- [错误提示统一处理方案.md](../../docs/错误提示统一处理方案.md)
- [主题和样式管理规范](../../core/theme/)
- [MVVM架构规范](../../docs/mvvm_architecture.md)

---

## 📝 更新日志

### v1.0.0 (2025-01-15)
- ✅ 初始版本
- ✅ 支持8种预设场景
- ✅ 支持自定义错误消息
- ✅ 统一UI风格
- ✅ 集成主题系统
