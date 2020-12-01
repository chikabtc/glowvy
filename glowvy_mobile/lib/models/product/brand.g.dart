// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Brand _$BrandFromJson(Map<String, dynamic> json) {
  return Brand(
    address1: json['address1'] as String,
    address2: json['address2'] as String,
    bookmarkCount: json['bookmark_count'] as int,
    businessInfo: json['business_info'] == null
        ? null
        : BusinessInfo.fromJson(json['business_info'] as Map<String, dynamic>),
    email: json['email'] as String,
    enName: json['en_name'] as String,
    id: json['id'] as int,
    image: json['image'] as String,
    name: json['name'] as String,
    tags: (json['tags'] as List)
        ?.map((e) => e == null ? null : Tag.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    telephone: json['telephone'] as String,
    text: json['text'] as String,
    type: json['type'] == null
        ? null
        : Type.fromJson(json['type'] as Map<String, dynamic>),
  )..categories = (json['categories'] as List)
      ?.map((e) =>
          e == null ? null : Category.fromJson(e as Map<String, dynamic>))
      ?.toList();
}

Map<String, dynamic> _$BrandToJson(Brand instance) => <String, dynamic>{
      'address1': instance.address1,
      'address2': instance.address2,
      'bookmark_count': instance.bookmarkCount,
      'business_info': instance.businessInfo,
      'email': instance.email,
      'en_name': instance.enName,
      'id': instance.id,
      'image': instance.image,
      'name': instance.name,
      'tags': instance.tags,
      'telephone': instance.telephone,
      'text': instance.text,
      'categories': instance.categories,
      'type': instance.type,
    };
