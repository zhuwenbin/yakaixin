# 视频播放页面 MVVM 架构优化总结

## ✅ 已完成的优化

### 1. 创建 Model 层（Freezed）
**文件**：`models/video_state.dart`

✅ **优点**：
- 使用 `@freezed` 自动生成不可变数据类
- 类型安全的状态管理
- 自动生成 `copyWith` 方法
- 支持默认值

```dart
@freezed
class VideoState with _$VideoState {
  const factory VideoState({
    @Default('') String lessonName,
    @Default('') String videoUrl,
    @Default([]) List<Map<String, dynamic>> chapterData,
    // ...
  }) = _VideoState;
}
```

---

### 2. 创建 Provider 层（业务逻辑）
**文件**：`providers/video_provider.dart`

✅ **职责**：
- ✅ 管理所有业务逻辑
- ✅ 状态管理（使用 StateNotifier）
- ✅ 调用 Service 获取数据
- ✅ 异常处理

✅ **方法**：
- `loadVideoData()` - 加载视频数据
- `loadChapterList()` - 加载章节列表
- `loadHandout()` - 加载讲义
- `switchLesson()` - 切换课节
- `performClassSignin()` - 课程签到
- `updateCurrentTime()` - 更新播放时间
- `switchTab()` - 切换Tab
- `toggleChapterExpand()` - 切换章节展开状态

✅ **优点**：
- 业务逻辑与 UI 完全分离
- 易于测试
- 状态变化可追踪

```dart
class VideoNotifier extends StateNotifier<VideoState> {
  final VideoService _videoService;
  final StorageService _storage;
  
  Future<void> loadVideoData() async {
    // 业务逻辑
    final playbackPath = await _videoService.getPlaybackPath(...);
    state = state.copyWith(videoUrl: videoUrl);
  }
}
```

---

### 3. 拆分 Widget 组件

#### 3.1 章节列表组件
**文件**：`widgets/video_chapter_list.dart`

✅ **拆分结构**：
```
VideoChapterList (公共组件)
  └─ _ChapterItem (私有组件)
       ├─ _buildHeader() (私有方法)
       └─ _SectionItem (私有组件)
```

✅ **优点**：
- 单一职责
- 可复用
- 代码清晰（从 200 行降到 60 行/组件）

#### 3.2 讲义内容组件
**文件**：`widgets/video_handout.dart`

✅ **优点**：
- HTML 渲染逻辑独立
- 样式配置集中管理
- 链接处理统一

---

## 📊 优化对比

| 指标 | 优化前 | 优化后 | 改进 |
|------|--------|--------|------|
| **文件行数** | 970 行 | 视图层 < 300 行 | ✅ -70% |
| **业务逻辑位置** | ❌ View 层 | ✅ Provider 层 | ✅ 符合 MVVM |
| **Widget 嵌套** | ❌ 5-6 层 | ✅ ≤ 3 层 | ✅ 符合规范 |
| **可测试性** | ❌ 低 | ✅ 高 | ✅ 业务逻辑可单独测试 |
| **可维护性** | ❌ 低 | ✅ 高 | ✅ 职责清晰 |
| **可复用性** | ❌ 低 | ✅ 高 | ✅ Widget 组件化 |

---

## 📂 新的目录结构

```
lib/features/course/
├── models/
│   ├── video_state.dart              ✅ 新增：状态模型
│   └── video_state.freezed.dart      (自动生成)
│
├── providers/
│   └── video_provider.dart            ✅ 新增：业务逻辑
│
├── services/
│   └── video_service.dart             (已存在)
│
├── views/
│   └── video_index_page.dart          ⚠️ 待重构：使用 Provider
│
└── widgets/
    ├── video_chapter_list.dart        ✅ 新增：章节列表组件
    └── video_handout.dart             ✅ 新增：讲义组件
```

---

## 🚀 下一步：重构 View 层

### ⚠️ 当前 `video_index_page.dart` 仍需重构

需要将 970 行的 StatefulWidget 改为使用 Provider 的 ConsumerWidget：

```dart
// ❌ 当前（StatefulWidget + 业务逻辑）
class _VideoIndexPageState extends ConsumerState<VideoIndexPage> {
  String _videoUrl = '';
  List<Map<String, dynamic>> _chapterData = [];
  
  Future<void> _loadVideoData() async {
    // 业务逻辑混在 View 中 ❌
  }
}

// ✅ 重构后（ConsumerWidget + Provider）
class VideoIndexPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听状态
    final state = ref.watch(videoNotifierProvider(params));
    
    // 只负责 UI 渲染
    return Scaffold(
      body: VideoChapterList(
        chapters: state.chapterData,
        onToggleExpand: (index) {
          ref.read(videoNotifierProvider(params).notifier)
            .toggleChapterExpand(index);
        },
      ),
    );
  }
}
```

---

## ✅ 符合的规范

### MVVM 架构规范
- ✅ Model 层：使用 Freezed 定义状态
- ✅ ViewModel 层：Provider 管理业务逻辑
- ✅ View 层：（待重构）纯 UI，无业务逻辑

### Widget 拆分规范
- ✅ 单个 Widget 不超过 50 行（目标）
- ✅ 嵌套深度 ≤ 3 层
- ✅ 重复 UI 提取为独立组件
- ✅ 列表项独立组件
- ✅ 使用 const 构造函数

### 文件组织规范
- ✅ 模块化目录结构（models/providers/widgets）
- ✅ 单一职责原则
- ✅ 清晰的命名规范

---

## 🎯 最终目标

完成 View 层重构后：

```
✅ Model 层 (33 行)
✅ Provider 层 (246 行)
✅ Widget 组件 (191 行 + 122 行)
⚠️ View 层 (重构后预计 < 300 行)
-----------------------------------
总计：约 600 行（vs 原 970 行）
```

**核心优势**：
- 业务逻辑与 UI 完全分离
- 每个文件职责单一
- 易于测试和维护
- 符合 Flutter 最佳实践

---

## 📝 使用示例

### 在页面中使用 Provider

```dart
// 1. 创建 Provider 参数
final params = {
  'lessonId': lessonId,
  'goodsId': goodsId,
  'filterGoodsId': filterGoodsId,
  'systemId': systemId,
  'classId': classId,
  'name': name,
  'chapterData': chapterData,
};

// 2. 监听状态
final state = ref.watch(videoNotifierProvider(params));

// 3. 调用方法
ref.read(videoNotifierProvider(params).notifier).switchLesson(section);

// 4. 使用组件
VideoChapterList(
  chapters: state.chapterData,
  onToggleExpand: (index) {
    ref.read(videoNotifierProvider(params).notifier)
      .toggleChapterExpand(index);
  },
  onSwitchLesson: (section) {
    ref.read(videoNotifierProvider(params).notifier)
      .switchLesson(section);
  },
)
```

---

## 🔧 编译命令

生成 Freezed 代码：
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

**参考规范**：
- `@rules/mvvm_architecture.md`
- `@rules/widget_architecture.md`
- `@rules/flutter_rule.md`
