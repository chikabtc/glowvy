import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/screens/write_review_screen.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../common/tools.dart';
import '../../models/product/product.dart';
import '../../screens/detail/cosmetics_product_detail.dart';
import '../../common/styles.dart';

import '../../common/colors.dart';

class CosmeticsThumbCard extends StatelessWidget {
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

  CosmeticsThumbCard({
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

    return Container(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WriteReviewScreen(
                product: product,
              ),
            )),
        child: Column(
          children: [
            Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FittedBox(
                    fit: BoxFit.cover,
                    child: Tools.image(
                      url: product.thumbnail,
                      fit: BoxFit.cover,
                      width: 34,
                      height: 36,
                      size: kSize.large,
                    ),
                  ),
                  // // item name
                  SizedBox(width: 7),
                  Flexible(
                    child: Container(
                      height: 35,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 2),
                          Text("${product.name}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.button2),
                          Text("${product.name}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.caption2),

                          // SizedBox(height: 9),

                          // // SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            showDivider ? Divider(height: 1) : Container()
          ],
        ),
      ),
    );
  }
}
