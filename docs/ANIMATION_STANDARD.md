# 动画效果标准规范

## 📋 概述

本文档定义了应用中统一使用的动画效果标准，确保整个应用的动画体验一致。

---

## 🎬 标准动画效果

### 1. 底部弹出对话框动画（Bottom Sheet Animation）

**效果描述**：
- 内容从屏幕底部向上滑出
- 遮罩同时淡入显示
- 关闭时内容向下滑回，遮罩淡出

**动画参数**：
- **时长**：250ms
- **曲线**：`Curves.easeInOut`
- **内容动画**：`SlideTransition`（从 `Offset(0.0, 1.0)` 到 `Offset.zero`）
- **遮罩动画**：`FadeTransition`（透明度从 0 到 1）

**使用场景**：
- 时间范围选择器
- 底部操作菜单
- 底部表单输入
- 其他需要从底部弹出的对话框

**代码示例**：
```dart
// 动画控制器
_animationController = AnimationController(
  duration: const Duration(milliseconds: 250),
  vsync: this,
);

_animation = CurvedAnimation(
  parent: _animationController,
  curve: Curves.easeInOut,
);

// 内容区域
SlideTransition(
  position: Tween<Offset>(
    begin: const Offset(0.0, 1.0), // 从底部开始
    end: Offset.zero,              // 滑动到正常位置
  ).animate(_animation),
  child: Container(...),
)

// 遮罩
FadeTransition(
  opacity: _animation,
  child: Container(
    color: Colors.black.withOpacity(0.4),
  ),
)
```

**标准描述**：
> "使用底部弹出对话框动画，内容从底部向上滑出，遮罩淡入，动画时长 250ms，曲线 easeInOut"

---

### 2. 下拉展开动画（Dropdown Animation）

**效果描述**：
- 内容从触发按钮下方下拉展开
- 遮罩同时淡入显示
- 关闭时内容向上收起，遮罩淡出

**动画参数**：
- **时长**：250ms
- **曲线**：`Curves.easeInOut`
- **内容动画**：`SizeTransition`（高度从 0 展开到目标高度）
- **遮罩动画**：`FadeTransition`（透明度从 0 到 1）

**使用场景**：
- 专业选择下拉菜单
- 筛选条件下拉
- 其他需要从按钮下方展开的菜单

**代码示例**：
```dart
// 动画控制器（同上）
_animationController = AnimationController(
  duration: const Duration(milliseconds: 250),
  vsync: this,
);

_animation = CurvedAnimation(
  parent: _animationController,
  curve: Curves.easeInOut,
);

// 内容区域
SizeTransition(
  sizeFactor: _animation,
  axis: Axis.vertical,
  axisAlignment: -1.0, // 从顶部开始展开
  child: Container(
    height: 480.h,
    child: ...,
  ),
)

// 遮罩
FadeTransition(
  opacity: _animation,
  child: Container(
    color: Colors.black.withOpacity(0.4),
  ),
)
```

**标准描述**：
> "使用下拉展开动画，内容从按钮下方下拉展开，遮罩淡入，动画时长 250ms，曲线 easeInOut"

---

## 📝 标准描述模板

### 模板 1：底部弹出对话框
```
使用底部弹出对话框动画，内容从底部向上滑出，遮罩淡入，动画时长 250ms，曲线 easeInOut
```

### 模板 2：下拉展开菜单
```
使用下拉展开动画，内容从按钮下方下拉展开，遮罩淡入，动画时长 250ms，曲线 easeInOut
```

### 模板 3：通用描述
```
使用标准动画效果：
- 动画时长：250ms
- 动画曲线：easeInOut
- 内容动画：[SlideTransition/SizeTransition]
- 遮罩动画：FadeTransition
```

---

## 🎯 动画参数对照表

| 参数 | 值 | 说明 |
|------|-----|------|
| 时长 | 250ms | 所有标准动画统一使用 |
| 曲线 | `Curves.easeInOut` | 缓入缓出，自然流畅 |
| 遮罩透明度 | 0.4 | `Colors.black.withOpacity(0.4)` |
| 内容动画类型 | `SlideTransition` 或 `SizeTransition` | 根据展开方向选择 |

---

## ✅ 检查清单

实现动画时，确保：

- [ ] 动画时长设置为 250ms
- [ ] 使用 `Curves.easeInOut` 曲线
- [ ] 遮罩使用 `FadeTransition`
- [ ] 内容使用 `SlideTransition`（底部弹出）或 `SizeTransition`（下拉展开）
- [ ] 关闭时调用 `_animationController.reverse()`
- [ ] 在 `dispose()` 中释放 `AnimationController`

---

## 📚 参考实现

- **底部弹出对话框**：`lib/features/collection/widgets/time_range_selector_dialog.dart`
- **下拉展开菜单**：`lib/features/major/widgets/major_selector_dialog.dart`

---

## 💡 使用建议

1. **统一性**：所有类似的弹窗/下拉菜单都应使用相同的动画参数
2. **性能**：250ms 是经过测试的最佳时长，既流畅又不会感觉慢
3. **一致性**：与专业选择、时间选择器等保持一致的动画体验
4. **可维护性**：使用标准描述，方便团队沟通和理解

---

**最后更新**：2025-01-25

