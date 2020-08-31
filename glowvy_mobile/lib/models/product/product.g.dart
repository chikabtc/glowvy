// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    id: json['id'] as int,
    hazardScore: json['hazard_score'] as int,
    thumbnail: json['thumbnail'] as String,
    rating: json['rating'] as String,
    cosmeticsRank: json['cosmetics_rank'] == null
        ? null
        : CosmeticsRank.fromJson(
            json['cosmetics_rank'] as Map<String, dynamic>),
    name: json['name'] as String,
    volume: json['volume'] as String,
    sname: json['sname'] as String,
    description: json['description'] as String,
    sdescription: json['sdescription'] as String,
    descImages:
        (json['desc_images'] as List)?.map((e) => e as String)?.toList(),
    ingredients: (json['ingredients'] as List)
        ?.map((e) =>
            e == null ? null : Ingredient.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    sliderImages:
        (json['slider_images'] as List)?.map((e) => e as String)?.toList(),
    tags: (json['tags'] as List)
        ?.map((e) => e == null ? null : Tag.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    salePrice: json['sale_price'] as int,
    salePercent: json['sale_percent'] as int,
    price: json['price'] as int,
    categoryId: json['category_id'] as int,
    categoryName: json['category_name'] as String,
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
      'sid': instance.sid,
      'hazard_score': instance.hazardScore,
      'thumbnail': instance.thumbnail,
      'name': instance.name,
      'sname': instance.sname,
      'sdescription': instance.sdescription,
      'description': instance.description,
      'desc_images': instance.descImages,
      'slider_images': instance.sliderImages,
      'tags': instance.tags,
      'sale_price': instance.salePrice,
      'price': instance.price,
      'category_id': instance.categoryId,
      'rating': instance.rating,
      'category_name': instance.categoryName,
      'sale_percent': instance.salePercent,
      'purchase_count': instance.purchaseCount,
      'volume': instance.volume,
      'cosmetics_rank': instance.cosmeticsRank,
      'size_details': instance.sizeDetails,
      'options': instance.options,
      'product_etc_info': instance.productEtcInfo,
      'seller': instance.seller,
      'add_info': instance.addInfo,
      'ingredients': instance.ingredients,
    };
