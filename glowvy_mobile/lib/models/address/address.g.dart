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
    isDefault: json['is_default'] as bool,
  )
    ..id = json['id'] as int
    ..district = json['district'] == null
        ? null
        : District.fromJson(json['district'] as Map<String, dynamic>)
    ..province = json['province'] == null
        ? null
        : Province.fromJson(json['province'] as Map<String, dynamic>);
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'id': instance.id,
      'recipient_name': instance.recipientName,
      'street': instance.street,
      'phone_number': instance.phoneNumber,
      'ward': instance.ward?.toJson(),
      'district': instance.district?.toJson(),
      'province': instance.province?.toJson(),
      'is_default': instance.isDefault,
    };
