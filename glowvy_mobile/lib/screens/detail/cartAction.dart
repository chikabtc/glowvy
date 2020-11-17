import 'package:Dimodo/models/order/cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';

class CartAction extends StatelessWidget {
  const CartAction({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartModel>(builder: (context, value, child) {
      return Stack(children: <Widget>[
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/cart',
              arguments: {'showBackSpace': true}),
          icon: SvgPicture.asset(
            'assets/icons/cart-product-detail.svg',
            width: 24 * kSizeConfig.containerMultiplier,
            height: 24 * kSizeConfig.containerMultiplier,
          ),
        ),
        if (value.totalCartQuantity > 0)
          Positioned(
            right: 7.5,
            top: 7.5,
            child: Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                value.totalCartQuantity.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
      ]);
    });
  }
}
