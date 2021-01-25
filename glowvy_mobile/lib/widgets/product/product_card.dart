import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/models/search_model.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../common/colors.dart';
import '../../common/styles.dart';
import '../../common/tools.dart';
import '../../models/product/product.dart';
import '../../screens/detail/product_detail.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    this.product,
    this.ranking,
    this.showDivider = true,
    this.showFullDivider = false,
    this.saveHistory = false,
    this.isRecentSearchItem = false,
    this.isReviewCard = false,
  });

  final Product product;
  final bool showDivider;
  final bool showFullDivider;
  final bool isReviewCard;
  final bool saveHistory;
  final bool isRecentSearchItem;
  final int ranking;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () async {
          if (isReviewCard) {
            print(product.sid);
            var userModel = Provider.of<UserModel>(context, listen: false);
            userModel.setProductInReview(product);
            Navigator.pop(context);
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                    product: product,
                    rank: ranking,
                  ),
                ));
          }

          if (saveHistory) {
            final loggedin =
                Provider.of<UserModel>(context, listen: false).isLoggedIn;
            if (loggedin) {
              await Provider.of<SearchModel>(context, listen: false)
                  .saveRecentSearchItem(product);
            }
          }
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
                      SvgPicture.asset('assets/icons/yellow-flower.svg',
                          color: Colors.transparent),
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
                                  color:
                                      ranking < 3 ? Colors.white : kDarkYellow,
                                  fontWeight: FontWeight.w800),
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
                          overflow: TextOverflow.ellipsis,
                          style: kBaseTextStyle.copyWith(
                            fontSize: 13,
                            color: kSecondaryGrey,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 5),
                        if (isRecentSearchItem)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                '${product.volume} /' +
                                    Tools.getPriceProduct(product, 'VND',
                                        onSale: false),
                                style: kBaseTextStyle.copyWith(
                                    color: kSecondaryGrey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          )
                        else
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset('assets/icons/red-star.svg'),
                              Text(
                                double.parse(product
                                        .reviewMetas.all.averageRating
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
                                '${product.volume} /' +
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
            if (showFullDivider) kFullDivider
          ],
        ),
      ),
    );
  }
}
