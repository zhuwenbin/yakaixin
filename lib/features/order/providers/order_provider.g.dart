// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$orderNotifierHash() => r'49304ee8a2cbc81b27a277123dc3f0b33aaf67c1';

/// 订单 Provider
/// 职责:
///   1. 创建订单业务逻辑
///   2. 获取支付方式业务逻辑
///   3. 调用支付业务逻辑
///
/// Copied from [OrderNotifier].
@ProviderFor(OrderNotifier)
final orderNotifierProvider =
    AutoDisposeNotifierProvider<OrderNotifier, OrderState>.internal(
  OrderNotifier.new,
  name: r'orderNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$orderNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OrderNotifier = AutoDisposeNotifier<OrderState>;
String _$orderListHash() => r'98a57d6145d3372162c135147f5989bc3a5c61b5';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$OrderList
    extends BuildlessAutoDisposeAsyncNotifier<List<OrderModel>> {
  late final String status;

  FutureOr<List<OrderModel>> build(
    String status,
  );
}

/// 订单列表 Provider
/// 职责: 获取订单列表并支持分页加载
/// 参数: status - 订单状态 (0:全部 1:待支付 2:已支付 4:已取消)
///
/// Copied from [OrderList].
@ProviderFor(OrderList)
const orderListProvider = OrderListFamily();

/// 订单列表 Provider
/// 职责: 获取订单列表并支持分页加载
/// 参数: status - 订单状态 (0:全部 1:待支付 2:已支付 4:已取消)
///
/// Copied from [OrderList].
class OrderListFamily extends Family<AsyncValue<List<OrderModel>>> {
  /// 订单列表 Provider
  /// 职责: 获取订单列表并支持分页加载
  /// 参数: status - 订单状态 (0:全部 1:待支付 2:已支付 4:已取消)
  ///
  /// Copied from [OrderList].
  const OrderListFamily();

  /// 订单列表 Provider
  /// 职责: 获取订单列表并支持分页加载
  /// 参数: status - 订单状态 (0:全部 1:待支付 2:已支付 4:已取消)
  ///
  /// Copied from [OrderList].
  OrderListProvider call(
    String status,
  ) {
    return OrderListProvider(
      status,
    );
  }

  @override
  OrderListProvider getProviderOverride(
    covariant OrderListProvider provider,
  ) {
    return call(
      provider.status,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'orderListProvider';
}

/// 订单列表 Provider
/// 职责: 获取订单列表并支持分页加载
/// 参数: status - 订单状态 (0:全部 1:待支付 2:已支付 4:已取消)
///
/// Copied from [OrderList].
class OrderListProvider
    extends AutoDisposeAsyncNotifierProviderImpl<OrderList, List<OrderModel>> {
  /// 订单列表 Provider
  /// 职责: 获取订单列表并支持分页加载
  /// 参数: status - 订单状态 (0:全部 1:待支付 2:已支付 4:已取消)
  ///
  /// Copied from [OrderList].
  OrderListProvider(
    String status,
  ) : this._internal(
          () => OrderList()..status = status,
          from: orderListProvider,
          name: r'orderListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$orderListHash,
          dependencies: OrderListFamily._dependencies,
          allTransitiveDependencies: OrderListFamily._allTransitiveDependencies,
          status: status,
        );

  OrderListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
  }) : super.internal();

  final String status;

  @override
  FutureOr<List<OrderModel>> runNotifierBuild(
    covariant OrderList notifier,
  ) {
    return notifier.build(
      status,
    );
  }

  @override
  Override overrideWith(OrderList Function() create) {
    return ProviderOverride(
      origin: this,
      override: OrderListProvider._internal(
        () => create()..status = status,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<OrderList, List<OrderModel>>
      createElement() {
    return _OrderListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderListProvider && other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin OrderListRef on AutoDisposeAsyncNotifierProviderRef<List<OrderModel>> {
  /// The parameter `status` of this provider.
  String get status;
}

class _OrderListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<OrderList, List<OrderModel>>
    with OrderListRef {
  _OrderListProviderElement(super.provider);

  @override
  String get status => (origin as OrderListProvider).status;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
