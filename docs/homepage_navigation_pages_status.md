# Flutter 首页跳转页面状态分析

根据小程序 `brushing.vue` 的跳转逻辑，本文档详细分析 Flutter 首页点击题库和秒杀内容应跳转的所有页面，并标注其实现状态和API接入情况。

---

## 📋 跳转页面总览

### 小程序跳转逻辑来源
- **小程序文件**: `mini-dev_250812/src/modules/jintiku/components/makeQuestion/examination-test-item.vue`
- **方法**: `goDetail(item)` (Line 191-343)

---

## 🎯 题库商品跳转页面清单

### 一、未购买商品跳转 (permission_status == '2')

#### 1️⃣ 页面: GoodsDetailPage (经典商品详情页)

**触发条件**:
- `details_type == 1` (经典版)
- 或 `data_type == 2 && details_type == 1` (模考+经典版)

**小程序路径**: `pages/test/detail`

**Flutter 实现状态**: ⚠️ **页面已创建，但功能未实现**

**文件位置**: `yakaixin_app/lib/features/goods/views/goods_detail_page.dart`

**当前状态**:
```dart
// ⚠️ 仅占位页面，显示"功能开发中..."
Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
    appBar: AppBar(title: const Text('商品详情')),
    body: Center(
      child: Column(
        children: [
          Icon(Icons.shopping_cart, size: 80.sp),
          Text('商品详情页'),
          Text('功能开发中...'),  // ⚠️ 未实现
        ],
      ),
    ),
  );
}
```

**需要实现的功能**:
- [ ] 获取商品详情API: `/c/goods/detail` 或类似接口
- [ ] 显示商品基本信息（名称、封面、价格）
- [ ] 显示商品详细介绍（HTML内容）
- [ ] 显示题目数量/试卷数量等
- [ ] 底部购买按钮
- [ ] 支付流程

**接口分析需求**:
```dart
// TODO: 需要确定接口
// GET /c/goods/detail?goods_id={id}&professional_id={pid}
// 或其他接口
```

---

#### 2️⃣ 页面: SecretRealDetailPage (历年真题详情页)

**触发条件**:
- `details_type == 2` (真题版)

**小程序路径**: `pages/test/secretRealDetail`

**Flutter 实现状态**: ✅ **已实现UI，使用Mock数据**

**文件位置**: `yakaixin_app/lib/features/goods/views/secret_real_detail_page.dart`

**当前状态**:
```dart
// ✅ UI已完整实现
class SecretRealDetailPage extends ConsumerStatefulWidget {
  final String? productId;
  final String? professionalId;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('绝密真题')),
      body: _buildContent(),  // ✅ 已实现UI
      bottomNavigationBar: _buildBottomBar(),  // ✅ 已实现购买栏
    );
  }
}

// ⚠️ 使用Mock数据
final Map<String, dynamic> _goodsInfo = {
  'examTitle': '口腔执业医师',
  'name': '2026口腔执业医师历年真题精选',
  'tiku_goods_details': {
    'question_num': 3580,
    'exam_time': '2026-12-31',
  },
  // ...
};
```

**需要实现的功能**:
- [ ] 替换Mock数据为真实API
- [ ] 接入商品详情API
- [ ] 接入购买/支付API
- [ ] 添加加载状态
- [ ] 添加错误处理

**接口分析需求**:
```dart
// TODO: 需要对接接口
// 参考小程序: modules/jintiku/pages/test/secretRealDetail.vue
// 可能的接口:
// GET /c/goods/detail?goods_id={id}&professional_id={pid}
```

---

#### 3️⃣ 页面: SubjectMockDetailPage (科目模考详情页)

**触发条件**:
- `details_type == 3` (科目版)

**小程序路径**: `pages/test/subjectMockDetail`

**Flutter 实现状态**: ✅ **已实现UI，使用Mock数据**

**文件位置**: `yakaixin_app/lib/features/goods/views/subject_mock_detail_page.dart`

**当前状态**:
```dart
// ✅ UI已实现
class SubjectMockDetailPage extends ConsumerStatefulWidget {
  final String? productId;
  final String? professionalId;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('科目模考')),
      body: _buildContent(),  // ✅ 已实现UI（显示长图）
      bottomNavigationBar: _buildBottomBar(),  // ✅ 已实现购买栏
    );
  }
}

// ⚠️ 使用Mock数据
final Map<String, dynamic> _goodsInfo = {
  'name': '2026口腔执业医师科目模考',
  'sale_price': '199.00',
  'longImagePath': '',  // 长图路径
};
```

**需要实现的功能**:
- [ ] 替换Mock数据为真实API
- [ ] 获取商品长图路径
- [ ] 接入购买/支付API
- [ ] 添加加载状态
- [ ] 添加错误处理

**接口分析需求**:
```dart
// TODO: 需要对接接口
// 参考小程序: modules/jintiku/pages/test/subjectMockDetail.vue
```

---

#### 4️⃣ 页面: SimulatedExamRoomPage (模拟考场页)

**触发条件**:
- `details_type == 4` (模拟版)
- 或 `data_type == 2 && details_type == 4` (模考+模拟版)

**小程序路径**: `pages/test/simulatedExamRoom`

**Flutter 实现状态**: ✅ **已实现UI，使用Mock数据**

**文件位置**: `yakaixin_app/lib/features/goods/views/simulated_exam_room_page.dart`

**当前状态**:
```dart
// ✅ UI已实现（左侧考生信息栏 + 主内容区）
class SimulatedExamRoomPage extends ConsumerStatefulWidget {
  final String? productId;
  final String? professionalId;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _buildLeftSidebar(),  // ✅ 已实现左侧栏
            _buildMainContent(),  // ✅ 已实现主内容
          ],
        ),
      ),
    );
  }
}

// ⚠️ 使用Mock数据
final Map<String, dynamic> _examInfo = {
  'examTitle': '口腔执业医师',
  'permission_status': '2',
  'mkgoods_statistics': {
    'fullMarkScore': 600,
    'examDuration': 150,
  },
};
```

**需要实现的功能**:
- [ ] 替换Mock数据为真实API
- [ ] 接入模拟考场信息API
- [ ] 实现考试列表功能
- [ ] 实现开始考试功能
- [ ] 添加权限判断（已购买/未购买）
- [ ] 添加加载状态和错误处理

**接口分析需求**:
```dart
// TODO: 需要对接接口
// 参考小程序: modules/jintiku/pages/test/simulatedExamRoom.vue
// 可能的接口:
// GET /c/exam/mkgoods?goods_id={id}
// GET /c/exam/mklist?goods_id={id}
```

---

#### 5️⃣ 页面: CourseGoodsDetailPage (课程商品详情页)

**触发条件**:
- `type == 2` (课程类型，未购买)

**小程序路径**: `pages/course/courseDetail` (无order_id)

**Flutter 实现状态**: ✅ **已实现，已接入API**

**文件位置**: `yakaixin_app/lib/features/goods/views/course_goods_detail_page.dart`

**当前状态**: ✅ **完整实现，无需修改**

---

### 二、已购买商品跳转 (permission_status == '1')

#### 6️⃣ 页面: ChapterListPage (章节练习列表)

**触发条件**:
- `type == 18` (章节练习，已购买)

**小程序路径**: `pages/chapterExercise/index`

**Flutter 实现状态**: ✅ **已实现，已接入API**

**文件位置**: `yakaixin_app/lib/features/question_bank/views/chapter_list_page.dart`

**当前状态**: ✅ **完整实现，无需修改**

---

#### 7️⃣ 页面: TestExamPage (考试页面)

**触发条件**:
- `details_type == 1` (经典版，已购买)
- 或 `details_type == 3` (科目版，已购买)

**小程序路径**: `pages/test/exam`

**Flutter 实现状态**: ✅ **已实现，已接入API**

**文件位置**: `yakaixin_app/lib/features/exam/views/test_exam_page.dart`

**当前状态**: ✅ **完整实现，无需修改**

---

#### 8️⃣ 页面: ExamInfoPage (模考信息页)

**触发条件**:
- `data_type == 2 && details_type == 1` (模考+经典版，已购买)

**小程序路径**: `pages/modelExaminationCompetition/examInfo`

**Flutter 实现状态**: ✅ **已实现，已接入API**

**文件位置**: `yakaixin_app/lib/features/model_exam/views/exam_info_page.dart`

**当前状态**: ✅ **完整实现，无需修改**

---

#### 9️⃣ 页面: CourseDetailPage (课程学习页)

**触发条件**:
- `type == 2` (课程类型，已购买)

**小程序路径**: `pages/course/courseDetail` (带order_id)

**Flutter 实现状态**: ✅ **已实现，已接入API**

**文件位置**: `yakaixin_app/lib/features/course/views/course_detail_page.dart`

**当前状态**: ✅ **完整实现，无需修改**

---

## 🔥 秒杀轮播商品跳转

秒杀商品的跳转逻辑与题库商品相同，根据 `permission_status`、`type`、`details_type`、`data_type` 判断跳转目标。

**Flutter 实现**: ✅ **已完整实现**

**实现位置**: `yakaixin_app/lib/features/home/views/home_page.dart`
- `_handleSeckillCardTap(goods)` → 调用 `_navigateToGoodsDetail()`

---

## 📊 页面实现状态汇总

### 状态分类

| 状态 | 说明 | 数量 |
|-----|------|-----|
| ✅ **完成** | 页面已实现且已接入API | 5个 |
| ⚠️ **UI完成** | 页面UI已实现，但使用Mock数据 | 3个 |
| ❌ **未实现** | 页面仅占位，功能未实现 | 1个 |

### 详细清单

| # | 页面名称 | 状态 | 说明 |
|---|---------|-----|------|
| 1 | GoodsDetailPage | ❌ **未实现** | 仅占位，显示"功能开发中..." |
| 2 | SecretRealDetailPage | ⚠️ **UI完成** | UI完整，使用Mock数据 |
| 3 | SubjectMockDetailPage | ⚠️ **UI完成** | UI完整，使用Mock数据 |
| 4 | SimulatedExamRoomPage | ⚠️ **UI完成** | UI完整，使用Mock数据 |
| 5 | CourseGoodsDetailPage | ✅ **完成** | 已接入API |
| 6 | ChapterListPage | ✅ **完成** | 已接入API |
| 7 | TestExamPage | ✅ **完成** | 已接入API |
| 8 | ExamInfoPage | ✅ **完成** | 已接入API |
| 9 | CourseDetailPage | ✅ **完成** | 已接入API |

---

## 🚀 下一步工作计划

### 优先级 P0（高优先级 - 必须完成）

#### 1. GoodsDetailPage (经典商品详情页) - ❌ 未实现

**工作内容**:
1. 分析小程序 `pages/test/detail.vue` 的接口调用
2. 确定API接口和数据结构
3. 创建 Model (使用 Freezed)
4. 创建 Service (数据层)
5. 创建 Provider (业务逻辑层)
6. 实现完整UI
7. 接入购买/支付流程

**预计工作量**: 1-2天

**小程序参考文件**:
```
mini-dev_250812/src/modules/jintiku/pages/test/detail.vue
```

---

### 优先级 P1（中优先级 - 建议完成）

#### 2. SecretRealDetailPage (历年真题详情页) - ⚠️ UI完成

**工作内容**:
1. 分析小程序接口调用
2. 创建 Model、Service、Provider
3. 替换Mock数据为真实API
4. 实现购买功能
5. 添加加载和错误状态

**预计工作量**: 0.5-1天

**小程序参考文件**:
```
mini-dev_250812/src/modules/jintiku/pages/test/secretRealDetail.vue
```

---

#### 3. SubjectMockDetailPage (科目模考详情页) - ⚠️ UI完成

**工作内容**:
1. 分析小程序接口调用
2. 创建 Model、Service、Provider
3. 替换Mock数据为真实API
4. 获取长图路径并显示
5. 实现购买功能

**预计工作量**: 0.5-1天

**小程序参考文件**:
```
mini-dev_250812/src/modules/jintiku/pages/test/subjectMockDetail.vue
```

---

#### 4. SimulatedExamRoomPage (模拟考场页) - ⚠️ UI完成

**工作内容**:
1. 分析小程序接口调用
2. 创建 Model、Service、Provider
3. 替换Mock数据为真实API
4. 实现考试列表功能
5. 实现开始考试功能
6. 权限判断

**预计工作量**: 1-1.5天

**小程序参考文件**:
```
mini-dev_250812/src/modules/jintiku/pages/test/simulatedExamRoom.vue
```

---

## 📝 API接口分析清单

以下是需要对接的API接口（根据小程序分析）：

### 1. 商品详情接口

**小程序调用**:
```javascript
// mini-dev_250812/src/modules/jintiku/pages/test/detail.vue
getGoodsDetail({
  goods_id: this.id,
  professional_id: this.professional_id
})
```

**Flutter 需要**:
```dart
// TODO: Service方法
Future<GoodsDetailModel> getGoodsDetail({
  required String goodsId,
  required String professionalId,
});
```

---

### 2. 真题详情接口

**小程序调用**:
```javascript
// mini-dev_250812/src/modules/jintiku/pages/test/secretRealDetail.vue
getGoodsDetail({
  goods_id: this.id,
  professional_id: this.professional_id
})
```

**Flutter 需要**:
```dart
// TODO: Service方法（可能与商品详情接口相同）
Future<SecretRealDetailModel> getSecretRealDetail({
  required String goodsId,
  required String professionalId,
});
```

---

### 3. 科目模考接口

**小程序调用**:
```javascript
// mini-dev_250812/src/modules/jintiku/pages/test/subjectMockDetail.vue
// 需要分析具体接口
```

**Flutter 需要**:
```dart
// TODO: Service方法
Future<SubjectMockDetailModel> getSubjectMockDetail({
  required String goodsId,
  required String professionalId,
});
```

---

### 4. 模拟考场接口

**小程序调用**:
```javascript
// mini-dev_250812/src/modules/jintiku/pages/test/simulatedExamRoom.vue
// 可能包括:
// - 获取考场信息
// - 获取考试列表
// - 获取考试详情
```

**Flutter 需要**:
```dart
// TODO: Service方法
Future<SimulatedExamRoomModel> getSimulatedExamRoom({
  required String goodsId,
  required String professionalId,
});

Future<List<ExamModel>> getExamList({
  required String goodsId,
});
```

---

## 🔧 开发建议

### 1. 按优先级依次开发

建议按照 P0 → P1 的顺序依次完成：
1. **GoodsDetailPage** (最重要，阻塞其他功能)
2. **SecretRealDetailPage**
3. **SubjectMockDetailPage**
4. **SimulatedExamRoomPage**

### 2. 复用已有架构

所有页面都应遵循已有的 MVVM 架构：
```
features/{module}/
├── models/          # Freezed Model
├── services/        # API调用
├── providers/       # 业务逻辑
└── views/           # UI页面
```

### 3. 使用Mock数据过渡

在接口未就绪前：
1. 先使用Mock数据完成UI
2. 通过Mock Interceptor模拟接口返回
3. 接口就绪后替换为真实API

### 4. 参考已完成的页面

可以参考以下已完成页面的实现：
- `CourseGoodsDetailPage` - 商品详情页参考
- `ChapterListPage` - 列表页参考
- `TestExamPage` - 考试页参考

---

## 📄 相关文档

- [商品跳转逻辑对比文档](./navigation_logic_comparison.md)
- [首页优化实现总结](./home_optimization_summary.md)
- [Flutter MVVM架构规范](../.cursor/rules/removetoflutter.mdc)

---

**文档版本**: v1.0
**创建日期**: 2025-11-29
**维护人**: AI Assistant

