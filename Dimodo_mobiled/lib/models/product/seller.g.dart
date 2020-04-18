// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Seller _$SellerFromJson(Map<String, dynamic> json) {
  return Seller(
    address1: json['address1'] as String,
    address2: json['address2'] as String,
    bookmarkCount: json['bookmark_count'] as int,
    businessInfo: json['business_info'] == null
        ? null
        : BusinessInfo.fromJson(json['business_info'] as Map<String, dynamic>),
    email: json['email'] as String,
    enName: json['en_name'] as String,
    id: json['id'] as String,
    imageUrl: json['image_url'] as String,
    name: json['name'] as String,
    operationTime: json['operation_time'] as String,
    tags: (json['tags'] as List)
        ?.map((e) => e == null ? null : Tag.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    telephone: json['telephone'] as String,
    text: json['text'] as String,
    type: json['type'] == null
        ? null
        : Type.fromJson(json['type'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SellerToJson(Seller instance) => <String, dynamic>{
      'address1': instance.address1,
      'address2': instance.address2,
      'bookmark_count': instance.bookmarkCount,
      'business_info': instance.businessInfo,
      'email': instance.email,
      'en_name': instance.enName,
      'id': instance.id,
      'image_url': instance.imageUrl,
      'name': instance.name,
      'operation_time': instance.operationTime,
      'tags': instance.tags,
      'telephone': instance.telephone,
      'text': instance.text,
      'type': instance.type,
    };
