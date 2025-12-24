# Flutter混淆规则

# 保留Flutter相关类
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# 保留Dart方法调用
-keep class io.flutter.embedding.** { *; }

# 保留微信支付SDK
-keep class com.tencent.mm.opensdk.** { *; }
-keep class com.tencent.wxop.** { *; }
-dontwarn com.tencent.mm.**

# 保留Dio网络请求
-keepattributes Signature
-keepattributes *Annotation*
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**

# 保留JSON序列化
-keepclassmembers class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# 保留Kotlin
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-keepclassmembers class **$WhenMappings {
    <fields>;
}
-keepclassmembers class kotlin.Metadata {
    public <methods>;
}

# ✅ 保留 ExoPlayer 视频播放器相关类（防止混淆导致播放失败）
-keep class androidx.media3.** { *; }
-keep interface androidx.media3.** { *; }
-dontwarn androidx.media3.**

# ✅ 保留 MediaCodec 相关类
-keep class android.media.MediaCodec { *; }
-keep class android.media.MediaCodecInfo { *; }
-keep class android.media.MediaFormat { *; }
-dontwarn android.media.**

# ✅ 保留 video_player 插件相关类
-keep class io.flutter.plugins.videoplayer.** { *; }
-dontwarn io.flutter.plugins.videoplayer.**

# 通用规则
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
