import 'package:Dimodo/common/styles.dart';
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

class Cart extends StatefulWidget {
  final PageController controller;
  final bool isModal;

  Cart({this.controller, this.isModal});

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> with SingleTickerProviderStateMixin {
  bool isLoading = false;
  var bottomPopupHeightFactor;
  var screenSize;

  List<Widget> _createShoppingCartRows(CartModel model) {
    final userModel = Provider.of<UserModel>(context, listen: false); //

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
                      SizedBox(height: 5),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => onOrderConfirmed(context),
                              child: Container(
                                padding: EdgeInsets.all(5),
                                height: 40,
                                decoration: new BoxDecoration(
                                  color: kPinkAccent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: DynamicText(
                                      S.of(context).selectOrEnterCoupon,
                                      style: kBaseTextStyle.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            )
                          ]),
                      SizedBox(height: 5),
                      Container(
                        // height: screenSize.height -
                        //     MediaQuery.of(context).padding.top -
                        //     MediaQuery.of(context).padding.bottom -
                        //     100,
                        child: Column(
                          children: _createShoppingCartRows(cartModel),
                        ),
                      ),
                    ])),
                ]),
              )));
    });
  }

  void onOrderConfirmed(context) {
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
                    color: kDefaultBackground,
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
                              child: DynamicText(S.of(context).writeReview,
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
                                Navigator.pop(context);
                              }),
                        )
                      ]),
                      Container(
                          width: 200,
                          height: 236,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Image.asset(
                                'assets/icons/cart/received-package-illustration.png'),
                          )),
                      // SizedBox(height: 20),
                      DynamicText(S.of(context).askServiceQuality,
                          style: kBaseTextStyle.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center),
                      SizedBox(height: 28),
                      Container(
                        height: 140,
                        color: Colors.white,
                        padding: EdgeInsets.only(left: 16),
                        child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            cursorColor: kPinkAccent,
                            style: kBaseTextStyle.copyWith(
                                fontSize: 15 * kSizeConfig.textMultiplier,
                                fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                                hintText: S.of(context).askForFeedback,
                                hintStyle: kBaseTextStyle.copyWith(
                                    fontSize: 14,
                                    color: kDarkSecondary.withOpacity(0.5)),
                                border: InputBorder.none,
                                hintMaxLines: 3,
                                labelStyle: kBaseTextStyle.copyWith(
                                    fontSize: 15 * kSizeConfig.textMultiplier,
                                    fontWeight: FontWeight.w600,
                                    color: kDarkAccent.withOpacity(0.5)),
                                focusColor: kPinkAccent,
                                fillColor: kPinkAccent,
                                hoverColor: kPinkAccent),
                            validator: (val) {
                              return val.isEmpty
                                  ? S.of(context).fullNameIsRequired
                                  : null;
                            },
                            onChanged: (String value) {}),
                      ),
                      // Expanded(
                      //   child: Align(
                      //     alignment: FractionalOffset.bottomCenter,
                      //     child: Padding(
                      //       padding: const EdgeInsets.only(
                      //           left: 16, right: 16, bottom: 40.0),
                      //       child: MaterialButton(
                      //           elevation: 0,
                      //           color: kPinkAccent,
                      //           minWidth: kScreenSizeWidth,
                      //           height: 40,
                      //           shape: RoundedRectangleBorder(
                      //               borderRadius:
                      //                   new BorderRadius.circular(25.0),
                      //               side: BorderSide(
                      //                   color: kPinkAccent, width: 1.5)),
                      //           child: DynamicText(S.of(context).send,
                      //               style: kBaseTextStyle.copyWith(
                      //                   fontSize: 14,
                      //                   fontWeight: FontWeight.w600,
                      //                   color: Colors.white)),
                      //           onPressed: ()
                      //               ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            },
          );
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
