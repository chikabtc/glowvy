import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/models/coupon.dart';
import 'package:flutter/material.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:Dimodo/common/tools.dart';

class CouponCard extends StatefulWidget {
  final Function onTap;
  final Coupon coupon;
  final context;
  final isSelector;
  bool isSelected;

  CouponCard(
      {this.coupon,
      this.onTap,
      this.context,
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
              widget.isSelector
                  ? widget.onTap(context)
                  : setState(() {
                      isSelected = !isSelected;
                      widget.onTap();
                    });
            },
            height: 70,
            elevation: 0,
            color: kAccentPurple.withOpacity(0.1),
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
                        DynamicText(
                            widget.coupon != null
                                ? widget.coupon.description
                                : "",
                            textAlign: TextAlign.center,
                            style: kBaseTextStyle.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: isSelected
                                    ? kAccentPurple.withOpacity(0.1)
                                    : kAccentPurple)),
                        DynamicText(
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
                                    ? kAccentPurple.withOpacity(0.1)
                                    : kAccentPurple)),
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
                        dashColor: kAccentPurple.withOpacity(1),
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
                                  color: kAccentPurple,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: DynamicText(
                                    "nhận phiếu giảm giá",
                                    textAlign: TextAlign.center,
                                    style: kBaseTextStyle.copyWith(
                                        fontSize: 14,
                                        color: isSelected
                                            ? kAccentPurple.withOpacity(0.1)
                                            : Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )
                            : DynamicText(
                                "Có Nhận",
                                textAlign: TextAlign.center,
                                style: kBaseTextStyle.copyWith(
                                    fontSize: 14,
                                    color: isSelected
                                        ? kAccentPurple.withOpacity(0.1)
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
          color:
              i % 2 == 0 ? Colors.transparent : kAccentPurple.withOpacity(0.2),
          // margin: EdgeInsets.only(left: emptyWidth / 2, right: emptyWidth / 2),
        ),
      ),
    );
  }
}
