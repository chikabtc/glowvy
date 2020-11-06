import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/address/address.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/edit_birthyear_page.dart';
import 'package:Dimodo/screens/edit_gender_page.dart';
import 'package:Dimodo/screens/edit_name_page.dart';
import 'package:Dimodo/screens/edit_region_page.dart';

import 'package:Dimodo/screens/search_review_cosmetisc.dart';
import 'package:Dimodo/screens/setting/add_shipping_address.dart';
import 'package:Dimodo/screens/setting/login.dart';
import 'package:Dimodo/screens/write_review_screen.dart';

import 'package:Dimodo/widgets/baumann_quiz.dart';
import 'package:Dimodo/widgets/setting_card.dart';
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

class EditProfilePage extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;

  EditProfilePage({this.user, this.onLogout});

  @override
  State<StatefulWidget> createState() {
    return EditProfilePageState();
  }
}

class EditProfilePageState extends State<EditProfilePage>
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

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;
    User user = userModel.user;
    // userModel.user.address = Address();

    kRateMyApp.init().then((_) {});

    TextStyle textStyle = Theme.of(context)
        .textTheme
        .body2
        .copyWith(fontSize: 15, color: kDefaultFontColor);

    return Scaffold(
        appBar: AppBar(
            brightness: Brightness.light,
            elevation: 0,
            leading: backIcon(context),
            backgroundColor: Colors.white,
            title: Text(S.of(context).accounts, style: textTheme.headline3)),
        backgroundColor: kDefaultBackground,
        body: Container(
          child: ListView(
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              SettingCard(
                color: kWhite,
                title: "profile photo",
                trailingWidget: Image.asset(
                  'assets/icons/default-avatar.png',
                ),
              ),
              SettingCard(
                color: kWhite,
                title: S.of(context).name,
                trailingText: user.fullName,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) => EditNamePage())),
              ),
              SettingCard(
                color: kWhite,
                title: "gender",
                trailingText: user.gender,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) => EditGenderPage())),
              ),
              SettingCard(
                color: kWhite,
                title: "Region",
                trailingText: user.address.province == null
                    ? ""
                    : user.address.province.name,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) => EditRegionPage())),
              ),
              SettingCard(
                color: kWhite,
                title: "Birthday",
                trailingText: user.birthYear.toString(),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) => EditBirthyearPage()

                        // fullscreenDialog: true,
                        )),
              ),
              SettingCard(
                color: kWhite,
                title: "Skin Type",
                trailingText: userModel.user.fullName,
              ),
              SettingCard(
                color: kWhite,
                title: "Skin Issues",
                // trailingText: userModel.user.fullName,
              ),
              SizedBox(height: 7),
              SettingCard(
                color: kWhite,
                title: "Account setting",
                // trailingText: userModel.user.fullName,
              ),

              // GestureDetector(
              //   onTap: () => {
              //     //log out the firebase user and delete local user obj
              //     (b.FirebaseAuth.instance.currentUser != null)
              //         ? userModel.logout()
              //         : Navigator.pushNamed(context, "/register")
              //   },
              //   child: Container(
              //     height: 97,
              //     padding: EdgeInsets.only(left: 16, bottom: 14),
              //     color: Colors.white,
              //     child: Row(children: <Widget>[
              //       // Container(width: 16),

              //       Spacer(),
              //       // backIcon()
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: <Widget>[
              //           Text(
              //               (userModel.isLoggedIn
              //                   ? b.FirebaseAuth.instance.currentUser.email
              //                   : S.of(context).clickToSignIn),
              //               style: textTheme.headline3),
              //           Text(
              //               userModel.isLoggedIn
              //                   ? userModel.user.fullName
              //                   : "Shop like Korean",
              //               style: textStyle.copyWith(
              //                   fontWeight: FontWeight.w500,
              //                   fontSize: 13,
              //                   color: kSecondaryGrey.withOpacity(0.5))),
              //           Container(height: 15),
              //           Container(
              //             width: screenSize.width - 122,
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.end,
              //               children: [
              //                 Spacer(),
              //                 Container(
              //                   decoration: BoxDecoration(
              //                     border: Border.all(
              //                         width: 0.7, color: kSecondaryGrey),
              //                     borderRadius: BorderRadius.all(
              //                         Radius.circular(
              //                             8.0) //                 <--- border radius here
              //                         ),
              //                   ),
              //                   padding: EdgeInsets.only(
              //                       left: 10, right: 10, top: 2, bottom: 2),
              //                   child: Text('Edit Profile',
              //                       style: textStyle.copyWith(
              //                           fontWeight: FontWeight.w700,
              //                           fontSize: 12,
              //                           fontStyle: FontStyle.normal,
              //                           color: kSecondaryGrey)),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ],
              //       ),
              //     ]),
              //   ),
              // ),
            ],
          ),
        ));
  }
}
