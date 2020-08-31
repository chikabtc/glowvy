import 'package:Dimodo/common/constants.dart';
import 'package:flutter/material.dart';
import '../../generated/i18n.dart';
import '../../models/address/address.dart';

import 'package:Dimodo/common/styles.dart';

class CustomTextFormField extends StatelessWidget {
  final Address address;
  final labelText;
  final hintText;
  final Function onTap;
  final bool isEnabled;
  final bool isNumber;
  final bool isReviewForm;
  final bool isMaxLineOne;
  final bool isBorderNeeded;

  final TextEditingController nameController;

  CustomTextFormField(
      {this.address,
      this.labelText,
      this.hintText,
      this.nameController,
      this.onTap,
      this.isBorderNeeded = true,
      this.isMaxLineOne = false,
      this.isReviewForm = false,
      this.isEnabled = true,
      this.isNumber = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 70,
      padding: EdgeInsets.only(left: 16),
      child: TextFormField(
          keyboardType:
              isNumber ? TextInputType.number : TextInputType.multiline,
          maxLines: isMaxLineOne ? 1 : 2,
          onTap: onTap,
          enabled: isEnabled,
          controller: nameController,
          cursorColor: kPinkAccent,
          style: kBaseTextStyle.copyWith(
              fontSize: 15 * kSizeConfig.textMultiplier,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              hintText: hintText,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: isBorderNeeded
                        ? kDarkSecondary.withOpacity(0.1)
                        : kDarkSecondary.withOpacity(0.0)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: kDarkSecondary.withOpacity(0.1)),
              ),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: kDarkSecondary.withOpacity(0.1)),
              ),
              labelText: labelText,
              labelStyle: kBaseTextStyle.copyWith(
                  fontSize: 13 * kSizeConfig.textMultiplier,
                  fontWeight: FontWeight.w500,
                  color: kDarkAccent),
              focusColor: kPinkAccent,
              fillColor: kPinkAccent,
              hoverColor: kPinkAccent),
          validator: (val) {
            return val.isEmpty ? S.of(context).fullNameIsRequired : null;
          },
          onChanged: (String value) {
            if (labelText == S.of(context).fullName) {
              print("is it updating?");
              address.recipientName = value;
            } else if (labelText == S.of(context).phoneNumber) {
              address.phoneNumber = value;
            } else if (labelText == S.of(context).province) {
              address.phoneNumber = value;
            } else if (labelText == S.of(context).streetName) {
              address.street = value;
            }
            print("address updated: ${address.toJson()}");
          }),
    );
  }
}
