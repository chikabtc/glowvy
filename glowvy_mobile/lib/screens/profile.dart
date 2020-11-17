import 'dart:math';

import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/baumannTestIntro.dart';
import 'package:Dimodo/screens/before_login_page.dart';
import 'package:Dimodo/screens/edit_profile_page.dart';
import 'package:Dimodo/screens/feedback_center.dart';
import 'package:Dimodo/screens/write_review_screen.dart';
import 'package:Dimodo/widgets/baumann_quiz.dart';
import 'package:Dimodo/widgets/user_review_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart' as b;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;

  ProfilePage({this.user, this.onLogout});

  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool enabledNotification = true;
  UserModel userModel;

  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);
  }

  void showSkinTest() {
    Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => userModel.user.skinType == null
              ? BaumannTestIntro()
              : BaumannQuiz(
                  baumannType: userModel.user.skinType,
                  baumannScores: userModel.user.baumannScores),
          fullscreenDialog: true,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    imageCache.clear();
    PaintingBinding.instance.imageCache.clear();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: kDefaultBackground));
    return Scaffold(

        // extendBodyBehindAppBar: true,
        body: Consumer<UserModel>(builder: (context, userModel, child) {
      final user = userModel.user;
      return !userModel.isLoggedIn
          ? BeforeLoginPage()
          : Container(
              color: kWhite,
              child: ListView(
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfilePage()))
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 16, bottom: 14, top: 84),
                      color: Colors.white,
                      child: Row(children: <Widget>[
                        user.picture == null
                            ? Image.asset(
                                'assets/icons/default-avatar.png',
                              )
                            : ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: user.picture +
                                      '?v=${ValueKey(Random().nextInt(100))}',
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        Container(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                                b.FirebaseAuth.instance.currentUser.email ??
                                    ' ',
                                style: textTheme.headline3),
                            Text(userModel.user.fullName ?? ' ',
                                style: textTheme.caption2),
                            Container(height: 15),
                            Container(
                              width: screenSize.width - 122,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Spacer(),
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
                                        style: textTheme.caption2.copyWith(
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
                                    S.of(context).yourSkin ?? ' ',
                                    textAlign: TextAlign.start,
                                    style: textTheme.headline4.copyWith(
                                      color: kDarkYellow,
                                    ),
                                  ),
                                  // const SizedBox(height: 3.5),
                                  Container(
                                    padding: const EdgeInsets.all(3.0),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      border: Border.all(color: kDarkYellow),
                                    ),
                                    child: Text(
                                        userModel.user.baumannType ?? '????',
                                        textAlign: TextAlign.start,
                                        style: textTheme.caption2.copyWith(
                                            height: 1.3,
                                            color: kDarkYellow,
                                            fontWeight: FontWeight.bold)),
                                  )
                                ],
                              ),
                              const Spacer(),
                              SvgPicture.asset('assets/icons/girl-face.svg'),
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
                                      padding: EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        border: Border.all(color: kPrimaryBlue),
                                      ),
                                      child: Text('Cải thiện ứng dụng',
                                          textAlign: TextAlign.start,
                                          style: textTheme.caption2.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: kPrimaryBlue,
                                          )),
                                    )
                                  ],
                                ),
                                const Spacer(),
                                SvgPicture.asset(
                                    'assets/icons/message-banner.svg'),
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
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      padding:
                          const EdgeInsets.only(top: 14, left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            '  Activity (${userModel.reviews.length})',
                            style: textTheme.headline5,
                          ),
                          const SizedBox(height: 16),
                          if (userModel.reviews.isEmpty)
                            Container(
                              width: screenSize.width,
                              decoration: const BoxDecoration(
                                  color: kQuaternaryOrange,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              padding:
                                  const EdgeInsets.only(top: 31, bottom: 19),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/icons/comment.svg'),
                                  const SizedBox(height: 18),
                                  Text(
                                    'what cosmetics you use \nmore than two times so far?',
                                    style: textTheme.headline4
                                        .copyWith(color: kPrimaryOrange),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WriteReviewScreen())),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: kSecondaryOrange,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      padding: EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 9,
                                          bottom: 9),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/review-cosmetics.svg',
                                            width: 16,
                                          ),
                                          const SizedBox(
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
                                  const SizedBox(height: 18),
                                  Text(
                                    'share my experience to \nhelp buddies choose better cosmetics',
                                    textAlign: TextAlign.center,
                                    style: textTheme.caption1
                                        .copyWith(color: kDarkSecondary),
                                  )
                                ],
                              ),
                            ),
                          if (userModel.reviews.isNotEmpty)
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          WriteReviewScreen())),
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
                                    const SizedBox(
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
                          const SizedBox(height: 19),
                        ],
                      )),
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
            );
    }));
  }
}
