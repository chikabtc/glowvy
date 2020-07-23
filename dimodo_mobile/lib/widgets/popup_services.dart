import 'package:Dimodo/models/app.dart';
import 'package:Dimodo/widgets/baumann_quiz.dart';
import 'package:flutter/material.dart';
import 'package:Dimodo/widgets/webview.dart';
import 'package:flutter/rendering.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:provider/provider.dart';

class PopupServices {
  static showSurvey(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    var heighFactor = 1 -
        (AppBar().preferredSize.height +
                160 +
                MediaQuery.of(context).padding.bottom) /
            kScreenSizeHeight;
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return FractionallySizedBox(
                heightFactor: heighFactor,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  width: screenSize.width,
                  height: screenSize.height * heighFactor -
                      AppBar().preferredSize.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Stack(children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                            ),
                            height: AppBar().preferredSize.height,
                            width: kScreenSizeWidth,
                            child: Center(
                              child: DynamicText(
                                  S.of(context).thankYouForUsingDimodo,
                                  style: kBaseTextStyle.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                            )),
                        Positioned(
                          top: 6,
                          right: 0,
                          child: IconButton(
                              icon: SvgPicture.asset(
                                  'assets/icons/address/close-popup.svg'),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        )
                      ]),
                      Container(
                          width: 200,
                          height: 236,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Image.asset(
                                'assets/images/notification-illustration.png'),
                          )),
                      // SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 32.0, left: 32, bottom: 20),
                        child: DynamicText(S.of(context).surveyDescription,
                            style: kBaseTextStyle.copyWith(
                              fontSize: 13,
                              color: kDarkSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.justify),
                      ),

                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 40.0),
                            child: MaterialButton(
                                elevation: 0,
                                color: kDarkAccent,
                                minWidth: kScreenSizeWidth,
                                height: 36,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                ),
                                child: Text(S.of(context).takeSurvey,
                                    style: kBaseTextStyle.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WebView(
                                              url: "https://bit.ly/measurepmf",
                                              title:
                                                  "DIMODO Users Survey ⭐️")));
                                }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  static showFeedbackPopup(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    var heighFactor = 1 -
        (AppBar().preferredSize.height +
                160 +
                MediaQuery.of(context).padding.bottom) /
            kScreenSizeHeight;
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return FractionallySizedBox(
                heightFactor: heighFactor,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  width: screenSize.width,
                  height: screenSize.height * heighFactor -
                      AppBar().preferredSize.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Stack(children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                            ),
                            height: AppBar().preferredSize.height,
                            width: kScreenSizeWidth,
                            child: Center(
                              child: DynamicText(
                                  S.of(context).thankYouForUsingDimodo,
                                  style: kBaseTextStyle.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                            )),
                        Positioned(
                          top: 6,
                          right: 0,
                          child: IconButton(
                              icon: SvgPicture.asset(
                                  'assets/icons/address/close-popup.svg'),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        )
                      ]),
                      Container(
                          width: 200,
                          height: 236,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Image.asset(
                                'assets/images/notification-illustration.png'),
                          )),
                      // SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 32.0, left: 32, bottom: 20),
                        child: DynamicText(S.of(context).surveyDescription,
                            style: kBaseTextStyle.copyWith(
                              fontSize: 13,
                              color: kDarkSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.justify),
                      ),

                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 40.0),
                            child: MaterialButton(
                                elevation: 0,
                                color: kDarkAccent,
                                minWidth: kScreenSizeWidth,
                                height: 36,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                ),
                                child: Text(S.of(context).takeSurvey,
                                    style: kBaseTextStyle.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WebView(
                                              url: "https://bit.ly/measurepmf",
                                              title:
                                                  "DIMODO Users Survey ⭐️")));
                                }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  static showBaummanQuiz(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    var heighFactor = 1 -
        (AppBar().preferredSize.height +
                450 +
                MediaQuery.of(context).padding.bottom) /
            kScreenSizeHeight;
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return FractionallySizedBox(
                heightFactor: 0.27,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  width: screenSize.width,
                  height: screenSize.height * heighFactor -
                      AppBar().preferredSize.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Stack(children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                            ),
                            height: AppBar().preferredSize.height,
                            width: kScreenSizeWidth,
                            child: Center(
                              child: Text(S.of(context).thankYouForUsingDimodo,
                                  style: kBaseTextStyle.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                            )),
                        Positioned(
                          top: 6,
                          right: 0,
                          child: IconButton(
                              icon: SvgPicture.asset(
                                  'assets/icons/address/close-popup.svg'),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        )
                      ]),

                      // SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 32.0, left: 32, bottom: 20),
                        child: Text(S.of(context).discoverYourType,
                            style: kBaseTextStyle.copyWith(
                              fontSize: 14,
                              color: kDarkSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.justify),
                      ),

                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 108, right: 108, bottom: 40.0),
                            child: MaterialButton(
                                elevation: 0,
                                color: kDarkAccent,
                                minWidth: kScreenSizeWidth,
                                // height: 44,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                ),
                                // padding: EdgeInsets.only(top: 8, bottom: 8),
                                child: Text(S.of(context).startTheTest,
                                    style: kBaseTextStyle.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            BaumannQuiz(),
                                        fullscreenDialog: true,
                                      ));
                                }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  static showQandA(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    var heighFactor = 1 -
        (AppBar().preferredSize.height +
                80 +
                MediaQuery.of(context).padding.bottom) /
            kScreenSizeHeight;
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return FractionallySizedBox(
                heightFactor: heighFactor,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  width: screenSize.width,
                  height: screenSize.height * heighFactor -
                      AppBar().preferredSize.height,
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Stack(children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                            ),
                            height: AppBar().preferredSize.height,
                            width: kScreenSizeWidth,
                            child: Center(
                              child: DynamicText(S.of(context).officialQA,
                                  style: kBaseTextStyle.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                            )),
                        Positioned(
                          top: 6,
                          right: 0,
                          child: IconButton(
                              icon: SvgPicture.asset(
                                  'assets/icons/address/close-popup.svg'),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        )
                      ]),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            DynamicText(
                              S.of(context).whyLowerThanMarketpriceAnswer,
                              style: kBaseTextStyle.copyWith(fontSize: 14),
                              maxLines: 10,
                            ),
                            DynamicText(
                              S.of(context).whereReivewsFromAnswer,
                              style: kBaseTextStyle.copyWith(fontSize: 14),
                              maxLines: 10,
                            ),
                            DynamicText(
                              S.of(context).sameQualityAsInKoreaAnswer,
                              style: kBaseTextStyle.copyWith(fontSize: 14),
                              maxLines: 100,
                            )
                          ],
                        ),
                      )

                      // Expanded(
                      //   child: Align(
                      //     alignment: FractionalOffset.bottomCenter,
                      //     child: Padding(
                      //       padding: const EdgeInsets.only(
                      //           left: 16, right: 16, bottom: 40.0),
                      //       child: MaterialButton(
                      //           elevation: 0,
                      //           color: kDarkAccent,
                      //           minWidth: kScreenSizeWidth,
                      //           height: 36,
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: new BorderRadius.circular(25.0),
                      //           ),
                      //           child: Text(S.of(context).takeSurvey,
                      //               style: kBaseTextStyle.copyWith(
                      //                   fontSize: 15,
                      //                   fontWeight: FontWeight.w600,
                      //                   color: Colors.white)),
                      //           onPressed: () {
                      //             Navigator.pop(context);
                      //             Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                     builder: (context) => WebView(
                      //                         url: "https://bit.ly/measurepmf",
                      //                         title:
                      //                             "DIMODO Users Survey ⭐️")));
                      //           }),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  static showDimodoStory(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    var heighFactor = 1 -
        (AppBar().preferredSize.height +
                160 +
                MediaQuery.of(context).padding.bottom) /
            kScreenSizeHeight;
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return FractionallySizedBox(
                heightFactor: heighFactor,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  width: screenSize.width,
                  height: screenSize.height * heighFactor -
                      AppBar().preferredSize.height,
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Stack(children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                            ),
                            height: AppBar().preferredSize.height,
                            width: kScreenSizeWidth,
                            child: Center(
                              child: DynamicText(S.of(context).dimodoServices,
                                  style: kBaseTextStyle.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                            )),
                        Positioned(
                          top: 6,
                          right: 0,
                          child: IconButton(
                              icon: SvgPicture.asset(
                                  'assets/icons/address/close-popup.svg'),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        )
                      ]),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            DynamicText(
                              S.of(context).provenKoreanCosmeticsStory,
                              style: kBaseTextStyle.copyWith(fontSize: 14),
                              maxLines: 10,
                            ),
                            DynamicText(
                              S.of(context).getTheCheapesPriceStory,
                              style: kBaseTextStyle.copyWith(fontSize: 14),
                              maxLines: 10,
                            ),
                            DynamicText(
                              S.of(context).moneyBackGuaranteeStory,
                              style: kBaseTextStyle.copyWith(fontSize: 14),
                              maxLines: 100,
                            )
                          ],
                        ),
                      )

                      // Expanded(
                      //   child: Align(
                      //     alignment: FractionalOffset.bottomCenter,
                      //     child: Padding(
                      //       padding: const EdgeInsets.only(
                      //           left: 16, right: 16, bottom: 40.0),
                      //       child: MaterialButton(
                      //           elevation: 0,
                      //           color: kDarkAccent,
                      //           minWidth: kScreenSizeWidth,
                      //           height: 36,
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: new BorderRadius.circular(25.0),
                      //           ),
                      //           child: Text(S.of(context).takeSurvey,
                      //               style: kBaseTextStyle.copyWith(
                      //                   fontSize: 15,
                      //                   fontWeight: FontWeight.w600,
                      //                   color: Colors.white)),
                      //           onPressed: () {
                      //             Navigator.pop(context);
                      //             Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                     builder: (context) => WebView(
                      //                         url: "https://bit.ly/measurepmf",
                      //                         title:
                      //                             "DIMODO Users Survey ⭐️")));
                      //           }),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
