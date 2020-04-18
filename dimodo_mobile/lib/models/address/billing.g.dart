// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Billing _$BillingFromJson(Map<String, dynamic> json) {
  return Billing(
    json['full_name'] as String,
    json['company'] as String,
    json['shipping1'] as String,
    json['shipping2'] as String,
    json['post_code'] as String,
    json['city'] as String,
    json['province'] as String,
    json['email'] as String,
    json['phone'] as String,
  );
}

Map<String, dynamic> _$BillingToJson(Billing instance) => <String, dynamic>{
      'full_name': instance.fullName,
      'company': instance.company,
      'shipping1': instance.shipping1,
      'shipping2': instance.shipping2,
      'city': instance.city,
      'post_code': instance.postCode,
      'province': instance.province,
      'email': instance.email,
      'phone': instance.phone,
    };
