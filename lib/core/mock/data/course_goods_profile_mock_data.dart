/// F4. 学习中心模块 Mock数据
class CourseMockData {
  /// P4-1 学习日历Mock数据
  static final Map<String, dynamic> calendarData = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'calendar': List.generate(30, (index) {
        final date = DateTime.now().subtract(Duration(days: 29 - index));
        final isChecked = index % 3 != 0; // 模拟打卡情况
        return {
          'date': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
          'is_checkin': isChecked ? 1 : 0,
          'study_duration': isChecked ? 3600 + (index * 100) : 0,
          'question_count': isChecked ? 50 + (index % 30) : 0,
          'correct_count': isChecked ? 40 + (index % 25) : 0,
        };
      }),
      'total_days': 30,
      'checkin_days': 20,
      'continuous_days': 7,
    }
  };
  
  /// P4-2 我的课程Mock数据
  static final Map<String, dynamic> myCourseList = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'list': [
        {
          'id': 'course_001',
          'course_name': '口腔执业医师精品课程',
          'cover_img': 'https://picsum.photos/300/180?random=10',
          'teacher_name': '张教授',
          'total_lessons': 120,
          'learned_lessons': 45,
          'progress': 37.5, // 学习进度百分比
          'validity_end_time': '2025-06-30 23:59:59',
          'is_expired': false,
        },
        {
          'id': 'course_002',
          'course_name': '口腔解剖学系统课',
          'cover_img': 'https://picsum.photos/300/180?random=11',
          'teacher_name': '李老师',
          'total_lessons': 80,
          'learned_lessons': 80,
          'progress': 100,
          'validity_end_time': '2025-12-31 23:59:59',
          'is_expired': false,
        },
      ],
      'total': 2,
    }
  };
  
  /// P4-3 课程详情Mock数据
  static final Map<String, dynamic> courseDetail = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'id': 'course_001',
      'course_name': '口腔执业医师精品课程',
      'cover_img': 'https://picsum.photos/600/360?random=10',
      'teacher_name': '张教授',
      'teacher_avatar': 'https://i.pravatar.cc/150?img=10',
      'teacher_intro': '从事口腔医学教学20年，主编多部教材',
      'total_lessons': 120,
      'learned_lessons': 45,
      'progress': 37.5,
      'validity_end_time': '2025-06-30 23:59:59',
      'description': '<p>本课程系统讲解口腔执业医师考试重点内容</p>',
      'chapters': [
        {
          'id': 'chapter_001',
          'name': '第一章 口腔解剖生理学',
          'lessons': [
            {
              'id': 'lesson_001',
              'name': '牙体解剖',
              'duration': 1800, // 秒
              'is_free': true,
              'is_learned': true,
              'type': 'video', // video=录播, live=直播
            },
            {
              'id': 'lesson_002',
              'name': '牙周组织',
              'duration': 2400,
              'is_free': false,
              'is_learned': false,
              'type': 'video',
            },
          ],
        },
        {
          'id': 'chapter_002',
          'name': '第二章 口腔组织病理学',
          'lessons': [
            {
              'id': 'lesson_003',
              'name': '牙体组织病理',
              'duration': 3000,
              'is_free': false,
              'is_learned': false,
              'type': 'live',
              'live_time': '2024-11-25 19:00:00',
              'live_status': 'upcoming', // upcoming=未开始, living=直播中, ended=已结束
            },
          ],
        },
      ],
    }
  };
}

/// F5. 商品订单模块 Mock数据
class GoodsOrderMockData {
  /// P5-1 商品详情Mock数据
  static final Map<String, dynamic> goodsDetail = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'id': '555343665594113147',
      'goods_name': '2024口腔执业医师题库',
      'name': '2024口腔执业医师题库',
      'price': '299.00',
      'original_price': '599.00',
      'type': '18', // 18=题库, 8=试卷, 10=模考
      'permission_status': '2', // 1=已购买, 2=未购买
      'professional_id': '524033912737962623',
      'professional_id_name': '医学-口腔执业医师',
      'cover_img': 'https://picsum.photos/600/300?random=20',
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
      'material_cover_path': 'https://picsum.photos/600/400?random=21',
      'description': '<h3>商品介绍</h3><p>本题库包含5000道精选试题</p><ul><li>章节练习</li><li>模拟考试</li><li>真题解析</li></ul>',
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
      ],
    }
  };
  
  /// P5-2 订单列表Mock数据
  static final Map<String, dynamic> orderList = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'list': [
        {
          'order_id': '555343665594178683',
          'order_no': 'YKX202411231234567890',
          'goods_name': '2024口腔执业医师题库',
          'pay_amount': '299.00',
          'status': '2', // 0=待支付, 1=支付中, 2=已支付, 3=已取消, 4=已退款
          'status_name': '已支付',
          'create_time': '2024-11-23 14:30:00',
          'pay_time': '2024-11-23 14:31:25',
          'goods_cover': 'https://picsum.photos/150/90?random=22',
          'validity_day': '180',
          'expire_time': '2025-05-22 14:31:25',
          'goods_type': '18', // 18=题库
        },
        {
          'order_id': '555343665594178684',
          'order_no': 'YKX202410151234567890',
          'goods_name': '2024口腔执业医师模考大赛',
          'pay_amount': '99.00',
          'status': '2',
          'status_name': '已支付',
          'create_time': '2024-10-15 10:20:00',
          'pay_time': '2024-10-15 10:21:15',
          'goods_cover': 'https://picsum.photos/150/90?random=23',
          'validity_day': '0',
          'expire_time': '',
          'goods_type': '10', // 10=模考
        },
      ],
      'total': 2
    }
  };
}

/// F6. 我的中心模块 Mock数据
class ProfileMockData {
  /// P6-1 个人中心Mock数据
  static final Map<String, dynamic> profileInfo = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'student_id': '555343665594113147',
      'nickname': '牙开心8000',
      'avatar': 'https://i.pravatar.cc/150?img=20',
      'mobile': '13800138000',
      'professional_name': '医学-口腔执业医师',
      'study_days': 30,
      'question_count': 1250,
      'menus': [
        {'id': '1', 'name': '我的订单', 'icon': 'order', 'route': '/my-order'},
        {'id': '2', 'name': '报告中心', 'icon': 'report', 'route': '/report-center'},
        {'id': '3', 'name': '错题本', 'icon': 'wrong', 'route': '/wrong-book-index'},
        {'id': '4', 'name': '收藏', 'icon': 'collect', 'route': '/collect-index'},
        {'id': '5', 'name': '设置', 'icon': 'settings', 'route': '/settings'},
      ]
    }
  };
  
  /// P6-3 报告中心Mock数据
  static final Map<String, dynamic> reportList = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'list': [
        {
          'id': 'report_001',
          'type': 'chapter', // chapter=章节练习, exam=模拟考试, challenge=闯关
          'title': '第一章 口腔解剖生理学',
          'score': 85,
          'accuracy': '85.00',
          'create_time': '2024-11-23 14:30:00',
        },
        {
          'id': 'report_002',
          'type': 'exam',
          'title': '2024年口腔执业医师模考大赛第一场',
          'score': 82,
          'accuracy': '82.00',
          'ranking': 45,
          'create_time': '2024-11-20 11:00:00',
        },
      ],
      'total': 2,
    }
  };
}

/// 通用类：整合所有Mock数据供路由器使用
class CourseGoodsProfileMockData {
  // F4. 学习中心
  static final Map<String, dynamic> studyIndex = CourseMockData.calendarData;
  static final Map<String, dynamic> myCourse = CourseMockData.myCourseList;
  static final Map<String, dynamic> courseDetail = CourseMockData.courseDetail;
  static final Map<String, dynamic> videoInfo = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'video_url': 'https://www.w3schools.com/html/mov_bbb.mp4',
      'title': '牙体解剖',
      'duration': 1800,
    }
  };
  
  // F5. 商品订单
  static final Map<String, dynamic> goodsDetail = GoodsOrderMockData.goodsDetail;
  static final Map<String, dynamic> orderList = GoodsOrderMockData.orderList;
  static final Map<String, dynamic> createOrder = {
    'code': 100000,
    'msg': ['创建成功'],
    'data': {
      'order_id': '555343665594178686',
      'order_no': 'YKX202411231234567891',
      'pay_url': 'https://example.com/pay',
    }
  };
  
  // F6. 个人中心
  static final Map<String, dynamic> myIndex = ProfileMockData.profileInfo;
  static final Map<String, dynamic> updateProfile = {
    'code': 100000,
    'msg': ['修改成功'],
    'data': null,
  };
}
