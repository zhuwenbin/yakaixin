# Mock 架构升级说明

## 🔧 问题修复

### 问题描述

在未开启 Mock 模式时，首页仍然显示 Mock 数据，但数据不是来自 JSON 文件，而是来自旧的静态 Mock 数据。

### 问题根源

1. **旧架构遗留**：`lib/core/mock/mock_data.dart` 中有硬编码的静态 Mock 数据
2. **回退机制**：`MockDataRouter` 有回退逻辑，当 JSON 文件查询失败时，会使用静态数据
3. **Mock 开关默认关闭**：`mockEnabledProvider` 默认值是 `false`，导致拦截器不生效

### 修复方案

#### 1. 禁用静态 Mock 数据回退

**文件**: `lib/core/mock/mock_data_router.dart`

**修改**:
```dart
// ❌ 旧代码 - 有回退机制
final dynamicData = await _getDynamicData(path, method, params);
if (dynamicData != null) {
  return dynamicData;
}

// 回退到静态数据
final staticData = MockData.getData(url, method);
if (staticData != null) {
  return staticData;
}

// ✅ 新代码 - 禁用回退，强制使用 JSON 文件
final dynamicData = await _getDynamicData(path, method, params);
if (dynamicData != null) {
  print('✅ Mock数据库查询命中 (来自 JSON 文件)');
  return dynamicData;
}

// ⚠️ 不再回退到静态数据模式
// 注释掉静态数据回退逻辑

print('⚠️ 未找到Mock数据: $url (请检查 JSON 文件)');
return null;
```

#### 2. 修改 Mock 开关默认值

**文件**: `lib/core/network/mock_interceptor.dart`

**修改**:
```dart
// ❌ 旧代码 - 默认关闭
final mockEnabledProvider = StateProvider<bool>((ref) => false);

// ✅ 新代码 - Debug 模式下默认开启
/// ⚠️ Debug 模式下默认开启 Mock，可在调试面板关闭
final mockEnabledProvider = StateProvider<bool>((ref) => true);
```

## 🎯 新架构说明

### 数据来源优先级

```
1. JSON 文件 (assets/mock/*.json)  ← 唯一数据源
   ├── goods_data.json
   ├── order_data.json
   └── config_data.json

2. ❌ 静态数据 (mock_data.dart) ← 已禁用
```

### Mock 开关控制

#### 默认状态
- **Debug 模式**: Mock **默认开启** ✅
- **Release 模式**: Mock **强制关闭** ❌

#### 如何控制

**方式1: 在代码中控制（推荐用于开发调试）**
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 关闭 Mock
ref.read(mockEnabledProvider.notifier).state = false;

// 开启 Mock
ref.read(mockEnabledProvider.notifier).state = true;
```

**方式2: 在调试面板控制（如果有 UI 开关）**
```dart
class DebugSettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMockEnabled = ref.watch(mockEnabledProvider);
    
    return SwitchListTile(
      title: const Text('Mock 模式'),
      value: isMockEnabled,
      onChanged: (value) {
        ref.read(mockEnabledProvider.notifier).state = value;
        
        // 动态添加/移除拦截器
        final dioClient = ref.read(dioClientProvider);
        if (value) {
          dioClient.enableMock();
        } else {
          dioClient.disableMock();
        }
      },
    );
  }
}
```

## 📝 使用指南

### 1. 确认 Mock 是否生效

**查看日志**:
```
// Mock 开启时
🧪 Mock拦截: GET /c/goods/v2/servicehall/mine?type=8,10,18
🔍 查找Mock数据: GET /c/goods/v2/servicehall/mine?type=8,10,18
🗄️ Mock数据库查询 - 商品列表
   查询参数: {type: 8,10,18}
   查询结果: 7 条 / 总计 13 条
✅ Mock数据库查询命中 (来自 JSON 文件)
⏱️ Mock延迟: 250ms (模式: normal)

// Mock 关闭时
// 正常发起网络请求，无 Mock 相关日志
```

### 2. 数据来源验证

**JSON 文件数据**:
- 商品列表: `assets/mock/goods_data.json` (13条商品)
- 订单列表: `assets/mock/order_data.json` (5条订单)
- 配置数据: `assets/mock/config_data.json` (1项配置)

**验证方式**:
```dart
// 1. 查看商品数据
final result = await MockDatabase.queryGoods({'type': '8,10,18'});
final list = result['data']['list'] as List;
print('题库商品数量: ${list.length}'); // 应该是 7

// 2. 查看第一条商品名称
print('第一条商品: ${list[0]['name']}'); 
// 应该是: "2026高清网课—口腔组织病理学"
```

### 3. 如何关闭 Mock

**临时关闭（当前会话）**:
```dart
// 在任意 ConsumerWidget 中
ref.read(mockEnabledProvider.notifier).state = false;
ref.read(dioClientProvider).disableMock();
```

**永久关闭（代码修改）**:
```dart
// lib/core/network/mock_interceptor.dart
final mockEnabledProvider = StateProvider<bool>((ref) => false); // 改为 false
```

**生产环境关闭（自动）**:
```bash
flutter build apk --release
# Release 模式下，Mock 拦截器不会被添加（见 DioClient 第 48 行）
```

## 🗑️ 旧代码清理（可选）

### 可以删除的文件

以下文件已不再使用，可以安全删除：

1. **`lib/core/mock/mock_data.dart`** ❌
   - 旧的静态 Mock 数据
   - 已被 JSON 文件替代

**删除命令**:
```bash
cd /Users/mac/Desktop/vueToFlutter/yakaixin_app
rm lib/core/mock/mock_data.dart
```

**更新导入**:
需要移除 `mock_data_router.dart` 中的导入：
```dart
// ❌ 删除这行
import 'mock_data.dart';
```

## ✅ 验收标准

### Mock 开启时
- ✅ 首页商品列表显示 JSON 文件中的数据（13条商品）
- ✅ 日志输出 "✅ Mock数据库查询命中 (来自 JSON 文件)"
- ✅ 题库Tab显示7条商品
- ✅ 网课Tab显示3条商品
- ✅ 直播Tab显示3条商品
- ✅ 秒杀轮播显示3条推荐商品

### Mock 关闭时
- ✅ 正常发起网络请求
- ✅ 无 Mock 相关日志输出
- ✅ 如果后端未准备好，显示网络错误

## 🔍 常见问题

### Q1: 为什么还是显示旧数据？

**原因**: 可能还在使用旧的静态 Mock 数据

**解决方案**:
1. 确认 `mock_data_router.dart` 已更新（禁用静态数据回退）
2. 热重启应用（按 `R` 键）
3. 查看日志确认数据来源

### Q2: Mock 开关在哪里？

**位置**: `mockEnabledProvider`

**查看状态**:
```dart
final isMockEnabled = ref.read(mockEnabledProvider);
print('Mock状态: $isMockEnabled');
```

### Q3: 如何知道当前使用的是哪个数据源？

**查看日志**:
```
✅ Mock数据库查询命中 (来自 JSON 文件)  ← JSON 文件
✅ Mock静态数据命中                    ← 静态数据（已禁用）
```

### Q4: 生产环境会不会用到 Mock 数据？

**不会**，因为：
1. `DioClient` 初始化时检查 `ApiConfig.isDebug`
2. Release 模式下 `isDebug = false`
3. Mock 拦截器不会被创建和添加

```dart
// lib/core/network/dio_client.dart 第 48 行
if (_ref != null && ApiConfig.isDebug) {  // ← Release 时为 false
  _mockInterceptor = MockInterceptor(_ref);
  // ...
}
```

## 📊 架构对比

### 旧架构（已废弃）
```
请求 → Mock拦截器 → MockDataRouter
                      ├─ JSON文件 ✅
                      └─ 静态数据 ⚠️ (回退)
```

### 新架构（当前）
```
请求 → Mock拦截器 → MockDataRouter
                      └─ JSON文件 ✅ (唯一来源)
```

## 🎉 总结

### 修复内容
1. ✅ 禁用静态 Mock 数据回退
2. ✅ Mock 开关默认开启（Debug 模式）
3. ✅ 强制使用 JSON 文件作为数据源
4. ✅ 添加数据来源日志标识

### 使用建议
1. **开发阶段**: 保持 Mock 开启，使用 JSON 文件数据
2. **联调阶段**: 关闭 Mock，使用真实接口
3. **生产环境**: 自动关闭 Mock

### 数据管理
- ✅ 所有 Mock 数据统一在 `assets/mock/*.json`
- ✅ 直接编辑 JSON 文件，热重载生效
- ✅ 一个接口对应一个 JSON 文件（符合规范）

**现在可以放心使用新的 Mock 架构了！** 🚀
