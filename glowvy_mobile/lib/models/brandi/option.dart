import 'package:json_annotation/json_annotation.dart';

import '../productAttribute.dart';
import 'attribute.dart';
import 'notice.dart';

part 'option.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Option {
  String productId;
  String sku;
  int minOrderQty;
  int maxOrderQty;
  int addPrice;
  bool isSell;
  bool isTodayDelivery;
  String deliveryDate;
  int qty;
  bool isEssential;
  Notice notice;
  bool isSoldOut;
  bool isTemporarySoldOut;
  List<OptionAttribute> attributes;

  Option(
    this.productId,
    this.sku,
    this.minOrderQty,
    this.maxOrderQty,
    this.addPrice,
    this.isSell,
    this.isTodayDelivery,
    this.deliveryDate,
    this.qty,
    this.isEssential,
    this.notice,
    this.isSoldOut,
    this.isTemporarySoldOut,
    this.attributes,
  );
  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);
  Map<String, dynamic> toJson() => _$OptionToJson(this);

  static SingleOptions newSingleOptions(List<Option> options) {
    // print(options);
    var singleOptions = SingleOptions();
    singleOptions.attributes = <ProductAttribute>[];

    options.forEach((option) {
      singleOptions.title = option.attributes[0].title;
      var value = option.attributes[0].value;
      singleOptions.attributes
          .add(ProductAttribute(null, value, option.isSoldOut));
    });
    return singleOptions;
  }

  static List<CompoundOption> newCompoundOptions(List<Option> options) {
    var com = CompoundOption();
    var com1 = CompoundOption();
    com.options = <String, List<ProductAttribute>>{};
    com1.options = <String, List<ProductAttribute>>{};

    // print(options[0].isSoldOut);

    options.forEach((option) {
      var title = option.attributes[0].title;
      var value = option.attributes[0].value;
      var title1 = option.attributes[1].title;
      var value1 = option.attributes[1].value;
      com.title = title;
      com1.title = title1;
      if (com.options[value] == null) {
        com.options[value] = <ProductAttribute>[];
      }
      if (com1.options[value1] == null) {
        com1.options[value1] = <ProductAttribute>[];
      }
      com.options[value]
          .add(ProductAttribute(title1, value1, option.isSoldOut));
      com1.options[value1]
          .add(ProductAttribute(title, value, option.isSoldOut));
    });
    // print(com1.options['S'][1].value);
    // print(json.encode(com1.options));

    return [com, com1];
  }
}

class SingleOptions {
  String title;
  List<ProductAttribute> attributes;
}

class CompoundOption {
  String title;
  Map<String, List<ProductAttribute>> options;
  // Map<String, dynamic> toJson() => _$NoticeToJson(this);
}
