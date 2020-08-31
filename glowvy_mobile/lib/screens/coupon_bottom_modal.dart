import 'dart:async';
import 'package:provider/provider.dart';
import 'package:Dimodo/models/user/userModel.dart';

import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/models/coupon.dart';
import 'package:flutter/material.dart';
import '../generated/i18n.dart';
import '../models/order/cart.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Dimodo/widgets/login_animation.dart';
import 'coupon_card.dart';

class CouponBottomModal extends StatefulWidget {
  CouponBottomModal({this.coupons});
  List<Coupon> coupons = [];

  @override
  _CouponBottomModalState createState() => _CouponBottomModalState();
}

class _CouponBottomModalState extends State<CouponBottomModal>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  double bottomPopupHeightFactor;
  var screenSize;
  bool isLoading = false;
  AnimationController addToCartButtonController;
  Timer timer;
  var timeout = const Duration(seconds: 2);
  CartModel cartModel;
  @override
  void initState() {
    super.initState();
    addToCartButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
    cartModel = Provider.of<CartModel>(context, listen: false);
  }

  void dispose() {
    // timer = Timer(timeout, () {
    //   setState(() {
    //     isLoading = false;
    //   });
    // });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    screenSize = MediaQuery.of(context).size;
    bottomPopupHeightFactor = 1 -
        (AppBar().preferredSize.height +
                60 +
                MediaQuery.of(context).padding.bottom) /
            kScreenSizeHeight;

    return FractionallySizedBox(
      heightFactor: bottomPopupHeightFactor,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        width: screenSize.width,
        height: screenSize.height * bottomPopupHeightFactor -
            AppBar().preferredSize.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  height: AppBar().preferredSize.height,
                  width: kScreenSizeWidth,
                  child: Center(
                    child: DynamicText(S.of(context).discount,
                        style: kBaseTextStyle.copyWith(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                  )),
              Positioned(
                top: 6,
                right: 0,
                child: IconButton(
                    icon: SvgPicture.asset(
                        'assets/icons/address/close-popup.svg'),
                    onPressed: () {
                      isLoading = false;
                      Navigator.pop(context);
                    }),
              ),
            ]),
            SizedBox(height: 20),
            (widget.coupons.length == 0)
                ? Padding(
                    padding: const EdgeInsets.only(top: 200.0),
                    child: DynamicText(
                      S.of(context).noCouponsAvailable,
                      style: kBaseTextStyle.copyWith(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  )
                : Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: DynamicText(
                            S.of(context).couponCode,
                            style: kBaseTextStyle.copyWith(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                        for (var i = 0; i < widget.coupons.length; i++)
                          CouponCard(
                              coupon: widget.coupons.length != 0
                                  ? widget.coupons[i]
                                  : null,
                              onTap: () {
                                cartModel.setCoupon(widget.coupons[i]);
                                setState(() {
                                  isLoading = true;
                                });
                                timer = Timer(timeout, () {
                                  if (this.mounted) {
                                    print("running timer");
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                });
                              },
                              isSelected: cartModel.selectedCoupons
                                  .contains(widget.coupons[i]),
                              context: context,
                              isSelector: false),
                      ],
                    ),
                  ),
            Spacer(),
            IgnorePointer(
                ignoring: !isLoading,
                child: AnimatedOpacity(
                  opacity: isLoading ? 1 : 0,
                  duration: Duration(milliseconds: 200),
                  child: Container(
                    height: 72,
                    width: 100,
                    decoration: BoxDecoration(
                        color: kGrey200,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset('assets/icons/cart/checkMark.svg'),
                        SizedBox(height: 6),
                        Center(
                          child: DynamicText(
                            S.of(context).username,
                            textAlign: TextAlign.center,
                            style: kBaseTextStyle.copyWith(
                                fontSize: 12, color: kDarkSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 40.0,
                    ),
                    child: StaggerAnimation(
                        buttonController: addToCartButtonController,
                        buttonTitle: S.of(context).done,
                        btnColor: kPinkAccent,
                        btnTitleColor: Colors.white,
                        onTap: () {
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.of(context).pop();
                        })),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
