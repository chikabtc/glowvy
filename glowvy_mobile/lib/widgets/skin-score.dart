import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:flutter_svg/svg.dart';

class SkinScore extends StatelessWidget {
  SkinScore(this.skinType1, this.skinType2, {this.score});
  final String skinType1;
  final String skinType2;
  final double score;

  @override
  Widget build(BuildContext context) {
    print("skin type: $skinType1 and score: $score");
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Container(
        child: Row(children: <Widget>[
          Spacer(),
          Container(
            width: 70,
            child: Text(
              skinType1,
              textAlign: TextAlign.end,
              style: kBaseTextStyle.copyWith(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w800,
                color: kDarkAccent,
              ),
            ),
          ),
          SizedBox(width: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    height: 10,
                    width: 32,
                    decoration: BoxDecoration(
                        color: kLightYellow,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20))),
                  ),
                  score <= 3.2
                      ? Positioned(
                          child: SvgPicture.asset("assets/icons/red-smile.svg"))
                      : Container()
                ],
              ),
              SizedBox(width: 1),
              ScoreElement(score > 3.2 && score <= 6.4 ? true : false),
              SizedBox(width: 1),
              ScoreElement(score > 6.4 && score <= 9.6 ? true : false),
              SizedBox(width: 1),
              ScoreElement(score > 9.6 && score <= 12.8 ? true : false),
              SizedBox(width: 1),
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                      height: 10,
                      width: 32,
                      decoration: BoxDecoration(
                          color: kLightYellow,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20)))),
                  score > 12.8
                      ? Positioned(
                          child: SvgPicture.asset("assets/icons/red-smile.svg"))
                      : Container()
                ],
              ),
              SizedBox(width: 1),
            ],
          ),
          SizedBox(width: 10),
          Container(
            width: 70,
            child: Text(
              skinType2,
              textAlign: TextAlign.start,
              style: kBaseTextStyle.copyWith(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w800,
                color: kDarkAccent,
              ),
            ),
          ),
          Spacer(),
        ]),
      ),
    );
  }
}

class ScoreElement extends StatelessWidget {
  ScoreElement(this.showSmile);
  final bool showSmile;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(height: 10, width: 32, color: kLightYellow),
        showSmile
            ? Positioned(child: SvgPicture.asset("assets/icons/red-smile.svg"))
            : Container()
      ],
    );
  }
}
