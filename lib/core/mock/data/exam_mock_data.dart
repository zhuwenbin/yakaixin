/// 考试相关Mock数据
/// 
/// 对应小程序页面：examination/index.vue, answertest/scoreReport.vue
/// 数据来源：基于小程序页面分析
class MockExamData {
  /// 考试信息Mock数据
  /// 
  /// 对应小程序页面：examination/index.vue
  /// 对应接口：/api/exam/info
  static final Map<String, dynamic> examInfo = {
    'id': 'exam_001',
    'name': '2024年口腔执业医师模拟考试（一）',
    'question_num': 150,
    'duration': 180, // 分钟
    'total_score': 150,
    'pass_score': 90,
    'status': 0, // 0-未开始 1-进行中 2-已结束
  };

  /// 成绩报告Mock数据
  /// 
  /// 对应小程序页面：answertest/scoreReport.vue
  /// 对应接口：/api/exam/report
  static final Map<String, dynamic> examReport = {
    'exam_id': 'exam_001',
    'exam_name': '2024年口腔执业医师模拟考试（一）',
    'score': 125,
    'total_score': 150,
    'pass_score': 90,
    'is_pass': true,
    'rank': 156,
    'total_participants': 2580,
    'correct_num': 125,
    'wrong_num': 20,
    'blank_num': 5,
    'accuracy_rate': '83.3%',
    'duration': 165, // 实际用时（分钟）
    'finish_time': '2025-01-25 15:30:00',
    'subject_analysis': [
      {
        'subject_name': '基础医学综合',
        'correct_num': 35,
        'total_num': 40,
        'accuracy_rate': '87.5%',
      },
      {
        'subject_name': '口腔临床医学综合',
        'correct_num': 48,
        'total_num': 60,
        'accuracy_rate': '80.0%',
      },
      {
        'subject_name': '预防医学综合',
        'correct_num': 42,
        'total_num': 50,
        'accuracy_rate': '84.0%',
      },
    ],
  };

  /// 考试列表
  static final List<Map<String, dynamic>> examList = [
    {
      'id': 'exam_001',
      'name': '2024年口腔执业医师模拟考试（一）',
      'question_num': 150,
      'status': 2, // 已完成
      'score': 125,
    },
    {
      'id': 'exam_002',
      'name': '2024年口腔执业医师模拟考试（二）',
      'question_num': 150,
      'status': 0, // 未开始
    },
  ];
}
