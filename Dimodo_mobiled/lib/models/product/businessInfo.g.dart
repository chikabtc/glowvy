// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'businessInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessInfo _$BusinessInfoFromJson(Map<String, dynamic> json) {
  return BusinessInfo(
    businessCode: json['business_code'] as String,
    businessName: json['business_name'] as String,
    mailOrderBusinessCode: json['mail_order_business_code'] as String,
    representativeName: json['representative_name'] as String,
  );
}

Map<String, dynamic> _$BusinessInfoToJson(BusinessInfo instance) =>
    <String, dynamic>{
      'business_code': instance.businessCode,
      'business_name': instance.businessName,
      'mail_order_business_code': instance.mailOrderBusinessCode,
      'representative_name': instance.representativeName,
    };
