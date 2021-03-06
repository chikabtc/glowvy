import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/baumann_quiz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class BaumannTestIntro extends StatefulWidget {
  @override
  _BaumannTestIntroState createState() => _BaumannTestIntroState();
}

class _BaumannTestIntroState extends State<BaumannTestIntro> {
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

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: kLightYellow,
          appBar: AppBar(
              elevation: 0,
              brightness: Brightness.light,
              leading: backIcon(context, color: kDarkYellow),
              backgroundColor: Colors.transparent),
          body: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  physics: const ClampingScrollPhysics(),
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text('B???n c?? hi???u l??n da c???a m??nh?',
                                    style: textTheme.headline2),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 43.0, right: 43, bottom: 20),
                                child: Text(
                                  'L??n da m???i ng?????i th???c t??? r???t kh??c nhau. B??i ki???m tra da li???u t??? chuy??n gia Lessie Baumann s??? gi??p b???n th???u hi???u nh???ng v???n ????? v??? da c???a m??nh.',
                                  textAlign: TextAlign.center,
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
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    'B???n ???? s???n s??ng ????? s??? h???u l??n da ho??n h???o nh???t t??? tr?????c ?????n gi????',
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
                            'Sau b??i test n??y, b???n s??? bi???t ???????c: ',
                            style: textTheme.headline3,
                          ),
                          TodoElement(
                              'Nh???ng s???n ph???m skincare ???????c thi???t k??? cho ri??ng b???n'),
                          TodoElement(
                              'Nh???ng tips skincare cho ri??ng c?? nh??n b???n'),
                          TodoElement('K??? ho???ch skincare ?????c quy???n m???i ng??y'),
                          TodoElement('V?? nhi???u h??n th??? n???a...'),
                          Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 28, bottom: 70.0),
                                child: Container(
                                  height: 48,
                                  child: PlatformButton(
                                    disabledColor: kPrimaryOrange,
                                    color: kPrimaryOrange,
                                    material: (_, __) =>
                                        MaterialRaisedButtonData(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0)),
                                    ),
                                    cupertino: (_, __) => CupertinoButtonData(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BaumannQuiz())),
                                    child: Center(
                                      child: Text(
                                        'start',
                                        style: textTheme.headline3
                                            .copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
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
          const SizedBox(width: 3),
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
