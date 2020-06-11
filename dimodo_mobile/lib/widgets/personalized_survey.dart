import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/models/app.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

class PersonalSurvey extends StatefulWidget {
  Function onSurveyFinish;
  PersonalSurvey({this.onSurveyFinish});
  @override
  _PersonalSurveyState createState() => _PersonalSurveyState();
}

class _PersonalSurveyState extends State<PersonalSurvey> {
  @override
  Widget build(BuildContext parentContext) {
    var screenSize = MediaQuery.of(parentContext).size;
    SwiperController _controller = new SwiperController();
    var surveyQuestions = [
      [
        "1. What cosmetics are you looking for",
        "Speialized Acne",
        "Whiten Skin"
      ],
      ["What is your age?", "15-22", "22-29"]
    ];

    var userModel = Provider.of<UserModel>(context, listen: false);

    return LayoutBuilder(
      builder: (BuildContext buildcontext, BoxConstraints constraints) {
        return Container(
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 21),
                  Image.asset(
                    "assets/icons/survey.png",
                  ),
                  DynamicText(
                    "Survey",
                    style: kBaseTextStyle.copyWith(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Container(
                width: screenSize.width,
                height: screenSize.height * 0.2,
                child: Swiper(
                  index: 0,
                  controller: _controller,
                  itemHeight: screenSize.height * 0.1,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kQuaternaryBlue,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        padding: EdgeInsets.only(
                            right: 15, left: 15, top: 10, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DynamicText(
                              surveyQuestions[i][0],
                              style: kBaseTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: kPrimaryBlue,
                                  fontSize: 15),
                            ),
                            SizedBox(height: 10),
                            MaterialButton(
                                elevation: 0,
                                color: kSecondaryBlue,
                                minWidth: (screenSize.width - 48) * 0.5,
                                height: 40,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(36.0),
                                ),
                                child: DynamicText(
                                  surveyQuestions[i][1],
                                  style: kBaseTextStyle.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: kPrimaryBlue,
                                      fontSize: 15),
                                ),
                                onPressed: () {
                                  if (i == 0) {
                                    userModel.setUserCosmeticsTypesPref(
                                        cosmeticsType: surveyQuestions[i][1],
                                        context: context);
                                    _controller.next(animation: true);
                                    print("indeX: $i");
                                  } else if (i == 1) {
                                    userModel.setUserAgeGroup(
                                        ageGroup: surveyQuestions[i][1],
                                        context: context);
                                    setState(() {
                                      widget.onSurveyFinish();
                                    });
                                  }
                                }),
                            SizedBox(height: 10),
                            MaterialButton(
                                elevation: 0,
                                color: kPrimaryBlue,
                                minWidth: (screenSize.width - 48) * 0.5,
                                height: 40,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(36.0),
                                ),
                                child: DynamicText(
                                  surveyQuestions[i][2],
                                  style: kBaseTextStyle.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 15),
                                ),
                                onPressed: () {
                                  if (i == 0) {
                                    userModel.setUserCosmeticsTypesPref(
                                        cosmeticsType: surveyQuestions[i][2],
                                        context: context);
                                    _controller.next(animation: true);
                                    print("indeX: $i");
                                  } else if (i == 1) {
                                    userModel.setUserAgeGroup(
                                        ageGroup: surveyQuestions[i][2],
                                        context: context);
                                    setState(() {
                                      widget.onSurveyFinish();
                                    });
                                  }
                                }),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: 2,
                  pagination: new SwiperPagination(
                      builder: new DotSwiperPaginationBuilder(
                          size: 5 * kSizeConfig.containerMultiplier,
                          activeSize: 5 * kSizeConfig.containerMultiplier,
                          color: Colors.grey.withOpacity(0.8),
                          activeColor: kPrimaryBlue)),
                  control: SwiperControl(
                      iconNext: null, iconPrevious: null, color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
