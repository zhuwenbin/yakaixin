/// 登录接口Mock数据
/// 用于开发和测试时参考真实返回数据结构
/// 
/// 数据来源: /c/student/smslogin 验证码登录接口
/// 采集时间: 2024-01
class LoginMockData {
  /// 验证码登录成功响应 - 真实数据示例1
  static const Map<String, dynamic> smsLoginSuccess1 = {
    "msg": ["操作成功"],
    "code": 100000,
    "data": {
      "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NjY0MzA4MzYsImlhdCI6MTc2MzgzODgzNiwiaWQiOiI1OTQyNDQ2Mjk2MTY5MjU0MjQiLCJpc3MiOiJqaW5neWluZ2ppZS5jb20iLCJqdGkiOiI1OTQ0MzIyNTg1ODUxMzk5NTIiLCJuYmYiOjE3NjM4Mzg4MzZ9.3kp3vLWiBOD0XHb919oaDx-VhKCd_T57AE1sjnChxXo",
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
      "major_id": 524033912737962623,  // 注意: int类型
      "major_name": "口腔执业医师",
      "employee_id": 0,  // 注意: int类型, 0表示无员工身份
      "is_real_name": 2,
      "promoter_id": "594244629616925424",
      "promoter_type": 2,
      "post_type_level": null,
      "employee_info": {
        "employee_id": 0,  // 注意: int类型
        "post_name": "",
        "org_name": ""
      },
      "is_new": 0
    }
  };

  /// 验证码登录成功响应 - 真实数据示例2 (首次注册用户)
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
      "major_id": 0,  // 注意: 0表示未选择专业
      "major_name": "",
      "employee_id": 0,
      "is_real_name": 2,
      "promoter_id": "594245437976746736",
      "promoter_type": 2,
      "post_type_level": null,
      "employee_info": {
        "employee_id": 0,
        "post_name": "",
        "org_name": ""
      },
      "is_new": 0
    }
  };

  /// 字段说明和类型对照表
  static const Map<String, String> fieldTypeMapping = {
    // 顶层响应
    "code": "int - 100000表示成功, 0也表示成功",
    "msg": "List<String> - 消息数组",
    "data": "Map<String, dynamic> - 业务数据",
    
    // 用户基本信息
    "token": "String - JWT token",
    "student_id": "String - 学生ID",
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
    "major_id": "int - 专业ID, 0表示未选择",
    "major_name": "String - 专业名称",
    
    // 员工信息
    "employee_id": "int - 员工ID, 0表示非员工",
    "employee_info": "Map - 员工详细信息",
    "post_name": "String - 职位名称",
    "org_name": "String - 组织名称",
    
    // 其他信息
    "is_real_name": "int - 实名状态",
    "promoter_id": "String - 推广员ID",
    "promoter_type": "int - 推广员类型",
    "post_type_level": "dynamic - 职位级别(可能为null)",
    "is_new": "int - 是否新用户, 0=否, 1=是",
  };

  /// 关键类型注意事项
  static const List<String> typeNotes = [
    "⚠️ major_id 是 int 类型,不是 String!",
    "⚠️ employee_id 是 int 类型,不是 String!",
    "⚠️ employee_info.employee_id 也是 int 类型!",
    "⚠️ 值为 0 不等于 null,需要判断 != 0",
    "⚠️ 空字符串 '' 不等于 null,需要判断 isEmpty",
    "✅ code == 100000 或 code == 0 都表示成功",
    "✅ msg 可能是字符串数组,需要用 join 拼接",
  ];
}
