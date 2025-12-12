#!/usr/bin/env dart
/// 批量替换旧OSS URL为统一配置
/// 
/// 使用方法:
/// dart scripts/migrate_oss_urls.dart

import 'dart:io';

void main() {
  print('🔄 开始迁移OSS URL...\n');
  
  final oldOssUrl = 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/';
  final files = _findDartFiles();
  
  int totalFiles = 0;
  int totalReplacements = 0;
  
  for (final file in files) {
    final content = file.readAsStringSync();
    
    if (!content.contains(oldOssUrl)) {
      continue;
    }
    
    int replacements = 0;
    String newContent = content;
    
    // 规则1: 替换完整URL为ApiConfig.completeImageUrl()
    final regex1 = RegExp(r"'https://xy-shunshun-pro\.oss-cn-hangzhou\.aliyuncs\.com/([^']+)'");
    newContent = newContent.replaceAllMapped(regex1, (match) {
      replacements++;
      final path = match.group(1)!;
      return "ApiConfig.completeImageUrl('$path')";
    });
    
    // 规则2: 替换URL字符串拼接
    final regex2 = RegExp(r'"https://xy-shunshun-pro\.oss-cn-hangzhou\.aliyuncs\.com/\$([^"]+)"');
    newContent = newContent.replaceAllMapped(regex2, (match) {
      replacements++;
      final variable = match.group(1)!;
      return 'ApiConfig.completeImageUrl(\$$variable)';
    });
    
    if (replacements > 0) {
      // 添加import
      if (!newContent.contains("import '../../../app/config/api_config.dart';") &&
          !newContent.contains("import '../../app/config/api_config.dart';") &&
          !newContent.contains("import '../app/config/api_config.dart';")) {
        
        // 找到最后一个import的位置
        final importMatches = RegExp(r"import '[^']+';").allMatches(newContent);
        if (importMatches.isNotEmpty) {
          final lastImport = importMatches.last;
          final insertPos = lastImport.end;
          
          // 计算相对路径深度
          final relativePath = file.path.split('/lib/').last;
          final depth = relativePath.split('/').length - 1;
          final prefix = List.generate(depth, (_) => '..').join('/');
          
          newContent = newContent.substring(0, insertPos) +
              "\nimport '$prefix/app/config/api_config.dart';" +
              newContent.substring(insertPos);
        }
      }
      
      file.writeAsStringSync(newContent);
      print('✅ ${file.path}');
      print('   替换了 $replacements 处\n');
      
      totalFiles++;
      totalReplacements += replacements;
    }
  }
  
  print('');
  print('=' * 60);
  print('✅ 迁移完成！');
  print('   修改文件数: $totalFiles');
  print('   总替换次数: $totalReplacements');
  print('=' * 60);
}

List<File> _findDartFiles() {
  final libDir = Directory('lib');
  final files = <File>[];
  
  if (!libDir.existsSync()) {
    print('❌ lib目录不存在');
    exit(1);
  }
  
  for (final entity in libDir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      // 跳过生成的文件
      if (entity.path.endsWith('.g.dart') || 
          entity.path.endsWith('.freezed.dart')) {
        continue;
      }
      files.add(entity);
    }
  }
  
  return files;
}
