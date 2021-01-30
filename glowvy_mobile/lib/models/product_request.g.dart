// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductRequest _$ProductRequestFromJson(Map<String, dynamic> json) {
  return ProductRequest(
    isUploaded: json['is_uploaded'] as bool,
    sentNotificaiton: json['sent_notificaiton'] as bool,
    product: json['product'] == null
        ? null
        : Product.fromJson(json['product'] as Map<String, dynamic>),
    productName: json['product_name'] as String,
    brandName: json['brand_name'] as String,
    categoryName: json['category_name'] as String,
    id: json['id'] as int,
  )..user = json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ProductRequestToJson(ProductRequest instance) =>
    <String, dynamic>{
      'is_uploaded': instance.isUploaded,
      'sent_notificaiton': instance.sentNotificaiton,
      'product': instance.product?.toJson(),
      'product_name': instance.productName,
      'category_name': instance.categoryName,
      'brand_name': instance.brandName,
      'user': instance.user?.toJson(),
      'id': instance.id,
    };
