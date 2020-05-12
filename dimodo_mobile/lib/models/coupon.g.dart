// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coupon _$CouponFromJson(Map<String, dynamic> json) {
  return Coupon(
    json['id'] as int,
    json['user_id'] as int,
    json['code'],
    json['description'],
    json['discount_amount'] as int,
    json['discount_type'],
    json['discount_percentage'] as int,
    json['minimum_amount'] as int,
    json['maximum_amount'] as int,
    json['usage_count'] as int,
    json['usage_limit'] as int,
    json['date_expires'] as int,
    json['date_created'] as int,
  );
}

Map<String, dynamic> _$CouponToJson(Coupon instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'code': instance.code,
      'description': instance.description,
      'discount_type': instance.discountType,
      'discount_amount': instance.discountAmount,
      'discount_percentage': instance.discountPercentage,
      'minimum_amount': instance.minimumAmount,
      'maximum_amount': instance.maximumAmount,
      'usage_limit': instance.usageLimit,
      'usage_count': instance.usageCount,
      'date_expires': instance.dateExpires,
      'date_created': instance.dateCreated,
    };
