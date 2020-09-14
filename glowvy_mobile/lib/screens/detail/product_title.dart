import 'package:Dimodo/common/styles.dart';
import 'package:flutter/material.dart';
import '../../models/product/product.dart';
import '../../widgets/customWidgets.dart';
import '../../common/tools.dart';
import 'package:Dimodo/generated/i18n.dart';

class ProductTitle extends StatelessWidget {
  final Product product;

  ProductTitle(
    this.product,
  );

  @override
  Widget build(BuildContext context) {
    var tag = product.tags.length == 1
        ? product.tags[0].sname
        : product.tags[1].sname;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  Tools.getPriceProduct(product, "VND", onSale: false),
                  style: kBaseTextStyle.copyWith(
                      color: kPinkAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                if (product.salePercent != null)
                  Container(
                    height: 18,
                    width: 44,
                    decoration: BoxDecoration(
                      color: kPinkAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: Text(
                        "-${product.salePercent}%",
                        textAlign: TextAlign.center,
                        style: kBaseTextStyle.copyWith(
                            color: kDefaultBackground,
                            fontSize: 14,
                            height: 1.3,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                Spacer(),
                if (product.purchaseCount != null)
                  Text("${product.purchaseCount} sold",
                      style: kBaseTextStyle.copyWith(
                          fontSize: 10,
                          color: kDarkSecondary.withOpacity(0.5))),
              ]),
          SizedBox(height: 3),
          if (product.salePrice != null)
            Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                  "Price: ${Tools.getPriceProduct(product, "VND", onSale: false)}",
                  style: kBaseTextStyle.copyWith(
                      decoration: TextDecoration.lineThrough,
                      fontSize: 12,
                      color: kDarkSecondary.withOpacity(0.5))),
            ),
          SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: kDefaultBackground,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7.0),
              child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Image.asset("assets/icons/product_detail/korean-flag.png"),
                SizedBox(width: 5),
                Text(
                  S.of(context).soldByKoreanShopDirectShipping,
                  style: kBaseTextStyle.copyWith(
                      fontSize: 12, color: kDarkSecondary.withOpacity(0.7)),
                  textAlign: TextAlign.start,
                ),
              ]),
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              "${product.name}",
              style: kBaseTextStyle.copyWith(
                  fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
