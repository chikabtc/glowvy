import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/styles.dart';
import '../../models/user/userModel.dart';
import '../../common/tools.dart';
import '../../generated/i18n.dart';
import '../../models/order/cart.dart';
import '../../widgets/cart_item.dart';
import '../../widgets/expansion_info.dart';

class Review extends StatefulWidget {
  final Function onBack;
  final Function onNext;

  Review({this.onBack, this.onNext});

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  TextEditingController note = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<CartModel>(
      builder: (context, model, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            kAdvanceConfig['EnableShipping']
                ? ExpansionInfo(
                    title: S.of(context).shippingAddress,
                    children: <Widget>[
                      ShippingAddressInfo(),
                    ],
                  )
                : Container(),
            Container(height: 1, decoration: BoxDecoration(color: kGrey200)),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(S.of(context).orderDetail,
                  style: TextStyle(fontSize: 16)),
            ),
            ...getProducts(model),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    S.of(context).subtotal,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  Text(
                    Tools.getCurrecyFormatted(model.getSubTotal(),
                        currency: model.currency),
                    style: Theme.of(context).textTheme.headline.copyWith(
                          fontSize: 14,
                          color: Theme.of(context).accentColor,
                        ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    S.of(context).total,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  Text(
                    Tools.getCurrecyFormatted(model.getTotal(),
                        currency: model.currency),
                    style: Theme.of(context).textTheme.headline.copyWith(
                          fontSize: 20,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              S.of(context).yourNote,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 2,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 0.2,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  maxLines: 5,
                  controller: note,
                  style: TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                      hintText: S.of(context).writeYourNote,
                      hintStyle: TextStyle(fontSize: 12),
                      border: InputBorder.none),
                )),
            SizedBox(
              height: 20,
            ),
            Row(children: [
              Expanded(
                child: ButtonTheme(
                  height: 45,
                  child: RaisedButton(
                    onPressed: () {
                      widget.onNext();
                      // if (note.text != null && note.text.isNotEmpty)
                      //   Provider.of<CartModel>(context, listen: false)
                      //       .setOrderNotes(note.text);
                    },
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    child: Text(S.of(context).continueToPayment.toUpperCase()),
                  ),
                ),
              ),
            ]),
            Center(
                child: FlatButton(
                    onPressed: () {
                      widget.onBack();
                    },
                    child: Text(S.of(context).goBackToShipping,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 15,
                            color: kGrey400))))
          ],
        );
      },
    );
  }

  List<Widget> getProducts(CartModel model) {
    final userModel = Provider.of<UserModel>(context, listen: false); //

    return model.cartItems.keys.map(
      (key) {
        return CartItemRow(
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
}

class ShippingAddressInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context, listen: false);
    final address = cartModel.address;

    return Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 120,
                  child: Text(
                    S.of(context).fullName + " :",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    address.recipientName,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 120,
                  child: Text(
                    S.of(context).email + " :",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 120,
                  child: Text(
                    S.of(context).streetName + " :",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    address.street,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 120,
                  child: Text(
                    S.of(context).city + " :",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    address.ward.district.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 120,
                  child: Text(
                    S.of(context).province + " :",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    address.ward.province.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 120,
                  child: Text(
                    S.of(context).country + " :",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                // Expanded(
                //   child: Text(
                //     CountryPickerUtils.getCountryByIsoCode(shipping.country)
                //         .name,
                //     style: TextStyle(
                //       fontSize: 14,
                //       color: Theme.of(context).accentColor,
                //     ),
                //   ),
                // )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 120,
                  child: Text(
                    S.of(context).phoneNumber + " :",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    address.phoneNumber.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }
}
