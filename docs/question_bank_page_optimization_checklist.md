# 题库页面优化清单

## 📊 当前实现对比分析

### ✅ 已实现功能（与小程序一致）

| 功能模块 | 小程序 | Flutter | 状态 |
|---------|--------|---------|------|
| 顶部专业选择 | ✅ | ✅ | ✅ 完全一致 |
| 学习日历卡片 | ✅ | ✅ | ✅ UI一致 |
| 4个功能卡片 | ✅ | ✅ | ✅ UI一致 |
| 每日一测 | ✅ | ✅ | ✅ UI一致 |
| 章节练习 | ✅ | ✅ | ✅ UI一致 |
| 技能模拟 | ✅ | ✅ | ✅ UI一致 |
| 已购试题 | ✅ | ✅ | ✅ UI一致 |

---

## ⚠️ 需要优化的关键问题

### 1. 缺少 goodsServiceProvider 的导入 ⚠️ **关键问题**

**问题描述**：
```dart
// question_bank_page.dart Line 803
final goodsService = ref.read(goodsServiceProvider);  // ❌ 未导入
```

**错误**：
- `goodsServiceProvider` 未导入，会导致编译错误

**解决方案**：
```dart
// ✅ 在文件顶部添加导入
import '../../goods/services/goods_service.dart';
```

---

### 2. 已购试题字段名称错误 ⚠️

**问题描述**：
```dart
// question_bank_page.dart Line 644
'${goods.questionCount}题',  // ❌ questionCount 字段不存在
```

**小程序实现**（Line 59）：
```vue
<index-nav-item v-for="(item, index) in goodsList10" :key="index" :formData="item">
```

**index-nav-item.vue** 组件中：
```javascript
// 显示题目数量
computed: {
  questionCount() {
    // 从 tiku_goods_details.question_num 获取
    return this.formData.tiku_goods_details?.question_num || 0;
  }
}
```

**GoodsModel 字段**：
```dart
@JsonKey(name: 'tiku_goods_details') TikuGoodsDetails? tikuGoodsDetails;

class TikuGoodsDetails {
  @JsonKey(name: 'question_num') dynamic questionNum;  // ✅ 正确字段
}
```

**解决方案**：
```dart
// ❌ 错误
'${goods.questionCount}题',

// ✅ 正确
'${goods.tikuGoodsDetails?.questionNum ?? 0}题',
```

---

### 3. 已购试题封面路径处理问题 ⚠️

**问题描述**：
```dart
// question_bank_page.dart Line 635-638
final coverPath = goods.materialCoverPath;
final imageUrl = coverPath.startsWith('http')
    ? coverPath
    : 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/$coverPath';
```

**问题**：
- `coverPath` 可能为 null
- 没有处理空字符串的情况

**解决方案**：
```dart
// ✅ 安全处理
final coverPath = goods.materialCoverPath ?? '';
final imageUrl = coverPath.isNotEmpty && coverPath.startsWith('http')
    ? coverPath
    : coverPath.isNotEmpty
        ? 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/$coverPath'
        : '';  // 默认为空，由 errorBuilder 处理
```

---

### 4. 技能模拟显示条件 ℹ️

**小程序实现**（Line 40-45）：
```vue
<view class="title mt-30" v-if="hasSkillMock && showSkillMock">
  <text class="text">技能模拟</text>
</view>
<skill-mock-nav ref="skillNav" v-if="hasSkillMock && showSkillMock"></skill-mock-nav>
```

**条件判断**：
```javascript
data() {
  return {
    hasSkillMock: true,  // 是否有技能模拟数据
    showSkillMock: true  // 是否显示技能模拟（可能基于专业）
  }
}
```

**Flutter实现**：
```dart
// ✅ 当前实现已正确
if (state.skillMock != null) ...[
  SliverToBoxAdapter(
    child: _buildSkillMockSection(context, state.skillMock!),
  ),
],
```

**结论**：✅ 当前实现正确，无需修改

---

### 5. 每日一测显示条件 ℹ️

**小程序实现**（Line 28-33）：
```vue
<view class="title mt-30" v-if="hasDaily30">
  <text class="text">每日一测</text>
</view>
<daily-nav ref="dailyNavRef" v-if="hasDaily30"></daily-nav>
```

**Flutter实现**：
```dart
// ✅ 当前实现已正确
if (state.dailyPractice != null) ...[
  SliverToBoxAdapter(
    child: _buildDailyPractice(context, state.dailyPractice!),
  ),
],
```

**结论**：✅ 当前实现正确，无需修改

---

## 🔧 修复代码

### 修复1: 添加导入

```dart
// question_bank_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../app/routes/app_routes.dart';
import '../providers/question_bank_provider.dart';
import '../models/question_bank_model.dart';
import '../../major/widgets/major_selector_dialog.dart';
import '../providers/home_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../goods/services/goods_service.dart';  // ✅ 添加这一行
```

---

### 修复2: 修正已购试题字段

```dart
/// 已购试题
Widget _buildPurchasedQuestions(QuestionBankState state) {
  // ... 前面代码不变
  
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 12.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('已购试题'),
        SizedBox(height: 12.h),
        ...(state.purchasedGoods.map((goods) {
          final name = goods.name ?? '未命名商品';
          final coverPath = goods.materialCoverPath ?? '';
          
          // ✅ 安全处理封面路径
          final imageUrl = coverPath.isNotEmpty && coverPath.startsWith('http')
              ? coverPath
              : coverPath.isNotEmpty
                  ? 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/$coverPath'
                  : '';
          
          // ✅ 从 tikuGoodsDetails 获取题目数量
          final questionNum = goods.tikuGoodsDetails?.questionNum ?? 0;
          final questionCount = '$questionNum题';

          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _buildPurchasedItem(
              name,
              questionCount,
              imageUrl,
            ),
          );
        })),
      ],
    ),
  );
}
```

---

## ✅ 优化后的完整检查清单

### 代码层面
- [ ] ✅ 添加 `goodsServiceProvider` 导入
- [ ] ✅ 修正 `questionCount` 字段为 `tikuGoodsDetails?.questionNum`
- [ ] ✅ 安全处理 `materialCoverPath` 可能为 null 的情况
- [ ] ✅ 添加空值默认处理

### 逻辑层面
- [x] ✅ 技能模拟显示条件正确（已实现）
- [x] ✅ 每日一测显示条件正确（已实现）
- [x] ✅ 专业切换刷新数据（已实现）
- [x] ✅ 打卡功能逻辑正确（已实现）

### UI层面
- [x] ✅ 学习日历卡片样式一致
- [x] ✅ 4个功能卡片布局正确
- [x] ✅ 章节练习显示前3个
- [x] ✅ 已购试题列表样式正确

---

## 🎯 总结

### 关键问题（必须修复）
1. ⚠️ **添加 `goodsServiceProvider` 导入**（编译错误）
2. ⚠️ **修正 `questionCount` 字段访问**（运行时错误）
3. ⚠️ **安全处理 `coverPath` 空值**（避免异常）

### 其他问题
- ✅ 所有UI已与小程序保持一致
- ✅ 所有逻辑判断已正确实现
- ✅ 所有状态管理已正确实现

---

**修复优先级**: 🔴 高 - 必须立即修复，否则无法编译运行  
**影响范围**: 已购试题模块  
**修复时间**: 约5分钟

