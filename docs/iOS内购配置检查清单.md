# iOS 内购配置检查清单（标准化流程）

## 📌 产品ID规则

**标准格式**: `bundle_id.goods_id`

**示例**:
- Bundle ID: `com.yakaixin.yakaixin`
- 商品ID (goods_id): `123`
- 苹果产品ID (product_id): `com.yakaixin.yakaixin.123`

**代码实现**:
```dart
// lib/features/payment/services/iap_service.dart
String getProductId(String goodsId) {
  const bundleId = 'com.yakaixin.yakaixin';
  return '$bundleId.$goodsId';
}
```

## ✅ 配置步骤

### 步骤 1：在 App Store Connect 创建内购产品

#### 1.1 登录并进入内购配置

### 1.2 创建新的内购产品

点击 **"+"** 创建新产品：

1. **选择类型**:
   - ✅ 消耗型项目（推荐，适合课程、题库）
   - 非消耗型项目
   - 自动续期订阅
   - 非续期订阅

2. **填写产品ID**（重要！）:
   ```
   格式: com.yakaixin.yakaixin.{商品ID}
   示例: com.yakaixin.yakaixin.123
   ```
   
   **如何获取商品ID**:
   - 从后台接口 `/c/goods/v2` 获取商品列表
   - 每个商品都有唯一的 `id` 字段
   - 使用这个 `id` 作为 `goods_id`

3. **填写参考名称**:
   ```
   示例: 2024年护士资格考试题库
   ```

#### 1.3 配置产品详情

**价格等级**:
- ¥1.00 = Tier 1
- ¥6.00 = Tier 6
- ¥30.00 = Tier 30
- ¥298.00 = Tier 298
- 更多价格参考 App Store Connect 价格列表

**本地化信息**（至少添加中文简体）:
- **显示名称**: 显示给用户的名称
  ```
  示例: 2024年护士资格考试题库
  ```
- **描述**: 详细说明
  ```
  示例: 包含3580道精选题目，助你轻松通过考试
  ```

#### 1.4 提交产品审核

1. 完成所有必填字段后，点击 **"提交以供审核"**
2. 产品状态变为 **"等待审核"**
3. **关键**: 即使在审核中，沙盒环境也可以测试！

### 步骤 2：配置 Xcode 项目

#### 1. 检查 App Store Connect 中的 Bundle ID

```
App Store Connect > 你的App > App信息 > Bundle ID
```

确认 Bundle ID（例如：`com.yakaixin.app`）

#### 2. 检查 Xcode 项目中的 Bundle ID

打开 `yakaixin_app/ios/Runner.xcodeproj`：

```
Runner > Signing & Capabilities > Bundle Identifier
```

**必须完全一致**！

#### 3. 检查 Info.plist

```xml
<!-- yakaixin_app/ios/Runner/Info.plist -->
<key>CFBundleIdentifier</key>
<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
```

### 步骤 3：创建沙盒测试账号

#### 1. 创建沙盒测试账号

1. **登录 App Store Connect**
2. **进入用户和访问**：
   ```
   首页 > 用户和访问 > 沙盒测试员
   ```
3. **点击 "+" 添加测试员**
   - 邮箱：使用未注册过 Apple ID 的邮箱
   - 密码：设置强密码
   - 地区：中国

#### 2. 在设备上登录沙盒账号

**iOS 设置 > App Store > 沙盒账户**：
1. 打开 **设置**
2. 滚动到底部，点击 **App Store**
3. 点击 **沙盒账户**
4. 登录刚创建的测试账号

**重要**：
- ⚠️ 不要在 iCloud 中登录沙盒账号
- ⚠️ 只在"App Store > 沙盒账户"中登录
- ⚠️ 测试完成后记得退出

#### 3. 验证沙盒账号

运行应用，尝试购买时会弹出登录框（如果未登录）。

### 步骤 4：后台配置

#### 4.1 确保商品数据完整

后台接口 `/c/goods/v2` 返回的商品必须包含:
```json
{
  "id": "123",           // 商品ID，用于生成苹果产品ID
  "name": "商品名称",
  "amount": "298.00",   // 价格（必须与App Store Connect一致）
  "type": "18"          // 商品类型
}
```

#### 4.2 产品ID对应关系

| 后台字段 | App Store Connect | Flutter代码 |
|---------|------------------|-------------|
| `goods.id = "123"` | `product_id = "com.yakaixin.yakaixin.123"` | `getProductId("123")` |
| `goods.amount = "298.00"` | `价格等级 = Tier 298` | 自动从产品详情获取 |
| `goods.name` | `显示名称` | 显示给用户 |

#### 4.3 验证接口支持

确保后端支持内购收据验证接口:
```
POST /c/pay/iap/verify
```

请求参数:
```json
{
  "order_id": "订单ID",
  "goods_id": "商品ID",
  "receipt_data": "Base64编码的收据",
  "transaction_id": "苹果交易ID",
  "product_id": "com.yakaixin.yakaixin.123"
}
```

## 📋 完整检查清单

### ✅ App Store Connect 配置

- [ ] 产品已创建
- [ ] 产品ID格式正确: `com.yakaixin.yakaixin.{goods_id}`
- [ ] 价格等级已设置（必须与后台商品价格一致）
- [ ] 至少一个本地化信息（中文简体）
  - [ ] 显示名称
  - [ ] 描述
- [ ] 产品状态:
  - [ ] ✅ 等待审核（可以测试）
  - [ ] ✅ 已批准（可以测试）
  - [ ] ⚠️ 准备提交（无法测试）

### ✅ Xcode 项目配置

- [ ] Bundle ID 与 App Store Connect 一致
- [ ] 签名配置正确
- [ ] Capabilities 中启用 In-App Purchase
  ```
  Xcode > Runner > Signing & Capabilities > + Capability > In-App Purchase
  ```

### ✅ 沙盒测试配置

- [ ] 创建沙盒测试账号
- [ ] 设备上登录沙盒账号（设置 > App Store > 沙盒账户）
- [ ] 测试设备连接到网络

### ✅ 后台配置

- [ ] 商品接口返回正确的 `id` 字段
- [ ] 商品价格与 App Store Connect 一致
- [ ] 收据验证接口已实现
- [ ] 验证成功后正确开通权限

## 🧪 测试流程

### 1. 准备测试数据

从后台获取一个测试商品:
```bash
curl 'https://api.yakaixin.com/c/goods/v2?type=18&page=1&page_size=1'
```

记录返回的商品ID:
```json
{
  "data": {
    "list": [
      {
        "id": "123",      // ← 商品ID
        "name": "测试商品",
        "amount": "1.00"
      }
    ]
  }
}
```

### 2. 创建对应的内购产品

在 App Store Connect 中创建产品:
- 产品ID: `com.yakaixin.yakaixin.123`
- 价格: ¥1.00 (Tier 1)
- 提交审核

### 3. 运行应用测试

```bash
# 1. 清理项目
cd yakaixin_app
flutter clean

# 2. 重新安装依赖
flutter pub get

# 3. 运行应用（真机）
flutter run
```

### 4. 查看日志

**查询产品**:
```
🔍 开始查询产品...
   产品ID列表: {com.yakaixin.yakaixin.123}
📊 查询结果:
   找到产品数: 1  ✅
   未找到产品数: 0
✅ 找到的产品详情:
   - ID: com.yakaixin.yakaixin.123
     标题: 测试商品
     价格: ¥1.00
```

**购买流程**:
```
🍎 ========== 开始iOS内购 ==========
📝 订单ID: order_123456
📦 商品ID: 123
🏷️ 产品ID: com.yakaixin.yakaixin.123

📱 步骤1: 查询产品信息...
✅ 找到产品: 测试商品
   价格: ¥1.00

💳 步骤2: 发起购买...
✅ 购买请求已发送，等待用户确认...

📬 收到购买更新: purchased
✅ 购买成功！开始验证收据...

🔐 步骤3: 验证收据...
✅ 收据获取成功

🌐 步骤4: 调用后端验证...
✅ 收据验证成功，权限已开通

✔️ 步骤5: 结束交易...
🎉 ========== 内购流程完成 ==========
```

## 🎯 常见问题

### Q1: 商品ID从哪里获取？
**A**: 从后台接口 `/c/goods/v2` 返回的商品列表中，每个商品都有唯一的 `id` 字段。

### Q2: 如果后台返回的商品ID很长怎么办？
**A**: 没关系，苹果产品ID支持长ID。例如: `com.yakaixin.yakaixin.595918548996463431`

### Q3: 价格必须完全一致吗？
**A**: ✅ 是的！后台 `amount` 字段和 App Store Connect 价格等级必须对应。

### Q4: 产品状态是"准备提交"，能测试吗？
**A**: ❌ 不能。必须至少提交到"等待审核"状态。

### Q5: 需要上传应用才能测试内购吗？
**A**: ❌ 不需要。只要产品配置完成并提交审核，沙盒环境即可测试。

### Q6: 沙盒测试会真实扣费吗？
**A**: ❌ 不会。沙盒环境所有交易都是模拟的。

### Q7: 可以在模拟器上测试吗？
**A**: ⚠️ iOS 模拟器不支持真实的内购流程，建议使用真机测试。

### Q8: 一个商品可以创建多个内购产品吗？
**A**: ❌ 不可以。`product_id = bundle_id.goods_id` 是一一对应的。

---

## 📚 参考资料

- [Apple 官方文档 - 设置内购买](https://developer.apple.com/cn/in-app-purchase/)
- [App Store Connect 帮助](https://help.apple.com/app-store-connect/)
- [Flutter in_app_purchase 插件](https://pub.dev/packages/in_app_purchase)

## 🚀 下一步

### 立即操作

1. **获取商品列表**:
   ```bash
   curl 'https://api.yakaixin.com/c/goods/v2?type=18'
   ```

2. **为每个商品创建内购产品**:
   - 产品ID格式: `com.yakaixin.yakaixin.{goods_id}`
   - 价格必须与商品 `amount` 一致
   - 提交审核

3. **配置沙盒测试账号**:
   - 创建测试账号
   - 设备登录

4. **运行测试**:
   - 查询产品
   - 完成购买流程
   - 验证权限开通

---

**更新时间**: 2025-01-25  
**产品ID规则**: `bundle_id.goods_id`  
**Bundle ID**: `com.yakaixin.yakaixin`
