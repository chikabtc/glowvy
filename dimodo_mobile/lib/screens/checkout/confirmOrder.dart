import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/services/index.dart';
import 'package:Dimodo/widgets/orderItem.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../generated/i18n.dart';
import '../../models/order/cart.dart';
import '../../models/order/orderModel.dart';
import '../../models/user/user.dart';
import '../../models/user/userModel.dart';
import 'package:Dimodo/common/tools.dart';

import '../../models/order/order.dart';
import '../setting/shippingAddressCard.dart';

import 'package:Dimodo/widgets/login_animation.dart';
import '../../widgets/cart_item.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'orderSubmitted.dart';
import 'orderSummary.dart';
import 'package:localstorage/localstorage.dart';

class ConfirmOrder extends StatefulWidget {
  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  AnimationController submitButtonController;
  User user;
  @override
  void initState() {
    super.initState();
    submitButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    submitButtonController.dispose();
    super.dispose();
  }

  List<Widget> _createShoppingCartRows(CartModel model) {
    final userModel = Provider.of<UserModel>(context, listen: false); //

    var countKeys = 0;

    return model.cartItems.keys.map(
      (key) {
        countKeys++;
        print("countkeys: $countKeys");
        return OrderItemRow(
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

  Future<Null> _playAnimation() async {
    try {
      setState(() {
        isLoading = true;
      });
      await submitButtonController.forward();
    } on TickerCanceled {}
  }

  Future<Null> _stopAnimation() async {
    try {
      await submitButtonController.reverse();
      setState(() {
        isLoading = false;
      });
    } on TickerCanceled {}
  }

  void createOrder() async {
    print("created order");
    final cartModel = Provider.of<CartModel>(context, listen: false);
    final userModel = Provider.of<UserModel>(context, listen: false);
    final orderModel = Provider.of<OrderModel>(context, listen: false);

    try {
      _playAnimation();
      isLoading = false;
      var order = Order();
      order.totalShipping = cartModel.getShippingFee();
      order.totalFee = cartModel.getTotal();
      order.userId = userModel.user.id;
      order.addressId = userModel.user.address.id;

      await orderModel.createOrder(order: order, userModel: userModel);

      Navigator.pushReplacementNamed(context, "/order_submitted",
          arguments: {'cartModel': cartModel});
    } catch (err) {
      isLoading = false;
      _stopAnimation();
      final snackBar = SnackBar(
        content: Text(err.toString()),
      );
      print(err.toString());
      // Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final user = Provider.of<UserModel>(context, listen: false).user;

    return Consumer<CartModel>(
      builder: (context, model, child) {
        return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: SafeArea(
                bottom: false,
                top: false,
                child: Container(
                  height: screenSize.height,
                  decoration:
                      BoxDecoration(color: Theme.of(context).backgroundColor),
                  child: CustomScrollView(slivers: [
                    SliverAppBar(
                      brightness: Brightness.light,
                      leading: IconButton(
                        icon: CommonIcons.arrowBackwardWhite,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      elevation: 0,
                      backgroundColor: kPinkAccent,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        title: DynamicText(S.of(context).confirmToOrder,
                            style: kBaseTextStyle.copyWith(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      Container(
                          color: Colors.white,
                          padding:
                              EdgeInsets.only(left: 16, top: 30, bottom: 12),
                          child: DynamicText(S.of(context).whereToDeliver,
                              style: kBaseTextStyle.copyWith(
                                  fontSize: 17, fontWeight: FontWeight.w600))),
                      if (user.address != null)
                        ShippingAddressSmallCard(user.address),
                      // if (user.address == null)

                      Container(
                          height: 10, color: Theme.of(context).backgroundColor),
                      Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(left: 16),
                          child: DynamicText(S.of(context).orderDetail,
                              style: kBaseTextStyle.copyWith(
                                  fontSize: 17, fontWeight: FontWeight.w600))),
                      Container(
                        color: Colors.pink,
                        child: Column(
                          children: _createShoppingCartRows(model),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 20, bottom: 20, left: 16, right: 16),
                              child: OrderSummary(model: model),
                            ),
                            Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 9.0, bottom: 7, left: 16, right: 16),
                                child: StaggerAnimation(
                                  titleButton: S.of(context).submitOrder,
                                  buttonController: submitButtonController.view,
                                  onTap: () {
                                    if (user.address == null) {
                                      Navigator.pushNamed(
                                          context, "/manage_address");
                                    }
                                    //should have address saved if not go to the address setting page
                                    else if (!isLoading) {
                                      createOrder();
                                    }
                                  },
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 20, bottom: 30),
                              child: Column(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/icons/heart-ballon.svg',
                                    width: 30,
                                    height: 42,
                                  ),
                                  SizedBox(height: 16.5),
                                  DynamicText(
                                    S.of(context).needHelp,
                                    style: kBaseTextStyle.copyWith(
                                        color: kDarkSecondary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 15),
                                  Container(
                                    padding:
                                        EdgeInsets.only(right: 16, left: 16),
                                    width: screenSize.width,
                                    child: Column(
                                      children: <Widget>[],
                                    ),
                                  ),
                                  MaterialButton(
                                      elevation: 0,
                                      color: Colors.transparent,
                                      minWidth: screenSize.width * 0.3,
                                      height: 40,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(25.0),
                                          side: BorderSide(
                                              color: kPinkAccent, width: 1.5)),
                                      child: DynamicText(S.of(context).askUs,
                                          style: kBaseTextStyle.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: kPinkAccent)),
                                      onPressed: CustomerSupport
                                          .openFacebookMessenger),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ])),
                  ]),
                )));
      },
    );
  }

  void doCheckout() async {
    showLoading();
    try {
      hideLoading();
      // widget.controller.animateTo(1,
      //     duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
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

class OrderSummaryCard extends StatelessWidget {
  // final CartModel model;
  final String currency;
  final String title;
  final String subTitle;
  final String fee;
  final bool isTotalFee;

  OrderSummaryCard(
      {this.currency,
      this.title,
      this.subTitle,
      this.fee,
      this.isTotalFee = false});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DynamicText(title,
              style: kBaseTextStyle.copyWith(
                  fontSize: 13, fontWeight: FontWeight.w600)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              DynamicText(
                subTitle,
                style: kBaseTextStyle.copyWith(
                    fontSize: 12, color: kDarkSecondary),
              ),
              Spacer(),
              DynamicText(
                fee,
                style: kBaseTextStyle.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isTotalFee ? kPinkAccent : Colors.black),
              ),
            ],
          ),
        ]);
  }
}
