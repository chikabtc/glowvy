import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/edit_password.dart';
import 'package:Dimodo/widgets/setting_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;

  SettingPage({this.user, this.onLogout});

  @override
  State<StatefulWidget> createState() {
    return SettingPageState();
  }
}

class SettingPageState extends State<SettingPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  UserModel userModel;
  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);
  }

  Future logout() async {
    await userModel.logout();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            brightness: Brightness.light,
            elevation: 0,
            leading: backIcon(context),
            backgroundColor: Colors.white,
            title:
                Text(S.of(context).generalSetting, style: textTheme.headline3)),
        backgroundColor: kDefaultBackground,
        body: Consumer<UserModel>(builder: (context, userModel, child) {
          var user = userModel.user;
          return Container(
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                // SettingCard(
                //   color: kWhite,
                //   title: S.of(context).email,
                //   trailingText: user.email,
                //   onTap: () => Navigator.push(
                //       context,
                //       MaterialPageRoute<void>(
                //           builder: (BuildContext context) => EditEmailPage())),
                // ),
                SettingCard(
                  color: kWhite,
                  title: 'password',
                  showDivider: false,
                  // trailingText: ,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              EditPasswordPage())),
                ),

                const SizedBox(height: 7),
                // SettingCard(
                //   color: kWhite,
                //   title: 'Account setting',
                // ),
                GestureDetector(
                  onTap: () async {
                    await logout();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: kWhite,
                    ),
                    height: 48,
                    width: kScreenSizeWidth - 32,
                    child: Center(
                      child: Text(
                        'log out',
                        style:
                            textTheme.bodyText1.copyWith(color: kPrimaryOrange),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }));
  }
}
