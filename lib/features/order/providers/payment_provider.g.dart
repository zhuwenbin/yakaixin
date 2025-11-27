// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paymentHash() => r'51972a98274f71faa54dde0dabf4f1a989cd8866';

/// 支付Provider - 处理订单支付流程
/// 对应小程序的支付逻辑
///
/// Copied from [Payment].
@ProviderFor(Payment)
final paymentProvider =
    AutoDisposeAsyncNotifierProvider<Payment, PaymentState>.internal(
  Payment.new,
  name: r'paymentProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$paymentHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Payment = AutoDisposeAsyncNotifier<PaymentState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
