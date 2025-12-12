# 🔐 Release签名快速参考

## ✅ 签名已生成成功！

### 📋 关键信息（请妥善保管）

```
签名MD5：9437b03faf5046bc6c0727bf9921846b
密码：   135698
别名：   yakaixin
```

---

## 🎯 立即行动清单

### ✅ 已完成
- [x] 生成Release签名文件
- [x] 创建key.properties配置文件
- [x] 获取签名MD5值
- [x] 添加到.gitignore（防止泄露）
- [x] 备份到桌面

### 🔲 待完成（重要！）

- [ ] **立即备份到云盘**（Google Drive、iCloud等）
- [ ] **保存密码到密码管理器**（1Password、LastPass等）
- [ ] **再备份一份到U盘或移动硬盘**
- [ ] **团队成员安全共享**（如需要）

---

## 📱 微信开放平台配置

### 当前阶段（开发测试）- 保持不变
```
应用包名：com.yakaixin.yakaixin.android
应用签名：5d56daa98f6ad171961632f24c53be3c (Debug签名)
备用签名：(不填)
```

### 准备上架时 - 更新配置
```
应用包名：com.yakaixin.yakaixin.android
应用签名：9437b03faf5046bc6c0727bf9921846b ← 改为Release签名
备用签名：5d56daa98f6ad171961632f24c53be3c ← 保留Debug签名
```

---

## 🔧 如何切换到Release签名

### 步骤1：修改配置
```kotlin
// android/app/build.gradle.kts
buildTypes {
    release {
        // 注释掉这行
        // signingConfig = signingConfigs.getByName("debug")
        
        // 取消注释这行
        signingConfig = signingConfigs.getByName("release")
    }
}
```

### 步骤2：打包测试
```bash
flutter build apk --release
```

### 步骤3：验证签名
```bash
keytool -printcert -jarfile build/app/outputs/flutter-apk/app-release.apk
```

---

## 📂 文件位置

```
签名文件：
/Users/mac/Desktop/vueToFlutter/yakaixin_app/android/app/release.jks

配置文件：
/Users/mac/Desktop/vueToFlutter/yakaixin_app/android/key.properties

备份文件：
/Users/mac/Desktop/yakaixin_release_backup_2025-12-12.jks

详细文档：
/Users/mac/Desktop/vueToFlutter/yakaixin_app/android/SIGNING_INFO.md
```

---

## ⚠️ 重要提醒

### 签名丢失 = 应用永远无法更新！

```
务必至少备份到3个地方：
1. 云盘（Google Drive、iCloud等）
2. 本地外接硬盘或U盘
3. 密码管理器（文件+密码）
```

### 密码忘记 = 签名无法使用！

```
立即保存到密码管理器：
密码：135698
别名：yakaixin
```

---

## 🎉 恭喜！

Release签名生成成功！现在你可以：

✅ 继续使用Debug签名开发测试  
✅ 随时切换到Release签名打包  
✅ 准备好上架应用商店  

**记住：立即完成备份！** 🔐
