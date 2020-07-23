import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/models/app.dart';
import 'package:Dimodo/models/survey.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/survey_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../generated/i18n.dart';

import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:provider/provider.dart';

class BaumannQuiz extends StatefulWidget {
  @override
  _BaumannQuizState createState() => _BaumannQuizState();
}

class _BaumannQuizState extends State<BaumannQuiz>
    with TickerProviderStateMixin {
  // AnimationController _loginBurttonController;

  int currentPage = 0;
  List<List<Survey>> surveys = [];
  List<String> skinTypes = [];
  List<bool> chosenAnswers = [];
  List<String> descriptions = [];
  bool surveyFinished = false;
  bool isSaving = false;
  bool showFullTips = false;
  bool showFullHarmful = false;
  bool fetchingExplanation = false;
  bool showFullExplanation = false;
  var skinTypeDescription;
  var skinType = "";
  double percent = 0;
  var totalProgress = 0;
  SwiperController swipeController;
  TabController tabController;
  List<String> tabList = [
    "khô vs da dầu",
    "sắc tố và không sắc tố",
    "căng vs nhăn",
    "Tight vs Wrinkled"
  ];

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);
    swipeController = SwiperController();
    try {
      final baumannQuiz = Provider.of<AppModel>(context, listen: false)
          .appConfig['Baumann_quiz'];
      print("baumanna JSON: ${baumannQuiz}");
      final dVsO = baumannQuiz["dry vs oily"] as List;
      final sVsR = baumannQuiz["sensitive vs resistant"] as List;
      final nVsP = baumannQuiz["non-pigmented vs pigmented"] as List;
      final tVsW = baumannQuiz["tight vs wrinkled"] as List;
      skinTypeDescription = baumannQuiz["skin-types-explanations"];

      descriptions.add(baumannQuiz["description1"]);
      descriptions.add(baumannQuiz["description2"]);
      descriptions.add(baumannQuiz["description3"]);
      descriptions.add(baumannQuiz["description4"]);
      print("surveys length: ${descriptions.length}");

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
      print("sVsRSurvey content: ${sVsR[0]}");
      print("sVsRSurvey length: ${sVsRSurvey.length}");
      print("nVsPSurvey length: ${nVsPSurvey.length}");
      print("tVsWSurvey length: ${tVsWSurvey.length}");

      surveys.add(dVsOSurvey);
      surveys.add(sVsRSurvey);
      surveys.add(nVsPSurvey);
      surveys.add(tVsWSurvey);
      print("surveyssurveys length: ${surveys.length}");
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
    tabController.dispose();
    swipeController.dispose();
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

  String getFullSkinType(type) {
    print("type: $type");
    switch (type) {
      case "D":
        return S.of(context).dry;
        break;
      case "O":
        return S.of(context).oily;
        break;
      case "S":
        return S.of(context).sensitive;
        break;
      case "R":
        return S.of(context).resistant;
        break;
      case "N":
        return S.of(context).nonPigmented;
        break;
      case "P":
        return S.of(context).pigmented;
        break;
      case "T":
        return S.of(context).tight;
        break;
      case "W":
        return S.of(context).wrinkled;
        break;
      default:
        "Skin";
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: Text(
              !surveyFinished
                  ? S.of(context).baumannSkinTypeTest
                  : "Contragulations Lottery!",
              style: kBaseTextStyle.copyWith(
                  fontSize: 16, fontWeight: FontWeight.w600)),
          brightness: Brightness.light,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 30,
              child: IconButton(
                icon: CommonIcons.arrowBackward,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          bottom: !surveyFinished
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(85),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10),
                        Text(
                          "$totalProgress / 18",
                          style: kBaseTextStyle.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: kAccentGreen.withOpacity(0.7)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: new LinearPercentIndicator(
                            alignment: MainAxisAlignment.center,
                            animateFromLastPercent: true,
                            width: screenSize.width - 32,
                            animation: true,
                            animationDuration: 500,
                            lineHeight: 8.0,
                            percent: totalProgress / 18,
                            // center: Text((totalProgress / 36).toString() + " %"),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: kAccentGreen,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: screenSize.width,
                          child: Text(
                            tabList[currentPage],
                            textAlign: TextAlign.center,
                            style: kBaseTextStyle.copyWith(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                )
              : PreferredSize(
                  preferredSize: const Size.fromHeight(40),
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(top: 12, bottom: 10),
                        child: Text(
                          S.of(context).finishedSurvey,
                          textAlign: TextAlign.center,
                          style: kBaseTextStyle.copyWith(
                            fontSize: 12,
                            color: kAccentGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
      backgroundColor: kDefaultBackground,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SafeArea(
          top: true,
          bottom: !surveyFinished ? true : false,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            width: kScreenSizeWidth,
            // padding: EdgeInsets.symmetric(horizontal: 7),
            child: !surveyFinished
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    color: kDefaultBackground,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 8),
                        Expanded(
                            child: ListView(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              descriptions[currentPage],
                              style: kBaseTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: kAccentGreen.withOpacity(0.7)),
                            ),
                            SizedBox(height: 20),
                            Container(
                              height: screenSize.height * 0.6,
                              child: Swiper(
                                key: Key(tabList[currentPage]),
                                controller: swipeController,
                                physics: surveys[currentPage].length == 1
                                    ? NeverScrollableScrollPhysics()
                                    : AlwaysScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int i) {
                                  return SurveyCard(
                                    survey: surveys[currentPage][i],
                                    index: i,
                                    onTap: () {
                                      return Future.delayed(
                                          const Duration(milliseconds: 250),
                                          () {
                                        calculateProgress();

                                        if (answeredAll(currentPage)) {
                                          setState(() {});
                                        } else if (surveys[currentPage].length -
                                                1 !=
                                            i) {
                                          setState(() {
                                            swipeController.move(i + 1);
                                          });
                                        }
                                      });
                                    },
                                  );
                                },
                                itemCount: surveys[currentPage].length,
                                control: SwiperControl(
                                    iconNext: null,
                                    iconPrevious: null,
                                    color: Colors.red),
                              ),
                            ),
                          ],
                        )),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 16, right: 16, bottom: 10.0),
                          child: MaterialButton(
                              elevation: 0,
                              color: answeredAll(currentPage)
                                  ? kAccentGreen
                                  : kAccentGreen.withOpacity(0.3),
                              minWidth: kScreenSizeWidth,
                              height: 36,
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                              ),
                              child: fetchingExplanation
                                  ? CupertinoActivityIndicator()
                                  : Text(
                                      currentPage == 3
                                          ? S.of(context).checkYourSkinTYpe
                                          : S.of(context).next,
                                      style: kBaseTextStyle.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                              onPressed: () {
                                if (!answeredAll(currentPage)) {
                                  alertUnfilledQuestion();
                                  //answered all for that page and not the last page
                                } else if (currentPage != 3 &&
                                    answeredAll(currentPage)) {
                                  setState(() {
                                    swipeController = SwiperController();
                                    calculateSkinType();
                                    currentPage++;
                                    swipeController.index = 0;
                                    swipeController.move(0);
                                  });
                                } else if (currentPage == 3) {
                                  calculateSkinType();
                                  getSkinTypeExplanation();
                                  setState(() {
                                    fetchingExplanation = true;
                                  });
                                  Future.delayed(
                                      const Duration(milliseconds: 2500), () {
                                    setState(() {
                                      fetchingExplanation = false;
                                      surveyFinished = true;
                                    });
                                  });
                                }
                              }),
                        ),
                      ],
                    ),
                  )
                : Container(
                    width: screenSize.width,
                    color: kAccentGreen.withOpacity(0.15),
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView(
                            children: <Widget>[
                              SizedBox(height: 30),
                              Text(
                                S.of(context).yourSkinTypeIs,
                                textAlign: TextAlign.center,
                                style: kBaseTextStyle.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                skinType,
                                textAlign: TextAlign.center,
                                style: kBaseTextStyle.copyWith(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: kAccentGreen,
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                    color: kAccentGreen,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        for (var i = 0;
                                            i < skinTypes.length;
                                            i++)
                                          Text(
                                            "#" +
                                                getFullSkinType(skinTypes[i]) +
                                                " ",
                                            textAlign: TextAlign.center,
                                            style: kBaseTextStyle.copyWith(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),
                              //add learn more
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showFullExplanation = !showFullExplanation;
                                  });
                                },
                                //use the fitted box..approach
                                child: Wrap(
                                  children: <Widget>[
                                    Text(
                                      getSkinTypeExplanation(),
                                      textAlign: TextAlign.start,
                                      maxLines: showFullExplanation ? 30 : 2,
                                      style: kBaseTextStyle.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: kDarkAccent.withOpacity(0.7),
                                      ),
                                    ),
                                    !showFullExplanation
                                        ? Text(
                                            "...Learn More",
                                            textAlign: TextAlign.start,
                                            style: kBaseTextStyle.copyWith(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  kDarkAccent.withOpacity(0.7),
                                            ),
                                          )
                                        : Container()
                                  ],
                                ),
                              ),
                              Container(height: 20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "To dos!",
                                    style: kBaseTextStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: kAccentGreen),
                                  ),
                                  SizedBox(height: 5),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showFullTips = !showFullTips;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      height: showFullTips ? 400 : 200,
                                      width: screenSize.width,
                                      padding: EdgeInsets.only(
                                          left: 12, top: 12, bottom: 15),
                                      child: Wrap(
                                        // crossAxisAliqgnment:
                                        //     CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // SizedBox(width: 10),
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.thumb_up,
                                                color: kAccentGreen,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Lipid free liquid cleansers",
                                                style: kBaseTextStyle.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                          showFullTips
                                              ? Text(
                                                  "Soap destroys the skin barrier for sensitive type\n\n",
                                                  style:
                                                      kBaseTextStyle.copyWith(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: kDarkAccent
                                                              .withOpacity(0.7),
                                                          fontSize: 13),
                                                )
                                              : Text(
                                                  "\n\n",
                                                  style:
                                                      kBaseTextStyle.copyWith(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 13),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    "Not To dos!",
                                    style: kBaseTextStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent,
                                        fontSize: 20),
                                  ),
                                  SizedBox(height: 5),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showFullHarmful = !showFullHarmful;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      height: showFullHarmful ? 400 : 230,
                                      padding: EdgeInsets.only(
                                          left: 12, top: 12, bottom: 15),
                                      width: screenSize.width,
                                      child: Wrap(
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // SizedBox(width: 10),
                                          Row(
                                            children: <Widget>[
                                              Icon(Icons.close,
                                                  color: Colors.redAccent),
                                              Text(
                                                "1. Do Not put too much make up",
                                                style: kBaseTextStyle.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "because it is hard to erase the makeup with the cleanser \n\n2. No Toner, No Soap, No Perfumes",
                                            style: kBaseTextStyle.copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SafeArea(
                          bottom: true,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 18, left: 16, right: 16),
                            child: MaterialButton(
                                elevation: 0,
                                color: kAccentGreen,
                                minWidth: kScreenSizeWidth,
                                height: 36,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                ),
                                child: !isSaving
                                    ? Text(S.of(context).saveResult,
                                        style: kBaseTextStyle.copyWith(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white))
                                    : CupertinoActivityIndicator(),
                                //animation
                                // popup
                                onPressed: () {
                                  setState(() {
                                    isSaving = true;
                                  });

                                  Future.delayed(
                                      const Duration(milliseconds: 1500), () {
                                    calculateProgress();
                                    setState(() {
                                      isSaving = false;
                                    });
                                  });

                                  // ===========================================
                                  // SAVE skinType to the user local db
                                  // ===========================================

                                  Provider.of<UserModel>(context, listen: false)
                                      .saveSkinType(skinType);

                                  // Navigator.pop(context);
                                }),
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

//  FittedBox(
//                     fit: BoxFit.cover,
//                     child: DynamicText(onboardingData[i]['title'],
//                         maxLines: 2,
//                         textAlign: TextAlign.center,
//                         style: kBaseTextStyle.copyWith(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: kDefaultFontColor,
//                           decoration: TextDecoration.none,
//                         )),
//                   ),
  // check how many options are chosen
  calculateProgress() {
    totalProgress = 0;

    surveys.forEach((element) {
      element.forEach((survey) {
        if (survey.answer != null) {
          totalProgress++;
        }
      });
    });
    // print("total progress : ${totalProgress}");
  }

  calculateSkinType() {
    if (skinTypes.length == 4) {
      return;
    } else {
      //Give yourself 1 point for every “a” answer, 2 points for every “b”, 3 points for every “c”, 4 points for every “d”, and 2.5 points for every “e” answer.
      var score = surveys[currentPage].fold(0.0, (previousValue, element) {
        var index = element.options.indexOf(element.answer).toDouble();
        print("index value score : $index");
        if (index == 5) {
          index = 2.5;
        }
        return previousValue + index;
      });

//If your score is between 34-44 you have very oily skin.
// If your score is between 27-33 you have slightly oily skin.
// If your score is between 17-26 you have slightly dry skin.
// If you score is between 11-16 you have dry skin.

      switch (currentPage) {
        case 0:
          skinTypes.add(score < 13 ? "D" : "O");
          break;
        case 1:
          skinTypes.add(score < 10 ? "S" : "R");
          break;
        case 2:
          skinTypes.add(score < 10 ? "N" : "P");
          break;
        case 3:
          skinTypes.add(score < 13 ? "T" : "W");
          break;
        default:
      }
      print('skinType : ${skinTypes.join()}');
    }
  }

  getSkinTypeExplanation() {
    skinType = skinTypes.join();
    print("skinType: #### $skinType");
    print("Desc!!!!: ${skinTypeDescription[skinType]}");
    return skinTypeDescription[this.skinType];
  }

  answeredAll(index) {
    var isAllAnswered = true;
    surveys[index].forEach((element) {
      //check if the answer is null
      if (element.answer == null) {
        isAllAnswered = false;
        return;
      }
    });
    return isAllAnswered;
  }

  List<Widget> renderTabbar() {
    List<String> tabList = [
      "khô vs da dầu",
      "Mẫn cảm với kháng chiến",
      "sắc tố và không sắc tố",
      "căng vs nhăn",
    ];
    List<Widget> list = [];

    tabList.asMap().forEach((index, item) {
      list.add(Container(
        child: Tab(
          text: item,
        ),
      ));
    });
    return list;
  }
}
