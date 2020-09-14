import 'package:Dimodo/common/styles.dart';
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
import '../setting/shipping_address_small_card.dart';

import 'package:Dimodo/widgets/login_animation.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'orderSummary.dart';

class ConfirmOrder extends StatefulWidget {
  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  AnimationController submitButtonController;
  User user;
  CartModel cartModel;
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
    var countKeys = 0;

    return model.cartItems.keys.map(
      (key) {
        countKeys++;
        return OrderItemRow(
          isDividerNeeded: model.cartItems.length > 1 &&
                  model.cartItems.keys.length != countKeys
              ? true
              : false,
          cartItem: model.getCartItemById(key),
          onRemove: () {
            model.removeItemFromCart(key);
          },
          onChangeQuantity: (val) {
            Provider.of<CartModel>(context, listen: false)
                .updateQuantity(key, val);
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

  void submitOrder() async {
    print("created order");
    cartModel = Provider.of<CartModel>(context, listen: false);
    final userModel = Provider.of<UserModel>(context, listen: false);
    final orderModel = Provider.of<OrderModel>(context, listen: false);

    try {
      _playAnimation();
      isLoading = false;
      var order = Order();
      order.totalShipping = cartModel.getShippingFee();
      order.totalFee = cartModel.getTotal();
      order.totalDiscounts = cartModel.getTotalDiscounts();
      order.userId = userModel.user.id;
      order.addressId = cartModel.address.id != null
          ? cartModel.address.id
          : userModel.user.defaultAddress.id;
      order.appliedCoupons = cartModel.selectedCoupons;

      await orderModel.submitOrder(order: order);

      Navigator.pushReplacementNamed(context, "/order_submitted",
          arguments: {'cartModel': cartModel});
    } catch (err) {
      isLoading = false;
      _stopAnimation();

      print("fail to submit order: ${err.toString()}");
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
                        title: Text(S.of(context).confirmToOrder,
                            style: kBaseTextStyle.copyWith(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      if (model.address == null)
                        ShippingAddressSmallCard(user.defaultAddress),
                      if (model.address != null)
                        ShippingAddressSmallCard(model.address),
                      if (user.addresses.length == 0)
                        ListTile(
                          contentPadding: EdgeInsets.only(
                              top: 16.0, bottom: 14, left: 16, right: 16),
                          onTap: () => {
                            Navigator.pushNamed(
                              context,
                              "/manage_address",
                            )
                          },
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(S.of(context).shippingAddress,
                                  style: kBaseTextStyle.copyWith(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  )),
                              SizedBox(width: 5),
                              Text(S.of(context).pleaseInput,
                                  style: kBaseTextStyle.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: kPinkError)),
                            ],
                          ),
                          trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[CommonIcons.arrowForward]),
                        ),
                      Container(
                          height: 10, color: Theme.of(context).backgroundColor),
                      Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(left: 16, top: 30),
                          child: Text(S.of(context).yourOrderDetail,
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
                                  height: 48,
                                  buttonTitle: S.of(context).submitOrder,
                                  buttonController: submitButtonController.view,
                                  onTap: () {
                                    if (user.defaultAddress == null) {
                                      var isFromOrderPage = true;
                                      Navigator.pushNamed(
                                          context, "/manage_address",
                                          arguments: isFromOrderPage);
                                    }
                                    //should have address saved if not go to the address setting page
                                    else if (!isLoading) {
                                      submitOrder();
                                    }
                                  },
                                ),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                    height: 10, color: kDefaultBackground),
                                Image.asset(
                                  'assets/images/support-illustration.png',
                                ),
                                SizedBox(height: 5),
                                Text(
                                  S.of(context).needHelp,
                                  style: kBaseTextStyle.copyWith(
                                      color: kDarkSecondary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20),
                                MaterialButton(
                                    elevation: 0,
                                    color: kDarkAccent,
                                    minWidth: screenSize.width * 0.3,
                                    height: 36,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(36.0),
                                        side: BorderSide(width: 1.5)),
                                    child: Text(S.of(context).askUs,
                                        style: kBaseTextStyle.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                    onPressed: () =>
                                        CustomerSupport.openFacebookMessenger(
                                            context)),
                                SizedBox(height: 60)
                              ],
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
