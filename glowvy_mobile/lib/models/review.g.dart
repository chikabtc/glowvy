// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) {
  return Review(
    id: json['id'] as int,
    createdAt: json['created_at'] as int,
    content: json['content'] as String,
    scontent: json['scontent'] as String,
    rating: json['rating'] as int,
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    images: (json['images'] as List)?.map((e) => e as String)?.toList(),
  )
    ..product = json['product'] == null
        ? null
        : Product.fromJson(json['product'] as Map<String, dynamic>)
    ..likeCount = json['like_count'] as int;
}

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'scontent': instance.scontent,
      'rating': instance.rating,
      'images': instance.images,
      'user': instance.user?.toJson(),
      'created_at': instance.createdAt,
      'product': instance.product?.toJson(),
      'like_count': instance.likeCount,
    };
