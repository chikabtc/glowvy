// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orderItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return OrderItem(
    option: json['option'] as String,
    optionId: json['option_id'] as int,
    quantity: json['quantity'] as int,
    product: json['product'] == null
        ? null
        : Product.fromJson(json['product'] as Map<String, dynamic>),
    orderId: json['order_id'] as int,
  );
}

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'option': instance.option,
      'option_id': instance.optionId,
      'quantity': instance.quantity,
      'product': instance.product?.toJson(),
      'order_id': instance.orderId,
    };
