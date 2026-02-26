# App Store 审核回复模板 - 问题1：账户删除功能

## 📋 回复模板（英文）

```
Subject: Response to Guideline 5.1.1(v) - Account Deletion Feature

Dear App Review Team,

Thank you for your feedback regarding Guideline 5.1.1(v) - Data Collection and Storage.

We understand that apps supporting account creation must also offer account deletion functionality. We are committed to providing this feature to give users full control over their data.

**Current Status:**
We are currently implementing the account deletion feature. Based on our previous project implementation, we have designed a comprehensive account deletion flow that includes:

1. **Risk Warning Page**: 
   - Displays the account to be deleted (with masked phone number)
   - Lists all data and assets that will be permanently deleted
   - Warns users about the irreversible consequences

2. **Security Verification Page**:
   - Requires password verification to ensure account security
   - Validates user identity before proceeding with deletion

3. **Confirmation Page**:
   - Final confirmation step to prevent accidental deletion
   - Clear explanation of the deletion process

4. **Account Deletion API**:
   - Backend API to permanently delete user account and all associated data
   - Complete removal of user information, learning records, purchase history, etc.

**Implementation Plan:**
- Frontend UI: Settings page → Account Deletion → Risk Warning → Security Verification → Confirmation
- Backend API: Account deletion endpoint to permanently remove user data
- Data Cleanup: Complete removal of all user-related data including:
  - Account information
  - Learning progress and records
  - Purchase history and permissions
  - Personal data and preferences

**Timeline:**
We are actively working on this feature and expect to complete implementation within [X] days. Once completed, we will submit an updated version for review.

**Location in App:**
The account deletion feature will be accessible from:
Settings → Account Management → Delete Account

We appreciate your patience and will notify you once the feature is fully implemented and ready for review.

Best regards,
[Your Name]
[Your Team]
```

---

## 📋 回复模板（中文）

```
主题：关于 Guideline 5.1.1(v) - 账户删除功能的回复

尊敬的 App Review 团队：

感谢您关于 Guideline 5.1.1(v) - 数据收集与存储的反馈。

我们理解支持账户创建的应用必须同时提供账户删除功能。我们致力于提供此功能，让用户完全控制自己的数据。

**当前状态：**
我们正在实现账户删除功能。基于我们之前项目的实现经验，我们设计了一个完整的账户删除流程，包括：

1. **风险提示页面**：
   - 显示要注销的账号（手机号脱敏显示）
   - 列出所有将被永久删除的数据和资产
   - 警告用户不可逆的后果

2. **安全验证页面**：
   - 要求密码验证以确保账户安全
   - 在继续删除前验证用户身份

3. **确认页面**：
   - 最终确认步骤，防止误删
   - 清楚说明删除流程

4. **账户删除 API**：
   - 后端 API 永久删除用户账户和所有关联数据
   - 完全移除用户信息、学习记录、购买历史等

**实现计划：**
- 前端 UI：设置页面 → 账户管理 → 删除账户 → 风险提示 → 安全验证 → 确认
- 后端 API：账户删除接口，永久移除用户数据
- 数据清理：完全移除所有用户相关数据，包括：
  - 账户信息
  - 学习进度和记录
  - 购买历史和权限
  - 个人数据和偏好设置

**时间表：**
我们正在积极开发此功能，预计在 [X] 天内完成实现。完成后，我们将提交更新版本供审核。

**功能位置：**
账户删除功能将可通过以下路径访问：
设置 → 账户管理 → 删除账户

感谢您的耐心，我们将在功能完全实现并准备好审核时通知您。

此致
敬礼

[您的姓名]
[您的团队]
```

---

## 📋 参考实现（基于 tiku 项目）

### 实现流程

```
设置页面
  ↓
点击"注销账号"
  ↓
风险提示页面（SKDeleteAccountRiskVC）
  - 显示要注销的账号（手机号脱敏）
  - 列出将被删除的权益和资产
  ↓
点击"下一步"
  ↓
安全验证页面（SKVerificationViewControlelr）
  - 输入密码验证
  - 调用登录接口验证密码
  ↓
密码验证成功
  ↓
确认注销页面（SKDeleteAccountMakeSureVC）
  - 显示"您所要注销账号"
  - 最终确认按钮
  ↓
点击"确认注销"
  ↓
显示"注销审核中"提示（SKDeleteAccountTostView）
  - 提示："为维护用户在APP内权益，请等待审核，审核通过后注销成功"
  ↓
调用后端删除账户 API（需要实现）
  ↓
清除本地数据
  ↓
退出登录，跳转到登录页
```

### 关键页面说明

1. **风险提示页面**：
   - 显示账号信息（脱敏）
   - 列出将被删除的权益：
     - 账号信息（包含身份信息）
     - 学习记录、笔记、下载记录
     - 课程及权益
     - 余额、赠币、礼券等资产
     - 分享返现金额

2. **安全验证页面**：
   - 输入密码
   - 调用登录接口验证密码
   - 验证成功后进入确认页面

3. **确认注销页面**：
   - 显示"您所要注销账号"
   - 最终确认按钮
   - 点击后显示"注销审核中"提示

4. **提示视图**：
   - 显示"注销审核中"
   - 说明："为维护用户在APP内权益，请等待审核，审核通过后注销成功"

---

## ⚠️ 重要说明

### Apple 要求

根据 Apple 的审核指南，账户删除必须：

1. **真正删除账户**：
   - 不能只是"停用"或"禁用"
   - 必须永久删除用户数据

2. **可以包含确认步骤**：
   - 可以要求密码验证
   - 可以显示风险提示
   - 可以要求最终确认

3. **不能要求客服**：
   - 除非是高度监管行业，否则不能要求用户通过电话或邮件完成删除
   - 必须在应用内完成删除流程

### 需要实现的后端 API

```
DELETE /api/user/delete-account

请求参数：
- token: 用户token（必需）
- password: 密码（用于验证，必需）

响应：
{
  "code": 100000,
  "msg": ["账户删除成功"],
  "data": null
}
```

### 需要删除的数据

- 用户基本信息（姓名、手机号、邮箱等）
- 学习记录（答题记录、错题本、学习进度等）
- 购买记录和权限
- 个人设置和偏好
- 所有关联数据

---

## 📝 实现检查清单

- [ ] 在设置页面添加"删除账户"入口
- [ ] 实现风险提示页面
- [ ] 实现安全验证页面（密码验证）
- [ ] 实现确认注销页面
- [ ] 实现后端删除账户 API
- [ ] 实现数据清理逻辑
- [ ] 清除本地存储数据
- [ ] 退出登录并跳转
- [ ] 测试完整流程
- [ ] 提交审核

---

## 🚀 下一步行动

1. **立即回复 Apple**：使用上面的模板回复审核团队
2. **实现功能**：参考 tiku 项目的实现，在 Flutter 项目中实现账户删除功能
3. **测试验证**：确保删除流程完整且符合 Apple 要求
4. **提交更新**：完成后提交新版本供审核

---

**更新时间**：2025-01-25  
**参考项目**：tiku (GoldQuestionBank)  
**状态**：待实现
