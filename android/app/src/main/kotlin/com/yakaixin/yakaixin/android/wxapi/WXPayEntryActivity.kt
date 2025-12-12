package com.yakaixin.yakaixin.android.wxapi

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import com.tencent.mm.opensdk.modelbase.BaseReq
import com.tencent.mm.opensdk.modelbase.BaseResp
import com.tencent.mm.opensdk.openapi.IWXAPI
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler
import com.tencent.mm.opensdk.openapi.WXAPIFactory

/**
 * 微信支付回调Activity
 * 
 * 注意：
 * 1. 必须放在 {包名}.wxapi 包下
 * 2. 类名必须是 WXPayEntryActivity
 * 3. 在 AndroidManifest.xml 中注册
 * 4. 实现 IWXAPIEventHandler 接口处理微信回调
 */
class WXPayEntryActivity : Activity(), IWXAPIEventHandler {
    
    private var api: IWXAPI? = null
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // 初始化微信API
        api = WXAPIFactory.createWXAPI(this, "wx8e6a5efdf07a69cb")
        api?.handleIntent(intent, this)
    }
    
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        api?.handleIntent(intent, this)
    }
    
    override fun onReq(req: BaseReq?) {
        // 微信发送请求到第三方应用时，会回调到该方法
    }
    
    override fun onResp(resp: BaseResp?) {
        // 微信支付结果回调
        // fluwx 插件会自动处理这个回调，这里只需要finish即可
        finish()
    }
}
