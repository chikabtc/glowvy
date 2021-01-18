// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sizeDetail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SizeDetail _$SizeDetailFromJson(Map<String, dynamic> json) {
  return SizeDetail(
    attributes: (json['attributes'] as List)
        ?.map((e) => e == null
            ? null
            : ProductAttribute.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SizeDetailToJson(SizeDetail instance) =>
    <String, dynamic>{
      'attributes': instance.attributes?.map((e) => e?.toJson())?.toList(),
    };
