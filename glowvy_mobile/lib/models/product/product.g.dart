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
    reviewMetas: json['review_metas'] == null
        ? null
        : ReviewMetas.fromJson(json['review_metas'] as Map<String, dynamic>),
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
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    salePrice: json['sale_price'] as int,
    salePercent: json['sale_percent'] as int,
    price: json['price'] as int,
    purchaseCount: json['purchase_count'] as int,
    sizeDetails: (json['size_details'] as List)
        ?.map((e) =>
            e == null ? null : SizeDetail.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    options: (json['options'] as List)
        ?.map((e) =>
            e == null ? null : Option.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    brand: json['brand'] == null
        ? null
        : Brand.fromJson(json['brand'] as Map<String, dynamic>),
    sid: json['sid'] as int,
  )..category = json['category'] == null
      ? null
      : Category.fromJson(json['category'] as Map<String, dynamic>);
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
      'rating': instance.rating,
      'sale_percent': instance.salePercent,
      'purchase_count': instance.purchaseCount,
      'volume': instance.volume,
      'category': instance.category,
      'review_metas': instance.reviewMetas,
      'size_details': instance.sizeDetails,
      'options': instance.options,
      'brand': instance.brand,
      'ingredients': instance.ingredients,
    };
