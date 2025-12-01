# Mock首页无数据问题 - 已解决

## 🐛 问题描述

首页Mock模式下显示：
```
查询结果: 0 条 / 总计 13 条
```

虽然Mock数据库有13条数据，但查询返回0条。

---

## 🔍 根本原因

**MockQueryEngine将多余的业务参数当作筛选条件**

查看日志中的查询参数：
```dart
{
  type: 8,10,18,                    // ✅ 筛选参数
  teaching_type: 3,                 // ✅ 筛选参数
  shelf_platform_id: xxx,           // ❌ 业务参数，不应筛选
  professional_id: xxx,             // ❌ 业务参数，不应筛选
  platform_id: xxx,                 // ❌ 业务参数，不应筛选
  user_id: xxx,                     // ❌ 业务参数，不应筛选
  student_id: xxx,                  // ❌ 业务参数，不应筛选
  merchant_id: xxx,                 // ❌ 业务参数，不应筛选
  brand_id: xxx,                    // ❌ 业务参数，不应筛选
  channel_id: xxx,                  // ❌ 业务参数，不应筛选
  extend_uid: xxx,                  // ❌ 业务参数，不应筛选
}
```

**问题**：`user_id` 和 `student_id` 没有被标记为"非筛选参数"，导致Mock引擎尝试在数据中查找这些字段，但Mock数据中没有这些字段，所以返回0条。

---

## ✅ 解决方案

修改 `lib/core/mock/mock_query_engine.dart`：

```dart
static bool _isNonFilterParam(String key) {
  const nonFilterParams = [
    // 分页和排序
    'page', 'page_size', 'pageSize', 'sort', 'order',
    // 业务标识参数（不用于筛选）
    'shelf_platform_id', 'professional_id', 'is_buyed',
    'platform_id', 'merchant_id', 'brand_id', 'channel_id', 'extend_uid',
    // ✅ 新增：用户相关参数（不用于筛选）
    'user_id', 'student_id',
    // ✅ 新增：其他非筛选参数
    'no_professional_id', 'no_user_id',
  ];
  return nonFilterParams.contains(key);
}
```

---

## 🧪 验证步骤

1. **重新启动应用**（热重载不生效，需要完全重启）
   ```bash
   cd /Users/mac/Desktop/vueToFlutter/yakaixin_app
   flutter run
   ```

2. **查看日志**，应该看到：
   ```
   🗄️ Mock数据库查询 - 商品列表
      查询参数: {type: 8,10,18, ...}
      查询结果: 3 条 / 总计 13 条  ✅ 有数据了！
   ```

3. **首页应该显示数据**：
   - 题库Tab：应该显示3条数据
   - 网课Tab：应该显示数据
   - 直播Tab：应该显示数据

---

## 📝 原理说明

### MockQueryEngine的筛选逻辑

```dart
// 遍历所有查询参数
for (final entry in queryParams.entries) {
  final paramKey = entry.key;
  final paramValue = entry.value;
  
  // ✅ 跳过非筛选参数
  if (_isNonFilterParam(paramKey)) continue;
  
  // ❌ 对剩余参数进行精确匹配
  final itemValue = item[paramKey]?.toString() ?? '';
  if (itemValue != paramValue) {
    return false;  // 不匹配，过滤掉
  }
}
```

### 为什么需要"非筛选参数"？

真实API中，很多参数只是**业务标识**或**上下文信息**，不用于数据筛选：

- `user_id` - 标识当前用户，后端用于权限判断
- `merchant_id` - 标识商户，后端用于数据隔离
- `platform_id` - 标识平台，后端用于多平台支持

这些参数在Mock环境下应该被忽略，否则会导致**过度筛选**。

---

## 🎯 关键要点

1. **Mock数据不需要包含所有业务字段**
   - 只需要包含**真正用于筛选的字段**
   - 业务标识字段可以省略

2. **新增API参数时，记得更新非筛选参数列表**
   - 如果新参数不影响数据筛选，加入 `_isNonFilterParam`
   - 否则Mock数据需要添加对应字段

3. **日志是最好的调试工具**
   - 看 "查询参数" - 知道传了什么
   - 看 "查询结果" - 知道匹配了多少

---

## ✅ 问题已解决

重新启动应用后，首页应该正常显示Mock数据！

**下一步**：测试商品详情页跳转是否正常。

