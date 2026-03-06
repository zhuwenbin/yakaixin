package com.jinyisheng.jinyisheng.android

import android.os.Build
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.lang.reflect.Method

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.jinyisheng.jinyisheng.android/device"
    private var useSoftwareDecoder = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ✅ 禁用 MediaCodec 和 AudioTrack 的调试日志
        disableMediaCodecDebugLogs()

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "isHarmonyOS" -> {
                    val isHarmony = VideoPlayerConfig.isHarmonyOS()
                    Log.d("MainActivity", "检测鸿蒙系统: $isHarmony")
                    result.success(isHarmony)
                }
                "setVideoDecoderType" -> {
                    useSoftwareDecoder = call.argument<Boolean>("useSoftware") ?: false
                    Log.d("MainActivity", "设置解码器类型: useSoftware=$useSoftwareDecoder")
                    // ✅ 注意：video_player 插件可能不支持动态切换解码器
                    // 这里只是记录状态，实际的解码器配置需要在 ExoPlayer 初始化时设置
                    result.success(true)
                }
                "getDeviceInfo" -> {
                    val info = VideoPlayerConfig.getDeviceInfo()
                    result.success(info)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    /**
     * 禁用 MediaCodec 和 AudioTrack 的调试日志
     * 这些日志是 Android 系统底层打印的，不是应用代码打印的
     */
    private fun disableMediaCodecDebugLogs() {
        try {
            // ✅ 通过反射设置系统属性，禁用 MediaCodec 调试日志
            val systemProperties = Class.forName("android.os.SystemProperties")
            val setMethod: Method = systemProperties.getMethod(
                "set",
                String::class.java,
                String::class.java
            )

            // ✅ 禁用 MediaCodec 视频调试日志
            setMethod.invoke(null, "debug.media.codec.video", "0")
            // ✅ 禁用 MediaCodec 音频调试日志
            setMethod.invoke(null, "debug.media.codec.audio", "0")
            // ✅ 禁用 AudioTrack 调试日志
            setMethod.invoke(null, "debug.audio.track", "0")

            Log.d("MainActivity", "已禁用 MediaCodec 和 AudioTrack 调试日志")
        } catch (e: Exception) {
            // ✅ 如果设置失败（可能是权限问题），不影响应用运行
            Log.w("MainActivity", "禁用 MediaCodec 调试日志失败: ${e.message}")
        }
    }
}
