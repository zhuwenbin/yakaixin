# 做题组件库使用文档

## 📦 组件列表

### 1. 基础组件 (common/)

#### HtmlContentView - HTML内容渲染
```dart
HtmlContentView(
  content: '<p>题目内容</p>',
  textStyle: AppTextStyles.bodyMedium,
)
```

#### QuestionTypeTag - 题型标签
```dart
QuestionTypeTag(
  questionType: '1',  // 1/2/3/4/5
  isMultiple: false,
  typeName: 'A1',     // 自定义题型名称（可选）
)
```

---

### 2. 题目组件 (question/)

#### QuestionCard - 单题卡片（推荐使用）⭐
**最核心的组件，包含题干+选项+解析**

```dart
QuestionCard(
  question: questionData,      // Map<String, dynamic>
  questionNumber: 1,           // 题号
  showAnswer: false,           // 是否显示答案
  showAnalysis: false,         // 是否显示解析
  onAnswerChanged: (answer) {
    // 答案变化回调
    print('用户选择: $answer');
  },
)
```

**question 数据结构：**
```dart
{
  'id': '123',
  'type': '1',                // 1=单选 2=多选 3=判断
  'question': '题目内容',
  'options': [
    {'label': 'A', 'text': '选项A'},
    {'label': 'B', 'text': '选项B'},
  ],
  'answer': 'A',              // 正确答案
  'analysis': '解析内容',
  'user_answer': null,        // 用户答案（可选）
  'is_correct': null,         // 是否正确（可选）
  'thematic_stem': '病例...',  // 公用题干（可选）
  'type_name': 'A1',          // 自定义题型名称（可选）
}
```

---

#### QuestionStem - 题干显示
```dart
QuestionStem(
  questionNumber: 1,
  questionType: '1',
  questionContent: '题目内容',
  typeName: 'A1',              // 可选
  thematicStem: '病例描述...',  // 可选
  isMultiple: false,
)
```

---

#### QuestionOptions - 选项列表（智能判断题型）
```dart
QuestionOptions(
  questionType: '1',           // 自动适配单选/多选/判断
  options: [
    {'label': 'A', 'text': '选项A'},
    {'label': 'B', 'text': '选项B'},
  ],
  userAnswer: 'A',
  correctAnswer: 'B',
  showAnswer: false,
  onAnswerChanged: (answer) {
    print('用户选择: $answer');
  },
)
```

---

#### QuestionAnalysis - 答案解析
```dart
QuestionAnalysis(
  correctAnswer: 'A',
  analysis: '解析内容',
  userAnswer: 'B',             // 可选
  isCorrect: false,            // 可选
  statistics: {                // 可选
    'total_answers': 1000,
    'correct_rate': 75,
  },
)
```

---

#### OptionItem - 单个选项
```dart
OptionItem(
  label: 'A',
  content: '选项内容',
  isSelected: true,
  isCorrect: false,
  showResult: true,
  onTap: () {
    print('选项被点击');
  },
)
```

---

## 🎯 使用场景

### 场景1：章节练习做题页面 ✅

```dart
import '../widgets/question/question_card.dart';

class MakeQuestionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: questions.length,
      itemBuilder: (context, index) {
        return QuestionCard(
          question: questions[index],
          questionNumber: index + 1,
          showAnswer: showAnswer,
          showAnalysis: showAnswer,
          onAnswerChanged: (answer) {
            questions[index]['user_answer'] = answer;
          },
        );
      },
    );
  }
}
```

---

### 场景2：查看解析页面

```dart
QuestionCard(
  question: questionData,
  questionNumber: 1,
  showAnswer: true,       // ✅ 显示答案
  showAnalysis: true,     // ✅ 显示解析
  readOnly: true,         // ✅ 只读模式
)
```

---

### 场景3：错题本

```dart
ListView.builder(
  itemCount: wrongQuestions.length,
  itemBuilder: (context, index) {
    return QuestionCard(
      question: wrongQuestions[index],
      questionNumber: index + 1,
      showAnswer: true,
      showAnalysis: true,
    );
  },
)
```

---

### 场景4：自定义组合（高级用法）

```dart
// 如果需要自定义布局，可以单独使用子组件
Column(
  children: [
    QuestionStem(
      questionNumber: 1,
      questionType: '1',
      questionContent: '题目内容',
    ),
    SizedBox(height: 20),
    QuestionOptions(
      questionType: '1',
      options: options,
      correctAnswer: 'A',
      onAnswerChanged: (answer) {},
    ),
    SizedBox(height: 20),
    QuestionAnalysis(
      correctAnswer: 'A',
      analysis: '解析内容',
    ),
  ],
)
```

---

## ✅ 优势

1. **高复用性** - 所有做题场景共用一套组件
2. **智能适配** - QuestionOptions自动判断题型
3. **类型安全** - 完整处理null和类型转换
4. **HTML支持** - 自动移除HTML标签
5. **状态管理** - 支持答题/解析两种模式
6. **易于维护** - 组件职责单一

---

## 📋 题型支持

| 题型代码 | 名称 | 支持状态 |
|---------|------|---------|
| 1 | 单选题 | ✅ |
| 2 | 多选题 | ✅ |
| 3 | 判断题 | ✅ |
| 4 | 填空题 | ⏳ 待实现 |
| 5 | 简答题 | ⏳ 待实现 |

---

## 🔧 扩展方法

### 添加新题型

1. 修改 `QuestionOptions` 组件
2. 添加新的构建方法
3. 在 switch 中添加 case

```dart
case '6':  // 新题型
  return _buildNewTypeOptions();
```

---

## 📝 注意事项

1. **数据格式** - 确保传入的question数据包含所有必需字段
2. **HTML处理** - 题目和选项内容会自动移除HTML标签
3. **答案格式** - userAnswer和correctAnswer都是String类型
4. **多选题** - answer是字母拼接，如"ABC"
5. **回调函数** - onAnswerChanged在每次答案变化时触发

---

## 🚀 快速开始

```dart
// 1. 导入组件
import '../widgets/question/question_card.dart';

// 2. 准备数据
final question = {
  'id': '1',
  'type': '1',
  'question': '牙釉质的主要成分是？',
  'options': [
    {'label': 'A', 'text': '羟基磷灰石'},
    {'label': 'B', 'text': '胶原蛋白'},
  ],
  'answer': 'A',
  'analysis': '牙釉质的主要成分是羟基磷灰石',
};

// 3. 使用组件
QuestionCard(
  question: question,
  questionNumber: 1,
  showAnswer: false,
  onAnswerChanged: (answer) {
    question['user_answer'] = answer;
  },
)
```

---

**组件版本**: v1.1.0  
**最后更新**: 2024-12  
**维护者**: Flutter Team

---

## 📦 新增组件 (v1.1.0)

### QuestionCardSwiper - 题目轮播组件 ⭐

**功能：**
- PageView实现题目滑动切换
- 预加载前后1题（性能优化）
- 自动保存答案
- 页面切换回调

**使用示例：**

```dart
class ExamPage extends StatefulWidget {
  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  final GlobalKey<QuestionCardSwiperState> _swiperKey = GlobalKey();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QuestionCardSwiper(
        key: _swiperKey,
        questions: questionList,
        initialIndex: 0,
        showAnswer: false,
        onPageChanged: (index) {
          print('当前第 ${index + 1} 题');
        },
        onAnswerChanged: (data) {
          print('题目 ${data['index']} 答案: ${data['answer']}');
        },
      ),
      bottomNavigationBar: Row(
        children: [
          ElevatedButton(
            onPressed: () => _swiperKey.currentState?.previousQuestion(),
            child: Text('上一题'),
          ),
          ElevatedButton(
            onPressed: () => _swiperKey.currentState?.nextQuestion(),
            child: Text('下一题'),
          ),
        ],
      ),
    );
  }
}
```

**QuestionCardSwiper 方法：**
- `jumpToQuestion(int index)` - 跳转到指定题目
- `nextQuestion()` - 下一题
- `previousQuestion()` - 上一题
- `currentIndex` - 获取当前题目索引

---

### AnswerSheetDialog - 答题卡弹窗 📋

**功能：**
- 显示所有题目状态（已做/未做/标疑）
- 点击跳转到对应题目
- 完全对照小程序UI样式

**使用示例：**

```dart
ElevatedButton(
  onPressed: () {
    AnswerSheetDialog.show(
      context,
      questions: questionList,
      currentIndex: currentIndex,
      onQuestionTap: (index) {
        // 跳转到指定题目
        swiperKey.currentState?.jumpToQuestion(index);
      },
    );
  },
  child: Text('答题卡'),
)
```

**题目状态显示：**
- 未做：灰色背景 `#F6F6F6`
- 已做：蓝色背景 `#E7F3FE`
- 标疑：橙色背景 `#FB9E0C`

---

## 🎯 完整做题页面示例

```dart
import '../widgets/question/question_card_swiper.dart';
import '../widgets/answer_sheet/answer_sheet_dialog.dart';

class QuestionPaperPage extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  
  const QuestionPaperPage({required this.questions, super.key});
  
  @override
  State<QuestionPaperPage> createState() => _QuestionPaperPageState();
}

class _QuestionPaperPageState extends State<QuestionPaperPage> {
  final GlobalKey<QuestionCardSwiperState> _swiperKey = GlobalKey();
  int _currentIndex = 0;
  bool _showAnswer = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('做题 ${_currentIndex + 1}/${widget.questions.length}'),
        actions: [
          // 答题卡按钮
          IconButton(
            icon: Icon(Icons.grid_view),
            onPressed: () {
              AnswerSheetDialog.show(
                context,
                questions: widget.questions,
                currentIndex: _currentIndex,
                onQuestionTap: (index) {
                  _swiperKey.currentState?.jumpToQuestion(index);
                },
              );
            },
          ),
        ],
      ),
      
      // 题目轮播
      body: QuestionCardSwiper(
        key: _swiperKey,
        questions: widget.questions,
        initialIndex: 0,
        showAnswer: _showAnswer,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        onAnswerChanged: (data) {
          // 自动保存答案
          print('题目 ${data['index']} 答案: ${data['answer']}');
        },
      ),
      
      // 底部操作栏
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // 上一题
            Expanded(
              child: ElevatedButton(
                onPressed: _currentIndex > 0
                    ? () => _swiperKey.currentState?.previousQuestion()
                    : null,
                child: Text('上一题'),
              ),
            ),
            SizedBox(width: 16),
            
            // 查看解析
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showAnswer = !_showAnswer;
                  });
                },
                child: Text(_showAnswer ? '隐藏解析' : '查看解析'),
              ),
            ),
            SizedBox(width: 16),
            
            // 下一题
            Expanded(
              child: ElevatedButton(
                onPressed: _currentIndex < widget.questions.length - 1
                    ? () => _swiperKey.currentState?.nextQuestion()
                    : null,
                child: Text('下一题'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```
