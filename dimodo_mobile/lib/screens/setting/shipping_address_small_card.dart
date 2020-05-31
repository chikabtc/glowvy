import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:Dimodo/models/address/address.dart';
import 'package:Dimodo/generated/i18n.dart';

class ShippingAddressSmallCard extends StatelessWidget {
  ShippingAddressSmallCard(this.address);
  final Address address;

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 66,
        color: Colors.white,
        child: ListTile(
          contentPadding:
              EdgeInsets.only(top: 16.0, bottom: 14, left: 16, right: 16),
          onTap: () {
            var isFromOrderScreen = true;
            Navigator.pushNamed(context, "/manage_address",
                arguments: {'isFromConfirmOrderScreen': true});
          },
          title: address != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(children: <Widget>[
                      DynamicText(address.recipientName ?? "not found",
                          style: kBaseTextStyle.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          )),
                      SizedBox(width: 5),
                      DynamicText(address.phoneNumber,
                          style: kBaseTextStyle.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: kDarkSecondary)),
                    ]),
                    DynamicText(
                      address.ward.province.name +
                          "  " +
                          address.ward.district.name +
                          "  " +
                          address.ward.name,
                      textAlign: TextAlign.start,
                      style: kBaseTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: kDarkSecondary),
                    ),
                    DynamicText(
                      address.street,
                      style: kBaseTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: kDarkSecondary),
                    )
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    DynamicText(S.of(context).shippingAddress,
                        style: kBaseTextStyle.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        )),
                    SizedBox(width: 5),
                    DynamicText(S.of(context).pleaseInput,
                        style: kBaseTextStyle.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: kPinkError)),
                  ],
                ),
          trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[CommonIcons.arrowForward]),
        ));
  }
}
