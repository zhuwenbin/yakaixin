// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paper_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaperModelImpl _$$PaperModelImplFromJson(Map<String, dynamic> json) =>
    _$PaperModelImpl(
      id: json['id'],
      name: json['name'] as String?,
      paperExerciseId: json['paper_exercise_id'] as String?,
    );

Map<String, dynamic> _$$PaperModelImplToJson(_$PaperModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'paper_exercise_id': instance.paperExerciseId,
    };

_$ChapterPaperModelImpl _$$ChapterPaperModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ChapterPaperModelImpl(
      name: json['name'] as String?,
      list: (json['list'] as List<dynamic>?)
              ?.map((e) => PaperModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ChapterPaperModelImplToJson(
        _$ChapterPaperModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'list': instance.list,
    };
