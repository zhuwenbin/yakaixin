# 选择专业功能实现说明

## 📋 功能概述

本次实现完成了参照小程序使用真实 API 的选择专业功能，替换了之前的 mock 数据实现。

## 🎯 实现的功能

### 1. 真实 API 集成

- ✅ **获取专业列表**: `GET /c/teaching/mapping/tree`
- ✅ **选择/切换专业**: `PUT /c/student`
- ✅ 完整的请求参数和响应处理

### 2. 数据模型 (Freezed)

**文件**: `lib/features/major/models/major_model.dart`

```dart
// 专业数据模型
@freezed
class MajorModel with _$MajorModel {
  const factory MajorModel({
    required String id,
    @JsonKey(name: 'data_name') required String dataName,
    @JsonKey(name: 'level') String? level,
    @JsonKey(name: 'subs') @Default([]) List<MajorModel> subs,
  }) = _MajorModel;
}

// 当前选择的专业信息（本地存储）
@freezed
class CurrentMajor with _$CurrentMajor {
  const factory CurrentMajor({
    @JsonKey(name: 'major_id') required String majorId,
    @JsonKey(name: 'major_name') required String majorName,
    @JsonKey(name: 'major_pid_level') String? majorPidLevel,
  }) = _CurrentMajor;
}
```

### 3. Service 层

**文件**: `lib/features/major/services/major_service.dart`

```dart
class MajorService {
  /// 获取专业列表
  Future<MajorListResponse> getMajorList() async {
    final response = await _dioClient.get(
      '/c/teaching/mapping/tree',
      queryParameters: {
        'code': 'professional',
        'is_auth': 2,
        'is_usable': 1,
        'is_standard': 0,
        'professional_ids': '',
      },
    );
    return MajorListResponse.fromJson(response.data);
  }

  /// 选择/切换专业（需要登录）
  Future<void> selectMajor({
    required String studentId,
    required String majorId,
  }) async {
    await _dioClient.put(
      '/c/student',
      data: {
        'id': studentId,
        'major_id': majorId,
      },
    );
  }
}
```

### 4. UI 组件

**文件**: `lib/features/major/widgets/major_selector_dialog.dart`

**特性**:
- ✅ 从 header 下方弹出（符合 UI 规范）
- ✅ 左右分栏布局（左侧分类，右侧专业）
- ✅ 支持分组显示专业
- ✅ 动画效果（下拉展开/收起）
- ✅ 已选中专业高亮显示
- ✅ 完全符合小程序 UI 效果

**对应小程序**: `components/select-major.vue`

## 📁 文件结构

```
lib/features/major/
├── models/
│   ├── major_model.dart              # 数据模型
│   ├── major_model.freezed.dart      # Freezed 生成
│   └── major_model.g.dart            # JSON 序列化生成
├── services/
│   └── major_service.dart            # API 服务
├── widgets/
│   └── major_selector_dialog.dart    # 选择专业弹窗组件
├── views/
│   └── test_major_selector_page.dart # 测试页面
└── major.dart                        # 模块导出
```

## 🔄 业务流程

### 1. 加载专业列表

```
用户点击"选择专业" 
  ↓
调用 getMajorList() API
  ↓
解析响应数据为 MajorModel 列表
  ↓
显示弹窗（默认选中"医学类"）
```

### 2. 选择专业流程

```
用户点击某个专业
  ↓
检查是否已登录
  ↓
├─ 已登录: 调用 selectMajor() API 更新后端
└─ 游客: 跳过 API 调用
  ↓
保存到本地存储 (StorageKeys.majorInfo)
  ↓
✅ 关键：更新 authProvider 的 currentMajor 状态
  ↓
显示成功提示
  ↓
关闭弹窗并触发回调刷新页面
```

### 3. 数据存储

**本地存储 Key**:
- `StorageKeys.majorInfo`: 完整的专业信息 (JSON)
- `StorageKeys.currentMajorId`: 当前专业 ID (String)

**存储数据格式**:
```json
{
  "major_id": "524033912737962623",
  "major_name": "护理学",
  "major_pid_level": "2"
}
```

## 🔌 使用方式

### 方式 1: 在现有页面中使用（推荐）

**首页、题库页已集成**，可直接参考：

```dart
// 首页: lib/features/home/views/home_page.dart Line 128-134
// 题库页: lib/features/home/views/question_bank_page.dart Line 133-138

GestureDetector(
  onTap: () {
    showMajorSelector(
      context,
      onChanged: () {
        // 专业变更后刷新数据
        ref.read(homeProvider.notifier).loadHomeData();
      },
    );
  },
  child: Row(
    children: [
      Text(majorName),
      Icon(Icons.keyboard_arrow_down),
    ],
  ),
)
```

### 方式 2: 测试页面

```dart
// 导航到测试页面
import 'package:yakaixin_app/features/major/major.dart';

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => TestMajorSelectorPage(),
  ),
);
```

## 🎨 UI 规范遵循

根据用户记忆规范:
> 选择专业组件的下拉内容（白色内容）和遮罩背景需从触发按钮（选择专业）的下方起始对齐，确保视觉连贯性和操作一致性。

**实现**:
```dart
// 遮罩从 header 下方开始 (Line 79-89)
Positioned(
  top: 48.h, // header高度
  ...
)

// 内容区域从 header 下方开始下拉 (Line 92-118)
Positioned(
  top: 48.h, // header高度
  ...
  SlideTransition(...), // 下拉动画
)
```

## 📊 小程序对照表

| 小程序文件 | 功能 | Flutter 对应文件 |
|-----------|------|-----------------|
| `components/select-major.vue` Line 74-89 | 获取专业列表 | `major_service.dart` getMajorList() |
| `components/select-major.vue` Line 102-117 | 选择专业（已登录） | `major_service.dart` selectMajor() |
| `components/select-major.vue` Line 120-131 | 选择专业（游客） | `major_selector_dialog.dart` Line 252-262 |
| `components/select-major.vue` Line 111-116 | 保存到本地存储 | `major_selector_dialog.dart` Line 264-265 |
| `api/index.js` Line 299-308 | 专业列表 API | `major_service.dart` Line 21-34 |
| `api/index.js` Line 310-323 | 选择专业 API | `major_service.dart` Line 42-53 |

## 🐞 已修复的问题

### 问题 1: 选择专业后数据不更新

**现象**：
- 选择专业后，`professional_id` 参数没有更新
- 页面显示的专业信息不正确
- API 请求使用的还是旧的专业 ID

**原因**：
- `currentMajorProvider` 从 `authProvider.currentMajor` 读取数据
- 选择专业后只更新了本地存储，没有更新 `authProvider` 的状态
- 导致 `ref.watch(currentMajorProvider)` 读取到的还是旧值

**修复**：
```dart
// major_selector_dialog.dart Line 314-321
// ✅ 关键修复：更新 authProvider 的专业状态
final majorModel = MajorModel(
  majorId: item.id,
  majorName: item.dataName,
  majorPidLevel: item.level,
);
ref.read(authProvider.notifier).switchMajor(majorModel);
```

**效果**：
- ✅ `currentMajorProvider` 立即读取到最新的专业信息
- ✅ API 拦截器自动添加正确的 `professional_id` 参数
- ✅ 页面刷新后显示正确的数据

### 问题 2: API 参数转换逺辑

**小程序逻辑** (`api/request.js` Line 129-136):
```javascript
if (majorInfo && majorInfo.major_id && 
    !Object.keys(data).includes('professional_id') &&
    data.no_professional_id !== "1") {
  data.professional_id = majorInfo.major_id  // major_id → professional_id
}
```

**Flutter 实现** (`api_interceptor.dart` Line 125-137):
```dart
final shouldAddProfessionalId = !currentParams.containsKey('professional_id') && 
                                 currentParams['no_professional_id'] != "1";

final majorId = _storage.getString(StorageKeys.currentMajorId);
if (shouldAddProfessionalId && majorId != null && majorId.isNotEmpty) {
  professionalParams = {
    'professional_id': majorId,  // ✅ 正确转换
  };
}
```

**结论**：✅ API 拦截器已正确实现 `major_id` → `professional_id` 的转换

---

## ✅ 已完成的功能

1. ✅ 真实 API 调用（替换 mock 数据）
2. ✅ Freezed 数据模型定义
3. ✅ 本地存储集成
4. ✅ UI 组件完全符合小程序效果
5. ✅ 支持游客模式（未登录也能选择专业）
6. ✅ 支持已登录用户（调用后端 API 更新）
7. ✅ 动画效果（下拉展开/收起）
8. ✅ 分组显示专业
9. ✅ 已选中专业高亮
10. ✅ 错误处理和 Loading 状态
11. ✅ 符合用户 UI 规范（从 header 下方对齐）

## 🧪 测试建议

### 1. 基础功能测试
```bash
# 运行测试页面
flutter run
# 然后导航到 TestMajorSelectorPage
```

### 2. 测试场景

**场景 1: 游客模式**
1. 未登录状态打开选择专业
2. 选择一个专业
3. 检查本地存储是否保存成功
4. 不应调用后端 API

**场景 2: 已登录模式**
1. 登录后打开选择专业
2. 选择一个专业
3. 应该调用 `/c/student` API
4. 检查本地存储和后端是否同步

**场景 3: UI 效果**
1. 点击"选择专业"按钮
2. 检查弹窗是否从 header 下方弹出
3. 检查动画效果是否流畅
4. 左右分栏布局是否正确
5. 已选中专业是否高亮显示

### 3. API 调试

```bash
# 查看调试框架中的网络请求
# 应该看到以下请求：

GET /c/teaching/mapping/tree
  ✓ code: professional
  ✓ is_auth: 2
  ✓ is_usable: 1
  ✓ is_standard: 0

PUT /c/student (已登录时)
  ✓ id: {student_id}
  ✓ major_id: {选择的专业ID}
```

## 📝 注意事项

1. **大数字 ID**: 专业 ID 可能是超大整数（如 `524033912737962623`），在 Model 中使用 `String` 类型
2. **游客模式**: 未登录用户也可以选择专业，只保存到本地，不调用 API
3. **数据持久化**: 专业信息保存在 `SharedPreferences`，App 重启后仍然有效
4. **UI 规范**: 弹窗必须从 header 下方开始，符合用户记忆规范

## 🚀 下一步

如需在其他页面集成选择专业功能，只需：

```dart
import 'package:yakaixin_app/features/major/major.dart';

// 使用
showMajorSelector(
  context,
  onChanged: () {
    // 专业变更后的处理
  },
);

// 读取当前专业
final storage = ref.read(storageServiceProvider);
final majorJson = storage.getJson(StorageKeys.majorInfo);
final currentMajor = majorJson != null 
    ? CurrentMajor.fromJson(majorJson) 
    : null;
```

---

**实现时间**: 2025-11-25  
**参照小程序**: `src/modules/jintiku/components/select-major.vue`  
**状态**: ✅ 已完成并可使用
