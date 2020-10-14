import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math';
import '../../common/constants.dart';
import '../../widgets/image_galery.dart';
import '../../common/styles.dart';

import '../../common/colors.dart';

import '../../models/review.dart';
import 'package:Dimodo/widgets/customWidgets.dart';

class CosmeticsReviewCard extends StatelessWidget {
  CosmeticsReviewCard(
      {this.review,
      this.isKorean = false,
      this.context,
      this.showDivider = true,
      this.isPreview = false});

  final Review review;
  final bool isPreview;
  final bool isKorean;
  final showDivider;

  final BuildContext context;
  Random rng = new Random();
  String sanitizedText;
  String kSanitizedText;

  List<Widget> renderImgs(context, Review review) {
    var imgButtons = <Widget>[];

    review.images?.forEach((element) {
      var imgBtn = ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          child: IconButton(
              iconSize: 150,
              icon: Image.network(
                element,
                fit: BoxFit.fill,
              ),
              onPressed: () => Navigator.of(context).push(_createRoute())));

      imgButtons.add(imgBtn);
    });
    return imgButtons;
    //on the external display, the lag is unusable..
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Page2(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    sanitizedText = review.content.replaceAll("\n", "");
    kSanitizedText = review.scontent.replaceAll("\n", "");

    if (isPreview && sanitizedText.length > 70) {
      sanitizedText =
          review.content.replaceAll("\n", "").substring(1, 70) + " ...";
    }

    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(2.0)),
      margin: EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //todo: assign the same profile pic
              SvgPicture.asset(
                'assets/icons/review-avartar.svg',
                width: isPreview ? 18 : 38,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(review.user.displayName, style: textTheme.button2),
                    Row(
                      children: <Widget>[
                        Text(review.user.age.toString(),
                            style: textTheme.button2.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: kSecondaryGrey)),
                        SizedBox(width: 10),
                        Text(review.user.skinType,
                            style: textTheme.button2
                                .copyWith(color: kSecondaryGrey)),
                      ],
                    ),
                    SizedBox(height: 7),
                    Text(isKorean ? kSanitizedText : sanitizedText,
                        maxLines: isPreview ? 2 : 20,
                        style: textTheme.bodyText1.copyWith(
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal)),
                    SizedBox(height: 14),
                    if (showDivider)
                      Divider(color: Colors.black.withOpacity(0.1)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height,
      width: screenSize.width,
      color: Colors.purple,
    );
  }
}
