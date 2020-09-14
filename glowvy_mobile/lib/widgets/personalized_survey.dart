import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/models/app.dart';
import 'package:Dimodo/models/survey.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:Dimodo/generated/i18n.dart';

class PersonalSurvey extends StatefulWidget {
  Function onSurveyFinish;
  List<Survey> surveys;
  PersonalSurvey({this.onSurveyFinish, this.surveys});
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

    print("survey received: ${widget.surveys[0].toJson()}");

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
                  Text(
                    S.of(context).customizeDimodo,
                    style: kBaseTextStyle.copyWith(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Container(
                width: screenSize.width,
                height: screenSize.height * 0.27,
                child: Swiper(
                  index: 0,
                  controller: _controller,
                  itemHeight: screenSize.height * 0.1,
                  // physics: NeverScrollableScrollPhysics(),
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
                            Text(
                              widget.surveys[i].question,
                              style: kBaseTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: kPrimaryBlue,
                                  fontSize: 15),
                            ),
                            // new ListView.builder(
                            //     itemCount: surveyQuestions[i].length,
                            //     itemBuilder: (BuildContext ctxt, int index) =>
                            //         buildBody(ctxt, index)),
                            SizedBox(height: 10),
                            MaterialButton(
                                elevation: 0,
                                color: kSecondaryBlue,
                                minWidth: (screenSize.width - 48) * 0.5,
                                height: 40,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(36.0),
                                ),
                                child: Text(
                                  widget.surveys[i].options[0],
                                  style: kBaseTextStyle.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: kPrimaryBlue,
                                      fontSize: 15),
                                ),
                                onPressed: () {
                                  if (i == 0) {
                                    userModel.setUserCosmeticsTypesPref(
                                        cosmeticsType:
                                            widget.surveys[i].options[0],
                                        context: context);
                                    _controller.next(animation: true);
                                    print("indeX: $i");
                                  } else if (i == 1) {
                                    userModel.setUserAgeGroup(
                                        ageGroup: widget.surveys[i].options[1],
                                        context: context);
                                    _controller.next(animation: true);
                                  } else if (i == 2) {
                                    userModel.setUserSkinType(
                                        skinType: widget.surveys[i].options[2],
                                        context: context);
                                    setState(() {
                                      widget.onSurveyFinish();
                                    });
                                  }
                                }),
                            SizedBox(height: 10),
                            MaterialButton(
                                elevation: 0,
                                color: kSecondaryBlue,
                                minWidth: (screenSize.width - 48) * 0.5,
                                height: 40,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(36.0),
                                ),
                                child: Text(
                                  widget.surveys[i].options[1],
                                  style: kBaseTextStyle.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: kPrimaryBlue,
                                      fontSize: 15),
                                ),
                                onPressed: () {
                                  if (i == 0) {
                                    userModel.setUserCosmeticsTypesPref(
                                        cosmeticsType:
                                            widget.surveys[i].options[0],
                                        context: context);
                                    _controller.next(animation: true);
                                    print("indeX: $i");
                                  } else if (i == 1) {
                                    userModel.setUserAgeGroup(
                                        ageGroup: widget.surveys[i].options[1],
                                        context: context);
                                    _controller.next(animation: true);
                                  } else if (i == 2) {
                                    userModel.setUserSkinType(
                                        skinType: widget.surveys[i].options[2],
                                        context: context);
                                    setState(() {
                                      widget.onSurveyFinish();
                                    });
                                  }
                                }),
                            SizedBox(height: 10),
                            MaterialButton(
                                elevation: 0,
                                color: kSecondaryBlue,
                                minWidth: (screenSize.width - 48) * 0.5,
                                height: 40,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(36.0),
                                ),
                                child: Text(
                                  widget.surveys[i].options[2],
                                  style: kBaseTextStyle.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: kPrimaryBlue,
                                      fontSize: 15),
                                ),
                                onPressed: () {
                                  if (i == 0) {
                                    userModel.setUserCosmeticsTypesPref(
                                        cosmeticsType:
                                            widget.surveys[i].options[0],
                                        context: context);
                                    _controller.next(animation: true);
                                    print("indeX: $i");
                                  } else if (i == 1) {
                                    userModel.setUserAgeGroup(
                                        ageGroup: widget.surveys[i].options[1],
                                        context: context);
                                    _controller.next(animation: true);
                                  } else if (i == 2) {
                                    userModel.setUserSkinType(
                                        skinType: widget.surveys[i].options[2],
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
                  itemCount: 3,
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
