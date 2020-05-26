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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          ProductModel.showSubCategoryPage(category, "+sale_price", context),
      child: Column(children: <Widget>[
        Image.asset(category.image),
        DynamicText(category.name,
            style: kBaseTextStyle.copyWith(
                fontSize: 13, fontWeight: FontWeight.w600))
      ]),
    );
  }
}
