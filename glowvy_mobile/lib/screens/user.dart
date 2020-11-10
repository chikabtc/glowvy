import 'package:Dimodo/models/order/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user/userModel.dart';
import 'profile.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    //wait until the userModel finishes running the getUser and address functions
    final userModel = Provider.of<UserModel>(context, listen: true);
    final cartModel = Provider.of<CartModel>(context, listen: true);

    return ListenableProvider.value(
        value: userModel,
        child: Consumer<UserModel>(builder: (context, value, child) {
          // print("user screen: ${value.user.toJson()}");
          return ProfilePage(
            user: value.user,
            onLogout: () async {
              print("logged out tap!");
              userModel.logout();
              cartModel.clearCart();
            },
          );
        }));
  }
}
