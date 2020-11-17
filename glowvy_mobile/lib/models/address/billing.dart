import 'package:json_annotation/json_annotation.dart';

part 'billing.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Billing {
  Billing(this.fullName, this.company, this.shipping1, this.shipping2,
      this.postCode, this.city, this.province, this.email, this.phone);
  String fullName;
  String company;
  String shipping1;
  String shipping2;
  String city;
  String postCode;
  String province;
  String email;
  String phone;

  factory Billing.fromJson(Map<String, dynamic> json) =>
      _$BillingFromJson(json);

  Map<String, dynamic> toJson() => _$BillingToJson(this);
}
