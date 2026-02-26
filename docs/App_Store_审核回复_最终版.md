# App Store 审核回复 - 最终版

## 📋 回复内容（英文）

```
Subject: Response to App Review Feedback - Guidelines 5.1.1(v), 2.3.2, and 5.1.1

Dear App Review Team,

Thank you for your feedback regarding our app submission. We have carefully reviewed your concerns and would like to address each issue:

---

**Issue 1: Guideline 5.1.1(v) - Account Deletion Feature**

We understand the requirement for account deletion functionality. We are currently implementing this feature and will submit an updated version of the app with the account deletion capability included.

The account deletion feature will be accessible from:
My → Settings → Delete Account

The implementation will include:
- Risk warning page displaying account information and data that will be deleted
- Security verification requiring password confirmation
- Final confirmation step to prevent accidental deletion
- Complete account and data removal process

We will upload a new IPA package with this feature implemented as soon as possible.

---

**Issue 2: Guideline 2.3.2 - Promotional Images**

We have removed all promotional images for in-app purchase products from App Store Connect, as we do not have plans to promote these products in the App Store. All in-app purchases will only be available and displayed within the app itself.

---

**Issue 3: Guideline 5.1.1 - Account-Based In-App Purchases**

We would like to clarify that our in-app purchases are account-based, not standalone products. All IAP products (question banks, exam papers, mock exams) require student account binding and are tied to account-specific functionality.

**Technical Implementation:**
- All purchases require a student account ID (studentId) during the purchase process
- Purchased content is permanently bound to the user's account
- Learning progress, answer records, and statistics are stored per account
- Cross-device synchronization requires account authentication

**Service Nature:**
Our app provides online learning services, not static content sales:
- Question bank practice requires account to track progress, wrong answers, and learning statistics
- Mock exams require account to record scores, rankings, and history
- All features require account management and data synchronization

**Compliance with Guideline 5.1.1:**
User registration is tied to account-specific functionality (learning services), which is standard practice for educational apps. Registration is necessary for the core functionality of the app, as all learning content and progress must be associated with a student account.

We believe our implementation complies with Guideline 5.1.1 as our IAP products are account-based and registration is tied to account-specific functionality.

---

We appreciate your patience and will submit the updated version with the account deletion feature as soon as it is completed.

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

感谢您对我们应用提交的反馈。我们已经仔细审阅了您的关注点，并希望逐一解决每个问题：

---

**问题 1: Guideline 5.1.1(v) - 账户删除功能**

我们理解账户删除功能的要求。我们正在实现此功能，并将提交包含账户删除功能的应用更新版本。

账户删除功能将可通过以下路径访问：
我的 → 设置 → 删除账户

实现将包括：
- 风险提示页面，显示账户信息和将被删除的数据
- 安全验证，需要密码确认
- 最终确认步骤，防止误删
- 完整的账户和数据删除流程

我们将在功能完成后尽快上传新的 IPA 包。

---

**问题 2: Guideline 2.3.2 - 促销图片**

我们已经从 App Store Connect 中删除了所有内购产品的促销图片，因为我们没有在 App Store 中推广这些产品的计划。所有内购产品将仅在应用内提供和展示。

---

**问题 3: Guideline 5.1.1 - 账户绑定型内购产品**

我们希望澄清，我们的内购产品是账户绑定型的，而非独立产品。所有内购产品（题库、试卷、模考）都需要学生账户绑定，并与账户特定功能相关联。

**技术实现：**
- 所有购买流程都需要学生账户ID（studentId）
- 购买后的内容永久绑定到用户账户
- 学习进度、答题记录和统计数据按账户存储
- 跨设备同步需要账户验证

**服务性质：**
我们的应用提供在线学习服务，而非静态内容销售：
- 题库练习需要账户来跟踪进度、错题和学习统计
- 模拟考试需要账户来记录成绩、排名和历史
- 所有功能都需要账户管理和数据同步

**符合 Guideline 5.1.1：**
用户注册与账户特定功能（学习服务）绑定，这是教育类应用的标准做法。注册对于应用的核心功能是必需的，因为所有学习内容和进度都必须与学生账户关联。

我们相信我们的实现符合 Guideline 5.1.1，因为我们的内购产品是账户绑定型的，注册与账户特定功能相关联。

---

我们感谢您的耐心，将在账户删除功能完成后尽快提交更新版本。

此致
敬礼

[您的姓名]
[您的团队]
[联系方式]
```

---

## 📝 使用说明

### 在 App Store Connect 中回复

1. 登录 [App Store Connect](https://appstoreconnect.apple.com)
2. 进入：我的 App → [选择你的App] → 版本 → [选择被拒的版本]
3. 找到"回复审核"或"Resolution Center"
4. 复制上面的英文回复内容
5. 粘贴到回复框中
6. 点击"提交"

### 注意事项

1. 问题1：说明正在实现，会上传新版本
2. 问题2：说明已删除促销图片
3. 问题3：详细说明内购是账户绑定型，符合要求

### 回复后需要做的

1. 完成账户删除功能的实现
2. 测试完整流程
3. 上传新的 IPA 包
4. 在 App Store Connect 中提交新版本

---

## ⚠️ 关于问题3的处理说明

### 问题3是否需要等待审核人员回复？

**答案：不需要等待，可以直接提交新版本。**

**原因：**
1. **问题3是申诉说明**：你在回复中已经详细说明了内购是账户绑定型的，符合 Guideline 5.1.1
2. **审核流程**：审核人员会在审核新版本时同时查看你的回复说明
3. **并行处理**：问题1（账户删除）和问题3（内购说明）可以同时处理，不需要分开等待

### 建议操作流程

**方案A：先回复，再提交新版本（推荐）**
1. ✅ 先在 Resolution Center 回复三个问题的说明
2. ✅ 完成账户删除功能开发
3. ✅ 上传包含账户删除功能的新 IPA 包
4. ✅ 提交新版本审核
5. ⏳ 等待审核人员审核（会同时查看你的回复和新版本）

**方案B：先提交新版本，再回复**
1. ✅ 完成账户删除功能开发
2. ✅ 上传新 IPA 包并提交审核
3. ✅ 同时在 Resolution Center 回复说明
4. ⏳ 等待审核

### 问题3可能的审核结果

**情况1：审核人员接受说明（大概率）**
- ✅ 审核通过，应用上架
- 说明你的回复充分，审核人员理解内购是账户绑定型

**情况2：审核人员需要更多信息（小概率）**
- ⚠️ 可能再次拒绝，要求提供更多技术细节
- 例如：要求提供代码截图、购买流程截图等
- 需要再次回复补充说明

**情况3：审核人员不接受说明（极小概率）**
- ❌ 坚持认为不符合要求
- 可能需要调整应用逻辑或提供更多证据

### 如何提高问题3通过率

1. **确保代码实现与说明一致**
   - 检查所有 IAP 购买流程都确实需要 `studentId`
   - 确保购买后的内容确实绑定到账户

2. **准备补充材料（如需要）**
   - 购买流程截图（显示需要登录）
   - 代码片段（显示 studentId 参数）
   - 账户绑定说明文档

3. **如果被再次拒绝**
   - 提供更详细的技术说明
   - 提供购买流程的视频或截图
   - 引用其他类似教育类应用的实现方式

---

**更新时间**：2025-01-25  
**状态**：待提交
