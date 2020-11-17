import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TipCard extends StatelessWidget {
  TipCard(this.tip, this.index, this.isYes);

  final dynamic tip;
  final int index;
  final bool isYes;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
        width: 162,
        decoration: BoxDecoration(
            color: isYes ? kLightGreen : kQuaternaryOrange,
            border: Border.all(
                color: isYes ? kSafetyGreen : kPrimaryOrange, width: 2),
            borderRadius: BorderRadius.circular(10.0)),
        height: 223,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          tip,
          style: kBaseTextStyle.copyWith(
              fontSize: 15, color: kDarkAccent, fontWeight: FontWeight.bold),
        ),
      ),
      Positioned(
        left: 14,
        top: 14,
        child: Text(
          'Tip ${index.toString()}',
          style: kBaseTextStyle.copyWith(
              fontSize: 15,
              color: isYes ? kSafetyGreen : kPrimaryOrange,
              fontWeight: FontWeight.bold),
        ),
      ),
      Positioned(
        right: 14,
        top: 14,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
              color: isYes ? kSafetyGreen : kPrimaryOrange,
              borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
      Positioned(
          bottom: 15,
          right: 12,
          child: SvgPicture.asset(
            isYes ? 'assets/icons/yes-tip.svg' : 'assets/icons/no-tip.svg',
            width: 75,
            height: 36,
          ))
    ]);
  }
}
