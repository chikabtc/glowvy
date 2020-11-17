import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/baumann_quiz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class BaumannTestIntro extends StatefulWidget {
  @override
  _BaumannTestIntroState createState() => _BaumannTestIntroState();
}

class _BaumannTestIntroState extends State<BaumannTestIntro> {
  Size screenSize;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String firstName;
  String lastName;
  UserModel userModel;
  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: kLightYellow,
          appBar: AppBar(
              elevation: 0,
              // expandedHeight: screenSize.height * 0.3,
              brightness: Brightness.light,
              leading: backIcon(context, color: kDarkYellow),
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
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text('Know My Skin Type',
                                    style: textTheme.headline2),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 43.0, right: 43, bottom: 20),
                                  child: Text(
                                    'Đây là lựa chọn phù hợp dành cho bạn! Lời khuyên đến từ chuyên gia phù hợp dành riêng cho nhu cầu chăm sóc da của bạn.',
                                    style: textTheme.headline5
                                        .copyWith(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                Container(
                                    // color: Colors.purple,
                                    width: screenSize.width - 80,
                                    height: screenSize.height / 2.9 - 92,
                                    child: SvgPicture.asset(
                                        'assets/icons/closed-eye-girl.svg'))
                              ])),
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 70,
                              decoration: const BoxDecoration(
                                color: kLightYellow,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      'Bạn đã sẵn sàng để sở hữu làn da hoàn hảo nhất từ trước đến giờ?',
                                      style: textTheme.headline4.copyWith(
                                        color: kDarkYellow,
                                      ),
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/icons/star-vy.png',
                                    width: 80,
                                    height: 70,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Sau bài test này, tôi sẽ biết được: ',
                              style: textTheme.headline3,
                            ),
                            TodoElement(
                                'Những sản phẩm skincare được thiết kế cho riêng bạn'),
                            TodoElement(
                                'Những tips skincare cho riêng cá nhân bạn'),
                            TodoElement('Kế hoạch skincare độc quyền mỗi ngày'),
                            TodoElement('Và nhiều hơn thế nữa...'),
                            Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 28, bottom: 70.0),
                                child: Column(
                                  children: <Widget>[
                                    Row(children: <Widget>[
                                      Container(
                                          width: (screenSize.width - 50) / 2,
                                          height: 48,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16)),
                                              color: kQuaternaryOrange),
                                          child: // Group 6
                                              Center(
                                            child: MediaQuery(
                                              data: MediaQuery.of(context)
                                                  .copyWith(textScaleFactor: 1),
                                              child: TextField(
                                                  controller:
                                                      _firstNameController,
                                                  cursorColor:
                                                      theme.cursorColor,
                                                  onChanged: (value) =>
                                                      firstName = value,
                                                  style: textTheme.headline5
                                                      .copyWith(
                                                          color: kDarkAccent),
                                                  decoration:
                                                      kTextField.copyWith(
                                                    hintText:
                                                        S.of(context).firstName,
                                                  )
                                                  // decoration: InputDecoration(
                                                  //   border: InputBorder.none,
                                                  //   hintText:
                                                  //       S.of(context).firstName,
                                                  //   hintStyle: textTheme.headline5
                                                  //       .copyWith(
                                                  //           fontWeight:
                                                  //               FontWeight.w600,
                                                  //           color:
                                                  //               kPrimaryOrange),
                                                  //   contentPadding:
                                                  //       const EdgeInsets.only(left: 20),
                                                  // ),
                                                  ),
                                            ),
                                          )),
                                      const SizedBox(width: 10.0),
                                      Container(
                                          width: (screenSize.width - 50) / 2,
                                          height: 48,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16)),
                                              color: kQuaternaryOrange),
                                          child: // Group 6
                                              Center(
                                            child: TextField(
                                                controller: _lastNameController,
                                                style: textTheme.headline5
                                                    .copyWith(
                                                        color: kDarkAccent),
                                                cursorColor: theme.cursorColor,
                                                onChanged: (value) =>
                                                    lastName = value,
                                                decoration: kTextField.copyWith(
                                                  hintText:
                                                      S.of(context).lastName,
                                                )),
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
                                              BorderRadius.circular(16.0),
                                        ),
                                        child: Text('Bắt đầu kiểm tra loại da',
                                            style: textTheme.headline5
                                                .copyWith(color: Colors.white)),
                                        onPressed: () {
                                          if (firstName != null &&
                                              lastName != null) {
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
          )),
    );
  }
}

class TodoElement extends StatelessWidget {
  final String text;
  TodoElement(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: <Widget>[
          SvgPicture.asset('assets/icons/yellow-smiley-face.svg'),
          Flexible(
            child: Text(
              text,
              style: textTheme.headline5
                  .copyWith(color: kSecondaryGrey, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
