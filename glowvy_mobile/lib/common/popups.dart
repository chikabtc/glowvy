import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/widgets/baumann_quiz.dart';
import 'package:Dimodo/widgets/webview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Popups {
  static void failMessage(message, context) {
    FocusScope.of(context).requestFocus(FocusNode());

    final snackBar = SnackBar(
      content: Text(
        '$message',
        style: textTheme.headline5.copyWith(color: Colors.white),
      ),
      duration: const Duration(seconds: 30),
      action: SnackBarAction(
        label: S.of(context).close,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void simpleAlert(context, bodyText, {buttonText = 'Ok'}) {
    showDialog(
        context: context,
        // barrierColor: kAlertBackground,
        // barrierColor: Colors.grey.withOpacity(0.7),
        builder: (BuildContext context) {
          return Center(
              // Aligns the container to center
              child: Container(
                  decoration: BoxDecoration(
                      color: kWhite, borderRadius: BorderRadius.circular(16)),
                  // A simplified version of dialog.
                  width: 315.0,
                  height: 125.0,
                  padding: const EdgeInsets.only(top: 28, bottom: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        bodyText,
                        style: textTheme.headline5
                            .copyWith(decoration: TextDecoration.none),
                      ),
                      const SizedBox(height: 28),
                      kFullDivider,
                      // const SizedBox(height: 14),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 48,
                          color: Colors.transparent,
                          width: 315,
                          // padding: const EdgeInsets.only(left: 14, right: 14),
                          child: Center(
                            child: Text(
                              buttonText,
                              style: textTheme.button1.copyWith(
                                  decoration: TextDecoration.none,
                                  color: kPrimaryOrange),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )));
        }).then((value) {
      // Future.delayed(const Duration(milliseconds: 700), () {
      //   Navigator.of(context).pop();
      //   // Navigator.of(dialogContext).pop();
      // });
    });
  }

  static void showPMF(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

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
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                width: screenSize.width,
                height: 313,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(children: <Widget>[
                      Container(
                          decoration: const BoxDecoration(
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
                                    fontSize: 16, fontWeight: FontWeight.w600)),
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
                    const SizedBox(
                      height: 14,
                    ),
                    SvgPicture.asset('assets/icons/big-logo.svg'),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 32.0, left: 32, bottom: 34),
                      child: Text(
                          'Hey~ Chúng tôi là Glowvy team và luôn mong muốn có thể cải thiện dịch vụ. Chúng tôi rất trân trọng các ý tưởng của bạn! Bạn có thể dành ra vài phút trả lời câu hỏi không?',
                          style: kBaseTextStyle.copyWith(
                            fontSize: 14,
                            color: kSecondaryGrey,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.justify),
                    ),
                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 35.0),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebView(
                                            url: 'https://bit.ly/measurepmf',
                                            title: 'DIMODO Users Survey ⭐️')));
                              },
                              child: Container(
                                height: 36,
                                decoration: const BoxDecoration(
                                    color: kDarkAccent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                padding: const EdgeInsets.only(
                                    left: 30, right: 30, top: 7, bottom: 7),
                                child: Text('Làm khảo sát',
                                    style: kBaseTextStyle.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  static void showBaummanQuiz(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final heighFactor = 1 -
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
                  decoration: const BoxDecoration(
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
                            decoration: const BoxDecoration(
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
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
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
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 32.0, left: 32, bottom: 20),
                        child: Text(S.of(context).discoverYourType,
                            style: kBaseTextStyle.copyWith(
                              fontSize: 14,
                              color: kSecondaryGrey,
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
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                // padding: const EdgeInsets.only(top: 8, bottom: 8),
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

  static void showQandA(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final heighFactor = 1 -
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
                  decoration: const BoxDecoration(
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
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                            ),
                            height: AppBar().preferredSize.height,
                            width: kScreenSizeWidth,
                            child: Center(
                              child: Text(S.of(context).officialQA,
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
                            Text(
                              S.of(context).whyLowerThanMarketpriceAnswer,
                              style: kBaseTextStyle.copyWith(fontSize: 15),
                              maxLines: 10,
                            ),
                            Text(
                              S.of(context).whereReivewsFromAnswer,
                              style: kBaseTextStyle.copyWith(fontSize: 15),
                              maxLines: 10,
                            ),
                            Text(
                              S.of(context).sameQualityAsInKoreaAnswer,
                              style: kBaseTextStyle.copyWith(fontSize: 15),
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
                      //                         url: 'https://bit.ly/measurepmf',
                      //                         title:
                      //                             'DIMODO Users Survey ⭐️')));
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

  static void showGlowvyStory(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final heighFactor = 1 -
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
                  decoration: const BoxDecoration(
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
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                            ),
                            height: AppBar().preferredSize.height,
                            width: kScreenSizeWidth,
                            child: Center(
                              child: Text(S.of(context).dimodoServices,
                                  style: kBaseTextStyle.copyWith(
                                      fontSize: 16,
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
                            Text(
                              S.of(context).provenKoreanCosmeticsStory,
                              style: kBaseTextStyle.copyWith(fontSize: 15),
                              maxLines: 10,
                            ),
                            Text(
                              S.of(context).getTheCheapesPriceStory,
                              style: kBaseTextStyle.copyWith(fontSize: 15),
                              maxLines: 10,
                            ),
                            Text(
                              S.of(context).moneyBackGuaranteeStory,
                              style: kBaseTextStyle.copyWith(fontSize: 15),
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
                      //                         url: 'https://bit.ly/measurepmf',
                      //                         title:
                      //                             'DIMODO Users Survey ⭐️')));
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
