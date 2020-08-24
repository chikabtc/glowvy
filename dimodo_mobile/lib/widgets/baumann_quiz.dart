import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/models/app.dart';
import 'package:Dimodo/models/survey.dart';
import 'package:Dimodo/models/user/skinScores.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/skin-score.dart';
import 'package:Dimodo/widgets/survey_card.dart';
import 'package:Dimodo/widgets/tip-card.dart';
import 'package:Dimodo/widgets/tips-card.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../generated/i18n.dart';

import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:provider/provider.dart';

class BaumannQuiz extends StatefulWidget {
  String skinType;
  SkinScores skinScores;

  BaumannQuiz({this.skinType, this.skinScores});
  @override
  _BaumannQuizState createState() => _BaumannQuizState();
}

class _BaumannQuizState extends State<BaumannQuiz>
    with TickerProviderStateMixin {
  int currentPage = 0;
  List<List<Survey>> surveys = [];
  List<String> skinTypes = [];
  List<bool> chosenAnswers = [];
  List<String> descriptions = [];
  bool surveyFinished = false;
  bool isSaving = false;
  // bool showFullTips = false;
  // bool showFullHarmful = false;
  bool calculatingResult = false;
  bool showFullExplanation = false;
  var skinTypeDescription;
  // var skinType = "";
  double dsScore;
  double srScore;
  double pnScore;
  double wnScore;
  UserModel userModel;

  var totalProgress = 0;
  SwiperController swipeController;
  dynamic sensitiveTips;
  dynamic sensitiveAvoid;
  List<String> tabList = [
    "khô vs da dầu",
    "sắc tố và không sắc tố",
    "căng vs nhăn",
    "Căng vs nhăn"
  ];

  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);
    print("widget skin type: ${widget.skinType}");

    swipeController = SwiperController();
    try {
      final baumannQuiz = Provider.of<AppModel>(context, listen: false)
          .appConfig['Baumann_quiz'];
      // print("baumanna JSON: ${baumannQuiz}");

      final dVsO = baumannQuiz["khô vs da dầu"] as List;
      final sVsR = baumannQuiz["Nhạy cảm vs đề kháng cao"] as List;
      final nVsP = baumannQuiz["không sắc tố sắc tố và"] as List;
      final tVsW = baumannQuiz["căng vs nhăn"] as List;
      sensitiveTips = baumannQuiz["sensitive-type-tips"];
      sensitiveAvoid = baumannQuiz["sensitive-type-avoid"];

      skinTypeDescription = baumannQuiz["skin-types-explanations"];

      descriptions.add(baumannQuiz["description1"]);
      descriptions.add(baumannQuiz["description2"]);
      descriptions.add(baumannQuiz["description3"]);
      descriptions.add(baumannQuiz["description4"]);
      // print("surveys length: ${descriptions.length}");

      List<Survey> dVsOSurvey = [];

      dVsO.forEach((e) {
        dVsOSurvey.add(Survey.fromJson(e));
      });
      print("dVsOSurvey length: ${dVsOSurvey.length}");
//
      List<Survey> sVsRSurvey = [];
      sVsR.forEach((e) {
        sVsRSurvey.add(Survey.fromJson(e));
      });
      List<Survey> nVsPSurvey = [];
      nVsP.forEach((e) {
        nVsPSurvey.add(Survey.fromJson(e));
      });
      List<Survey> tVsWSurvey = [];
      tVsW.forEach((e) {
        tVsWSurvey.add(Survey.fromJson(e));
      });
      surveys.add(dVsOSurvey);
      surveys.add(sVsRSurvey);
      surveys.add(nVsPSurvey);
      surveys.add(tVsWSurvey);
    } catch (err) {
      var message =
          "There is an issue with the app during request the data, please contact admin for fixing the issues " +
              err.toString();
      print("error: $message");
    }
  }

  @override
  void dispose() {
    super.dispose();
    swipeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    if (widget.skinType != null && widget.skinScores != null) {
      surveyFinished = true;
      skinTypes.clear();
      widget.skinType.runes.forEach((int rune) {
        var character = String.fromCharCode(rune);
        print(character);
        skinTypes.add(character);
      });
      dsScore = widget.skinScores.dsScore;
      srScore = widget.skinScores.srScore;
      pnScore = widget.skinScores.pnScore;
      wnScore = widget.skinScores.wnScore;
      if (widget.skinType.contains("R")) {
        showFullExplanation = true;
      }
    }

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: Text(
              !surveyFinished
                  ? S.of(context).baumannSkinTypeTest
                  : "My Skin Type",
              style: kBaseTextStyle.copyWith(
                  color: kDarkYellow,
                  fontSize: 17,
                  fontWeight: FontWeight.bold)),
          brightness: Brightness.light,
          leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.arrow_back_ios,
                color: kDarkYellow,
                size: 20.0,
                semanticLabel: 'Text to announce in accessibility modes',
              )),
          backgroundColor: kLightYellow,
          //if the survey is completed or the user provided the skinType
          bottom: !surveyFinished
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(55),
                  child: Container(
                    color: kLightYellow,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: LinearPercentIndicator(
                            alignment: MainAxisAlignment.center,
                            animateFromLastPercent: true,
                            width: screenSize.width,
                            animation: true,
                            animationDuration: 500,
                            lineHeight: 10.0,
                            percent: totalProgress / 16,
                            backgroundColor: Colors.white,
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: Color(0xFFFDD13C),
                          ),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Container(
                          width: screenSize.width,
                          padding: EdgeInsets.symmetric(horizontal: 28),
                          child: Text(
                            tabList[currentPage],
                            textAlign: TextAlign.start,
                            style: kBaseTextStyle.copyWith(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w900,
                                color: kDarkYellow),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : PreferredSize(
                  preferredSize: const Size.fromHeight(0), child: Container())),
      backgroundColor: kDefaultBackground,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          top: true,
          bottom: false,
          child: Container(
            decoration: BoxDecoration(
              // color: kLightYellow,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            width: screenSize.width,
            // padding: EdgeInsets.symmetric(horizontal: 7),
            child: !surveyFinished
                ? Container(
                    color: kLightYellow,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child: ListView(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18.0),
                              child: Text(descriptions[currentPage],
                                  style: kBaseTextStyle.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: kDarkYellow)),
                            ),
                            SizedBox(height: 14),
                            Container(
                              height: screenSize.height * 0.6,
                              child: Swiper(
                                itemCount: surveys[currentPage].length,
                                key: Key(tabList[currentPage]),
                                controller: swipeController,
                                physics: surveys[0].length == 1
                                    ? NeverScrollableScrollPhysics()
                                    : AlwaysScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int i) {
                                  return SurveyCard(
                                    survey: surveys[currentPage][i],
                                    index: totalProgress - 1,
                                    onTap: () {
                                      return Future.delayed(
                                          const Duration(milliseconds: 200),
                                          () {
                                        calculateProgress();
                                        //if answered all, do nothing
                                        if (answeredAll()) {
                                          setState(() {});
                                        }
                                        //show the next criteria
                                        else if (currentPage != 3 &&
                                            isSectionComplete(currentPage)) {
                                          setState(() {
                                            swipeController =
                                                SwiperController();
                                            // calculateSkinType();
                                            currentPage++;
                                            swipeController.index = 0;
                                            swipeController.move(0);
                                          });
                                          //show the next question
                                        } else {
                                          setState(() {
                                            swipeController.move(i + 1);
                                          });
                                        }
                                      });
                                    },
                                  );
                                },
                                control: SwiperControl(
                                    iconNext: null,
                                    iconPrevious: null,
                                    color: Colors.red),
                              ),
                            ),
                          ],
                        )),
                        answeredAll()
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 16, right: 16, bottom: 40.0),
                                child: MaterialButton(
                                    elevation: 0,
                                    color: kPrimaryOrange,
                                    minWidth: kScreenSizeWidth,
                                    height: 48,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    child: calculatingResult
                                        ? CupertinoActivityIndicator()
                                        : Text(S.of(context).checkYourSkinTYpe,
                                            style: kBaseTextStyle.copyWith(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                    onPressed: () {
                                      if (!answeredAll()) {
                                        alertUnfilledQuestion();
                                        //answered all for that page and not the last page
                                      } else {
                                        calculateSkinType();

                                        getSkinTypeExplanation();
                                        setState(() {
                                          calculatingResult = true;
                                        });
                                        Future.delayed(
                                            const Duration(milliseconds: 2500),
                                            () {
                                          SkinScores scores = SkinScores(
                                              dsScore,
                                              srScore,
                                              pnScore,
                                              wnScore);
                                          print("scores@@ ${scores.toJson()}");
                                          setState(() {
                                            calculatingResult = false;
                                            surveyFinished = true;

                                            Provider.of<UserModel>(context,
                                                    listen: false)
                                                .saveSkinType(
                                                    widget.skinType, scores);
                                          });
                                        });
                                      }
                                    }),
                              )
                            : Container()
                      ],
                    ),
                  )
                : Container(
                    width: screenSize.width,
                    color: kLightYellow,
                    // padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: ListView(
                            children: <Widget>[
                              Container(
                                  color: kLightYellow,
                                  child: SvgPicture.asset(
                                    "assets/icons/smiley-girl-face.svg",
                                    height: 50,
                                    width: 280,
                                  ),
                                  height: screenSize.height / 4),
                              Container(
                                alignment: Alignment.center,
                                color: Colors.white,
                                // padding: EdgeInsets.symmetric(horizontal: 40),
                                child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(height: 16.5),
                                      SkinScore("Dầu", "Khô", score: dsScore),
                                      SkinScore("Sắc tố", "Không có\nsắc tố",
                                          score: srScore),
                                      SkinScore("Nhạy cảm", "Kháng cự",
                                          score: pnScore),
                                      SkinScore("Chặt chẽ", "Nhăn nheo",
                                          score: wnScore),
                                    ]),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 25.0, left: 38, right: 38),
                                    child: Text(
                                      "Professional skin management\nspecialist, Min says:",
                                      textAlign: TextAlign.start,
                                      maxLines: showFullExplanation ? 30 : 3,
                                      style: kBaseTextStyle.copyWith(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w900,
                                        color: kDarkYellow,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SvgPicture.asset(
                                          "assets/icons/big-double-quote.svg"),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showFullExplanation =
                                                !showFullExplanation;
                                          });
                                        },
                                        //use the fitted box..approach
                                        child: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          width: screenSize.width - 60,
                                          child: Wrap(
                                            children: <Widget>[
                                              SizedBox(height: 10),
                                              Text(
                                                "${getSkinTypeExplanation()}",
                                                textAlign: TextAlign.start,
                                                maxLines: showFullExplanation
                                                    ? 30
                                                    : 3,
                                                style: kBaseTextStyle.copyWith(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: kDarkYellow,
                                                ),
                                              ),
                                              !showFullExplanation
                                                  ? Text(
                                                      "... More",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: kBaseTextStyle
                                                          .copyWith(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: kDarkYellow,
                                                      ),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(height: 40),
                              Text(
                                "- Exclusive Skin Tips -",
                                textAlign: TextAlign.center,
                                style: kBaseTextStyle.copyWith(
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w800,
                                  color: kDarkAccent,
                                ),
                              ),
                              Container(height: 13),
                              Container(
                                  width: screenSize.width,
                                  height: 223,
                                  padding: EdgeInsets.only(left: 10),
                                  child: ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          Container(width: 10),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: sensitiveTips.length +
                                          sensitiveAvoid.length,
                                      itemBuilder:
                                          (BuildContext context, int i) {
                                        if (i > sensitiveTips.length) {
                                          return TipCard(
                                              sensitiveAvoid[
                                                  i - sensitiveTips.length - 1],
                                              i - sensitiveTips.length - 1,
                                              false);
                                        }
                                        return TipCard(
                                            sensitiveTips[0], i, true);
                                      })),
                              SizedBox(height: 50),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            BaumannQuiz(),
                                        fullscreenDialog: true,
                                      ));
                                },
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: kBaseTextStyle.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: kDarkSecondary,
                                        fontSize: 14),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              'Unsatisfied with the result?  Retake '),
                                      TextSpan(
                                          text: 'click here',
                                          style: kBaseTextStyle.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: kDarkSecondary,
                                              fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 14),
                              Container(
                                color: kDefaultBackground,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 70),
                                    SvgPicture.asset(
                                        "assets/icons/glowvy-activity.svg"),
                                    SizedBox(height: 14),
                                    Text("Brand Story with Hongbeom Park",
                                        style: kBaseTextStyle.copyWith(
                                            fontSize: 16,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w900,
                                            color: kDarkAccent)),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 33,
                                          right: 33,
                                          top: 14,
                                          bottom: 14),
                                      child: Text(
                                          "Glowvy is newly born by Young Koreans to help Hongboem find the suitable cosmetics for their skin type and issues. With the goal of making Hongboem skin glow, Glowvy trys their best to provides personalized cosmetics recommendations, the skin type analysis, skin care tips based on skin type.\n\nDid you experience buying the cosmetics that ruin the skin before? Chat about it with Glowvy~ ",
                                          style: kBaseTextStyle.copyWith(
                                              fontSize: 15,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w600,
                                              color: kDarkAccent)),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 14,
                                            left: 20,
                                            right: 20,
                                            bottom: 67),
                                        child: MaterialButton(
                                            elevation: 0,
                                            color: kPrimaryOrange,
                                            minWidth: screenSize.width - 32,
                                            height: 48,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            child: !isSaving
                                                ? Text(
                                                    widget.skinType != null
                                                        ? S.of(context).close
                                                        : S
                                                            .of(context)
                                                            .saveResult,
                                                    style:
                                                        kBaseTextStyle.copyWith(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.white))
                                                : CupertinoActivityIndicator(),
                                            //animation
                                            // popup
                                            onPressed: () {
                                              if (!userModel.isLoggedIn) {
                                                Navigator.pushNamed(
                                                    context, "/login");
                                              } else {
                                                dynamic scores = {};
                                                scores["ds"] = dsScore;
                                                scores["sr"] = srScore;
                                                scores["pn"] = pnScore;
                                                scores["wn"] = wnScore;
                                                print("scores@@ $scores");
                                                setState(() {
                                                  isSaving = true;
                                                  Provider.of<UserModel>(
                                                          context,
                                                          listen: false)
                                                      .saveSkinType(
                                                          widget.skinType,
                                                          scores);
                                                });
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 1500),
                                                    () {
                                                  setState(() {
                                                    isSaving = false;
                                                    Navigator.pop(context);
                                                  });
                                                });
                                              }
                                            })),
                                    Text("Glowvy x Make My Skin Glow",
                                        style: kBaseTextStyle.copyWith(
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600,
                                            color: kSecondaryGrey)),
                                    SizedBox(
                                      height: 30,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> alertUnfilledQuestion() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user can tap anywhere to dismiss the popup!
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: Text(
            "Please answer all questions",
            style: kBaseTextStyle,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok',
                style: kBaseTextStyle,
              ),
              onPressed: () {
                Navigator.of(buildContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  calculateProgress() {
    totalProgress = 0;

    surveys.forEach((element) {
      element.forEach((survey) {
        if (survey.answer != null) {
          totalProgress++;
        }
      });
    });
  }

  calculateSkinType() {
    if (skinTypes.length == 4) {
      return;
    } else {
      //Give yourself
      //1 point for every “a” answer,
      //2 points for every “b”,
      //3 points for every “c”,
      //4 points for every “d”
      //2.5 points for every “e” answer.
      surveys.forEach((survey) {
        double score = survey.fold(0.0, (previousValue, element) {
          var index = element.options.indexOf(element.answer).toDouble();
          if (index == 5) {
            index = 2.5;
          }
          print("index value score : ${index + 1}");
          return previousValue + index + 1;
        });

        // If your score is between 34-44 you have very oily skin.
        // If your score is between 27-33 you have slightly oily skin.
        // If your score is between 17-26 you have slightly dry skin.
        // If your score is between 11-16 you have dry skin.
        print("score!! $score");

        switch (surveys.indexOf(survey)) {
          case 0:
            skinTypes.add(score < 8 ? "D" : "O");
            dsScore = score;
            break;
          case 1:
            skinTypes.add(score < 8 ? "R" : "S");
            srScore = score;

            break;
          case 2:
            skinTypes.add(score < 8 ? "N" : "P");
            pnScore = score;
            break;
          case 3:
            skinTypes.add(score < 8 ? "T" : "W");
            wnScore = score;

            break;
          default:
        }
        print('skinType : ${skinTypes.join()}');
      });
    }
  }

  getSkinTypeExplanation() {
    widget.skinType = skinTypes.join();
    return skinTypeDescription[widget.skinType];
  }

  answeredAll() {
    var isAllAnswered = true;
    surveys.forEach((survey) {
      survey.forEach((element) {
        //check if the answer is null
        if (element.answer == null) {
          isAllAnswered = false;
          return;
        }
      });
    });
    return isAllAnswered;
  }

  isSectionComplete(index) {
    var isAllAnswered = true;
    surveys[index].forEach((survey) {
      if (survey.answer == null) {
        isAllAnswered = false;
        return;
      }
    });
    return isAllAnswered;
  }
}
