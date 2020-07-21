import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/models/app.dart';
import 'package:Dimodo/models/survey.dart';
import 'package:Dimodo/widgets/survey_card.dart';
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
  var skinTypeDescription;
  var skinType;
  double percent = 0;
  SwiperController swipeController;
  TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);
    swipeController = SwiperController();
    try {
      final baumannQuiz = Provider.of<AppModel>(context, listen: false)
          .appConfig['Baumann_quiz'];
      final dVsO = baumannQuiz["dry vs oily"] as List;
      final sVsR = baumannQuiz["sensitive vs resistant"] as List;
      final nVsP = baumannQuiz["non-pigmented vs pigmented"] as List;
      final tVsW = baumannQuiz["tight vs wrinkled"] as List;
      skinTypeDescription = baumannQuiz["skin-types"];

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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(S.of(context).baumannSkinTypeTest,
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              Text(
                (percent * 100).toStringAsFixed(0).toString() + " %",
                style: kBaseTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: kAccentGreen.withOpacity(0.7)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: new LinearPercentIndicator(
                  alignment: MainAxisAlignment.center,
                  width: screenSize.width - 32,
                  animation: true,
                  animationDuration: 500,
                  lineHeight: 8.0,
                  percent: 0.5,
                  // center: Text("20.0%"),
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: kAccentGreen,
                ),
              ),
              IgnorePointer(
                ignoring: true,
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.label,
                  controller: tabController,
                  isScrollable: true,
                  indicatorColor: kAccentGreen,
                  unselectedLabelColor: kDarkSecondary,
                  unselectedLabelStyle: kBaseTextStyle.copyWith(
                      fontSize: 13,
                      color: kDarkSecondary,
                      fontWeight: FontWeight.w600),
                  labelColor: kAccentGreen,
                  labelStyle: kBaseTextStyle.copyWith(
                      fontSize: 13,
                      color: kAccentGreen,
                      fontWeight: FontWeight.w600),
                  onTap: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  tabs: renderTabbar(),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: kDefaultBackground,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SafeArea(
          top: true,
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
                            Text(
                              descriptions[currentPage],
                              style: kBaseTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: kAccentGreen.withOpacity(0.7)),
                            ),
                            SizedBox(height: 28),
                            Container(
                              height: screenSize.height * 0.52,
                              child: Swiper(
                                controller: swipeController,
                                physics: surveys[currentPage].length == 1
                                    ? NeverScrollableScrollPhysics()
                                    : AlwaysScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int i) {
                                  return SurveyCard(
                                    survey: surveys[currentPage][i],
                                    index: i,
                                    onTap: () => swipeController.move(i + 1),
                                    isLast: surveys[currentPage].length - 1 == i
                                        ? true
                                        : false,
                                  );
                                },
                                itemCount: surveys[currentPage].length,
                                control: SwiperControl(
                                    iconNext: null,
                                    iconPrevious: null,
                                    color: Colors.red),
                              ),
                            ),
                            Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 24, left: 16, right: 16, bottom: 10.0),
                                child: MaterialButton(
                                    elevation: 0,
                                    color: kAccentGreen,
                                    minWidth: kScreenSizeWidth,
                                    height: 36,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                    ),
                                    child: Text(S.of(context).next,
                                        style: kBaseTextStyle.copyWith(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                    onPressed: () {
                                      if (!answeredAll(currentPage)) {
                                        alertUnfilledQuestion();
                                      } else if (currentPage != 3 &&
                                          answeredAll(currentPage)) {
                                        calculateSkinType();
                                        swipeController = SwiperController();
                                        currentPage = currentPage + 1;
                                        swipeController.index = 0;

                                        setState(() {
                                          print("next!");

                                          tabController
                                              .animateTo(currentPage + 1);
                                        });
                                      } else if (currentPage == 3) {
                                        calculateSkinType();
                                        getSkinTypeExplanation();
                                        setState(() {
                                          surveyFinished = true;
                                        });

                                        //setState to render the result screeen
                                        //calculate the skin types!!
                                        //print it out

                                      }
                                    }),
                              ),
                            ),
                          ],
                        ))
                      ],
                    ),
                  )
                : Container(
                    width: screenSize.width,
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView(
                            children: <Widget>[
                              Container(
                                color: kLightPink,
                                padding: EdgeInsets.only(top: 12, bottom: 10),
                                child: Text(
                                  S.of(context).finishedSurvey,
                                  textAlign: TextAlign.center,
                                  style: kBaseTextStyle.copyWith(
                                    fontSize: 12,
                                    color: kPinkAccent,
                                  ),
                                ),
                              ),
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
                              SizedBox(height: 25),
                              Text(
                                skinType,
                                textAlign: TextAlign.center,
                                style: kBaseTextStyle.copyWith(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: kDarkAccent,
                                ),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.only(left: 13, right: 13),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        for (var i = 0;
                                            i < skinTypes.length;
                                            i++)
                                          Text(
                                            "#" + skinTypes[i] + " ",
                                            textAlign: TextAlign.center,
                                            style: kBaseTextStyle.copyWith(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: kDarkAccent,
                                            ),
                                          ),
                                      ],
                                    ),
                                    Text(
                                      getSkinTypeExplanation(),
                                      textAlign: TextAlign.start,
                                      style: kBaseTextStyle.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: kDarkAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(height: 350),
                              Align(
                                alignment: FractionalOffset.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 24,
                                      left: 16,
                                      right: 16,
                                      bottom: 10.0),
                                  child: MaterialButton(
                                      elevation: 0,
                                      color: kAccentGreen,
                                      minWidth: kScreenSizeWidth,
                                      height: 36,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(25.0),
                                      ),
                                      child: Text(S.of(context).save,
                                          style: kBaseTextStyle.copyWith(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white)),
                                      onPressed: () {
                                        //save the results and show in the home page
                                        Navigator.pop(context);
                                        //pop and show the result in the home page
                                      }),
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

  calculateSkinType() {
    //Give yourself 1 point for every “a” answer, 2 points for every “b”, 3 points for every “c”, 4 points for every “d”, and 2.5 points for every “e” answer.
    var score = surveys[currentPage].fold(0.0, (previousValue, element) {
      var index = element.options.indexOf(element.answer).toDouble();
      if (index == 5) {
        index = 2.5;
      }
      return previousValue + index;
    });
    switch (currentPage) {
      case 0:
        skinTypes.add(score < 22 ? "dry" : "oily");
        break;
      case 1:
        skinTypes.add(score < 27 ? "sensitive" : "resistant");
        break;
      case 2:
        skinTypes.add(score < 10 ? "non-pigmented" : "pigmented");
        break;
      case 3:
        skinTypes.add(score < 26 ? "tight" : "wrinkled");
        break;
      default:
    }
    print('skinType : ${skinTypes[currentPage]}');
  }

  getSkinTypeExplanation() {
    String skinType = skinTypes
        .fold(skinTypes[0][0],
            (previousValue, element) => previousValue + element[0])
        .toUpperCase();
    print("skinType: #### $skinType");

    this.skinType = skinType.substring(1, 5);

    print("filtered skinType: #### ${this.skinType}");

    print("Desc!!!!: ${skinTypeDescription[this.skinType]}");
    return skinTypeDescription[this.skinType];

    // var skinType =  skinTypes.fold((value, element) => value)
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
      "sắc tố và không sắc tố",
      "căng vs nhăn",
      "Tight vs Wrinkled"
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
