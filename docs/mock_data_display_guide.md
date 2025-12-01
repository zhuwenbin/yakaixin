# Mock数据显示与跳转测试指南

## ✅ 最新更新

**Mock数据已更新**，所有商品名称现在清楚标识跳转目标页面！

---

## 📊 Mock数据清单（首页显示）

### 题库Tab (type=8,10,18)

| 序号 | 商品名称 | 跳转页面 | 类型 | 购买状态 |
|-----|---------|---------|------|---------|
| 1 | 【跳转→GoodsDetailPage】口腔组织病理学题库 | GoodsDetailPage | type=18 | 未购买 |
| 2 | 【跳转→SecretRealDetailPage】2026口腔执业医师历年真题 | SecretRealDetailPage | type=8 | 未购买 |
| 3 | 【跳转→SimulatedExamRoomPage】口腔医学综合模拟考场 | SimulatedExamRoomPage | type=10 | 未购买 |
| 4 | 【跳转→SubjectMockDetailPage】口腔解剖学科目模考 | SubjectMockDetailPage | type=8 | 未购买 |
| 5 | 【跳转→SecretRealDetailPage】口腔修复学历年真题 | SecretRealDetailPage | type=8 | 已购买 |
| 6 | 【跳转→GoodsDetailPage】口腔预防医学题库 | GoodsDetailPage | type=18 | 未购买 |
| 7 | 【跳转→SimulatedExamRoomPage】口腔综合能力模拟考场 | SimulatedExamRoomPage | type=10 | 已购买 |

### 网课Tab (teaching_type=3, type=2,3)

| 序号 | 商品名称 | 跳转页面 | 类型 | 购买状态 |
|-----|---------|---------|------|---------|
| 1 | 【跳转→CourseGoodsDetailPage】口腔正畸学精品网课 | CourseGoodsDetailPage | type=2 | 未购买 |
| 2 | 【跳转→CourseGoodsDetailPage】口腔病理学系列课 | CourseGoodsDetailPage | type=3 | 未购买 |
| 3 | 【跳转→CourseGoodsDetailPage】口腔内科学精讲网课 | CourseGoodsDetailPage | type=2 | 未购买 |

### 直播Tab (teaching_type=1, type=2,3)

| 序号 | 商品名称 | 跳转页面 | 类型 | 购买状态 |
|-----|---------|---------|------|---------|
| 1 | 【跳转→CourseGoodsDetailPage】口腔颌面外科直播课 | CourseGoodsDetailPage | type=2 | 未购买 |
| 2 | 【跳转→CourseGoodsDetailPage】口腔医学系列直播课程 | CourseGoodsDetailPage | type=3 | 已购买 |
| 3 | 【跳转→CourseGoodsDetailPage】口腔执业医师考前冲刺直播 | CourseGoodsDetailPage | type=2 | 已购买 |

---

## 🧪 测试步骤

### Step 1: 重启应用（必须！）

```bash
cd /Users/mac/Desktop/vueToFlutter/yakaixin_app
flutter run
```

### Step 2: 查看首页数据

应该看到：

**题库Tab**:
- 【跳转→GoodsDetailPage】口腔组织病理学题库
- 【跳转→SecretRealDetailPage】2026口腔执业医师历年真题
- 【跳转→SimulatedExamRoomPage】口腔医学综合模拟考场
- ...（共7条）

**网课Tab**:
- 【跳转→CourseGoodsDetailPage】口腔正畸学精品网课
- 【跳转→CourseGoodsDetailPage】口腔病理学系列课
- 【跳转→CourseGoodsDetailPage】口腔内科学精讲网课

**直播Tab**:
- 【跳转→CourseGoodsDetailPage】口腔颌面外科直播课
- 【跳转→CourseGoodsDetailPage】口腔医学系列直播课程
- 【跳转→CourseGoodsDetailPage】口腔执业医师考前冲刺直播

### Step 3: 测试跳转

#### 测试1: GoodsDetailPage（经典商品详情）
1. 点击"【跳转→GoodsDetailPage】口腔组织病理学题库"
2. 应该跳转到商品详情页
3. 显示：章节树、价格选项、商品介绍

#### 测试2: SecretRealDetailPage（历年真题详情）
1. 点击"【跳转→SecretRealDetailPage】2026口腔执业医师历年真题"
2. 应该跳转到历年真题详情页
3. 显示：绝密真题标签、题目数量、做题统计

#### 测试3: SubjectMockDetailPage（科目模考详情）
1. 点击"【跳转→SubjectMockDetailPage】口腔解剖学科目模考"
2. 应该跳转到科目模考详情页
3. 显示：长图介绍

#### 测试4: SimulatedExamRoomPage（模拟考场）
1. 点击"【跳转→SimulatedExamRoomPage】口腔医学综合模拟考场"
2. 应该跳转到模拟考场页
3. 显示：左侧信息栏、考试列表区域

#### 测试5: CourseGoodsDetailPage（课程详情）
1. 切换到"网课"或"直播"Tab
2. 点击任意课程卡片
3. 应该跳转到课程详情页
4. 显示：课程章节、教师信息

---

## 🎯 跳转逻辑验证

### 题库类商品跳转规则

根据 `home_page.dart` 的跳转逻辑：

```dart
// 未购买状态 (permission_status == '2')
if (type == 2) {
  // 课程 → CourseGoodsDetailPage
} else if (dataType == 2) {
  // 模考 (dataType == 2)
  if (detailsType == 4) {
    // → SimulatedExamRoomPage
  } else {
    // → GoodsDetailPage
  }
} else {
  // 根据 detailsType 跳转
  switch (detailsType) {
    case 1: // → GoodsDetailPage
    case 2: // → SecretRealDetailPage
    case 3: // → SubjectMockDetailPage
    case 4: // → SimulatedExamRoomPage
  }
}
```

### Mock数据字段说明

| 字段 | 值 | 说明 |
|-----|---|------|
| type | 18 | 题库/章节练习 |
| type | 8 | 试卷 |
| type | 10 | 模考 |
| type | 2 | 网课 |
| type | 3 | 系列课 |
| details_type | 1 | 经典商品详情 |
| details_type | 2 | 历年真题详情 |
| details_type | 3 | 科目模考详情 |
| details_type | 4 | 模拟考场 |
| data_type | 2 | 模考类型 |

---

## ✅ 预期结果

### 控制台日志

```
🗄️ Mock数据库查询 - 商品列表
   查询参数: {type: 8,10,18, ...}
   查询结果: 7 条 / 总计 13 条  ✅

📚 [题库数据] 获取到 7 条数据
🎓 [网课数据] 获取到 3 条数据（已增强）
📡 [直播数据] 获取到 3 条数据（已增强）

🔍 Mock拦截器: GET /c/goods/v2/detail?goods_id=593505082385898224
✅ Mock数据命中
🗄️ Mock数据库查询 - 商品详情
   商品ID: 593505082385898224
   ✅ 查询成功: 【跳转→GoodsDetailPage】口腔组织病理学题库
```

### 首页显示

- ✅ 题库Tab显示7条数据
- ✅ 网课Tab显示3条数据
- ✅ 直播Tab显示3条数据
- ✅ 所有卡片标题都带【跳转→XXX】标识

### 详情页跳转

- ✅ 点击卡片正确跳转
- ✅ 详情页正确显示数据
- ✅ 已购买/未购买状态正确
- ✅ 底部按钮正确显示

---

## 🐛 如果遇到问题

### 问题1: 首页还是没有数据
**检查**: 是否完全重启应用（热重载不生效）
**解决**: `flutter run` 重新运行

### 问题2: 点击卡片没反应
**检查**: 路由配置是否正确
**解决**: 检查 `app_router.dart` 中的路由定义

### 问题3: 详情页显示空白
**检查**: `goods_detail_data.json` 是否有对应ID的数据
**解决**: 添加对应商品ID到 `goods_detail_data.json`

---

## 📝 注意事项

1. **商品ID对应关系**
   - `goods_data.json` - 首页列表数据
   - `goods_detail_data.json` - 详情页数据
   - ID必须一致才能正确跳转

2. **Mock数据同步**
   - 修改列表数据后，记得添加对应的详情数据
   - 确保 `type`, `details_type`, `data_type` 字段正确

3. **测试覆盖**
   - 已购买状态（permission_status='1'）
   - 未购买状态（permission_status='2'）
   - 不同详情页类型（details_type=1,2,3,4）

---

**现在重新启动应用，首页应该正常显示数据，并且可以正确跳转到各个详情页！** ✅

