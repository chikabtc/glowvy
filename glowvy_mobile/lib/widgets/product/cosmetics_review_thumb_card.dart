import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/styles.dart';
import '../../common/tools.dart';
import '../../models/product/product.dart';

class CosmeticsReviewThumbCard extends StatelessWidget {
  const CosmeticsReviewThumbCard({
    this.product,
    this.ranking,
    this.showHeart = false,
    this.showDivider = true,
  });
  final Product product;
  final bool showDivider;
  final bool showHeart;

  final int ranking;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          print(product.sid);
          var userModel = Provider.of<UserModel>(context, listen: false);
          userModel.setProductInReview(product);
          Navigator.pop(context);
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
                  const SizedBox(width: 7),
                  Flexible(
                    child: Container(
                      height: 35,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 2),
                          Text(product.brand.name + ' ' + product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.button2),
                          Text(product.category.firstCategoryName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.caption2),

                          // const SizedBox(height: 9),

                          // // const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (showDivider) kFullDivider
          ],
        ),
      ),
    );
  }
}
