# App Store 审核回复 - 完整版（2025-01-30）

## 📋 回复内容（英文）

```
Subject: Response to App Review Feedback - Guidelines 5.1.1(v), 2.3.2, and 5.1.1

Dear App Review Team,

Thank you for your feedback regarding our app submission. We have carefully reviewed your concerns and have made the following changes to address each issue:

---

**Issue 1: Guideline 5.1.1(v) - Account Deletion Feature**

We have implemented the account deletion feature as required. The feature is now fully functional and accessible in the app.

**Location in App:**
My → Settings → Delete Account

**Implementation Details:**
The account deletion flow includes:
1. Risk Warning Page: Displays the account to be deleted (with masked phone number) and lists all data that will be permanently deleted
2. Security Verification Page: Requires password verification to ensure account security
3. Confirmation Page: Final confirmation step to prevent accidental deletion
4. Account Deletion Process: Shows "Account deletion under review" message and logs out the user

Users can now delete their accounts directly from the app without requiring customer service assistance.

---

**Issue 2: Guideline 2.3.2 - Promotional Images**

We have removed all promotional images for in-app purchase products from App Store Connect, as we do not have plans to promote these products in the App Store. All in-app purchases will only be available and displayed within the app itself.

---

**Issue 3: Guideline 5.1.1 - Data Collection and Storage**

We have revised the app to allow users to freely access app content without registration. The changes include:

**Changes Made:**

1. **Public Content Access (No Registration Required):**
   - Users can now browse the home page (product list) without registration
   - Users can view product details (question banks, exam papers, courses) without registration
   - Users can view course information and descriptions without registration
   - All browsing and viewing features are now accessible without requiring account creation

2. **Account-Based Features (Registration Required):**
   - Purchase/In-App Purchase: Requires account to bind purchases to user (studentId required)
   - Learning Progress: Requires account to track progress and statistics
   - Practice/Exam Taking: Requires account to save answers and records
   - Personal Center: Requires account to manage user data
   - Order Management: Requires account to view purchase history

**Implementation Details:**

- **Home Page**: Now accessible without login. Users can browse all products (question banks, exam papers, courses) freely.
- **Product Detail Pages**: Now accessible without login. Users can view product information, prices, and descriptions.
- **Purchase Flow**: When users click "Purchase" or "Enroll", they will be prompted to log in with a unified dialog. This is necessary because:
  - All purchases are account-bound (require studentId parameter)
  - Purchase history must be associated with an account
  - Learning content must be bound to an account for progress tracking
  - Cross-device synchronization requires account authentication

**Why Purchase Requires Login (Technical Justification):**

Our in-app purchases are **account-bound** and require `studentId` during the purchase process:
- All purchases must be associated with a student account (`studentId`)
- Purchase history must be stored per account
- Learning content must be bound to an account for progress tracking
- Cross-device synchronization requires account authentication

Therefore, requiring login for purchases is **necessary for the core functionality** and complies with Guideline 5.1.1, as registration is directly relevant to account-specific functionality (purchases and learning services).

**Compliance with Guideline 5.1.1:**

- ✅ Users can freely browse and view content without registration
- ✅ Registration is only required for account-based features (purchases, learning progress, practice)
- ✅ All in-app purchases are account-bound, requiring registration is necessary for the core functionality
- ✅ Registration is directly relevant to account-specific functionality (learning services)

---

We have uploaded a new version of the app with all these changes implemented. Users can now browse the app content freely, and registration is only required when they want to make purchases or access account-based features.

Thank you for your patience and understanding.

Best regards,
[Your Name]
[Your Team]
[Contact Information]
```

---

## 📋 回复内容（中文）

```
主题：关于 App 审核反馈的回复 - Guidelines 5.1.1(v)、2.3.2 和 5.1.1

尊敬的 App Review 团队：

感谢您对我们应用提交的反馈。我们已经仔细审阅了您的关注点，并已进行以下修改以解决每个问题：

---

**问题 1: Guideline 5.1.1(v) - 账户删除功能**

我们已经按要求实现了账户删除功能。该功能现已完全可用，可在应用内访问。

**功能位置：**
我的 → 设置 → 删除账户

**实现细节：**
账户删除流程包括：
1. 风险提示页面：显示要删除的账户（手机号脱敏显示）并列出所有将被永久删除的数据
2. 安全验证页面：需要密码验证以确保账户安全
3. 确认页面：最终确认步骤，防止误删
4. 账户删除流程：显示"注销审核中"提示并退出登录

用户现在可以直接从应用内删除账户，无需联系客服。

---

**问题 2: Guideline 2.3.2 - 促销图片**

我们已经从 App Store Connect 中删除了所有内购产品的促销图片，因为我们没有在 App Store 中推广这些产品的计划。所有内购产品将仅在应用内提供和展示。

---

**问题 3: Guideline 5.1.1 - 数据收集与存储**

我们已经修改了应用，允许用户无需注册即可自由访问应用内容。修改包括：

**已做的修改：**

1. **公开内容访问（无需注册）：**
   - 用户现在可以在不注册的情况下浏览首页（商品列表）
   - 用户可以在不注册的情况下查看商品详情（题库、试卷、课程）
   - 用户可以在不注册的情况下查看课程信息和介绍
   - 所有浏览和查看功能现在都可以在不创建账户的情况下访问

2. **账户型功能（需要注册）：**
   - 购买/内购：需要账户以将购买绑定到用户（需要 studentId 参数）
   - 学习进度：需要账户来跟踪进度和统计
   - 练习/考试：需要账户来保存答案和记录
   - 个人中心：需要账户来管理用户数据
   - 订单管理：需要账户来查看购买历史

**实现细节：**

- **首页**：现在无需登录即可访问。用户可以自由浏览所有商品（题库、试卷、课程）。
- **商品详情页**：现在无需登录即可访问。用户可以查看商品信息、价格和介绍。
- **购买流程**：当用户点击"购买"或"报名"时，会通过统一的对话框提示登录。这是必要的，因为：
  - 所有购买都是账户绑定型的（需要 studentId 参数）
  - 购买历史必须与账户关联
  - 学习内容必须绑定到账户以跟踪进度
  - 跨设备同步需要账户验证

**为什么购买需要登录（技术说明）：**

我们的内购是**账户绑定型的**，在购买过程中需要 `studentId`：
- 所有购买必须与学生账户（`studentId`）关联
- 购买历史必须按账户存储
- 学习内容必须绑定到账户以跟踪进度
- 跨设备同步需要账户验证

因此，购买时要求登录是**核心功能所必需的**，符合 Guideline 5.1.1，因为注册与账户特定功能（购买和学习服务）直接相关。

**符合 Guideline 5.1.1：**

- ✅ 用户可以自由浏览和查看内容，无需注册
- ✅ 注册仅用于账户型功能（购买、学习进度、练习）
- ✅ 所有内购都是账户绑定型的，要求注册对核心功能是必要的
- ✅ 注册与账户特定功能（学习服务）直接相关

---

我们已经上传了包含所有这些修改的新版本。用户现在可以自由浏览应用内容，只有在想要购买或访问账户型功能时才需要注册。

感谢您的耐心和理解。

此致
敬礼

[您的姓名]
[您的团队]
[联系方式]
```

---

## 📝 使用说明

### 在 App Store Connect 中回复的步骤

1. **登录 App Store Connect**
   - 访问：https://appstoreconnect.apple.com
   - 使用你的开发者账号登录

2. **找到被拒的版本**
   - 进入：我的 App → [选择你的App] → 版本 → [选择被拒的版本]
   - 或者直接进入：App Store Connect → 我的 App → [你的App] → 版本

3. **进入 Resolution Center**
   - 在版本详情页面，找到"Resolution Center"或"回复审核"按钮
   - 点击进入回复界面

4. **复制并粘贴回复**
   - 复制上面的**英文回复内容**（App Store 审核团队使用英文）
   - 粘贴到回复框中
   - 检查格式是否正确

5. **提交回复**
   - 点击"提交"或"Send"按钮
   - 确认回复已发送

### 回复后需要做的

1. ✅ **确认新版本已上传**
   - 检查 App Store Connect 中是否有新版本
   - 确认版本号已更新

2. ✅ **检查功能完整性**
   - 账户删除功能已实现
   - 未登录可以浏览内容
   - 购买时提示登录

3. ⏳ **等待审核**
   - 通常 24-48 小时内会有回复
   - 可以在 Resolution Center 查看审核状态

---

## ✅ 已完成的修改清单

### 问题1：账户删除功能
- [x] 实现风险提示页面
- [x] 实现安全验证页面（密码验证）
- [x] 实现确认页面
- [x] 实现删除流程（显示"注销审核中"）
- [x] 添加设置页面入口（我的 → 设置 → 删除账户）

### 问题2：促销图片
- [x] 从 App Store Connect 删除所有促销图片

### 问题3：强制注册问题
- [x] 修改路由逻辑：首页、商品详情页设为公开页面
- [x] 修改启动页：未登录时跳转到首页
- [x] 修改首页：支持未登录浏览
- [x] 修改商品详情页：支持未登录查看，购买时提示登录
- [x] 修改课程详情页：支持未登录查看，报名时提示登录
- [x] 统一登录提示：使用 ConfirmDialog
- [x] 添加登录页面返回按钮
- [x] 未登录时设置默认专业

---

## ⚠️ 重要提示

1. **使用英文回复**：App Store 审核团队使用英文，请使用英文版本回复

2. **回复要简洁明确**：
   - 说明已完成的修改
   - 提供功能位置
   - 解释技术原因（如需要）

3. **不要过度解释**：
   - 简洁说明修改即可
   - 避免冗长的技术细节

4. **保持礼貌专业**：
   - 使用正式的语气
   - 感谢审核团队的反馈

---

**更新时间**：2025-01-30  
**状态**：✅ 已实现，可提交  
**版本**：包含所有修改的新版本
