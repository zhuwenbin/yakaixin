# 支付功能实现说明

## 概述

Flutter应用的支付功能已完成核心逻辑实现,参照小程序的支付流程。支持微信支付。

## 已实现的文件

### 1. 核心服务层

#### `/lib/core/payment/payment_service.dart`
- 微信支付平台调用服务
- Platform Channel通信(iOS/Android原生支付SDK)
- 支付结果解析
- 微信安装检测

**关键方法:**
```dart
// 发起微信支付
PaymentService.requestWechatPayment({
  required String appId,
  required String timeStamp,
  required String nonceStr,
  required String package,
  required String signType,
  required String paySign,
})

// 检查微信是否安装
PaymentService.isWechatInstalled()
```

### 2. 状态管理层

#### `/lib/features/order/providers/payment_provider.dart`
- Riverpod状态管理
- 完整支付流程编排
- API调用封装

**主要功能:**
```dart
// 创建订单
createOrder({
  required String goodsId,
  required String goodsMonthsPriceId,
  required int months,
  required double payableAmount,
})

// 获取支付账户
getPaymentAccount({
  required String goodsId,
  required String orderId,
})

// 获取微信支付参数
getWechatPayParams({
  required String flowId,
  required String financeBodyId,
})

// 完整支付流程
processPayment({
  required String goodsId,
  required String goodsMonthsPriceId,
  required int months,
  required double payableAmount,
})
```

### 3. UI层(已存在)

#### `/lib/features/order/views/pay_success_page.dart`
- 支付成功页面
- 显示群二维码(根据专业匹配)
- 跳转逻辑(根据商品类型)

## 支付流程

### 小程序支付流程(参考)
```javascript
// 1. 创建订单
getOrderV2({ goods, payable_amount, ... })
  .then(res => {
    // 2. 获取支付方式
    payModeListNew({ order_id, goods_id, ... })
      .then(response => {
        // 3. 获取支付参数
        wechatapplet({ flow_id, wechat_app_id, open_id, ... })
          .then(res => {
            // 4. 调起微信支付
            uni.requestPayment({
              timeStamp, nonceStr, package, signType, paySign
            })
          })
      })
  })
```

### Flutter支付流程
```dart
// 使用 PaymentProvider
final paymentNotifier = ref.read(paymentProvider.notifier);

final success = await paymentNotifier.processPayment(
  goodsId: '商品ID',
  goodsMonthsPriceId: '价格套餐ID',
  months: 12,
  payableAmount: 299.0,
);

if (success) {
  // 跳转支付成功页
  context.push(AppRoutes.paySuccess, extra: {
    'goods_id': goodsId,
    'professional_id_name': '专业名称',
  });
}
```

## API接口

### 1. 创建订单
```
POST /c/order/v2
```
**请求参数:**
- business_scene: 1
- goods: [{ goods_id, goods_months_price_id, months, goods_num }]
- payable_amount: 金额
- student_id: 学生ID
- order_type: 10

**返回:**
- order_id: 订单ID
- flow_id: 流水号
- pay_amount: 支付金额

### 2. 获取支付方式列表
```
GET /c/config/finance/account
```
**查询参数:**
- account_use: 1 (收款)
- account_type: 1 (线上支付)
- order_id: 订单ID
- goods_ids: 商品ID
- merchant_id: 商户ID
- brand_id: 品牌ID

**返回:**
- list: [{ id, pay_method, wechat_pay_app_id }]

### 3. 获取微信支付参数
```
POST /c/pay/wechatpay/jsapi
```
**请求参数:**
- flow_id: 流水号
- wechat_app_id: 微信APPID
- open_id: 用户OpenID
- finance_body_id: 财务主体ID

**返回:**
- app_id: 微信APPID
- time_stamp: 时间戳
- nonce_str: 随机字符串
- package: 预支付ID
- sign_type: 签名类型
- pay_sign: 签名

## 需要原生端实现

### iOS (Swift/Objective-C)

在 `ios/Runner/AppDelegate.swift` 添加:

```swift
import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let paymentChannel = FlutterMethodChannel(name: "com.yakaixin.app/payment",
                                              binaryMessenger: controller.binaryMessenger)
    
    paymentChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      
      if call.method == "wechatPay" {
        // 调用微信支付SDK
        // 需要集成微信SDK: pod 'WechatOpenSDK'
        self?.handleWechatPay(call: call, result: result)
      } else if call.method == "isWechatInstalled" {
        // 检查微信是否安装
        result(WXApi.isWXAppInstalled())
      } else {
        result(FlutterMethodNotImplemented)
      }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func handleWechatPay(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any] else {
      result(FlutterError(code: "INVALID_ARGUMENT", message: "参数错误", details: nil))
      return
    }
    
    let req = PayReq()
    req.partnerId = args["partnerid"] as? String ?? ""
    req.prepayId = args["prepayid"] as? String ?? ""
    req.package = args["package"] as? String ?? ""
    req.nonceStr = args["noncestr"] as? String ?? ""
    req.timeStamp = UInt32(args["timestamp"] as? String ?? "0") ?? 0
    req.sign = args["sign"] as? String ?? ""
    
    WXApi.send(req)
    // 结果通过 onResp 回调处理
  }
}
```

### Android (Kotlin/Java)

在 `android/app/src/main/kotlin/MainActivity.kt` 添加:

```kotlin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.tencent.mm.opensdk.modelpay.PayReq
import com.tencent.mm.opensdk.openapi.WXAPIFactory

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.yakaixin.app/payment"
    private lateinit var wxApi: IWXAPI

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        wxApi = WXAPIFactory.createWXAPI(this, "YOUR_WECHAT_APP_ID")
        wxApi.registerApp("YOUR_WECHAT_APP_ID")
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            when (call.method) {
                "wechatPay" -> {
                    val req = PayReq()
                    req.appId = call.argument<String>("appId") ?: ""
                    req.partnerId = call.argument<String>("partnerId") ?: ""
                    req.prepayId = call.argument<String>("prepayId") ?: ""
                    req.packageValue = call.argument<String>("packageValue") ?: ""
                    req.nonceStr = call.argument<String>("nonceStr") ?: ""
                    req.timeStamp = call.argument<String>("timeStamp") ?: ""
                    req.sign = call.argument<String>("sign") ?: ""
                    
                    wxApi.sendReq(req)
                    result.success(null)
                }
                "isWechatInstalled" -> {
                    result.success(wxApi.isWXAppInstalled)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
```

### 依赖配置

**iOS Podfile:**
```ruby
pod 'WechatOpenSDK'
```

**Android build.gradle:**
```gradle
dependencies {
    implementation 'com.tencent.mm.opensdk:wechat-sdk-android:+'
}
```

## 使用示例

### 在商品详情页调用支付

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class GoodsDetailPage extends ConsumerWidget {
  Future<void> _handleBuyNow(WidgetRef ref) async {
    // 1. 检查微信是否安装
    final isInstalled = await PaymentService.isWechatInstalled();
    if (!isInstalled) {
      EasyLoading.showError('请先安装微信');
      return;
    }

    // 2. 显示加载
    EasyLoading.show(status: '正在创建订单...');

    // 3. 调用支付
    final paymentNotifier = ref.read(paymentProvider.notifier);
    final success = await paymentNotifier.processPayment(
      goodsId: goodsId,
      goodsMonthsPriceId: priceId,
      months: selectedMonths,
      payableAmount: price,
    );

    // 4. 隐藏加载
    EasyLoading.dismiss();

    // 5. 处理结果
    if (success) {
      EasyLoading.showSuccess('支付成功');
      context.push(AppRoutes.paySuccess, extra: {
        'goods_id': goodsId,
        'is_learn_button': false,
      });
    } else {
      EasyLoading.showError('支付失败');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // ...
      floatingActionButton: ElevatedButton(
        onPressed: () => _handleBuyNow(ref),
        child: const Text('立即购买'),
      ),
    );
  }
}
```

## 注意事项

1. **微信APP_ID配置**: 需要在原生代码中配置正确的微信开放平台APPID

2. **支付结果回调**: 微信支付结果通过原生回调返回,需要在AppDelegate/MainActivity中处理

3. **金额为0**: 如果支付金额为0,会直接跳过支付步骤

4. **错误处理**: 所有API调用都包含错误处理和日志输出

5. **Mock模式**: 在开发阶段可以使用Mock数据测试支付流程

## 待完善事项

- [ ] 原生微信SDK集成(iOS & Android)
- [ ] 支付结果回调处理
- [ ] 支付宝支付集成(如需要)
- [ ] 订单查询功能
- [ ] 支付重试机制
- [ ] 支付超时处理

## 测试流程

1. 创建订单
2. 检查订单状态
3. 调起微信支付
4. 等待支付回调
5. 验证支付结果
6. 跳转支付成功页

## 相关文件

- `/lib/core/payment/payment_service.dart` - 支付服务
- `/lib/features/order/providers/payment_provider.dart` - 支付Provider
- `/lib/features/order/views/pay_success_page.dart` - 支付成功页面
- `/lib/app/routes/app_routes.dart` - 路由定义
