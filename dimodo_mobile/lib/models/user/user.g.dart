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
    json['access_token'] as String,
    json['address'] == null
        ? null
        : Address.fromJson(json['address'] as Map<String, dynamic>),
    json['billing'] == null
        ? null
        : Billing.fromJson(json['billing'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'logged_in': instance.loggedIn,
      'full_name': instance.fullName,
      'email': instance.email,
      'picture': instance.picture,
      'access_token': instance.accessToken,
      'address': instance.address,
      'billing': instance.billing,
    };
