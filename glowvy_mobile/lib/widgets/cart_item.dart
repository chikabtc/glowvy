import 'package:Dimodo/models/order/cartItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/constants.dart';
import '../common/styles.dart';
import '../common/tools.dart';
import '../models/product/product.dart';
import '../models/app.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Dimodo/widgets/customWidgets.dart';

class CartItemRow extends StatefulWidget {
  CartItemRow(
      {@required this.cartItem,
      this.onRemove,
      this.onChangeQuantity,
      this.isDividerNeeded,
      this.isOrder = false});

  final CartItem cartItem;
  final Function onChangeQuantity;
  final VoidCallback onRemove;
  //isCart checks whether the current widget is cart or confirmToOrder
  //and resize certain sizes based on it
  final bool isOrder;
  final bool isDividerNeeded;

  @override
  _CartItemRowState createState() => _CartItemRowState();
}

class _CartItemRowState extends State<CartItemRow> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    quantity = widget.cartItem.quantity;
    final screenSize = MediaQuery.of(context).size;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(right: 12.0, bottom: 10, top: 10),
      child: Column(children: [
        Row(
          key: ValueKey(widget.cartItem.product.id),
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: SvgPicture.asset('assets/icons/remove_cart_circle.svg'),
              onPressed: widget.onRemove,
            ),
            Expanded(
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(children: <Widget>[
                      ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Image.network(
                              widget.cartItem.product.thumbnail,
                              width: screenSize.width *
                                  0.27 *
                                  kSizeConfig.textMultiplier,
                              height: screenSize.width *
                                  0.27 *
                                  kSizeConfig.textMultiplier,
                            ),

                            // child: Tools.image(url: imageFeature)
                          )),
                    ]),
                    SizedBox(width: 7.0),
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 26.0, bottom: 5),
                              child: Text(widget.cartItem.product.name,
                                  style: kBaseTextStyle.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Wrap(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 36.0),
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        bottom: 2, top: 2, left: 5, right: 5),
                                    decoration: BoxDecoration(
                                        color: kLightBG,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(6),
                                        )),
                                    child: Text(
                                      "${widget.cartItem.option}",
                                      // maxLines: 0,
                                      style: kBaseTextStyle.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: kDarkSecondary),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3),
                            if (widget.cartItem.product.salePercent != null)
                              Opacity(
                                opacity: 0.5,
                                child: Container(
                                  padding: EdgeInsets.only(left: 3, right: 3),
                                  decoration: BoxDecoration(
                                      color: kPinkAccent,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(6),
                                      )),
                                  child: Text(
                                    "-${widget.cartItem.product.salePercent}%",
                                    style: kBaseTextStyle.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            SizedBox(height: 25),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  height: 24,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          Tools.getPriceProduct(
                                              widget.cartItem.product, "VND",
                                              onSale: true),
                                          style: kBaseTextStyle.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: widget.isOrder
                                                  ? kDarkSecondary
                                                  : kPinkAccent)),
                                      Spacer(),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            width: 24,
                                            height: 24,
                                            child: IconButton(
                                                padding: EdgeInsets.all(0),
                                                icon: SvgPicture.asset(
                                                    'assets/icons/product_detail/substract-stepper.svg'),
                                                onPressed: () {
                                                  setState(() {
                                                    if (quantity == 1) {
                                                      return;
                                                    }
                                                    quantity -= 1;

                                                    widget.onChangeQuantity(
                                                        quantity);
                                                  });

                                                  // widget.cartItem.onChangeQuantity(
                                                  //     widget.cartItem.quantity);
                                                }),
                                          ),
                                          SizedBox(width: 3),
                                          Container(
                                            height: 24,
                                            width: 32,
                                            decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6.0)),
                                                border: Border.all(
                                                    style: BorderStyle.solid,
                                                    color: kGrey200,
                                                    width: 1.5)),
                                            child: Text(
                                              quantity.toString(),
                                              textAlign: TextAlign.center,
                                              style: kBaseTextStyle.copyWith(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: kDarkSecondary),
                                            ),
                                          ),
                                          SizedBox(width: 3),
                                          Container(
                                            width: 24,
                                            height: 24,
                                            child: IconButton(
                                                padding: EdgeInsets.all(0),
                                                color: Colors.red,
                                                icon: SvgPicture.asset(
                                                    'assets/icons/product_detail/add-stepper.svg'),
                                                onPressed: () {
                                                  setState(() {
                                                    if (quantity == 10) {
                                                      return;
                                                    }
                                                    quantity += 1;
                                                    widget.onChangeQuantity(
                                                        quantity);
                                                  });
                                                }),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (widget.isDividerNeeded)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
            child: Divider(height: 0),
          )
      ]),
    );
  }
}
