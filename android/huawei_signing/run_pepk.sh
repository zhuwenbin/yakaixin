#!/usr/bin/env bash
# 华为应用市场 应用签名服务 - 方式二：生成加密的 sign.zip 供上传
# 对应步骤 a b c；步骤 d 为在 AGC 页面上传生成的 sign.zip

set -e

# 华为 AGC 提供的加密公钥（固定值，勿改）
HUAWEI_ENCRYPTION_KEY="034200041E224EE22B45D19B23DB91BA9F52DE0A06513E03A5821409B34976FDEED6E0A47DBA48CC249DD93734A6C5D9A0F43461F9E140F278A5D2860846C2CF5D2C3C02"
PEPK_JAR_URL="https://www.gstatic.com/play-apps-publisher-rapid/signing-tool/prod/pepk.jar"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
KEY_PROPERTIES="$PROJECT_ROOT/android/key.properties"
KEYSTORE_FILE="$PROJECT_ROOT/android/app/release.jks"
PEPK_JAR="$SCRIPT_DIR/pepk.jar"
OUTPUT_ZIP="$SCRIPT_DIR/sign.zip"

# ---------- a. 获取 pepk.jar ----------
if [ ! -f "$PEPK_JAR" ]; then
  echo "[a] 正在下载 pepk.jar ..."
  if command -v curl >/dev/null 2>&1; then
    curl -L -o "$PEPK_JAR" "$PEPK_JAR_URL"
  elif command -v wget >/dev/null 2>&1; then
    wget -O "$PEPK_JAR" "$PEPK_JAR_URL"
  else
    echo "错误: 未找到 curl 或 wget，请手动下载 pepk.jar 到 $SCRIPT_DIR"
    echo "下载地址: $PEPK_JAR_URL"
    exit 1
  fi
  echo "[a] pepk.jar 已就绪"
else
  echo "[a] pepk.jar 已存在，跳过下载"
fi

# ---------- b. 校验密钥文件 ----------
if [ ! -f "$KEYSTORE_FILE" ]; then
  echo "错误: 未找到签名密钥文件: $KEYSTORE_FILE"
  exit 1
fi
if [ ! -f "$KEY_PROPERTIES" ]; then
  echo "错误: 未找到 android/key.properties，无法读取别名和密码"
  exit 1
fi

STOREPASS=$(grep -E "^storePassword=" "$KEY_PROPERTIES" | cut -d'=' -f2- | tr -d '\r\n' | xargs)
KEYPASS=$(grep -E "^keyPassword=" "$KEY_PROPERTIES" | cut -d'=' -f2- | tr -d '\r\n' | xargs)
KEYALIAS=$(grep -E "^keyAlias=" "$KEY_PROPERTIES" | cut -d'=' -f2- | tr -d '\r\n' | xargs)

if [ -z "$STOREPASS" ] || [ -z "$KEYPASS" ] || [ -z "$KEYALIAS" ]; then
  echo "错误: key.properties 中缺少 storePassword / keyPassword / keyAlias"
  exit 1
fi

echo "[b] 使用密钥: $(basename "$KEYSTORE_FILE"), 别名: $KEYALIAS"

# ---------- c. 运行 pepk 生成加密 zip ----------
echo "[c] 正在生成 sign.zip（会使用 key.properties 中的密码）..."
cd "$SCRIPT_DIR"
java -jar pepk.jar \
  --keystore="$KEYSTORE_FILE" \
  --alias="$KEYALIAS" \
  --output=sign.zip \
  --encryptionkey="$HUAWEI_ENCRYPTION_KEY" \
  --include-cert \
  --keystore-pass="$STOREPASS" \
  --key-pass="$KEYPASS"

if [ ! -f "$OUTPUT_ZIP" ]; then
  echo "错误: 未生成 sign.zip"
  exit 1
fi

echo ""
echo "---------- 完成 ----------"
echo "已生成: $OUTPUT_ZIP"
echo ""
echo "[d] 请到华为开发者联盟 -> 应用签名服务 -> 上传签名密钥："
echo "    点击「浏览」选择上述 sign.zip 并上传。"
echo "    （可选）不上传「上传密钥」则使用同一密钥。"
echo ""
