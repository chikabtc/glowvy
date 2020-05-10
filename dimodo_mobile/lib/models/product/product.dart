import '../brandi/option.dart';
import '../sizeDetail.dart';
import 'package:json_annotation/json_annotation.dart';
import 'seller.dart';
import 'productEtcInfo.dart';
import 'addInfo.dart';
part 'product.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Product {
  int id;
  String thumbnail;
  String name;
  String description;
  List<String> descImages;
  List<String> sliderImages;
  int salePrice;
  int price;
  int categoryId;
  int salePercent;
  int purchaseCount;

  List<SizeDetail> sizeDetails;
  List<Option> options;
  ProductEtcInfo productEtcInfo;
  Seller seller;
  List<AddInfo> addInfo;
  int sid;

  Product({
    this.id,
    this.thumbnail,
    this.name,
    this.description,
    this.descImages,
    this.sliderImages,
    this.salePrice,
    this.salePercent,
    this.price,
    this.categoryId,
    this.purchaseCount,
    this.sizeDetails,
    this.options,
    this.productEtcInfo,
    this.seller,
    this.addInfo,
    this.sid,
  });

  Product.empty(int id) {
    this.id = id;
    name = 'Loading...';
    price = 0;
  }

  bool isEmptyProduct() {
    return name == 'Loading...' && price == '0.0';
  }

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  String toString() => 'Product { id: $id name: $name }';
}

class ProductVariation {
  String option1;
  String option2;
  // int quantity;

  ProductVariation({this.option2, this.option1});

  ProductVariation.fromJson(Map<String, dynamic> parsedJson) {
    option2 = parsedJson["option2"];
    option1 = parsedJson["option1"];
  }

  Map<String, dynamic> toJson() {
    return {
      "option1": option1,
      "option2": option2,
    };
  }

  ProductVariation.fromLocalJson(Map<String, dynamic> json) {
    try {
      option2 = json["option2"];
      option1 = json["option1"];
    } catch (e) {
      print(e.toString());
    }
  }
}
