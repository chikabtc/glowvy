// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as int,
    fullName: json['full_name'] as String,
    email: json['email'] as String,
    picture: json['picture'] as String,
    skinType: json['skin_type'] as String,
    accessToken: json['access_token'] as String,
    defaultAddress: json['default_address'] == null
        ? null
        : Address.fromJson(json['default_address'] as Map<String, dynamic>),
    billing: json['billing'] == null
        ? null
        : Billing.fromJson(json['billing'] as Map<String, dynamic>),
  )
    ..uid = json['uid'] as String
    ..displayName = json['display_name'] as String
    ..firstName = json['first_name'] as String
    ..lastName = json['last_name'] as String
    ..skinTypeId = json['skin_type_id'] as int
    ..age = json['age'] as int
    ..addresses = (json['addresses'] as List)
        ?.map((e) =>
            e == null ? null : Address.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'display_name': instance.displayName,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'full_name': instance.fullName,
      'email': instance.email,
      'picture': instance.picture,
      'skin_type': instance.skinType,
      'skin_type_id': instance.skinTypeId,
      'age': instance.age,
      'access_token': instance.accessToken,
      'default_address': instance.defaultAddress,
      'addresses': instance.addresses,
      'billing': instance.billing,
    };
