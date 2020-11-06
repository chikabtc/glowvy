import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

class ProductThumbnail extends StatelessWidget {
  const ProductThumbnail(this.product, {this.allowEdit = false});

  final Product product;
  final bool allowEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: kSecondaryWhite),
      padding: EdgeInsets.only(left: 10, right: 10, top: 10.5, bottom: 10.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
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
          Flexible(
            child: Container(
              height: 35,
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
                ],
              ),
            ),
          ),
          Spacer(),
          if (allowEdit)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Change",
                  style: textTheme.caption1.copyWith(color: kSecondaryGrey),
                ),
                SvgPicture.asset(
                  'assets/icons/arrow_forward.svg',
                  width: 24,
                  color: kSecondaryGrey,
                )
              ],
            )
        ],
      ),
    );
  }
}
