import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/search_review_cosmetisc.dart';
import 'package:Dimodo/widgets/baumann_quiz.dart';
import 'package:firebase_auth/firebase_auth.dart' as b;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/screens/baumannTestIntro.dart';
import 'package:Dimodo/screens/feedback_center.dart';
import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/widgets/webview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'dart:io' show Platform;
import 'package:flutter_mailer/flutter_mailer.dart';
import 'setting/language.dart';

class SettingScreen extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;

  SettingScreen({this.user, this.onLogout});

  @override
  State<StatefulWidget> createState() {
    return SettingScreenState();
  }
}

class SettingScreenState extends State<SettingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool enabledNotification = true;
  UserModel userModel;

  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);

    Future.delayed(Duration.zero, () async {
      checkNotificationPermission();
    });
  }

  void checkNotificationPermission() async {
    try {
      NotificationPermissions.getNotificationPermissionStatus().then((status) {
        if (mounted)
          setState(() {
            enabledNotification = status == PermissionStatus.granted;
          });
      });
    } catch (err) {}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkNotificationPermission();
    }
  }

  showSkinTest() {
    Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => userModel.skinType == null
              ? BaumannTestIntro()
              : BaumannQuiz(
                  skinType: userModel.skinType,
                  skinScores: userModel.skinScores),
          fullscreenDialog: true,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    kRateMyApp.init().then((_) {});

    TextStyle textStyle = Theme.of(context)
        .textTheme
        .body2
        .copyWith(fontSize: 15, color: kDefaultFontColor);

    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          leading: Container(),
          backgroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(S.of(context).accounts,
                style: textStyle.copyWith(
                    fontSize: 19,
                    color: Colors.black,
                    fontWeight: FontWeight.w600)),
            background: Image.network(
              kProfileBackground,
              fit: BoxFit.cover,
            ),
          ),
        ),
        backgroundColor: kDefaultBackground,
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              width: screenSize.width,
              height: screenSize.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => {
                      (widget.user != null)
                          ? print("logged in")
                          : Navigator.pushNamed(context, "/register")
                    },
                    child: Container(
                      height: 97,
                      padding: EdgeInsets.only(left: 16),
                      color: Colors.white,
                      child: Row(children: <Widget>[
                        // Container(width: 16),
                        Image.asset(
                          'assets/icons/default-avatar.png',
                          // width: 75,
                        ),
                        Container(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                                (b.FirebaseAuth.instance.currentUser != null)
                                    ? b.FirebaseAuth.instance.currentUser
                                        .displayName
                                    : S.of(context).clickToSignIn,
                                style: textTheme.headline3),
                            Text(
                                (b.FirebaseAuth.instance.currentUser != null &&
                                        widget.user != null)
                                    ? "s"
                                    : "Shop like Korean",
                                style: textStyle.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: kSecondaryGrey.withOpacity(0.5))),
                            Container(height: 15),
                            Container(
                              width: screenSize.width - 122,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Spacer(),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 0.7, color: kSecondaryGrey),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              8.0) //                 <--- border radius here
                                          ),
                                    ),
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, top: 2, bottom: 2),
                                    child: Text('Edit Profile',
                                        style: textStyle.copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            fontStyle: FontStyle.normal,
                                            color: kSecondaryGrey)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => showSkinTest(),
                        child: Container(
                          height: 70,
                          width: screenSize.width / 2,
                          color: kLightYellow,
                          padding: EdgeInsets.only(
                            top: 13,
                            bottom: 11,
                            left: 16,
                            right: 17,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    S.of(context).yourSkin,
                                    textAlign: TextAlign.start,
                                    style: textTheme.headline4.copyWith(
                                      color: kDarkYellow,
                                    ),
                                  ),
                                  // SizedBox(height: 3.5),
                                  Container(
                                    padding: const EdgeInsets.all(3.0),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      border: Border.all(color: kDarkYellow),
                                    ),
                                    child: Text(
                                        userModel.skinType != null
                                            ? userModel.getFullSkinType(
                                                context, userModel.skinType)
                                            : "????",
                                        textAlign: TextAlign.start,
                                        style: textTheme.caption2.copyWith(
                                            height: 1.3,
                                            color: kDarkYellow,
                                            fontWeight: FontWeight.bold)),
                                  )
                                ],
                              ),
                              Spacer(),
                              SvgPicture.asset("assets/icons/girl-face.svg"),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async => {
                          // await FlutterMailer.send(MailOptions(
                          //     body: '',
                          //     subject:
                          //         'Làm thế nào chúng tôi có thể cải thiện ứng dụng cho bạn?',
                          //     recipients: ['hbpfreeman@gmail.com']))
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FeedbackCenter()))
                        },
                        child: Container(
                          height: 70,
                          width: screenSize.width / 2,
                          color: kPrimaryBlue.withOpacity(0.3),
                          padding: EdgeInsets.only(
                            top: 13,
                            bottom: 12,
                            left: 16,
                            right: 17,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      S.of(context).feedback,
                                      textAlign: TextAlign.start,
                                      style: textTheme.headline4.copyWith(
                                        color: kPrimaryBlue,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        border: Border.all(color: kPrimaryBlue),
                                      ),
                                      child: Text("Cải thiện ứng dụng",
                                          textAlign: TextAlign.start,
                                          style: textTheme.caption2.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: kPrimaryBlue,
                                          )),
                                    )
                                  ],
                                ),
                                Spacer(),
                                SvgPicture.asset(
                                    "assets/icons/message-banner.svg"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 40.0,
                    color: kDefaultBackground,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      padding: EdgeInsets.only(top: 28, left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "  Activity (0)",
                            style: textTheme.headline5,
                          ),
                          SizedBox(height: 14),
                          Container(
                            width: screenSize.width,
                            decoration: BoxDecoration(
                                color: kQuaternaryOrange,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            padding: EdgeInsets.only(top: 31, bottom: 19),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/icons/comment.svg'),
                                SizedBox(height: 18),
                                Text(
                                  'what cosmetics you use \nmore than two times so far?',
                                  style: textTheme.headline4
                                      .copyWith(color: kPrimaryOrange),
                                ),
                                SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ReviewCosmeticsSearchScreen())),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: kSecondaryOrange,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    padding: EdgeInsets.only(
                                        left: 15, right: 15, top: 9, bottom: 9),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/review-cosmetics.svg',
                                          width: 16,
                                        ),
                                        SizedBox(
                                          width: 5.5,
                                        ),
                                        Text(
                                          'select one related cosmetics',
                                          style: textTheme.caption1.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: kPrimaryOrange),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 18),
                                Text(
                                  "share my experience to \nhelp buddies choose better cosmetics",
                                  textAlign: TextAlign.center,
                                  style: textTheme.caption1
                                      .copyWith(color: kDarkSecondary),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  // SettingCard(
                  //   title: S.of(context).orderHistory,
                  //   onTap: () => b.FirebaseAuth.instance.currentUser == null
                  //       ? Navigator.pushNamed(context, "/login")
                  //       : Navigator.pushNamed(context, "/orders"),
                  //   trailingWidget:
                  //       Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  //     Text(S.of(context).viewAll,
                  //         style: textTheme.caption1.copyWith(
                  //           color: kSecondaryGrey.withOpacity(0.5),
                  //         )),
                  //     // Icon(Icons.arrow_forward_ios, size: 12, color: Colors.black26)
                  //   ]),
                  // ),
                  // kFullDivider,
                  // SettingCard(
                  //     title: S.of(context).customerSupport,
                  //     onTap: () =>
                  //         CustomerSupport.openFacebookMessenger(context)),
                  // kFullDivider,
                  // SettingCard(
                  //     title: S.of(context).feedback,
                  //     onTap: () async => {
                  //           await FlutterMailer.send(MailOptions(
                  //             body: '',
                  //             subject: 'Feedback',
                  //             recipients: ['parker@dimodo.app'],
                  //           ))
                  //         }),
                  // kFullDivider,
                  // Container(height: 5, color: kDefaultBackground),
                  // kDivider,
                  // SettingCard(
                  //   title: S.of(context).shippingAddress,
                  //   onTap: () => b.FirebaseAuth.instance.currentUser == null
                  //       ? Navigator.pushNamed(context, "/login")
                  //       : Navigator.pushNamed(context, "/manage_address"),
                  // ),
                  // Container(height: 5, color: kDefaultBackground),
                  // kDivider,
                  // SettingCard(
                  //   title: S.of(context).rateTheApp,
                  //   trailingWidget: SvgPicture.asset(
                  //       'assets/icons/setting/rate.svg',
                  //       width: 24),
                  //   onTap: () => kRateMyApp
                  //       .showRateDialog(context)
                  //       .then((v) => setState(() {})),
                  // ),
                  // kFullDivider,
                  // SettingCard(
                  //   title: S.of(context).share,
                  //   trailingWidget: SvgPicture.asset(
                  //       'assets/icons/setting/share.svg',
                  //       width: 24),
                  //   onTap: () => Share.share(
                  //     Platform.isAndroid
                  //         ? "ca-app-pub-8984237340323037/4196743612"
                  //         : "ca-app-pub-8984237340323037/8355480475",
                  //   ),
                  // ),
                  // kFullDivider,
                  // // SettingCard(
                  // //     title: "Phản hồi",
                  // //     trailingWidget: Row(
                  // //         mainAxisSize: MainAxisSize.min,
                  // //         children: <Widget>[
                  // //           Text("1.0",
                  // //               style: textStyle.copyWith(
                  // //                 fontSize: 13,
                  // //                 color: kDarkSecondary.withOpacity(0.5),
                  // //                 fontWeight: FontWeight.w500,
                  // //               )),
                  // //           // CommonIcons.arrowForward
                  // //         ]),
                  // //     onTap: () => Navigator.push(
                  // //         context,
                  // //         MaterialPageRoute(
                  // //             builder: (context) => WebView(
                  // //                 // url: "https://bit.ly/measurepmf",
                  // //                 url: "https://glowvy.nolt.io/",
                  // //                 title: "Phản hồi⭐️")))),
                  // // SettingCard(
                  // //     title: S.of(context).language,
                  // //     onTap: () => Navigator.push(context,
                  // //         MaterialPageRoute(builder: (context) => Language()))),
                  // kFullDivider,
                  ,
                  // if (b.FirebaseAuth.instance.currentUser == null)
                  //   SettingCard(
                  //     fontColor: kSecondaryGrey,
                  //     title: S.of(context).login,
                  //     trailingWidget: null,
                  //     onTap: () => Navigator.pushNamed(context, "/login"),
                  //   ),
                  // if (b.FirebaseAuth.instance.currentUser != null)
                  //   SettingCard(
                  //     trailingWidget: null,
                  //     fontColor: kSecondaryGrey,
                  //     title: S.of(context).logout,
                  //     onTap: widget.onLogout,
                  //   ),
                  // Expanded(child: Container(color: kDefaultBackground))
                ],
              ),
            )
          ],
        ));
  }
}

class SettingCard extends StatelessWidget {
  final String title;
  final Function onTap;
  final trailingWidget;
  final Color color;
  final fontColor;

  SettingCard(
      {this.title,
      this.onTap,
      this.fontColor = kDarkBG,
      this.trailingWidget =
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black26),
      this.color = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: color,
        margin: EdgeInsets.only(bottom: 1.0),
        elevation: 0,
        child: ListTile(
          onTap: onTap,
          title: Text(title,
              style: kBaseTextStyle.copyWith(
                  fontSize: 16, color: fontColor, fontWeight: FontWeight.w600)),
          trailing: trailingWidget,
          contentPadding: EdgeInsets.only(left: 15, right: 15),
        ));
  }
}
