import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/baumann_quiz.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:provider/provider.dart';

class BaumannTestIntro extends StatefulWidget {
  @override
  _BaumannTestIntroState createState() => _BaumannTestIntroState();
}

class _BaumannTestIntroState extends State<BaumannTestIntro> {
  Size screenSize;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  var firstName;
  var lastName;
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
        backgroundColor: kLightYellow,
        appBar: AppBar(
            elevation: 0,

            // expandedHeight: screenSize.height * 0.3,
            brightness: Brightness.light,
            leading: CommonIcons.backIcon(context, kDarkYellow),
            backgroundColor: Colors.transparent),
        body: Container(
          width: screenSize.width,
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top +
                          AppBar().preferredSize.height,
                      bottom: 0),
                  children: <Widget>[
                    Container(
                        color: kLightYellow,
                        width: screenSize.width,
                        // height: screenSize.height / 2.9,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "Know My Skin Type",
                                style: kBaseTextStyle.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FontStyle.italic),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 43.0, right: 43, bottom: 20),
                                child: Text(
                                  "Đây là lựa chọn phù hợp dành cho bạn! Lời khuyên đến từ chuyên gia phù hợp dành riêng cho nhu cầu chăm sóc da của bạn.",
                                  style: kBaseTextStyle.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                              Container(
                                  // color: Colors.purple,
                                  width: screenSize.width - 80,
                                  height: screenSize.height / 2.9 - 92,
                                  child: SvgPicture.asset(
                                      "assets/icons/closed-eye-girl.svg"))
                            ])),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 70,
                            decoration: BoxDecoration(
                              color: kLightYellow,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    "Bạn đã sẵn sàng để sở hữu làn da hoàn hảo nhất từ trước đến giờ?",
                                    style: kBaseTextStyle.copyWith(
                                        color: kDarkYellow,
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                                Image.asset(
                                  "assets/icons/star-vy.png",
                                  width: 80,
                                  height: 70,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Sau bài test này, tôi sẽ biết được: ",
                            style: kBaseTextStyle.copyWith(
                                color: kDarkSecondary,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          TodoElement(
                              "Những sản phẩm skincare được thiết kế cho riêng bạn"),
                          TodoElement(
                              "Những tips skincare cho riêng cá nhân bạn"),
                          TodoElement("Kế hoạch skincare độc quyền mỗi ngày"),
                          TodoElement("Và nhiều hơn thế nữa..."),
                          Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 28, bottom: 28.0),
                              child: Column(
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    Container(
                                        width: (screenSize.width - 50) / 2,
                                        height: 48,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6)),
                                            color: kQuaternaryPink),
                                        child: // Group 6
                                            Center(
                                          child: TextField(
                                            controller: _firstNameController,
                                            cursorColor: kPinkAccent,
                                            onChanged: (value) =>
                                                firstName = value,
                                            style:
                                                TextStyle(color: kDarkAccent),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: S.of(context).firstName,
                                              hintStyle:
                                                  kBaseTextStyle.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: kPrimaryOrange),
                                              contentPadding:
                                                  EdgeInsets.only(left: 20),
                                            ),
                                          ),
                                        )),
                                    const SizedBox(width: 10.0),
                                    Container(
                                        width: (screenSize.width - 50) / 2,
                                        height: 48,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6)),
                                            color: kQuaternaryPink),
                                        child: // Group 6
                                            Center(
                                          child: TextField(
                                            controller: _lastNameController,
                                            style:
                                                TextStyle(color: kDarkAccent),
                                            cursorColor: kPinkAccent,
                                            onChanged: (value) =>
                                                lastName = value,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: S.of(context).lastName,
                                              hintStyle:
                                                  kBaseTextStyle.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: kPrimaryOrange),
                                              contentPadding:
                                                  EdgeInsets.only(left: 20),
                                            ),
                                          ),
                                        )),
                                  ]),
                                  const SizedBox(height: 16.0),
                                  MaterialButton(
                                      elevation: 0,
                                      color: kPrimaryOrange,
                                      minWidth: screenSize.width,
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      enableFeedback: false,
                                      height: 48,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(16.0),
                                      ),
                                      child: Text(S.of(context).starTheSkinTest,
                                          style: kBaseTextStyle.copyWith(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white)),
                                      onPressed: () {
                                        if (firstName != null &&
                                            lastName != null) {
                                          print(
                                              "fN: $firstName and ln: $lastName");
                                          Navigator.pop(context);
                                          userModel.setName(
                                              firstName, lastName);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BaumannQuiz()));
                                        }
                                      }),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class TodoElement extends StatelessWidget {
  final text;
  TodoElement(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: <Widget>[
          SvgPicture.asset("assets/icons/yellow-smiley-face.svg"),
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
