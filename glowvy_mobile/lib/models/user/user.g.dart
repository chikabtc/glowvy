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
    facebookId: json['facebook_id'] as String,
    skinType: json['skin_type'] as String,
    skinIssues:
        (json['skin_issues'] as List)?.map((e) => e as String)?.toList(),
    birthYear: json['birth_year'] as int,
    gender: json['gender'] as String,
    createdAt: json['created_at'] as int,
    viewedProducts: (json['viewed_products'] as List)
        ?.map((e) =>
            e == null ? null : Product.fromJson(e as Map<String, dynamic>))
        ?.toList(),
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
    ..baumannType = json['baumann_type'] as String
    ..baumannScores = json['baumann_scores'] == null
        ? null
        : SkinScores.fromJson(json['baumann_scores'] as Map<String, dynamic>)
    ..skinTypeId = json['skin_type_id'] as int
    ..age = json['age'] as int
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
      'facebook_id': instance.facebookId,
      'display_name': instance.displayName,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'full_name': instance.fullName,
      'email': instance.email,
      'picture': instance.picture,
      'gender': instance.gender,
      'skin_type': instance.skinType,
      'skin_issues': instance.skinIssues,
      'baumann_type': instance.baumannType,
      'baumann_scores': instance.baumannScores,
      'skin_type_id': instance.skinTypeId,
      'birth_year': instance.birthYear,
      'age': instance.age,
      'address': instance.address,
      'created_at': instance.createdAt,
      'addresses': instance.addresses,
      'viewed_products': instance.viewedProducts,
      'review_draft': instance.reviewDraft,
      'billing': instance.billing,
    };
