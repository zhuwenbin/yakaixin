/// F3. 模拟考试模块 Mock数据
class ModelExamMockData {
  /// P3-1 模考首页Mock数据
  static final Map<String, dynamic> modelExamIndex = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'banner': [
        {'img': 'https://picsum.photos/750/300?random=1', 'link': ''},
        {'img': 'https://picsum.photos/750/300?random=2', 'link': ''},
      ],
      'upcoming_exams': examList['data']['list'],
    }
  };
  
  /// P3-1 模考列表Mock数据
  static final Map<String, dynamic> examList = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'list': [
        {
          'id': '479966355437655235',
          'exam_name': '2024年口腔执业医师模考大赛第一场',
          'start_time': '2024-11-25 09:00:00',
          'end_time': '2024-11-25 11:00:00',
          'exam_status': '1', // 0=未开始, 1=报名中, 2=进行中, 3=已结束
          'is_signup': 1, // 0=未报名, 1=已报名
          'signup_start_time': '2024-11-20 00:00:00',
          'signup_end_time': '2024-11-24 23:59:59',
          'exam_duration': 120, // 分钟
          'question_num': 100,
          'total_score': 100,
          'pass_score': 60,
          'signup_num': 1250, // 报名人数
          'cover_img': 'https://picsum.photos/300/150?random=1',
        },
        {
          'id': '479966355437655236',
          'exam_name': '2024年口腔执业医师模考大赛第二场',
          'start_time': '2024-12-15 09:00:00',
          'end_time': '2024-12-15 11:00:00',
          'exam_status': '0',
          'is_signup': 0,
          'signup_start_time': '2024-12-10 00:00:00',
          'signup_end_time': '2024-12-14 23:59:59',
          'exam_duration': 120,
          'question_num': 100,
          'total_score': 100,
          'pass_score': 60,
          'signup_num': 856,
          'cover_img': 'https://picsum.photos/300/150?random=2',
        },
        {
          'id': '479966355437655237',
          'exam_name': '2024年口腔执业医师模考大赛第三场',
          'start_time': '2025-01-20 09:00:00',
          'end_time': '2025-01-20 11:00:00',
          'exam_status': '3', // 已结束
          'is_signup': 1,
          'has_result': true, // 有成绩
          'score': 82,
          'ranking': 45,
          'exam_duration': 120,
          'question_num': 100,
          'total_score': 100,
          'pass_score': 60,
          'signup_num': 2100,
          'cover_img': 'https://picsum.photos/300/150?random=3',
        },
      ]
    }
  };
  
  /// P3-3 开始考试Mock数据
  static final Map<String, dynamic> startExam = {
    'code': 100000,
    'msg': ['进入考试'],
    'data': {
      'exam_record_id': 'record_123456',
      'exam_id': '479966355437655235',
      'start_time': '2024-11-25 09:30:00',
    }
  };
  
  /// P3-4 考试中的题目Mock数据
  static final Map<String, dynamic> examQuestions = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'questions': [
        {
          'id': '1',
          'type': '1',
          'type_name': 'A1',
          'stem_list': [
            {
              'content': '<p>口腔执业医师考试题目...</p>',
              'option': '["A. 选项1", "B. 选项2", "C. 选项3", "D. 选项4"]',
              'answer': '["C"]',
              'user_option': null,
            }
          ],
          'parse': '<p><b>解析：</b>详细解析...</p>',
        },
      ],
      'total': 100,
    }
  };
  
  /// P3-5 提交试卷Mock数据
  static final Map<String, dynamic> submitExam = {
    'code': 100000,
    'msg': ['提交成功'],
    'data': {
      'exam_record_id': 'record_123456',
      'score': 82,
      'ranking': 45,
    }
  };
  
  /// P3-7 考试记录Mock数据
  static final Map<String, dynamic> examRecords = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'list': [
        {
          'exam_record_id': 'record_123456',
          'exam_name': '2024年口腔执业医师模考大赛第一场',
          'score': 82,
          'ranking': 45,
          'submit_time': '2024-11-25 11:00:00',
        }
      ]
    }
  };
  
  /// P3-2 模考详情Mock数据
  static final Map<String, dynamic> examInfo = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'id': '479966355437655235',
      'exam_name': '2024年口腔执业医师模考大赛第一场',
      'start_time': '2024-11-25 09:00:00',
      'end_time': '2024-11-25 11:00:00',
      'exam_status': '1',
      'is_signup': 1,
      'exam_duration': 120,
      'question_num': 100,
      'total_score': 100,
      'pass_score': 60,
      'signup_num': 1250,
      'cover_img': 'https://picsum.photos/600/300?random=1',
      'description': '<p>本次模考全真模拟实际考试环境，帮助您提前适应考试节奏。</p><p><b>考试说明：</b></p><ul><li>考试时长120分钟</li><li>共100题，满分100分</li><li>60分及格</li></ul>',
      'exam_rules': [
        '考试期间不得退出考试页面',
        '考试时间结束自动交卷',
        '允许查看试题解析',
        '成绩将在交卷后立即显示',
      ],
      'subjects': [ // 考试科目
        {'name': '基础医学综合', 'question_num': 40},
        {'name': '医学人文', 'question_num': 10},
        {'name': '预防医学', 'question_num': 10},
        {'name': '临床医学综合', 'question_num': 40},
      ],
    }
  };
  
  /// P3-7 考试成绩报告Mock数据
  static final Map<String, dynamic> examScoreReport = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'score': 82,
      'total_question': 100,
      'correct_num': 82,
      'error_num': 18,
      'accuracy': '82.00',
      'duration': 5400, // 90分钟
      'ranking': 45,
      'total_participants': 1250, // 总参赛人数
      'beat_rate': '96.4',
      'pass_status': 1, // 0=不及格, 1=及格
      'practice_id': '479966355437655235',
      // 各科目得分
      'subject_scores': [
        {'name': '基础医学综合', 'score': 35, 'total': 40, 'accuracy': '87.5'},
        {'name': '医学人文', 'score': 8, 'total': 10, 'accuracy': '80.0'},
        {'name': '预防医学', 'score': 7, 'total': 10, 'accuracy': '70.0'},
        {'name': '临床医学综合', 'score': 32, 'total': 40, 'accuracy': '80.0'},
      ],
      // 分数段分布
      'score_distribution': [
        {'range': '90-100', 'count': 125, 'percent': '10.0'},
        {'range': '80-89', 'count': 375, 'percent': '30.0'},
        {'range': '70-79', 'count': 500, 'percent': '40.0'},
        {'range': '60-69', 'count': 188, 'percent': '15.0'},
        {'range': '0-59', 'count': 62, 'percent': '5.0'},
      ],
    }
  };
  
  /// P3-8 排行榜Mock数据
  static final Map<String, dynamic> rankList = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'my_rank': {
        'ranking': 45,
        'nickname': '牙开心8000',
        'avatar': 'https://thirdwx.qlogo.cn/mmopen/vi_32/mock.png',
        'score': 82,
        'duration': 5400,
      },
      'top_list': [
        {
          'ranking': 1,
          'student_id': '111',
          'nickname': '学霸A',
          'avatar': 'https://i.pravatar.cc/150?img=1',
          'score': 98,
          'duration': 4800,
        },
        {
          'ranking': 2,
          'student_id': '112',
          'nickname': '学霸B',
          'avatar': 'https://i.pravatar.cc/150?img=2',
          'score': 95,
          'duration': 5100,
        },
        {
          'ranking': 3,
          'student_id': '113',
          'nickname': '学霸C',
          'avatar': 'https://i.pravatar.cc/150?img=3',
          'score': 93,
          'duration': 5200,
        },
      ],
    }
  };
}
