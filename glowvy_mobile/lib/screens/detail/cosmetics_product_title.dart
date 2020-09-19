import 'package:Dimodo/common/styles.dart';
import 'package:flutter/material.dart';
import '../../models/product/product.dart';
import '../../widgets/customWidgets.dart';
import '../../common/tools.dart';
import 'package:Dimodo/generated/i18n.dart';

class CosmeticsProductTitle extends StatelessWidget {
  final Product product;

  CosmeticsProductTitle(
    this.product,
  );

  @override
  Widget build(BuildContext context) {
    print("ingredient score: ${product.hazardScore}");
    var tag = product.tags.length == 1
        ? product.tags[0].sname
        : product.tags[1].sname;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "${product.seller.name}",
                    maxLines: 2,
                    style: kBaseTextStyle.copyWith(
                        fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ),
                // SizedBox(height: 5),
                Text(product.name,
                    maxLines: 2,
                    style: kBaseTextStyle.copyWith(
                        fontSize: 17, fontWeight: FontWeight.w600)),
                // SizedBox(height: 5),

                Text(product.categoryName,
                    maxLines: 1,
                    style: kBaseTextStyle.copyWith(
                        color: kDarkSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.normal)),
                // if (product.ingredientScore == 0)

                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Giá tham khảo " +
                        Tools.getPriceProduct(product, "VND") +
                        " . " +
                        product.volume,
                    style: kBaseTextStyle.copyWith(
                        color: kDarkSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
