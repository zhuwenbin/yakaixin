#!/bin/bash
# 获取 iOS Distribution 证书信息脚本
# 用于应用备案

echo "=========================================="
echo "iOS Distribution 证书信息获取工具"
echo "=========================================="
echo ""

# 查找 Distribution 证书
echo "=== 查找 Distribution 证书 ==="
DIST_CERTS=$(security find-identity -v -p codesigning 2>/dev/null | grep -i "distribution")

if [ -z "$DIST_CERTS" ]; then
    echo "❌ 未找到 Distribution 证书"
    echo ""
    echo "请先执行以下步骤："
    echo "1. 打开 Xcode"
    echo "2. 打开项目：ios/Runner.xcworkspace"
    echo "3. 选择 Runner target → Signing & Capabilities"
    echo "4. 确保 'Automatically manage signing' 已勾选"
    echo "5. 构建 Release 版本：flutter build ios --release"
    echo ""
    echo "或者手动在 Apple Developer Portal 创建 Distribution 证书"
    exit 1
fi

echo "$DIST_CERTS"
echo ""

# 提取证书名称（取第一个）
CERT_NAME=$(echo "$DIST_CERTS" | head -1 | sed 's/.*"\(.*\)".*/\1/')

if [ -z "$CERT_NAME" ]; then
    echo "❌ 无法提取证书名称"
    exit 1
fi

echo "=== 使用证书：$CERT_NAME ==="
echo ""

# 获取 SHA-1 指纹
echo "=== 证书 SHA-1 指纹（用于备案）==="
SHA1=$(security find-certificate -c "$CERT_NAME" -p 2>/dev/null | openssl x509 -fingerprint -sha1 -noout -inform pem 2>/dev/null | cut -d'=' -f2)
if [ -n "$SHA1" ]; then
    echo "带冒号格式："
    echo "$SHA1"
    echo ""
    echo "去除冒号格式："
    echo "$SHA1" | tr -d ':'
else
    echo "❌ 无法获取 SHA-1 指纹"
fi
echo ""

# 获取公钥
echo "=== 公钥（用于备案）==="
PUBKEY=$(security find-certificate -c "$CERT_NAME" -p 2>/dev/null | openssl x509 -pubkey -noout -inform pem 2>/dev/null | grep -v "BEGIN\|END" | tr -d '\n')
if [ -n "$PUBKEY" ]; then
    echo "$PUBKEY"
else
    echo "❌ 无法获取公钥"
fi
echo ""

# 获取证书详细信息
echo "=== 证书详细信息 ==="
security find-certificate -c "$CERT_NAME" -p 2>/dev/null | openssl x509 -subject -issuer -dates -noout -inform pem 2>/dev/null
echo ""

echo "=========================================="
echo "备案填写信息汇总"
echo "=========================================="
echo ""
echo "iOS平台Bundle ID:"
echo "com.yakaixin.yakaixin"
echo ""
echo "公钥:"
echo "$PUBKEY"
echo ""
echo "证书SHA-1指纹:"
echo "$SHA1"
echo ""
echo "去除冒号格式:"
echo "$SHA1" | tr -d ':'
echo ""

