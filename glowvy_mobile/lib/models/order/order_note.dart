import 'package:json_annotation/json_annotation.dart';

part 'order_note.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class OrderNote {
  int id;
  String dateCreated;
  String note;

  OrderNote({this.id, this.dateCreated, this.note});

  OrderNote.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateCreated = json['date_created'];
    note = json['note'];
  }
}
