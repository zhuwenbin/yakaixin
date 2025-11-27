import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/home_provider.dart';
import '../../major/providers/major_provider.dart';
import '../../major/widgets/major_selector_dialog.dart';

/// 题库首页
/// 对应小程序: src/modules/jintiku/pages/index/index.vue
class QuestionBankPage extends ConsumerStatefulWidget {
  const QuestionBankPage({super.key});

  @override
  ConsumerState<QuestionBankPage> createState() => _QuestionBankPageState();
}

class _QuestionBankPageState extends ConsumerState<QuestionBankPage> {
  // ✅ 遵守Mock规则: 通过API获取学习数据
  Map<String, dynamic> _learningData = {};
  bool _isLoadingLearningData = true;
  
  // 章节数据
  List<Map<String, dynamic>> _chapterList = [];
  bool _isLoadingChapters = false;
  
  // 已购商品
  List<Map<String, dynamic>> _purchasedGoods = [];
  bool _isLoadingPurchased = false;
  
  // 每日一测
  Map<String, dynamic>? _dailyPractice;
  bool _hasDaily = false;
  
  // 技能模拟
  Map<String, dynamic>? _skillMock;
  bool _hasSkillMock = false;
  
  // 下拉刷新状态
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }
  
  /// 加载所有数据
  /// 对应小程序: updata() 方法
  Future<void> _loadAllData() async {
    print('🔄 题库页面 - 开始加载所有数据');
    
    await Future.wait([
      _loadLearningData(),
      _loadChapters(),
      _loadPurchasedGoods(),
      _loadDailyPractice(),
      _loadSkillMock(),
    ]);
    
    print('✅ 题库页面 - 所有数据加载完成');
  }

  /// 加载学习数据
  /// 对应小程序: apiExamLearningData()
  Future<void> _loadLearningData() async {
    try {
      final majorInfo = ref.read(currentMajorProvider);
      final professionalId = majorInfo?.majorId ?? '524033912737962623';
      
      print('📋 请求学习数据 - 专业ID: $professionalId');
      
      // ✅ 通过API调用（Mock拦截器会自动返回Mock数据）
      final dio = ref.read(dioClientProvider);
      final response = await dio.get(
        '/c/exam/learningData',
        queryParameters: {
          'professional_id': professionalId,
        },
      );
      
      if (response.statusCode == 200 && response.data['code'] == 100000) {
        setState(() {
          _learningData = response.data['data'] as Map<String, dynamic>;
          _isLoadingLearningData = false;
        });
        print('✅ 学习数据加载成功');
      }
    } catch (e) {
      setState(() {
        _isLoadingLearningData = false;
      });
      print('❌ 加载学习数据失败: $e');
    }
  }
  
  /// 加载章节数据
  Future<void> _loadChapters() async {
    try {
      setState(() {
        _isLoadingChapters = true;
      });
      
      final majorInfo = ref.read(currentMajorProvider);
      final professionalId = majorInfo?.majorId ?? '524033912737962623';
      
      print('📋 请求章节数据 - 专业ID: $professionalId');
      
      final dio = ref.read(dioClientProvider);
      final response = await dio.get(
        '/c/exam/chapter/list',
        queryParameters: {
          'professional_id': professionalId,
        },
      );
      
      if (response.statusCode == 200 && response.data['code'] == 100000) {
        setState(() {
          _chapterList = (response.data['data'] as List).cast<Map<String, dynamic>>();
          _isLoadingChapters = false;
        });
        print('✅ 章节数据加载成功: ${_chapterList.length} 条');
      }
    } catch (e) {
      setState(() {
        _isLoadingChapters = false;
      });
      print('❌ 加载章节数据失败: $e');
    }
  }
  
  /// 加载已购商品
  /// 对应小程序: getGoods({is_buyed: 1})
  Future<void> _loadPurchasedGoods() async {
    try {
      setState(() {
        _isLoadingPurchased = true;
      });
      
      final majorInfo = ref.read(currentMajorProvider);
      final professionalId = majorInfo?.majorId ?? '524033912737962623';
      
      print('📋 请求已购商品 - 专业ID: $professionalId');
      
      final dio = ref.read(dioClientProvider);
      final response = await dio.get(
        '/c/goods/v2',
        queryParameters: {
          'professional_id': professionalId,
          'type': '10,8',
          'is_buyed': '1',
        },
      );
      
      if (response.statusCode == 200 && response.data['code'] == 200) {
        setState(() {
          _purchasedGoods = (response.data['data']['list'] as List).cast<Map<String, dynamic>>();
          _isLoadingPurchased = false;
        });
        print('✅ 已购商品加载成功: ${_purchasedGoods.length} 条');
      }
    } catch (e) {
      setState(() {
        _isLoadingPurchased = false;
      });
      print('❌ 加载已购商品失败: $e');
    }
  }
  
  /// 加载每日一测
  /// 对应小程序: getDaily30()
  Future<void> _loadDailyPractice() async {
    try {
      final majorInfo = ref.read(currentMajorProvider);
      final professionalId = majorInfo?.majorId ?? '524033912737962623';
      
      print('📋 请求每日一测 - 专业ID: $professionalId');
      
      final dio = ref.read(dioClientProvider);
      final response = await dio.get(
        '/c/goods/v2',
        queryParameters: {
          'professional_id': professionalId,
          'position_identify': 'daily30',
        },
      );
      
      if (response.statusCode == 200 && response.data['code'] == 100000) {
        final list = response.data['data']['list'] as List;
        setState(() {
          _hasDaily = list.isNotEmpty;
          _dailyPractice = list.isNotEmpty ? list[0] as Map<String, dynamic> : null;
        });
        print('✅ 每日一测加载成功: $_hasDaily');
      }
    } catch (e) {
      setState(() {
        _hasDaily = false;
      });
      print('❌ 加载每日一测失败: $e');
    }
  }
  
  /// 加载技能模拟
  /// 对应小程序: getSkillMock()
  Future<void> _loadSkillMock() async {
    try {
      final majorInfo = ref.read(currentMajorProvider);
      final professionalId = majorInfo?.majorId ?? '524033912737962623';
      
      // 只有特定专业显示技能模拟
      final showSkillMock = professionalId == '524033912737962623' || professionalId == '524033614019566207';
      
      if (!showSkillMock) {
        setState(() {
          _hasSkillMock = false;
        });
        return;
      }
      
      print('📋 请求技能模拟 - 专业ID: $professionalId');
      
      final dio = ref.read(dioClientProvider);
      final response = await dio.get(
        '/c/exam/chapterpackage',
        queryParameters: {
          'professional_id': professionalId,
          'position_identify': 'jinengmoni',
        },
      );
      
      if (response.statusCode == 200 && response.data['code'] == 100000) {
        final data = response.data['data'] as Map<String, dynamic>;
        final hasData = data['id'] != null && data['id'] != 0;
        setState(() {
          _hasSkillMock = hasData;
          _skillMock = hasData ? data : null;
        });
        print('✅ 技能模拟加载成功: $_hasSkillMock');
      }
    } catch (e) {
      setState(() {
        _hasSkillMock = false;
      });
      print('❌ 加载技能模拟失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _handleRefresh,
        child: Stack(
          children: [
            // 渐变背景
            _buildGradientBackground(),
            // 主内容
            _buildContent(),
          ],
        ),
      ),
    );
  }
  
  /// 下拉刷新
  /// 对应小程序: onPullDownRefresh()
  Future<void> _handleRefresh() async {
    print('🔄 开始下拉刷新...');
    await _loadAllData();
    print('✅ 下拉刷新完成');
  }

  /// 渐变背景
  Widget _buildGradientBackground() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 250.h,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB8E8FC),
              Color(0xFFE9F7FF),
            ],
            stops: [0.0, 1.0],
          ),
        ),
      ),
    );
  }

  /// 主内容
  Widget _buildContent() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeader()),
        SliverToBoxAdapter(child: _buildStudyCalendar()),
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        SliverToBoxAdapter(child: _buildStudyCardGrid()),
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        // 每日一测
        if (_hasDaily) ...[  
          SliverToBoxAdapter(child: _buildDailyPractice()),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        ],
        // 章节练习
        SliverToBoxAdapter(child: _buildChapterPractice()),
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        // 技能模拟  
        if (_hasSkillMock) ...[  
          SliverToBoxAdapter(child: _buildSkillMockSection()),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        ],
        // 已购试题
        SliverToBoxAdapter(child: _buildPurchasedQuestions()),
        SliverToBoxAdapter(child: SizedBox(height: 60.h)),
      ],
    );
  }

  /// 顶部专业选择栏
  Widget _buildHeader() {
    // ✅ 从 majorProvider 读取当前专业信息
    final majorInfo = ref.watch(currentMajorProvider);
    final majorName = majorInfo?.majorName ?? '选择专业';
    
    return GestureDetector(
      onTap: () {
        // ✅ 打开专业选择弹窗(与首页保持一致)
        showMajorSelector(
          context,
          onChanged: () {
            // 专业变更后刷新题库数据
            print('🔄 专业变更，重新加载数据...');
            _loadAllData();
          },
        );
      },
      child: Container(
        padding: EdgeInsets.only(top: 60.h, left: 24.w, bottom: 24.h),
        child: Row(
          children: [
            Text(
              majorName,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20.sp,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }

  /// 学习日历卡片
  Widget _buildStudyCalendar() {
    return _StudyCalendarCard(
      learningData: _learningData,
      isLoadingLearningData: _isLoadingLearningData,
      onCheckIn: _handleCheckIn,
    );
  }

  /// 学习卡片网格(绝密押题、科目模考、模拟考试、学习报告)
  Widget _buildStudyCardGrid() {
    final cards = [
      {
        'title': '绝密押题',
        'subtitle': '名师密押 考后即焚',
        'imageUrl': 'https://yakaixin.oss-cn-beijing.aliyuncs.com/public/predictIcon.png',
        'action': () => _handleCardClick(0),
      },
      {
        'title': '科目模考',
        'subtitle': '查漏补缺 直击重点',
        'imageUrl': 'https://yakaixin.oss-cn-beijing.aliyuncs.com/public/test-icon.png',
        'action': () => _handleCardClick(1),
      },
      {
        'title': '模拟考试',
        'subtitle': '全真模拟 还原考场',
        'imageUrl': 'https://yakaixin.oss-cn-beijing.aliyuncs.com/public/exam-icon.png',
        'action': () => _handleCardClick(2),
      },
      {
        'title': '学习报告',
        'subtitle': '实时学习情况',
        'imageUrl': 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/col-4.png',
        'action': () => _handleCardClick(3),
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
        ),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return _buildStudyCard(
            title: card['title'] as String,
            subtitle: card['subtitle'] as String,
            imageUrl: card['imageUrl'] as String,
            onTap: card['action'] as VoidCallback,
          );
        },
      ),
    );
  }

  /// 学习卡片单项
  Widget _buildStudyCard({
    required String title,
    required String subtitle,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            // 图标
            Image.network(
              imageUrl,
              width: 30.w,
              height: 30.w,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image,
                  size: 30.w,
                  color: const Color(0xFFCCCCCC),
                );
              },
            ),
            SizedBox(width: 12.w),
            // 文字
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF999999),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 每日一测
  Widget _buildDailyPractice() {
    if (_dailyPractice == null) {
      return SizedBox.shrink();
    }
    
    final totalQuestions = _dailyPractice!['total_questions'] ?? 30;
    final doneQuestions = _dailyPractice!['done_questions'] ?? 0;
    final name = _dailyPractice!['name'] as String? ?? '每日30题';
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('每日一测'),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: _handleDailyPractice,
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.today, size: 40.w, color: Colors.orange),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '已做 $doneQuestions/$totalQuestions 题',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 24.w, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 章节练习
  Widget _buildChapterPractice() {
    if (_isLoadingChapters) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('章节练习'),
            SizedBox(height: 12.h),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('章节练习'),
          SizedBox(height: 12.h),
          // 显示前3个章节
          ...(_chapterList.take(3).map((chapter) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _buildChapterItem(
              chapter['sectionname'] as String? ?? '',
              '${chapter['question_number']}题',
              '已做${chapter['do_question_num']}题',
              double.tryParse(chapter['correct_rate']?.toString() ?? '0') ?? 0.0,
              () {
                // TODO: 跳转到章节详情
                print('点击章节: ${chapter['sectionname']}');
                EasyLoading.showToast('点击了章节: ${chapter['sectionname']}');
              },
            ),
          ))),
          // 查看更多按钮
          if (_chapterList.length > 3)
            GestureDetector(
              onTap: () {
                // TODO: 跳转到章节列表页
                print('查看全部章节');
                EasyLoading.showToast('查看全部 ${_chapterList.length} 个章节');
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFFE5E5E5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '查看全部 ${_chapterList.length} 个章节',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.arrow_forward_ios, size: 12.sp, color: Colors.blue),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 章节练习单项
  Widget _buildChapterItem(
    String title,
    String totalQuestions,
    String doneQuestions,
    double accuracy,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(
                        totalQuestions,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF999999),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        doneQuestions,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        '正确率 ${accuracy.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 24.w, color: Colors.grey),
          ],
        ),
      ),
    );
  }
  
  /// 技能模拟区域
  Widget _buildSkillMockSection() {
    if (_skillMock == null) {
      return SizedBox.shrink();
    }
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('技能模拟'),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () {
              // TODO: 跳转到技能模拟页面
              print('点击技能模拟: ${_skillMock!['name']}');
              EasyLoading.showToast('点击了技能模拟');
            },
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFF5F7FF),
                    Colors.white,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  // 图标
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.medical_services,
                      size: 30.w,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // 文字
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _skillMock!['name'] as String? ?? '技能模拟',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _skillMock!['description'] as String? ?? '',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF999999),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 24.w, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 已购试题
  Widget _buildPurchasedQuestions() {
    if (_isLoadingPurchased) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('已购试题'),
            SizedBox(height: 12.h),
            Center(child: CircularProgressIndicator()),
          ],
        ),
      );
    }
    
    if (_purchasedGoods.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('已购试题'),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(40.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.inbox_outlined, size: 50.sp, color: Colors.grey.shade300),
                    SizedBox(height: 12.h),
                    Text(
                      '暂无已购试题',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('已购试题'),
          SizedBox(height: 12.h),
          ...(_purchasedGoods.map((goods) {
            final name = goods['name'] as String? ?? '未知商品';
            final coverPath = goods['material_cover_path'] as String? ?? '';
            final imageUrl = coverPath.startsWith('http') 
                ? coverPath 
                : 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/$coverPath';
            
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildPurchasedItem(
                name,
                '3580题', // TODO: 从商品数据获取
                imageUrl,
              ),
            );
          })),
        ],
      ),
    );
  }

  /// 已购试题单项
  Widget _buildPurchasedItem(
    String title,
    String questionCount,
    String imageUrl,
  ) {
    return GestureDetector(
      onTap: () {
        // TODO: 跳转到试题详情
        print('点击已购试题: $title');
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                imageUrl,
                width: 80.w,
                height: 60.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80.w,
                    height: 60.h,
                    color: const Color(0xFFF5F5F5),
                    child: Icon(Icons.image, color: Colors.grey),
                  );
                },
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    questionCount,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 24.w, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  /// 分段标题
  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Image.network(
          'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/title-icon.png',
          width: 15.w,
          height: 15.w,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.star, size: 15.w, color: Colors.blue);
          },
        ),
        SizedBox(width: 5.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  // ==================== 事件处理 ====================

  /// 处理打卡
  /// ✅ 遵守Mock规则: 通过API调用打卡接口
  Future<void> _handleCheckIn() async {
    // 如果已经打卡或正在加载，不处理
    if (_learningData['is_checkin'] == 1 || _isLoadingLearningData) {
      return;
    }
    
    try {
      final majorInfo = ref.read(currentMajorProvider);
      final professionalId = majorInfo?.majorId ?? '524033912737962623';
      
      EasyLoading.show(status: '打卡中...');
      
      print('📋 请求打卡 - 专业ID: $professionalId');
      
      // ⚠️ 先设置加载状态
      setState(() {
        _isLoadingLearningData = true;
      });
      
      // ✅ 通过API调用打卡（Mock拦截器会自动返回Mock数据）
      final dio = ref.read(dioClientProvider);
      final response = await dio.post(
        '/c/exam/checkinData',
        data: {
          'professional_id': professionalId,
        },
      );
      
      EasyLoading.dismiss();
      
      if (response.statusCode == 200 && response.data['code'] == 100000) {
        EasyLoading.showSuccess('打卡成功');
        
        // 重新加载学习数据，这会自动更新UI
        await _loadLearningData();
        
        print('✅ 打卡成功，状态已更新');
      } else {
        setState(() {
          _isLoadingLearningData = false;
        });
        final msg = response.data['msg'];
        final message = msg is List && msg.isNotEmpty ? msg[0] : '打卡失败';
        EasyLoading.showError(message);
      }
    } catch (e) {
      setState(() {
        _isLoadingLearningData = false;
      });
      EasyLoading.dismiss();
      EasyLoading.showError('打卡失败');
      print('❌ 打卡失败: $e');
    }
  }

  /// 处理卡片点击
  void _handleCardClick(int type) {
    switch (type) {
      case 0:
        // 绝密押题 - 跳转到历年真题详情页
        _navigateToGoodsDetail('linianzhenti', AppRoutes.secretRealDetail);
        break;
      case 1:
        // 科目模考 - 跳转到科目模考详情页
        _navigateToGoodsDetail('kemumokao', AppRoutes.subjectMockDetail);
        break;
      case 2:
        // 模拟考试 - 跳转到模拟考场页
        _navigateToGoodsDetail('monikaoshi', AppRoutes.simulatedExamRoom);
        break;
      case 3:
        // 学习报告 - 跳转到报告中心
        context.push(AppRoutes.reportCenter);
        break;
    }
  }

  /// 跳转到商品详情页
  /// ✅ 遵守Mock规则: 通过API调用,由Mock拦截器返回Mock数据
  Future<void> _navigateToGoodsDetail(String positionIdentify, String routePath) async {
    try {
      EasyLoading.show(status: '加载中...');
      
      // 获取当前用户的专业ID
      final authState = ref.read(authProvider);
      final professionalId = authState.currentMajor?.majorId ?? '';
      
      // ✅ 通过API获取商品数据 (Mock拦截器会自动返回Mock数据)
      final goodsService = ref.read(goodsServiceProvider);
      final response = await goodsService.getGoodsByPosition(
        positionIdentify: positionIdentify,
        professionalId: professionalId.isNotEmpty ? professionalId : null,
      );
      
      EasyLoading.dismiss();
      
      if (response.list.isEmpty) {
        EasyLoading.showToast('暂无数据');
        return;
      }
      
      final firstGoods = response.list[0];
      
      // 跳转到对应的详情页
      context.push(
        routePath,
        extra: {
          'product_id': firstGoods.goodsId?.toString() ?? '',
          'professional_id': professionalId,
        },
      );
      
      print('📦 跳转到: $routePath, productId: ${firstGoods.goodsId}');
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('加载失败: ${e.toString()}');
      print('❌ 获取商品数据失败: $e');
    }
  }

  /// 处理每日一测点击
  void _handleDailyPractice() {
    // TODO: 调用API获取每日30题数据，跳转到做题页面
    context.push(AppRoutes.makeQuestion);
    print('点击了每日一测');
  }
}

// ==================== 独立 Widget 组件 ====================

/// 学习日历卡片
class _StudyCalendarCard extends StatelessWidget {
  final Map<String, dynamic> learningData;
  final bool isLoadingLearningData;
  final VoidCallback onCheckIn;

  const _StudyCalendarCard({
    required this.learningData,
    required this.isLoadingLearningData,
    required this.onCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    final checkinNum = learningData['checkin_num'] ?? 0;
    final totalNum = learningData['total_num'] ?? 0;
    final correctRate = learningData['correct_rate'] ?? '0';
    final isCheckin = learningData['is_checkin'] == 1;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                SizedBox(height: 20.h),
                _buildStatsRow(checkinNum, totalNum, correctRate),
                SizedBox(height: 20.h),
                _buildCheckInButton(isCheckin, onCheckIn),
              ],
            ),
          ),
          _buildDecoration(),
          _buildCheckInStatus(isCheckin),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      '学习日历',
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF333333),
      ),
    );
  }

  Widget _buildStatsRow(int checkinNum, int totalNum, String correctRate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _StatItem(label: '坚持打卡', value: '$checkinNum', unit: '天'),
        _buildDivider(),
        _StatItem(label: '做题总数', value: '$totalNum', unit: '题'),
        _buildDivider(),
        _StatItem(label: '正确率', value: correctRate, unit: '%'),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40.h,
      color: const Color(0xFFE5E5E5),
    );
  }

  Widget _buildCheckInButton(bool isCheckin, VoidCallback onCheckIn) {
    // ⚠️ 加载中时禁用按钮
    final isDisabled = isCheckin || isLoadingLearningData;
    
    return GestureDetector(
      onTap: isDisabled ? null : onCheckIn,
      child: Container(
        width: double.infinity,
        height: 44.h,
        decoration: BoxDecoration(
          color: isCheckin ? const Color(0xFFFFEEE7) : const Color(0xFFFF5500),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: isLoadingLearningData
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCheckin ? const Color(0xFFF44900) : Colors.white,
                    ),
                  ),
                )
              : Text(
                  isCheckin ? '已打卡' : '打卡',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: isCheckin ? const Color(0xFFF44900) : Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDecoration() {
    return Positioned(
      top: 0,
      right: 0,
      child: Image.network(
        'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/study-card-color.png',
        width: 130.w,
        height: 32.h,
        opacity: const AlwaysStoppedAnimation(0.8),
        errorBuilder: (context, error, stackTrace) {
          return SizedBox(width: 130.w, height: 32.h);
        },
      ),
    );
  }

  Widget _buildCheckInStatus(bool isCheckin) {
    return Positioned(
      top: 0,
      right: 0,
      width: 130.w,
      height: 32.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/study-card-zan.png',
            width: 16.w,
            height: 16.w,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                isCheckin ? Icons.check_circle : Icons.circle_outlined,
                size: 16.w,
                color: const Color(0xFF666666),
              );
            },
          ),
          SizedBox(width: 4.w),
          Text(
            isCheckin ? '今日已打卡' : '今日未打卡',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}

/// 统计项组件
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _StatItem({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFF5500),
              ),
            ),
            SizedBox(width: 2.w),
            Text(
              unit,
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF999999),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF666666),
          ),
        ),
      ],
    );
  }
}
