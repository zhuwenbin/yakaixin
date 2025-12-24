# CommonStateWidget 迁移指南

## 🎯 迁移目标

将项目中所有页面的错误/空状态UI统一替换为 `CommonStateWidget`，确保：
- ✅ 断网后所有页面显示效果一致
- ✅ 加载失败时UI统一
- ✅ 空数据状态统一

---

## 📋 迁移检查清单

### Phase 1: 核心页面（优先级最高）

- [x] ✅ `/features/order/views/my_order_page.dart` - 我的订单页（已完成）
- [x] ✅ `/features/goods/views/goods_detail_page.dart` - 商品详情页（已完成）
- [ ] `/features/course/views/my_course_page.dart` - 我的课程页
- [ ] `/features/collection/views/collection_page.dart` - 收藏页
- [ ] `/features/home/views/home_page.dart` - 首页

### Phase 2: 商品相关页面

- [ ] `/features/goods/views/secret_real_detail_page.dart`
- [ ] `/features/goods/views/simulated_exam_room_page.dart`
- [ ] `/features/exam/views/test_exam_page.dart`
- [ ] `/features/question_bank/views/wrong_book_page.dart`

### Phase 3: 其他页面

- [ ] `/features/profile/views/report_center_page.dart`
- [ ] 其他需要错误/空状态的页面

---

## 🔧 迁移步骤

### Step 1: 添加import

在页面文件顶部添加：

```dart
import '../../../core/widgets/common_state_widget.dart';
```

---

### Step 2: 替换错误状态UI

#### ❌ 修改前

```dart
Widget _buildError(String error) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, size: 64.sp, color: AppColors.error),
        SizedBox(height: AppSpacing.mdV),
        Text(
          error,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        SizedBox(height: AppSpacing.lgV),
        ElevatedButton.icon(
          onPressed: () {
            ref.read(myProvider.notifier).refresh();
          },
          icon: Icon(Icons.refresh, size: 18.sp),
          label: Text('重试', style: AppTextStyles.buttonMedium),
        ),
      ],
    ),
  );
}
```

#### ✅ 修改后

```dart
Widget _buildError(String error) {
  return CommonStateWidget.loadError(
    message: error,
    onRetry: () {
      ref.read(myProvider.notifier).refresh();
    },
  );
}
```

---

### Step 3: 替换空状态UI

#### 场景1: 通用空数据

**❌ 修改前**:
```dart
Widget _buildEmpty() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          ApiConfig.completeImageUrl('public/xxx.png'),
          width: 156.w,
          height: 102.h,
        ),
        SizedBox(height: 16.h),
        Text('暂无数据', style: TextStyle(fontSize: 12.sp)),
      ],
    ),
  );
}
```

**✅ 修改后**:
```dart
Widget _buildEmpty() {
  return CommonStateWidget.empty();
}
```

---

#### 场景2: 暂无订单

**❌ 修改前**:
```dart
Widget _buildEmptyView() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          ApiConfig.completeImageUrl('public/16954369620338446169543696203498545_xxx.png'),
          width: 114.w,
          height: 90.h,
        ),
        SizedBox(height: 20.h),
        Text('暂无订单！', style: TextStyle(fontSize: 13.sp)),
      ],
    ),
  );
}
```

**✅ 修改后**:
```dart
Widget _buildEmptyView() {
  return CommonStateWidget.noOrder();
}
```

---

#### 场景3: 暂无课程

**❌ 修改前**:
```dart
Widget _buildEmptyState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(/* ... */),
        Text('未找到符合的学习内容'),
        GestureDetector(
          onTap: () {
            context.go('/main-tab');
            ref.read(mainTabIndexProvider.notifier).state = 2;
          },
          child: Container(/* 按钮样式 */),
        ),
      ],
    ),
  );
}
```

**✅ 修改后**:
```dart
Widget _buildEmptyState() {
  return CommonStateWidget.noCourse(
    onAction: () {
      context.go('/main-tab');
      ref.read(mainTabIndexProvider.notifier).state = 2;
    },
  );
}
```

---

### Step 4: 在AsyncValue中使用

#### ❌ 修改前

```dart
asyncValue.when(
  data: (data) => /* ... */,
  loading: () => Center(child: CircularProgressIndicator()),
  error: (error, stack) => Center(
    child: Text('加载失败: $error'),
  ),
)
```

#### ✅ 修改后

```dart
asyncValue.when(
  data: (data) => /* ... */,
  loading: () => const Center(child: CircularProgressIndicator()),
  error: (error, stack) => CommonStateWidget.loadError(
    message: error.toString(),
    onRetry: () => ref.read(myProvider.notifier).refresh(),
  ),
)
```

---

### Step 5: 删除旧的错误/空状态方法

迁移完成后，删除以下方法（如果不再使用）：

```dart
// ❌ 可以删除
Widget _buildError(String error) { /* ... */ }
Widget _buildEmpty() { /* ... */ }
Widget _buildEmptyState() { /* ... */ }
Widget _buildEmptyView() { /* ... */ }
```

---

## 🔍 迁移验证

### 1. 断网测试

**测试步骤**:
1. 关闭WiFi和移动网络
2. 打开订单页面
3. 打开商品详情页
4. 打开课程页面

**预期结果**:
- ✅ 所有页面显示相同的"网络连接失败"提示
- ✅ 所有页面都有"重试"按钮
- ✅ UI风格统一（图标、文字、按钮）

---

### 2. 空数据测试

**测试步骤**:
1. 清空所有订单数据
2. 清空所有收藏
3. 清空所有错题

**预期结果**:
- ✅ 订单页显示"暂无订单！"
- ✅ 收藏页显示"暂无收藏"
- ✅ 错题页显示"暂无错题~"
- ✅ 图片、文字、样式统一

---

### 3. 加载失败测试

**测试步骤**:
1. Mock服务器返回500错误
2. 测试各个页面的错误提示

**预期结果**:
- ✅ 显示"加载失败"标题
- ✅ 显示友好的错误消息（不是技术错误）
- ✅ 有重试按钮

---

## 📊 迁移进度跟踪

### 已完成 (2个页面)

1. ✅ `my_order_page.dart` - 订单页面
   - 空状态: `CommonStateWidget.noOrder()`
   - 错误状态: `CommonStateWidget.loadError()`

2. ✅ `goods_detail_page.dart` - 商品详情页
   - 错误状态: `CommonStateWidget.loadError()`

### 待迁移 (预估10+个页面)

运行以下命令查找所有需要迁移的页面：

```bash
# 查找包含自定义错误UI的文件
grep -r "Icons.error_outline" lib/features --include="*.dart"

# 查找包含空状态图片的文件
grep -r "Image.network.*public.*png" lib/features --include="*.dart"

# 查找包含"暂无"文字的空状态
grep -r "暂无" lib/features --include="*.dart"
```

---

## ⚠️ 注意事项

### 1. 保留加载状态

```dart
// ✅ 正确：保留加载中的UI
body: state.isLoading
    ? _buildLoading()  // ← 保留
    : state.error != null
        ? CommonStateWidget.loadError(/* ... */)  // ← 使用新组件
        : /* ... */
```

### 2. 错误消息要友好

```dart
// ❌ 错误：直接显示技术错误
CommonStateWidget.loadError(
  message: 'DioException [connection error]: SocketException',
)

// ✅ 正确：显示友好消息
CommonStateWidget.loadError(
  message: '网络连接失败，请检查网络设置后重试',
)
```

### 3. 提供重试回调

```dart
// ❌ 错误：没有重试回调
CommonStateWidget.loadError(
  message: '加载失败',
  // onRetry 缺失
)

// ✅ 正确：提供重试回调
CommonStateWidget.loadError(
  message: '加载失败',
  onRetry: () => ref.read(myProvider.notifier).refresh(),
)
```

---

## 🎯 预期收益

完成迁移后：

1. **用户体验提升**
   - ✅ 断网后所有页面提示一致
   - ✅ 错误提示更友好
   - ✅ 交互逻辑统一

2. **开发效率提升**
   - ✅ 不再需要写重复的错误/空状态UI
   - ✅ 新页面开发更快
   - ✅ 代码量减少约30%

3. **维护成本降低**
   - ✅ 统一修改UI只需修改一个文件
   - ✅ 代码更简洁
   - ✅ 更容易测试

---

## 📞 问题反馈

如果在迁移过程中遇到问题：

1. 查看 [README_COMMON_STATE.md](../lib/core/widgets/README_COMMON_STATE.md)
2. 查看 [common_state_widget_example.dart](../lib/core/widgets/common_state_widget_example.dart)
3. 参考已完成的页面：
   - `my_order_page.dart`
   - `goods_detail_page.dart`

---

**迁移愉快！** 🚀
