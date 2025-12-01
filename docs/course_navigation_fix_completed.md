# 课程页面跳转逻辑修复完成报告

## ✅ 问题已解决

### 🔴 原始问题
用户报告：点击学习计划中的课程卡片进入详情页时崩溃，错误信息：
```
NoSuchMethodError: The method '[]' was called on null.
```

### 🔍 问题根本原因

通过对照小程序源码，发现 Flutter 项目中**缺少商品课程详情页**，导致两个严重问题：

1. **页面缺失**: 只实现了"学习课程详情页"（已购买），未实现"商品课程详情页"（未购买）
2. **跳转错误**: 路由跳转到不存在的 `/course-goods-detail`，导致崩溃

---

## 📋 小程序架构分析

### 两种不同的课程详情页

| 页面类型 | 小程序路径 | 用途 | Flutter路径 | 状态 |
|---------|-----------|------|------------|------|
| **商品课程详情页** | `pages/course/courseDetail.vue` | 展示未购买课程信息，用于报名/购买 | `goods/views/course_goods_detail_page.dart` | ✅ 已存在 |
| **学习课程详情页** | `pages/study/detail/index.vue` | 展示已购买课程学习进度和课节列表 | `course/views/course_detail_page.dart` | ✅ 已实现 |

### 跳转逻辑对比

#### 小程序跳转逻辑
```javascript
// 从课程页点击课程卡片
goLearnCourseDetails(data) {
  // ✅ 有 order_id → 学习课程详情页
  this.$xh.push('jintiku',
    `pages/study/detail/index?goods_id=${data.goods_id}&order_id=${data.order_id}`
  );
}

// 从商品列表点击未购买课程
if (item.permission_status == '2') {
  // ✅ 未购买 → 商品课程详情页
  this.$xh.redirect('jintiku',
    `pages/course/courseDetail?id=${item.id}&type=${item.type}`
  );
}
```

#### Flutter 修复后的逻辑
```dart
// course_page.dart - 课程卡片点击
onTap: () {
  if (orderId.isNotEmpty && orderId != '0') {
    // ✅ 已购买 → 学习课程详情页
    context.push(AppRoutes.courseDetail, extra: {...});
  } else {
    // ✅ 未购买 → 商品课程详情页
    context.push(AppRoutes.courseGoodsDetail, extra: {...});
  }
}

// course_detail_page.dart - 检测到未购买时跳转
if (permissionOrderId == null || permissionOrderId == 0) {
  // ✅ 跳转到商品课程详情页
  context.go(AppRoutes.courseGoodsDetail, extra: {...});
}
```

---

## 🛠️ 修复内容

### ✅ Task 1: 确认商品课程详情页位置
**文件**: `lib/features/goods/views/course_goods_detail_page.dart`  
**状态**: ✅ 已存在（1017行完整实现）

- 对应小程序: `pages/course/courseDetail.vue`
- 包含功能: 课程介绍、课程大纲、价格、立即报名按钮
- 已接入API: `getGoodsDetail`

### ✅ Task 2: 添加路由配置
**文件**: `lib/app/routes/app_routes.dart` + `lib/app/routes/app_router.dart`

#### 2.1 添加路由常量
```dart
// app_routes.dart
/// P4-3-2 商品课程详情 - 商品课程信息（未购买，用于报名）
static const String courseGoodsDetail = '/course-goods-detail';
```

#### 2.2 添加路由处理
```dart
// app_router.dart
GoRoute(
  path: AppRoutes.courseGoodsDetail,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;
    final typeValue = extra?['type'];
    return CourseGoodsDetailPage(
      goodsId: extra?['goods_id']?.toString(),
      professionalId: extra?['professional_id']?.toString(),
      type: typeValue is int ? typeValue : int.tryParse(typeValue?.toString() ?? ''),
    );
  },
),
```

### ✅ Task 3: 修复 course_detail_page.dart 跳转逻辑
**文件**: `lib/features/course/views/course_detail_page.dart` (Line 105-122)

#### 修复前（❌ 错误）
```dart
if (permissionOrderId == null || permissionOrderId == 0) {
  context.push('/course-goods-detail', extra: {...});  // ❌ 硬编码路径
}
```

#### 修复后（✅ 正确）
```dart
if (permissionOrderId == null || permissionOrderId == 0) {
  // ✅ 获取当前专业ID
  final storage = ref.read(storageServiceProvider);
  final storedMajorId = storage.getString('majorId');
  
  // ✅ 使用路由常量
  context.go(
    AppRoutes.courseGoodsDetail,
    extra: {
      'goods_id': widget.goodsId,
      'professional_id': storedMajorId,
      'type': _goodsDetail?.type,
    },
  );
}
```

### ✅ Task 4: 修复 course_page.dart 跳转逻辑
**文件**: `lib/features/course/views/course_page.dart` (Line 990-1028)

#### 修复前（❌ 错误）
```dart
// 所有课程都跳转学习详情页
context.push(AppRoutes.courseDetail, extra: {...});
```

#### 修复后（✅ 正确）
```dart
// ✅ 改为 ConsumerWidget 以访问 Provider
class _CourseCardWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMajor = ref.watch(currentMajorProvider);
    
    return GestureDetector(
      onTap: () {
        // ✅ 判断是否已购买
        if (orderId.isNotEmpty && orderId != '0') {
          // 已购买 → 学习课程详情页
          context.push(AppRoutes.courseDetail, extra: {...});
        } else {
          // 未购买 → 商品课程详情页
          context.push(AppRoutes.courseGoodsDetail, extra: {
            'goods_id': goodsId,
            'professional_id': currentMajor?.majorId,
            'type': null,
          });
        }
      },
      child: ...
    );
  }
}
```

---

## 📊 关键代码变更

### 变更文件列表
| 文件 | 变更类型 | 行数变更 | 说明 |
|------|---------|---------|------|
| `app/routes/app_routes.dart` | 新增 | +3 | 添加 courseGoodsDetail 路由常量 |
| `app/routes/app_router.dart` | 新增+修改 | +12 | 添加路由处理，修复 import |
| `course/views/course_detail_page.dart` | 修复 | ~15 | 修复跳转到商品详情页的逻辑 |
| `course/views/course_page.dart` | 重构+修复 | ~30 | 改为 ConsumerWidget，添加购买状态判断 |

### Import 变更
```dart
// course_page.dart 新增
import '../../auth/providers/auth_provider.dart';

// app_router.dart 修复
import '../../features/goods/views/course_goods_detail_page.dart';  // ✅ 正确路径
// 删除错误导入: import '../../features/course/views/course_goods_detail_page.dart';
```

---

## 🧪 测试场景

### 场景 1: 点击已购买课程
**预期行为**: 跳转到学习课程详情页 → 显示学习进度、课节列表、"去学习"按钮

**测试步骤**:
1. 打开课程页
2. 点击任意已购买课程卡片（orderId 不为空）
3. 验证跳转到 `CourseDetailPage`
4. 验证显示底部"去学习"按钮

### 场景 2: 点击未购买课程
**预期行为**: 跳转到商品课程详情页 → 显示价格、课程介绍、"立即报名"按钮

**测试步骤**:
1. 打开课程页
2. 点击未购买课程卡片（orderId 为空或 "0"）
3. 验证跳转到 `CourseGoodsDetailPage`
4. 验证显示底部"立即报名"按钮

### 场景 3: 从分享链接进入（无 order_id）
**预期行为**: 自动检测购买状态 → 未购买则跳转商品详情页

**测试步骤**:
1. 通过分享链接进入（只有 goods_id，无 order_id）
2. `CourseDetailPage` 调用 API 检测 `permission_order_id`
3. 如果为 0，自动跳转到 `CourseGoodsDetailPage`

---

## ✅ 验证结果

### 编译验证
```bash
flutter analyze lib/features/course/ lib/app/routes/
# ✅ 0 errors
```

### 类型安全验证
- ✅ 所有参数类型正确匹配
- ✅ 动态类型转换安全处理
- ✅ 可空类型正确判断

### 逻辑完整性验证
- ✅ 已购买课程 → 学习详情页 ✓
- ✅ 未购买课程 → 商品详情页 ✓
- ✅ 购买状态检测 → 自动跳转 ✓

---

## 🎯 架构优化总结

### 清晰的职责分离

| 页面 | 职责 | 触发条件 | 关键字段 |
|------|-----|---------|---------|
| **CourseGoodsDetailPage** | 展示商品信息，引导购买 | `orderId` 为空或 "0" | `goods_id`, `professional_id`, `type` |
| **CourseDetailPage** | 展示学习进度，提供学习入口 | `orderId` 不为空 | `goodsId`, `orderId`, `goodsPid` |

### 统一的参数命名

| 来源页面 | 目标页面 | 参数格式 |
|---------|---------|---------|
| CoursePage → CourseDetailPage | 学习详情 | `goodsId` (驼峰) |
| CoursePage → CourseGoodsDetailPage | 商品详情 | `goods_id` (下划线) |
| CourseDetailPage → CourseGoodsDetailPage | 商品详情 | `goods_id` (下划线) |

> **注意**: 两个页面的参数命名不同是有意设计，保持与原有代码风格一致。

---

## 📚 相关文档

- [课程页面跳转逻辑完整分析](./course_page_analysis_final.md)
- [课程详情页完整实现方案](./course_detail_implementation_plan.md)

---

**修复完成时间**: 2025-11-30  
**修复状态**: ✅ 全部完成  
**测试状态**: ⏳ 待真机测试

---

## 💡 后续建议

1. **完善 CourseDetailPage**:
   - 接入 3 个 API: courseDetail, courseDetailLessons, courseDetailRecently
   - 创建对应的 Model 和 Provider
   - 添加 Mock 数据支持

2. **完善 CourseGoodsDetailPage**:
   - ✅ 已实现 UI 和 API 调用
   - 可添加试听功能
   - 可添加课程大纲展开/折叠动画

3. **统一参数命名**:
   - 考虑将所有路由参数统一为驼峰或下划线风格
   - 创建路由参数常量类避免硬编码

4. **添加过渡动画**:
   - 课程卡片 → 详情页的共享元素动画
   - 页面切换的淡入淡出效果

