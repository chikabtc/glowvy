// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['id'] as int,
    json['logged_in'] as bool,
    json['full_name'] as String,
    json['email'] as String,
    json['picture'] as String,
    json['skin_type'] as String,
    json['access_token'] as String,
    json['default_address'] == null
        ? null
        : Address.fromJson(json['default_address'] as Map<String, dynamic>),
    json['billing'] == null
        ? null
        : Billing.fromJson(json['billing'] as Map<String, dynamic>),
  )..addresses = (json['addresses'] as List)
      ?.map(
          (e) => e == null ? null : Address.fromJson(e as Map<String, dynamic>))
      ?.toList();
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'logged_in': instance.loggedIn,
      'full_name': instance.fullName,
      'email': instance.email,
      'picture': instance.picture,
      'skin_type': instance.skinType,
      'access_token': instance.accessToken,
      'default_address': instance.defaultAddress,
      'addresses': instance.addresses,
      'billing': instance.billing,
    };
