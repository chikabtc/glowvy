import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:Dimodo/models/address/address.dart';

class ShippingAddressCard extends StatelessWidget {
  ShippingAddressCard(this.address);
  final Address address;

  @override
  Widget build(BuildContext context) {
    print("addressCard: ${address.toJson()}");
    return Card(
        margin: EdgeInsets.only(top: 5.0),
        elevation: 0,
        child: ListTile(
          onTap: () => {
            Navigator.pushNamed(context, "/add_address", arguments: address)
          },
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              DynamicText(address.recipientName,
                  style: kBaseTextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
              DynamicText(address.phoneNumber,
                  style: kBaseTextStyle.copyWith(
                      fontWeight: FontWeight.w600, color: Colors.black)),
              SizedBox(height: 10),
              DynamicText(
                address.ward.province.name ??
                    "province not found" + "  " + address.ward.district.name ??
                    "district not found" + "  " + address.ward.name ??
                    "ward not found" + "  " + address.street,
                style: kBaseTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: kDarkSecondary),
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

class ShippingAddressSmallCard extends StatelessWidget {
  ShippingAddressSmallCard(this.address);
  final Address address;

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 66,
        color: Colors.white,
        child: ListTile(
          onTap: () => {
            Navigator.pushNamed(context, "/add_address", arguments: address)
          },
          title: Padding(
            padding: const EdgeInsets.only(top: 6.0, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(children: <Widget>[
                  DynamicText(address.recipientName ?? "not found",
                      style: kBaseTextStyle.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      )),
                  SizedBox(width: 5),
                  DynamicText(address.phoneNumber,
                      style: kBaseTextStyle.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                ]),
                DynamicText(
                  address.ward.province.name +
                      "  " +
                      address.ward.district.name +
                      "  " +
                      address.ward.name +
                      "  " +
                      address.street,
                  textAlign: TextAlign.start,
                  style: kBaseTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: kDarkSecondary),
                )
              ],
            ),
          ),
          trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[CommonIcons.arrowForward]),
        ));
  }
}
