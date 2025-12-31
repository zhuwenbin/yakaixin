import 'dart:convert';  // ✅ 用于解析JSON字符串
import 'dart:async';  // ✅ 用于 unawaited
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:share_plus/share_plus.dart';  // ✅ 系统分享功能
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/storage/storage_service.dart';  // ✅ 获取用户ID
import '../../exam/services/exam_service.dart';  // ✅ 使用 ExamService 统一提交答案
import '../services/question_service.dart';  // ✅ 使用 QuestionService 获取题目
import '../widgets/question/question_card_swiper.dart';  // ✅ 导入题目轮播组件
import '../widgets/answer_sheet/answer_sheet_dialog.dart';  // ✅ 导入答题卡弹窗
import '../widgets/make_question/error_correction_dialog.dart';  // ✅ 导入纠错弹窗
import '../widgets/question/bottom_toolbar.dart';  // ✅ 导入底部工具栏
import '../../../core/widgets/confirm_dialog.dart';  // ✅ 导入统一对话框组件

/// 做题页面
/// 对应小程序: src/modules/jintiku/pages/makeQuestion/makeQuestion.vue
class MakeQuestionPage extends ConsumerStatefulWidget {
  final Map<String, dynamic>? extra;

  const MakeQuestionPage({
    this.extra,
    super.key,
  });

  @override
  ConsumerState<MakeQuestionPage> createState() => _MakeQuestionPageState();
}

class _MakeQuestionPageState extends ConsumerState<MakeQuestionPage> {
  int _currentIndex = 0;
  bool _showAnswer = false;
  bool _showOnlyError = false;
  bool _isLoading = true;
  // bool _showAnswerSheet = false; // 显示答题卡（已使用新组件替代）
  
  // 路由参数
  String? _knowledgeId;
  String? _type;
  String? _chapterId;
  String? _chapterName;
  String? _professionalId;
  String? _goodsId;
  String? _teachingSystemPackageId;
  
  // 题目数据（从 API 加载）
  List<Map<String, dynamic>> _questions = [];
  List<Map<String, dynamic>> _allQuestions = []; // 备份所有题目（用于只看错题切换）
  int _total = 0;  // 题目总数
  String? _productId; // 产品ID，用于提交答案
  
  // 做题模式：1-答题模式 2-背题模式
  // 对应小程序: makeQuestion.vue Line 133 currentMode
  int _currentMode = 1;
  int _tempMode = 1; // 临时模式（用于确认对话框）
  // 是否支持背题模式（1=支持 2=不支持）
  // 对应小程序: makeQuestion.vue Line 131 recitation_question_model
  int _recitationQuestionModel = 2;
  
  // ✅ 保存切换前的答题状态（用于恢复）
  Map<String, Map<String, dynamic>> _savedAnswerStates = {};
  
  // 做题时间
  final DateTime _startTime = DateTime.now();
  
  // QuestionCardSwiper 控制器
  final GlobalKey _swiperKey = GlobalKey();
  
  // Mock题目数据（备用）
  final List<Map<String, dynamic>> _mockQuestions = [
    {
      'id': '1',
      'question': '牙釉质的主要成分是？',
      'type': '1', // 1=单选 2=多选 3=判断
      'options': [
        {'label': 'A', 'text': '羟基磷灰石'},
        {'label': 'B', 'text': '胶原蛋白'},
        {'label': 'C', 'text': '钙盐'},
        {'label': 'D', 'text': '磷酸钙'},
      ],
      'answer': 'A',
      'analysis': '牙釉质的主要成分是羟基磷灰石，约占釉质重量的96%。',
      'user_answer': null,
      'is_correct': null,
    },
    {
      'id': '2',
      'question': '牙本质小管的走向是？',
      'type': '1',
      'options': [
        {'label': 'A', 'text': '从牙髓向外放射'},
        {'label': 'B', 'text': '从外向牙髓放射'},
        {'label': 'C', 'text': '平行排列'},
        {'label': 'D', 'text': '无规则分布'},
      ],
      'answer': 'A',
      'analysis': '牙本质小管从牙髓腔向外呈放射状排列，贯穿整个牙本质层。',
      'user_answer': null,
      'is_correct': null,
    },
    {
      'id': '3',
      'question': '牙周膜的主要功能包括（多选）',
      'type': '2', // 多选
      'options': [
        {'label': 'A', 'text': '固定牙齿'},
        {'label': 'B', 'text': '缓冲咬合压力'},
        {'label': 'C', 'text': '营养作用'},
        {'label': 'D', 'text': '感觉作用'},
      ],
      'answer': 'ABCD',
      'analysis': '牙周膜具有固定、支持、营养、感觉和修复等多种功能。',
      'user_answer': null,
      'is_correct': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _extractRouteParams();
    _loadQuestions();
    _checkRecitationModel();
  }
  
  @override
  void dispose() {
    // ✅ 不在 dispose 中提交数据，因为此时 Widget 已销毁，无法使用 ref
    // ✅ 提交逻辑已在 _handleBackButton 中处理（用户主动返回时）
    super.dispose();
  }
  
  /// 提取路由参数
  void _extractRouteParams() {
    final extra = widget.extra;
    if (extra != null) {
      _knowledgeId = extra['knowledge_id'] as String?;
      _type = extra['type'] as String?;
      _chapterId = extra['chapter_id'] as String?;
      _chapterName = extra['chapter_name'] as String?;
      _professionalId = extra['professional_id'] as String?;
      _goodsId = extra['goods_id'] as String?;
      _teachingSystemPackageId = extra['teaching_system_package_id'] as String?;
      
      print('📚 [MakeQuestionPage] 路由参数:');
      print('   - knowledgeId: $_knowledgeId');
      print('   - type: $_type');
      print('   - chapterId: $_chapterId');
      print('   - chapterName: $_chapterName');
      print('   - professionalId: $_professionalId');
      print('   - goodsId: $_goodsId');
      print('   - teachingSystemPackageId: $_teachingSystemPackageId');  // ✅ 添加日志
    } else {
      print('⚠️ [MakeQuestionPage] 未接收到路由参数');
    }
  }
  
  /// 检查是否支持背题模式
  /// 对应小程序: makeQuestion.vue Line 254-266 getDetail()
  Future<void> _checkRecitationModel() async {
    if (_goodsId == null) return;
    
    try {
      final service = ref.read(questionServiceProvider);
      // TODO: 调用商品详情接口获取 recitation_question_model
      // final dio = ref.read(dioClientProvider);
      // final response = await dio.get('/c/goods/detail', queryParameters: {
      //   'goods_id': _goodsId,
      // });
      // 
      // if (response.data['code'] == 100000) {
      //   final data = response.data['data'];
      //   setState(() {
      //     _recitationQuestionModel = int.tryParse(data['recitation_question_model']?.toString() ?? '2') ?? 2;
      //   });
      //   print('✅ [背题模式] recitation_question_model: $_recitationQuestionModel');
      // }
      
      // ⚠️ 临时测试：强制开启背题模式
      setState(() {
        _recitationQuestionModel = 1;
      });
      print('✅ [背题模式] 已开启（测试）');
    } catch (e) {
      print('❌ 获取背题模式配置失败: $e');
    }
  }
  
  /// 切换只看错题
  void _toggleErrorOnly() {
    if (!_showOnlyError) {
      // 打开错题模式
      final errorQuestions = _allQuestions.where((q) {
        final userAnswer = q['user_answer']?.toString() ?? '';
        return userAnswer.isNotEmpty && q['is_correct'] == false;
      }).toList();
      
      if (errorQuestions.isEmpty) {
        EasyLoading.showInfo('暂时还没有错题哦！');
        return;
      }
      
      setState(() {
        _showOnlyError = true;
        _questions = errorQuestions;
        _currentIndex = 0;
        _showAnswer = false;
      });
      
      // ✅ 使用 QuestionCardSwiper 跳转
      (_swiperKey.currentState as dynamic)?.jumpToQuestion(0);
    } else {
      // 关闭错题模式，恢复所有题目
      setState(() {
        _showOnlyError = false;
        _questions = _allQuestions;
        _currentIndex = 0;
        _showAnswer = false;
      });
      
      // ✅ 使用 QuestionCardSwiper 跳转
      (_swiperKey.currentState as dynamic)?.jumpToQuestion(0);
    }
  }
  
  /// 切换答题/背题模式
  /// 对应小程序: makeQuestion.vue Line 208-214 changeMode()
  void _handleModeChange(int mode) {
    if (mode == _currentMode) return;
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text('确认切换到${mode == 1 ? '答题模式' : '背题模式'}吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _confirmModeChange(mode);
              },
              child: Text('确定'),
            ),
          ],
        );
      },
    );
  }
  
  /// 确认切换模式
  /// 对应小程序: makeQuestion.vue Line 234-252 confirmChangeTab()
  void _confirmModeChange(int mode) {
    if (mode == 2) {
      // ✅ 切换到背题模式：保存当前答题状态，显示正确答案和解析
      // 对应小程序: Line 239-245
      print('✅ [模式切换] 切换到背题模式');
      
      // 1. 保存当前所有题目的答题状态（用于恢复）
      _savedAnswerStates.clear();
      for (var question in _questions) {
        final questionId = question['id']?.toString();
        if (questionId != null) {
          _savedAnswerStates[questionId] = {
            'user_answer': question['user_answer'],
            'is_correct': question['is_correct'],
          };
        }
      }
      print('💾 [背题模式] 已保存 ${_savedAnswerStates.length} 道题的答题状态');
      
      // 2. 将正确答案填充到 user_answer（用于高亮显示）
      for (var question in _questions) {
        final correctAnswer = question['answer']?.toString();
        if (correctAnswer != null && correctAnswer.isNotEmpty) {
          question['user_answer'] = correctAnswer;
          question['is_correct'] = true; // 标记为正确（绿色高亮）
        }
      }
      
      // 3. 显示解析
      setState(() {
        _currentMode = mode;
        _showAnswer = true;
      });
      
      // ✅ 保持在当前题目，不跳转
      // 对应小程序: Line 239-245 没有跳转逻辑
      
      print('✅ [背题模式] 已显示正确答案和解析');
    } else {
      // ✅ 切换到答题模式：恢复之前的答题状态，隐藏解析
      // 对应小程序: Line 246-251
      print('✅ [模式切换] 切换到答题模式');
      
      // 1. 恢复之前保存的答题状态
      if (_savedAnswerStates.isNotEmpty) {
        for (var question in _questions) {
          final questionId = question['id']?.toString();
          if (questionId != null && _savedAnswerStates.containsKey(questionId)) {
            final savedState = _savedAnswerStates[questionId]!;
            question['user_answer'] = savedState['user_answer'];
            question['is_correct'] = savedState['is_correct'];
          }
        }
        print('🔄 [答题模式] 已恢复 ${_savedAnswerStates.length} 道题的答题状态');
      }
      
      // 2. 隐藏解析
      setState(() {
        _currentMode = mode;
        _showAnswer = false;
      });
      
      // 3. ✅ 强制刷新当前题目（触发QuestionCard重新构建）
      // 通过临时跳转到当前题目，触发PageView重建
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _swiperKey.currentState != null) {
          final currentIdx = _currentIndex;
          (_swiperKey.currentState as dynamic)?.jumpToQuestion(currentIdx);
          print('🔄 [答题模式] 已刷新第 ${currentIdx + 1} 题');
        }
      });
      
      // ✅ 保持在当前题目，不跳转
    }
    
    EasyLoading.showSuccess(mode == 2 ? '已切换到背题模式' : '已切换到答题模式');
  }
  
  /// 加载题目数据
  Future<void> _loadQuestions() async {
    if (_knowledgeId == null || _type == null) {
      print('❌ [MakeQuestionPage] 缺少必要参数');
      setState(() {
        _isLoading = false;
        // 使用Mock数据
        _questions = _mockQuestions;
        _allQuestions = _mockQuestions;
        _total = _mockQuestions.length;
      });
      return;
    }
    
    print('🔍 [MakeQuestionPage] 开始加载题目...');
    EasyLoading.show(status: '加载中...');
    
    try {
      final service = ref.read(questionServiceProvider);
      final result = await service.getQuestionsList(
        knowledgeId: _knowledgeId!,
        type: _type!,
        chapterId: _chapterId,
        teachingSystemPackageId: _teachingSystemPackageId,  // ✅ 添加教学包ID
        professionalId: _professionalId,
      );
      
      final list = result['list'] as List<Map<String, dynamic>>;
      final total = result['total'] as int;
      final productId = result['product_id']?.toString();
      
      print('📦 [MakeQuestionPage] 题目加载成功: ${list.length}道题');
      print('📦 [MakeQuestionPage] product_id: $productId');
      
      // ✅ 拆分配伍题（B1型题）
      // 对应小程序: utils/index.js Line 137-163 transform()
      final transformedList = _transformQuestions(list);
      print('✅ [拆分配伍题] 拆分后共 ${transformedList.length} 个题目');
      
      // 处理题目数据
      final processedQuestions = transformedList.map((item) {
        return _processQuestionData(item);
      }).toList();
      
      setState(() {
        _questions = processedQuestions;
        _allQuestions = processedQuestions;
        _total = total;
        _productId = productId;
        _isLoading = false;
      });
      
      // ⚠️ 关键：在题目列表加载完成后，恢复存储的题目序号
      // 对应小程序: makeQuestion.vue Line 517-522 onShow() → getList().then(() => getStorageNumber())
      await _restoreQuestionProgress();
      
      EasyLoading.dismiss();
    } catch (e) {
      print('❌ [MakeQuestionPage] 加载题目失败: $e');
      EasyLoading.showError('加载失败: $e');
      
      setState(() {
        _isLoading = false;
        // 失败后使用Mock数据
        _questions = _mockQuestions;
        _allQuestions = _mockQuestions;
        _total = _mockQuestions.length;
      });
    }
  }
  
  /// 恢复题目进度（定位到上次做的题目）
  /// 对应小程序: makeQuestion.vue Line 150-175 getStorageNumber()
  Future<void> _restoreQuestionProgress() async {
    try {
      final storageService = ref.read(storageServiceProvider);
      
      // ✅ 读取本地存储: "__questionNumber__"
      final storageDataStr = storageService.getString('__questionNumber__');
      if (storageDataStr == null || storageDataStr.isEmpty) {
        print('ℹ️ [题目定位] 没有存储的进度数据');
        return;
      }
      
      // ✅ 解析JSON
      final Map<String, dynamic> storageData = jsonDecode(storageDataStr);
      
      // ✅ 生成存储ID: "{chapter_id}_{knowledge_id}"
      // 对应小程序: makeQuestion.vue Line 146-148 getStorageId()
      final storageId = '${_chapterId}_$_knowledgeId';
      print('📍 [题目定位] 存储ID: $storageId');
      
      // ✅ 严格类型校验（防NaN/undefined）
      final savedIndex = storageData[storageId];
      if (savedIndex is int && savedIndex >= 0 && savedIndex < _questions.length) {
        setState(() {
          _currentIndex = savedIndex;
        });
        
        // ✅ 使用 QuestionCardSwiper 跳转到指定题目
        await Future.delayed(const Duration(milliseconds: 100));  // 等待Widget构建完成
        (_swiperKey.currentState as dynamic)?.jumpToQuestion(savedIndex);
        
        print('✅ [题目定位] 恢复进度成功: 跳转到第 ${savedIndex + 1} 题');
      } else {
        print('⚠️ [题目定位] 存储的索引无效: $savedIndex (题目总数: ${_questions.length})');
      }
    } catch (e) {
      print('❌ [题目定位] 恢复进度失败: $e');
      // 失败时重置为默认值 (索引0)
      setState(() {
        _currentIndex = 0;
      });
    }
  }
  
  /// 保存题目进度
  /// 对应小程序: makeQuestion.vue Line 178-202 saveQuestionNumber()
  Future<void> _saveQuestionProgress() async {
    if (_chapterId == null || _knowledgeId == null) {
      print('⚠️ [保存进度] 缺少章节ID或知识点ID，跳过保存');
      return;
    }
    
    try {
      final storageService = ref.read(storageServiceProvider);
      
      // ✅ 读取现有存储数据
      final storageDataStr = storageService.getString('__questionNumber__');
      Map<String, dynamic> storageData = {};
      
      if (storageDataStr != null && storageDataStr.isNotEmpty) {
        storageData = jsonDecode(storageDataStr);
      }
      
      // ✅ 生成存储ID: "{chapter_id}_{knowledge_id}"
      final storageId = '${_chapterId}_$_knowledgeId';
      
      // ✅ 更新当前章节的进度
      storageData[storageId] = _currentIndex;
      
      // ✅ 保存到本地存储
      await storageService.setString('__questionNumber__', jsonEncode(storageData));
      
      print('✅ [保存进度] 存储ID: $storageId, 题号: $_currentIndex');
    } catch (e) {
      print('❌ [保存进度] 失败: $e');
    }
  }
  
  /// 拆分配伍题（B1型题）
  /// 对应小程序: utils/index.js Line 137-163 transform()
  /// 
  /// 逻辑:
  /// - 如果 stem_list.length == 1，保持原样
  /// - 如果 stem_list.length > 1（配伍题），拆分成多个独立题目
  ///   每个独立题目只包含一个 stem_list 元素
  /// - 为B1型题添加 group_index（组内索引）和 group_size（组总数）
  List<Map<String, dynamic>> _transformQuestions(List<Map<String, dynamic>> questionList) {
    final List<Map<String, dynamic>> transformedList = [];
    int groupCounter = 0;  // ✅ 记录当前是第几组B1题
    
    for (int i = 0; i < questionList.length; i++) {
      final question = questionList[i];
      final stemList = question['stem_list'] as List?;
      final questionType = question['type']?.toString() ?? '1';
      
      if (stemList == null || stemList.isEmpty) {
        print('⚠️ [拆分配伍题] 第${i + 1}题 stem_list为空，跳过');
        continue;
      }
      
      if (stemList.length == 1) {
        // ✅ 普通题目（单选、多选、判断等），直接添加
        transformedList.add({
          ...question,
          'question_id': question['id'],
          'original_stem_list': stemList,  // ⚠️ 也要保存原始 stem_list
          'current_stem_index': 0,  // 单小题题目，索引为0
          'is_b1_group': false,  // 不是B1配伍题
        });
        print('✅ [拆分配伍题] 第${i + 1}题 普通题目，stem_list=1');
      } else {
        // ✅ 配伍题（B1型题），拆分成多个独立题目
        final isB1 = questionType == '5' || questionType == '16';  // type=5是B1型题
        if (isB1) {
          groupCounter++;  // 增加组计数
        }
        
        print('✅ [拆分配伍题] 第${i + 1}题 配伍题，stem_list=${stemList.length}，type=$questionType，是否B1=$isB1，组号=$groupCounter');
        
        for (int j = 0; j < stemList.length; j++) {
          final singleStem = stemList[j];
          final questionId = question['id'];
          
          // 创建新的独立题目，只包含一个 stem_list
          final splitQuestion = {
            ...question,
            'stem_list': [singleStem],  // ✅ UI显示用：只包含当前子题
            'original_stem_list': stemList,  // ⚠️ 关键：保存原始完整的 stem_list（提交时需要）
            'current_stem_index': j,  // ✅ 当前是第几个小题
            'question_id': questionId,
            'is_b1_group': isB1,  // 是否是B1配伍题
            'b1_group_number': isB1 ? groupCounter : 0,  // B1组号（第几组）
            'b1_sub_index': isB1 ? (j + 1) : 0,  // 组内索引（第几个子题）
            'b1_group_size': isB1 ? stemList.length : 0,  // 组内题目总数
          };
          
          transformedList.add(splitQuestion);
          print('   - 拆分子题 ${j + 1}/${stemList.length}: stem_id=${singleStem['id']}${isB1 ? "，B1第${groupCounter}组第${j + 1}题" : ""}');
        }
      }
    }
    
    return transformedList;
  }
  
  /// 处理题目数据（转换为UI需要的格式）
  /// 对应小程序: makeQuestion.vue Line 402-443
  /// 真实数据结构参考: 章节练习做题.txt
  Map<String, dynamic> _processQuestionData(Map<String, dynamic> rawQuestion) {
    print('📝 [处理题目] 原始数据keys: ${rawQuestion.keys}');
    
    // ✅ 真实数据结构: section_info -> stem_list[0]
    final stemList = rawQuestion['stem_list'] as List?;
    if (stemList == null || stemList.isEmpty) {
      print('⚠️ [处理题目] stem_list为空');
      return rawQuestion;
    }
    
    final stem = stemList[0] as Map<String, dynamic>;
    print('📝 [处理题目] stem数据keys: ${stem.keys}');
    
    // ✅ 处理题干内容（移除HTML标签）
    String questionText = stem['content']?.toString() ?? '';
    questionText = _cleanHtmlContent(questionText);
    
    // ✅ 处理选项列表
    // 真实数据: "option": "[\"<p>选项1</p>\", \"<p>选项2</p>\"]" (JSON字符串数组)
    List<Map<String, dynamic>> options = [];
    
    final optionData = stem['option'];
    if (optionData != null) {
      try {
        // 解析JSON字符串数组
        final List<dynamic> optionList = (optionData is String) 
            ? (jsonDecode(optionData) as List) 
            : (optionData as List);
        
        // 转换为选项格式，添加ABCDE标签
        options = List.generate(optionList.length, (index) {
          String optText = optionList[index].toString();
          optText = _cleanHtmlContent(optText);
          
          return {
            'label': String.fromCharCode(65 + index),  // A, B, C, D, E...
            'text': optText,
          };
        });
        
        print('✅ [处理选项] 解析成功，共${options.length}个选项');
      } catch (e) {
        print('❌ [处理选项] 解析失败: $e');
        print('   原始option数据: $optionData');
      }
    }
    
    // ✅ 处理答案
    // 真实数据: "answer": "[\"3\"]" 或 "[\"0\"]" (JSON字符串数组，索引从0开始)
    String answer = '';
    final answerData = stem['answer'];
    if (answerData != null) {
      try {
        final List<dynamic> answerList = (answerData is String) 
            ? (jsonDecode(answerData) as List) 
            : (answerData as List);
        
        // 将索引转换为ABCDE字母
        answer = answerList.map((idx) {
          final index = int.tryParse(idx.toString()) ?? 0;
          return String.fromCharCode(65 + index);  // 0->A, 1->B, 2->C, 3->D...
        }).join('');
        
        print('✅ [处理答案] 原始: $answerData, 转换后: $answer');
      } catch (e) {
        print('❌ [处理答案] 解析失败: $e');
      }
    }
    
    // ✅ 处理题目类型
    // rawQuestion.type: "1" (1=单选 2=多选 3=判断)
    String questionType = rawQuestion['type']?.toString() ?? '1';
    
    // ✅ 处理解析内容
    // rawQuestion.parse 包含详细解析
    String analysis = rawQuestion['parse']?.toString() ?? '';
    if (analysis.isEmpty) {
      analysis = stem['parse']?.toString() ?? '';
    }
    analysis = _cleanHtmlContent(analysis);
    
    // ✅ 处理主题干（材料题）
    String thematicStem = rawQuestion['thematic_stem']?.toString() ?? '';
    if (thematicStem == '--' || thematicStem.isEmpty) {
      thematicStem = '';
    } else {
      thematicStem = _cleanHtmlContent(thematicStem);
    }
    
    // ✅ 处理用户已选答案（对应小程序的已做题逻辑）
    // 后端数据结构:
    //   - is_answer: "1" 表示已答过
    //   - user_option: JSON字符串，包含所有小题的答题记录
    //     例如: "[{\"sub_question_id\":\"589987774115876307\",\"answer\":[\"1\"]}]"
    String? userAnswer;
    
    // ⚠️ 关键：从顶层 rawQuestion 中获取 user_option（不是从 stem 中）
    final userOptionStr = rawQuestion['user_option']?.toString();
    final isAnswer = rawQuestion['is_answer']?.toString() == '1';
    
    if (isAnswer && userOptionStr != null && userOptionStr.isNotEmpty) {
      try {
        // ✅ 解析 user_option JSON 字符串
        final List<dynamic> userOptionList = jsonDecode(userOptionStr) as List;
        
        // ✅ 根据当前 stem 的 id 查找对应的答题记录
        final stemId = stem['id']?.toString();
        final matchedOption = userOptionList.firstWhere(
          (opt) => opt['sub_question_id']?.toString() == stemId,
          orElse: () => null,
        );
        
        if (matchedOption != null) {
          final answerList = matchedOption['answer'] as List?;
          if (answerList != null && answerList.isNotEmpty) {
            // ✅ 将答案数组转换为字母（如 ["1"] -> "B", ["0","1"] -> "AB"）
            userAnswer = answerList.map((idx) {
              final index = int.tryParse(idx.toString()) ?? 0;
              return String.fromCharCode(65 + index);  // 0->A, 1->B, 2->C...
            }).join('');
            print('✅ [已做题目] stem_id=$stemId, user_option答案=$answerList, 转换为=$userAnswer');
          }
        }
      } catch (e) {
        print('❌ [已做题目] 解析 user_option 失败: $e');
        print('   user_option 内容: $userOptionStr');
      }
    }
    
    final processed = {
      'id': rawQuestion['id']?.toString() ?? rawQuestion['question_id']?.toString() ?? '',
      'question_id': rawQuestion['question_id']?.toString() ?? rawQuestion['id']?.toString() ?? '',  // ✅ 保存 question_id
      'stem_list': rawQuestion['stem_list'],  // ✅ 保存 stem_list （UI显示用）
      'original_stem_list': rawQuestion['original_stem_list'],  // ⚠️ 关键：保存原始完整的小题列表（提交时需要）
      'current_stem_index': rawQuestion['current_stem_index'] ?? 0,  // ⚠️ 关键：保存当前小题索引
      'question': questionText,
      'type': questionType,
      'options': options,
      'answer': answer,
      'analysis': analysis.isNotEmpty ? analysis : '暂无解析',
      'thematic_stem': thematicStem,  // ✅ 材料题题干
      'user_answer': userAnswer,  // ⚠️ 关键修复：从 selected 读取已做题目的答案
      'is_correct': userAnswer != null ? (userAnswer == answer) : null,  // ✅ 如果有答案，判断是否正确
      'is_collected': rawQuestion['is_collect']?.toString() ?? '2',
      'doubt': false,  // ✅ 默认未标疑
      'raw_question': rawQuestion,
      // ✅ B1配伍题信息（在_transformQuestions中添加）
      'is_b1_group': rawQuestion['is_b1_group'] ?? false,
      'b1_group_number': rawQuestion['b1_group_number'] ?? 0,
      'b1_sub_index': rawQuestion['b1_sub_index'] ?? 0,
      'b1_group_size': rawQuestion['b1_group_size'] ?? 0,
    };
    
    print('✅ [处理题目] 处理完成:');
    print('   - ID: ${processed['id']}');
    print('   - question_id: ${processed['question_id']}');
    print('   - 题干: ${questionText.substring(0, questionText.length > 30 ? 30 : questionText.length)}...');
    print('   - 类型: $questionType');
    print('   - 选项数: ${options.length}');
    print('   - 答案: $answer');
    print('   - 材料题干: ${thematicStem.isNotEmpty ? '有' : '无'}');
    print('   - stem_list长度: ${(rawQuestion['stem_list'] as List?)?.length ?? 0}');
    print('   - original_stem_list长度: ${(rawQuestion['original_stem_list'] as List?)?.length ?? 0}');
    print('   - current_stem_index: ${rawQuestion['current_stem_index'] ?? 0}');
    print('   - B1配伍题: ${processed['is_b1_group']}${processed['is_b1_group'] == true ? '（第${processed['b1_group_number']}组第${processed['b1_sub_index']}题）' : ''}');
    
    return processed;
  }
  
  /// 清理HTML内容，移除标签保留文本
  String _cleanHtmlContent(String html) {
    if (html.isEmpty) return '';
    
    String cleaned = html;
    // 移除HTML标签
    cleaned = cleaned.replaceAll(RegExp(r'<[^>]*>'), '');
    // 替换HTML实体
    cleaned = cleaned.replaceAll(RegExp(r'&nbsp;'), ' ');
    cleaned = cleaned.replaceAll(RegExp(r'&lt;'), '<');
    cleaned = cleaned.replaceAll(RegExp(r'&gt;'), '>');
    cleaned = cleaned.replaceAll(RegExp(r'&amp;'), '&');
    cleaned = cleaned.replaceAll(RegExp(r'&quot;'), '"');
    // 移除多余空格和换行
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');
    cleaned = cleaned.trim();
    
    return cleaned;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          title: Text(_chapterName ?? '做题'),
          backgroundColor: AppColors.surface,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox, size: 64.sp, color: AppColors.textHint),
              SizedBox(height: 16.h),
              Text('暂无题目', style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      );
    }
    
    final currentQuestion = _questions[_currentIndex];

    return PopScope(
      // ✅ 禁止手势返回（对应小程序的页面锁定）
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        
        // ✅ 显示返回确认对话框（使用统一样式）
        // 对应小程序 enableAlertBeforeUnload
        final shouldPop = await ConfirmDialog.show(
          context,
          title: '提示',
          content: '好题配好课跟着名师学习开心过',
        );
        
        if (shouldPop != true) return;
        
        // ✅ 异步提交答案（后台执行，不等待）
        unawaited(_submitAnswers());
        
        // ✅ 立即返回页面
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Column(
            children: [
            // 顶部栏
            _buildTopBar(),
            // 题目内容：使用 QuestionCardSwiper 组件
            Expanded(
              child: QuestionCardSwiper(
                key: _swiperKey,
                questions: _questions,
                initialIndex: _currentIndex,
                showAnswer: _showAnswer,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                    _showAnswer = false;
                  });
                  // ✅ 保存题目进度
                  // 对应小程序: makeQuestion.vue Line 203-206 onCurrentChange() → saveQuestionNumber()
                  _saveQuestionProgress();
                },
                onAnswerChanged: (data) {
                  final index = data['index'] as int;
                  final answer = data['answer'] as String;
                  print('👆 [选项点击] 题目${_questions[index]['id']}, 答案: $answer');
                },
              ),
            ),
            // 底部操作栏
            _buildBottomBar(),
          ],
          ),
        ),
      ),
    );
  }

  /// 构建顶部栏
  /// 对应小程序: makeQuestion.vue Line 5-28
  Widget _buildTopBar() {
    return Container(
      padding: AppSpacing.horizontalMd.add(EdgeInsets.symmetric(vertical: 12.h)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          // 返回按钮（使用小程序相同的图标）
          // 小程序尺寸: width: 19rpx, height: 32rpx
          GestureDetector(
            onTap: _handleBackButton,
            child: Image.network(
              'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/169509193147644ed169509193147782088_back.png',
              width: 9.5.w,  // ✅ 小程序 19rpx ÷ 2 = 9.5.w
              height: 16.h,  // ✅ 小程序 32rpx ÷ 2 = 16.h
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // 如果图片加载失败，使用默认图标
                return Icon(Icons.arrow_back, size: 16.sp);
              },
            ),
          ),
          SizedBox(width: 12.w),
          
          // ✅ 只看错题按钮（仅答题模式显示）
          // 对应小程序: Line 11-13 v-if="currentMode == 1"
          if (_currentMode == 1 && _allQuestions.any((q) => q['is_correct'] == false))
            GestureDetector(
              onTap: _toggleErrorOnly,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: _showOnlyError ? AppColors.tikuPrice : AppColors.background,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Text(
                  _showOnlyError ? '全部' : '只看错题',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: _showOnlyError ? AppColors.textWhite : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          
          Spacer(),
          
          // ✅ 答题/背题模式切换（需要商品支持背题模式）
          // 对应小程序: Line 14-23 v-if="recitation_question_model == 1"
          if (_recitationQuestionModel == 1)
            _buildModeSwitch(),
          
          // ✅ 题号（背题模式不显示）
          // 对应小程序: Line 24-27 v-if="recitation_question_model != 1"
          if (_recitationQuestionModel != 1)
            Text(
              '${_currentIndex + 1}/${_questions.length}',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
  
  /// 构建答题/背题模式切换按钮
  /// 对应小程序: makeQuestion.vue Line 16-21
  Widget _buildModeSwitch() {
    return Container(
      height: 32.h,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildModeButton(1, '答题'),
          _buildModeButton(2, '背题'),
        ],
      ),
    );
  }
  
  /// 构建模式按钮
  Widget _buildModeButton(int mode, String label) {
    final isActive = _currentMode == mode;
    return GestureDetector(
      onTap: () => _handleModeChange(mode),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: isActive ? AppColors.textWhite : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
  


  /// 构建底部操作栏
  Widget _buildBottomBar() {
    final currentQuestion = _questions[_currentIndex];
    final userAnswer = currentQuestion['user_answer']?.toString() ?? '';
    final hasAnswer = userAnswer.isNotEmpty;
    // ✅ 修复字段名：统一使用 is_collect（与API返回和更新逻辑一致）
    final isCollected = currentQuestion['is_collect']?.toString() == '1';

    return BottomToolbar(
      // ✅ 问老师（系统分享）- 暂时隐藏
      onAskTeacher: _handleShareQuestion,
      showAskTeacher: false,  // ⚠️ 暂时隐藏"问老师"按钮
      
      // ✅ 重新做题/查看解析
      onToggleAnalysis: _handleToggleAnalysis,
      
      // ✅ 答题卡
      onShowAnswerSheet: _showAnswerSheetDialog,
      
      // ✅ 收藏/取消收藏
      onToggleCollect: () => _toggleCollect(),
      
      // ✅ 纠错
      onErrorCorrection: () => _showErrorCorrectionDialog(),
      
      isCollected: isCollected,
      hasAnswer: hasAnswer,
      showAnalysis: hasAnswer,  // 答题后显示"重新做题"
    );
  }
  
  /// ✅ 处理重新做题/查看解析
  void _handleToggleAnalysis() {
    final currentQuestion = _questions[_currentIndex];
    final userAnswer = currentQuestion['user_answer']?.toString() ?? '';
    
    // ✅ 重新做题（只清空答案，不调用接口，不显示提示）
    if (userAnswer.isNotEmpty) {
      setState(() {
        currentQuestion['user_answer'] = null;
        currentQuestion['is_correct'] = null;
      });
    }
  }
  
  /// ✅ 切换收藏状态
  Future<void> _toggleCollect() async {
    final currentQuestion = _questions[_currentIndex];
    
    try {
      // ✅ 获取题目版本ID
      final questionVersionId = currentQuestion['id']?.toString() ?? '';
      if (questionVersionId.isEmpty) {
        EasyLoading.showError('题目ID为空');
        return;
      }
      
      // ✅ 获取当前收藏状态
      final isCollected = currentQuestion['is_collect'] == '1';
      final newStatus = isCollected ? '2' : '1';  // '1'-收藏, '2'-取消收藏
      
      EasyLoading.show(status: isCollected ? '取消收藏中...' : '收藏中...');
      
      // ✅ 调用API
      final examService = ref.read(examServiceProvider);
      await examService.collectQuestion(
        questionVersionId: questionVersionId,
        status: newStatus,
      );
      
      // ✅ 更新本地状态
      setState(() {
        currentQuestion['is_collect'] = newStatus;
      });
      
      EasyLoading.showSuccess(isCollected ? '已取消收藏' : '收藏成功');
    } catch (e) {
      EasyLoading.showError('操作失败: $e');
    }
  }
  
  /// 显示纠错弹窗
  /// 对应小程序: bottom-utils.vue Line 155-158
  Future<void> _showErrorCorrectionDialog() async {
    final currentQuestion = _questions[_currentIndex];
    
    ErrorCorrectionDialog.show(
      context,
      onSubmit: (data) async {
        try {
          // ✅ 获取题目信息
          final questionId = currentQuestion['question_id']?.toString() ?? currentQuestion['id']?.toString() ?? '';
          final questionVersionId = currentQuestion['id']?.toString() ?? '';
          // ✅ 修复：如果version为空，使用默认值 "1"（避免后端解析uint失败）
          final version = (currentQuestion['version']?.toString() ?? '').isEmpty 
              ? '1' 
              : currentQuestion['version']?.toString() ?? '1';
          
          if (questionId.isEmpty || questionVersionId.isEmpty) {
            EasyLoading.showError('题目信息不完整');
            return;
          }
          
          EasyLoading.show(status: '提交中...');
          
          // ✅ 调用API（明确类型转换）
          final examService = ref.read(examServiceProvider);
          await examService.submitCorrection(
            description: data['description'] as String,
            errType: data['err_type'] as String,
            filePath: (data['file_path'] as List).cast<String>(),  // ✅ 明确类型转换
            questionId: questionId,
            questionVersionId: questionVersionId,
            version: version,
          );
          
          // ✅ 延迟显示成功提示（对应小程序 Line 132-134）
          await Future.delayed(const Duration(milliseconds: 500));
          EasyLoading.showSuccess('感谢您的意见！');
        } catch (e) {
          EasyLoading.showError('提交失败: $e');
        }
      },
    );
  }

  /// 构建底部按钮
  Widget _buildBottomButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,  // ✅ 添加颜色参数，用于标疑状态
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: AppRadius.radiusSm,
        ),
        child: Row(
          children: [
            Icon(
              icon, 
              size: 18.sp, 
              color: color ?? AppColors.textSecondary,  // ✅ 使用自定义颜色
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: color ?? AppColors.textSecondary,  // ✅ 使用自定义颜色
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 切换标疑状态 ✅ 新增
  void _toggleDoubt(Map<String, dynamic> question) {
    setState(() {
      final isDoubt = question['doubt'] == true;
      question['doubt'] = !isDoubt;
    });
    
    final isDoubt = question['doubt'] == true;
    EasyLoading.showSuccess(isDoubt ? '已标记为疑问' : '已取消标疑');
  }
  
  /// 分享题目（问老师）
  /// 对应小程序: bottom-utils.vue 中的 open-type="share"
  /// 使用系统原生分享，可分享到微信、QQ、短信等
  Future<void> _handleShareQuestion() async {
    try {
      final currentQuestion = _questions[_currentIndex];
      
      // ✅ 获取题目信息
      final questionText = currentQuestion['question']?.toString() ?? '';
      final questionType = currentQuestion['type']?.toString() ?? '1';
      final questionNumber = _currentIndex + 1;
      final totalQuestions = _questions.length;
      
      // ✅ 题目类型名称
      String typeName = '';
      switch (questionType) {
        case '1':
          typeName = '单选题';
          break;
        case '2':
          typeName = '多选题';
          break;
        case '3':
          typeName = '判断题';
          break;
        case '4':
          typeName = 'X型题';
          break;
        case '5':
          typeName = 'B1型题';
          break;
        default:
          typeName = '练习题';
      }
      
      // ✅ 截取题目内容（避免过长）
      String shortQuestion = questionText;
      if (questionText.length > 100) {
        shortQuestion = '${questionText.substring(0, 100)}...';
      }
      
      // ✅ 生成分享文本（优化微信兼容性）
      // 关键点：
      // 1. 添加链接（微信更倾向于分享带链接的内容）
      // 2. 精简文本（避免过长）
      // 3. 减少emoji使用（提高兼容性）
      final shareText = '''牙开心题库 - 问老师

【$typeName】第 $questionNumber/$totalQuestions 题

$shortQuestion

我在做这道题，想请教一下老师或同学！

下载牙开心题库App一起学习：
https://yakaixin.yunsop.com/
''';
      
      // ✅ 调用系统分享
      await Share.share(
        shareText,
        subject: '牙开心题库 - 问老师',
      );
      
      print('✅ [分享] 调用系统分享面板成功');
    } catch (e) {
      print('❌ [分享] 分享失败: $e');
      EasyLoading.showError('分享失败');
    }
  }
  
  /// 处理返回按钮点击
  /// ✅ 触发 PopScope 的拦截逻辑，显示确认对话框
  Future<void> _handleBackButton() async {
    // ✅ 显示返回确认对话框（使用统一样式）
    // 对应小程序 enableAlertBeforeUnload
    final shouldPop = await ConfirmDialog.show(
      context,
      title: '提示',
      content: '好题配好课跟着名师学习开心过',
    );
    
    if (shouldPop != true) return;
    
    // ✅ 异步提交答案（后台执行，不等待）
    unawaited(_submitAnswers());
    
    // ✅ 立即返回页面
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
  
  /// 显示答题卡弹窗
  void _showAnswerSheetDialog() {
    AnswerSheetDialog.show(
      context,
      questions: _questions,
      currentIndex: _currentIndex,
      onQuestionTap: (index) {
        // ✅ 更新当前题目索引
        setState(() {
          _currentIndex = index;
        });
        // ✅ 使用 QuestionCardSwiper 跳转
        (_swiperKey.currentState as dynamic)?.jumpToQuestion(index);
        // ✅ 保存题目进度
        _saveQuestionProgress();
      },
    );
  }
  
  /// 提交答案到后端
  /// 对应小程序: makeQuestion.vue Line 346-367
  /// ✅ 静默提交，无论成功失败都不显示任何提示
  /// ✅ 使用 ExamService.submitAnswer() 统一提交（与试卷考试相同）
  Future<void> _submitAnswers() async {
    // ✅ 在方法开始时就读取 service，避免 Widget 销毁后访问 ref
    if (!mounted) return;
    
    // ✅ 使用 ExamService 统一提交（与试卷考试相同）
    final examService = ref.read(examServiceProvider);
    final storage = ref.read(storageServiceProvider);
    
    try {
      // 过滤出已作答的题目
      final answeredQuestions = _allQuestions.where((q) {
        return q['user_answer'] != null && q['user_answer'].toString().isNotEmpty;
      }).toList();
      
      // ✅ 没有答题也静默返回，不提示（对应小程序）
      if (answeredQuestions.isEmpty) {
        return;
      }
      
      // ✅ 构建提交数据（完全参照小程序 setSubmitPageData 格式）
      // 对应小程序: utils/index.js Line 297-324
      
      // ✅ 步骤1: 按 question_id 分组去重（对应小程序 Line 301-307）
      // 小程序逻辑:
      //   第一次遇到: obj[question_id] = item
      //   后续遇到: obj[question_id].stem_list.push(item.stem_list[0])
      final Map<String, Map<String, dynamic>> questionMap = {};
      final Map<String, List<int>> answeredStemIndexes = {};  // 记录每个question_id已答的小题索引
      
      for (final q in answeredQuestions) {
        final questionId = q['question_id']?.toString() ?? '';
        final currentStemIndex = q['current_stem_index'] as int? ?? 0;
        
        if (!questionMap.containsKey(questionId)) {
          // ✅ 第一次遇到这个 question_id，保存整个题目
          questionMap[questionId] = Map<String, dynamic>.from(q);
          answeredStemIndexes[questionId] = [currentStemIndex];
        } else {
          // ✅ 后续遇到相同 question_id，记录答题的小题索引
          answeredStemIndexes[questionId]!.add(currentStemIndex);
        }
      }
      
      print('📊 [分组去重] 原始题目数: ${answeredQuestions.length}, 去重后: ${questionMap.length}');
      answeredStemIndexes.forEach((questionId, indexes) {
        print('   - question_id=$questionId, 已答小题索引: $indexes');
      });
      
      // ✅ 步骤2: 转换为数组（对应小程序 Line 308-311）
      final List<Map<String, dynamic>> groupedQuestions = questionMap.values.toList();
      
      // ✅ 步骤3: 构建 question_info（对应小程序 Line 312-323）
      final questionInfo = groupedQuestions.map((q) {
        // ✅ 小程序使用 question_id 字段（对应 utils/index.js Line 314）
        final questionId = q['question_id']?.toString() ?? '';
        
        // ⚠️ 关键修复：使用 original_stem_list（原始完整的小题列表）
        // 而不是 stem_list（UI显示用的单个小题）
        final originalStemList = q['original_stem_list'] as List? ?? [];
        final currentStemIndex = q['current_stem_index'] as int? ?? 0;
        
        print('📝 [构建提交数据] question_id=$questionId, 原始小题数=${originalStemList.length}, 当前小题索引=$currentStemIndex');
        
        // ✅ 构建 user_option（必须包含所有 sub_question_id）
        final userOption = originalStemList.asMap().entries.map((entry) {
          final index = entry.key;
          final stem = entry.value;
          final subQuestionId = stem['id']?.toString() ?? '';
          
          List<String> answerList = [];
          
          // ⚠️ 关键修复：判断该小题是否在已答列表中
          final answeredIndexes = answeredStemIndexes[questionId] ?? [];
          
          if (answeredIndexes.contains(index)) {
            // ✅ 该小题已答，需要获取答案
            // 从 answeredQuestions 中找到对应的题目
            final answeredQuestion = answeredQuestions.firstWhere(
              (aq) => aq['question_id'] == questionId && aq['current_stem_index'] == index,
              orElse: () => <String, dynamic>{},
            );
            
            if (answeredQuestion.isNotEmpty && answeredQuestion['user_answer'] != null) {
              final userAnswer = answeredQuestion['user_answer'];
              
              if (userAnswer is List) {
                // 多选题：将字母A,B,C转换为索引0,1,2
                answerList = userAnswer.map((e) {
                  final letter = e.toString();
                  final index = letter.codeUnitAt(0) - 65;  // 'A'=65
                  return index.toString();
                }).toList();
              } else if (userAnswer.toString().isNotEmpty) {
                // 单选题：将字母A,B,C转换为索引0,1,2
                final letter = userAnswer.toString();
                final index = letter.codeUnitAt(0) - 65;  // 'A'=65
                answerList = [index.toString()];
              }
            }
            
            print('   - 小题$index (已答): sub_question_id=$subQuestionId, answer=$answerList');
          } else {
            // ✅ 该小题未答，answer为空数组
            answerList = [];
            print('   - 小题$index (未答): sub_question_id=$subQuestionId, answer=[]');
          }
          
          return {
            'sub_question_id': subQuestionId,
            'answer': answerList,  // ✅ 可能是空数组（未答题）
          };
        }).toList();
        
        return {
          'question_id': questionId,
          'cost_time': 1,  // ✅ 每个题目的做题时间（小程序也是固定为1）
          'user_option': userOption,
        };
      }).toList();
      
      // 计算做题时长（秒）
      final costTime = DateTime.now().difference(_startTime).inSeconds;
      
      // ✅ 获取用户ID（必须字段）
      // ⚠️ 注意：小程序中 user_id 和 student_id 是同一个值（都是 student_id）
      // 对应小程序: api/request.js Line 70-71, 148-149
      final studentId = storage.getString('student_id') ?? '';
      final userId = studentId;  // ✅ user_id = student_id
      
      print('📤 [MakeQuestionPage] 提交数据:');
      print('   - type: 1');  // ⚠️ 章节练习固定为 '1'
      print('   - question_info: ${jsonEncode(questionInfo)}');
      print('   - cost_time: $costTime');
      print('   - product_id: $_productId');
      print('   - professional_id: $_professionalId');
      print('   - goods_id: $_goodsId');
      print('   - teaching_system_package_id: $_teachingSystemPackageId');  // ⚠️ 添加日志
      print('   - user_id: $userId');
      print('   - student_id: $studentId');
      
      // ✅ 使用 ExamService.submitAnswer() （与试卷考试完全相同）
      await examService.submitAnswer(
        productId: _productId ?? '',
        professionalId: _professionalId ?? '',
        costTime: costTime,
        type: '1',  // ⚠️ 章节练习固定为 '1'（对应小程序 Line 353）
        questionInfo: jsonEncode(questionInfo),  // ✅ 使用 jsonEncode 而不是 toString()
        goodsId: _goodsId ?? '',
        orderId: '',  // 章节练习没有订单ID
        userId: userId,
        studentId: studentId,
        teachingSystemPackageId: _teachingSystemPackageId,  // ✅ 添加教学包ID
      );
      
      print('✅ [MakeQuestionPage] 答案提交成功');
    } catch (e) {
      print('❌ [MakeQuestionPage] 提交答案失败: $e');
      // 不显示错误提示，静默失败
    }
  }
}
