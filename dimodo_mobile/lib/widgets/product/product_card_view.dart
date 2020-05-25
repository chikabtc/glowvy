import 'package:Dimodo/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/tools.dart';
import '../../models/product/product.dart';
import '../../models/app.dart';
import '../../screens/detail/product_detail.dart';
import '../../common/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductCard extends StatelessWidget {
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

  ProductCard({
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
          builder: (BuildContext context) => ProductDetail(product: product),
          fullscreenDialog: true,
        ));
  }

  @override
  Widget build(BuildContext context) {
    var tag = product.tags.length == 1
        ? product.tags[0].sname
        : product.tags[1].sname;

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6), topRight: Radius.circular(6)),
            child: Container(
                width: width,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: GestureDetector(
                      onTap: () => onTapProduct(context),
                      child: Tools.image(
                        url: product.thumbnail,
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                        size: kSize.large,
                      )

                      // CachedNetworkImage(
                      //   imageUrl: product.thumbnail,
                      //   width: 100,
                      //   height: 100,
                      //   // placeholder: (context, url) =>
                      //   //     CircularProgressIndicator(),
                      //   // errorWidget: (context, url, error) => Icon(Icons.error),
                      // ),
                      ),
                )),
          ),
          // // item name
          SizedBox(height: 3),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 7.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    !isNameAvailable
                        ? "${product.tags[0].name} ${product.categoryName} " ??
                            "not found"
                        : "${product.name}",
                    maxLines: 1,
                    style: kBaseTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // SizedBox(height: 3),
                  // if (product.salePercent != 0 && product.salePercent != null)
                  //   Row(
                  //     children: <Widget>[
                  //       Padding(
                  //         padding: EdgeInsets.only(left: 4),
                  //         child: Text(
                  //           "${product.salePercent}%",
                  //           textAlign: TextAlign.center,
                  //           style: kBaseTextStyle.copyWith(
                  //               color: kAccentRed,
                  //               fontSize: 10,
                  //               fontWeight: FontWeight.bold),
                  //         ),
                  //       ),
                  //       Image.asset("assets/icons/home/coupon.png")
                  //     ],
                  //   ),
                  // SizedBox(height: 7),
                  Row(
                    children: <Widget>[
                      Text(
                        product.salePercent != 0
                            ? Tools.getPriceProduct(product, "VND",
                                onSale: true)
                            : Tools.getPriceProduct(product, "VND",
                                onSale: false),
                        style: kBaseTextStyle.copyWith(
                            color: kPinkAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
