# 学习课程详情页 UI/逻辑差异分析

## 🔍 小程序 vs Flutter 详细对比

### ❌ 缺失功能

#### 1. **资料下载按钮** (重要！)
**小程序 Line 197-202**:
```vue
<view v-if="lessons.resource_document.length" @click="goDataDownload(...)">
  <image src="ziliao.png" />
  <text>资料</text>
</view>
```

**Flutter**: ❌ 未实现

**影响**: 用户无法下载课程讲义资料

---

#### 2. **底部作业列表** (evaluation_type_bottom)
**小程序 Line 204-225**:
```vue
<view v-if="lessons.evaluation_type_bottom.length">
  <view v-for="independent in lessons.evaluation_type_bottom">
    <text>{{ independent.name }}</text>
    <view v-if="independent.is_evaluation == '1'">已完成</view>
    <view v-if="independent.is_evaluation == '2'" @click="goAnswer(...)">去考试</view>
  </view>
</view>
```

**Flutter**: ❌ 未实现

**影响**: 缺少课后作业/独立测评入口

---

#### 3. **章节嵌套结构** (新课程列表格式)
**小程序 Line 231-292**:
```vue
<!-- 新版：班级 > 章节 > 课节 三级结构 -->
<view class="chapter-block" v-for="chapt in itemCo.lesson">
  <view class="chapter-title">{{ chapt.name }}</view>
  <view v-if="!chapt.isClose">
    <view v-for="subItem in chapt.showSub">
      {{ subItem.lesson_name }}
    </view>
  </view>
</view>
```

**Flutter**: ❌ 未实现  
**当前**: 只支持班级 > 课节两级结构

**影响**: 如果API返回章节结构，会显示不正确

---

### ⚠️ 数据字段缺失

| 字段 | 小程序 | Flutter | 影响 |
|------|--------|---------|------|
| `resource_document` | ✅ 有 | ❌ 无 | 无法显示资料按钮 |
| `evaluation_type_bottom` | ✅ 有 | ❌ 无 | 无法显示底部作业 |
| `lesson.isOpen` | ✅ 有 | ❌ 无 | 课节描述展开状态 |
| `chapt.showSub` | ✅ 有 | ❌ 无 | 章节嵌套结构 |

---

### ✅ 已实现功能（正确）

| 功能 | 小程序 | Flutter | 状态 |
|------|--------|---------|------|
| 课程名称+标签 | ✅ | ✅ | 完全一致 |
| 课程日期 | ✅ | ✅ | 完全一致 |
| 学习进度条 | ✅ | ✅ | 完全一致 |
| 教师信息 | ✅ | ✅ | 完全一致 |
| 继续学习卡片 | ✅ | ✅ | 完全一致 |
| 班级列表 | ✅ | ✅ | 完全一致 |
| 展开/折叠 | ✅ | ✅ | 完全一致 |
| 课节编号 | ✅ | ✅ | 完全一致 |
| 课节名称 | ✅ | ✅ | 完全一致 |
| 课节描述 | ✅ | ✅ | 完全一致 |
| 直播/回放标识 | ✅ | ✅ | 完全一致 |
| 学习状态 | ✅ | ✅ | 完全一致 |
| 顶部作业按钮 | ✅ | ✅ | 完全一致 |
| "去学习"按钮 | ✅ | ✅ | 完全一致 |

---

## 🎯 需要修复的问题

### 🔴 高优先级

#### 问题1: 缺少资料下载按钮
**位置**: 课节详情区域，作业按钮旁边

**修复方案**:
```dart
// 在 _LessonItem 中添加
final resourceDocument = widget.lesson['resource_document'] as List? ?? [];

if (resourceDocument.isNotEmpty) {
  _buildResourceButton(resourceDocument[0]);
}
```

#### 问题2: 缺少底部作业列表
**位置**: 课节详情下方

**修复方案**:
```dart
// 在 _LessonItem 中添加
final evaluationBottom = widget.lesson['evaluation_type_bottom'] as List? ?? [];

if (evaluationBottom.isNotEmpty) {
  _buildBottomEvaluations(evaluationBottom);
}
```

---

### 🟡 中优先级

#### 问题3: Model缺少字段
**CourseClassModel** 需要添加:
```dart
@JsonKey(name: 'resource_document') List<Map<String, dynamic>>? resourceDocument,
@JsonKey(name: 'evaluation_type_bottom') List<Map<String, dynamic>>? evaluationTypeBottom,
```

#### 问题4: 课节描述展开状态
当前使用 `_LessonItemState` 管理，但应该与小程序一致，在数据中存储 `isOpen` 状态。

---

### 🟢 低优先级

#### 问题5: 章节嵌套结构
小程序有新旧两种列表格式，目前只实现了旧格式（班级 > 课节）。

**是否需要**: 取决于真实API返回的数据结构

---

## ✅ 快速修复方案

### Step 1: 更新 Model (5分钟)
```dart
// course_detail_model.dart
@JsonKey(name: 'lesson') List<LessonModel>? lessons, // ← 改为强类型

@freezed
class LessonModel with _$LessonModel {
  const factory LessonModel({
    @JsonKey(name: 'lesson_id') String? lessonId,
    @JsonKey(name: 'lesson_name') String? lessonName,
    @JsonKey(name: 'lesson_name_other') String? lessonNameOther,
    String? date,
    @JsonKey(name: 'teaching_type') String? teachingType,
    String? status,
    @JsonKey(name: 'lesson_status') String? lessonStatus,
    @JsonKey(name: 'evaluation_type_top') List<Map<String, dynamic>>? evaluationTypeTop,
    @JsonKey(name: 'evaluation_type_bottom') List<Map<String, dynamic>>? evaluationTypeBottom,
    @JsonKey(name: 'resource_document') List<Map<String, dynamic>>? resourceDocument,
  }) = _LessonModel;
}
```

### Step 2: 添加资料按钮 (10分钟)
```dart
// _LessonItem 的 operation-box 区域
Row(
  children: [
    // 作业按钮
    ...evaluationTypeTop.map((btn) => _buildEvaluationButton(btn)),
    // 资料按钮
    if (lesson.resourceDocument?.isNotEmpty ?? false)
      _buildResourceButton(),
  ],
)
```

### Step 3: 添加底部作业列表 (15分钟)
```dart
// _LessonItem 底部
if (lesson.evaluationTypeBottom?.isNotEmpty ?? false)
  Column(
    children: lesson.evaluationTypeBottom!.map((item) {
      return _buildBottomEvaluationItem(item);
    }).toList(),
  )
```

---

## 📊 当前状态

| 功能 | 完成度 | 说明 |
|------|--------|------|
| 核心UI | 90% | 主要UI已实现 |
| 资料下载 | 0% | ❌ 缺失 |
| 底部作业 | 0% | ❌ 缺失 |
| 章节嵌套 | 0% | 可选功能 |

**总完成度**: 约75%

---

## 🚀 立即修复

现在开始修复资料下载和底部作业功能！

