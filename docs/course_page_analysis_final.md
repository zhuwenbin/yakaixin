# 课程页面跳转逻辑完整分析

## 🎯 核心发现：两种不同的课程详情页

### 1️⃣ **商品课程详情页** (Course Goods Detail)
**路径**: `pages/course/courseDetail.vue`  
**用途**: 展示**未购买**的课程商品信息，用于报名/购买  
**对应Flutter页面**: ❌ **尚未实现**

#### 页面特征
- 显示课程封面图
- 显示价格和"立即报名"按钮
- 显示课程大纲（章节/试听）
- 显示商品介绍

#### 跳转场景
```javascript
// 场景1: 点击未购买的网课/直播课
if ((item.type == 2 || item.type == 3) && 
    (item.teaching_type == 1 || item.teaching_type == 3)) {
  this.$xh.redirect('jintiku',
    `pages/course/courseDetail?professional_id=${item.professional_id}&id=${item.id}&type=${item.type}`
  );
}

// 场景2: 从学习课程详情页检测到未购买时跳转
if (!this.pageData.order_id || this.pageData.order_id == 0) {
  this.goDetailPage(goodsDetailsRes.data)
}
```

#### 参数
```javascript
{
  professional_id: "xxx",  // 专业ID
  id: "xxx",               // 商品ID (goods_id)
  type: "2" or "3"         // 2:网课 3:直播课
}
```

---

### 2️⃣ **学习课程详情页** (Course Study Detail)
**路径**: `pages/study/detail/index.vue`  
**用途**: 展示**已购买**的课程学习进度和课节列表  
**对应Flutter页面**: ✅ **已实现** (`course_detail_page.dart`)

#### 页面特征
- 显示学习进度
- 显示课节列表（可展开/折叠）
- 显示"去学习"按钮
- 显示最近学习

#### 跳转场景
```javascript
// 从课程页学习计划点击已购买课程
goLearnCourseDetails(data) {
  this.$xh.push('jintiku',
    `pages/study/detail/index?goods_id=${data.goods_id}&goods_pid=${data.goods_pid}&order_id=${data.order_id}`
  );
}
```

#### 参数
```javascript
{
  goods_id: "xxx",    // 商品ID
  goods_pid: "xxx",   // 套餐ID（可选）
  order_id: "xxx"     // 订单ID（关键！）
}
```

---

## 🚨 当前Flutter实现问题

### ❌ 问题1: 缺少"商品课程详情页"
当前只实现了"学习课程详情页"，但缺少"商品课程详情页"用于展示未购买的课程。

### ❌ 问题2: 路由配置不完整
```dart
// 当前路由 (yakaixin_app/lib/app/routes/app_routes.dart)
static const courseDetail = '/course-detail';  // ✅ 学习课程详情

// 缺失的路由
static const courseGoodsDetail = '/course-goods-detail';  // ❌ 商品课程详情
```

### ❌ 问题3: 跳转逻辑错误
```dart
// course_detail_page.dart Line 111-115
if (permissionOrderId == null || permissionOrderId == 0) {
  context.push('/course-goods-detail', extra: {  // ❌ 这个路由不存在！
    'goods_id': widget.goodsId,
    'type': goods.type,
  });
}
```

---

## ✅ 正确的实现方案

### Step 1: 创建"商品课程详情页"
```
yakaixin_app/lib/features/course/
├── views/
│   ├── course_detail_page.dart         ✅ 已实现（学习课程详情）
│   └── course_goods_detail_page.dart   ❌ 需要新建（商品课程详情）
```

### Step 2: 更新路由配置
```dart
// app/routes/app_routes.dart
class AppRoutes {
  // 学习课程详情（已购买）
  static const courseDetail = '/course-detail';
  
  // 商品课程详情（未购买）
  static const courseGoodsDetail = '/course-goods-detail';
}

// app/routes/app_router.dart
GoRoute(
  path: AppRoutes.courseGoodsDetail,
  name: 'courseGoodsDetail',
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>;
    return CourseGoodsDetailPage(
      goodsId: extra['goods_id'] as String,
      professionalId: extra['professional_id'] as String?,
      type: extra['type'] as String?,
    );
  },
),
```

### Step 3: 修复跳转逻辑

#### 在 `course_page.dart` 中
```dart
void _onCourseCardTap(CourseModel course) {
  // ✅ 判断是否已购买（有order_id）
  if (course.orderId != null && course.orderId != '0') {
    // 已购买 → 学习课程详情页
    context.push(AppRoutes.courseDetail, extra: {
      'goods_id': course.goodsId,
      'order_id': course.orderId,
      'goods_pid': course.goodsPid ?? '0',
    });
  } else {
    // 未购买 → 商品课程详情页
    context.push(AppRoutes.courseGoodsDetail, extra: {
      'goods_id': course.goodsId,
      'professional_id': course.professionalId,
      'type': course.type,
    });
  }
}
```

#### 在 `course_detail_page.dart` 中
```dart
// Line 106-117
if (permissionOrderId == null || permissionOrderId == 0) {
  print('\n❌ 最终判断: 未报名（permission_order_id 为空或0）');
  print('  → 跳转到商品详情页（报名/购买页面）');
  
  if (mounted) {
    // ✅ 跳转到商品课程详情页
    context.go(AppRoutes.courseGoodsDetail, extra: {
      'goods_id': widget.goodsId,
      'professional_id': _goodsDetail?.professionalId,
      'type': _goodsDetail?.type,
    });
  }
  return;
}
```

---

## 📋 实现任务清单

### 🔴 高优先级（修复跳转错误）
- [ ] 创建 `course_goods_detail_page.dart`（商品课程详情页UI）
- [ ] 添加 `courseGoodsDetail` 路由配置
- [ ] 修复 `course_detail_page.dart` 中的跳转逻辑
- [ ] 修复 `course_page.dart` 中的跳转逻辑

### 🟠 中优先级（完善功能）
- [ ] 创建 `CourseGoodsDetailService`（获取课程商品详情API）
- [ ] 创建 `CourseGoodsDetailProvider`（状态管理）
- [ ] 创建相关 Model
- [ ] 创建 Mock 数据

### 🟢 低优先级（优化体验）
- [ ] 添加课程试听功能
- [ ] 添加课程大纲展示
- [ ] 添加支付功能集成

---

## 🎯 下一步操作建议

### 方案A: 快速修复（30分钟）
1. 创建简单的 `course_goods_detail_page.dart`（显示"开发中"）
2. 添加路由配置
3. 修复跳转逻辑
4. **目标**: 防止跳转崩溃

### 方案B: 完整实现（2-3小时）
1. 参照小程序完整实现商品课程详情页UI
2. 接入真实API
3. 添加报名/支付功能
4. **目标**: 完整功能闭环

---

## 📊 当前状态总结

| 功能 | 小程序 | Flutter | 状态 |
|-----|--------|---------|------|
| 课程页（学习计划） | ✅ | ✅ | 完成 |
| 学习课程详情页 | ✅ | ⚠️ | UI完成，缺API |
| 商品课程详情页 | ✅ | ❌ | **未实现** |
| 课程跳转逻辑 | ✅ | ❌ | **错误** |

---

**结论**: 当前最严重的问题是**商品课程详情页完全缺失**，导致跳转到不存在的路由。建议先快速创建一个占位页面，防止崩溃。

