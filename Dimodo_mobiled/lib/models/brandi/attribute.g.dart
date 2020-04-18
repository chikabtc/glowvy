// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attribute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OptionAttribute _$OptionAttributeFromJson(Map<String, dynamic> json) {
  return OptionAttribute(
    json['title'] as String,
    json['value'] as String,
    json['order'] as int,
  );
}

Map<String, dynamic> _$OptionAttributeToJson(OptionAttribute instance) =>
    <String, dynamic>{
      'title': instance.title,
      'value': instance.value,
      'order': instance.order,
    };
