// import 'package:Dimodo/models/product/seller.dart';
// import 'package:Dimodo/models/product/tag.dart';
// import 'package:json_annotation/json_annotation.dart';
// part 'cosmetics_product.g.dart';

// @JsonSerializable(fieldRename: FieldRename.snake)
// class CosmeticProduct {
//   int id;
//   int sid;
//   String thumbnail;
//   String name;
//   String description;
//   List<String> sliderImages;
//   List<Tag> tags;
//   int salePrice;
//   int price;
//   int categoryId;
//   String categoryName;
//   int salePercent;
//   int reviewCount;
//   double averageRating;
//   double volumne;
//   String volumeUnit;
//   String brandImg;
//   String brandName;
//   Seller seller;

//   CosmeticProduct({
//     this.id,
//     this.sid,
//     this.thumbnail,
//     this.name,
//     this.description,
//     this.sliderImages,
//     this.tags,
//     this.salePrice,
//     this.salePercent,
//     this.price,
//     this.categoryId,
//     this.categoryName,
//     this.reviewCount,
//     this.seller,
//   });

//   CosmeticProduct.empty(int id) {
//     this.id = id;
//     name = 'Loading...';
//     price = 0;
//   }

//   factory CosmeticProduct.fromJson(Map<String, dynamic> json) =>
//       _$CosmeticProductFromJson(json);
//   Map<String, dynamic> toJson() => _$CosmeticProductToJson(this);

//   @override
//   String toString() => 'Product { id: $id name: $name }';
// }
