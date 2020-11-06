// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    fullName: json['full_name'] as String,
    email: json['email'] as String,
    picture: json['picture'] as String,
    skinType: json['skin_type'] as String,
    address: json['address'] == null
        ? null
        : Address.fromJson(json['address'] as Map<String, dynamic>),
    billing: json['billing'] == null
        ? null
        : Billing.fromJson(json['billing'] as Map<String, dynamic>),
  )
    ..uid = json['uid'] as String
    ..displayName = json['display_name'] as String
    ..firstName = json['first_name'] as String
    ..lastName = json['last_name'] as String
    ..gender = json['gender'] as String
    ..skinTypeId = json['skin_type_id'] as int
    ..birthYear = json['birth_year'] as int
    ..age = json['age'] as int
    ..skinScores = json['skin_scores'] == null
        ? null
        : SkinScores.fromJson(json['skin_scores'] as Map<String, dynamic>)
    ..addresses = (json['addresses'] as List)
        ?.map((e) =>
            e == null ? null : Address.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..reviewDraft = json['review_draft'] == null
        ? null
        : Review.fromJson(json['review_draft'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'uid': instance.uid,
      'display_name': instance.displayName,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'full_name': instance.fullName,
      'email': instance.email,
      'picture': instance.picture,
      'gender': instance.gender,
      'skin_type': instance.skinType,
      'skin_type_id': instance.skinTypeId,
      'birth_year': instance.birthYear,
      'age': instance.age,
      'skin_scores': instance.skinScores,
      'address': instance.address,
      'addresses': instance.addresses,
      'review_draft': instance.reviewDraft,
      'billing': instance.billing,
    };
