import 'package:Dimodo/common/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/colors.dart';
import '../../common/styles.dart';
import '../../common/tools.dart';
import '../../models/product/product.dart';
import '../../screens/detail/cosmetics_product_detail.dart';

class CosmeticsProductCard extends StatelessWidget {
  const CosmeticsProductCard({
    this.product,
    this.ranking,
    this.size = kSize.medium,
    this.isHero = false,
    this.showHeart = false,
    this.showDivider = true,
    this.hideDetail = false,
    this.isNameAvailable = false,
  });
  final Product product;
  final kSize size;
  final bool isHero;
  final bool showDivider;
  final bool showHeart;
  final bool hideDetail;
  final int ranking;
  final bool isNameAvailable;

  @override
  Widget build(BuildContext context) {
    // print('product sid ${product.sid}');
    return Container(
      height: 112,
      color: Colors.white,
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CosmeticsProductDetail(
                product: product,
                rank: ranking,
              ),
            )),
        child: Row(
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
                Positioned(
                    top: 1,
                    left: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                          // color: Color(0xFFCFEEBEC),
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
            const SizedBox(width: 7),
            Flexible(
              child: Container(
                height: 112,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 10),
                    Text(
                      product.brand.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kBaseTextStyle.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset('assets/icons/red-star.svg'),
                        Text(
                          double.parse(product.reviewMetas.all.averageRating
                                  .toString()
                                  .substring(0, 3))
                              .toString(),
                          maxLines: 1,
                          style: kBaseTextStyle.copyWith(
                              color: kPrimaryOrange,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          child: Text(
                            '(${product.reviewMetas.all.reviewCount})',
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            style: kBaseTextStyle.copyWith(
                                color: kSecondaryGrey.withOpacity(0.5),
                                fontSize: 13,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          Tools.getPriceProduct(product, 'VND', onSale: false),
                          style: kBaseTextStyle.copyWith(
                              color: kSecondaryGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    const SizedBox(height: 9),
                    if (showDivider) kFullDivider

                    // // const SizedBox(height: 5),
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
