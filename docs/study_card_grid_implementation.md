# 题库页面 - 4功能卡片完整实现方案

## 📋 小程序逻辑分析

### 卡片配置

| 序号 | 标题 | 副标题 | position_identify | 跳转逻辑 |
|------|------|--------|-------------------|----------|
| 0 | 绝密押题 | 名师密押 考后即焚 | `linianzhenti` | 获取商品→跳转详情页 |
| 1 | 科目模考 | 查漏补缺 直击重点 | `kemumokao` | 获取商品→跳转详情页 |
| 2 | 模拟考试 | 全真模拟 还原考场 | `monikaoshi` | 获取商品→跳转详情页 |
| 3 | 学习报告 | 实时学习情况 | - | 直接跳转报告页面 |

---

## 🔍 小程序跳转逻辑详解

### Step 1: 获取商品数据 (卡片0,1,2)

```javascript
getGoods({
  shelf_platform_id,
  professional_id: this.majorId,
  position_identify: "linianzhenti", // 或 kemumokao、monikaoshi
}).then(res => {
  const list = res.data.list
  if (!res.data || !res.data.list || !res.data.list.length) {
    uni.showToast({ title: '暂无数据', icon: 'none' })
  }
  this.goDetailPage(list[0]) // 取第一个商品
})
```

### Step 2: 根据商品状态跳转 (goDetailPage)

**核心判断**:
1. `permission_status` - 购买状态 ('1'=已购买, '2'=未购买)
2. `details_type` - 详情页类型 (1=经典版, 2=真题版, 3=科目版, 4=模考版)
3. `data_type` - 数据类型 (2=模考)

**未购买 (permission_status='2')**:
- details_type=1 → `pages/test/detail` (经典商品详情)
- details_type=2 → `pages/test/secretRealDetail` (真题商品详情)
- details_type=3 → `pages/test/subjectMockDetail` (科目商品详情)
- details_type=4 → `pages/test/simulatedExamRoom` (模拟商品详情)

**已购买 (permission_status='1')**:
- details_type=1 → `pages/test/exam` (开始答题)
- details_type=2 → `pages/test/secretRealDetail` (真题详情)
- details_type=3 → `pages/test/exam` (开始答题)
- details_type=4 → `pages/test/simulatedExamRoom` (模拟考试)

### Step 3: 学习报告 (卡片3)

直接跳转: `pages/userInfo/report`

---

## 🎯 Flutter 实现方案

### 方案A: 在点击时实时获取商品

```dart
Future<void> _handleCardClick(BuildContext context, WidgetRef ref, int index) async {
  final majorId = ref.read(currentMajorProvider)?.majorId;
  if (majorId == null) {
    // 显示提示
    return;
  }

  // 根据索引获取 position_identify
  final positions = ['linianzhenti', 'kemumokao', 'monikaoshi', null];
  final position = positions[index];

  if (position == null) {
    // 学习报告，直接跳转
    context.go('/study_report');
    return;
  }

  // 显示加载
  showDialog(...);

  try {
    // 获取商品
    final goodsService = ref.read(goodsServiceProvider);
    final response = await goodsService.getGoodsByPosition(
      professionalId: majorId,
      positionIdentify: position,
    );

    Navigator.pop(context); // 关闭加载

    if (response.list.isEmpty) {
      // 显示暂无数据
      ScaffoldMessenger.of(context).showSnackBar(...);
      return;
    }

    final goods = response.list.first;
    _navigateToGoodsDetail(context, goods);
  } catch (e) {
    Navigator.pop(context);
    // 显示错误
  }
}

void _navigateToGoodsDetail(BuildContext context, GoodsModel goods) {
  // 根据 permission_status 和 details_type 跳转
  if (goods.permissionStatus == '2') {
    // 未购买，跳转商品详情页
    context.go('/goods_detail/${goods.id}');
  } else if (goods.permissionStatus == '1') {
    // 已购买，跳转答题页面
    if (goods.detailsType == '4') {
      context.go('/simulated_exam_room/${goods.id}');
    } else {
      context.go('/exam/${goods.id}');
    }
  }
}
```

### 方案B: 预加载所有卡片数据 (推荐)

```dart
// QuestionBankState 中添加字段
@freezed
class QuestionBankState with _$QuestionBankState {
  const factory QuestionBankState({
    // ... 现有字段
    
    // 4功能卡片数据
    GoodsModel? secretPredictGoods,     // 绝密押题
    GoodsModel? subjectMockGoods,       // 科目模考
    GoodsModel? simulatedExamGoods,     // 模拟考试
    @Default(false) bool isLoadingCards, // 卡片数据加载状态
  }) = _QuestionBankState;
}

// Provider 中加载
Future<void> _loadCardGoods(String majorId) async {
  try {
    final service = _ref.read(goodsServiceProvider);
    
    // 并发请求3个position_identify
    final results = await Future.wait([
      service.getGoodsByPosition(
        professionalId: majorId,
        positionIdentify: 'linianzhenti',
      ),
      service.getGoodsByPosition(
        professionalId: majorId,
        positionIdentify: 'kemumokao',
      ),
      service.getGoodsByPosition(
        professionalId: majorId,
        positionIdentify: 'monikaoshi',
      ),
    ]);

    state = state.copyWith(
      secretPredictGoods: results[0].list.isNotEmpty ? results[0].list.first : null,
      subjectMockGoods: results[1].list.isNotEmpty ? results[1].list.first : null,
      simulatedExamGoods: results[2].list.isNotEmpty ? results[2].list.first : null,
      isLoadingCards: false,
    );
  } catch (e) {
    state = state.copyWith(isLoadingCards: false);
  }
}

// UI 中使用
void _handleCardClick(BuildContext context, WidgetRef ref, int index) {
  final state = ref.read(questionBankProvider);
  
  switch (index) {
    case 0:
      if (state.secretPredictGoods != null) {
        _navigateToGoodsDetail(context, state.secretPredictGoods!);
      }
      break;
    case 1:
      if (state.subjectMockGoods != null) {
        _navigateToGoodsDetail(context, state.subjectMockGoods!);
      }
      break;
    case 2:
      if (state.simulatedExamGoods != null) {
        _navigateToGoodsDetail(context, state.simulatedExamGoods!);
      }
      break;
    case 3:
      context.go('/study_report');
      break;
  }
}
```

---

## 📦 需要添加的Mock数据

在 `assets/mock/goods_data.json` 中添加:

```json
{
  "id": "goods_special_001",
  "name": "2026口腔执业医师历年真题精选",
  "type": "8",
  "position_identify": "linianzhenti",
  "professional_id": "524033912737962623",
  "permission_status": "2",
  "details_type": "2",
  "sale_price": "199.00",
  "student_num": "2340"
},
{
  "id": "goods_special_002",
  "name": "口腔执业医师科目模考",
  "type": "8",
  "position_identify": "kemumokao",
  "professional_id": "524033912737962623",
  "permission_status": "2",
  "details_type": "3",
  "sale_price": "299.00",
  "student_num": "1856"
},
{
  "id": "goods_special_003",
  "name": "口腔执业医师全真模拟考试",
  "type": "10",
  "position_identify": "monikaoshi",
  "professional_id": "524033912737962623",
  "permission_status": "1",
  "details_type": "4",
  "data_type": "2",
  "sale_price": "399.00",
  "student_num": "3120"
}
```

---

## ✅ 推荐实现步骤

1. ✅ 在 `goods_data.json` 中添加3个特殊商品
2. ✅ 在 `QuestionBankState` 中添加卡片商品字段
3. ✅ 在 Provider 的 `build()` 方法中调用 `_loadCardGoods()`
4. ✅ 修改 `StudyCardGrid` 组件的点击逻辑
5. ✅ 实现 `_navigateToGoodsDetail()` 跳转方法
6. ✅ 测试 Mock 模式和真实 API

---

## 🎨 UI 优化建议

1. **加载状态**: 卡片数据加载时显示骨架屏
2. **无数据状态**: 商品为空时卡片置灰或显示"敬请期待"
3. **购买状态**: 显示"已购买"标签
4. **图标**: 使用小程序相同的图标URL

---

**预计实现时间**: 40分钟  
**优先级**: 🔴 高

