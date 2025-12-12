# 我的收藏功能

## 📋 功能概述

完整实现了小程序的"我的收藏"功能，包括收藏列表展示、题型筛选、时间筛选、收藏详情查看等。

## 🎯 对应小程序页面

- **主页面**: `mini-dev_250812/src/modules/jintiku/pages/collect/index.vue`
- **详情页**: `mini-dev_250812/src/modules/jintiku/pages/collect/detail.vue`
- **题型选择**: `mini-dev_250812/src/modules/jintiku/components/collect/select-question-type.vue`
- **时间选择**: `mini-dev_250812/src/modules/jintiku/components/collect/select-time-range.vue`
- **API接口**: `mini-dev_250812/src/modules/jintiku/api/collect.js`

## 📂 文件结构

```
lib/features/collection/
├── models/
│   ├── collection_question_model.dart          # 收藏题目数据模型
│   ├── collection_question_model.freezed.dart  # Freezed生成文件
│   └── collection_question_model.g.dart        # JSON序列化生成文件
├── services/
│   └── collection_service.dart                 # 收藏API服务
├── providers/
│   ├── collection_provider.dart                # 收藏状态管理
│   ├── collection_provider.freezed.dart        # Freezed生成文件
│   └── collection_provider.g.dart              # Riverpod生成文件
├── views/
│   ├── collection_page.dart                    # 收藏列表页面
│   └── collection_detail_page.dart             # 收藏详情页面
├── widgets/
│   ├── collection_question_card.dart           # 收藏题目卡片
│   ├── question_type_selector.dart             # 题型选择器
│   └── time_range_selector.dart                # 时间范围选择器
├── collection_demo.dart                        # 功能演示入口
└── README.md                                   # 本文档
```

## 🔧 核心功能

### 1. 收藏列表展示 (CollectionPage)

- ✅ 按题型分组展示收藏的题目
- ✅ 支持下拉刷新
- ✅ 支持上拉加载更多
- ✅ 空状态提示
- ✅ 加载状态和错误处理

**对应小程序**: `collect/index.vue` Line 17-68

### 2. 题型筛选 (QuestionTypeSelector)

- ✅ 展示所有可用题型 (A1, A2, A3, A4, B1, B2, X)
- ✅ 支持选择单个题型
- ✅ 支持重置筛选
- ✅ 从API动态加载题型列表

**对应小程序**: `select-question-type.vue`

### 3. 时间范围筛选 (TimeRangeSelector)

- ✅ 预设时间范围: 全部、近3天、一周内、一月内
- ✅ 自定义时间范围选择
- ✅ 日期选择器集成
- ✅ 时间验证

**对应小程序**: `select-time-range.vue`

### 4. 收藏题目卡片 (CollectionQuestionCard)

- ✅ 显示题目标题
- ✅ 支持病例题型展示
- ✅ 支持B1题型选项列表展示
- ✅ 显示收藏时间
- ✅ 显示难度星级 (1-5星)

**对应小程序**: `collect/index.vue` Line 20-64

### 5. 数据模型 (CollectionQuestionModel)

- ✅ 使用Freezed实现不可变数据类
- ✅ 自动生成fromJson/toJson
- ✅ 支持题干列表、知识点等复杂字段
- ✅ UI辅助字段 (titleInfo)

## 📡 API接口

### 1. 获取收藏列表

```dart
GET /c/tiku/question/practice/collect/list

参数:
- page: 页码 (默认1)
- size: 每页数量 (默认10)
- time_range: 时间范围 ('0'-全部, '1'-近3天, '2'-一周内, '3'-一月内, '4'-自定义)
- question_type: 题型 (可选)
- start_date: 开始日期 (自定义时间时必填)
- end_date: 结束日期 (自定义时间时必填)
```

### 2. 收藏/取消收藏

```dart
GET /c/tiku/question/practice/collect

参数:
- question_version_id: 题目版本ID
- status: 收藏状态 ('1'-收藏, '2'-取消收藏)
- type: 类型 ('1'-收藏)
```

### 3. 获取题型列表

```dart
GET /c/tiku/question/type

返回所有可用的题型及其名称
```

## 🎨 UI设计

### 颜色规范

- **主色调**: `#2E68FF` (AppColors.primary)
- **背景色**: `#F5F5F5` (AppColors.background)
- **卡片背景**: `#FFFFFF`
- **选中状态**: `#EBF1FF` (浅蓝色背景)
- **文字颜色**: 
  - 主要文本: `#333333`
  - 次要文本: `#666666`
  - 提示文本: `#999999`

### 布局规范

- **rpx转换**: 小程序的rpx需要除以2后使用ScreenUtil (如: `24rpx` → `12.w`)
- **间距**: 遵循8的倍数设计系统
- **圆角**: 卡片圆角 `12.r` (对应小程序 `12rpx`)

## 🔄 业务逻辑

### 1. 题目标题处理

根据题型不同，展示不同的标题内容:

- **病例题型** (thematic_stem存在): 显示病例题干
- **B1题型** (type='5'): 显示选项列表 (A、B、C...)
- **其他题型**: 显示题干内容

**对应小程序**: `collect/index.vue` Line 160-171

### 2. 按题型分组

收藏列表按题型分组展示:

1. 先按type排序
2. 将相同题型的题目归为一组
3. 每组显示题型名称标题

**对应小程序**: `collect/index.vue` Line 173-183

### 3. 筛选条件

- 题型筛选和时间筛选相互独立
- 修改任一筛选条件后，重置分页并刷新列表
- 支持组合筛选 (题型 + 时间范围)

## 🚀 使用方法

### 1. 独立运行演示

```bash
cd yakaixin_app
flutter run -t lib/features/collection/collection_demo.dart
```

### 2. 集成到主应用

```dart
import 'package:yakaixin_app/features/collection/views/collection_page.dart';

// 导航到收藏页面
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const CollectionPage()),
);
```

### 3. 使用Provider

```dart
// 读取收藏状态
final state = ref.watch(collectionNotifierProvider);

// 刷新列表
ref.read(collectionNotifierProvider.notifier).loadCollections(refresh: true);

// 加载更多
ref.read(collectionNotifierProvider.notifier).loadMore();

// 更新筛选条件
ref.read(collectionNotifierProvider.notifier).updateFilter(
  questionType: '1',
  questionTypeName: 'A1',
);
```

## 📝 待完善功能

### 1. 收藏详情页

当前详情页仅为占位实现，需要集成现有的做题组件:

- [ ] 复用章节练习的题目展示组件
- [ ] 支持题目滑动切换
- [ ] 支持取消收藏操作
- [ ] 支持纠错功能

### 2. Mock数据

为了离线测试，可以添加Mock数据:

- [ ] 在 `assets/mock/collection_data.json` 中添加示例数据
- [ ] 在MockDatabase中添加查询方法
- [ ] 在MockDataRouter中添加路由映射

### 3. 优化项

- [ ] 图片缓存优化
- [ ] 列表性能优化
- [ ] 错误重试机制
- [ ] 数据持久化缓存

## 🐛 注意事项

### 1. 类型安全

- 所有API返回的字段都使用 `dynamic` 或可空类型
- 题型type、难度level等使用String类型 (与后端保持一致)
- 使用SafeTypeConverter进行类型转换

### 2. HTML内容处理

题目内容可能包含HTML标签，使用 `flutter_html` 包渲染:

```dart
Html(
  data: content,
  style: {
    "body": Style(
      fontSize: FontSize(15.sp),
      margin: Margins.zero,
      padding: HtmlPaddings.zero,
    ),
  },
)
```

### 3. 图片加载

所有网络图片都添加了errorBuilder:

```dart
Image.network(
  imageUrl,
  errorBuilder: (_, __, ___) => Icon(Icons.error),
)
```

## 📚 相关文档

- [MVVM架构规范](../../../.qoder/rules/mvvm_architecture.md)
- [主题和样式规范](../../../.qoder/rules/theme_and_style.md)
- [Widget拆分规范](../../../.qoder/rules/widget_architecture.md)
- [UI迁移规则](../../../.qoder/rules/ui_migration.md)

## ✅ 检查清单

- [x] Model层使用Freezed
- [x] Service层只负责数据访问
- [x] Provider层包含业务逻辑
- [x] View层纯UI展示
- [x] 使用AppColors统一颜色
- [x] 使用AppTextStyles统一文字样式
- [x] 使用AppSpacing统一间距
- [x] 支持下拉刷新
- [x] 支持上拉加载更多
- [x] 错误状态处理
- [x] 空状态提示
- [x] 加载状态显示

---

**开发完成时间**: 2025-12-06
**对应小程序版本**: mini-dev_250812
**Flutter版本**: 3.x
**状态**: ✅ 主要功能完成，详情页待完善
