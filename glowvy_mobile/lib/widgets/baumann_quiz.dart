import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/models/app.dart';
import 'package:Dimodo/models/survey.dart';
import 'package:Dimodo/models/user/skinScores.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/skin-score.dart';
import 'package:Dimodo/widgets/survey_card.dart';
import 'package:Dimodo/widgets/tip-card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../generated/i18n.dart';

import 'package:Dimodo/common/styles.dart';

import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/icons.dart';
import 'package:provider/provider.dart';

class BaumannQuiz extends StatefulWidget {
  BaumannQuiz({this.skinType, this.skinScores});

  String skinType;
  SkinScores skinScores = SkinScores();

  @override
  _BaumannQuizState createState() => _BaumannQuizState();
}

class _BaumannQuizState extends State<BaumannQuiz>
    with TickerProviderStateMixin {
  int currentPage = 0;
  List<List<Survey>> surveys = [];
  List<String> skinTypes = [];
  List<bool> chosenAnswers = [];
  dynamic descriptions;
  bool surveyFinished = false;
  bool isSaving = false;
  bool calculatingResult = false;
  bool showFullExplanation = false;
  var skinTypeResults;
  List<dynamic> dos;
  List<dynamic> donts;
  double dsScore;
  double srScore;
  double pnScore;
  double wnScore;
  UserModel userModel;
  var totalProgress = 0;
  SwiperController swipeController;
  List<String> tabList = [
    "khô vs dầu",
    "sắc tố và không sắc tố",
    "căng vs Khỏe nhăn",
    "Căng bóng vs Nhăn nhăn"
  ];

  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);

    swipeController = SwiperController();
    try {
      final baumannQuiz = Provider.of<AppModel>(context, listen: false)
          .appConfig['Baumann_quiz'];
      final dVsO = baumannQuiz["khô vs da dầu"] as List;
      final sVsR = baumannQuiz["Nhạy cảm vs đề kháng cao"] as List;
      final nVsP = baumannQuiz["không sắc tố sắc tố và"] as List;
      final tVsW = baumannQuiz["căng vs nhăn"] as List;
      skinTypeResults = baumannQuiz["skin-type-results"];
      descriptions = baumannQuiz["section-descriptions"];

      List<Survey> dVsOSurvey = [];
      dVsO.forEach((e) {
        dVsOSurvey.add(Survey.fromJson(e));
      });
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
      surveys
        ..add(dVsOSurvey)
        ..add(sVsRSurvey)
        ..add(nVsPSurvey)
        ..add(tVsWSurvey);
    } catch (err) {
      var message = "Fail to load the bauman_quiz_data:" + err.toString();
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
      print("widget skin type: ${widget.skinType}");
      surveyFinished = true;
      skinTypes.clear();
      widget.skinType.runes.forEach((int rune) {
        var character = String.fromCharCode(rune);
        skinTypes.add(character);
      });
      dsScore = widget.skinScores.dsScore;
      srScore = widget.skinScores.srScore;
      pnScore = widget.skinScores.pnScore;
      wnScore = widget.skinScores.wnScore;
      getSkinTypeResults();
      if (widget.skinType.contains("R")) {
        showFullExplanation = true;
      }
    }

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: Text(
              !surveyFinished ? "Test Baumann về da" : "Loại Da Của Tôi",
              style: textTheme.headline3.copyWith(color: kDarkYellow)),
          brightness: Brightness.light,
          leading: !surveyFinished
              ? IconButton(
                  icon: Icon(
                    Icons.close,
                    color: kDarkYellow,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  })
              : backIcon(context, color: kDarkYellow),
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
                            style: textTheme.headline4
                                .copyWith(color: kDarkYellow),
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
                              child: Text(descriptions["description2"],
                                  style: textTheme.button2
                                      .copyWith(color: kDarkYellow)),
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
                                    index: totalProgress,
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
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: calculatingResult
                                        ? CupertinoActivityIndicator()
                                        : Text("Kiểm tra loại da",
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
                                        getSkinTypeResults();
                                        setState(() {
                                          calculatingResult = true;
                                        });
                                        Future.delayed(
                                            const Duration(milliseconds: 2500),
                                            () {
                                          SkinScores scores = SkinScores(
                                              dsScore: dsScore,
                                              srScore: srScore,
                                              pnScore: pnScore,
                                              wnScore: wnScore);
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
                                child: Column(children: <Widget>[
                                  SizedBox(height: 16.5),
                                  SkinScore("Dầu", "Khô", score: dsScore),
                                  SkinScore("Sắc tố", "Không có\nsắc tố",
                                      score: srScore),
                                  SkinScore("Nhạy cảm", "Khỏe mạnh",
                                      score: pnScore),
                                  SkinScore("Căng bóng", "Nhăn nheo",
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
                                      "Chuyên viên quản lý da chuyên nghiệp",
                                      textAlign: TextAlign.start,
                                      maxLines: showFullExplanation ? 30 : 3,
                                      style: textTheme.headline4.copyWith(
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
                                        child: Container(
                                          padding: EdgeInsets.only(top: 15),
                                          width: screenSize.width - 60,
                                          child: Wrap(
                                            children: <Widget>[
                                              SizedBox(height: 10),
                                              Text(
                                                skinTypeResults[widget.skinType]
                                                    ['explanation'],
                                                textAlign: TextAlign.start,
                                                maxLines: showFullExplanation
                                                    ? 30
                                                    : 3,
                                                style: textTheme.headline5
                                                    .copyWith(
                                                  color: kDarkYellow,
                                                ),
                                              ),
                                              !showFullExplanation
                                                  ? Text(
                                                      "... Nhiều hơn",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: textTheme.headline5
                                                          .copyWith(
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
                                "- Tips chăm sóc da độc quyền -",
                                textAlign: TextAlign.center,
                                style: textTheme.headline4.copyWith(
                                  color: kDarkAccent,
                                ),
                              ),
                              Container(height: 13),
                              Container(
                                  width: screenSize.width,
                                  height: 223,
                                  // padding: EdgeInsets.only(left: 10),
                                  child: ListView.separated(
                                      padding: EdgeInsets.only(left: 10),
                                      separatorBuilder: (context, index) =>
                                          Container(width: 10),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: dos.length + donts.length,
                                      itemBuilder:
                                          (BuildContext context, int i) {
                                        if (i > dos.length - 1) {
                                          return TipCard(donts[i - dos.length],
                                              i - dos.length + 1, false);
                                        }
                                        return TipCard(dos[i], i + 1, true);
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
                                    style: textTheme.bodyText2.copyWith(
                                      color: kSecondaryGrey,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              'Bạn không hài lòng với kết quả? \nHãy '),
                                      TextSpan(
                                          text: 'bấm vào đây ',
                                          style: textTheme.bodyText2.copyWith(
                                            color: kSecondaryGrey,
                                          )),
                                      TextSpan(text: ' để thử lại'),
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
                                    Text("Câu chuyện của Glowvy ",
                                        style: textTheme.headline4
                                            .copyWith(color: kDarkAccent)),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 33,
                                          right: 33,
                                          top: 14,
                                          bottom: 14),
                                      child: Text(
                                          "Glowvy là đứa con tinh thần của một nhóm các bạn trẻ người Hàn Quốc nhằm giúp tìm ra loại mỹ phẩm phù hợp với loại da và các vấn đề về da của bạn. Với mục tiêu biến làn da trở nên căng bóng và tỏa sáng, Glowvy luôn nỗ lực để cung cấp những lời khuyên về mĩ phẩm, phân tích loại da và tips chăm sóc da phù hợp với riêng mỗi người. Bạn đã bao giờ trải qua việc mua phải và sử dụng những mĩ phẩm làm hỏng da của bạn chưa? Hãy kể cho Glowvy biết về điều đó~~",
                                          style: textTheme.bodyText1
                                              .copyWith(color: kDarkAccent)),
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
                                                    style: textTheme.headline5
                                                        .copyWith(
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
                                                print(
                                                    "scores@@ ${widget.skinScores}");
                                                setState(() {
                                                  isSaving = true;
                                                  Provider.of<UserModel>(
                                                          context,
                                                          listen: false)
                                                      .saveSkinType(
                                                          widget.skinType,
                                                          widget.skinScores);
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
                                    Text("Glowvy x Căng bóng làn da",
                                        style: textTheme.bodyText2.copyWith(
                                            fontStyle: FontStyle.italic,
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
            style: textTheme.headline5,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok',
                style: textTheme.headline5,
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

  getSkinTypeResults() {
    widget.skinType = skinTypes.join();
    print("widget.skinType: ${widget.skinType}");
    dos = skinTypeResults[widget.skinType]["do"].map((item) => item).toList();
    donts =
        skinTypeResults[widget.skinType]["dont"].map((item) => item).toList();
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
