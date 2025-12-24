# 构建问题排查指南

## 问题1: Java版本不匹配

### 错误信息
```
Cannot find a Java installation matching: {languageVersion=17}
```

### 原因
- 项目默认配置Java 17
- 系统只安装了Java 25

### 解决方案
修改 `android/app/build.gradle.kts`：
```kotlin
compileOptions {
    sourceCompatibility = JavaVersion.VERSION_21
    targetCompatibility = JavaVersion.VERSION_21
}

kotlin {
    jvmToolchain(21)
}
```

---

## 问题2: webview_flutter编译错误

### 错误信息
```
错误: 找不到符号 PigeonApiWebSettingsCompat
错误: 找不到符号 PigeonApiWebResourceErrorCompat
... 100个错误
```

### 原因
- `webview_flutter` 4.4.2版本与Flutter 3.38.1存在兼容性问题
- Pigeon生成的代码不完整

### 解决方案
升级到最新版本：
```bash
# 1. 修改pubspec.yaml
webview_flutter: ^4.10.0

# 2. 更新依赖
flutter pub get
flutter pub upgrade webview_flutter webview_flutter_android webview_flutter_wkwebview

# 3. 清理重建
flutter clean
flutter build apk --split-per-abi --release
```

**更新后的版本**：
- webview_flutter: 4.10.0
- webview_flutter_android: 4.10.11 ✅
- webview_flutter_wkwebview: 3.23.5 ✅

---

## 问题3: Gradle Kotlin DSL语法错误

### 错误信息
```
Unresolved reference: util
Unresolved reference: minifyEnabled
Unresolved reference: shrinkResources
```

### 解决方案
在 `build.gradle.kts` 顶部添加导入：
```kotlin
import java.util.Properties
import java.io.FileInputStream
```

使用正确的属性名：
```kotlin
isMinifyEnabled = true      // ✅ 正确
isShrinkResources = true    // ✅ 正确

minifyEnabled = true        // ❌ 错误
shrinkResources = true      // ❌ 错误
```

---

## 常见警告（可忽略）

### 警告1: Java 8已过时
```
警告: [options] 源值 8 已过时，将在未来发行版中删除
```
**原因**: 第三方依赖使用Java 8编译  
**影响**: 无  
**处理**: 可以忽略

### 警告2: bridge方法覆盖
```
警告: onListen覆盖了bridge方法
```
**原因**: video_player插件内部实现  
**影响**: 无  
**处理**: 可以忽略

---

## 构建流程

### 完整构建命令
```bash
cd /Users/mac/Desktop/vueToFlutter/yakaixin_app

# 清理
flutter clean

# 获取依赖
flutter pub get

# 构建分架构APK（推荐）
flutter build apk --split-per-abi --release

# 或构建通用APK
flutter build apk --release

# 或构建AAB（Google Play）
flutter build appbundle --release
```

### 预计时间
- 首次构建: 10-15分钟
- 增量构建: 3-5分钟
- clean后: 8-12分钟

---

## 验证构建结果

### 检查APK文件
```bash
ls -lh build/app/outputs/flutter-apk/
```

应该看到:
```
app-arm64-v8a-release.apk      (推荐，大部分手机)
app-armeabi-v7a-release.apk   (老设备)
app-x86_64-release.apk         (模拟器)
```

### 验证签名
```bash
keytool -printcert -jarfile build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

应该看到:
```
所有者: CN=yakaixin
签名算法名称: SHA256withRSA
```

### 验证MD5
```bash
keytool -exportcert -alias yakaixin -keystore android/app/release.jks -storepass 135698 | openssl dgst -md5
```

应该输出:
```
MD5(stdin)= 9437b03faf5046bc6c0727bf9921846b
```

---

## 安装测试

### 通过USB安装
```bash
# 连接手机，开启USB调试
adb devices

# 安装APK
adb install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk

# 覆盖安装
adb install -r build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

### 检查应用信息
```bash
adb shell dumpsys package com.yakaixin.yakaixin.android | grep version
```

---

## 依赖版本记录

| 包名 | 版本 | 状态 |
|------|------|------|
| Flutter SDK | 3.38.1 | ✅ 稳定 |
| Dart SDK | 3.10.0 | ✅ 稳定 |
| webview_flutter | 4.10.0 | ✅ 已修复 |
| webview_flutter_android | 4.10.11 | ✅ 最新 |
| video_player | 2.8.2 | ✅ 稳定 |
| Java | 21 (兼容25) | ✅ 已配置 |

---

## 下次构建快速检查清单

- [ ] Java版本配置正确（VERSION_21）
- [ ] webview_flutter >= 4.10.0
- [ ] build.gradle.kts有正确的import
- [ ] 签名文件存在（release.jks）
- [ ] key.properties配置正确
- [ ] 执行flutter clean（如有问题）
- [ ] 网络连接正常（下载依赖）

---

**最后更新**: 2025-01-25  
**构建环境**: macOS 15.6.1, Flutter 3.38.1, Java 25
