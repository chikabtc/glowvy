import 'package:json_annotation/json_annotation.dart';

part 'restock.g.dart';

@JsonSerializable()
class Restock {
  bool isManaged;
  bool isRequested;

  Restock(
    this.isManaged,
    this.isRequested,
  );
  factory Restock.fromJson(Map<String, dynamic> json) =>
      _$RestockFromJson(json);
}
