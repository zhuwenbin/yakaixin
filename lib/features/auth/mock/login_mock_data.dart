  /// 登录接口Mock数据
/// 用于开发和测试时参考真实返回数据结构
/// 
/// 数据来源: /c/student/smslogin 验证码登录接口
/// 更新时间: 2025-01-27 (来自真实API响应)
/// 对应小程序: src/modules/jintiku/api/index.js - smslogin
class LoginMockData {
  /// 验证码登录成功响应 - 真实数据示例1（来自真实API）
  /// 
  /// ⚠️ 关键字段类型说明:
  /// - major_id: String类型（大数值，如"524033912737962623"）
  /// - employee_id: String类型（"0"表示无员工身份）
  /// - is_real_name: String类型（"2"表示已实名认证）
  /// - promoter_type: String类型（"2"表示推广员类型）
  /// - is_new: String类型（"0"表示非新用户）
  /// - employee_info.employee_id: String类型（"0"表示无员工身份）
  /// 
  /// 数据来源: 2025-01-27 真实API响应
  /// 手机号: 13521956613
  static const Map<String, dynamic> smsLoginSuccess1 = {
    "msg": ["操作成功"],
    "code": 100000,
    "data": {
      "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NjY4OTQzOTUsImlhdCI6MTc2NDMwMjM5NSwiaWQiOiI1OTQyNDQ2Mjk2MTY5MjU0MjQiLCJpc3MiOiJqaW5neWluZ2ppZS5jb20iLCJqdGkiOiI1OTUyMDk5ODI4MDczODI4NTUiLCJuYmYiOjE3NjQzMDIzOTV9.ueZYdbNj1tGg_tyWBBylVStybuVqY7_B5leHwWujjQ4",
      "nickname": "牙开心6613",
      "avatar": "",
      "phone": "13521956613",
      "student_id": "594244629616925424",
      "student_name": "未填写",
      "merchant": [
        {
          "merchant_id": "408559575579495187",
          "merchant_name": "牙开心",
          "brand_id": "408559632588540691",
          "brand_name": "牙开心"
        }
      ],
      "major_id": "524033912737962623",  // ⚠️ String类型（大数值）
      "major_name": "口腔执业医师",
      "employee_id": "0",  // ⚠️ String类型
      "is_real_name": "2",  // ⚠️ String类型
      "promoter_id": "594244629616925424",
      "promoter_type": "2",  // ⚠️ String类型
      "post_type_level": null,
      "employee_info": {
        "employee_id": "0",  // ⚠️ String类型
        "post_name": "",
        "org_name": ""
      },
      "is_new": "0"  // ⚠️ String类型
    }
  };

  /// 验证码登录成功响应 - 真实数据示例2（首次注册用户，保留以对比不同状态）
  /// 
  /// ⚠️ 注意: 这个示例的字段类型与真实API不一致！
  /// 真实API返回的 is_real_name、promoter_type、is_new 等字段是 String 类型
  /// 这个示例仅用于测试 Model 的兼容性
  /// 
  /// 推荐使用 smsLoginSuccess1 作为标准Mock数据
  static const Map<String, dynamic> smsLoginSuccess2 = {
    "msg": ["操作成功"],
    "code": 100000,
    "data": {
      "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NjY0Mjk3MTMsImlhdCI6MTc2MzgzNzcxMywiaWQiOiI1OTQyNDU0Mzc5NzY3NDY3MzYiLCJpc3MiOiJqaW5neWluZ2ppZS5jb20iLCJqdGkiOiI1OTQ0MzAzNzQ3MDUxMDk3NDQiLCJuYmYiOjE3NjM4Mzc3MTN9.OjevbkiqpjbP4vCLevunKcKSZSN8OC5fLgyK0AKZ37g",
      "nickname": "",
      "avatar": "",
      "phone": "15937813015",
      "student_id": "594245437976746736",
      "student_name": "未填写",
      "merchant": [
        {
          "merchant_id": "408559575579495187",
          "merchant_name": "牙开心",
          "brand_id": "408559632588540691",
          "brand_name": "牙开心"
        }
      ],
      "major_id": "0",  // ⚠️ 改为String类型，"0"表示未选择专业
      "major_name": "",
      "employee_id": "0",  // ⚠️ 改为String类型
      "is_real_name": "2",  // ⚠️ 改为String类型
      "promoter_id": "594245437976746736",
      "promoter_type": "2",  // ⚠️ 改为String类型
      "post_type_level": null,
      "employee_info": {
        "employee_id": "0",  // ⚠️ 改为String类型
        "post_name": "",
        "org_name": ""
      },
      "is_new": "0"  // ⚠️ 改为String类型
    }
  };

  /// ✅ 字段说明和类型对照表（基于真实API响应）
  /// 更新时间: 2025-01-27
  static const Map<String, String> fieldTypeMapping = {
    // 顶层响应
    "code": "int - 100000表示成功, 0也表示成功",
    "msg": "List<String> - 消息数组",
    "data": "Map<String, dynamic> - 业务数据",
    
    // 用户基本信息
    "token": "String - JWT token",
    "student_id": "String - 学生ID（大数值）",
    "student_name": "String - 学生姓名",
    "nickname": "String - 昵称(可能为空字符串)",
    "avatar": "String - 头像URL(可能为空字符串)",
    "phone": "String - 手机号",
    
    // 商户信息
    "merchant": "List<Map> - 商户列表",
    "merchant_id": "String - 商户ID",
    "merchant_name": "String - 商户名称",
    "brand_id": "String - 品牌ID",
    "brand_name": "String - 品牌名称",
    
    // 专业信息
    "major_id": "⚠️ String - 专业ID（大数值，如'524033912737962623'），'0'表示未选择",
    "major_name": "String - 专业名称",
    
    // 员工信息
    "employee_id": "⚠️ String - 员工ID，'0'表示非员工",
    "employee_info": "Map - 员工详细信息",
    "post_name": "String - 职位名称",
    "org_name": "String - 组织名称",
    
    // 其他信息
    "is_real_name": "⚠️ String - 实名状态，'2'表示已实名",
    "promoter_id": "String - 推广员ID",
    "promoter_type": "⚠️ String - 推广员类型，'2'表示某种类型",
    "post_type_level": "dynamic - 职位级别(可能为null)",
    "is_new": "⚠️ String - 是否新用户，'0'=否，'1'=是",
  };

  /// ⚠️ 关键类型注意事项（基于真实API响应）
  /// 更新时间: 2025-01-27
  static const List<String> typeNotes = [
    "⚠️ major_id 是 String 类型！可能是超大整数如 '524033912737962623'",
    "⚠️ employee_id 是 String 类型！'0' 表示无员工身份",
    "⚠️ is_real_name 是 String 类型！'2' 表示已实名认证",
    "⚠️ promoter_type 是 String 类型！'2' 表示推广员类型",
    "⚠️ is_new 是 String 类型！'0' 表示非新用户",
    "⚠️ employee_info.employee_id 也是 String 类型！",
    "⚠️ 值 '0' 不等于 null 和空字符串，需要判断 == '0'",
    "⚠️ 空字符串 '' 不等于 null，需要判断 isEmpty",
    "✅ code == 100000 或 code == 0 都表示成功",
    "✅ msg 可能是字符串数组，需要用 join 拼接",
    "✅ Model 字段使用 dynamic 类型来兼容 String 和 int",
  ];
}
