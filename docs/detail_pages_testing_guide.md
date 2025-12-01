# 📱 详情页跳转测试指南

## 🎯 测试目标

验证首页到4个详情页的跳转逻辑和页面显示是否正确。

---

## ✅ 前置准备

### 1. 开启Mock模式
- 进入调试页面（从首页点击调试入口）
- 找到"Mock数据模式"开关
- 确保开关为**开启**状态

### 2. 刷新首页数据
- 返回首页
- 下拉刷新页面
- 确认看到Mock数据商品

---

## 📋 测试场景

### 场景1: GoodsDetailPage（经典商品详情页）

**测试商品**：`【跳转→GoodsDetailPage】口腔组织病理学题库`

**跳转条件**：
- `type = 18`（题库）
- `permission_status = 2`（未购买）
- `details_type = 1`（经典商品）

**验证点**：
- ✅ 显示商品封面图
- ✅ 显示商品名称和副标题
- ✅ 显示价格选择（多个有效期）
- ✅ 显示章节信息（type=18题库专有）
- ✅ 显示商品介绍（HTML格式）
- ✅ 底部购买栏正常显示
- ✅ 点击购买按钮显示"购买功能开发中..."

**操作步骤**：
1. 在首页"题库"Tab找到该商品
2. 点击商品卡片
3. 验证页面显示

---

### 场景2: SecretRealDetailPage（绝密真题详情页）

**测试商品**：
- **未购买**：`【跳转→SecretRealDetailPage】2026口腔执业医师历年真题`
- **已购买**：`【跳转→SecretRealDetailPage】口腔修复学历年真题`

**跳转条件**：
- `type = 8`（试卷）
- `details_type = 2`（历年真题）

**验证点**：
- ✅ 渐变背景色（从蓝色到浅蓝）
- ✅ 白色圆角卡片布局
- ✅ 显示考试标题（`exam_title`）
- ✅ 显示"绝密真题"标签
- ✅ 显示题目内容标题
- ✅ 显示统计信息列表：
  - 题目总数
  - 练习次数
  - 正确率
  - 错题链接（点击显示"错题本功能开发中..."）
  - 有效期
- ✅ 底部按钮：
  - 未购买显示"立即购买"
  - 已购买显示"开始冲刺做题"

**操作步骤**：
1. 在首页"题库"Tab找到该商品
2. 点击商品卡片
3. 验证页面显示
4. 测试已购买和未购买状态

---

### 场景3: SubjectMockDetailPage（科目模考详情页）

**测试商品**：`【跳转→SubjectMockDetailPage】口腔解剖学科目模考`

**跳转条件**：
- `type = 8`（试卷）
- `details_type = 3`（科目模考）

**验证点**：
- ✅ 全屏显示长图介绍
- ✅ 图片自适应宽度
- ✅ 底部固定购买栏
- ✅ 显示价格（¥399.00）
- ✅ 显示"立即购买"按钮
- ✅ 图片加载失败显示占位图
- ✅ 图片加载中显示进度条

**操作步骤**：
1. 在首页"题库"Tab找到该商品
2. 点击商品卡片
3. 验证长图加载和显示
4. 滚动查看完整长图

---

### 场景4: SimulatedExamRoomPage（模拟考场页）

**测试商品**：`【跳转→SimulatedExamRoomPage】口腔医学综合模拟考场`

**跳转条件**：
- `type = 10`（模拟考试）
- 或 `data_type = 2`（模考类型）
- 或 `details_type = 4`（模拟考场）

**验证点**：
- ✅ 左侧边栏显示：
  - 专业名称（口腔执业医师）
  - 满分（600分）
  - 时长（150分钟）
- ✅ 右侧内容区显示：
  - 考场标题
  - 副标题（查漏补缺 直击重点）
  - 总分和时间信息
  - 考试统计表格占位
  - 注意事项（3条，第2条"1"为红色加粗）
- ✅ 底部"进入考场"按钮
- ✅ 点击按钮显示"考试列表功能开发中..."

**操作步骤**：
1. 在首页"题库"Tab找到该商品
2. 点击商品卡片
3. 验证横向布局
4. 验证注意事项格式

---

## 🔍 常见问题排查

### 问题1: 首页没有数据

**原因**：Mock模式未正确启用

**解决方案**：
1. 检查调试页面Mock开关状态
2. 确认`MockInterceptor`已注入
3. 查看控制台日志：
   ```
   ✅ [MockInterceptor] Mock模式已启用
   ✅ Mock数据库初始化成功
   ✅ 商品数据加载成功: 13 条
   ```

---

### 问题2: 点击商品无反应

**原因**：路由配置问题

**解决方案**：
1. 检查`app_router.dart`路由配置
2. 确认`GoRouterState.extra`参数传递
3. 查看控制台是否有路由错误

---

### 问题3: 详情页显示"暂无数据"

**原因**：Mock数据中找不到对应的`goods_id`

**解决方案**：
1. 检查`goods_detail_data.json`中是否有该商品数据
2. 确认`goods_id`匹配
3. 查看控制台日志：
   ```
   ✅ [MockDatabase] 查询商品详情: goods_id=593505082385898224
   ```

---

### 问题4: 页面报错"类型转换失败"

**原因**：数据类型不匹配

**解决方案**：
1. 检查Mock数据字段类型
2. 确认使用了`SafeTypeConverter`
3. 查看具体错误信息

---

## 📊 测试记录表

| 测试场景 | 预期结果 | 实际结果 | 状态 | 备注 |
|---------|---------|---------|------|------|
| GoodsDetailPage未购买 | 显示购买按钮 | | ⬜ | |
| GoodsDetailPage已购买 | 显示做题按钮 | | ⬜ | |
| SecretRealDetailPage未购买 | 显示立即购买 | | ⬜ | |
| SecretRealDetailPage已购买 | 显示开始做题 | | ⬜ | |
| SubjectMockDetailPage | 长图加载 | | ⬜ | |
| SimulatedExamRoomPage | 横向布局 | | ⬜ | |

---

## 🎯 验收标准

### 通过条件
- ✅ 所有4个页面都能正常跳转
- ✅ 页面布局与小程序一致
- ✅ 数据显示正确（使用Mock数据）
- ✅ 已购买/未购买状态正确显示
- ✅ 图片加载正常（或显示占位图）
- ✅ 无控制台错误或崩溃

### 不通过条件
- ❌ 任何页面无法跳转
- ❌ 页面显示空白或报错
- ❌ 数据类型转换失败
- ❌ 控制台出现红色错误

---

## 📞 技术支持

### Mock数据文件位置
- 商品列表：`assets/mock/goods_data.json`
- 商品详情：`assets/mock/goods_detail_data.json`

### Provider位置
- GoodsDetail: `lib/features/goods/providers/goods_detail_provider.dart`
- SecretReal: `lib/features/goods/providers/secret_real_detail_provider.dart`
- SubjectMock: `lib/features/goods/providers/subject_mock_detail_provider.dart`
- SimulatedExam: `lib/features/goods/providers/simulated_exam_room_provider.dart`

### Model位置
- `lib/features/goods/models/goods_detail_model.dart`

### 参考文档
- [详情页实现总结](./detail_pages_implementation_summary.md)
- [Mock架构完整方案](./mock_complete_solution.md)
- [主要跳转路由](./主要跳转路由.md)

---

**测试时间**：_______  
**测试人**：_______  
**测试结果**：⬜ 通过 ⬜ 不通过  
**备注**：_______________________


