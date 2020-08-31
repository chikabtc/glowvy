// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../generated/i18n.dart';
// import '../../models/order/cart.dart';
// import '../../models/order/order.dart';
// import 'shipping_address.dart';
// import 'package:after_layout/after_layout.dart';

// class Checkout extends StatefulWidget {
//   @override
//   _CheckoutState createState() => _CheckoutState();
// }

// class _CheckoutState extends State<Checkout> with AfterLayoutMixin {
//   int tabIndex = 0;
//   Order newOrder;

//   @override
//   void initState() {
//     super.initState();
//   }

//   void setLoading(bool loading) {
//     setState(() {});
//   }

//   @override
//   void afterFirstLayout(BuildContext context) {}

//   @override
//   Widget build(BuildContext context) {
//     final cartModel = Provider.of<CartModel>(context, listen: false);

//     return Stack(
//       children: <Widget>[
//         Scaffold(
//           backgroundColor: Theme.of(context).backgroundColor,
//           appBar: AppBar(
//             backgroundColor: Theme.of(context).backgroundColor,
//             title: Text(
//               S.of(context).addAddress,
//               style: TextStyle(
//                 color: Theme.of(context).accentColor,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             leading: Center(
//               child: GestureDetector(
//                 onTap: () => Navigator.of(context).pop(),
//                 child: Icon(
//                   Icons.arrow_back_ios,
//                   color: Theme.of(context).accentColor,
//                   size: 20,
//                 ),
//               ),
//             ),
//           ),
//           body: SafeArea(
//             child: Column(
//                     children: <Widget>[
//                       Expanded(
//                         child: ListView(
//                           padding: EdgeInsets.only(top: 20, bottom: 10),
//                           children: <Widget>[ShippingAddress()],
//                         ),
//                       )
//                     ],
//                   ),
//           ),
//         ),
//       ],
//     );
//   }
// }
