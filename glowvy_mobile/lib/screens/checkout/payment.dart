// import 'package:flutter/material.dart';
// import 'package:localstorage/localstorage.dart';
// import 'package:provider/provider.dart';

// import '../../common/config.dart';
// import '../../common/constants.dart';
// import '../../common/styles.dart';
// import '../../common/tools.dart';
// import '../../generated/i18n.dart';
// import '../../models/order/cart.dart';
// import '../../models/order/order.dart';
// import '../../models/payment_method.dart';
// import '../../models/user/user.dart';
// import '../../services/index.dart';
// import '../../widgets/payment/tap/index.dart';
// import 'payment_webview.dart';

// class PaymentMethods extends StatefulWidget {
//   final Function onBack;
//   final Function onFinish;
//   final Function(bool) onLoading;

//   PaymentMethods({this.onBack, this.onFinish, this.onLoading});

//   @override
//   _PaymentMethodsState createState() => _PaymentMethodsState();
// }

// class _PaymentMethodsState extends State<PaymentMethods> {
//   String selectedId;

//   @override
//   void initState() {
//     super.initState();

//     Future.delayed(Duration.zero, () {
//       final cartModel = Provider.of<CartModel>(context);
//       final userModel = Provider.of<UserModel>(context, listen: false);
//       Provider.of<PaymentMethodModel>(context).getPaymentMethods(
//           address: cartModel.address,
//           // shippingMethod: cartModel.shippingMethod,
//           token: userModel.user != null ? userModel.user.accessToken : null);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cartModel = Provider.of<CartModel>(context);
//     final paymentMethodModel = Provider.of<PaymentMethodModel>(context);

//     return ListenableProvider.value(
//         value: paymentMethodModel,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(S.of(context).paymentMethods, style: TextStyle(fontSize: 16)),
//             SizedBox(height: 5),
//             Text(
//               S.of(context).chooseYourPaymentMethod,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Theme.of(context).accentColor.withOpacity(0.6),
//               ),
//             ),
//             SizedBox(height: 20),
//             Consumer<PaymentMethodModel>(builder: (context, model, child) {
//               if (model.isLoading) {
//                 return Container(height: 100, child: kLoadingWidget(context));
//               }

//               if (model.message != null) {
//                 return Container(
//                   height: 100,
//                   child: Center(
//                       child: Text(model.message,
//                           style: TextStyle(color: kErrorRed))),
//                 );
//               }

//               if (selectedId == null && model.paymentMethods.length > 0) {
//                 selectedId =
//                     model.paymentMethods.firstWhere((item) => item.enabled).id;
//               }

//               return Column(
//                 children: <Widget>[
//                   for (int i = 0; i < model.paymentMethods.length; i++)
//                     model.paymentMethods[i].enabled
//                         ? Column(
//                             children: <Widget>[
//                               InkWell(
//                                 onTap: () {
//                                   setState(() {
//                                     selectedId = model.paymentMethods[i].id;
//                                   });
//                                 },
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                       color: model.paymentMethods[i].id ==
//                                               selectedId
//                                           ? Theme.of(context).primaryColorLight
//                                           : Colors.transparent),
//                                   child: Padding(
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: 15, horizontal: 10),
//                                     child: Row(
//                                       children: <Widget>[
//                                         Radio(
//                                             value: model.paymentMethods[i].id,
//                                             groupValue: selectedId,
//                                             onChanged: (i) {
//                                               setState(() {
//                                                 selectedId = i;
//                                               });
//                                             }),
//                                         SizedBox(width: 10),
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: <Widget>[
//                                               if (Payments[model
//                                                       .paymentMethods[i].id] !=
//                                                   null)
//                                                 Image.asset(
//                                                   Payments[model
//                                                       .paymentMethods[i].id],
//                                                   width: 120,
//                                                   height: 30,
//                                                 ),
//                                               if (Payments[model
//                                                       .paymentMethods[i].id] ==
//                                                   null)
//                                                 Text(
//                                                   model.paymentMethods[i].title,
//                                                   style: TextStyle(
//                                                     fontSize: 14,
//                                                     color: Theme.of(context)
//                                                         .accentColor
//                                                         .withOpacity(0.8),
//                                                   ),
//                                                 ),
//                                             ],
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Divider(height: 1)
//                             ],
//                           )
//                         : Container()
//                 ],
//               );
//             }),
//             SizedBox(height: 20),
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Text(
//                     S.of(context).subtotal,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Theme.of(context).accentColor.withOpacity(0.8),
//                     ),
//                   ),
//                   Text(
//                       Tools.getCurrecyFormatted(cartModel.getSubTotal(),
//                           currency: cartModel.currency),
//                       style: TextStyle(fontSize: 14, color: kGrey400))
//                 ],
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Text(
//                     S.of(context).total,
//                     style: TextStyle(
//                         fontSize: 16, color: Theme.of(context).accentColor),
//                   ),
//                   Text(
//                     Tools.getCurrecyFormatted(cartModel.getTotal(),
//                         currency: cartModel.currency),
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Theme.of(context).accentColor,
//                       fontWeight: FontWeight.w600,
//                       decoration: TextDecoration.underline,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             // Row(children: [
//             //   Expanded(
//             //     child: ButtonTheme(
//             //       height: 45,
//             //       child: RaisedButton(
//             //         onPressed: () {
//             //           if (paymentMethodModel.paymentMethods.length > 0) {
//             //             final paymentMethod = paymentMethodModel.paymentMethods
//             //                 .firstWhere((item) => item.id == selectedId);
//             //             if (paymentMethod.id
//             //                     .contains(PaypalConfig["paymentMethodId"]) &&
//             //                 PaypalConfig["enabled"] == true) {
//             //               Navigator.push(
//             //                 context,
//             //               );
//             //             } else if (paymentMethod.id
//             //                     .contains(RazorpayConfig["paymentMethodId"]) &&
//             //                 RazorpayConfig["enabled"] == true) {
//             //               Navigator.push(
//             //                 context,
//             //                 MaterialPageRoute(
//             //                     builder: (context) =>
//             //                         RazorpayPayment(onFinish: (number) {
//             //                           createOrder(paid: true);
//             //                         })),
//             //               );
//             //             } else if (paymentMethod.id
//             //                     .contains(TapConfig["paymentMethodId"]) &&
//             //                 TapConfig["enabled"] == true) {
//             //               Navigator.push(
//             //                 context,
//             //                 MaterialPageRoute(
//             //                     builder: (context) =>
//             //                         TapPayment(onFinish: (number) {
//             //                           createOrder(paid: true);
//             //                         })),
//             //               );
//             //             } else {
//             //               if (paymentMethod.id == "cod" ||
//             //                   serverConfig["type"] == "magento") {
//             //                 createOrder(cod: true);
//             //               } else if (serverConfig["type"] == "woo") {
//             //                 final user = Provider.of<UserModel>(context, listen: false).user;
//             //                 var params = Order().toJson(
//             //                     cartModel, user != null ? user.id : null, true);
//             //                 params["token"] = user != null ? user.accessToken : null;
//             //                 Navigator.push(
//             //                   context,
//             //                   MaterialPageRoute(
//             //                       builder: (context) => PaymentWebview(
//             //                           params: params,
//             //                           onFinish: (number) {
//             //                             widget.onFinish(Order(number: number));
//             //                           })),
//             //                 );
//             //               } else if (serverConfig["type"] == "opencart") {
//             //                 Navigator.push(
//             //                   context,
//             //                   MaterialPageRoute(
//             //                       builder: (context) =>
//             //                           PaymentWebview(onFinish: (number) {
//             //                             widget.onFinish(Order(number: number));
//             //                           })),
//             //                 );
//             //               }
//             //             }
//             //           }
//             //         },
//             //         textColor: Colors.white,
//             //         color: Theme.of(context).primaryColor,
//             //         child: Text(S.of(context).placeMyOrder.toUpperCase()),
//             //       ),
//             //     ),
//             //   ),
//             // ]),
//             Center(
//               child: FlatButton(
//                 onPressed: () {
//                   widget.onBack();
//                 },
//                 child: Text(
//                   S.of(context).goBackToReview,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     decoration: TextDecoration.underline,
//                     fontSize: 15,
//                     color: Theme.of(context).accentColor,
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ));
//   }

//   void createOrder({paid = false, cod = false}) async {
//     final LocalStorage storage = new LocalStorage('data_order');
//     var listOrder = [];
//     bool isLoggedIn = Provider.of<UserModel>(context, listen: false).loggedIn;

//     widget.onLoading(true);
//     final cartModel = Provider.of<CartModel>(context);
//     final userModel = Provider.of<UserModel>(context, listen: false);
//     try {
//       final order = await Services()
//           .createOrder(order: cartModel, user: userModel, paid: paid);
//       if (cod) await Services().updateOrder(order.id, status: 'processing');
//       widget.onLoading(false);
//       if (!isLoggedIn) {
//         var items = storage.getItem('orders');
//         if (items != null) {
//           listOrder = items;
//         }
//         listOrder.add(order.toOrderJson(cartModel, null));
//         storage.setItem('orders', listOrder);
//       }
//       widget.onFinish(order);
//     } catch (err) {
//       widget.onLoading(false);

//       final snackBar = SnackBar(
//         content: Text(err.toString()),
//       );
//       Scaffold.of(context).showSnackBar(snackBar);
//     }
//   }
// }
