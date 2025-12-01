# 商品跳转逻辑对比文档

本文档对比小程序和 Flutter 的商品卡片点击跳转逻辑，确保实现的完整性和正确性。

---

## 📋 目录
1. [题库商品跳转逻辑](#1-题库商品跳转逻辑)
2. [课程商品跳转逻辑](#2-课程商品跳转逻辑)
3. [跳转参数对照表](#3-跳转参数对照表)
4. [实现状态总结](#4-实现状态总结)

---

## 1. 题库商品跳转逻辑

### 小程序逻辑来源
- **文件**: `mini-dev_250812/src/modules/jintiku/components/makeQuestion/examination-test-item.vue`
- **方法**: `goDetail(item)` (Line 165-343)

### 跳转逻辑决策树

```
题库商品 (type: 8/10/18)
│
├─ permission_status == '2' (未购买)
│  │
│  ├─ type == 2 (课程类型) → courseDetail
│  │
│  ├─ data_type == 2 (模考类型)
│  │  ├─ details_type == 1 → 经典商品详情 (pages/test/detail)
│  │  └─ details_type == 4 → 模拟考试房间 (pages/test/simulatedExamRoom)
│  │
│  └─ 根据 details_type 分发:
│     ├─ details_type == 1 → 经典商品详情 (pages/test/detail)
│     ├─ details_type == 2 → 真题商品详情 (pages/test/secretRealDetail)
│     ├─ details_type == 3 → 科目商品详情 (pages/test/subjectMockDetail)
│     └─ details_type == 4 → 模拟商品详情 (pages/test/simulatedExamRoom)
│
└─ permission_status == '1' (已购买)
   │
   ├─ type == 2 (课程类型) → courseDetail
   │
   ├─ type == 18 (章节练习) → 章节练习页 (pages/chapterExercise/index)
   │
   ├─ data_type == 2 (模考类型)
   │  ├─ details_type == 1 → 模考信息页 (pages/modelExaminationCompetition/examInfo)
   │  └─ details_type == 4 → 模拟考试房间 (pages/test/simulatedExamRoom)
   │
   └─ 根据 details_type 分发:
      ├─ details_type == 1 → 考试页面 (pages/test/exam)
      ├─ details_type == 2 → 真题商品详情 (pages/test/secretRealDetail)
      ├─ details_type == 3 → 考试页面 (pages/test/exam)
      └─ details_type == 4 → 模拟考试房间 (pages/test/simulatedExamRoom)
```

### Flutter 实现对照

#### ✅ 未购买跳转 (permission_status == '2')

**实现位置**: `yakaixin_app/lib/features/home/views/home_page.dart`
**方法**: `_navigateToGoodsDetail()` (Line 500-596)

| 小程序条件 | 小程序跳转 | Flutter路由 | Flutter extra | 状态 |
|---|---|---|---|---|
| `type == 2` | `pages/course/courseDetail` | `AppRoutes.goodsDetail` | `{goods_id, professional_id, type}` | ✅ |
| `data_type == 2 && details_type == 1` | `pages/test/detail` | `AppRoutes.goodsDetail` | `{goods_id, professional_id}` | ✅ |
| `data_type == 2 && details_type == 4` | `pages/test/simulatedExamRoom` | `AppRoutes.simulatedExamRoom` | `{product_id, professional_id}` | ✅ |
| `details_type == 1` | `pages/test/detail` | `AppRoutes.goodsDetail` | `{goods_id, professional_id}` | ✅ |
| `details_type == 2` | `pages/test/secretRealDetail` | `AppRoutes.secretRealDetail` | `{product_id, professional_id}` | ✅ |
| `details_type == 3` | `pages/test/subjectMockDetail` | `AppRoutes.subjectMockDetail` | `{product_id, professional_id}` | ✅ |
| `details_type == 4` | `pages/test/simulatedExamRoom` | `AppRoutes.simulatedExamRoom` | `{product_id, professional_id}` | ✅ |

#### ✅ 已购买跳转 (permission_status == '1')

**实现位置**: `yakaixin_app/lib/features/home/views/home_page.dart`
**方法**: `_navigateToChapterPractice()` (Line 598-693)

| 小程序条件 | 小程序跳转 | Flutter路由 | Flutter extra | 状态 |
|---|---|---|---|---|
| `type == 2` | `pages/course/courseDetail` | `AppRoutes.goodsDetail` | `{goods_id, professional_id, type}` | ✅ |
| `type == 18` | `pages/chapterExercise/index` | `AppRoutes.chapterList` | `{goods_id, professional_id, total}` | ✅ |
| `data_type == 2 && details_type == 1` | `pages/modelExaminationCompetition/examInfo` | `AppRoutes.examInfo` | `{product_id, title, page}` | ✅ |
| `data_type == 2 && details_type == 4` | `pages/test/simulatedExamRoom` | `AppRoutes.simulatedExamRoom` | `{product_id, professional_id}` | ✅ |
| `details_type == 1` | `pages/test/exam` | `AppRoutes.testExam` | `{id, recitation_question_model}` | ✅ |
| `details_type == 2` | `pages/test/secretRealDetail` | `AppRoutes.secretRealDetail` | `{product_id, professional_id}` | ✅ |
| `details_type == 3` | `pages/test/exam` | `AppRoutes.testExam` | `{id, recitation_question_model}` | ✅ |
| `details_type == 4` | `pages/test/simulatedExamRoom` | `AppRoutes.simulatedExamRoom` | `{product_id, professional_id}` | ✅ |

---

## 2. 课程商品跳转逻辑

### 小程序逻辑来源
- **文件**: `mini-dev_250812/src/modules/jintiku/components/makeQuestion/examination-course-item.vue`
- **方法**: `goCourseDetail(item)` (Line 226-246)

### 跳转逻辑决策树

```
课程商品 (type: 2/3, teaching_type: 1/3)
│
├─ permission_status == '2' (未购买)
│  └─ pages/course/courseDetail (商品详情/报名页)
│
└─ permission_status == '1' (已购买)
   └─ pages/course/courseDetail (课程学习页，带 order_id)
```

**⚠️ 关键差异**: 
- 小程序的 `courseDetail` 页面通过是否有 `order_id` 参数来区分：
  - **无 order_id**: 显示商品详情（报名页）
  - **有 order_id**: 显示课程学习内容

### Flutter 实现对照

**实现位置**: `yakaixin_app/lib/features/home/views/home_page.dart`
**方法**: `_handleCourseCardTap()` (Line 728-788)

#### ✅ 课程跳转逻辑

| 小程序条件 | 小程序跳转 | Flutter路由 | Flutter extra | 状态 |
|---|---|---|---|---|
| `permission_status == '2'`<br/>(未购买) | `pages/course/courseDetail`<br/>(无order_id) | `AppRoutes.goodsDetail`<br/>(商品详情页) | `{goods_id, professional_id, type}` | ✅ |
| `permission_status == '1'`<br/>(已购买) | `pages/course/courseDetail`<br/>(有order_id) | `AppRoutes.courseDetail`<br/>(课程学习页) | `{goodsId, orderId, goodsPid}` | ✅ |

#### 🔍 Flutter 架构优化

Flutter 使用了两个独立的页面，职责更清晰：
1. **`CourseGoodsDetailPage`** (`AppRoutes.goodsDetail` when type=2/3): 商品详情/报名页
2. **`CourseDetailPage`** (`AppRoutes.courseDetail`): 课程学习页

**优势**:
- 避免单个页面承载过多逻辑
- 更符合 MVVM 架构的单一职责原则
- 减少条件判断，提高代码可维护性

---

## 3. 跳转参数对照表

### 小程序 → Flutter 参数映射

| 小程序参数 | 小程序示例 | Flutter参数 | Flutter示例 | 说明 |
|---|---|---|---|---|
| `id` | `?id=123` | `goods_id` / `product_id` | `extra: {'goods_id': '123'}` | 商品ID |
| `professional_id` | `?professional_id=456` | `professional_id` | `extra: {'professional_id': '456'}` | 专业ID |
| `type` | `?type=2` | `type` | `extra: {'type': 2}` | 商品类型 |
| `total` | `?total=3580` | `total` | `extra: {'total': questionNum}` | 题目总数 |
| `title` | `?title=模考` | `title` | `extra: {'title': goods.name}` | 标题 |
| `page` | `?page=home` | `page` | `extra: {'page': 'home'}` | 来源页面 |
| `recitation_question_model` | `?recitation_question_model=1` | `recitation_question_model` | `extra: {'recitation_question_model': ...}` | 背诵模式 |
| `order_id` | `?order_id=789` | `orderId` | `extra: {'orderId': '789'}` | 订单ID |

### Flutter 路由命名规范

| 小程序路径 | Flutter路由常量 | Flutter页面 |
|---|---|---|
| `pages/test/detail` | `AppRoutes.goodsDetail` | `GoodsDetailPage` |
| `pages/test/secretRealDetail` | `AppRoutes.secretRealDetail` | `SecretRealDetailPage` |
| `pages/test/subjectMockDetail` | `AppRoutes.subjectMockDetail` | `SubjectMockDetailPage` |
| `pages/test/simulatedExamRoom` | `AppRoutes.simulatedExamRoom` | `SimulatedExamRoomPage` |
| `pages/test/exam` | `AppRoutes.testExam` | `TestExamPage` |
| `pages/chapterExercise/index` | `AppRoutes.chapterList` | `ChapterListPage` |
| `pages/modelExaminationCompetition/examInfo` | `AppRoutes.examInfo` | `ExamInfoPage` |
| `pages/course/courseDetail` (未购买) | `AppRoutes.goodsDetail` (type=2/3) | `CourseGoodsDetailPage` |
| `pages/course/courseDetail` (已购买) | `AppRoutes.courseDetail` | `CourseDetailPage` |

---

## 4. 实现状态总结

### ✅ 已完成功能 (100%)

#### 题库商品跳转 (18/18)
- [x] 未购买 - type == 2 课程跳转
- [x] 未购买 - 模考+经典版 跳转
- [x] 未购买 - 模考+模考版 跳转
- [x] 未购买 - details_type == 1 经典详情
- [x] 未购买 - details_type == 2 真题详情
- [x] 未购买 - details_type == 3 科目详情
- [x] 未购买 - details_type == 4 模拟详情
- [x] 已购买 - type == 2 课程跳转
- [x] 已购买 - type == 18 章节练习
- [x] 已购买 - 模考+经典版 跳转
- [x] 已购买 - 模考+模考版 跳转
- [x] 已购买 - details_type == 1 考试页
- [x] 已购买 - details_type == 2 真题详情
- [x] 已购买 - details_type == 3 考试页
- [x] 已购买 - details_type == 4 模拟详情
- [x] 秒杀轮播商品跳转
- [x] 已购试题列表跳转
- [x] 全局Tab参数支持

#### 课程商品跳转 (2/2)
- [x] 未购买 - 商品详情页
- [x] 已购买 - 课程学习页

### 🎯 代码质量

#### 代码组织
- ✅ 遵循 MVVM 架构
- ✅ View 层不包含业务逻辑
- ✅ 使用独立方法封装跳转逻辑
- ✅ 代码注释清晰，标注对应小程序行号

#### 类型安全
- ✅ 使用 `SafeTypeConverter` 处理 dynamic 字段
- ✅ 统一使用 `.toString()` 转换类型进行比较
- ✅ 避免 `as int` 类型转换错误

#### 路由管理
- ✅ 使用 GoRouter 统一管理路由
- ✅ 路由常量定义在 `AppRoutes` 中
- ✅ extra 参数类型安全传递

### 🔍 测试建议

#### 关键测试场景

1. **题库商品**
   - [ ] 点击未购买经典商品 (details_type=1) → 跳转商品详情
   - [ ] 点击未购买真题商品 (details_type=2) → 跳转真题详情
   - [ ] 点击未购买科目商品 (details_type=3) → 跳转科目详情
   - [ ] 点击未购买模拟商品 (details_type=4) → 跳转模拟考试房间
   - [ ] 点击已购买章节练习 (type=18) → 跳转章节列表
   - [ ] 点击已购买经典商品 → 跳转考试页
   - [ ] 点击已购买模考 (data_type=2, details_type=1) → 跳转模考信息页

2. **课程商品**
   - [ ] 点击未购买网课 → 跳转课程商品详情页
   - [ ] 点击已购买网课 → 跳转课程学习页（验证 orderId 传递）
   - [ ] 点击未购买直播 → 跳转课程商品详情页
   - [ ] 点击已购买直播 → 跳转课程学习页（验证 orderId 传递）

3. **全局Tab参数**
   - [ ] 从其他页面传递 `index=2` → 首页切换到网课Tab
   - [ ] 从其他页面传递 `index=3` → 首页切换到直播Tab
   - [ ] 无参数 → 默认显示题库Tab

4. **数据增强**
   - [ ] 验证网课列表 `new_type_name` 字段正确
   - [ ] 验证直播列表 `shop_type` 字段正确
   - [ ] 验证教师数据只显示前4个

---

## 📝 总结

### ✅ 完成度: 100%

**题库商品跳转**: 18/18 场景已实现
**课程商品跳转**: 2/2 场景已实现
**全局Tab参数**: ✅ 已实现
**课程数据增强**: ✅ 已实现

### 🎉 实现亮点

1. **完整性**: 覆盖小程序所有跳转场景，无遗漏
2. **架构优化**: 课程页拆分为商品详情和学习页，职责更清晰
3. **类型安全**: 使用 `SafeTypeConverter` 和 `.toString()` 避免类型转换错误
4. **代码可读性**: 详细注释，标注对应小程序行号，便于维护
5. **可扩展性**: 使用路由常量和 extra 参数，易于扩展新页面

### 🔄 后续优化建议

1. **配置接口集成**: 实现 `getConfigCommon` 动态控制 Tab 显示（已标注TODO）
2. **单元测试**: 为跳转逻辑编写单元测试
3. **埋点统计**: 添加商品点击埋点，跟踪用户行为
4. **性能监控**: 监控页面跳转性能，优化加载速度

---

**文档版本**: v1.0
**更新日期**: 2025-11-29
**维护人**: AI Assistant

