import 'package:json_annotation/json_annotation.dart';
part 'coupon.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Coupon {
  int id;
  int userId;
  var code;
  var description;
  var discountType;
  int discountAmount;
  int discountPercentage;
  int minimumAmount;
  int maximumAmount;
  int usageLimit;
  int usageCount;
  int dateExpires;
  int dateCreated;

  Coupon(
    this.id,
    this.userId,
    this.code,
    this.description,
    this.discountAmount,
    this.discountType,
    this.discountPercentage,
    this.minimumAmount,
    this.maximumAmount,
    this.usageCount,
    this.usageLimit,
    this.dateExpires,
    this.dateCreated,
  );

  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);
  Map<String, dynamic> toJson() => _$CouponToJson(this);
}
