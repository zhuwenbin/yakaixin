# Xcode 签名配置步骤（图文说明）

## 📍 配置位置

在 Xcode 中配置签名证书的位置：

### 步骤1：打开项目

1. 打开 Xcode
2. 打开工作空间文件：
   ```bash
   open ios/Runner.xcworkspace
   ```
   ⚠️ **注意**：必须打开 `.xcworkspace` 文件，不是 `.xcodeproj` 文件

### 步骤2：选择项目

1. 在左侧导航栏（Project Navigator）中，点击最顶部的 **"Runner"** 项目图标（蓝色图标）
2. 在中间区域，选择 **"TARGETS"** 下的 **"Runner"**（不是 PROJECT 下的 Runner）

### 步骤3：进入签名配置

1. 点击顶部标签栏的 **"Signing & Capabilities"** 标签
2. 这是配置签名的核心位置

---

## 🔧 配置签名证书

### 方法1：自动管理签名（推荐）

#### 配置位置

在 **"Signing & Capabilities"** 标签中：

1. **勾选 "Automatically manage signing"** ✅
   - 位置：在 "Signing" 部分的最上方
   - 勾选后，Xcode 会自动管理证书和配置文件

2. **选择 Team**
   - 位置：在 "Automatically manage signing" 下方
   - 下拉菜单选择：**6LPT9NQFKF (Sun Zhanpeng)**
   - 这是你的开发团队

3. **查看配置**
   - **Debug 配置**：自动使用 **Apple Development** 证书
   - **Release 配置**：自动使用 **Apple Distribution** 证书 ✅

#### 如何切换配置查看

1. 在 Xcode 顶部工具栏，找到 **Scheme** 选择器（显示 "Runner" 的地方）
2. 点击 **"Edit Scheme..."**
3. 在左侧选择 **"Archive"**
4. 在 **"Build Configuration"** 下拉菜单中选择：
   - **Debug** → 使用 Development 证书
   - **Release** → 使用 Distribution 证书 ✅

### 方法2：手动管理签名

如果自动管理遇到问题，可以手动配置：

1. **取消勾选 "Automatically manage signing"**
2. **选择 Provisioning Profile**
   - 在 "Provisioning Profile" 下拉菜单中选择对应的配置文件
   - **Debug** → 选择 Development 类型的 Profile
   - **Release** → 选择 Distribution 类型的 Profile ✅

---

## 📋 详细配置步骤

### 步骤1：打开 Signing & Capabilities

```
Xcode 窗口布局：
┌─────────────────────────────────────────┐
│  [Runner] 项目图标 (左侧导航栏)          │
│    ├─ TARGETS                           │
│    │   └─ Runner ← 选择这个             │
│    └─ PROJECT                           │
│                                         │
│  中间区域显示：                          │
│  ┌───────────────────────────────────┐  │
│  │ General | Signing & Capabilities │ ← 点击这个标签
│  │         | Build Settings | ...   │  │
│  └───────────────────────────────────┘  │
│                                         │
│  Signing 部分：                         │
│  ☑ Automatically manage signing        │
│  Team: [6LPT9NQFKF ▼]                  │
│  Bundle Identifier: com.yakaixin...   │
│  Provisioning Profile: (自动)          │
└─────────────────────────────────────────┘
```

### 步骤2：检查 Release 配置

1. 点击 Xcode 顶部工具栏的 **"Runner"** Scheme 选择器
2. 选择 **"Edit Scheme..."**
3. 在左侧选择 **"Archive"**
4. 查看 **"Build Configuration"**：
   - 应该选择 **"Release"** ✅
   - 这样 Archive 时会使用 Distribution 证书

### 步骤3：验证配置

在 **"Signing & Capabilities"** 标签中，查看：

**Debug 配置时：**
- Provisioning Profile 显示：`iOS Team Provisioning Profile: com.yakaixin.yakaixin (Development)`
- 证书类型：Apple Development ✅

**Release 配置时：**
- Provisioning Profile 显示：`iOS Team Provisioning Profile: com.yakaixin.yakaixin (Distribution)`
- 证书类型：Apple Distribution ✅

---

## 🔍 如何验证当前配置

### 方法1：在 Xcode 中查看

1. 打开 **"Signing & Capabilities"** 标签
2. 查看 **"Provisioning Profile"** 显示的信息
3. 如果显示 `(Distribution)`，说明配置正确 ✅

### 方法2：通过命令行验证

```bash
# 查看项目配置
cd /Users/mac/Desktop/vueToFlutter/yakaixin_app
xcodebuild -workspace ios/Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -showBuildSettings | grep CODE_SIGN_IDENTITY
```

**应该显示：**
```
CODE_SIGN_IDENTITY = Apple Distribution
```

### 方法3：构建后验证

```bash
# 构建 Release 版本
flutter build ios --release

# 检查签名
codesign -dvv build/ios/iphoneos/Runner.app | grep Authority
```

**应该显示：**
```
Authority=Apple Distribution: Sun Zhanpeng (...)
```

---

## ⚠️ 常见问题

### Q1: 为什么 Release 还是使用 Development 证书？

**可能原因：**
1. ❌ 没有勾选 "Automatically manage signing"
2. ❌ 手动选择了 Development 类型的 Provisioning Profile
3. ❌ 钥匙串中没有 Distribution 证书
4. ❌ Scheme 的 Archive 配置选择了 Debug

**解决方法：**
1. ✅ 勾选 "Automatically manage signing"
2. ✅ 让 Xcode 自动选择 Provisioning Profile
3. ✅ 确保 Archive 的 Build Configuration 是 Release
4. ✅ 如果没有 Distribution 证书，Xcode 会自动创建（需要账户权限）

### Q2: 如何确保 Archive 使用 Release 配置？

1. 点击 Scheme 选择器 → **"Edit Scheme..."**
2. 选择 **"Archive"**
3. 在 **"Build Configuration"** 中选择 **"Release"**
4. 点击 **"Close"**

### Q3: 如何查看当前使用的证书？

在 **"Signing & Capabilities"** 标签中：
- 查看 **"Provisioning Profile"** 后面的括号
- `(Development)` = 开发证书
- `(Distribution)` = 发布证书 ✅

---

## 📝 配置检查清单

### 在 Xcode 中检查：

- [ ] ✅ 已打开 `Runner.xcworkspace`（不是 `.xcodeproj`）
- [ ] ✅ 选择了 **TARGETS** 下的 **Runner**
- [ ] ✅ 在 **"Signing & Capabilities"** 标签
- [ ] ✅ 已勾选 **"Automatically manage signing"**
- [ ] ✅ Team 选择了 **6LPT9NQFKF (Sun Zhanpeng)**
- [ ] ✅ Scheme → Edit Scheme → Archive → Build Configuration 是 **Release**
- [ ] ✅ Provisioning Profile 显示 `(Distribution)`（Release 配置时）

### 验证构建：

- [ ] ✅ 运行 `flutter build ios --release`
- [ ] ✅ 检查签名：`codesign -dvv build/ios/iphoneos/Runner.app | grep Authority`
- [ ] ✅ 应该显示 `Apple Distribution`

---

## 🎯 快速配置步骤总结

1. **打开项目**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **选择 Target**
   - 左侧导航栏 → 点击 **Runner** 项目图标
   - 中间区域 → 选择 **TARGETS** 下的 **Runner**

3. **配置签名**
   - 点击 **"Signing & Capabilities"** 标签
   - 勾选 **"Automatically manage signing"** ✅
   - 选择 Team：**6LPT9NQFKF (Sun Zhanpeng)**

4. **配置 Archive**
   - 点击 Scheme 选择器 → **"Edit Scheme..."**
   - 选择 **"Archive"**
   - Build Configuration 选择 **"Release"** ✅

5. **验证**
   - 查看 Provisioning Profile 是否显示 `(Distribution)`
   - 构建并检查签名

---

## 📸 关键位置图示

### 位置1：Signing & Capabilities 标签
```
┌─────────────────────────────────────┐
│ General | Signing & Capabilities |  │ ← 点击这里
│         | Build Settings | ...     │
└─────────────────────────────────────┘
```

### 位置2：自动管理签名选项
```
Signing
☑ Automatically manage signing  ← 勾选这个
  Team: [6LPT9NQFKF ▼]          ← 选择团队
```

### 位置3：Archive 配置
```
Scheme: Runner ▼ → Edit Scheme...
  └─ Archive
     └─ Build Configuration: [Release ▼] ← 选择 Release
```

---

**配置完成后，Release 构建会自动使用 Distribution 证书！** ✅

