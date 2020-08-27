// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as int,
    loggedIn: json['logged_in'] as bool,
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
    ..firstName = json['first_name'] as String
    ..lastName = json['last_name'] as String
    ..addresses = (json['addresses'] as List)
        ?.map((e) =>
            e == null ? null : Address.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'logged_in': instance.loggedIn,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'full_name': instance.fullName,
      'email': instance.email,
      'picture': instance.picture,
      'skin_type': instance.skinType,
      'access_token': instance.accessToken,
      'default_address': instance.defaultAddress,
      'addresses': instance.addresses,
      'billing': instance.billing,
    };
