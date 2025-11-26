/// F1. 用户认证模块 Mock数据
class AuthMockData {
  /// P1-1 登录Mock数据
  static final Map<String, dynamic> login = {
    'code': 100000,
    'msg': ['登录成功'],
    'data': {
      'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.mock_token',
      'student_id': '555343665594113147',
      'nickname': '牙开心8000',
      'avatar': 'https://thirdwx.qlogo.cn/mmopen/vi_32/mock.png',
      'mobile': '13800138000',
      'account': '13800138000',
      'merchant': [
        {
          'merchant_id': '436047240159563069',
          'brand_id': '508925829265162766',
        }
      ],
      'employee': {
        'id': '508948528815416786',
        'name': '业务员张三',
      }
    }
  };
  
  /// 发送验证码Mock数据
  static final Map<String, dynamic> sendCode = {
    'code': 100000,
    'msg': ['发送成功'],
    'data': {
      'code': '123456',  // 测试用验证码
      'expire_time': 300, // 过期时间(秒)
    }
  };
  
  /// P1-2 H5登录Mock数据
  static final Map<String, dynamic> h5Login = {
    'code': 100000,
    'msg': ['登录成功'],
    'data': {
      'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.h5_mock_token',
      'student_id': '555343665594113148',
      'nickname': '牊开心8001',
      'avatar': 'https://thirdwx.qlogo.cn/mmopen/vi_32/h5_mock.png',
      'mobile': '13800138001',
      'account': '13800138001',
    }
  };
  
  /// P1-3 专业列表Mock数据
  static final Map<String, dynamic> majorList = {
    'code': 100000,
    'msg': ['success'],
    'data': [
      {
        'id': '524033912737962623',
        'name': '医学-口腔执业医师',
        'children': []
      },
      {
        'id': '524033912737962624',
        'name': '医学-临床执业医师',
        'children': []
      },
      {
        'id': '524033912737962625',
        'name': '医学-中医执业医师',
        'children': []
      },
      {
        'id': '524033912737962626',
        'name': '护理学-护士资格',
        'children': []
      },
      {
        'id': '524033912737962627',
        'name': '药学-执业药师',
        'children': []
      },
    ]
  };
  
  /// 选择专业响应
  static final Map<String, dynamic> selectMajorResponse = {
    'code': 100000,
    'msg': ['success'],
  };
  
  /// P1-3 获取专业列表
  static final Map<String, dynamic> getMajor = {
    'code': 100000,
    'msg': ['成功'],
    'data': [
      {
        'id': '1',
        'data_name': '医学',
        'subs': [
          {
            'id': '524033912737962623',
            'data_name': '口腔执业医师',
          },
          {
            'id': '524033912737962624',
            'data_name': '临床执业医师',
          },
          {
            'id': '524033912737962625',
            'data_name': '中医执业医师',
          },
        ],
      },
      {
        'id': '2',
        'data_name': '药学',
        'subs': [
          {
            'id': '524033912737962626',
            'data_name': '执业药师',
          },
          {
            'id': '524033912737962627',
            'data_name': '中药师',
          },
        ],
      },
      {
        'id': '3',
        'data_name': '护理',
        'subs': [
          {
            'id': '524033912737962628',
            'data_name': '护士资格证',
          },
          {
            'id': '524033912737962629',
            'data_name': '主管护师',
          },
        ],
      },
    ],
  };

  /// 保存专业响应
  static final Map<String, dynamic> saveMajor = {
    'code': 100000,
    'msg': ['保存成功'],
    'data': null,
  };
}
