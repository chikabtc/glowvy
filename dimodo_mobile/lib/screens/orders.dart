import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/models/order/cart.dart';
import 'package:Dimodo/models/order/cartItem.dart';
import 'package:Dimodo/models/order/order.dart';
import 'package:Dimodo/models/order/orderModel.dart';
import 'package:Dimodo/widgets/orderItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:Dimodo/models/user/userModel.dart';

class OrdersScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OrdersScreenState();
  }
}

class OrdersScreenState extends State<OrdersScreen> {
  OrderModel _orderModel;
  bool isOrderComplete;
  UserModel userModel;
  Future<List<Order>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _orderModel = Provider.of<OrderModel>(context, listen: false);

    _ordersFuture = _orderModel.getMyOrders(
        userModel: Provider.of<UserModel>(context, listen: false));
  }

  List<Widget> _createOrders(List<Order> orders) {
    var orderWidgets = <Widget>[];
    if (orders.length > 0) {
      orders.forEach((order) => orderWidgets.add(Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: GestureDetector(
              onTap: () {
                Map<int, CartItem> orderItems = {};
                order.orderItems
                    .forEach((item) => orderItems[item.optionId] = item);
                var cartModel = CartModel();
                if (order.totalDiscounts != null) {
                  cartModel.totalDiscounts = order.totalDiscounts;
                }

                cartModel.addCartItems(orderItems);

                Navigator.pushNamed(context, "/order_submitted", arguments: {
                  'cartModel': cartModel,
                  'isOrderHistory': true,
                  'isOrderConfirmed': order.isPaid
                });
              },
              child: Container(
                padding: EdgeInsets.only(top: 30),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15.0, left: 16, right: 16),
                      child: Row(
                        children: <Widget>[
                          DynamicText(
                              order.isPaid
                                  ? S.of(context).orderDetail
                                  : S.of(context).orderSubmitted,
                              style: kBaseTextStyle.copyWith(
                                  fontSize: 17, fontWeight: FontWeight.w600)),
                          Spacer(),
                          DynamicText(
                              order.isPaid
                                  ? S.of(context).transactionSuccess
                                  : S.of(context).oneStepLeft,
                              style: kBaseTextStyle.copyWith(
                                  color: order.isPaid
                                      ? kGreenPrimary
                                      : Color(0xffF01F0E),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Column(children: _createOrderedItems(order: order))
                  ],
                ),
              ),
            ),
          )));
      return orderWidgets;
    } else {
      return orderWidgets;
    }
  }

  List<Widget> _createOrderedItems({
    Order order,
  }) {
    List<Widget> list = [];
    order.orderItems.asMap().forEach((i, item) => list.add(
          OrderItemRow(
            isDividerNeeded:
                order.orderItems.length > 1 && order.orderItems.length - 1 != i
                    ? true
                    : false,
            cartItem: item,
            isOrder: true,
          ),
        ));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    print("building ordersScreen");

    return Consumer<UserModel>(
      builder: (context, userModel, child) {
        userModel = userModel;
        return Scaffold(
          body: Container(
              color: kLightBG,
              width: screenSize.width,
              height: screenSize.height,
              child: CustomScrollView(slivers: <Widget>[
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
                    title: DynamicText(S.of(context).orders,
                        style: kBaseTextStyle.copyWith(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                FutureBuilder<List<Order>>(
                  future: _ordersFuture,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Order>> snapshot) {
                    if (snapshot.data == null)
                      return SliverList(
                          delegate: SliverChildListDelegate([
                        Container(
                          width: screenSize.width,
                          height: kScreenSizeHeight,
                          child: CupertinoActivityIndicator(animating: true),
                        ),
                      ]));
                    else if (snapshot.data.length == 0)
                      return SliverList(
                          delegate: SliverChildListDelegate([EmptyOrders()]));
                    else
                      return SliverList(
                        delegate: SliverChildListDelegate([
                          Column(children: _createOrders(snapshot.data)),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 42,
                                ),
                              ],
                            ),
                          ),
                        ]),
                      );
                  },
                )
              ])),
        );
      },
    );
  }
}

class EmptyOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        height: screenSize.height -
            AppBar().preferredSize.height -
            MediaQuery.of(context).padding.bottom -
            MediaQuery.of(context).padding.top,
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 120),
                Container(
                    width: 200,
                    height: 236,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Image.asset(
                          'assets/icons/order/empty-order-illustration.png'),
                    )),
                // SizedBox(height: 20),
                DynamicText(S.of(context).noOrdersDescription,
                    style: kBaseTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: kDarkSecondary),
                    textAlign: TextAlign.center),
                SizedBox(height: 50),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: MaterialButton(
                          elevation: 0,
                          color: Colors.transparent,
                          minWidth: screenSize.width,
                          height: 48,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              side: BorderSide(color: kPinkAccent, width: 1.5)),
                          child: DynamicText(S.of(context).continueShopping,
                              style: kBaseTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: kPinkAccent)),
                          onPressed: () {
                            Navigator.of(context).pushNamed('/home');
                          }),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
