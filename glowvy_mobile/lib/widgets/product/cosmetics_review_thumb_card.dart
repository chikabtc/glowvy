import 'dart:html';

import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/write_review_screen.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../common/tools.dart';
import '../../models/product/product.dart';
import '../../screens/detail/cosmetics_product_detail.dart';
import '../../common/styles.dart';

import '../../common/colors.dart';

class CosmeticsReviewThumbCard extends StatelessWidget {
  final Product product;
  final bool showDivider;
  final bool showHeart;

  final ranking;

  CosmeticsReviewThumbCard({
    this.product,
    this.ranking,
    this.showHeart = false,
    this.showDivider = true,
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
        onTap: () {
          print(product.sid);
          // if (onProductTap != null) {
          //   onProductTap(this.product);
          //   return;
          // }
          // UserModel userModel = Provider.of<UserModel>(context, listen: false);

          // userModel.setProductInReview(this.product);
          // Navigator.pop(context);

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WriteReviewScreen(
                  product: product,
                ),
              ));
        },
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
