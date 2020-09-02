import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/baumann_quiz.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:provider/provider.dart';

class FeedbackCenter extends StatefulWidget {
  @override
  _FeedbackCenterState createState() => _FeedbackCenterState();
}

class _FeedbackCenterState extends State<FeedbackCenter> {
  Size screenSize;
  UserModel userModel;
  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0,
            title: Text(
              "Give feedback",
              style: kBaseTextStyle.copyWith(
                  color: kPrimaryBlue,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            // expandedHeight: screenSize.height * 0.3,
            brightness: Brightness.light,
            leading: CommonIcons.backIcon(context, kPrimaryBlue),
            backgroundColor: kQuaternaryBlue),
        body: SafeArea(
          child: Container(
            width: screenSize.width,
            child: ListView(
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Container(
                      height: 160,
                      color: kQuaternaryBlue,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 20.0, right: 20, bottom: 30),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: kSecondaryBlue),
                        padding: EdgeInsets.only(
                            left: 16, right: 30, top: 14, bottom: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  "User research, glowvy app survey",
                                  style: kBaseTextStyle.copyWith(
                                      color: kPrimaryBlue,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "User research, glowvy app survey",
                                  style: kBaseTextStyle.copyWith(
                                      color: kPrimaryBlue,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Spacer(),
                            SvgPicture.asset("assets/icons/arrow-more.svg")
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: 0,
                        child:
                            SvgPicture.asset("assets/icons/blue-big-logo.svg")),
                    Positioned(
                        top: 0,
                        left: screenSize.width / 2 + 58,
                        child: SvgPicture.asset(
                            "assets/icons/light-blue-star.svg"))
                  ],
                ),
                Container(
                  width: screenSize.width,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.only(right: screenSize.width / 3),
                        child: SvgPicture.asset(
                            "assets/icons/primary-blue-star.svg"),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "To make Glowvy Better",
                        style: kBaseTextStyle.copyWith(
                            color: kDarkSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      TextWithIcon("yodwq msadwqrqwe",
                          "assets/icons/blue-smiley-face.svg"),
                      TextWithIcon("yodwq msadwqrqwe",
                          "assets/icons/blue-smiley-face.svg"),
                      TextWithIcon("yodwq msadwqrqwe",
                          "assets/icons/blue-smiley-face.svg"),
                      TextWithIcon("yodwq msadwqrqwe",
                          "assets/icons/blue-smiley-face.svg"),
                      SizedBox(height: 36),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            color: kPrimaryBlue),
                        width: screenSize.width,
                        height: 48,
                        alignment: Alignment.center,
                        child: Text(
                          "Make Glowvy Better",
                          style: kBaseTextStyle.copyWith(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 54),
                      SvgPicture.asset("assets/icons/light-blue-feedback.svg"),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.only(left: 48, right: 48),
                        child: Text(
                          "Having troubles with the app? Email developers! Glowvy Team will response it as soon as possible",
                          textAlign: TextAlign.center,
                          style: kBaseTextStyle.copyWith(
                              color: kDarkSecondary,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: 22),
                      Container(
                          height: 48,
                          padding: EdgeInsets.only(left: 48, right: 48),
                          alignment: Alignment.center,
                          child: Text("Contact Glowvy Developer",
                              textAlign: TextAlign.center,
                              style: kBaseTextStyle.copyWith(
                                  color: kPrimaryBlue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: kQuaternaryBlue, width: 2),
                            borderRadius: BorderRadius.circular(15.0),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class TextWithIcon extends StatelessWidget {
  final text;
  final iconPath;
  TextWithIcon(this.text, this.iconPath);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: <Widget>[
          SvgPicture.asset(iconPath),
          SizedBox(width: 7),
          Flexible(
            child: Text(
              text,
              style: kBaseTextStyle.copyWith(
                  color: kDarkSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
