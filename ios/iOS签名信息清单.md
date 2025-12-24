# iOS 应用签名信息清单

## 📦 应用基本信息

- **Bundle ID**：`com.yakaixin.yakaixin`
- **应用名称**：牙开心学堂
- **开发团队ID**：`6LPT9NQFKF`

---

## ⚠️ 重要提示

**当前钥匙串中只有开发证书（Development），没有正式发布证书（Distribution）。**

**项目使用 Xcode 自动管理签名**，这意味着证书和配置文件由 Xcode 自动创建和管理。

### 如何获取正式发布证书（Distribution）

由于使用 Xcode 自动管理，需要按以下步骤获取 Distribution 证书：

#### 方法一：通过 Xcode 自动创建（推荐）

1. **打开 Xcode**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **选择项目**
   - 在左侧导航栏选择 `Runner` 项目
   - 选择 `Runner` target
   - 进入 **Signing & Capabilities** 标签

3. **配置 Release 签名**
   - 确保 **"Automatically manage signing"** 已勾选 ✅
   - 选择 **Team**：`6LPT9NQFKF` (Sun Zhanpeng)
   - 切换到 **Release** 配置（Product → Scheme → Edit Scheme → Run → Build Configuration 选择 Release）
   - Xcode 会自动创建 **Apple Distribution** 证书（如果还没有）

4. **构建 Release 版本**
   ```bash
   flutter build ios --release
   ```
   或
   ```bash
   xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner -configuration Release
   ```
   构建过程中，Xcode 会自动下载并安装 Distribution 证书到钥匙串

5. **获取证书信息**
   构建完成后，使用以下命令获取 Distribution 证书信息：
   ```bash
   security find-identity -v -p codesigning | grep -i "distribution"
   security find-certificate -c "Apple Distribution: ..." -p | openssl x509 -fingerprint -sha1 -noout -inform pem
   ```

#### 方法二：通过 Apple Developer Portal 手动下载

如果 Xcode 自动管理遇到问题，可以手动操作：

1. 登录 [Apple Developer Portal](https://developer.apple.com/account/)
2. 进入 **Certificates, Identifiers & Profiles**
3. 查看 **Certificates** → **Production** 类型
4. 如果已有 **Apple Distribution** 证书，点击下载
5. 双击 `.cer` 文件安装到钥匙串
6. 使用下面的命令获取证书信息

---

## 🔐 当前可用证书信息

### 证书1：Apple Development - Sun Zhanpeng（与项目团队ID匹配）

**证书信息：**
- **证书名称**：Apple Development: Sun Zhanpeng (XD28TU68H8)
- **团队ID**：6LPT9NQFKF ✅（与项目配置匹配）
- **所有者**：Sun Zhanpeng
- **有效期**：2025年12月1日 - 2026年12月1日

**证书SHA-1指纹（用于备案）：**
```
48:6B:0C:62:FB:AD:B1:02:DB:CD:08:35:A8:2A:3F:FA:8D:6F:49:21
```

**去除冒号格式（如需要）：**
```
486B0C62FBADB102DBCD0835A82A3FFA8D6F4921
```

**公钥（Public Key）：**
```
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzL3jSO6DxKeQNE7VHhHj3Tq9lf9ac2FMoXm8yte0pTHVd2bhJoGGkAQXt5eJp9UAwAFMvdRKzR8slMWZlzX0adu587dBHtnG0NXVJS21cWJO5gBDxPp+19JJVaN8kSyJRW26fW0N7YaqztmKX0vA+T4AbvtpN1MlYlh9Xef8qkgAOaCwGTsaarR/7Vak8M06G15uobxAaYZhegH4jlUoET76JwFLQcvVtkegB/1b08i7PGn/4Kvl59gnqwzA+Owcfq+4UyyK+sBOIwQ+iHqufHCArosxZPrxAyqnmq9GQ20OZbq2SRIlp7BOzl3KFnJOQz2Wxrd4em3vQEUSnWN4AwIDAQAB
```

**完整公钥（带格式）：**
```
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzL3jSO6DxKeQNE7VHhHj
3Tq9lf9ac2FMoXm8yte0pTHVd2bhJoGGkAQXt5eJp9UAwAFMvdRKzR8slMWZlzX0
adu587dBHtnG0NXVJS21cWJO5gBDxPp+19JJVaN8kSyJRW26fW0N7YaqztmKX0vA
+T4AbvtpN1MlYlh9Xef8qkgAOaCwGTsaarR/7Vak8M06G15uobxAaYZhegH4jlUo
ET76JwFLQcvVtkegB/1b08i7PGn/4Kvl59gnqwzA+Owcfq+4UyyK+sBOIwQ+iHqu
fHCArosxZPrxAyqnmq9GQ20OZbq2SRIlp7BOzl3KFnJOQz2Wxrd4em3vQEUSnWN4
AwIDAQAB
-----END PUBLIC KEY-----
```

---

### 证书2：Apple Development - 1182747855@qq.com

**证书信息：**
- **证书名称**：Apple Development: 1182747855@qq.com (864STT9ZZL)
- **团队ID**：BSDUUA2TCC
- **所有者**：wen zhu
- **有效期**：2025年10月23日 - 2026年10月23日

**证书SHA-1指纹：**
```
BF:D0:C5:6D:FC:37:84:E6:7D:F8:0F:EE:D7:FC:6B:37:CD:B8:71:9B
```

**去除冒号格式：**
```
BFD0C56DFC3784E67DF80FEED7FC6B37CDB8719B
```

**公钥：**
```
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApXHzAOjBTwfio6LuRgtu2Xx4X5btwf0YFW2MrzsgUf4e02AozmXOIoO8Y7ip5FadBE6OOH6d0uE3jOZYMRPHBCU3se7WVsYDE6PA79VGDsExQm5bHr3hSG5C/GqJMfE+njun0TR1cdJYemcGCHNWSGgt+W9Iog/axAPwyhBLV6wC+1mh9vy/m4IeHDYKpYTV3w4BSkrpL3xctxpus2IWSBR8c8jkN56i8gHnU7zM5qjPVox9JypMyc+h/onRgDh7JT4a2YmoYZ3QYeP2MpLyRS/4sVL9RH0Zp83WrL/s21Nu4CZj3aiQHDM4NdSHVYrJu7nAUXx61yEWRAp9FtLhhQIDAQAB
```

---

### 证书3：Apple Development - lei chen

**证书信息：**
- **证书名称**：Apple Development: lei chen (UQDG72CWS9)
- **团队ID**：SYRQW4PVF4
- **所有者**：Beijing Jin Yingjie Education Technology Group Co., Ltd.
- **有效期**：2024年11月9日 - 2025年11月9日 ⚠️（已过期）

**证书SHA-1指纹：**
```
4E:38:91:1D:AC:25:B6:AB:75:31:3F:CD:D8:62:DA:C4:DD:B0:51:FD
```

**去除冒号格式：**
```
4E38911DAC25B6AB75313FCDD862DAC4DDB051FD
```

---

### 证书4：Apple Development - 2820100012@qq.com

**证书信息：**
- **证书名称**：Apple Development: 2820100012@qq.com (TUDLP5X7QX)
- **团队ID**：3NCBL79FPZ
- **所有者**：文斌 朱
- **有效期**：2024年11月12日 - 2025年11月12日 ⚠️（已过期）

**证书SHA-1指纹：**
```
BD:59:61:60:AC:48:B3:42:41:9E:66:B0:CA:96:16:81:74:27:5D:64
```

**去除冒号格式：**
```
BD596160AC48B342419E66B0CA96168174275D64
```

---

## 📋 备案填写信息

### ⚠️ 当前状态：只有开发证书

**当前使用的是开发证书（Development）**，但应用备案通常需要 **Distribution 证书**。

### 临时方案：使用开发证书（证书1）

如果暂时无法获取 Distribution 证书，可以使用以下开发证书信息：

#### iOS平台Bundle ID
```
com.yakaixin.yakaixin
```

#### 公钥（开发证书）
```
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzL3jSO6DxKeQNE7VHhHj3Tq9lf9ac2FMoXm8yte0pTHVd2bhJoGGkAQXt5eJp9UAwAFMvdRKzR8slMWZlzX0adu587dBHtnG0NXVJS21cWJO5gBDxPp+19JJVaN8kSyJRW26fW0N7YaqztmKX0vA+T4AbvtpN1MlYlh9Xef8qkgAOaCwGTsaarR/7Vak8M06G15uobxAaYZhegH4jlUoET76JwFLQcvVtkegB/1b08i7PGn/4Kvl59gnqwzA+Owcfq+4UyyK+sBOIwQ+iHqufHCArosxZPrxAyqnmq9GQ20OZbq2SRIlp7BOzl3KFnJOQz2Wxrd4em3vQEUSnWN4AwIDAQAB
```

#### 证书SHA-1指纹（开发证书）
```
48:6B:0C:62:FB:AD:B1:02:DB:CD:08:35:A8:2A:3F:FA:8D:6F:49:21
```

**去除冒号格式（如需要）：**
```
486B0C62FBADB102DBCD0835A82A3FFA8D6F4921
```

### ✅ 推荐方案：获取 Distribution 证书后使用

**获取 Distribution 证书后，使用以下命令获取正式签名信息：**

```bash
# 1. 查找 Distribution 证书
security find-identity -v -p codesigning | grep -i "distribution"

# 2. 获取证书SHA-1指纹（替换为实际的证书名称）
security find-certificate -c "Apple Distribution: ..." -p | openssl x509 -fingerprint -sha1 -noout -inform pem

# 3. 获取公钥（替换为实际的证书名称）
security find-certificate -c "Apple Distribution: ..." -p | openssl x509 -pubkey -noout -inform pem | grep -v "BEGIN\|END" | tr -d '\n'
```

**获取到 Distribution 证书后，更新此文档中的备案信息。**

---

## 🔄 获取证书信息的命令

### 查看所有可用证书
```bash
security find-identity -v -p codesigning
```

### 获取指定证书的SHA-1指纹
```bash
security find-certificate -c "证书名称" -p | openssl x509 -fingerprint -sha1 -noout -inform pem
```

### 获取指定证书的公钥
```bash
security find-certificate -c "证书名称" -p | openssl x509 -pubkey -noout -inform pem | grep -v "BEGIN\|END" | tr -d '\n'
```

### 获取证书详细信息
```bash
security find-certificate -c "证书名称" -p | openssl x509 -subject -issuer -dates -noout -inform pem
```

---

## 📝 快速获取 Distribution 证书信息（Xcode 自动管理）

### 步骤1：构建 Release 版本触发证书创建

```bash
# 进入项目目录
cd /Users/mac/Desktop/vueToFlutter/yakaixin_app

# 构建 iOS Release 版本（Xcode 会自动创建 Distribution 证书）
flutter build ios --release
```

### 步骤2：查找 Distribution 证书

构建完成后，运行以下命令查找 Distribution 证书：

```bash
# 查找所有 Distribution 证书
security find-identity -v -p codesigning | grep -i "distribution"
```

### 步骤3：获取证书信息

找到 Distribution 证书后，使用证书名称获取信息：

```bash
# 替换 "Apple Distribution: ..." 为实际的证书名称
CERT_NAME="Apple Distribution: Sun Zhanpeng (6LPT9NQFKF)"

# 获取 SHA-1 指纹
security find-certificate -c "$CERT_NAME" -p | openssl x509 -fingerprint -sha1 -noout -inform pem

# 获取公钥（Base64，去除头尾）
security find-certificate -c "$CERT_NAME" -p | openssl x509 -pubkey -noout -inform pem | grep -v "BEGIN\|END" | tr -d '\n'

# 获取证书详细信息
security find-certificate -c "$CERT_NAME" -p | openssl x509 -subject -issuer -dates -noout -inform pem
```

### 一键获取脚本

创建以下脚本快速获取 Distribution 证书信息：

```bash
#!/bin/bash
# 获取 Distribution 证书信息

echo "=== 查找 Distribution 证书 ==="
security find-identity -v -p codesigning | grep -i "distribution"

echo ""
echo "=== 请输入证书名称（完整名称）："
read CERT_NAME

if [ -z "$CERT_NAME" ]; then
    echo "错误：证书名称不能为空"
    exit 1
fi

echo ""
echo "=== 证书 SHA-1 指纹 ==="
security find-certificate -c "$CERT_NAME" -p 2>/dev/null | openssl x509 -fingerprint -sha1 -noout -inform pem

echo ""
echo "=== 公钥（Base64） ==="
security find-certificate -c "$CERT_NAME" -p 2>/dev/null | openssl x509 -pubkey -noout -inform pem | grep -v "BEGIN\|END" | tr -d '\n'
echo ""

echo ""
echo "=== 证书详细信息 ==="
security find-certificate -c "$CERT_NAME" -p 2>/dev/null | openssl x509 -subject -issuer -dates -noout -inform pem
```

---

## ⚠️ 注意事项

1. **开发证书 vs 发布证书**
   - 开发证书（Development）：用于开发和测试
   - 发布证书（Distribution）：用于正式发布和备案 ✅

2. **证书有效期**
   - 开发证书通常有效期1年
   - 发布证书通常有效期3年
   - 过期前需要续期

3. **SHA-1指纹格式**
   - 备案系统可能需要去除冒号的格式
   - 确保使用40位十六进制数字

4. **公钥格式**
   - 备案系统通常需要Base64编码的公钥
   - 不要包含 `-----BEGIN PUBLIC KEY-----` 和 `-----END PUBLIC KEY-----`

5. **Bundle ID匹配**
   - 确保证书关联的App ID与Bundle ID匹配
   - 当前Bundle ID：`com.yakaixin.yakaixin`

---

## 🔍 验证证书是否有效

```bash
# 检查证书是否在钥匙串中
security find-certificate -c "证书名称" -a

# 验证证书是否有效
security find-certificate -c "证书名称" -p | openssl x509 -checkend 0 -noout
```

---

## 📝 更新记录

- **创建日期**：2025-01-25
- **Bundle ID**：com.yakaixin.yakaixin
- **开发团队ID**：6LPT9NQFKF
- **当前状态**：只有开发证书，需要创建Distribution证书用于正式发布

