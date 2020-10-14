// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) {
  return Review(
    id: json['id'] as int,
    createdTime: json['created_time'] as String,
    content: json['content'] as String,
    scontent: json['scontent'] as String,
    rating: json['rating'] as int,
    productId: json['product_id'] as int,
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    images: (json['images'] as List)?.map((e) => e as String)?.toList(),
  )..userId = json['user_id'] as int;
}

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'scontent': instance.scontent,
      'user_id': instance.userId,
      'product_id': instance.productId,
      'rating': instance.rating,
      'images': instance.images,
      'user': instance.user,
      'created_time': instance.createdTime,
    };
