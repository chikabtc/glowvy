import 'package:json_annotation/json_annotation.dart';
import 'restock.dart';
part 'notice.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Notice {
  Restock restock;

  Notice(
    this.restock,
  );
  factory Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);
  Map<String, dynamic> toJson() => _$NoticeToJson(this);
}
