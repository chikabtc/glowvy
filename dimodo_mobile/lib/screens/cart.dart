import 'dart:async';

import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/models/coupon.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../generated/i18n.dart';
import '../models/order/cart.dart';
import '../widgets/cart_item.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'checkout/confirmOrder.dart';
import 'shoppingCartSummary.dart';
import 'package:flutter/cupertino.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Dimodo/widgets/login_animation.dart';

class Cart extends StatefulWidget {
  final PageController controller;
  final bool isModal;

  Cart({this.controller, this.isModal});

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart>
    with SingleTickerProviderStateMixin, TickerProviderStateMixin {
  bool isLoading = false;
  Timer timer;
  var timeout = const Duration(seconds: 2);

  var bottomPopupHeightFactor;
  var screenSize;
  CartModel cartModel;
  UserModel userModel;
  List<Coupon> coupons = [];
  AnimationController addToCartButtonController;

  @override
  void initState() {
    super.initState();
    cartModel = Provider.of<CartModel>(context, listen: false);
    userModel = Provider.of<UserModel>(context, listen: false);
    cartModel.getAllCoupons(userModel).then((onValues) {
      setState(() {
        coupons = onValues;
        print("coupon1: ${coupons[0].toJson()}");
      });
    });
    addToCartButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
  }

  List<Widget> _createShoppingCartRows(CartModel model) {
    var countKeys = 0;

    return model.cartItems.keys.map(
      (key) {
        countKeys++;
        return CartItemRow(
          isDividerNeeded: model.cartItems.length > 1 &&
                  model.cartItems.keys.length != countKeys
              ? true
              : false,
          cartItem: model.getCartItemById(key),
          onRemove: () {
            model.removeItemFromCart(key, userModel);
          },
          onChangeQuantity: (val) {
            Provider.of<CartModel>(context, listen: false)
                .updateQuantity(key, val, userModel);
          },
        );
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    bottomPopupHeightFactor = 1 -
        (AppBar().preferredSize.height +
                60 +
                MediaQuery.of(context).padding.bottom) /
            kScreenSizeHeight;
    bool showBackSpace = false;
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) showBackSpace = arguments['showBackSpace'];

    return Consumer<CartModel>(builder: (context, cartModel, child) {
      return Scaffold(
          bottomNavigationBar: cartModel.totalCartQuantity > 0
              ? SafeArea(
                  bottom: true,
                  child: Container(
                    height: 104,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ShoppingCartSummary(model: cartModel),
                        Container(
                          height: 56,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 9.0, bottom: 7, left: 16, right: 16),
                            child: MaterialButton(
                                elevation: 0,
                                padding: EdgeInsets.all(0),
                                color: kPinkAccent,
                                minWidth: screenSize.width,
                                height: 40,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    side: BorderSide(
                                        color: kPinkAccent, width: 1.5)),
                                child: DynamicText(S.of(context).checkout,
                                    style: kBaseTextStyle.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ConfirmOrder()));
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : null,
          backgroundColor: Theme.of(context).backgroundColor,
          body: SafeArea(
              top: false,
              child: Container(
                height: screenSize.height,
                decoration:
                    BoxDecoration(color: Theme.of(context).backgroundColor),
                child: CustomScrollView(slivers: [
                  SliverAppBar(
                    brightness: Brightness.light,
                    leading: showBackSpace
                        ? IconButton(
                            icon: CommonIcons.arrowBackward,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        : Container(),
                    elevation: 0,
                    backgroundColor: kPinkAccent,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: DynamicText(S.of(context).cart,
                          style: kBaseTextStyle.copyWith(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  if (cartModel.totalCartQuantity == 0)
                    SliverList(
                        delegate: SliverChildListDelegate([EmptyCart()])),
                  if (cartModel.totalCartQuantity == 0)
                    SliverList(
                        delegate: SliverChildListDelegate([
                      ProductModel.showProductListByCategory(
                          cateId: 9, sortBy: "id", limit: 200, context: context)
                    ])),
                  if (cartModel.totalCartQuantity > 0)
                    SliverList(
                        delegate: SliverChildListDelegate([
                      CouponCard(
                          // coupon: "choose",
                          onTap: onSelectCoupons,
                          context: context,
                          isSelector: true),
                      Column(
                        children: _createShoppingCartRows(cartModel),
                      ),
                    ])),
                ]),
              )));
    });
  }

  _toggle() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  hideToast(StateSetter setState) {
    timer = Timer(timeout, () {
      setState(() {
        isLoading = false;
      });
    });
    return timer;
  }

  onSelectCoupons(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return FractionallySizedBox(
                heightFactor: bottomPopupHeightFactor,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
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
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
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
                      (coupons.length == 0)
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
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  for (var i = 0; i < coupons.length; i++)
                                    CouponCard(
                                        coupon: coupons[i] ?? "free",
                                        onTap: () {
                                          cartModel.setCoupon(coupons[i]);
                                          setState(() {
                                            isLoading = true;
                                          });
                                          hideToast(setState);
                                        },
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                      'assets/icons/cart/checkMark.svg'),
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
                                  })),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }).then((void value) {
      isLoading = false;
      timer.cancel();
    });
  }

  void doCheckout() async {
    showLoading();
    try {
      hideLoading();
      widget.controller.animateToPage(1,
          duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
    } catch (err) {
      hideLoading();
      Fluttertoast.showToast(
          msg: err.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void showLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void hideLoading() {
    setState(() {
      isLoading = false;
    });
  }
}

class CouponCard extends StatefulWidget {
  final Function onTap;
  final Coupon coupon;
  final context;
  final isSelector;

  CouponCard({this.coupon, this.onTap, this.context, this.isSelector});

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
            height: 56,
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
                    child: DynamicText(
                        widget.isSelector ? "" : widget.coupon.discountType,
                        textAlign: TextAlign.center,
                        style: kBaseTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: isSelected
                                ? kAccentPurple.withOpacity(0.1)
                                : kAccentPurple)),
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
                      height: 56,
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        height: 36,
                        // width: 160,
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
                      ),
                    ),
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

class EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/icons/cart/empty-cart-illustration.png',
                ),
              ),
              // SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: DynamicText(S.of(context).emptyCartSubtitle,
                    style: kBaseTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: kDarkSecondary),
                    textAlign: TextAlign.center),
              ),
              SizedBox(height: 50),
            ]),
        Padding(
          padding: const EdgeInsets.only(left: 7.0),
          child: DynamicText(
            S.of(context).youMayAlsoLike,
            style: kBaseTextStyle.copyWith(
                fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class CartScreen extends StatefulWidget {
  final bool isModal;

  CartScreen({this.isModal});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: <Widget>[
        Cart(controller: pageController, isModal: widget.isModal),
      ],
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
