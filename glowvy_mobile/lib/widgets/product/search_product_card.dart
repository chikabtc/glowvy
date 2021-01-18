import 'package:Dimodo/common/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/colors.dart';
import '../../common/styles.dart';
import '../../common/tools.dart';
import '../../models/product/product.dart';
import '../../screens/detail/product_detail.dart';

class SearchProductCard extends StatelessWidget {
  const SearchProductCard({
    this.product,
    this.ranking,
    this.showDivider = true,
    this.onTap,
    this.showFullDivider = false,
  });

  final Product product;
  final bool showDivider;
  final bool showFullDivider;
  final int ranking;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    // print('product sid ${product.sid}');
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap(product);
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(
                  product: product,
                  rank: ranking,
                ),
              ));
        },
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (ranking != null)
                  Stack(overflow: Overflow.clip, children: <Widget>[
                    if (ranking < 3)
                      SvgPicture.asset('assets/icons/red-flower.svg'),
                    if (ranking >= 3 && ranking <= 5)
                      SvgPicture.asset('assets/icons/yellow-flower.svg'),
                    if (ranking > 5)
                      SvgPicture.asset(
                        'assets/icons/yellow-flower.svg',
                        color: Colors.transparent,
                      ),
                    if (ranking < 99)
                      Positioned(
                          top: 1,
                          left: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(28),
                                    bottomLeft: Radius.circular(28))),
                            width: 22,
                            height: 20,
                            padding: const EdgeInsets.all(3),
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
                Column(
                  children: [
                    Tools.image(
                      url: product.thumbnail,
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
                      size: kSize.large,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
                // // item name
                const SizedBox(width: 15),
                Flexible(
                  child: Container(
                    // height: 105,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 10),
                        Text(product.brand.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyText1),
                        Text(
                          product.name,
                          maxLines: 1,
                          style: kBaseTextStyle.copyWith(
                            fontSize: 13,
                            color: kSecondaryGrey,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            // SvgPicture.asset('assets/icons/red-star.svg'),
                            // Text(
                            //   double.parse(product.reviewMetas.all.averageRating
                            //           .toString()
                            //           .substring(0, 3))
                            //       .toString(),
                            //   maxLines: 1,
                            //   style: kBaseTextStyle.copyWith(
                            //       color: kPrimaryOrange,
                            //       fontSize: 13,
                            //       fontWeight: FontWeight.w600),
                            // ),
                            // const SizedBox(width: 5),
                            // Container(
                            //   child: Text(
                            //     '(${product.reviewMetas.all.reviewCount})',
                            //     textAlign: TextAlign.end,
                            //     maxLines: 1,
                            //     style: kBaseTextStyle.copyWith(
                            //         color: kSecondaryGrey.withOpacity(0.5),
                            //         fontSize: 13,
                            //         fontWeight: FontWeight.normal),
                            //   ),
                            // ),
                            // const Spacer(),
                            Text(
                              Tools.getPriceProduct(product, 'VND',
                                  onSale: false),
                              style: kBaseTextStyle.copyWith(
                                  color: kSecondaryGrey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (showDivider) kFullDivider
                      ],
                    ),
                  ),
                ),
              ],
            ),
            kFullDivider
          ],
        ),
      ),
    );
  }
}
