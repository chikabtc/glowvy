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

class OrderItemRow extends StatefulWidget {
  OrderItemRow(
      {@required this.cartItem,
      this.onRemove,
      this.isDividerNeeded,
      this.onChangeQuantity,
      this.isOrder = false});

  final CartItem cartItem;
  final Function onChangeQuantity;
  final bool isDividerNeeded;
  final VoidCallback onRemove;
  //isCart checks whether the current widget is cart or confirmToOrder
  //and resize certain sizes based on it
  final bool isOrder;

  @override
  _OrderItemRowState createState() => _OrderItemRowState();
}

class _OrderItemRowState extends State<OrderItemRow> {
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
            SizedBox(width: 24),
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
                            // color: Colors.brown,

                            child: Image.network(
                                widget.cartItem.product.thumbnail,
                                width: screenSize.width *
                                    0.3 *
                                    kSizeConfig.textMultiplier,
                                height: screenSize.width *
                                    0.3 *
                                    kSizeConfig.textMultiplier),

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
                                        bottom: 2, top: 2, left: 8, right: 8),
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
                                // if (!widget.isCart) Spacer(),
                              ],
                            ),
                            SizedBox(height: 3),
                            Container(
                              // height: 24,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        "x$quantity",
                                        textAlign: TextAlign.end,
                                        style: kBaseTextStyle.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: kDarkSecondary),
                                      ),
                                      Text(
                                          Tools.getPriceProduct(
                                              widget.cartItem.product, "VND",
                                              onSale: true),
                                          style: kBaseTextStyle.copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: widget.isOrder
                                                  ? kDarkSecondary
                                                  : kDarkBG)),
                                    ],
                                  ),
                                ],
                              ),
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
        if (widget.isDividerNeeded) Divider()
      ]),
    );
  }
}
