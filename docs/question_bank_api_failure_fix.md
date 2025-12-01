# 🔴 题库页面接口失败问题诊断和修复

## 问题现象
打开题库页面时，真实API接口调用失败

---

## 🔍 问题诊断

### 根本原因
题库页面的 `QuestionBankProvider` 需要 `currentMajorProvider` 提供专业ID：

```dart
// lib/features/home/providers/question_bank_provider.dart Line 66
final majorId = _ref.read(currentMajorProvider)?.majorId;
if (majorId == null || majorId.isEmpty) {
  state = state.copyWith(error: '请先选择专业', errorType: ErrorType.dataEmpty);
  return;  // ❌ 直接返回，不加载任何数据
}
```

### 可能的原因

#### 1. 用户未登录
- `authProvider` 中没有用户信息
- `currentMajorProvider` 返回 null

#### 2. 用户已登录但未选择专业
- 用户token存在
- 但 `currentMajor` 为 null

#### 3. 专业数据未持久化
- 登录时获取了专业
- 但重启应用后丢失

---

## 🔧 解决方案

### 方案A: 添加默认专业 (快速修复)

修改 `QuestionBankProvider` 的 `loadAllData()` 方法：

```dart
Future<void> loadAllData() async {
  // 获取当前专业ID
  var majorId = _ref.read(currentMajorProvider)?.majorId;
  
  // ✅ 如果没有专业，使用默认专业
  if (majorId == null || majorId.isEmpty) {
    // 口腔执业医师默认ID
    majorId = '524033912737962623';
    print('⚠️ 未选择专业，使用默认专业: $majorId');
  }

  // 并行加载所有数据
  await Future.wait([
    _loadLearningData(majorId),
    _loadChapters(majorId),
    _loadPurchasedGoods(majorId),
    _loadDailyPractice(majorId),
    _loadSkillMock(majorId),
  ]);
}
```

### 方案B: 引导用户选择专业 (推荐)

在页面中添加专业选择引导：

```dart
// lib/features/home/views/question_bank_page.dart

Widget _buildContent(
  BuildContext context,
  WidgetRef ref,
  QuestionBankState state,
) {
  // ✅ 检查是否有专业
  final currentMajor = ref.watch(currentMajorProvider);
  
  if (currentMajor == null) {
    return _buildSelectMajorPrompt(context, ref);
  }

  // 原有的内容显示逻辑
  return CustomScrollView(...);
}

Widget _buildSelectMajorPrompt(BuildContext context, WidgetRef ref) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.school, size: 64.sp, color: Colors.grey),
        SizedBox(height: 16.h),
        Text('请先选择您的专业', style: TextStyle(fontSize: 16.sp)),
        SizedBox(height: 24.h),
        ElevatedButton(
          onPressed: () {
            // 打开专业选择对话框
            showDialog(
              context: context,
              builder: (context) => MajorSelectorDialog(
                onSelected: (major) {
                  // 选择后刷新页面
                  ref.read(questionBankProvider.notifier).loadAllData();
                },
              ),
            );
          },
          child: Text('选择专业'),
        ),
      ],
    ),
  );
}
```

### 方案C: 检查登录状态

在 `QuestionBankProvider` 的 `loadAllData()` 开始处添加：

```dart
Future<void> loadAllData() async {
  // ✅ 检查登录状态
  final authState = _ref.read(authProvider);
  if (!authState.isAuthenticated) {
    state = state.copyWith(
      error: '请先登录',
      errorType: ErrorType.unauthorized,
    );
    return;
  }

  // 获取当前专业ID
  final majorId = _ref.read(currentMajorProvider)?.majorId;
  if (majorId == null || majorId.isEmpty) {
    state = state.copyWith(
      error: '请先选择专业',
      errorType: ErrorType.dataEmpty,
    );
    return;
  }

  // ... 后续加载逻辑
}
```

---

## 🎯 推荐实施步骤

### Step 1: 立即修复（方案A）- 5分钟
```dart
// 修改 lib/features/home/providers/question_bank_provider.dart
Future<void> loadAllData() async {
  var majorId = _ref.read(currentMajorProvider)?.majorId;
  
  // ✅ 使用默认专业
  if (majorId == null || majorId.isEmpty) {
    majorId = '524033912737962623'; // 口腔执业医师
    print('⚠️ 使用默认专业: $majorId');
  }

  await Future.wait([...]);
}
```

### Step 2: 添加专业选择引导 (可选) - 30分钟
- 创建 `_buildSelectMajorPrompt()` 方法
- 在 `_buildContent()` 中检查专业是否为空
- 提供"选择专业"按钮

### Step 3: 完善专业持久化 (可选) - 20分钟
- 确保登录时保存专业
- 应用启动时自动加载专业
- 专业切换时保存到本地

---

## 🧪 调试方法

### 1. 检查当前专业状态

在 `QuestionBankPage` 的 `build` 方法中添加：

```dart
Widget build(BuildContext context) {
  final state = ref.watch(questionBankProvider);
  final currentMajor = ref.watch(currentMajorProvider);
  
  // ✅ 调试输出
  print('🔍 当前专业: ${currentMajor?.majorName} (${currentMajor?.majorId})');
  print('🔍 页面状态: loading=${state.isLoading}, error=${state.error}');
  
  // ... 后续逻辑
}
```

### 2. 检查网络请求日志

打开网络调试浮窗，查看：
- 是否有API请求发出
- 请求URL是否正确
- 返回的状态码和错误信息

### 3. 检查Mock模式

确认Mock模式是否开启：
```dart
final isMockEnabled = ref.watch(mockEnabledProvider);
print('🔍 Mock模式: ${isMockEnabled ? "开启" : "关闭"}');
```

---

## 📋 检查清单

- [ ] 用户是否已登录？
- [ ] 用户是否已选择专业？
- [ ] `currentMajorProvider` 是否返回null？
- [ ] Mock模式是否开启？
- [ ] 网络请求是否发出？
- [ ] API返回什么错误？

---

## 🎯 快速修复代码

复制以下代码直接使用：

```dart
// lib/features/home/providers/question_bank_provider.dart
Future<void> loadAllData() async {
  // ✅ 获取专业ID，如果没有则使用默认
  var majorId = _ref.read(currentMajorProvider)?.majorId;
  
  if (majorId == null || majorId.isEmpty) {
    // 使用默认专业（口腔执业医师）
    majorId = '524033912737962623';
    print('⚠️ [QuestionBankProvider] 未选择专业，使用默认专业: $majorId');
  } else {
    print('✅ [QuestionBankProvider] 当前专业ID: $majorId');
  }

  // 并行加载所有数据
  try {
    await Future.wait([
      _loadLearningData(majorId),
      _loadChapters(majorId),
      _loadPurchasedGoods(majorId),
      _loadDailyPractice(majorId),
      _loadSkillMock(majorId),
    ]);
    print('✅ [QuestionBankProvider] 所有数据加载完成');
  } catch (e) {
    print('❌ [QuestionBankProvider] 数据加载失败: $e');
    state = state.copyWith(
      error: '数据加载失败: ${e.toString()}',
      errorType: ErrorType.networkError,
    );
  }
}
```

---

**修复优先级**: 🔴 最高  
**预计修复时间**: 5分钟  
**建议方案**: 方案A（使用默认专业）

