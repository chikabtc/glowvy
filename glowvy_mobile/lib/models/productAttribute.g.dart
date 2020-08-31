// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productAttribute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductAttribute _$ProductAttributeFromJson(Map<String, dynamic> json) {
  return ProductAttribute(
    json['title'] as String,
    json['value'] as String,
    json['is_sold_out'] as bool,
  );
}

Map<String, dynamic> _$ProductAttributeToJson(ProductAttribute instance) =>
    <String, dynamic>{
      'title': instance.title,
      'value': instance.value,
      'is_sold_out': instance.isSoldOut,
    };
