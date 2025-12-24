import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common_state_widget.dart';

/// CommonStateWidget 使用示例
/// 
/// 本文件展示了如何在不同场景下使用统一的状态组件
class CommonStateWidgetExample extends StatelessWidget {
  const CommonStateWidgetExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CommonStateWidget 示例')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('场景1: 网络错误（断网）', _Example1()),
          _buildSection('场景2: 加载失败（服务器错误）', _Example2()),
          _buildSection('场景3: 自定义错误消息', _Example3()),
          _buildSection('场景4: 空数据', _Example4()),
          _buildSection('场景5: 暂无订单', _Example5()),
          _buildSection('场景6: 暂无课程', _Example6()),
          _buildSection('场景7: 暂无收藏', _Example7()),
          _buildSection('场景8: 暂无错题', _Example8()),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget example) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: example,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

// ==================== 示例1: 网络错误 ====================
class _Example1 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CommonStateWidget.networkError(
      onRetry: () {
        // ✅ 重试网络请求
        print('重试网络请求');
      },
    );
  }
}

// ==================== 示例2: 加载失败 ====================
class _Example2 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CommonStateWidget.loadError(
      message: '服务器繁忙，请稍后重试',
      onRetry: () {
        // ✅ 重新加载数据
        print('重新加载数据');
      },
    );
  }
}

// ==================== 示例3: 自定义错误 ====================
class _Example3 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CommonStateWidget.error(
      title: '支付失败',
      message: '订单已过期，请重新下单',
      onRetry: () {
        // ✅ 返回上一页或重新下单
        Navigator.pop(context);
      },
    );
  }
}

// ==================== 示例4: 空数据 ====================
class _Example4 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CommonStateWidget.empty(
      message: '暂无搜索结果',
    );
  }
}

// ==================== 示例5: 暂无订单 ====================
class _Example5 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CommonStateWidget.noOrder();
  }
}

// ==================== 示例6: 暂无课程 ====================
class _Example6 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CommonStateWidget.noCourse(
      onAction: () {
        // ✅ 跳转到课程页
        print('跳转到课程页');
      },
    );
  }
}

// ==================== 示例7: 暂无收藏 ====================
class _Example7 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CommonStateWidget.noCollection();
  }
}

// ==================== 示例8: 暂无错题 ====================
class _Example8 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CommonStateWidget.noWrongQuestion();
  }
}

// ==================== 实际应用示例 ====================

/// 示例：在订单页面中使用
class OrderPageExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final ordersAsync = ref.watch(orderListProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('我的订单')),
      body: Container(), // ordersAsync.when(
        // data: (orders) {
        //   if (orders.isEmpty) {
        //     // ✅ 使用统一的空状态组件
        //     return CommonStateWidget.noOrder();
        //   }
        //   return ListView.builder(/* ... */);
        // },
        // loading: () => const Center(child: CircularProgressIndicator()),
        // error: (error, stack) {
        //   // ✅ 使用统一的错误组件
        //   return CommonStateWidget.loadError(
        //     message: error.toString(),
        //     onRetry: () => ref.read(orderListProvider.notifier).refresh(),
        //   );
        // },
      // ),
    );
  }
}

/// 示例：在商品详情页中使用
class GoodsDetailPageExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final state = ref.watch(goodsDetailProvider);
    final state = _MockState(
      isLoading: false,
      error: '网络连接失败，请检查网络设置后重试',
      goodsDetail: null,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('商品详情')),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? CommonStateWidget.networkError(
                  onRetry: () {
                    // ref.read(goodsDetailProvider.notifier).refresh();
                  },
                )
              : state.goodsDetail != null
                  ? Container() // _buildContent(state.goodsDetail!)
                  : CommonStateWidget.empty(),
    );
  }
}

// Mock state for example
class _MockState {
  final bool isLoading;
  final String? error;
  final dynamic goodsDetail;

  _MockState({
    required this.isLoading,
    this.error,
    this.goodsDetail,
  });
}
