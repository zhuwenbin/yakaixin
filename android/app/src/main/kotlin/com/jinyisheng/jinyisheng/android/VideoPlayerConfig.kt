package com.jinyisheng.jinyisheng.android

import android.os.Build
import android.util.Log

/**
 * 视频播放器配置工具类
 * 用于在鸿蒙系统上检测设备信息
 *
 * 注意：video_player 插件内部使用 ExoPlayer，但可能不支持直接配置解码器
 * 这里只提供设备检测功能，用于 Flutter 层做决策
 */

/**
 * 视频播放器配置工具类
 * 用于在鸿蒙系统上优化视频播放器参数
 */
object VideoPlayerConfig {
    private const val TAG = "VideoPlayerConfig"

    /**
     * 检测是否是鸿蒙系统
     */
    fun isHarmonyOS(): Boolean {
        return try {
            // 鸿蒙系统的特征
            val systemProperty = Class.forName("android.os.SystemProperties")
            val getMethod = systemProperty.getMethod("get", String::class.java)
            val harmonyVersion = getMethod.invoke(null, "hw_sc.build.platform.version") as? String
            val harmonyBrand = getMethod.invoke(null, "hw_sc.build.platform.brand") as? String

            // 检查是否是华为设备（鸿蒙系统通常运行在华为设备上）
            val isHuawei = Build.MANUFACTURER.equals("HUAWEI", ignoreCase = true) ||
                          Build.BRAND.equals("HUAWEI", ignoreCase = true) ||
                          Build.MODEL.contains("Mate", ignoreCase = true) ||
                          Build.MODEL.contains("P", ignoreCase = true) ||
                          Build.MODEL.contains("nova", ignoreCase = true)

            val isHarmony = harmonyVersion != null || harmonyBrand != null

            Log.d(TAG, "设备信息: manufacturer=${Build.MANUFACTURER}, brand=${Build.BRAND}, model=${Build.MODEL}")
            Log.d(TAG, "鸿蒙检测: harmonyVersion=$harmonyVersion, harmonyBrand=$harmonyBrand, isHuawei=$isHuawei, isHarmony=$isHarmony")

            isHuawei || isHarmony
        } catch (e: Exception) {
            Log.w(TAG, "检测鸿蒙系统失败: ${e.message}")
            // 如果检测失败，根据设备型号判断（华为设备可能是鸿蒙系统）
            Build.MANUFACTURER.equals("HUAWEI", ignoreCase = true) ||
            Build.BRAND.equals("HUAWEI", ignoreCase = true)
        }
    }

    /**
     * 检查是否应该使用软件解码器
     *
     * 注意：video_player 插件可能不支持动态切换解码器
     * 这个方法主要用于记录和日志，实际的解码器配置需要在 ExoPlayer 初始化时设置
     */
    fun shouldUseSoftwareDecoder(): Boolean {
        val isHarmony = isHarmonyOS()
        Log.d(TAG, "是否使用软件解码器: isHarmonyOS=$isHarmony")
        return isHarmony
    }

    /**
     * 获取设备信息（用于调试）
     */
    fun getDeviceInfo(): String {
        return buildString {
            appendLine("设备信息:")
            appendLine("  Manufacturer: ${Build.MANUFACTURER}")
            appendLine("  Brand: ${Build.BRAND}")
            appendLine("  Model: ${Build.MODEL}")
            appendLine("  Device: ${Build.DEVICE}")
            appendLine("  Product: ${Build.PRODUCT}")
            appendLine("  SDK Version: ${Build.VERSION.SDK_INT}")
            appendLine("  Release: ${Build.VERSION.RELEASE}")
            appendLine("  Is HarmonyOS: ${isHarmonyOS()}")
        }
    }
}
