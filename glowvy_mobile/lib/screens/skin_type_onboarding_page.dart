import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/popups.dart';
import 'package:Dimodo/common/widgets.dart';

import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/skin_issues_onboarding_page.dart';
import 'package:Dimodo/widgets/login_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SkinTypeOnboardingPage extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;

  const SkinTypeOnboardingPage({this.user, this.onLogout});

  @override
  State<StatefulWidget> createState() {
    return SkinTypeOnboardingPageState();
  }
}

class SkinTypeOnboardingPageState extends State<SkinTypeOnboardingPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  UserModel userModel;
  AnimationController _doneButtonController;
  String skinType;
  List<String> skinTypes = [
    'Da dầu',
    'Da khô',
    'Da Nhạy cảm',
    'Da hỗn hợp',
    'Da thường'
  ];

  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);

    _doneButtonController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _doneButtonController.dispose();
    super.dispose();
  }

  void validateInput(String value) {
    final year = double.parse(value);
    print(year);

    // TODO(parker): translate
    if (value == null) {
      throw 'Please provide year.';
    } else if (value.length != 4) {
      throw 'Please input valid birthyear.';
    } else if (year > 2020 || year < 1900) {
      throw 'Please input valid birthyear.';
    }
  }

  Future _updateSkinType(context) async {
    try {
      // validateInput(year);
      await userModel.updateUserSkinType(skinType);
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const SkinIssuesOnboardingPage()));
      // _stopAnimation();
      // Navigator.pop(context);
    } catch (e) {
      print('_updateUserName error: $e');
      // _stopAnimation();
      Popups.failMessage(e, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          leading: backIcon(context),
          backgroundColor: kDefaultBackground,
        ),
        backgroundColor: kDefaultBackground,
        body: Column(
          children: [
            // TODO(parker): translate
            Text('Choose your skin type', style: textTheme.headline2),
            const SizedBox(
              height: 30,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: skinTypes.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () async {
                        setState(() {
                          skinType = skinTypes[index];
                        });
                      },
                      trailing: skinType == skinTypes[index]
                          ? const Icon(
                              Icons.check,
                              color: kPrimaryOrange,
                            )
                          : const Icon(
                              Icons.check,
                              color: kPrimaryOrange,
                              size: 0,
                            ),
                      title: Text(skinTypes[index], style: textTheme.button),
                    ),
                    if (skinTypes.length - 1 != index) kDivider
                  ],
                );
              },
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 35.0),
                  child: Builder(
                    builder: (context) => StaggerAnimation(
                        btnColor: kPrimaryOrange,
                        buttonTitle: 'continue',
                        buttonController: _doneButtonController.view,
                        onTap: () {
                          _updateSkinType(context);
                        }),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
