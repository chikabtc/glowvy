import 'dart:io';
import 'dart:math';

import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/common/widgets.dart';

import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/edit_birthyear_page.dart';
import 'package:Dimodo/screens/edit_gender_page.dart';
import 'package:Dimodo/screens/edit_name_page.dart';
import 'package:Dimodo/screens/edit_region_page.dart';
import 'package:Dimodo/screens/setting.dart';

import 'package:Dimodo/widgets/setting_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

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
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);

    Future.delayed(Duration.zero, () async {
      checkNotificationPermission();
    });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      print("pciked! ${pickedFile.path}");
      await userModel.uploadProfilePicture(File(pickedFile.path));
    } else {
      print('No image selected.');
    }
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
    imageCache.clear();
    PaintingBinding.instance.imageCache.clear();

    kRateMyApp.init().then((_) {});

    return Scaffold(
        appBar: AppBar(
            brightness: Brightness.light,
            elevation: 0,
            leading: backIcon(context),
            backgroundColor: Colors.white,
            title: Text(S.of(context).accounts, style: textTheme.headline3)),
        backgroundColor: kDefaultBackground,
        body: Consumer<UserModel>(builder: (context, userModel, child) {
          User user = userModel.user;
          return Container(
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                SettingCard(
                    color: kWhite,
                    title: "profile photo",
                    trailingWidget: user.picture == null
                        ? Image.asset(
                            'assets/icons/default-avatar.png',
                          )
                        : ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: user.picture +
                                  '?v=${ValueKey(new Random().nextInt(100))}',
                              key: ValueKey(new Random().nextInt(100)),
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                          ),
                    onTap: () async {
                      await getImage();
                    }),
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
                  trailingText: user.address?.province == null
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
                          builder: (BuildContext context) =>
                              EditBirthyearPage())),
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
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) => SettingPage()),
                    // trailingText: userModel.user.fullName,
                  ),
                )
              ],
            ),
          );
        }));
  }
}
