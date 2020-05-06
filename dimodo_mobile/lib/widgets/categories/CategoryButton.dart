import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/generated/i18n.dart';

class CategoryButton extends StatelessWidget {
  final Category category;
  CategoryButton(this.category);

  String dynamicCateName(String name, BuildContext context) {
    switch (name) {
      case "ALL":
        return S.of(context).all;
      case "TOP":
        return S.of(context).top;
      case "COAT":
        return S.of(context).coat;
      case "PANT":
        return S.of(context).pant;
      case "SKIRT":
        return S.of(context).skirt;
      case "DRESS":
        return S.of(context).dress;
      case "SHOES":
        return S.of(context).shoes;
      case "UNDIES":
        return S.of(context).lifeware;
      case "COSMETICS":
        return S.of(context).cosmetics;
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          ProductModel.showSubCategoryPage(category, "+sale_price", context),
      child: Column(children: <Widget>[
        // SvgPicture.asset(category.image, width: 48, height: 48),
        Image.asset(category.image),
        DynamicText(category.name,
            style: kBaseTextStyle.copyWith(
                fontSize: 13, fontWeight: FontWeight.w600))
      ]),
    );
  }
}
