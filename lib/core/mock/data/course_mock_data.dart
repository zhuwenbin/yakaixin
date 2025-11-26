/// 课程相关Mock数据
/// 
/// 对应小程序页面：study/detail/index.vue, study/myCourse/index.vue
/// 数据来源：基于小程序页面分析
class MockCourseData {
  /// 课程详情Mock数据
  /// 
  /// 对应小程序页面：study/detail/index.vue
  /// 对应接口：/api/course/detail
  static final Map<String, dynamic> courseDetail = {
    'goods_id': '123',
    'goods_name': '口腔执业医师精品课程',
    'business_type': 2, // 2-高端 3-私塾
    'class': {
      'date': '2025年1月-6月',
      'lesson_attendance_num': 15,
      'lesson_num': 50,
      'teacher': [
        {
          'name': '张教授',
          'title': '口腔医学专家',
          'avatar': '',
        },
      ],
    },
  };

  /// 最近学习数据
  static final Map<String, dynamic> recentlyData = {
    'lesson_id': 'lesson_001',
    'lesson_name': '口腔解剖学基础（第一章）',
  };

  /// 课程列表Mock数据
  static final List<Map<String, dynamic>> lessonList = [
    {
      'id': 'class_001',
      'name': '基础理论课',
      'teaching_type': '3', // 1-直播 3-录播
      'teaching_type_name': '录播',
      'lesson_num': 20,
      'lesson_attendance_num': 8,
      'address': '',
      'isClose': false,
      'lesson': [
        {
          'lesson_id': 'lesson_001',
          'lesson_name': '口腔解剖学基础（第一章）',
          'lesson_name_other': '包含：牙齿结构、牙周组织、口腔黏膜等重要知识点讲解',
          'date': '2025-01-15 09:00',
          'lesson_status': '3', // 3-回放
          'status': '2', // 2-已学完
          'isOpen': false,
          'evaluation_type_top': [
            {
              'id': '1',
              'name': '课前作业',
              'icon': '',
              'paper_version_id': '101',
            },
          ],
          'resource_document': [],
        },
        {
          'lesson_id': 'lesson_002',
          'lesson_name': '口腔组织病理学',
          'lesson_name_other': '',
          'date': '2025-01-20 09:00',
          'lesson_status': '3',
          'status': '1', // 1-未学习
          'isOpen': false,
          'evaluation_type_top': [],
          'resource_document': [],
        },
      ],
    },
    {
      'id': 'class_002',
      'name': '临床实践课',
      'teaching_type': '1',
      'teaching_type_name': '直播',
      'lesson_num': 30,
      'lesson_attendance_num': 7,
      'address': '北京校区A101',
      'isClose': true,
      'lesson': [],
    },
  ];

  /// 我的课程列表
  /// 对应小程序页面：study/myCourse/index.vue
  static final List<Map<String, dynamic>> myCourseList = [
    {
      'goods_id': '1',
      'goods_name': '口腔执业医师精品课程',
      'cover': '',
      'teaching_type': '3',
      'teaching_type_name': '录播',
      'order_id': 'order_001',
    },
    {
      'goods_id': '2',
      'goods_name': '口腔助理医师基础课',
      'cover': '',
      'teaching_type': '1',
      'teaching_type_name': '直播',
      'order_id': 'order_002',
    },
  ];

  /// 下载资料列表
  static final List<Map<String, dynamic>> downloadList = [
    {
      'id': '1',
      'name': '口腔解剖学讲义.pdf',
      'size': '5.2MB',
      'url': 'https://example.com/file1.pdf',
    },
    {
      'id': '2',
      'name': '课后习题答案.pdf',
      'size': '2.8MB',
      'url': 'https://example.com/file2.pdf',
    },
  ];

  /// 打卡日期列表
  static final List<String> checkinDates = [
    '2025-01-15',
    '2025-01-16',
    '2025-01-17',
    '2025-01-20',
    '2025-01-21',
  ];
}
