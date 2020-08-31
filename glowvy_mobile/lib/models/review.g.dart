// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) {
  return Review(
    id: json['id'] as String,
    createdTime: json['created_time'] as String,
    type: json['type'] as String,
    content: json['content'] as String,
    scontent: json['scontent'] as String,
    product: json['product'] == null
        ? null
        : ReviewProduct.fromJson(json['product'] as Map<String, dynamic>),
    user: json['user'] == null
        ? null
        : ReviewUser.fromJson(json['user'] as Map<String, dynamic>),
    images: (json['images'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'id': instance.id,
      'created_time': instance.createdTime,
      'type': instance.type,
      'content': instance.content,
      'scontent': instance.scontent,
      'product': instance.product,
      'user': instance.user,
      'images': instance.images,
    };
