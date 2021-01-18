import 'package:json_annotation/json_annotation.dart';

import 'district.dart';
import 'province.dart';

part 'ward.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Ward {
  Ward(
      {this.id,
      this.name,
      this.proviceId,
      this.province,
      this.district,
      this.districtID});
  int id;
  String name;
  Province province;
  int proviceId;
  District district;
  int districtID;

  factory Ward.fromJson(Map<String, dynamic> json) => _$WardFromJson(json);
  Map<String, dynamic> toJson() => _$WardToJson(this);
}
