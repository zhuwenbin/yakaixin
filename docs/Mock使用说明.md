# Mock 数据使用说明

## 📚 保留的文档

本项目只保留以下 3 个 Mock 文档：

1. **Mock架构升级说明.md** - 最新的架构说明和问题修复
2. **Mock首页快速开始.md** - 5分钟快速开始指南
3. **Mock首页数据使用说明.md** - 详细的使用说明和示例代码

## 🎯 快速开始

### 1. Mock 数据位置

所有 Mock 数据存储在 JSON 文件中：
```
assets/mock/
  ├── goods_data.json     # 商品列表数据（13条）
  ├── order_data.json     # 订单列表数据（5条）
  └── config_data.json    # 配置数据（1项）
```

### 2. Mock 开关控制

**默认状态**:
- ✅ Debug 模式：**自动开启** Mock
- ❌ Release 模式：**自动关闭** Mock

**手动控制**:
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 关闭 Mock
ref.read(mockEnabledProvider.notifier).state = false;
ref.read(dioClientProvider).disableMock();

// 开启 Mock
ref.read(mockEnabledProvider.notifier).state = true;
ref.read(dioClientProvider).enableMock();
```

### 3. 数据来源验证

查看日志确认数据来源：
```
✅ Mock数据库查询命中 (来自 JSON 文件)  ← 正确
⚠️ 未找到Mock数据 (请检查 JSON 文件)   ← 需要检查
```

## 🔧 最近修复的问题

### 问题1: 首页显示不正确

**原因**: 
1. Mock 查询引擎没有忽略 `shelf_platform_id`、`professional_id`、`is_buyed` 等参数
2. 秒杀推荐筛选逻辑错误（应该筛选未购买，而不是已购买）

**修复**:
1. ✅ 更新 `MockQueryEngine`，忽略非筛选参数
2. ✅ 修正首页 Provider 的秒杀推荐筛选逻辑

### 问题2: 看到旧的 Mock 数据

**原因**: `MockDataRouter` 有回退机制，会使用旧的静态数据

**修复**: ✅ 已禁用静态数据回退，强制使用 JSON 文件

## 📊 首页数据说明

### 秒杀推荐（轮播）
**筛选条件**: `is_homepage_recommend=1` && `permission_status=2`

**Mock 数据**: 3条未购买的推荐商品
- 2026口腔执业医师历年真题精选 (seckill_countdown=3600秒)
- 口腔医学综合模拟考试 (seckill_countdown=1800秒)
- 口腔预防医学速成班 (seckill_countdown=7200秒)

### 题库 Tab
**筛选条件**: `type=8,10,18`

**Mock 数据**: 7条题库商品
- 章节练习 (type=18): 3条
- 试卷 (type=8): 2条
- 模考 (type=10): 2条

### 网课 Tab
**筛选条件**: `teaching_type=3` && `type=2,3`

**Mock 数据**: 3条网课商品

### 直播 Tab
**筛选条件**: `teaching_type=1` && `type=2,3`

**Mock 数据**: 3条直播商品

## ✅ 验证清单

运行应用后，检查：

- [ ] 控制台输出 "✅ Mock数据库查询命中 (来自 JSON 文件)"
- [ ] 秒杀轮播显示 3 条商品（带倒计时）
- [ ] 题库 Tab 显示 7 条商品
- [ ] 网课 Tab 显示 3 条商品（如果 Tab 可见）
- [ ] 直播 Tab 显示 3 条商品（如果 Tab 可见）
- [ ] 首页无报错和空数据

## 🐛 常见问题

### Q: 首页数据为空？

**检查**:
1. Mock 开关是否开启？
   ```dart
   final isMockEnabled = ref.read(mockEnabledProvider);
   print('Mock状态: $isMockEnabled'); // 应该是 true
   ```

2. 是否选择了专业？
   - Mock 模式下也需要选择专业才能加载数据
   - 选择任意专业即可

3. 查看控制台日志
   - 应该看到 "Mock数据库查询命中"
   - 如果看到 "未找到Mock数据"，说明查询参数不匹配

### Q: 秒杀轮播没有商品？

**原因**: `is_homepage_recommend=1` && `permission_status=2` 筛选后没有数据

**检查**: 
```dart
// 在 home_provider.dart 中添加日志
print('allQuestionBank: ${allQuestionBank.length}');
print('recommendList: ${recommendList.length}');
```

### Q: 如何修改 Mock 数据？

**步骤**:
1. 打开 `assets/mock/goods_data.json`
2. 修改数据（添加、删除、更新字段）
3. 保存文件
4. 热重载应用 (按 `r` 键)
5. Mock 数据自动更新

## 📖 详细文档

需要更详细的说明，请查看：
- 📖 [Mock架构升级说明.md](./Mock架构升级说明.md)
- 📖 [Mock首页快速开始.md](./Mock首页快速开始.md)
- 📖 [Mock首页数据使用说明.md](./Mock首页数据使用说明.md)

---

**最后更新**: 2025-11-25  
**状态**: ✅ Mock 数据已完整实现，可正常使用
