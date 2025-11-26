/// F2. 题库练习模块 Mock数据
class QuestionBankMockData {
  /// 商品列表Mock数据 (用于首页题库列表)
  /// 对应小程序: type: '8,10,18' (试卷、模考、章节练习)
  /// 基于真实API数据结构
  static final Map<String, dynamic> goodsList = {
    'code': 100000,
    'msg': ['操作成功'],
    'data': {
      'list': [
        {
          'id': '593505082385898224',
          'name': '2026高清网课—口腔组织病理学',
          'material_cover_path': '408559575579495187/2025/10/29/17617022592896af0-1761702259289-92214.jpg',
          'type': '18', // 章节练习
          'type_name': '章节练习',
          'new_type_name': '章节练习',
          'sale_price': '299.00',
          'original_price': '399.00',
          'permission_status': '1', // 已购买
          'is_homepage_recommend': '1',
          'is_recommend': '1',
          'validity_day': '0', // 永久
          'validity_start_date': '0001.01.01',
          'validity_end_date': '0001.01.01',
          'student_num': '1256',
          'year': '2026',
          'business_type': '1',
          'business_type_name': '精品',
          'tiku_goods_details': {
            'question_num': '3000',
            'paper_num': '0',
            'exam_num': '0',
            'exam_round_num': '0',
          },
          'teacher_data': [],
        },
        {
          'id': '593505082385898225',
          'name': '2026口腔执业医师历年真题精选',
          'material_cover_path': '408559575579495187/2025/10/16/176062477451584dc-1760624774515-70652.jpg',
          'type': '8', // 试卷
          'type_name': '试卷',
          'new_type_name': '试卷',
          'sale_price': '199.00',
          'original_price': '299.00',
          'permission_status': '2', // 未购买
          'is_homepage_recommend': '1',
          'is_recommend': '2',
          'validity_day': '12',
          'validity_start_date': '2025.10.22',
          'validity_end_date': '2026.10.22',
          'student_num': '2358',
          'year': '2026',
          'business_type': '1',
          'business_type_name': '精品',
          'tiku_goods_details': {
            'question_num': '1500',
            'paper_num': '10',
            'exam_num': '0',
            'exam_round_num': '0',
          },
          'teacher_data': [],
        },
        {
          'id': '593505082385898226',
          'name': '2026口腔执业医师模拟考试',
          'material_cover_path': '408559575579495187/2025/10/16/176062477451584dc-1760624774515-70652.jpg',
          'type': '10', // 模考
          'type_name': '模考',
          'new_type_name': '模考',
          'sale_price': '99.00',
          'original_price': '199.00',
          'permission_status': '2',
          'is_homepage_recommend': '1',
          'is_recommend': '2',
          'validity_day': '6',
          'validity_start_date': '2025.10.22',
          'validity_end_date': '2026.04.22',
          'student_num': '986',
          'year': '2026',
          'business_type': '1',
          'business_type_name': '精品',
          'tiku_goods_details': {
            'question_num': '600',
            'paper_num': '5',
            'exam_num': '0',
            'exam_round_num': '3',
          },
          'teacher_data': [],
        },
      ],
      'total': 3,
      'pages': 1,
    }
  };
  
  /// 网课 Mock数据 (对应小程序 teaching_type: '3')
  /// 基于真实API数据: /goods/v2?teaching_type=3
  /// 注意: shop_type 是通过 computGoodType 逻辑计算出来的
  static final Map<String, dynamic> onlineCourseList = {
    'code': 100000,
    'msg': ['操作成功'],
    'data': {
      'list': [
        {
          'id': '590847708726562259',
          'name': '2026精品医师考试高清网课-内部学员版',
          'material_cover_path': '408559575579495187/2025/10/29/17617022592896af0-1761702259289-92214.jpg',
          'type': '2',
          'type_name': '套餐',
          'new_type_name': '系统课-高端课程', // 使用goods_type_id_name
          'teaching_type': '3', // 录播
          'teaching_type_name': '录播',
          'service_type': '1',
          'service_type_name': '一年制',
          'business_type': '1',
          'business_type_name': '精品',
          'sale_price': '0.00',
          'original_price': '999.00',
          'permission_status': '2', // 未购买
          'validity_day': '12',
          'validity_start_date': '2025.10.22',
          'validity_end_date': '2026.11.22',
          'total_class_hour': '0',
          'class_hour': '0',
          'chapter_count': '0',
          'student_num': '823', // 购买人数
          // 注意: shop_type 不再直接从API返回,而是通过 GoodsModel.computeShopType() 计算
          // 根据逻辑: teaching_type_name='录播'(非直播), is_recommend='2', 所以返回 business_type='1'
          'is_recommend': '2', // 不是推荐
          'goods_type_id': '432738882501479281',
          'goods_type_id_name': '系统课-高端课程',
          'project_id_name': '口腔-口腔医师-口腔执业医师(120)',
          'year': '2026',
          'is_homepage_recommend': '2',
          'teacher_data': [],
        },
        {
          'id': '589039979154376128',
          'name': '2026精品医师考试高清网课',
          'material_cover_path': '408559575579495187/2025/10/16/176062477451584dc-1760624774515-70652.jpg',
          'type': '2',
          'type_name': '套餐',
          'new_type_name': '系统课-高端课程',
          'teaching_type': '3',
          'teaching_type_name': '录播',
          'service_type': '1',
          'service_type_name': '一年制',
          'business_type': '2', // 高端
          'business_type_name': '高端',
          'sale_price': '999.00',
          'original_price': '999.00',
          'permission_status': '2',
          'validity_day': '12',
          'validity_start_date': '2025.10.22',
          'validity_end_date': '2026.11.22',
          'total_class_hour': '0',
          'class_hour': '0',
          'chapter_count': '0',
          'student_num': '831',
          // 注意: shop_type 不再直接从API返回,而是通过 GoodsModel.computeShopType() 计算
          // 根据逻辑: teaching_type_name='录播'(非直播), is_recommend='2', 所以返回 business_type='2'
          'is_recommend': '2',
          'goods_type_id': '432738882501479281',
          'goods_type_id_name': '系统课-高端课程',
          'project_id_name': '口腔-口腔医师-口腔执业医师(120)',
          'year': '2026',
          'is_homepage_recommend': '2',
          'teacher_data': [],
        },
      ],
      'total': 2,
      'pages': 1,
    }
  };
  
  /// 直播Mock数据 (对应小程序 teaching_type: '1')
  /// 注意: shop_type 是通过 computGoodType 逻辑计算出来的
  static final Map<String, dynamic> liveList = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'list': [
        {
          'id': '555343665594113152',
          'name': '口腔执业医师直播课',
          'material_cover_path': 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/36byshkvk6.jpg',
          'type': '2',
          'type_name': '直播',
          'new_type_name': '强化直播课',
          'teaching_type': '1', // 直播
          'teaching_type_name': '直播',
          'service_type_name': '实时互动',
          'business_type': '1',
          'business_type_name': '精品',
          'sale_price': '799',
          'original_price': '1199',
          'permission_status': '2',
          'validity_day': '12',
          'validity_start_date': '2024-03-01',
          'validity_end_date': '2024-12-31',
          'total_class_hour': '100',
          'student_num': 2358,
          // 注意: shop_type 不再直接从API返回,而是通过 GoodsModel.computeShopType() 计算
          // 根据逻辑: teaching_type_name='直播', is_recommend='2', 所以返回 'good'
          'is_recommend': '2',
          'teacher_data': [
            {
              'teacher_id': 't003',
              'teacher_name': '王老师',
              'avatar': 'https://picsum.photos/100/100?random=3',
            },
          ],
        },
        {
          'id': '555343665594113153',
          'name': '口腔疾病诊疗直播',
          'material_cover_path': 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/36byshkvk6.jpg',
          'type': '3',
          'type_name': '直播',
          'new_type_name': '临床案例直播',
          'teaching_type': '1',
          'teaching_type_name': '直播',
          'service_type_name': '专家答疑',
          'business_type': '2',
          'business_type_name': '高端',
          'sale_price': '699',
          'original_price': '999',
          'permission_status': '2',
          'validity_day': '6',
          'validity_start_date': '2024-03-01',
          'validity_end_date': '2024-09-01',
          'total_class_hour': '60',
          'student_num': 1523,
          // 注意: shop_type 不再直接从API返回,而是通过 GoodsModel.computeShopType() 计算
          // 根据逻辑: is_recommend='1' (最高优先级), 所以返回 'recommend'
          'is_recommend': '1', // 推荐课程
        },
      ],
      'total': 2,
    }
  };
  
  /// P2-1 首页Mock数据
  static final Map<String, dynamic> homeData = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      // 首页统计
      'statistic': {
        'study_days': 30,
        'question_count': 1250,
        'correct_count': 985,
        'accuracy': '78.8',
        'cumulative_study_time': 72000, // 累计学习时长(秒) 20小时
      },
      // 推荐章节
      'recommend_chapters': [
        {
          'id': '123',
          'name': '口腔解剖生理学',
          'question_num': '500',
          'do_question_num': '120',
          'correct_question_num': '95',
          'cover_img': 'https://picsum.photos/200/100?random=1',
        },
        {
          'id': '124',
          'name': '口腔组织病理学',
          'question_num': '450',
          'do_question_num': '80',
          'correct_question_num': '65',
          'cover_img': 'https://picsum.photos/200/100?random=2',
        },
        {
          'id': '125',
          'name': '口腔预防医学',
          'question_num': '380',
          'do_question_num': '0',
          'correct_question_num': '0',
          'cover_img': 'https://picsum.photos/200/100?random=3',
        },
      ],
      // 上次练习
      'last_progress': {
        'scene': 1, // 1=章节练习, 2=真题闯关, 3=智能测评
        'practice_progress_text': '第一章 > 第一节 > 第25题',
        'chapter_id': '123',
        'goods_id': '555343665594113147',
        'practice_id': 'practice_123456',
      },
      // 打卡数据
      'checkin_data': {
        'continuous_days': 7,
        'total_days': 30,
        'today_checked': true,
        'today_question_count': 50,
        'today_correct_count': 42,
      }
    }
  };
  
  /// P2-2 章节列表Mock数据
  static final Map<String, dynamic> chapterTree = {
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
              'do_question_num': '20',
              'correct_question_num': '15',
              'parent_id': '437657998052172130',
              'sort': 2,
              'child': []
            },
            {
              'id': '437658088934351204',
              'name': '第三节 口腔黏膜',
              'question_number': '70',
              'do_question_num': '0',
              'correct_question_num': '0',
              'parent_id': '437657998052172130',
              'sort': 3,
              'child': []
            },
          ]
        },
        {
          'id': '437657998052172131',
          'name': '第二章 口腔组织病理学',
          'question_number': '450',
          'do_question_num': '80',
          'correct_question_num': '65',
          'parent_id': '0',
          'sort': 2,
          'child': [
            {
              'id': '437658088934351205',
              'name': '第一节 牙体组织',
              'question_number': '120',
              'do_question_num': '30',
              'correct_question_num': '25',
              'parent_id': '437657998052172131',
              'sort': 1,
              'child': []
            },
            {
              'id': '437658088934351206',
              'name': '第二节 牙周组织病理',
              'question_number': '100',
              'do_question_num': '0',
              'correct_question_num': '0',
              'parent_id': '437657998052172131',
              'sort': 2,
              'child': []
            },
          ]
        },
        {
          'id': '437657998052172132',
          'name': '第三章 口腔预防医学',
          'question_number': '380',
          'do_question_num': '0',
          'correct_question_num': '0',
          'parent_id': '0',
          'sort': 3,
          'child': []
        },
      ]
    }
  };
  
  /// P2-3 章节详情Mock数据
  static final Map<String, dynamic> chapterDetail = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'id': '437658088934351202',
      'name': '第一节 牙体解剖',
      'question_number': '100',
      'do_question_num': '25',
      'correct_question_num': '20',
      'accuracy': '80.0',
      'introduction': '本节主要讲解牙体的基本结构和解剖学特点...',
    }
  };
  
  /// P2-4 题目列表Mock数据
  static final Map<String, dynamic> questionList = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'list': [
        {
          'id': '473024261183771326',
          'type': '1', // 1=A1型题, 2=A2型题, 3=A3型题, 4=B型题
          'type_name': 'A1',
          'stem_list': [
            {
              'content': '<p>关于牙体组织的描述，下列哪项是错误的？</p>',
              'option': '["A. 牙釉质是人体最硬的组织", "B. 牙本质构成牙体的主体", "C. 牙骨质覆盖在牙根表面", "D. 牙髓位于髓腔内", "E. 牙釉质可以再生"]',
              'answer': '["E"]',
              'user_option': null, // 用户答案
            }
          ],
          'parse': '<p><b>解析：</b>牙釉质一旦形成后就不能再生，这是其特点之一。</p>',
          'is_collect': 0, // 是否收藏 0=否 1=是
          'is_wrong': 0, // 是否错题 0=否 1=是
        },
        {
          'id': '473024261183771327',
          'type': '1',
          'type_name': 'A1',
          'stem_list': [
            {
              'content': '<p>成人恒牙共有多少颗？</p>',
              'option': '["A. 28颗", "B. 30颗", "C. 32颗", "D. 34颗", "E. 36颗"]',
              'answer': '["C"]',
              'user_option': null,
            }
          ],
          'parse': '<p><b>解析：</b>成人恒牙共32颗，包括4颗第三磨牙(智齿)。</p>',
          'is_collect': 0,
          'is_wrong': 0,
        },
      ],
      'total': 100,
      'current_index': 0, // 当前题目索引
    }
  };
  
  /// P2-5 提交答案Mock数据
  static final Map<String, dynamic> submitAnswer = {
    'code': 100000,
    'msg': ['提交成功'],
    'data': {
      'is_correct': true,
      'correct_answer': '["E"]',
      'parse': '<p><b>解析：</b>牙釉质一旦形成后就不能再生...</p>',
    }
  };
  
  /// P2-6 成绩报告Mock数据
  static final Map<String, dynamic> scoreReport = {
    'code': 100000,
    'msg': ['提交成功'],
    'data': {
      'score': 85,
      'total_question': 100,
      'correct_num': 85,
      'error_num': 15,
      'accuracy': '85.00',
      'duration': 3600, // 用时(秒)
      'ranking': 120,
      'beat_rate': '75.5', // 击败率
      'practice_id': '479966355437655235',
      'error_questions': [
        {
          'question_id': '473024261183771326',
          'user_answer': '["A"]',
          'correct_answer': '["E"]',
        },
      ],
      // 知识点掌握情况
      'knowledge_points': [
        {
          'name': '牙体解剖',
          'total': 25,
          'correct': 20,
          'accuracy': '80.0',
        },
        {
          'name': '牙周组织',
          'total': 20,
          'correct': 15,
          'accuracy': '75.0',
        },
      ],
    }
  };
  
  /// P2-7 真题闯关首页Mock数据
  static final Map<String, dynamic> challengeIndex = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'total_levels': 30,
      'passed_levels': 12,
      'current_level': 13,
      'total_stars': 36,
      'ranking': 256,
    }
  };
  
  /// P2-8 关卡列表Mock数据
  static final Map<String, dynamic> levelList = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'list': [
        {
          'level': 1,
          'name': '第1关',
          'status': 2, // 0=未解锁 1=进行中 2=已通过
          'stars': 3,
          'question_num': 10,
        },
        {
          'level': 2,
          'name': '第2关',
          'status': 2,
          'stars': 3,
          'question_num': 10,
        },
        {
          'level': 3,
          'name': '第3关',
          'status': 1,
          'stars': 0,
          'question_num': 10,
        },
      ]
    }
  };
  
  /// P2-11 智能测评首页Mock数据
  static final Map<String, dynamic> intelligentIndex = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'total_tests': 15,
      'completed_tests': 8,
      'average_score': 82.5,
      'weak_points': ['牙体解剖', '牙周组织'],
    }
  };
  
  /// P2-14 考点词条首页Mock数据
  static final Map<String, dynamic> examEntryIndex = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'list': [
        {
          'id': '1',
          'title': '牙釉质',
          'category': '口腔解剖生理学',
          'view_count': 1250,
        },
        {
          'id': '2',
          'title': '牙本质',
          'category': '口腔解剖生理学',
          'view_count': 980,
        },
      ]
    }
  };
  
  /// P2-15 考点词条详情Mock数据
  static final Map<String, dynamic> examEntryDetail = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'id': '1',
      'title': '牙釉质',
      'category': '口腔解剖生理学',
      'content': '<p><b>牙釉质</b>是人体最硬的组织...</p>',
      'related_questions': [
        {'id': '473024261183771326', 'title': '关于牙体组织的描述...'}
      ],
    }
  };
  
  /// P7-1 错题本首页Mock数据
  static final Map<String, dynamic> wrongBookIndex = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'total_wrong': 45,
      'today_wrong': 3,
      'chapters': [
        {
          'chapter_id': '437657998052172130',
          'chapter_name': '第一章 口腔解剖生理学',
          'wrong_count': 15,
        },
        {
          'chapter_id': '437657998052172131',
          'chapter_name': '第二章 口腔组织病理学',
          'wrong_count': 12,
        },
      ]
    }
  };
  
  /// P7-2 错题详情Mock数据
  static final Map<String, dynamic> wrongBookDetail = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'list': questionList['data']['list'], // 复用题目列表结构
    }
  };
  
  /// P8-1 收藏首页Mock数据
  static final Map<String, dynamic> collectIndex = {
    'code': 100000,
    'msg': ['success'],
    'data': {
      'total_collect': 28,
      'today_collect': 2,
      'chapters': [
        {
          'chapter_id': '437657998052172130',
          'chapter_name': '第一章 口腔解剖生理学',
          'collect_count': 10,
        },
      ]
    }
  };
  
  /// P8-2 添加/取消收藏Mock数据
  static final Map<String, dynamic> toggleCollect = {
    'code': 100000,
    'msg': ['操作成功'],
    'data': {
      'is_collect': 1, // 1=已收藏 0=未收藏
    }
  };

  /// 学习数据 (for QuestionBankPage)
  /// 对应接口：/api/exam/learning
  static final Map<String, dynamic> learningData = {
    'code': 100000,
    'msg': ['操作成功'],
    'data': {
      'checkin_num': 15,        // 连续打卡天数
      'total_num': 1250,        // 总做题数
      'correct_rate': '85',     // 正确率
      'is_checkin': 1,          // 是否已打卡 1-已打卡 0-未打卡
    },
  };

  /// 打卡接口
  /// 对应接口：/api/exam/checkin
  static final Map<String, dynamic> checkinResponse = {
    'code': 100000,
    'msg': ['打卡成功'],
    'data': {},
  };

  /// 每日一测数据 (对应小程序 daily30)
  /// 对应接口：/api/goods?position_identify=daily30
  static final Map<String, dynamic> dailyPractice = {
    'id': '590847708726562260',
    'name': '每日30题',
    'question_number': 30,
    'do_question_num': 12,
    'permission_status': '1', // 1-已购买 2-未购买
    'data_type': 1, // 1-章节练习 2-模考
    'details_type': 1, // 1-经典版 2-真题版 3-科目版 4-模考版
    'professional_id': '524033912737962623',
  };

  /// 根据position_identify获取商品列表
  /// 对应小程序接口：getGoods({ position_identify: 'linianzhenti' })
  static List<Map<String, dynamic>> getGoodsByPosition(String positionIdentify) {
    // Mock数据：根据不同的position_identify返回对应的商品数据
    switch (positionIdentify) {
      case 'linianzhenti': // 历年真题/绝密押题
        return [
          {
            'id': '593505082385898230',
            'name': '2026口腔执业医师历年真题精选',
            'professional_id': '524033912737962623',
            'permission_status': '2', // 未购买
            'details_type': 2, // 真题版
            'data_type': 1, // 章节练习
            'tiku_goods_details': {
              'question_num': 3580,
              'exam_time': '2026-12-31',
            },
            'paper_statistics': {
              'do_count': 0,
              'total_accuracy_rate': '0',
            },
          },
        ];
      case 'kemumokao': // 科目模考
        return [
          {
            'id': '593505082385898231',
            'name': '2026口腔执业医师科目模考',
            'professional_id': '524033912737962623',
            'permission_status': '2', // 未购买
            'details_type': 3, // 科目版
            'data_type': 2, // 模考
            'sale_price': '199.00',
            'original_price': '299.00',
            'longImagePath': '', // 长图路径
          },
        ];
      case 'monikaoshi': // 模拟考试
        return [
          {
            'id': '593505082385898232',
            'name': '2026口腔执业医师模拟考试',
            'professional_id': '524033912737962623',
            'permission_status': '2', // 未购买
            'details_type': 4, // 模考版
            'data_type': 2, // 模考
            'examTitle': '口腔执业医师',
            'mkgoods_statistics': {
              'fullMarkScore': 600,
              'examDuration': 150,
            },
            'exam_rounds': [], // 考试轮次列表
          },
        ];
      default:
        return [];
    }
  }
}
