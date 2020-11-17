import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../common/colors.dart';
import '../common/styles.dart';

class ReviewRatingBar extends StatelessWidget {
  const ReviewRatingBar({
    Key key,
    @required this.title,
    @required this.percentage,
  }) : super(key: key);

  final String title;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width / 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: kBaseTextStyle.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFFBFBFBF)),
          ),
          const SizedBox(width: 7),
          Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: LinearPercentIndicator(
              alignment: MainAxisAlignment.center,
              animateFromLastPercent: true,
              width: screenSize.width / 2 - 44 - 15,
              animation: true,
              animationDuration: 500,
              lineHeight: 3.0,
              percent: percentage,
              backgroundColor: Colors.white,
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: kPrimaryOrange,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            (percentage * 100).toInt().toString() + '%',
            textAlign: TextAlign.start,
            style: kBaseTextStyle.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFFBFBFBF)),
          ),
        ],
      ),
    );
  }
}
