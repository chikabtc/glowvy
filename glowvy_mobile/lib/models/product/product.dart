import 'dart:ffi';

import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/ingredient.dart';
import 'package:Dimodo/models/product/review_meta.dart';
import 'package:Dimodo/models/product/review_metas.dart';

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
  int hazardScore;
  String thumbnail;
  String name;
  String sname;
  String sdescription;
  String description;
  List<String> descImages;
  List<String> sliderImages;
  List<String> tags;
  int salePrice;
  int price;
  double sprice;
  double officialPrice;
  String rating;
  int salePercent;
  int purchaseCount;
  String volume;
  Category category;
  ReviewMetas reviewMetas;
  List<SizeDetail> sizeDetails;
  List<Option> options;
  Brand brand;
  List<Ingredient> ingredients;

  Product({
    this.id,
    this.hazardScore,
    this.thumbnail,
    this.rating,
    this.reviewMetas,
    this.name,
    this.volume,
    this.sname,
    this.description,
    this.sdescription,
    this.descImages,
    this.ingredients,
    this.sliderImages,
    this.tags,
    this.salePrice,
    this.salePercent,
    this.price,
    this.purchaseCount,
    this.sizeDetails,
    this.options,
    // this.productEtcInfo,
    this.brand,
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

  factory Product.fromJson(Map<String, dynamic> json) {
    return _$ProductFromJson(json);
  }
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  String toString() => 'Product { id: $sid name: $name }';
}

class ProductVariation {
  String option1;
  String option2;
  // int quantity;

  ProductVariation({this.option2, this.option1});

  ProductVariation.fromJson(Map<String, dynamic> parsedJson) {
    option2 = parsedJson['option2'];
    option1 = parsedJson['option1'];
  }

  Map<String, dynamic> toJson() {
    return {
      'option1': option1,
      'option2': option2,
    };
  }

  ProductVariation.fromLocalJson(Map<String, dynamic> json) {
    try {
      option2 = json['option2'];
      option1 = json['option1'];
    } catch (e) {
      print(e.toString());
    }
  }
}
