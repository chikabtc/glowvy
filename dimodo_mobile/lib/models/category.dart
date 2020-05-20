import 'package:json_annotation/json_annotation.dart';
part 'category.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Category {
  int id;
  int parent;
  String name;
  String image;
  List<dynamic> subCategories;

  Category({
    this.id,
    this.name,
    this.image,
    this.parent,
    this.subCategories,
  });
  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
