import 'package:Dimodo/generated/i18n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../common/tools.dart';
import '../../models/product/product.dart';
import '../../screens/detail/cosmetics_product_detail.dart';
import '../../common/styles.dart';

class CosmeticsProductCard extends StatelessWidget {
  final Product product;
  final width;
  final kSize size;
  final bool isHero;
  final bool showCart;
  final bool showHeart;
  final height;
  final bool hideDetail;
  final offset;
  var ranking;
  bool isNameAvailable;

  CosmeticsProductCard({
    this.product,
    this.width,
    this.ranking,
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
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CosmeticsProductDetail(product: product),
        ));
    // Navigator.push(
    //     context,
    //     CupertinoPageRoute<void>(
    //       builder: (BuildContext context) =>
    //           CosmeticsProductDetail(product: product),
    //       fullscreenDialog: true,
    //     ));
  }

  @override
  Widget build(BuildContext context) {
    var tag = product.tags.length == 1
        ? product.tags[0].sname
        : product.tags[1].sname;
    final screenSize = MediaQuery.of(context).size;
    //get max number of tags
    var tags = [];

    product.tags.forEach((element) {
      if (tags.length == 2) {
        return;
      }
      tags.add(element);
    });

    return GestureDetector(
      onTap: () => onTapProduct(context),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(overflow: Overflow.clip, children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                child: Stack(children: <Widget>[
                  FittedBox(
                    fit: BoxFit.cover,
                    child: Tools.image(
                      url: product.thumbnail,
                      fit: BoxFit.cover,
                      width: 69,
                      height: 90,
                      size: kSize.large,
                    ),
                  ),
                  if (ranking != null)
                    Positioned(
                        top: 0,
                        left: 7,
                        child: Container(
                          decoration: BoxDecoration(
                              color: kRankingColor,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(28),
                                  bottomLeft: Radius.circular(28))),
                          width: 22,
                          height: 20,
                          padding: EdgeInsets.all(3),
                          child: Text(
                            (ranking + 1).toString(),
                            textAlign: TextAlign.center,
                            style: kBaseTextStyle.copyWith(
                              height: 1,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )),
                ]),
              ),
            ]),
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
                    product.seller.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: kBaseTextStyle.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${product.name}",
                    maxLines: 1,
                    style: kBaseTextStyle.copyWith(
                      fontSize: 13,
                      color: kDarkSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset("assets/icons/red-star.svg"),
                      Text(
                        double.parse(product.rating.substring(0, 3)).toString(),
                        maxLines: 1,
                        style: kBaseTextStyle.copyWith(
                            color: kPrimaryOrange,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 10),
                      if (product.purchaseCount != null)
                        Container(
                          child: Text(
                            "(${product.purchaseCount})",
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            style: kBaseTextStyle.copyWith(
                                color: kDarkSecondary.withOpacity(0.5),
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      Spacer(),
                      Text(
                        Tools.getPriceProduct(product, "VND", onSale: true),
                        style: kBaseTextStyle.copyWith(
                            color: kDarkSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  Wrap(
                    children: <Widget>[
                      if (tags.length > 0)
                        for (var tag in tags)
                          Text(
                            tag.name + " | ",
                            maxLines: 1,
                            style: kBaseTextStyle.copyWith(
                                color: kDarkSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                    ],
                  ),
                  // // SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
