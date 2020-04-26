import 'package:Dimodo/common/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product/product.dart';
import '../../models/product/productModel.dart';
import '../../widgets/customWidgets.dart';
import '../../common/tools.dart';

class ProductTitle extends StatelessWidget {
  final Product product;
  final String productName;

  ProductTitle(this.product, this.productName);

  @override
  Widget build(BuildContext context) {
    ProductVariation productVariation;
    productVariation = Provider.of<ProductModel>(context).productVariation;
    // print("product sale: ${product.salePercent}");
    if (product.salePercent is String) {
      // print("null is string!?");
    }

    return Container(
      color: Colors.white,
      // height: 88,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                DynamicText(
                  Tools.getPriceProduct(product, "VND", onSale: true),
                  style: kBaseTextStyle.copyWith(
                      color: kPinkAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                if (product.salePercent != null)
                  Container(
                    decoration: BoxDecoration(
                      color: kLightPink,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 2, right: 2),
                      child: DynamicText(
                        "-${product.salePercent}%",
                        textAlign: TextAlign.center,
                        style: kBaseTextStyle.copyWith(
                            color: kPinkAccent,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
              ]),
          SizedBox(height: 3),
          if (product.salePrice != null)
            Container(
              width: MediaQuery.of(context).size.width,
              child: DynamicText(
                  "Price: ${Tools.getPriceProduct(product, "VND", onSale: false)}",
                  style: kBaseTextStyle.copyWith(
                      decoration: TextDecoration.lineThrough,
                      fontSize: 12,
                      color: kDarkSecondary.withOpacity(0.5))),
            ),
          SizedBox(height: 5),
          Container(
            width: MediaQuery.of(context).size.width,
            child: DynamicText(
              productName,
              style: kBaseTextStyle.copyWith(
                  fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
