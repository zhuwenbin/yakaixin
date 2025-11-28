/// 安全类型转换工具类
/// 
/// 用于将 dynamic 类型安全地转换为具体类型，避免类型转换错误导致崩溃
/// 
/// 使用场景：
/// 1. Model 中使用 dynamic 接收后端数据
/// 2. 在 Provider/ViewModel 层使用本工具类转换为具体类型
/// 3. 在 UI 层安全显示数据
/// 
/// 示例：
/// ```dart
/// // Model
/// @JsonKey(name: 'employee_id') dynamic employeeId,
/// 
/// // Provider
/// final employeeIdInt = SafeTypeConverter.toInt(user.employeeId);
/// final employeeIdStr = SafeTypeConverter.toSafeString(user.employeeId);
/// 
/// // UI
/// Text('员工ID: ${SafeTypeConverter.toSafeString(user.employeeId, defaultValue: '无')}')
/// ```
class SafeTypeConverter {
  /// 安全转换为 int
  /// 
  /// 支持类型：
  /// - int → 直接返回
  /// - double → 转换为 int
  /// - String → 尝试解析，失败返回默认值
  /// - null → 返回默认值
  /// 
  /// 示例：
  /// ```dart
  /// SafeTypeConverter.toInt("123")       // → 123
  /// SafeTypeConverter.toInt("0")         // → 0
  /// SafeTypeConverter.toInt(123.5)       // → 123
  /// SafeTypeConverter.toInt(null)        // → 0
  /// SafeTypeConverter.toInt("abc")       // → 0
  /// SafeTypeConverter.toInt("abc", defaultValue: -1) // → -1
  /// ```
  static int toInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }

  /// 安全转换为 double
  /// 
  /// 支持类型：
  /// - double → 直接返回
  /// - int → 转换为 double
  /// - String → 尝试解析，失败返回默认值
  /// - null → 返回默认值
  /// 
  /// 示例：
  /// ```dart
  /// SafeTypeConverter.toDouble("123.45") // → 123.45
  /// SafeTypeConverter.toDouble("0")      // → 0.0
  /// SafeTypeConverter.toDouble(123)      // → 123.0
  /// SafeTypeConverter.toDouble(null)     // → 0.0
  /// SafeTypeConverter.toDouble("abc")    // → 0.0
  /// ```
  static double toDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }

  /// 安全转换为 String
  /// 
  /// 支持类型：
  /// - String → 直接返回
  /// - 其他类型 → 调用 toString()
  /// - null → 返回默认值
  /// 
  /// 示例：
  /// ```dart
  /// SafeTypeConverter.toSafeString("hello")     // → "hello"
  /// SafeTypeConverter.toSafeString(123)         // → "123"
  /// SafeTypeConverter.toSafeString(null)        // → ""
  /// SafeTypeConverter.toSafeString(null, defaultValue: "N/A") // → "N/A"
  /// ```
  static String toSafeString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    if (value is String) return value;
    return value.toString();
  }

  /// 安全转换为 bool
  /// 
  /// 支持类型：
  /// - bool → 直接返回
  /// - int → 0=false, 非0=true
  /// - String → "true"/"1"=true, "false"/"0"=false, 其他返回默认值
  /// - null → 返回默认值
  /// 
  /// 示例：
  /// ```dart
  /// SafeTypeConverter.toBool(true)       // → true
  /// SafeTypeConverter.toBool(1)          // → true
  /// SafeTypeConverter.toBool(0)          // → false
  /// SafeTypeConverter.toBool("true")     // → true
  /// SafeTypeConverter.toBool("1")        // → true
  /// SafeTypeConverter.toBool("false")    // → false
  /// SafeTypeConverter.toBool("0")        // → false
  /// SafeTypeConverter.toBool(null)       // → false
  /// SafeTypeConverter.toBool("abc")      // → false
  /// ```
  static bool toBool(dynamic value, {bool defaultValue = false}) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      final lower = value.toLowerCase();
      if (lower == 'true' || lower == '1') return true;
      if (lower == 'false' || lower == '0') return false;
    }
    return defaultValue;
  }

  /// 检查值是否为空
  /// 
  /// 判断规则：
  /// - null → true
  /// - String "0" → true （特殊处理，因为后端常用 "0" 表示无效值）
  /// - String "" → true
  /// - int 0 → true
  /// - 其他 → false
  /// 
  /// 示例：
  /// ```dart
  /// SafeTypeConverter.isEmpty(null)      // → true
  /// SafeTypeConverter.isEmpty("")        // → true
  /// SafeTypeConverter.isEmpty("0")       // → true
  /// SafeTypeConverter.isEmpty(0)         // → true
  /// SafeTypeConverter.isEmpty("123")     // → false
  /// SafeTypeConverter.isEmpty(123)       // → false
  /// ```
  static bool isEmpty(dynamic value) {
    if (value == null) return true;
    if (value is String) return value.isEmpty || value == '0';
    if (value is int) return value == 0;
    return false;
  }

  /// 检查值是否不为空（isEmpty 的反向）
  /// 
  /// 示例：
  /// ```dart
  /// SafeTypeConverter.isNotEmpty(null)   // → false
  /// SafeTypeConverter.isNotEmpty("0")    // → false
  /// SafeTypeConverter.isNotEmpty("")     // → false
  /// SafeTypeConverter.isNotEmpty("123")  // → true
  /// SafeTypeConverter.isNotEmpty(123)    // → true
  /// ```
  static bool isNotEmpty(dynamic value) => !isEmpty(value);

  /// 检查值是否为有效的员工ID
  /// 
  /// 判断规则：
  /// - 值不为空（not null, not "", not "0", not 0）
  /// - 值为正整数
  /// 
  /// 示例：
  /// ```dart
  /// SafeTypeConverter.isValidEmployeeId("123")  // → true
  /// SafeTypeConverter.isValidEmployeeId(123)    // → true
  /// SafeTypeConverter.isValidEmployeeId("0")    // → false
  /// SafeTypeConverter.isValidEmployeeId(0)      // → false
  /// SafeTypeConverter.isValidEmployeeId(null)   // → false
  /// SafeTypeConverter.isValidEmployeeId("")     // → false
  /// ```
  static bool isValidEmployeeId(dynamic value) {
    if (isEmpty(value)) return false;
    final intValue = toInt(value, defaultValue: 0);
    return intValue > 0;
  }

  /// 检查值是否为有效的ID（major_id, student_id 等）
  /// 
  /// 判断规则：
  /// - 值不为空（not null, not "", not "0", not 0）
  /// - 值为正数或有效字符串
  /// 
  /// 示例：
  /// ```dart
  /// SafeTypeConverter.isValidId("524033912737962623")  // → true
  /// SafeTypeConverter.isValidId("123")                 // → true
  /// SafeTypeConverter.isValidId(123)                   // → true
  /// SafeTypeConverter.isValidId("0")                   // → false
  /// SafeTypeConverter.isValidId(0)                     // → false
  /// SafeTypeConverter.isValidId(null)                  // → false
  /// SafeTypeConverter.isValidId("")                    // → false
  /// ```
  static bool isValidId(dynamic value) {
    return isNotEmpty(value);
  }

  /// 安全转换为 List<String>
  /// 
  /// 支持类型：
  /// - List<String> → 直接返回
  /// - List<dynamic> → 转换每个元素为 String
  /// - null → 返回空列表
  /// - 其他 → 返回空列表
  /// 
  /// 示例：
  /// ```dart
  /// SafeTypeConverter.toStringList(["a", "b"])        // → ["a", "b"]
  /// SafeTypeConverter.toStringList([1, 2, 3])         // → ["1", "2", "3"]
  /// SafeTypeConverter.toStringList(null)              // → []
  /// SafeTypeConverter.toStringList("not a list")      // → []
  /// ```
  static List<String> toStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => toSafeString(e)).toList();
    }
    return [];
  }

  /// 安全转换为 List<int>
  /// 
  /// 支持类型：
  /// - List<int> → 直接返回
  /// - List<dynamic> → 转换每个元素为 int（失败则跳过）
  /// - null → 返回空列表
  /// - 其他 → 返回空列表
  /// 
  /// 示例：
  /// ```dart
  /// SafeTypeConverter.toIntList([1, 2, 3])           // → [1, 2, 3]
  /// SafeTypeConverter.toIntList(["1", "2", "3"])     // → [1, 2, 3]
  /// SafeTypeConverter.toIntList(["1", "abc", "3"])   // → [1, 3]
  /// SafeTypeConverter.toIntList(null)                // → []
  /// ```
  static List<int> toIntList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value
          .map((e) {
            final intValue = toInt(e, defaultValue: -1);
            return intValue >= 0 ? intValue : null;
          })
          .whereType<int>()
          .toList();
    }
    return [];
  }
}
