# Mock 查询参数过滤问题修复

## 🐛 问题描述

Mock 模式下，所有查询都返回 **0 条数据**，即使 JSON 文件中有 13 条商品数据。

## 🔍 问题日志

```
flutter: 🗄️ Mock数据库查询 - 商品列表
flutter:    查询参数: {
  shelf_platform_id: 480130129201204499, 
  professional_id: 524033912737962623, 
  type: 8,10,
  platform_id: 409974729504527968,      ← ❌ 额外参数
  merchant_id: 408559575579495187,      ← ❌ 额外参数
  brand_id: 408559632588540691,         ← ❌ 额外参数
  channel_id: 515957991174840396,       ← ❌ 额外参数
  extend_uid: 508948528815416786        ← ❌ 额外参数
}
flutter:    查询结果: 0 条 / 总计 13 条  ← ❌ 筛选后没有数据
```

## 🔍 问题分析

### 原因：额外的业务参数被当作筛选条件

**Mock 查询引擎的工作流程**:
1. 遍历所有查询参数
2. 跳过非筛选参数（如 `page`, `sort`）
3. 用其他参数筛选数据

**问题参数**:
- `platform_id` - 平台ID
- `merchant_id` - 商户ID
- `brand_id` - 品牌ID
- `channel_id` - 渠道ID
- `extend_uid` - 扩展用户ID

这些参数在 **真实 API** 中用于业务标识，但在 **Mock 数据** 中不存在这些字段，导致筛选失败。

### 代码逻辑

**旧代码** (`MockQueryEngine._filterByParams`):
```dart
for (final entry in queryParams.entries) {
  final paramKey = entry.key;
  final paramValue = entry.value?.toString() ?? '';
  
  // 跳过非筛选参数
  if (_isNonFilterParam(paramKey)) continue; // ← 只忽略了部分参数
  
  // 获取字段值
  final itemValue = item[paramKey]?.toString() ?? '';
  
  // 精确匹配
  if (itemValue != paramValue) {
    return false; // ← platform_id 不匹配，过滤掉所有数据
  }
}
```

**旧的非筛选参数列表**:
```dart
const nonFilterParams = [
  'page', 'page_size', 'pageSize', 'sort', 'order',
  'shelf_platform_id', 'professional_id', 'is_buyed',
  // ❌ 缺少: platform_id, merchant_id, brand_id, channel_id, extend_uid
];
```

**问题**:
- `platform_id` 等参数没有被忽略
- Mock 数据中没有这些字段
- 字段值为空，导致匹配失败
- 所有数据都被过滤掉

## ✅ 修复方案

### 更新非筛选参数列表

**文件**: `lib/core/mock/mock_query_engine.dart`

```dart
/// 非筛选参数(用于排序、分页等)
static bool _isNonFilterParam(String key) {
  const nonFilterParams = [
    // 分页和排序
    'page', 'page_size', 'pageSize', 'sort', 'order',
    
    // 业务标识参数（不用于筛选）
    'shelf_platform_id',  // 货架平台ID
    'professional_id',    // 专业ID
    'is_buyed',          // 是否已购买
    'platform_id',       // 平台ID ← ✅ 新增
    'merchant_id',       // 商户ID ← ✅ 新增
    'brand_id',          // 品牌ID ← ✅ 新增
    'channel_id',        // 渠道ID ← ✅ 新增
    'extend_uid',        // 扩展用户ID ← ✅ 新增
  ];
  return nonFilterParams.contains(key);
}
```

### 修复效果

**修复前**:
```
查询参数: {type: 8,10, platform_id: xxx, merchant_id: xxx, ...}
查询结果: 0 条 / 总计 13 条  ← ❌ 被额外参数过滤掉
```

**修复后**:
```
查询参数: {type: 8,10, platform_id: xxx, merchant_id: xxx, ...}
               ↓ (忽略 platform_id, merchant_id 等参数)
查询结果: 4 条 / 总计 13 条  ← ✅ 只用 type 筛选
```

## 📊 验证修复

### 测试步骤

1. **重启应用** (热重载即可)
2. **选择专业**
3. **查看首页**
4. **查看日志**

### 预期日志

```
flutter: 🏠 首页加载数据 - 专业ID: 524033912737962623
flutter: 🗄️ Mock数据库查询 - 商品列表
flutter:    查询参数: {type: 18, platform_id: xxx, ...}
flutter:    查询结果: 3 条 / 总计 13 条  ← ✅ type=18 匹配 3 条
flutter: 🗄️ Mock数据库查询 - 商品列表
flutter:    查询参数: {type: 8,10, platform_id: xxx, ...}
flutter:    查询结果: 4 条 / 总计 13 条  ← ✅ type=8,10 匹配 4 条
flutter: 🗄️ Mock数据库查询 - 商品列表
flutter:    查询参数: {type: 2,3, teaching_type: 3, ...}
flutter:    查询结果: 3 条 / 总计 13 条  ← ✅ 匹配 3 条网课
flutter: 🗄️ Mock数据库查询 - 商品列表
flutter:    查询参数: {type: 2,3, teaching_type: 1, ...}
flutter:    查询结果: 3 条 / 总计 13 条  ← ✅ 匹配 3 条直播
flutter: 📊 数据加载完成:
flutter:    题库商品: 7 条  ← ✅ 3 + 4 = 7
flutter:    秒杀推荐: 3 条  ← ✅ 筛选后 3 条
flutter:    网课列表: 3 条  ← ✅ 正确
flutter:    直播列表: 3 条  ← ✅ 正确
```

### 预期结果

- ✅ 秒杀轮播显示 3 条推荐商品
- ✅ 题库 Tab 显示 7 条商品
- ✅ 网课 Tab 显示 3 条商品
- ✅ 直播 Tab 显示 3 条商品

## 🎯 参数分类说明

### 业务标识参数（不用于筛选）

这些参数在真实 API 中用于业务标识，但在 Mock 模式下应该被忽略：

| 参数名 | 说明 | 为什么忽略 |
|--------|------|------------|
| `shelf_platform_id` | 货架平台ID | Mock 数据没有此字段 |
| `professional_id` | 专业ID | Mock 数据没有此字段 |
| `platform_id` | 平台ID | Mock 数据没有此字段 |
| `merchant_id` | 商户ID | Mock 数据没有此字段 |
| `brand_id` | 品牌ID | Mock 数据没有此字段 |
| `channel_id` | 渠道ID | Mock 数据没有此字段 |
| `extend_uid` | 扩展用户ID | Mock 数据没有此字段 |
| `is_buyed` | 是否已购买 | Mock 数据没有此字段 |

### 真实筛选参数（用于过滤数据）

这些参数在 Mock 模式下会真正用于筛选数据：

| 参数名 | 说明 | 示例值 |
|--------|------|--------|
| `type` | 商品类型 | `8,10,18` |
| `teaching_type` | 授课类型 | `1` (直播), `3` (网课) |
| `permission_status` | 权限状态 | `1` (已购买), `2` (未购买) |
| `is_homepage_recommend` | 是否首页推荐 | `1` (是) |

### 分页和排序参数（特殊处理）

这些参数不用于筛选，而是用于排序和分页：

| 参数名 | 说明 |
|--------|------|
| `page` | 页码 |
| `page_size` | 每页数量 |
| `sort` | 排序字段 |
| `order` | 排序方式 (asc/desc) |

## 🚨 常见问题

### Q1: 为什么不直接在 API 请求时去掉这些参数？

**回答**: 
- 这些参数是真实 API 需要的
- Mock 模式应该尽量模拟真实情况
- 只在 Mock 查询引擎中忽略，不影响真实请求

### Q2: 如果以后需要用这些参数筛选怎么办？

**回答**:
1. 在 JSON 文件中添加对应字段
2. 从非筛选参数列表中移除
3. 数据会自动按该参数筛选

例如：
```json
// goods_data.json
{
  "id": "123",
  "type": "18",
  "platform_id": "409974729504527968",  ← 添加字段
  // ...
}
```

然后从 `nonFilterParams` 中移除 `platform_id`。

### Q3: 如何判断一个参数应该被忽略？

**判断标准**:
1. Mock JSON 数据中**没有**这个字段 → 应该忽略
2. 这个参数是**业务标识**而非筛选条件 → 应该忽略
3. 这个参数用于**分页/排序** → 应该忽略

## 📝 完整的非筛选参数列表

```dart
const nonFilterParams = [
  // === 分页和排序 ===
  'page',          // 页码
  'page_size',     // 每页数量
  'pageSize',      // 每页数量（驼峰格式）
  'sort',          // 排序字段
  'order',         // 排序方式
  
  // === 业务标识参数 ===
  'shelf_platform_id',  // 货架平台ID
  'professional_id',    // 专业ID
  'is_buyed',          // 是否已购买
  'platform_id',       // 平台ID
  'merchant_id',       // 商户ID
  'brand_id',          // 品牌ID
  'channel_id',        // 渠道ID
  'extend_uid',        // 扩展用户ID
];
```

## ✅ 修复总结

**问题**: Mock 查询返回 0 条数据

**原因**: 额外的业务参数（`platform_id`, `merchant_id` 等）没有被忽略，导致筛选失败

**修复**: 将这些参数添加到非筛选参数列表

**效果**: 
- ✅ Mock 查询正常返回数据
- ✅ 题库商品显示 7 条
- ✅ 秒杀推荐显示 3 条
- ✅ 网课/直播正常显示

**修改文件**:
- `lib/core/mock/mock_query_engine.dart`

---

**最后更新**: 2025-11-25  
**状态**: ✅ 问题已修复

## 🎉 总结

现在 Mock 查询引擎会正确忽略业务标识参数，只用 `type` 和 `teaching_type` 等真实筛选条件来过滤数据，首页应该可以正常显示所有商品了！
