import 'package:json_annotation/json_annotation.dart';

part 'province.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Province {
  Province({
    this.id,
    this.name,
    this.index,
  });
  int id;
  String name;
  String index;

  factory Province.fromJson(Map<String, dynamic> json) =>
      _$ProvinceFromJson(json);
  Map<String, dynamic> toJson() => _$ProvinceToJson(this);
}
