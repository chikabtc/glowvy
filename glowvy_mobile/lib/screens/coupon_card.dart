import 'package:Dimodo/common/styles.dart';

import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/models/coupon.dart';
import 'package:Dimodo/models/order/cart.dart';
import 'package:flutter/material.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:provider/provider.dart';

class CouponCard extends StatefulWidget {
  final Function onTap;
  final Coupon coupon;
  final context;
  final isSelector;
  final bool isSelected;
  final bool isCouponApplicable;

  CouponCard(
      {this.coupon,
      this.onTap,
      this.context,
      this.isCouponApplicable = true,
      this.isSelector,
      this.isSelected = false});

  @override
  _CouponCardState createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard> {
  bool isSelected = false;

  onCouponSelected() {
    Navigator.of(widget.context).pop();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> showAddedToCartAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user can tap anywhere to dismiss the popup!
      builder: (BuildContext buildContext) {
        // Future.delayed(const Duration(milliseconds: 1500), () {
        //   Navigator.of(buildContext).pop();
        // });

        return AlertDialog(
          title: Text(
            S.of(context).addedToYourCart,
            style: kBaseTextStyle,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok',
                style: kBaseTextStyle,
              ),
              onPressed: () {
                Navigator.of(buildContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // print("description: ${widget.coupon.description}");
    isSelected = widget.isSelected;
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Expanded(
          child: MaterialButton(
            onPressed: () {
              if (!widget.isCouponApplicable) {
                showAddedToCartAlert();
              } else {
                widget.isSelector
                    ? widget.onTap(context)
                    : setState(() {
                        isSelected = !isSelected;
                        widget.onTap();
                      });
              }
            },
            height: 70,
            elevation: 0,
            color: kAccentRed.withOpacity(0.1),
            padding: EdgeInsets.symmetric(horizontal: 10),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(6.0),
            ),
            child: Center(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                            widget.coupon != null
                                ? widget.coupon.description
                                : "",
                            textAlign: TextAlign.center,
                            style: kBaseTextStyle.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: isSelected
                                    ? kAccentRed.withOpacity(0.1)
                                    : kAccentRed)),
                        Text(
                            widget.coupon != null
                                ? widget.coupon.discountAmount != 0
                                    ? Tools.getCurrecyFormatted(
                                        widget.coupon.discountAmount)
                                    : widget.coupon.discountType
                                : "",
                            textAlign: TextAlign.center,
                            style: kBaseTextStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: isSelected
                                    ? kAccentRed.withOpacity(0.1)
                                    : kAccentRed)),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                      ),
                      DotWidget(
                        totalWidth: 200,
                        dashColor: kAccentRed.withOpacity(1),
                        dashHeight: 1.5,
                        dashWidth: 0.7,
                      ),
                      Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                        height: 70,
                        alignment: Alignment.center,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: !isSelected
                            ? Container(
                                height: 36,
                                decoration: new BoxDecoration(
                                  color: kAccentRed,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Text(
                                    "nhận phiếu giảm giá",
                                    textAlign: TextAlign.center,
                                    style: kBaseTextStyle.copyWith(
                                        fontSize: 14,
                                        color: isSelected
                                            ? kAccentRed.withOpacity(0.1)
                                            : Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )
                            : Text(
                                "Có Nhận",
                                textAlign: TextAlign.center,
                                style: kBaseTextStyle.copyWith(
                                    fontSize: 14,
                                    color: isSelected
                                        ? kAccentRed.withOpacity(0.1)
                                        : Colors.white,
                                    fontWeight: FontWeight.w600),
                              )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class DotWidget extends StatelessWidget {
  final double totalWidth, dashWidth, emptyWidth, dashHeight;
  final Color dashColor;

  const DotWidget({
    this.totalWidth = 260,
    this.dashWidth = 10,
    this.emptyWidth = 5,
    this.dashHeight = 2,
    this.dashColor = Colors.black,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        totalWidth ~/ (dashWidth + emptyWidth),
        (i) => Container(
          width: dashWidth,
          height: dashHeight,
          color: i % 2 == 0 ? Colors.transparent : kAccentRed.withOpacity(0.2),
          // margin: EdgeInsets.only(left: emptyWidth / 2, right: emptyWidth / 2),
        ),
      ),
    );
  }
}
