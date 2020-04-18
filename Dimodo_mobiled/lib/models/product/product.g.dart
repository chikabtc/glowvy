// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    id: json['id'] as int,
    thumbnail: json['thumbnail'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    descImages:
        (json['desc_images'] as List)?.map((e) => e as String)?.toList(),
    sliderImages:
        (json['slider_images'] as List)?.map((e) => e as String)?.toList(),
    salePrice: json['sale_price'] as int,
    salePercent: json['sale_percent'] as int,
    price: json['price'] as int,
    categoryId: json['category_id'] as int,
    purchaseCount: json['purchase_count'] as int,
    sizeDetails: (json['size_details'] as List)
        ?.map((e) =>
            e == null ? null : SizeDetail.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    options: (json['options'] as List)
        ?.map((e) =>
            e == null ? null : Option.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    productEtcInfo: json['product_etc_info'] == null
        ? null
        : ProductEtcInfo.fromJson(
            json['product_etc_info'] as Map<String, dynamic>),
    seller: json['seller'] == null
        ? null
        : Seller.fromJson(json['seller'] as Map<String, dynamic>),
    addInfo: (json['add_info'] as List)
        ?.map((e) =>
            e == null ? null : AddInfo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    sid: json['sid'] as int,
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'thumbnail': instance.thumbnail,
      'name': instance.name,
      'description': instance.description,
      'desc_images': instance.descImages,
      'slider_images': instance.sliderImages,
      'sale_price': instance.salePrice,
      'price': instance.price,
      'category_id': instance.categoryId,
      'sale_percent': instance.salePercent,
      'purchase_count': instance.purchaseCount,
      'size_details': instance.sizeDetails,
      'options': instance.options,
      'product_etc_info': instance.productEtcInfo,
      'seller': instance.seller,
      'add_info': instance.addInfo,
      'sid': instance.sid,
    };
