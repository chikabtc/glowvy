import 'package:json_annotation/json_annotation.dart';

import 'province.dart';

part 'district.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class District {
  District({
    this.id,
    this.name,
    this.province,
    this.provinceId,
  });
  int id;
  String name;
  Province province;
  int provinceId;

  factory District.fromJson(Map<String, dynamic> json) =>
      _$DistrictFromJson(json);

  Map<String, dynamic> toJson() => _$DistrictToJson(this);
}
