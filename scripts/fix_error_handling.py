#!/usr/bin/env python3
"""
批量修复 Provider 文件中的错误处理
将 e.toString() 替换为用户友好的错误提示
"""
import re
import sys

def fix_error_handling(file_path):
    """修复单个文件的错误处理"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        
        # 1. 添加必要的 import（如果不存在）
        if "import 'package:dio/dio.dart';" not in content:
            # 在第一个 import 之前添加
            content = re.sub(
                r"(import 'package:.*?';)",
                r"import 'package:dio/dio.dart';\n\1",
                content,
                count=1
            )
        
        if "import 'package:yakaixin_app/core/utils/error_message_mapper.dart';" not in content:
            # 在其他 import 之后添加
            imports_end = content.rfind("import '")
            next_newline = content.find('\n', imports_end)
            if next_newline != -1:
                content = content[:next_newline+1] + "import 'package:yakaixin_app/core/utils/error_message_mapper.dart';\n" + content[next_newline+1:]
        
        # 2. 替换错误处理模式
        # 模式: } catch (e) { ... error: e.toString() ... }
        
        # 查找所有的 catch (e) 块
        pattern = r'(\s+)\} catch \(e\) \{\s*\n(.*?)error:\s*e\.toString\(\)(.*?\n.*?)\}'
        
        def replacement(match):
            indent = match.group(1)
            before_error = match.group(2)
            after_error = match.group(3)
            
            # 判断错误消息
            error_msg = '加载失败，请稍后重试'
            if 'isLoading' in before_error:
                if 'Creating' in file_path or 'create' in before_error.lower():
                    error_msg = '创建失败，请稍后重试'
                elif 'edit' in file_path.lower() or 'update' in before_error.lower():
                    error_msg = '修改失败，请稍后重试'
                elif 'delete' in before_error.lower() or 'remove' in before_error.lower():
                    error_msg = '删除失败，请稍后重试'
            
            new_catch_block = f'''{indent}}} on DioException catch (e) {{
{indent}  // ✅ 使用拦截器已处理好的用户友好错误信息
{indent}  final errorMsg = e.error?.toString() ?? '{error_msg}';
{before_error}error: errorMsg{after_error}}}
{indent}}} catch (e) {{
{indent}  // ✅ 兜底：未预期的错误
{before_error}error: '{error_msg}'{after_error}}}'''
            
            return new_catch_block
        
        content = re.sub(pattern, replacement, content, flags=re.MULTILINE | re.DOTALL)
        
        # 如果内容有变化，写回文件
        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"✅ 已修复: {file_path}")
            return True
        else:
            print(f"⚠️  未发现需要修改的内容: {file_path}")
            return False
            
    except Exception as e:
        print(f"❌ 处理失败 {file_path}: {e}")
        return False

if __name__ == '__main__':
    files = [
        'lib/features/goods/providers/secret_real_detail_provider.dart',
        'lib/features/goods/providers/simulated_exam_room_provider.dart',
        'lib/features/goods/providers/subject_mock_detail_provider.dart',
        'lib/features/profile/providers/person_edit_provider.dart',
        'lib/features/profile/providers/report_provider.dart',
    ]
    
    success_count = 0
    for file_path in files:
        if fix_error_handling(file_path):
            success_count += 1
    
    print(f"\n完成！成功修复 {success_count}/{len(files)} 个文件")
