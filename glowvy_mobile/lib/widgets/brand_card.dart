import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/models/product/brand.dart';
import 'package:Dimodo/screens/brand_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrandCard extends StatelessWidget {
  const BrandCard({
    this.brand,
    this.showDivider = true,
  });
  final Brand brand;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    // print('product sid ${product.sid}');
    return Container(
      // height: 48,
      color: Colors.white,

      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BrandHomePage(brand),
            )),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FittedBox(
                  fit: BoxFit.cover,
                  child: Tools.image(
                    url: brand.image,
                    fit: BoxFit.cover,
                    width: 92,
                    height: 48,
                    size: kSize.large,
                  ),
                ),
                const SizedBox(width: 7),
                Text(brand.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyText1),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
