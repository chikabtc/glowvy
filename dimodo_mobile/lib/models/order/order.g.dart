// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
    orderId: json['order_id'] as int,
    isPaid: json['is_paid'] as bool,
    dateCreated: json['date_created'] as int,
    orderItems: (json['order_items'] as List)
        ?.map((e) =>
            e == null ? null : CartItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    userId: json['user_id'] as int,
    totalShipping: (json['total_shipping'] as num)?.toDouble(),
    totalFee: (json['total_fee'] as num)?.toDouble(),
    addressId: json['address_id'] as int,
  );
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'order_id': instance.orderId,
      'is_paid': instance.isPaid,
      'total_shipping': instance.totalShipping,
      'total_fee': instance.totalFee,
      'user_id': instance.userId,
      'address_id': instance.addressId,
      'date_created': instance.dateCreated,
      'order_items': instance.orderItems,
    };
