// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address(
    recipientName: json['recipient_name'] as String,
    street: json['street'] as String,
    ward: json['ward'] == null
        ? null
        : Ward.fromJson(json['ward'] as Map<String, dynamic>),
    phoneNumber: json['phone_number'] as String,
  );
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'recipient_name': instance.recipientName,
      'street': instance.street,
      'ward': instance.ward,
      'phone_number': instance.phoneNumber,
    };
