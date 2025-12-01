# ✅ 网络调试框架 - cURL 命令功能完成

## 🎉 新增功能

### cURL 命令展示与复制

在网络请求详情中添加了 cURL 命令区块，方便与后端调试。

---

## 📸 功能预览

```
┌─────────────────────────────────────────┐
│  🔧 cURL 命令              [复制]       │
├─────────────────────────────────────────┤
│ curl -X POST "https://api.xxx.com..." \│
│   -H "Content-Type: application/json" \│
│   -H "Authorization: Bearer xxx" \     │
│   -d "{\"key\":\"value\"}"             │
└─────────────────────────────────────────┘
```

---

## 🔧 功能详情

### 1. 生成 cURL 命令

**方法**: `_generateCurlCommand(NetworkLogModel log)`

**生成逻辑**：

```dart
String _generateCurlCommand(NetworkLogModel log) {
  final buffer = StringBuffer();
  
  // 1. 请求方法
  buffer.write('curl -X ${log.method}');
  
  // 2. URL (包含查询参数)
  String url = log.url;
  if (log.queryParameters != null && log.queryParameters!.isNotEmpty) {
    final uri = Uri.parse(log.url);
    final newUri = uri.replace(queryParameters: log.queryParameters!.map(
      (key, value) => MapEntry(key, value.toString()),
    ));
    url = newUri.toString();
  }
  buffer.write(' "$url"');
  
  // 3. 请求头
  if (log.headers != null && log.headers!.isNotEmpty) {
    log.headers!.forEach((key, value) {
      // 跳过自动添加的头
      if (key.toLowerCase() != 'content-length' && 
          key.toLowerCase() != 'host') {
        buffer.write(' \\\n  -H "$key: $value"');
      }
    });
  }
  
  // 4. 请求体
  if (log.requestData != null) {
    String data = jsonEncode(log.requestData);
    // 转义特殊字符
    data = data.replaceAll('"', '\\"').replaceAll('\$', '\\\$');
    buffer.write(' \\\n  -d "$data"');
  }
  
  return buffer.toString();
}
```

---

### 2. cURL 区块展示

**方法**: `_buildCurlSection(NetworkLogModel log)`

**特点**：
- ✅ 橙色主题，与其他区块区分
- ✅ 代码图标标识
- ✅ 复制按钮（右上角）
- ✅ 支持文本选择
- ✅ 等宽字体显示
- ✅ 边框高亮
- ✅ 黑色半透明背景

**UI组件**：
```dart
Widget _buildCurlSection(NetworkLogModel log) {
  return Column(
    children: [
      // 标题行
      Row(
        children: [
          Icon(Icons.code, color: Colors.orange.shade300),
          Text('cURL 命令', color: Colors.orange.shade300),
          Spacer(),
          // 复制按钮
          TextButton.icon(
            onPressed: () => _copyCurl(curlCommand),
            icon: Icon(Icons.copy),
            label: Text('复制'),
          ),
        ],
      ),
      // 命令显示区
      Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          border: Border.all(color: Colors.orange.shade300),
        ),
        child: SelectableText(
          curlCommand,
          style: TextStyle(
            fontFamily: 'monospace',
            color: Colors.orange.shade100,
          ),
        ),
      ),
    ],
  );
}
```

---

### 3. 复制功能

**触发**: 点击"复制"按钮

**实现**:
```dart
Clipboard.setData(ClipboardData(text: curlCommand));
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('✅ cURL 命令已复制到剪贴板'),
    duration: Duration(seconds: 2),
    backgroundColor: Colors.green.shade700,
  ),
);
```

**用户体验**：
- ✅ 一键复制
- ✅ 成功提示（绿色SnackBar）
- ✅ 2秒后自动消失

---

## 📋 生成的 cURL 命令示例

### GET 请求

```bash
curl -X GET "https://api.example.com/c/exam/learningData?professional_id=123" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

### POST 请求

```bash
curl -X POST "https://api.example.com/c/exam/checkinData" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -d "{\"professional_id\":\"524033912737962623\"}"
```

### 复杂请求

```bash
curl -X POST "https://api.example.com/c/goods/v2?type=10,8&is_buyed=1" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "X-Platform: ios" \
  -H "X-Version: 1.0.0" \
  -d "{\"professional_id\":\"123\",\"page\":1,\"page_size\":20}"
```

---

## 🎯 使用场景

### 1. 与后端调试

```bash
# 1. 在 App 中触发请求
# 2. 打开网络调试框架
# 3. 点击请求查看详情
# 4. 点击复制 cURL 命令
# 5. 发送给后端开发人员

后端开发人员可以直接在终端执行：
$ curl -X POST "https://api.example.com/..." \
    -H "..." \
    -d "..."
```

### 2. 问题复现

```bash
# 用户报告 API 错误
# 1. 复制 cURL 命令
# 2. 在不同环境执行测试
# 3. 对比结果
```

### 3. API 文档

```bash
# 可以作为 API 使用示例
# 1. 复制 cURL 命令
# 2. 添加到文档或 README
# 3. 团队成员可以直接使用
```

---

## 🔧 技术实现

### 导入的新依赖

```dart
import 'package:flutter/services.dart';  // ✅ 用于 Clipboard
```

### 修改的文件

| 文件 | 说明 |
|------|------|
| `network_debug_overlay.dart` | 添加 cURL 生成和显示功能 |

### 新增的方法

| 方法 | 功能 |
|------|------|
| `_generateCurlCommand()` | 生成 cURL 命令字符串 |
| `_buildCurlSection()` | 构建 cURL 命令展示区块 |

---

## ✅ 功能特点

### 1. 完整性
- ✅ 包含请求方法 (GET/POST/PUT/DELETE)
- ✅ 包含完整 URL (含查询参数)
- ✅ 包含所有请求头
- ✅ 包含请求体 (JSON 格式)
- ✅ 自动转义特殊字符

### 2. 易用性
- ✅ 一键复制
- ✅ 可选择文本
- ✅ 等宽字体显示
- ✅ 换行格式化
- ✅ 成功反馈提示

### 3. 兼容性
- ✅ 支持所有 HTTP 方法
- ✅ 支持查询参数
- ✅ 支持 JSON 请求体
- ✅ 支持多种 Content-Type
- ✅ 自动过滤不必要的头

### 4. 可读性
- ✅ 橙色主题区分
- ✅ 代码图标标识
- ✅ 每行缩进对齐
- ✅ 使用 `\` 换行
- ✅ 关键部分高亮

---

## 📊 位置

### 在请求详情中的顺序

```
请求详情
├── 📋 cURL 命令          ← ✅ 新增（第一位）
├── 📌 基本信息
├── 📝 请求头
├── 🔍 查询参数
├── 📤 请求体
├── 📥 响应体
└── ❌ 错误信息
```

**优先级**: 最高（第一个显示）

**原因**: 
- 最常用的功能
- 与后端调试最相关
- 需要快速访问和复制

---

## 🧪 测试建议

### 1. 基本测试

```bash
# 1. 发起一个 GET 请求
# 2. 查看请求详情
# 3. 验证 cURL 命令格式正确
# 4. 点击复制按钮
# 5. 验证复制成功提示
# 6. 粘贴到终端测试
```

### 2. 复杂场景

```bash
# 1. 测试 POST 请求 + JSON 数据
# 2. 测试带查询参数的请求
# 3. 测试带多个请求头的请求
# 4. 测试特殊字符转义
# 5. 测试长 URL
```

### 3. 边界情况

```bash
# 1. 测试无请求头
# 2. 测试无请求体
# 3. 测试空查询参数
# 4. 测试 Mock 请求
# 5. 测试失败的请求
```

---

## ⚠️ 注意事项

### 1. 安全性

**敏感信息**：
- ⚠️ cURL 命令可能包含 Token
- ⚠️ cURL 命令可能包含用户数据
- ⚠️ 不要将 cURL 命令分享到公开渠道

**建议**：
- 在分享前删除敏感头信息
- 替换真实 Token 为 `xxx`
- 脱敏用户数据

### 2. 格式化

**换行符**：
- 使用 `\` 实现命令换行
- 每行缩进 2 空格
- 兼容 bash/zsh/terminal

**特殊字符**：
- 自动转义 `"` → `\"`
- 自动转义 `$` → `\$`
- URL 自动编码

### 3. 跨平台

**支持**：
- ✅ macOS Terminal
- ✅ Linux bash/zsh
- ✅ Windows Git Bash
- ✅ Windows WSL
- ⚠️ Windows CMD (需要修改引号)

---

## 🎊 完成状态

| 项目 | 状态 |
|------|------|
| cURL 生成逻辑 | ✅ 完成 |
| UI 展示区块 | ✅ 完成 |
| 复制功能 | ✅ 完成 |
| 成功提示 | ✅ 完成 |
| 样式美化 | ✅ 完成 |
| 编译通过 | ✅ 完成 |

---

**完成时间**: 2025-11-30  
**功能状态**: 🟢 已实现，可立即使用  
**测试状态**: ⚠️ 待真机测试验证

