import '../brandi/option.dart';
import '../sizeDetail.dart';
import 'package:json_annotation/json_annotation.dart';
import 'seller.dart';
import 'productEtcInfo.dart';
import 'addInfo.dart';
import 'tag.dart';
part 'product.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Product {
  int id;
  int sid;
  String thumbnail;
  String name;
  String sname;
  String sdescription;
  String description;
  List<String> descImages;
  List<String> sliderImages;
  List<Tag> tags;
  int salePrice;
  int price;
  int categoryId;
  String categoryName;
  int salePercent;
  int purchaseCount;
  String volume;

  List<SizeDetail> sizeDetails;
  List<Option> options;
  ProductEtcInfo productEtcInfo;
  Seller seller;
  List<AddInfo> addInfo;

  Product({
    this.id,
    this.thumbnail,
    this.name,
    this.volume,
    this.sname,
    this.description,
    this.sdescription,
    this.descImages,
    this.sliderImages,
    this.tags,
    this.salePrice,
    this.salePercent,
    this.price,
    this.categoryId,
    this.categoryName,
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
