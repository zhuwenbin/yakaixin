#!/bin/bash
# iOS 内购票据提取脚本
# 用途：从 Flutter 日志中提取完整的票据数据

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# 显示帮助信息
show_help() {
    cat << EOF
📦 iOS 内购票据提取工具

用法:
    $0 <日志文件> [输出文件]

参数:
    <日志文件>   Flutter 运行日志文件路径（必需）
    [输出文件]   提取后的票据保存路径（可选，默认: receipt_data.txt）

示例:
    # 基本用法
    $0 flutter_log.txt

    # 指定输出文件
    $0 flutter_log.txt my_receipt.txt

    # 先运行应用保存日志，再提取
    flutter run 2>&1 | tee flutter_log.txt
    $0 flutter_log.txt

说明:
    此脚本会从日志文件中提取 RECEIPT_DATA_START 和 RECEIPT_DATA_END 
    之间的完整票据数据（Base64 编码），不包含任何额外字符。

EOF
}

# 检查参数
if [ $# -lt 1 ]; then
    print_error "缺少参数"
    echo ""
    show_help
    exit 1
fi

# 检查是否请求帮助
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

LOG_FILE="$1"
OUTPUT_FILE="${2:-receipt_data.txt}"

# 检查日志文件是否存在
if [ ! -f "$LOG_FILE" ]; then
    print_error "日志文件不存在: $LOG_FILE"
    exit 1
fi

print_info "开始提取票据数据..."
print_info "日志文件: $LOG_FILE"
print_info "输出文件: $OUTPUT_FILE"
echo ""

# 提取票据数据
# 使用 sed 提取 RECEIPT_DATA_START 和 RECEIPT_DATA_END 之间的内容
# 并删除这两个标记行本身
if sed -n '/RECEIPT_DATA_START/,/RECEIPT_DATA_END/p' "$LOG_FILE" | \
   sed '1d;$d' > "$OUTPUT_FILE"; then
    
    # 检查输出文件是否为空
    if [ ! -s "$OUTPUT_FILE" ]; then
        print_error "未找到票据数据"
        print_warning "请确保日志中包含 RECEIPT_DATA_START 和 RECEIPT_DATA_END 标记"
        rm -f "$OUTPUT_FILE"
        exit 1
    fi
    
    # 获取数据信息
    FILE_SIZE=$(wc -c < "$OUTPUT_FILE" | tr -d ' ')
    FIRST_LINE=$(head -n 1 "$OUTPUT_FILE")
    PREVIEW="${FIRST_LINE:0:50}"
    
    echo ""
    print_success "票据数据提取成功！"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📋 文件信息:"
    echo "   输出文件: $OUTPUT_FILE"
    echo "   数据长度: $FILE_SIZE 字节"
    echo "   数据预览: $PREVIEW..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    # 验证 Base64 格式
    if echo "$FIRST_LINE" | grep -qE '^[A-Za-z0-9+/=]+$'; then
        print_success "✓ Base64 格式验证通过"
    else
        print_warning "⚠️  数据格式可能不是标准 Base64"
    fi
    
    echo ""
    echo "📤 下一步操作:"
    echo "   1. 查看数据: cat $OUTPUT_FILE"
    echo "   2. 复制数据: cat $OUTPUT_FILE | pbcopy (macOS)"
    echo "   3. 发送给后端测试"
    echo ""
    
else
    print_error "提取失败"
    exit 1
fi
