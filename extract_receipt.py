#!/usr/bin/env python3
"""
iOS 内购票据提取工具 (Python 版本)
用途：从 Flutter 日志中提取完整的票据数据
"""

import sys
import re
import os


def print_colored(message, color_code):
    """打印带颜色的消息"""
    print(f"\033[{color_code}m{message}\033[0m")


def print_info(message):
    print_colored(f"ℹ️  {message}", "0;34")


def print_success(message):
    print_colored(f"✅ {message}", "0;32")


def print_error(message):
    print_colored(f"❌ {message}", "0;31")


def print_warning(message):
    print_colored(f"⚠️  {message}", "1;33")


def show_help():
    """显示帮助信息"""
    help_text = """
📦 iOS 内购票据提取工具 (Python 版本)

用法:
    python3 extract_receipt.py <日志文件> [输出文件]

参数:
    <日志文件>   Flutter 运行日志文件路径（必需）
    [输出文件]   提取后的票据保存路径（可选，默认: receipt_data.txt）

示例:
    # 基本用法
    python3 extract_receipt.py flutter_log.txt

    # 指定输出文件
    python3 extract_receipt.py flutter_log.txt my_receipt.txt

    # 先运行应用保存日志，再提取
    flutter run 2>&1 | tee flutter_log.txt
    python3 extract_receipt.py flutter_log.txt

说明:
    此脚本会从日志文件中提取 RECEIPT_DATA_START 和 RECEIPT_DATA_END 
    之间的完整票据数据（Base64 编码），不包含任何额外字符。

选项:
    -h, --help    显示此帮助信息
"""
    print(help_text)


def extract_receipt(log_file, output_file='receipt_data.txt'):
    """从日志文件中提取票据数据"""
    
    print_info("开始提取票据数据...")
    print_info(f"日志文件: {log_file}")
    print_info(f"输出文件: {output_file}")
    print()
    
    # 读取日志文件
    try:
        with open(log_file, 'r', encoding='utf-8') as f:
            content = f.read()
    except FileNotFoundError:
        print_error(f"日志文件不存在: {log_file}")
        return False
    except Exception as e:
        print_error(f"读取日志文件失败: {e}")
        return False
    
    # 使用正则表达式提取票据数据
    pattern = r'RECEIPT_DATA_START\n(.*?)\nRECEIPT_DATA_END'
    matches = re.findall(pattern, content, re.DOTALL)
    
    if not matches:
        print_error("未找到票据数据")
        print_warning("请确保日志中包含 RECEIPT_DATA_START 和 RECEIPT_DATA_END 标记")
        return False
    
    # 获取第一个匹配的票据（通常只有一个）
    receipt_data = matches[0].strip()
    
    # 保存到文件
    try:
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(receipt_data)
    except Exception as e:
        print_error(f"保存文件失败: {e}")
        return False
    
    # 获取文件信息
    file_size = len(receipt_data)
    preview = receipt_data[:50] if len(receipt_data) > 50 else receipt_data
    
    print()
    print_success("票据数据提取成功！")
    print()
    print("━" * 60)
    print("📋 文件信息:")
    print(f"   输出文件: {output_file}")
    print(f"   数据长度: {file_size} 字节")
    print(f"   数据预览: {preview}...")
    print("━" * 60)
    print()
    
    # 验证 Base64 格式
    if re.match(r'^[A-Za-z0-9+/=\n]+$', receipt_data):
        print_success("✓ Base64 格式验证通过")
    else:
        print_warning("⚠️  数据格式可能不是标准 Base64")
    
    print()
    print("📤 下一步操作:")
    print(f"   1. 查看数据: cat {output_file}")
    if sys.platform == 'darwin':
        print(f"   2. 复制数据: cat {output_file} | pbcopy")
    else:
        print(f"   2. 复制数据: cat {output_file} | xclip -selection clipboard")
    print("   3. 发送给后端测试")
    print()
    
    return True


def main():
    """主函数"""
    # 检查参数
    if len(sys.argv) < 2 or sys.argv[1] in ['-h', '--help']:
        show_help()
        sys.exit(0 if len(sys.argv) > 1 else 1)
    
    # 获取参数
    log_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else 'receipt_data.txt'
    
    # 提取票据
    success = extract_receipt(log_file, output_file)
    
    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
