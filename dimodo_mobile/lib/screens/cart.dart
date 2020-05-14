import 'dart:async';

import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/models/coupon.dart';
import 'package:Dimodo/models/product/product.dart';
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
import 'coupon_card.dart';
import 'coupon_bottom_modal.dart';
import 'package:Dimodo/services/index.dart';

class Cart extends StatefulWidget {
  final PageController controller;
  final bool isModal;

  Cart({this.controller, this.isModal});

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<Cart> {
  bool isLoading = false;
  Timer timer;
  var timeout = const Duration(seconds: 2);
  static Services service = Services();

  var screenSize;
  CartModel cartModel;
  UserModel userModel;
  List<Coupon> coupons = [];
  Future<List<Coupon>> _getAllCoupons;
  Future<List<Product>> _getProductsByCategory;

  @override
  void initState() {
    super.initState();
    cartModel = Provider.of<CartModel>(context, listen: false);
    userModel = Provider.of<UserModel>(context, listen: false);
    _getAllCoupons = cartModel.getAllCoupons(userModel);
    _getProductsByCategory = service.fetchProductsByCategory(
        categoryId: "9", sortBy: "sale_price", limit: 200);
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
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("building cart screen!");

    bool showBackSpace = false;
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) showBackSpace = arguments['showBackSpace'];
    screenSize = MediaQuery.of(context).size;

    return Consumer<CartModel>(builder: (context, cartModel, child) {
      print("building cart contents!");
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
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Consumer<CartModel>(builder: (context, cartModel, child) {
                      return CouponCard(
                          coupon: cartModel.selectedCoupons.length != 0
                              ? cartModel.selectedCoupons[0]
                              : null,
                          onTap: onSelectCoupons,
                          context: context,
                          isSelected: cartModel.selectedCoupons.length == 0
                              ? false
                              : true,
                          isSelector: true);
                    }),
                    if (cartModel.totalCartQuantity == 0) EmptyCart(),
                    if (cartModel.totalCartQuantity == 0)
                      ProductModel.showProductList(
                          future: _getProductsByCategory),
                    if (cartModel.totalCartQuantity > 0)
                      Column(
                        children: _createShoppingCartRows(cartModel),
                      ),
                  ])),
                ]),
              )));
    });
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
          print("AsyncSnapshot");

          return FutureBuilder<List<Coupon>>(
              future: _getAllCoupons,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Coupon>> snapshot) {
                if (snapshot.data != null) coupons = snapshot.data;

                return CouponBottomModal(coupons: coupons);
              });
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
