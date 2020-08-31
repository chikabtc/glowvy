import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Tag {
  int id;
  String name;
  String sname;
  String type;

  Tag({
    this.id,
    this.name,
    this.sname,
    this.type,
  });
  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
  Map<String, dynamic> toJson() => _$TagToJson(this);
}
