/// Mock数据服务
/// 
/// 为所有页面提供Mock数据支持
/// 
/// 使用方式:
/// ```dart
/// final mockData = MockDataService.getPageMockData('home');
/// ```

class MockDataService {
  /// 获取页面Mock数据
  static Map<String, dynamic> getPageMockData(String pageKey) {
    return _mockDataMap[pageKey] ?? {};
  }
  
  /// 所有页面的Mock数据映射
  static final Map<String, Map<String, dynamic>> _mockDataMap = {
    // F1. 用户认证模块
    'login': _loginMockData,
    'major': _majorMockData,
    
    // F2. 题库练习模块
    'home': _homeMockData,
    'chapter_list': _chapterListMockData,
    'goods_list': _goodsListMockData,
    
    // F3. 模拟考试模块
    'model_exam_list': _modelExamListMockData,
    
    // F4. 学习中心模块
    'study_calendar': _studyCalendarMockData,
    
    // F5. 商品订单模块
    'goods_detail': _goodsDetailMockData,
    'order_list': _orderListMockData,
    
    // F6. 我的中心模块
    'profile': _profileMockData,
  };
  
  // ========== F1. 用户认证模块 Mock数据 ==========
  
  /// 登录Mock数据
  static final Map<String, dynamic> _loginMockData = {
    'code': 100000,
    'msg': ['登录成功'],
    'data': {
      'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.mock_token_data',
      'student_id': '555343665594113147',
      'nickname': '牙开心测试用户',
      'avatar': 'https://thirdwx.qlogo.cn/mmopen/vi_32/mock_avatar.png',
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
  
  /// 专业列表Mock数据
  static final Map<String, dynamic> _majorMockData = {
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
    ]
  };
  
  // ========== F2. 题库练习模块 Mock数据 ==========
  
  /// 首页Mock数据
  static final Map<String, dynamic> _homeMockData = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      // 首页统计
      'statistic': {
        'study_days': 30,
        'question_count': 1250,
        'correct_count': 985,
        'accuracy': '78.8',
      },
      // 推荐章节
      'recommend_chapters': [
        {
          'id': '123',
          'name': '口腔解剖生理学',
          'question_num': 500,
          'do_question_num': '120',
          'correct_question_num': '95',
        },
        {
          'id': '124',
          'name': '口腔组织病理学',
          'question_num': 450,
          'do_question_num': '80',
          'correct_question_num': '65',
        },
      ],
      // 上次练习
      'last_progress': {
        'scene': 1,
        'practice_progress_text': '第一章 > 第一节',
        'chapter_id': '123',
        'goods_id': '555343665594113147',
      },
      // 打卡数据
      'checkin_data': {
        'continuous_days': 7,
        'total_days': 30,
        'today_checked': true,
      }
    }
  };
  
  /// 章节列表Mock数据
  static final Map<String, dynamic> _chapterListMockData = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'section_info': [
        {
          'id': '437657998052172130',
          'name': '第一章 口腔解剖生理学',
          'question_number': '500',
          'do_question_num': '120',
          'correct_question_num': '95',
          'parent_id': '0',
          'sort': 1,
          'child': [
            {
              'id': '437658088934351202',
              'name': '第一节 牙体解剖',
              'question_number': '100',
              'do_question_num': '25',
              'correct_question_num': '20',
              'parent_id': '437657998052172130',
              'sort': 1,
              'child': []
            },
            {
              'id': '437658088934351203',
              'name': '第二节 牙周组织',
              'question_number': '80',
              'do_question_num': '0',
              'correct_question_num': '0',
              'parent_id': '437657998052172130',
              'sort': 2,
              'child': []
            },
          ]
        },
        {
          'id': '437657998052172131',
          'name': '第二章 口腔组织病理学',
          'question_number': '450',
          'do_question_num': '0',
          'correct_question_num': '0',
          'parent_id': '0',
          'sort': 2,
          'child': []
        },
      ]
    }
  };
  
  /// 商品列表Mock数据
  static final Map<String, dynamic> _goodsListMockData = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'list': [
        {
          'id': '555343665594113147',
          'goods_name': '2024口腔执业医师题库',
          'name': '2024口腔执业医师题库',
          'price': '299.00',
          'original_price': '599.00',
          'cover_img': 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/cover.png',
          'type': '18', // 18=题库
          'permission_status': '2', // 2=未购买
          'is_homepage_recommend': 1,
          'validity_day': '180',
          'professional_id': '524033912737962623',
          'professional_id_name': '医学-口腔执业医师',
          'tiku_goods_details': {
            'question_num': '5000',
            'paper_num': '0',
            'exam_round_num': '0',
            'exam_time': ''
          },
          'teaching_system': {
            'system_id_name': '章节练习系统'
          },
          'prices': [
            {
              'goods_months_price_id': '555343665594178683',
              'month': '6',
              'days': '180',
              'sale_price': '299.00',
              'original_price': '599.00'
            },
            {
              'goods_months_price_id': '555343665594178684',
              'month': '12',
              'days': '365',
              'sale_price': '499.00',
              'original_price': '999.00'
            },
          ]
        },
        {
          'id': '555343665594113148',
          'goods_name': '2024口腔执业医师模考大赛',
          'name': '2024口腔执业医师模考大赛',
          'price': '99.00',
          'original_price': '199.00',
          'cover_img': 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/mock_cover.png',
          'type': '10', // 10=模考
          'permission_status': '1', // 1=已购买
          'is_homepage_recommend': 1,
          'tiku_goods_details': {
            'question_num': '0',
            'paper_num': '0',
            'exam_round_num': '3',
            'exam_time': '2024-06-15'
          },
          'prices': [
            {
              'goods_months_price_id': '555343665594178685',
              'month': '0',
              'days': '0',
              'sale_price': '99.00',
              'original_price': '199.00'
            },
          ]
        },
      ],
      'total': 2
    }
  };
  
  // ========== F3. 模拟考试模块 Mock数据 ==========
  
  /// 模考列表Mock数据
  static final Map<String, dynamic> _modelExamListMockData = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'list': [
        {
          'id': '479966355437655235',
          'exam_name': '2024年口腔执业医师模考大赛第一场',
          'start_time': '2024-11-25 09:00:00',
          'end_time': '2024-11-25 11:00:00',
          'exam_status': '1', // 1=报名中
          'is_signup': 0,
          'signup_start_time': '2024-11-20 00:00:00',
          'signup_end_time': '2024-11-24 23:59:59',
          'exam_duration': 120,
          'question_num': 100,
          'total_score': 100,
          'pass_score': 60
        },
        {
          'id': '479966355437655236',
          'exam_name': '2024年口腔执业医师模考大赛第二场',
          'start_time': '2024-12-15 09:00:00',
          'end_time': '2024-12-15 11:00:00',
          'exam_status': '0', // 0=未开始
          'is_signup': 0,
          'signup_start_time': '2024-12-10 00:00:00',
          'signup_end_time': '2024-12-14 23:59:59',
          'exam_duration': 120,
          'question_num': 100,
          'total_score': 100,
          'pass_score': 60
        },
      ]
    }
  };
  
  // ========== F4. 学习中心模块 Mock数据 ==========
  
  /// 学习日历Mock数据
  static final Map<String, dynamic> _studyCalendarMockData = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'calendar': [
        {
          'date': '2024-11-01',
          'is_checkin': 1,
          'study_duration': 3600,
          'question_count': 50,
          'correct_count': 42
        },
        {
          'date': '2024-11-02',
          'is_checkin': 1,
          'study_duration': 5400,
          'question_count': 80,
          'correct_count': 65
        },
        {
          'date': '2024-11-23',
          'is_checkin': 1,
          'study_duration': 7200,
          'question_count': 100,
          'correct_count': 85
        },
      ],
      'total_days': 30,
      'checkin_days': 25,
      'continuous_days': 7
    }
  };
  
  // ========== F5. 商品订单模块 Mock数据 ==========
  
  /// 商品详情Mock数据
  static final Map<String, dynamic> _goodsDetailMockData = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'id': '555343665594113147',
      'goods_name': '2024口腔执业医师题库',
      'name': '2024口腔执业医师题库',
      'price': '299.00',
      'original_price': '599.00',
      'type': '18',
      'permission_status': '2',
      'professional_id': '524033912737962623',
      'professional_id_name': '医学-口腔执业医师',
      'tiku_goods_details': {
        'question_num': '5000',
        'paper_num': '0',
        'exam_round_num': '0',
        'exam_time': ''
      },
      'teaching_system': {
        'system_id_name': '章节练习系统'
      },
      'material_intro_path': 'https://xxx.com/intro.html',
      'material_cover_path': 'https://xxx.com/cover.png',
      'cover_img': 'https://xxx.com/cover.png',
      'prices': [
        {
          'goods_months_price_id': '555343665594178683',
          'month': '6',
          'days': '180',
          'sale_price': '299.00',
          'original_price': '599.00'
        },
        {
          'goods_months_price_id': '555343665594178684',
          'month': '12',
          'days': '365',
          'sale_price': '499.00',
          'original_price': '999.00'
        },
        {
          'goods_months_price_id': '555343665594178685',
          'month': '0',
          'days': '0',
          'sale_price': '999.00',
          'original_price': '1999.00'
        },
      ]
    }
  };
  
  /// 订单列表Mock数据
  static final Map<String, dynamic> _orderListMockData = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'list': [
        {
          'order_id': '555343665594178683',
          'order_no': 'YKX202411231234567890',
          'goods_name': '2024口腔执业医师题库',
          'pay_amount': '299.00',
          'status': '2', // 2=已支付
          'status_name': '已支付',
          'create_time': '2024-11-23 14:30:00',
          'pay_time': '2024-11-23 14:31:25',
          'goods_cover': 'https://xxx.com/cover.png',
          'validity_day': '180',
          'expire_time': '2025-05-22 14:31:25'
        },
      ],
      'total': 1
    }
  };
  
  // ========== F6. 我的中心模块 Mock数据 ==========
  
  /// 个人中心Mock数据
  static final Map<String, dynamic> _profileMockData = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'student_id': '555343665594113147',
      'nickname': '牙开心测试用户',
      'avatar': 'https://thirdwx.qlogo.cn/mmopen/vi_32/mock_avatar.png',
      'mobile': '13800138000',
      'professional_name': '医学-口腔执业医师',
      'menus': [
        {'id': '1', 'name': '我的订单', 'icon': 'order'},
        {'id': '2', 'name': '报告中心', 'icon': 'report'},
        {'id': '3', 'name': '错题本', 'icon': 'wrong'},
        {'id': '4', 'name': '收藏', 'icon': 'collect'},
        {'id': '5', 'name': '设置', 'icon': 'settings'},
      ]
    }
  };
}
