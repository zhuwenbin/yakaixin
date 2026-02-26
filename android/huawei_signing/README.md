# 华为应用市场 - 应用签名（方式二）本地步骤

用于生成 `sign.zip` 并上传到 AppGallery Connect「应用签名密钥」页。

## 一键执行（完成 a b c）

在项目根目录执行：

```bash
bash android/huawei_signing/run_pepk.sh
```

脚本会：

- **a** 若缺少 `pepk.jar`，自动从 Google 官方地址下载到本目录
- **b** 使用 `android/app/release.jks` 与 `android/key.properties` 中的别名、密码
- **c** 使用华为提供的加密公钥生成 `sign.zip`，输出到本目录

## 步骤 d（手动）

1. 打开 [AppGallery Connect](https://developer.huawei.com/consumer/cn/service/josp/agc/index.html) -> 您的应用 -> 应用签名服务
2. 在「上传签名密钥」处点击 **浏览**
3. 选择本目录下生成的 **sign.zip**
4. 提交保存  
5. （可选）若不上传「上传密钥」，将使用同一套签名密钥

## 依赖

- 已安装 JDK，且 `java` 在 PATH 中
- 项目内已存在 `android/app/release.jks` 与 `android/key.properties`（含 `storePassword`、`keyPassword`、`keyAlias`）

## 说明

- `key.properties` 与 `release.jks` 已在 `.gitignore` 中，不会提交
- 生成的 `sign.zip` 建议不要提交；若需保留可加入 `.gitignore`：`android/huawei_signing/sign.zip`
