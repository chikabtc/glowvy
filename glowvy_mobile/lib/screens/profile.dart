import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/edit_profile_page.dart';

import 'package:Dimodo/screens/search_review_cosmetisc.dart';
import 'package:Dimodo/screens/setting/login.dart';
import 'package:Dimodo/screens/write_review_screen.dart';

import 'package:Dimodo/widgets/baumann_quiz.dart';
import 'package:Dimodo/widgets/user_review_card.dart';
import 'package:firebase_auth/firebase_auth.dart' as b;

import 'package:flutter/material.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/screens/baumannTestIntro.dart';
import 'package:Dimodo/screens/feedback_center.dart';
import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/user/user.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'dart:io' show Platform;
import 'package:flutter_mailer/flutter_mailer.dart';
import 'setting/language.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;

  ProfileScreen({this.user, this.onLogout});

  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen>
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
          builder: (BuildContext context) => userModel.user.skinType == null
              ? BaumannTestIntro()
              : BaumannQuiz(
                  skinType: userModel.user.skinType,
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
        backgroundColor: kWhite,
        // appBar: AppBar(
        //     brightness: Brightness.light,
        //     elevation: 0,
        //     leading: Container(),
        //     backgroundColor: Colors.white),
        extendBodyBehindAppBar: true,
        body: SafeArea(
          top: true,
          child: Container(
            color: kDefaultBackground,
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                GestureDetector(
                  onTap: () => {
                    //log out the firebase user and delete local user obj
                    (b.FirebaseAuth.instance.currentUser != null)
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfilePage()))
                        : Navigator.pushNamed(context, "/register")
                  },
                  child: Container(
                    // height: 97,
                    padding: EdgeInsets.only(left: 16, bottom: 14, top: 84),
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
                              (userModel.isLoggedIn
                                  ? b.FirebaseAuth.instance.currentUser.email
                                  : S.of(context).clickToSignIn),
                              style: textTheme.headline3),
                          Text(
                              userModel.isLoggedIn
                                  ? userModel.user.fullName
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
                                      userModel.user.skinType != null
                                          ? userModel.getFullSkinType(
                                              context, userModel.user.skinType)
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
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
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  padding: EdgeInsets.only(top: 14, left: 16, right: 16),
                  child:
                      Consumer<UserModel>(builder: (context, userModel, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "  Activity (${userModel.reviews.length})",
                          style: textTheme.headline5,
                        ),
                        SizedBox(height: 16),
                        if (userModel.reviews.length == 0)
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
                                              userModel.isLoggedIn
                                                  ? WriteReviewScreen()
                                                  : LoginScreen())),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: kSecondaryOrange,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, top: 9, bottom: 9),
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
                        if (userModel.reviews.length > 0)
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => userModel.isLoggedIn
                                        ? WriteReviewScreen()
                                        : LoginScreen())),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: kQuaternaryOrange,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              width: screenSize.width,
                              height: 48,
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 9, bottom: 9),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/comment.svg',
                                    width: 16,
                                  ),
                                  SizedBox(
                                    width: 5.5,
                                  ),
                                  Text(
                                    'select one related cosmetics',
                                    style: textTheme.headline4
                                        .copyWith(color: kPrimaryOrange),
                                  )
                                ],
                              ),
                            ),
                          ),
                        SizedBox(height: 19),
                      ],
                    );
                  }),
                ),
                Container(
                  color: Colors.red,
                  child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: userModel.reviews.length,
                      itemBuilder: (context, i) => UserReviewCard(
                          context: context,
                          // product: ,
                          review: userModel.reviews[i])),
                ),
                Container(
                  height: 200,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ));
  }
}
