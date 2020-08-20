import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Dimodo/common/styles.dart';

class SkinScore extends StatelessWidget {
  SkinScore(this.skinType1, this.skinType2, this.score);
  final String skinType1;
  final String skinType2;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                skinType1,
                textAlign: TextAlign.center,
                style: kBaseTextStyle.copyWith(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w800,
                  color: kDarkAccent,
                ),
              ),
              SizedBox(width: 10),
              Row(
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          color: kLightYellow,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20))),
                      height: 10,
                      width: 32),
                  SizedBox(width: 1),
                  Container(height: 10, width: 32, color: kLightYellow),
                  Container(height: 10, width: 32, color: kLightYellow),
                  SizedBox(width: 1),
                  Container(
                      decoration: BoxDecoration(
                          color: kLightYellow,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20))),
                      height: 10,
                      width: 32),
                  SizedBox(width: 1),
                ],
              ),
              SizedBox(width: 10),
              Text(
                skinType2,
                textAlign: TextAlign.center,
                style: kBaseTextStyle.copyWith(
                  fontSize: 15,
                  // fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w900,
                  color: kDarkAccent,
                ),
              ),
            ]),
      ),
    );
  }
}
