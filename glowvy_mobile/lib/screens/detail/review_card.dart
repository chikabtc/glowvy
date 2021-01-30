import 'dart:math';

import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/start_rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../../common/colors.dart';
import '../../common/constants.dart';
import '../../common/styles.dart';
import '../../models/review.dart';

class ReviewCard extends StatelessWidget {
  ReviewCard(
      {this.review,
      this.isKorean = false,
      this.context,
      this.showDivider = true,
      this.isPreview = false});

  final Review review;
  final bool isPreview;
  final bool isKorean;
  final bool showDivider;

  final BuildContext context;
  Random rng = Random();
  String sanitizedText;
  String kSanitizedText;

  List<Widget> renderImgs(context, Review review) {
    var imgButtons = <Widget>[];

    review.images?.forEach((element) {
      var imgBtn = ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
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

  getReviewDate() {
    final difference = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(review.createdAt));
    if (difference.inMinutes < 1) {
      // print('sec');
      return difference.inSeconds.toString() + ' giây trước';
    }
    if (difference.inMinutes < 60) {
      // print('min');
      return difference.inMinutes.toString() + ' phút trước';
    } else if (difference.inHours < 24) {
      //
      // print('hour');

      return difference.inHours.toString() + ' giờ trước';
    } else if (difference.inDays > 1) {
      // print('day');

      return difference.inDays.toString() + ' ngày trước';
    }
  }

  @override
  Widget build(BuildContext context) {
    sanitizedText = review.content.replaceAll('\n', '');
    kSanitizedText = review.scontent?.replaceAll('\n', '');
    // final title =
    final skinIssues = review.user.skinIssues != null
        ? '/ ${review.user.skinIssues.join(',').toString()}'
        : '';

    // print(review.rating);

    if (isPreview && sanitizedText.length > 70) {
      sanitizedText =
          review.content.replaceAll('\n', '').substring(1, 70) + ' ...';
    }

    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(2.0)),
      margin: const EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //todo: assign the same profile pic
              if (review.user.picture == null)
                SvgPicture.asset(
                  'assets/icons/review-avartar.svg',
                  width: isPreview ? 18 : 38,
                )
              else
                ClipOval(
                  child: Image.network(
                    review.user.picture +
                        '?v=${ValueKey(Random().nextInt(100))}',
                    key: ValueKey(Random().nextInt(100)),
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        review.user.displayName +
                            ' (' +
                            (DateTime.now().year - review.user.birthYear)
                                .toString() +
                            '/' +
                            review.user.skinType +
                            '' +
                            skinIssues +
                            ')',
                        style: textTheme.button2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SmoothStarRating(
                          starCount: 5,
                          size: 14,
                          rating: review.rating.toDouble(),
                        ),
                        const SizedBox(width: 5),
                        Text(getReviewDate(),
                            style: textTheme.button2.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: kSecondaryGrey)),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(isKorean ? kSanitizedText : sanitizedText,
                        maxLines: isPreview ? 2 : 20,
                        style: textTheme.bodyText1.copyWith(
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal)),
                    const SizedBox(height: 14),
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
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height,
      width: screenSize.width,
      color: Colors.purple,
    );
  }
}
