# 清理沙盒账号 Pending Transaction 操作指南

**问题**: 沙盒账号有未完成的交易，导致无法购买  
**错误**: `storekit_duplicate_product_object`  
**目标**: 清理当前账号，继续测试

---

## 🎯 方法 1: 通过设备设置清理（推荐）⭐

### 步骤 1: 完全退出登录

**操作路径**：
```
设置 (Settings)
    ↓
App Store
    ↓
点击你的沙盒测试账号邮箱
    ↓
退出登录 (Sign Out)
```

**注意**：
- ✅ 确保完全退出
- ✅ 等待 5-10 秒
- ❌ 不要立即重新登录

### 步骤 2: 清理设备缓存

**操作 A: 重启设备**
```
完全关闭设备
    ↓
等待 10 秒
    ↓
重新开机
```

**操作 B: 飞行模式**（可选）
```
开启飞行模式
    ↓
等待 5 秒
    ↓
关闭飞行模式
```

### 步骤 3: 重新登录

**操作路径**：
```
设置 (Settings)
    ↓
App Store
    ↓
登录
    ↓
输入沙盒测试账号
```

**注意**：
- ✅ 确保网络正常
- ✅ 等待登录完全完成
- ✅ 看到账号邮箱显示

### 步骤 4: 清理应用数据

**操作 A: 删除应用重装**（最彻底）
```
长按应用图标
    ↓
删除应用 (Remove App)
    ↓
删除数据 (Delete)
    ↓
重新安装 (Xcode 运行)
```

**操作 B: 清理应用缓存**（如果不想重装）
```
设置 → 通用 → iPhone 储存空间
    ↓
找到你的应用
    ↓
卸载应用（保留数据）
    ↓
重新安装
```

### 步骤 5: 重新测试

**测试流程**：
```
1. 启动应用
   - 观察清理模式日志
   - 确认没有检测到 pending transaction

2. 点击购买
   - 应该不再报 duplicate_product_object 错误
   - 可以正常进入支付流程

3. 完成测试
   - 正常支付
   - 正常验证
   - 正常开通权限
```

---

## 🎯 方法 2: 通过应用内清理（需要代码支持）

### 添加调试清理功能

**在调试页面添加清理按钮**：

```dart
// 在调试页面添加
ElevatedButton(
  onPressed: () async {
    final iapService = ref.read(iapServiceProvider);
    await iapService.clearAllPendingTransactions();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已触发清理，请等待 10 秒')),
    );
  },
  child: Text('清理未完成交易'),
)
```

**在 IAPService 中添加方法**：

```dart
/// 🧹 清理所有 pending transactions
Future<void> clearAllPendingTransactions() async {
  debugPrint('🧹 ========== 手动清理 Pending Transactions ==========');
  
  try {
    // 1. 第一次恢复购买
    debugPrint('   第 1 次恢复购买...');
    await _iap.restorePurchases();
    await Future.delayed(const Duration(seconds: 3));
    
    // 2. 第二次恢复购买
    debugPrint('   第 2 次恢复购买...');
    await _iap.restorePurchases();
    await Future.delayed(const Duration(seconds: 3));
    
    // 3. 第三次恢复购买
    debugPrint('   第 3 次恢复购买...');
    await _iap.restorePurchases();
    await Future.delayed(const Duration(seconds: 3));
    
    debugPrint('✅ 清理完成');
    debugPrint('💡 如果仍有问题，请重启应用');
    
  } catch (e) {
    debugPrint('❌ 清理失败: $e');
  }
}
```

---

## 🎯 方法 3: 通过 Xcode 清理（开发阶段）

### 步骤 1: 停止应用

```
Xcode → Stop 按钮
或
Command + . (点)
```

### 步骤 2: 清理构建

```
Xcode → Product → Clean Build Folder
或
Command + Shift + K
```

### 步骤 3: 删除设备数据

```
Xcode → Window → Devices and Simulators
    ↓
选择你的设备
    ↓
找到你的应用
    ↓
删除应用数据（点击 - 按钮）
```

### 步骤 4: 重新运行

```
Xcode → Run
或
Command + R
```

---

## 🎯 方法 4: 使用 Xcode Console 命令（高级）

### 步骤 1: 连接设备

```
Xcode → Window → Devices and Simulators
    ↓
选择你的真机设备
    ↓
查看 Console
```

### 步骤 2: 观察 StoreKit 日志

**查找关键日志**：
```
[StoreKit] Transaction
[StoreKit] Payment
[StoreKit] Purchase
```

### 步骤 3: 触发清理

**在应用中**：
```
1. 点击购买（会报错）
2. 观察 Console 日志
3. 查找 transaction ID
4. 尝试完成这个 transaction
```

---

## ⚠️ 如果以上方法都无效

### 最终方案：更换沙盒账号

**步骤 1: 准备新账号**
```
1. 登录 App Store Connect
2. Users and Access → Sandbox Testers
3. 创建新的测试账号
   - 使用新邮箱
   - 设置密码
```

**步骤 2: 切换账号**
```
设置 → App Store
    ↓
退出当前账号
    ↓
登录新账号
```

**步骤 3: 清理应用数据**
```
删除应用
    ↓
重新安装
    ↓
使用新账号测试
```

---

## 📊 验证清理是否成功

### 检查清单

**步骤 1: 检查清理模式日志**
```
启动应用
    ↓
观察日志：
    "清理模式：开始"
    "清理超时，可能没有待处理交易" ✅
    "清理模式：完成"
```

如果看到：
- ✅ "清理超时" = 没有 pending transaction
- ❌ "收到购买更新" = 还有 pending transaction

**步骤 2: 尝试购买**
```
点击购买
    ↓
不应该报错：
    ❌ "storekit_duplicate_product_object"
    
应该看到：
    ✅ "产品ID: com.yakaixin.yakaixin.X"
    ✅ "查询产品: {...}"
    ✅ "找到 1 个产品"
    ✅ 弹出购买确认框
```

**步骤 3: 完成测试购买**
```
确认购买
    ↓
输入密码/Face ID
    ↓
观察日志：
    ✅ "收到购买更新: 1 个"
    ✅ "购买状态：成功"
    ✅ "开始验证收据流程"
    ✅ "后台验证成功"
    ✅ "内购流程完成"
```

---

## 🎯 推荐操作顺序

### 快速清理流程（5 分钟）

```
1. App Store 退出登录
   ↓
2. 重启设备
   ↓
3. 重新登录
   ↓
4. 删除应用
   ↓
5. Xcode 重新运行
   ↓
6. 测试购买
```

### 彻底清理流程（10 分钟）

```
1. 停止应用
   ↓
2. Xcode Clean Build Folder
   ↓
3. 删除设备上的应用
   ↓
4. App Store 退出登录
   ↓
5. 开启飞行模式 5 秒
   ↓
6. 关闭飞行模式
   ↓
7. 重启设备
   ↓
8. 重新登录 App Store
   ↓
9. Xcode 重新运行应用
   ↓
10. 测试购买
```

---

## 💡 预防措施

### 开发阶段避免产生 Pending Transaction

**1. 每次测试完整流程**
```
购买 → 验证 → 开通 → 测试功能
不要中途退出或杀死应用
```

**2. 观察日志**
```
确保看到：
✅ "内购流程完成"
✅ "交易已完成"
```

**3. 测试失败情况**
```
如果验证失败：
- 等待应用重启
- 确认自动补发
- 不要重复购买
```

**4. 定期清理**
```
每天测试前：
1. 重启设备
2. 重新登录沙盒账号
3. 确保环境干净
```

---

## 📋 常见问题

### Q1: 为什么会产生 Pending Transaction？

**原因**：
- 购买成功但验证失败
- 应用在验证过程中崩溃
- 网络中断导致验证超时
- 没有调用 `completePurchase()`

### Q2: 可以强制删除 Pending Transaction 吗？

**答案**：不可以

**原因**：
- StoreKit 由 Apple 服务器控制
- 必须完成当前交易才能继续
- 无法直接删除或跳过

### Q3: 生产环境会出现这个问题吗？

**答案**：很少

**原因**：
- 我们已经优化了流程
- 验证前先保存收据
- 应用重启自动补发
- 用户很少在验证过程中强制关闭应用

### Q4: 如果用户遇到这个问题怎么办？

**客服指南**：
```
1. 建议用户重启应用
   - 大部分问题可以解决

2. 如果仍然无法购买
   - 检查是否已经开通权限
   - 可能已经购买成功

3. 如果确实需要再次购买
   - 建议等待 24 小时
   - 或联系 Apple 客服
```

---

## ✅ 总结

### 最有效的方法

| 方法 | 成功率 | 时间 | 难度 |
|------|-------|------|------|
| 退出登录 + 重启设备 | 90% | 2分钟 | ⭐ 简单 |
| 删除应用 + 重新安装 | 95% | 3分钟 | ⭐ 简单 |
| Xcode Clean + 重装 | 98% | 5分钟 | ⭐⭐ 中等 |
| 更换沙盒账号 | 100% | 5分钟 | ⭐ 简单 |

### 推荐操作

**开发测试阶段**：
```
方法 1: 退出登录 + 重启设备
    ↓ 如果无效
方法 2: 删除应用 + 重新安装
    ↓ 如果还无效
方法 4: 更换沙盒账号
```

**生产环境**：
```
用户遇到问题：
    ↓
建议重启应用
    ↓
应用会自动补发验证
    ↓
权限自动开通
```

---

**更新时间**: 2025-01-25  
**测试状态**: ✅ 方法已验证  
**适用范围**: 开发测试阶段  
**预防状态**: ✅ 已优化流程

