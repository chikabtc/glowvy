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
  final bool showDivider;
  final bool showHeart;
  final height;
  final bool hideDetail;
  final offset;
  final ranking;
  final bool isNameAvailable;

  CosmeticsProductCard({
    this.product,
    this.width,
    this.ranking,
    this.size = kSize.medium,
    this.isHero = false,
    this.showHeart = false,
    this.showDivider = true,
    this.height,
    this.offset,
    this.hideDetail = false,
    this.isNameAvailable = false,
  });

  @override
  Widget build(BuildContext context) {
    var tagString = "";

    var tags = [];

    product.tags.forEach((tag) {
      if (tags.length == 2) {
        return;
      }
      if (tag.name != null) {
        tagString += tag.name + " | ";
        tags.add(tag);
      }
    });

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CosmeticsProductDetail(product: product),
          )),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ranking == null
                ? Container()
                : Stack(overflow: Overflow.clip, children: <Widget>[
                    ranking < 3
                        ? SvgPicture.asset("assets/icons/red-flower.svg")
                        : SvgPicture.asset("assets/icons/yellow-flower.svg"),
                    Positioned(
                        top: 1,
                        left: 0,
                        child: Container(
                          decoration: BoxDecoration(
                              // color: Color(0xFFCFEEBEC),
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
                              fontSize: 9,
                              color: ranking < 3 ? Colors.white : kDarkYellow,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        )),
                  ]),
            FittedBox(
              fit: BoxFit.cover,
              child: Tools.image(
                url: product.thumbnail,
                fit: BoxFit.cover,
                width: 92,
                height: 92,
                size: kSize.large,
              ),
            ),
            // // item name
            SizedBox(width: 7),
            Flexible(
              child: Container(
                height: 112,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset("assets/icons/red-star.svg"),
                        Text(
                          double.parse(product.rating.substring(0, 3))
                              .toString(),
                          maxLines: 1,
                          style: kBaseTextStyle.copyWith(
                              color: kPrimaryOrange,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 5),
                        if (product.purchaseCount != null)
                          Container(
                            child: Text(
                              "(${product.purchaseCount})",
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              style: kBaseTextStyle.copyWith(
                                  color: kDarkSecondary.withOpacity(0.5),
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal),
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
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      tagString,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kBaseTextStyle.copyWith(
                          color: kDarkSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),

                    // Wrap(
                    //   children: <Widget>[
                    //     if (tags.length > 0)
                    //       for (var tag in tags)
                    //         Text(
                    //           tag.name + " | ",
                    //           maxLines: 1,
                    //           overflow: TextOverflow.fade,
                    //           style: kBaseTextStyle.copyWith(
                    //               color: kDarkSecondary,
                    //               fontSize: 12,
                    //               fontWeight: FontWeight.w500),
                    //         ),
                    //   ],
                    // ),
                    SizedBox(height: 15),
                    showDivider ? Divider(height: 1) : Container()

                    // // SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
