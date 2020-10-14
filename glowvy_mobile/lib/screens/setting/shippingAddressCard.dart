import 'package:Dimodo/models/order/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Dimodo/common/styles.dart';

import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:Dimodo/models/address/address.dart';
import 'package:provider/provider.dart';
import '../../generated/i18n.dart';

class ShippingAddressCard extends StatelessWidget {
  final Address address;
  var isFromOrderScreen;

  ShippingAddressCard({this.address, this.isFromOrderScreen = false});
  @override
  Widget build(BuildContext context) {
    print("addressCard: ${address.toJson()}");
    return Card(
        margin: EdgeInsets.only(top: 5.0),
        elevation: 0,
        child: ListTile(
          onTap: () {
            final cartModel = Provider.of<CartModel>(context, listen: false);
            if (isFromOrderScreen) {
              cartModel.chooseAddress(address);
              print("cartModel address: ${cartModel.address.toJson()}");
              Navigator.pop(context);
            } else {
              Navigator.pushNamed(context, "/add_address", arguments: address);
            }
          },
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(children: <Widget>[
                Text(address.recipientName ?? "not found",
                    style: kBaseTextStyle.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    )),
                SizedBox(width: 5),
                Text(address.phoneNumber,
                    style: kBaseTextStyle.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: kSecondaryGrey)),
              ]),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  address.isDefault
                      ? Row(
                          children: <Widget>[
                            Text(S.of(context).defaultString,
                                style: kBaseTextStyle.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: kPinkAccent)),
                            SizedBox(width: 7),
                          ],
                        )
                      : Container(),
                  Text(
                    address.ward.province.name ??
                        "province not found" +
                            "  " +
                            address.ward.district.name ??
                        "district not found" + "  " + address.ward.name,
                    style: kBaseTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: kSecondaryGrey),
                  ),
                ],
              ),
              Text(
                address.street,
                style: kBaseTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: kSecondaryGrey),
              )
            ],
          ),
          trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[CommonIcons.arrowForward]),
          contentPadding:
              EdgeInsets.only(left: 16, right: 8, top: 30, bottom: 15),
        ));
  }
}
