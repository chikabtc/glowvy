// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productEtcInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductEtcInfo _$ProductEtcInfoFromJson(Map<String, dynamic> json) {
  return ProductEtcInfo(
    attributes: (json['attributes'] as List)
        ?.map((e) => e == null
            ? null
            : ProductAttribute.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ProductEtcInfoToJson(ProductEtcInfo instance) =>
    <String, dynamic>{
      'attributes': instance.attributes?.map((e) => e?.toJson())?.toList(),
    };
