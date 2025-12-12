/// 百家云直播功能模块
/// 
/// ## 功能说明
/// 
/// 本模块封装了百家云直播的所有功能，包括：
/// - SDK初始化
/// - 进入直播间
/// - 学习数据记录
/// 
/// ## 技术方案
/// 
/// 使用百家云官方Flutter SDK：
/// - 使用 bjy_liveui_flutter 插件
/// - 支持参加码和签名两种进入方式
/// - 原生直播间体验
/// 
/// ## 使用方式
/// 
/// ### 1. 在应用启动时初始化SDK
/// 
/// ```dart
/// // main.dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   
///   // 初始化百家云SDK
///   final container = ProviderContainer();
///   await container.read(liveManagerProvider.notifier).initSDK("your_sdk_key");
///   
///   runApp(MyApp());
/// }
/// ```
/// 
/// ### 2. 进入直播间
/// 
/// ```dart
/// // 从课节列表进入直播
/// await BaijiayunLiveHelper.enterLiveRoom(
///   context: context,
///   ref: ref,
///   lessonId: '课节ID',
///   userName: '用户昵称',
///   userNumber: '用户ID',
///   goodsId: '商品ID',  // 可选
///   orderId: '订单ID',  // 可选
/// );
/// ```
/// 
/// ### 3. 支持的布局模板
/// 
/// - BJYUILayoutTemplate.Triple - 三分屏
/// - BJYUILayoutTemplate.Enterprise - 企业竖屏
/// - BJYUILayoutTemplate.Sell - 直播带货
/// - BJYUILayoutTemplate.Professional - 专业小班课（默认）
/// 
/// ## 模块结构
/// 
/// ```
/// lib/features/live/
/// ├── models/              # 数据模型
/// │   └── live_url_model.dart
/// ├── services/           # 网络服务
/// │   └── live_service.dart
/// ├── providers/          # 状态管理
/// │   └── live_manager.dart
/// ├── views/              # 工具类
/// │   └── baijiayun_live_page.dart
/// └── live_module.dart    # 模块文档(本文件)
/// ```
/// 
/// ## API接口
/// 
/// **获取直播信息**
/// 
/// - **接口**: GET `/c/study/learning/live`
/// - **参数**: `lesson_id` (课节ID)
/// - **返回**: 
///   - `live_url`: 直播地址
///   - `playback_url`: 回放地址
/// 
/// **添加学习数据**
/// 
/// - **接口**: POST `/c/live/data/add`
/// - **参数**: 
///   - `lesson_id`: 课节ID
///   - `goods_id`: 商品ID
///   - `order_id`: 订单ID
/// 
/// ## 注意事项
/// 
/// 1. **SDK初始化**: 必须在进入直播间前调用
/// 2. **学习打卡**: 学习数据记录异步执行，不会阻塞进入直播间
/// 3. **原生体验**: 百家云SDK会打开原生直播间页面
/// 4. **状态管理**: 使用Riverpod管理状态
/// 
library live_module;

export 'models/live_url_model.dart';
export 'services/live_service.dart';
export 'providers/live_manager.dart';
export 'views/baijiayun_live_page.dart';
