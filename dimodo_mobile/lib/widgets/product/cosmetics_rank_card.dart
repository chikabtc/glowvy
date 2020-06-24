import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/tools.dart';
import '../../models/product/product.dart';
import '../../models/app.dart';
import '../../screens/detail/cosmetics_product_detail.dart';
import '../../common/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CosmeticsRankCard extends StatelessWidget {
  final Product product;
  final width;
  final kSize size;
  final bool isHero;
  final bool showCart;
  final bool showHeart;
  final height;
  final bool hideDetail;
  final offset;
  bool isNameAvailable;

  CosmeticsRankCard({
    this.product,
    this.width,
    this.size = kSize.medium,
    this.isHero = false,
    this.showHeart = false,
    this.showCart = false,
    this.height,
    this.offset,
    this.hideDetail = false,
    this.isNameAvailable = false,
  });

  onTapProduct(context) {
    print("tapping this prd: ${product.sid}");

    Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              CosmeticsProductDetail(product: product),
          fullscreenDialog: true,
        ));
  }

  @override
  Widget build(BuildContext context) {
    var tag = product.tags.length == 1
        ? product.tags[0].sname
        : product.tags[1].sname;
    final screenSize = MediaQuery.of(context).size;

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6), topRight: Radius.circular(6)),
            child: Container(
                width: 100,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: GestureDetector(
                      onTap: () => onTapProduct(context),
                      child: Tools.image(
                        url: product.thumbnail,
                        fit: BoxFit.scaleDown,
                        width: 100,
                        height: 100,
                        size: kSize.large,
                      )),
                )),
          ),
          // // item name
          SizedBox(width: 7),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 10),
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: kBaseTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "${product.categoryName}",
                  maxLines: 1,
                  style: kBaseTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                Row(
                  children: <Widget>[
                    Text(
                      product.salePercent != null
                          ? Tools.getPriceProduct(product, "VND", onSale: true)
                          : Tools.getPriceProduct(product, "VND",
                              onSale: false),
                      style: kBaseTextStyle.copyWith(
                          color: kPinkAccent,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 8),
                    if (product.purchaseCount != null)
                      Container(
                        child: Text(
                          "${product.purchaseCount} ${S.of(context).beenSold}",
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          style: kBaseTextStyle.copyWith(
                              color: kDarkSecondary.withOpacity(0.5),
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    for (var tag in product.tags)
                      Text(
                        product.tags.last == tag ? tag.sname : tag.sname + ", ",
                        maxLines: 1,
                        style: kBaseTextStyle.copyWith(
                            color: kDarkSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                  ],
                ),
                SizedBox(height: 4)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
