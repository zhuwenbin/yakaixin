#!/bin/bash

# Flutter项目代码规范检查脚本

echo "🔍 开始代码规范检查..."
echo ""

# 1. 检查超大文件
echo "📏 检查超大文件 (>500行):"
find lib/features -name "*.dart" -type f ! -name "*.g.dart" ! -name "*.freezed.dart" -exec wc -l {} + | awk '$1 > 500 {print "⚠️  " $2 " (" $1 " 行)"}' | sort -t '(' -k2 -rn

echo ""

# 2. 检查硬编码颜色
echo "🎨 检查硬编码颜色 (Color(0x...)):"
grep -r "Color(0x" lib/features --include="*.dart" | grep -v "freezed" | wc -l | awk '{print "发现 " $1 " 处硬编码颜色"}'

echo ""

# 3. 检查硬编码字体大小
echo "📝 检查硬编码字体 (fontSize:):"
grep -r "fontSize:" lib/features --include="*.dart" | grep -v "freezed" | grep -v "AppTextStyles" | wc -l | awk '{print "发现 " $1 " 处硬编码字体"}'

echo ""

# 4. 检查硬编码间距
echo "📐 检查硬编码间距 (EdgeInsets.all/only):"
grep -r "EdgeInsets\." lib/features --include="*.dart" | grep -v "freezed" | grep -v "AppSpacing" | wc -l | awk '{print "发现 " $1 " 处硬编码间距"}'

echo ""

# 5. 运行Flutter分析
echo "🔧 运行 flutter analyze..."
flutter analyze --no-pub

echo ""
echo "✅ 检查完成!"
