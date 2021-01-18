// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cartItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItem _$CartItemFromJson(Map<String, dynamic> json) {
  return CartItem(
    option: json['option'] as String,
    optionId: json['option_id'] as int,
    quantity: json['quantity'] as int,
    product: json['product'] == null
        ? null
        : Product.fromJson(json['product'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
      'option': instance.option,
      'option_id': instance.optionId,
      'quantity': instance.quantity,
      'product': instance.product?.toJson(),
    };
