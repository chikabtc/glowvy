import 'package:json_annotation/json_annotation.dart';

part 'businessInfo.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class BusinessInfo {
  String businessCode;
  String businessName;
  String mailOrderBusinessCode;
  String representativeName;

  BusinessInfo({
    this.businessCode,
    this.businessName,
    this.mailOrderBusinessCode,
    this.representativeName,
  });
  factory BusinessInfo.fromJson(Map<String, dynamic> json) =>
      _$BusinessInfoFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessInfoToJson(this);
}
