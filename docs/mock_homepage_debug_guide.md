# Mock首页数据调试指南

## 问题：首页没有数据显示

### 原因分析

1. **非筛选参数**: `MockQueryEngine` 将以下参数设置为"非筛选参数"：
   - `shelf_platform_id` - 货架平台ID
   - `professional_id` - 专业ID  
   - `is_buyed` - 是否已购买

2. **首页查询参数**: 
```dart
// 题库查询
getGoodsList(
  shelfPlatformId: ApiConfig.shelfPlatformId,  // ✅ 被忽略
  professionalId: majorId,                      // ✅ 被忽略  
  type: '8,10,18',                              // ❌ 必须匹配
)

// 网课查询
getGoodsList(
  shelfPlatformId: ApiConfig.shelfPlatformId,  // ✅ 被忽略
  teachingType: '3',                             // ❌ 必须匹配
  type: '2,3',                                   // ❌ 必须匹配
)
```

3. **Mock数据匹配规则**:
   - `type` 字段必须精确匹配（支持逗号分隔）
   - `teaching_type` 字段必须精确匹配
   - 其他参数被忽略

### 解决方案

#### 方案1: 确保Mock数据包含所有type和teaching_type组合 ✅

**题库数据** (type=8,10,18):
```json
// goods_data.json 中确保包含
{ "type": "8", "teaching_type": "0", ... },  // 试卷
{ "type": "10", "teaching_type": "0", ... }, // 模考
{ "type": "18", "teaching_type": "0", ... }, // 章节练习
```

**网课数据** (teaching_type=3, type=2,3):
```json
{ "type": "2", "teaching_type": "3", ... },  // 网课-录播
{ "type": "3", "teaching_type": "3", ... },  // 系列课-录播
```

**直播数据** (teaching_type=1, type=2,3):
```json
{ "type": "2", "teaching_type": "1", ... },  // 直播课
{ "type": "3", "teaching_type": "1", ... },  // 系列直播
```

#### 方案2: 调试日志查看

启动应用后，查看控制台日志：

```bash
# Mock数据库初始化
🗄️ 初始化 Mock 数据库...
   ✅ 商品数据加载成功: XX 条

# Mock查询
🗄️ Mock数据库查询 - 商品列表
   查询参数: {shelf_platform_id: xxx, type: 8,10,18, ...}
   查询结果: 0 条 / 总计 XX 条  # ❌ 如果是0条，说明筛选有问题
```

#### 方案3: 临时修改Mock数据

如果发现没有匹配的数据，修改 `goods_data.json`:

1. 确保至少有1条 `type="18"` 的数据
2. 确保至少有1条 `type="2", teaching_type="3"` 的数据  
3. 确保至少有1条 `type="2", teaching_type="1"` 的数据

### 快速修复

修改 `goods_data.json` 第7-23行（第一条数据）：

```json
{
  "id": "593505082385898224",
  "name": "2026高清网课—口腔组织病理学",
  "material_cover_path": "408559575579495187/2025/10/29/17617022592896af0-1761702259289-92214.jpg",
  "type": "18",  // ✅ 确保是字符串 "18"
  "type_name": "章节练习",
  "teaching_type": "0",  // ✅ 题库类型设为 "0"
  "details_type": 1,
  "sale_price": "299.00",
  "original_price": "399.00",
  "permission_status": "1",
  "is_homepage_recommend": "1",
  "seckill_countdown": null,
  "validity_day": "0",
  "student_num": "1256",
  "create_time": "2025-10-29 10:00:00"
}
```

### 验证步骤

1. 重新启动应用
2. 查看日志确认数据加载成功
3. 查看首页是否显示数据
4. 如果还是没有，检查 `type` 和 `teaching_type` 字段值

### 调试命令

```bash
# 在Mock数据中搜索type字段
grep '"type":' assets/mock/goods_data.json | head -20

# 检查teaching_type分布
grep '"teaching_type":' assets/mock/goods_data.json | sort | uniq -c
```

---

**关键提示**: Mock数据中的 `type` 和 `teaching_type` 必须是字符串类型！

