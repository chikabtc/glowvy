import 'package:Dimodo/models/product/businessInfo.dart';
import 'package:Dimodo/models/product/tag.dart';
import 'package:json_annotation/json_annotation.dart';
import 'type.dart';

part 'seller.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Seller {
  String address1;
  String address2;
  int bookmarkCount;
  BusinessInfo businessInfo;
  String email;
  String enName;
  String id;
  String imageUrl;
  String name;
  String operationTime;
  List<Tag> tags;
  String telephone;
  String text;
  Type type;

  Seller({
    this.address1,
    this.address2,
    this.bookmarkCount,
    this.businessInfo,
    this.email,
    this.enName,
    this.id,
    this.imageUrl,
    this.name,
    this.operationTime,
    this.tags,
    this.telephone,
    this.text,
    this.type,
  });
  factory Seller.fromJson(Map<String, dynamic> json) => _$SellerFromJson(json);
  Map<String, dynamic> toJson() => _$SellerToJson(this);
}
