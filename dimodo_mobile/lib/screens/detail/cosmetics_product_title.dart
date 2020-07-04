import 'package:Dimodo/common/styles.dart';
import 'package:flutter/material.dart';
import '../../models/product/product.dart';
import '../../widgets/customWidgets.dart';
import '../../common/tools.dart';
import 'package:Dimodo/generated/i18n.dart';

class CosmeticsProductTitle extends StatelessWidget {
  final Product product;

  CosmeticsProductTitle(
    this.product,
  );

  @override
  Widget build(BuildContext context) {
    var tag = product.tags.length == 1
        ? product.tags[0].sname
        : product.tags[1].sname;
    return Container(
      color: Colors.purple,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DynamicText(
                  "DIMODO Price",
                  style: kBaseTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      DynamicText(
                        Tools.getPriceProduct(product, "VND",
                            onSale: product.salePrice != null ? true : false),
                        style: kBaseTextStyle.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      if (product.salePercent != null)
                        Container(
                          height: 18,
                          width: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                        DynamicText("${product.purchaseCount} sold",
                            style: kBaseTextStyle.copyWith(
                                fontSize: 10, color: kSecondaryPurple)),
                    ]),
                SizedBox(height: 3),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: DynamicText(
                      S.of(context).officialPrice +
                          ": ${Tools.getPriceProduct(product, "VND", onSale: false)}",
                      style: kBaseTextStyle.copyWith(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 12,
                          color: kSecondaryPurple)),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 5,
                  color: Colors.white,
                ),
                Container(
                  decoration: BoxDecoration(
                    // color: kDefaultBackground,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7.0),
                    child:
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      Image.asset(
                          "assets/icons/product_detail/korean-flag.png"),
                      SizedBox(width: 5),
                      DynamicText(
                        S.of(context).soldByKoreanShopDirectShipping,
                        style: kBaseTextStyle.copyWith(
                            fontSize: 12, color: Colors.purple),
                        textAlign: TextAlign.start,
                      ),
                    ]),
                  ),
                ),
                Container(
                  height: 10,
                  // color: kDefaultBackground,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: DynamicText(
                    "${product.seller.name} " +
                        "${product.name}" +
                        " ${product.volume}",
                    style: kBaseTextStyle.copyWith(
                        fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
