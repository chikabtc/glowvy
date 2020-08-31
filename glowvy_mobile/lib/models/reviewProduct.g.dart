// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviewProduct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewProduct _$ReviewProductFromJson(Map<String, dynamic> json) {
  return ReviewProduct(
    id: json['id'] as String,
    sid: json['sid'] as String,
    optionName: json['option_name'] as String,
    sellerId: json['seller_id'] as String,
  );
}

Map<String, dynamic> _$ReviewProductToJson(ReviewProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sid': instance.sid,
      'option_name': instance.optionName,
      'seller_id': instance.sellerId,
    };
