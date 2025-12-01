# 剩余3个页面实施计划

基于小程序分析，这3个页面的API接口和实现方案。

---

## 📋 总览

| 页面 | 当前状态 | API接口 | 工作量 |
|-----|---------|---------|--------|
| SecretRealDetailPage | UI完成 | `/c/goods/v2/detail` | 0.5天 |
| SubjectMockDetailPage | UI完成 | `/c/goods/v2/detail` | 0.5天 |
| SimulatedExamRoomPage | UI完成 | `/c/goods/v2/detail` + `/c/exam/mkgoods` | 1天 |

**关键发现**: 这3个页面都使用相同的商品详情接口 `/c/goods/v2/detail`！
这意味着可以复用已实现的 `GoodsDetailModel` 和 `GoodsService.getGoodsDetail()` 方法。

---

## 1️⃣ SecretRealDetailPage (历年真题详情页)

### API分析

**小程序文件**: `mini-dev_250812/src/modules/jintiku/pages/test/secretRealDetail.vue`

**主接口**: 与 `GoodsDetailPage` 相同
```javascript
// Line 约150
getGoodsDetail({
  goods_id: this.id,
  professional_id: this.professional_id
})
```

### 实施方案

#### Step 1: 复用现有Service ✅
不需要新增Service方法，直接使用：
```dart
final service = ref.read(goodsServiceProvider);
final detail = await service.getGoodsDetail(goodsId: productId);
```

#### Step 2: 创建Provider

创建 `secret_real_detail_provider.dart`:

```dart
@riverpod
class SecretRealDetailNotifier extends _$SecretRealDetailNotifier {
  @override
  SecretRealDetailState build() => const SecretRealDetailState();
  
  Future<void> loadDetail(String productId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final service = ref.read(goodsServiceProvider);
      final detail = await service.getGoodsDetail(goodsId: productId);
      
      state = state.copyWith(goodsDetail: detail, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
```

#### Step 3: 更新UI

替换Mock数据为真实数据：
```dart
// 移除 Mock 数据
// final Map<String, dynamic> _goodsInfo = {...};

// 使用 Provider
final state = ref.watch(secretRealDetailNotifierProvider);

@override
void initState() {
  super.initState();
  if (widget.productId != null) {
    ref.read(secretRealDetailNotifierProvider.notifier)
       .loadDetail(widget.productId!);
  }
}
```

---

## 2️⃣ SubjectMockDetailPage (科目模考详情页)

### API分析

**小程序文件**: `mini-dev_250812/src/modules/jintiku/pages/test/subjectMockDetail.vue`

**主接口**: 同样使用 `getGoodsDetail`
```javascript
getGoodsDetail({
  goods_id: this.id,
  professional_id: this.professional_id
})
```

**特殊处理**: 显示长图 (`longImagePath`)

### 实施方案

与 `SecretRealDetailPage` 几乎完全相同，只需：

1. 创建 `subject_mock_detail_provider.dart`
2. 更新 `subject_mock_detail_page.dart` 使用Provider
3. 确保长图正确显示（`material_intro_path`）

---

## 3️⃣ SimulatedExamRoomPage (模拟考场页)

### API分析

**小程序文件**: `mini-dev_250812/src/modules/jintiku/pages/test/simulatedExamRoom.vue`

**接口1**: 商品详情
```javascript
getGoodsDetail({
  goods_id: this.id,
  professional_id: this.professional_id
})
```

**接口2**: 模拟考场列表（需要分析）
```javascript
// 需要进一步分析小程序代码
// 可能是获取考试列表的接口
```

### 实施方案

#### Step 1: Service扩展

在 `GoodsService` 中可能需要添加获取模拟考试列表的方法（待确认）

#### Step 2: Provider实现

```dart
@freezed
class SimulatedExamRoomState {
  const factory SimulatedExamRoomState({
    GoodsDetailModel? goodsDetail,
    @Default([]) List<ExamModel> examList,  // 考试列表
    @Default(false) bool isLoading,
    String? error,
  }) = _SimulatedExamRoomState;
}
```

#### Step 3: UI更新

替换Mock数据，实现考试列表功能

---

## 🚀 实施顺序建议

### Phase 1: SecretRealDetailPage (0.5天)
1. 创建 Provider（20分钟）
2. 更新 UI（1小时）
3. 测试（30分钟）

### Phase 2: SubjectMockDetailPage (0.5天)
1. 创建 Provider（20分钟）
2. 更新 UI（1小时）
3. 测试（30分钟）

### Phase 3: SimulatedExamRoomPage (1天)
1. 分析额外接口（1小时）
2. 扩展 Service（1小时）
3. 创建 Provider（1小时）
4. 更新 UI（3小时）
5. 测试（1小时）

---

## 📝 快速实施模板

### Provider 模板

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../goods/models/goods_detail_model.dart';
import '../../goods/services/goods_service.dart';

part 'xxx_provider.freezed.dart';
part 'xxx_provider.g.dart';

@freezed
class XxxState with _$XxxState {
  const factory XxxState({
    GoodsDetailModel? goodsDetail,
    @Default(false) bool isLoading,
    String? error,
  }) = _XxxState;
}

@riverpod
class XxxNotifier extends _$XxxNotifier {
  @override
  XxxState build() => const XxxState();
  
  Future<void> loadDetail(String productId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final service = ref.read(goodsServiceProvider);
      final detail = await service.getGoodsDetail(goodsId: productId);
      
      state = state.copyWith(goodsDetail: detail, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
```

### UI更新模板

```dart
// 1. 删除 Mock 数据
// final Map<String, dynamic> _mockData = {...}; // 删除

// 2. 添加 Provider 监听
final state = ref.watch(xxxNotifierProvider);

// 3. initState 加载数据
@override
void initState() {
  super.initState();
  Future.microtask(() {
    if (widget.productId != null) {
      ref.read(xxxNotifierProvider.notifier).loadDetail(widget.productId!);
    }
  });
}

// 4. 更新 build 方法
@override
Widget build(BuildContext context) {
  final state = ref.watch(xxxNotifierProvider);
  
  return Scaffold(
    body: state.isLoading
        ? _buildLoading()
        : state.error != null
            ? _buildError(state.error!)
            : state.goodsDetail != null
                ? _buildContent(state.goodsDetail!)
                : _buildEmpty(),
  );
}

// 5. 更新所有使用 Mock 数据的地方
// _mockData['name'] → state.goodsDetail?.name
// _mockData['price'] → state.goodsDetail?.prices.first.salePrice
```

---

## ⚠️ 注意事项

### 1. 复用 GoodsDetailModel

这3个页面都使用相同的数据Model：
```dart
import '../../goods/models/goods_detail_model.dart';
```

### 2. 复用 GoodsService

都使用相同的Service方法：
```dart
final service = ref.read(goodsServiceProvider);
final detail = await service.getGoodsDetail(goodsId: productId);
```

### 3. UI适配

虽然使用相同的数据Model，但UI展示不同：
- **SecretRealDetailPage**: 显示题目数量、考试时间、练习进度
- **SubjectMockDetailPage**: 显示长图介绍
- **SimulatedExamRoomPage**: 显示左侧信息栏+考试列表

### 4. 购买流程

这3个页面都需要购买功能，可以：
- 暂时使用 TODO 占位
- 或复用 GoodsDetailPage 的购买逻辑（待实现）

---

## ✅ 完成标准

每个页面完成后应满足：

1. **功能完整**
   - [ ] 加载真实API数据
   - [ ] 显示商品信息
   - [ ] 显示价格信息
   - [ ] 处理加载/错误/空状态
   - [ ] 权限判断（已购买/未购买）

2. **代码质量**
   - [ ] 遵循 MVVM 架构
   - [ ] 无 lint 错误
   - [ ] 有详细注释
   - [ ] 使用 SafeTypeConverter

3. **测试通过**
   - [ ] 页面正常加载
   - [ ] 数据正确显示
   - [ ] 错误处理正常
   - [ ] 从首页跳转正常

---

## 🎯 预期成果

完成后的文件结构：

```
lib/features/goods/
├── models/
│   └── goods_detail_model.dart           ✅ 已完成（复用）
├── services/
│   └── goods_service.dart                ✅ 已完成（复用）
├── providers/
│   ├── goods_detail_provider.dart        ✅ 已完成
│   ├── secret_real_detail_provider.dart  🔄 待创建
│   ├── subject_mock_detail_provider.dart 🔄 待创建
│   └── simulated_exam_room_provider.dart 🔄 待创建
└── views/
    ├── goods_detail_page.dart            ✅ 已完成
    ├── secret_real_detail_page.dart      🔄 待更新
    ├── subject_mock_detail_page.dart     🔄 待更新
    └── simulated_exam_room_page.dart     🔄 待更新
```

---

**预计总时间**: 2天
**实际代码量**: ~600行（3个Provider + UI更新）
**复用率**: 80%（Model和Service完全复用）

---

**下一步**: 立即开始实现 SecretRealDetailPage

