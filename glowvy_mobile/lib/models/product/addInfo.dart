import 'package:json_annotation/json_annotation.dart';

part 'addInfo.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AddInfo {
  String key;
  String text;

  AddInfo({
    this.key,
    this.text,
  });
  factory AddInfo.fromJson(Map<String, dynamic> json) =>
      _$AddInfoFromJson(json);
  Map<String, dynamic> toJson() => _$AddInfoToJson(this);
}
