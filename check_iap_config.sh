#!/bin/bash

# iOS 内购配置验证脚本

echo "=========================================="
echo "🔍 iOS 内购配置检查"
echo "=========================================="
echo ""

# 1. 检查项目目录
echo "📁 1. 检查项目目录..."
if [ ! -d "ios" ]; then
    echo "❌ 错误：找不到 ios 目录"
    echo "   请在 Flutter 项目根目录运行此脚本"
    exit 1
fi
echo "✅ ios 目录存在"
echo ""

# 2. 检查 in_app_purchase 插件
echo "📦 2. 检查 in_app_purchase 插件..."
if grep -q "in_app_purchase" pubspec.yaml; then
    echo "✅ in_app_purchase 插件已添加"
    grep "in_app_purchase" pubspec.yaml | head -3
else
    echo "❌ 错误：未找到 in_app_purchase 插件"
    echo "   请在 pubspec.yaml 中添加："
    echo "   in_app_purchase: ^3.2.2"
fi
echo ""

# 3. 检查 Bundle ID
echo "📱 3. 检查 Bundle ID..."
BUNDLE_ID=$(grep -A 1 "PRODUCT_BUNDLE_IDENTIFIER" ios/Runner.xcodeproj/project.pbxproj | grep -o "com\.[^;]*" | head -1)
if [ -n "$BUNDLE_ID" ]; then
    echo "✅ Bundle ID: $BUNDLE_ID"
    echo "⚠️  请确认此 Bundle ID 与 App Store Connect 中的一致"
else
    echo "⚠️  无法自动检测 Bundle ID"
fi
echo ""

# 4. 检查插件集成
echo "🔌 4. 检查插件集成..."
if grep -q "InAppPurchasePlugin" ios/Runner/GeneratedPluginRegistrant.m; then
    echo "✅ InAppPurchasePlugin 已注册"
else
    echo "❌ 错误：InAppPurchasePlugin 未注册"
    echo "   请运行: flutter pub get"
fi
echo ""

# 5. 检查 IAPService 文件
echo "💳 5. 检查 IAPService 实现..."
if [ -f "lib/features/payment/services/iap_service.dart" ]; then
    echo "✅ IAPService 文件存在"
    
    # 检查产品 ID 生成逻辑
    if grep -q "getProductId" lib/features/payment/services/iap_service.dart; then
        echo "✅ getProductId 方法已定义"
    fi
    
    # 检查初始化方法
    if grep -q "initialize()" lib/features/payment/services/iap_service.dart; then
        echo "✅ initialize 方法已定义"
    fi
else
    echo "❌ 错误：未找到 IAPService 文件"
fi
echo ""

# 6. App Store Connect 配置提醒
echo "☁️  6. App Store Connect 配置检查清单"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "请手动检查以下项目："
echo ""
echo "□ 产品已创建"
echo "  - 产品 ID: 595918548996463431"
echo "  - 参考名称: 一元优惠直播课"
echo ""
echo "□ 价格等级已设置"
echo "  - 建议: Tier 1 (¥1.00)"
echo ""
echo "□ 本地化信息已添加（中文简体）"
echo "  - 显示名称: 例如 '一元优惠直播课'"
echo "  - 描述: 例如 '超值直播课程，限时1元'"
echo ""
echo "□ 产品状态"
echo "  - ❌ 准备提交（无法测试）"
echo "  - ✅ 等待审核（可以测试）"
echo "  - ✅ 已批准（可以测试）"
echo ""
echo "□ Bundle ID 匹配"
echo "  - App Store Connect: _______________________"
echo "  - Xcode 项目: $BUNDLE_ID"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 7. 沙盒测试账号提醒
echo "🧪 7. 沙盒测试账号配置"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "□ 已创建沙盒测试账号"
echo "  - App Store Connect > 用户和访问 > 沙盒测试员"
echo ""
echo "□ 设备上已登录沙盒账号"
echo "  - iOS 设置 > App Store > 沙盒账户"
echo "  - ⚠️ 不要在 iCloud 中登录"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 8. 测试建议
echo "🚀 8. 测试步骤"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1. 完善 App Store Connect 中的产品配置"
echo "2. 提交产品以供审核（状态变为'等待审核'）"
echo "3. 创建并登录沙盒测试账号"
echo "4. 运行应用测试："
echo "   flutter clean"
echo "   flutter pub get"
echo "   flutter run"
echo ""
echo "5. 查看日志，关键信息："
echo "   - '🔍 开始查询产品...'"
echo "   - '✅ 找到的产品详情:'"
echo "   - 如果显示'未找到产品'，请检查上述配置"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "=========================================="
echo "✅ 配置检查完成"
echo "=========================================="
echo ""
echo "📚 详细文档: docs/iOS内购配置检查清单.md"
echo ""
