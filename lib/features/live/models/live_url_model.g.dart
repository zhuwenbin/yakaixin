// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_url_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LiveUrlResponseImpl _$$LiveUrlResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$LiveUrlResponseImpl(
      liveUrl: json['live_url'] as String?,
      playbackUrl: json['playback_url'] as String?,
      goodsId: json['goods_id'] as String?,
      lessonId: json['lesson_id'] as String?,
    );

Map<String, dynamic> _$$LiveUrlResponseImplToJson(
        _$LiveUrlResponseImpl instance) =>
    <String, dynamic>{
      'live_url': instance.liveUrl,
      'playback_url': instance.playbackUrl,
      'goods_id': instance.goodsId,
      'lesson_id': instance.lessonId,
    };
