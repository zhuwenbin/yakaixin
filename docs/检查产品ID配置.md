# 检查产品 ID 配置

## 🔍 问题定位

错误 `⚠️ 未找到产品: [595918548996463431]` 说明：
- ❌ 不是后端服务器错误
- ✅ 是 Apple StoreKit API 查询错误
- ✅ 产品在 App Store Connect 中配置有问题

## 📋 必须检查的配置

### 1. App Store Connect 中检查

登录 [App Store Connect](https://appstoreconnect.apple.com)

#### 步骤 1：确认在正确的 App 下

```
我的 App > [选择你的App]
```

**关键信息**：
- App 名称：牙开心（或你的App名称）
- Bundle ID：`com.yakaixin.yakaixin` ← 必须完全匹配

#### 步骤 2：检查产品配置

```
App Store > 你的App > 功能 > App内购买项目
```

**必须检查**：
- [ ] 产品 ID: `595918548996463431`
- [ ] 产品存在于 **当前 App** 下
- [ ] 类型：非消耗型项目
- [ ] 价格等级：已设置（任意等级即可）

#### 步骤 3：检查产品状态

产品状态可以是以下任一种：
- ✅ 准备提交（黄色）← 你当前的状态，**可以测试**
- ✅ 等待审核（黄色）
- ✅ 已批准（绿色）
- ❌ 被拒绝（红色）← 这个不行

### 2. Bundle ID 完全匹配检查

#### Xcode 项目中的 Bundle ID

```bash
# 运行命令查看
grep -A 1 "PRODUCT_BUNDLE_IDENTIFIER" ios/Runner.xcodeproj/project.pbxproj | grep com
```

结果应该是：`com.yakaixin.yakaixin`

#### App Store Connect 中的 Bundle ID

```
App Store Connect > 我的 App > 你的App > App 信息 > 通用信息 > Bundle ID
```

**必须完全一致**！

### 3. 常见错误配置

#### ❌ 错误 1：产品在其他 App 下

如果你有多个 App，可能把产品创建在了错误的 App 下。

**解决**：
1. 删除错误 App 下的产品
2. 在正确的 App 下重新创建

#### ❌ 错误 2：Bundle ID 大小写不一致

```
Xcode:           com.yakaixin.yakaixin
App Store:       com.yakaixin.YaKaiXin  ← 错误！
```

Bundle ID **区分大小写**，必须完全一致。

#### ❌ 错误 3：使用了错误的产品类型

```
✅ 正确: 非消耗型项目（课程、题库这类一次性购买）
❌ 错误: 消耗型项目
❌ 错误: 自动续期订阅
```

## 🧪 测试方案

### 方案 A：创建标准格式的测试产品

在 App Store Connect 中创建新产品：

```
产品 ID: com.yakaixin.yakaixin.test001
参考名称: 测试课程
类型: 非消耗型
价格: Tier 1
```

然后修改代码测试：

```dart
// 临时测试
final productId = 'com.yakaixin.yakaixin.test001';
final products = await queryProducts({productId});
```

### 方案 B：使用现有产品排查

运行以下测试代码：

```dart
// 在 IAPService 的 initialize() 方法后添加
Future<void> testQueryProducts() async {
  print('🧪 开始测试查询产品...');
  
  // 测试 1：查询原产品 ID
  print('\n测试 1: 查询 595918548996463431');
  var products = await queryProducts({'595918548996463431'});
  print('结果: ${products.length} 个产品');
  
  // 测试 2：查询带前缀的产品 ID
  print('\n测试 2: 查询 com.yakaixin.yakaixin.595918548996463431');
  products = await queryProducts({'com.yakaixin.yakaixin.595918548996463431'});
  print('结果: ${products.length} 个产品');
  
  // 测试 3：查询所有可用产品（如果你创建了其他测试产品）
  print('\n测试 3: 查询测试产品 test001');
  products = await queryProducts({'com.yakaixin.yakaixin.test001'});
  print('结果: ${products.length} 个产品');
}
```

## 🎯 下一步行动

1. **立即检查**：
   - ✅ 确认产品在正确的 App 下
   - ✅ 确认 Bundle ID 完全匹配
   - ✅ 确认产品类型正确

2. **创建测试产品**：
   - ✅ 使用标准格式：`com.yakaixin.yakaixin.test001`
   - ✅ 设置价格等级
   - ✅ 保存后立即可测试（无需提交审核）

3. **验证配置**：
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

## 📝 记录结果

测试后请记录：
- [ ] 产品 `595918548996463431` 能否查询到
- [ ] 新建测试产品 `test001` 能否查询到
- [ ] Bundle ID 是否完全匹配
- [ ] 产品在哪个 App 下创建的

---

**重要**：即使产品状态是"准备提交"，沙盒环境也可以立即测试，无需等待审核！
