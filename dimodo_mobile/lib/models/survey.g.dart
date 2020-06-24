// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Survey _$SurveyFromJson(Map<String, dynamic> json) {
  return Survey(
    json['question'] as String,
    (json['options'] as List)?.map((e) => e as String)?.toList(),
    json['type'] as String,
  );
}

Map<String, dynamic> _$SurveyToJson(Survey instance) => <String, dynamic>{
      'question': instance.question,
      'type': instance.type,
      'options': instance.options,
    };
