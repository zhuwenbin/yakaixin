/// Storage Key常量
class StorageKeys {
  // Token
  static const String token = 'token';
  
  // 用户信息
  static const String userInfo = 'user_info';
  static const String studentId = 'student_id';
  
  // 专业信息
  static const String majorInfo = 'major_info';
  static const String currentMajorId = 'current_major_id';
  
  // 设置
  static const String isFirstLaunch = 'is_first_launch';
  static const String lastLoginTime = 'last_login_time';
  static const String chapterQuestionNumber = 'chapter_question_number'; // 章节练习每次题目数
  
  // Debug 模式 - 环境配置
  static const String debugEnv = 'debug_env';  // ✅ 记录当前环境(prod/test/dev)
  
  // 缓存
  static const String cacheVersion = 'cache_version';
  
  // 答题缓存 (对应小程序: __anwers_list__)
  static const String answersList = 'answers_list';
  
  // 秒杀倒计时 (对应小程序: __tiku_goods_time__)
  static const String seckillCountdownTime = '__tiku_goods_time__';
}
