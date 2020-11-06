// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) {
  return Review(
    id: json['id'] as int,
    createdAt: json['created_at'] as int,
    text: json['text'] as String,
    stext: json['stext'] as String,
    rating: json['rating'] as int,
    productId: json['product_id'] as int,
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
      'text': instance.text,
      'stext': instance.stext,
      'product_id': instance.productId,
      'rating': instance.rating,
      'images': instance.images,
      'user': instance.user,
      'created_at': instance.createdAt,
      'product': instance.product,
      'like_count': instance.likeCount,
    };
