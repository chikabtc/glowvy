import 'package:json_annotation/json_annotation.dart';
part 'province.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Province {
  int id;
  String name;
  int index;

  Province({
    this.id,
    this.name,
    this.index,
  });
  factory Province.fromJson(Map<String, dynamic> json) =>
      _$ProvinceFromJson(json);
  Map<String, dynamic> toJson() => _$ProvinceToJson(this);
}
