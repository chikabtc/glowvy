// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Option _$OptionFromJson(Map<String, dynamic> json) {
  return Option(
    json['product_id'] as String,
    json['sku'] as String,
    json['min_order_qty'] as int,
    json['max_order_qty'] as int,
    json['add_price'] as int,
    json['is_sell'] as bool,
    json['is_today_delivery'] as bool,
    json['delivery_date'] as String,
    json['qty'] as int,
    json['is_essential'] as bool,
    json['notice'] == null
        ? null
        : Notice.fromJson(json['notice'] as Map<String, dynamic>),
    json['is_sold_out'] as bool,
    json['is_temporary_sold_out'] as bool,
    (json['attributes'] as List)
        ?.map((e) => e == null
            ? null
            : OptionAttribute.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$OptionToJson(Option instance) => <String, dynamic>{
      'product_id': instance.productId,
      'sku': instance.sku,
      'min_order_qty': instance.minOrderQty,
      'max_order_qty': instance.maxOrderQty,
      'add_price': instance.addPrice,
      'is_sell': instance.isSell,
      'is_today_delivery': instance.isTodayDelivery,
      'delivery_date': instance.deliveryDate,
      'qty': instance.qty,
      'is_essential': instance.isEssential,
      'notice': instance.notice,
      'is_sold_out': instance.isSoldOut,
      'is_temporary_sold_out': instance.isTemporarySoldOut,
      'attributes': instance.attributes,
    };
