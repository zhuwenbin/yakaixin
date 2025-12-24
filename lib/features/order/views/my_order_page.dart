import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import '../models/order_model.dart';
import '../providers/order_provider.dart';
import '../providers/payment_provider.dart';
import '../../../app/routes/app_routes.dart';
import '../../../../app/config/api_config.dart';
import '../../../core/widgets/common_state_widget.dart';
import '../../../core/utils/error_message_mapper.dart';

/// 我的订单页面
/// 对应小程序: src/modules/jintiku/pages/test/order.vue
class MyOrderPage extends ConsumerStatefulWidget {
  const MyOrderPage({super.key});

  @override
  ConsumerState<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends ConsumerState<MyOrderPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _currentStatus = '0';

  // 订单状态Tab (对应小程序的tab数组)
  final List<Map<String, String>> _tabs = [
    {'id': '0', 'name': '全部'},
    {'id': '2', 'name': '已支付'},
    {'id': '1', 'name': '待支付'},
    {'id': '4', 'name': '已取消'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        _currentStatus = _tabs[_tabController.index]['id']!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F8),
      appBar: AppBar(
        title: Text('我的订单'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Tab 栏
          _buildTabBar(),
          // 订单列表
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabs.map((tab) {
                return _OrderListView(status: tab['id']!);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建Tab栏
  /// 对应小程序: .tab 样式
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = _tabController.index == index;

          return GestureDetector(
            onTap: () => _tabController.animateTo(index),
            child: Text(
              tab['name']!,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? Color(0xFF1A1B1C) : Color(0xFF686F81),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// 订单列表视图
/// 对应小程序: order-list.vue组件
class _OrderListView extends ConsumerStatefulWidget {
  final String status;

  const _OrderListView({required this.status});

  @override
  ConsumerState<_OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends ConsumerState<_OrderListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      // 距离底部100px时加载更多
      ref.read(orderListProvider(widget.status).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(orderListProvider(widget.status));

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(orderListProvider(widget.status).notifier).refresh();
      },
      child: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return _buildEmptyView();
          }

          return ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.all(16.w),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return _OrderItem(order: orders[index]);
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          // ✅ 使用统一的错误信息提取工具
          final errorMessage = ErrorMessageMapper.extractUserFriendlyMessage(
            error,
            '加载订单列表失败',
          );
          
          return CommonStateWidget.loadError(
            message: errorMessage,
            onRetry: () => ref.read(orderListProvider(widget.status).notifier).refresh(),
          );
        },
      ),
    );
  }

  /// 构建空视图
  /// 对应小程序: .not_data 样式
  Widget _buildEmptyView() {
    return CommonStateWidget.noOrder();
  }
}

/// 订单项组件
/// 对应小程序: order-list.vue 的 .item 样式
class _OrderItem extends ConsumerWidget {
  final OrderModel order;

  const _OrderItem({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15.r,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 倒计时（如果是待支付且有倒计时）
          if (order.status == '1' && _getCountdownSeconds(order.countdown) > 0)
            _buildCountdown(),
          // 订单号和状态
          _buildOrderInfo(),
          // 商品名称
          _buildGoodsName(),
          // 标签（题数、月数）
          _buildTags(),
          // 提示信息
          if (order.tips != null && order.tips!.isNotEmpty) _buildTips(),
          // 价格信息
          _buildPriceInfo(),
          // 操作按钮（待支付订单）
          if (order.status == '1') _buildActionButtons(context, ref, order),
        ],
      ),
    );
  }

  /// 构建倒计时
  Widget _buildCountdown() {
    return Container(
      width: 146.w,
      height: 22.h,
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            ApiConfig.completeImageUrl('public/4d97173977183148137274_timeback.png'),
          ),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 8.w),
      child: Text(
        _formatCountdown(_getCountdownSeconds(order.countdown)),
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: Color(0xFF2E68FF),
        ),
      ),
    );
  }
  
  /// ✅ 安全获取倒计时秒数（dynamic 转 int）
  int _getCountdownSeconds(dynamic countdown) {
    if (countdown == null) return 0;
    if (countdown is int) return countdown;
    if (countdown is String) {
      return int.tryParse(countdown) ?? 0;
    }
    return 0;
  }

  /// 格式化倒计时
  String _formatCountdown(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  /// 构建订单信息
  Widget _buildOrderInfo() {
    return Container(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ✅ 使用 Expanded 包裹订单号区域，防止溢出
          Expanded(
            child: Row(
              children: [
                // ✅ 订单号使用 Flexible，允许收缩
                Flexible(
                  child: Text(
                    order.orderNo,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Color(0xFF03203D).withOpacity(0.65),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () => _copyOrderNo(order.orderNo),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Color(0xFF03203D).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(9.r),
                    ),
                    child: Text(
                      '复制',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Color(0xFF03203D).withOpacity(0.75),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          // ✅ 状态文字不换行
          Text(
            order.statusName,
            style: TextStyle(
              fontSize: 12.sp,
              color: Color(0xFF03203D).withOpacity(0.55),
            ),
          ),
        ],
      ),
    );
  }

  /// 复制订单号
  void _copyOrderNo(String orderNo) {
    Clipboard.setData(ClipboardData(text: orderNo));
    EasyLoading.showSuccess('复制成功');
  }

  /// 构建商品名称
  Widget _buildGoodsName() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        order.goodsName,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: Color(0xFF212121),
        ),
      ),
    );
  }

  /// 构建标签
  Widget _buildTags() {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 12.h),
      child: Row(
        children: [
          if (order.numText != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Color(0xFFEBF1FF),
                borderRadius: BorderRadius.circular(2.r),
              ),
              child: Text(
                order.numText!,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Color(0xFF2E68FF),
                ),
              ),
            ),
          if (order.monthText != null) ...[
            SizedBox(width: 6.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(2.r),
              ),
              child: Text(
                order.monthText!,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Color(0xFF2C373D).withOpacity(0.71),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 构建提示信息
  Widget _buildTips() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        order.tips!,
        style: TextStyle(
          fontSize: 12.sp,
          color: Color(0xFF03203D).withOpacity(0.65),
        ),
      ),
    );
  }

  /// 构建价格信息
  Widget _buildPriceInfo() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE8E9EA), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '共1件商品，实付款：',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF29415A),
            ),
          ),
          Text(
            '¥ ${order.payableAmount}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: Color(0xFFFF5430),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButtons(BuildContext context, WidgetRef ref, OrderModel order) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => _handleOrderPayment(context, ref, order),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFF83131), width: 1),
                borderRadius: BorderRadius.circular(22.r),
              ),
              child: Text(
                '去支付',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Color(0xFFFF5430),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 处理订单支付
  /// 对应小程序: order-list.vue Line 224-261 (getPayModeListNew)
  /// 
  /// 关键：
  /// - ❌ 不再创建订单（订单已存在）
  /// - ✅ 直接使用订单中的 orderId 和 flowId 继续支付
  /// - ✅ orderId 回退逻辑: order.orderId ?? order.id（对应小程序 Line 233）
  void _handleOrderPayment(BuildContext context, WidgetRef ref, OrderModel order) async {
    try {
      print('\n💳 ========== 订单支付调试 ==========');
      print('📦 订单原始数据:');
      print('   order.id: ${order.id}');
      print('   order.orderId: ${order.orderId}');
      print('   order.flowId: ${order.flowId}');
      print('   order.goodsId: ${order.goodsId}');
      print('   order.status: ${order.status} (${order.statusName})');
      print('   order.payableAmount: ${order.payableAmount}');
      
      // ✅ 使用回退逻辑获取orderId（对应小程序 obj.order_id || obj.id）
      // ⚠️ 注意：order.orderId 可能是 0（而不是 null），所以需要额外判断
      final orderIdDynamic = (order.orderId == null || order.orderId.toString() == '0') 
          ? order.id 
          : order.orderId;
      final orderId = orderIdDynamic?.toString() ?? '';
      
      final flowId = order.flowId?.toString() ?? '';
      final goodsId = order.goodsId?.toString() ?? '';
      final amount = double.tryParse(order.payableAmount) ?? 0.0;

      print('\n🔄 处理后的数据:');
      print('   orderId: $orderId (来源: ${order.orderId != null && order.orderId.toString() != "0" ? "order_id" : "id"})');
      print('   flowId: $flowId');
      print('   goodsId: $goodsId');
      print('   amount: $amount');

      // ✅ 检查订单ID
      if (orderId.isEmpty || orderId == '0') {
        print('❌ 错误: 订单ID为空或0');
        EasyLoading.showError('订单ID不能为空');
        return;
      }

      // ⚠️ flowId检查 - 可能某些订单没有flow_id（已完成的订单）
      if (flowId.isEmpty || flowId == '0') {
        print('❌ 错误: 流水ID为空或0（该订单可能已完成或未生成流水）');
        EasyLoading.showError('该订单无法支付，流水ID不存在');
        return;
      }

      print('\n✅ 参数校验通过，准备支付...');

      // ✅ 0元订单直接跳转成功页
      if (amount == 0) {
        context.push(
          AppRoutes.paySuccess,
          extra: {
            'goods_id': goodsId,
            'order_id': orderId,
            'isLearnButton': 1,
          },
        );
        return;
      }

      // ✅ 直接跳转到确认付款页面（不需要预先获取支付参数）
      if (context.mounted) {
        print('\n🚀 跳转到确认付款页面...');
        
        context.push(AppRoutes.confirmPayment, extra: {
          'goods_id': goodsId,
          'goods_name': order.goodsName,
          'goods_months_price_id': null,
          'months': 0, // TODO: 从订单中获取
          'payable_amount': amount,
          'order_id': orderId,  // ✅ 传递订单ID
          'flow_id': flowId,    // ✅ 传递流水ID
          'finance_body_id': '',  // ✅ 继续支付时暂无finance_body_id，后台会根据订单查询
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('支付失败: $e');
      print('❌ 订单支付失败: $e');
    }
  }
}
