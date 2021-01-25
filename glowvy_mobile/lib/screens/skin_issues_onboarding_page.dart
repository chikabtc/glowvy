import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/popups.dart';
import 'package:Dimodo/common/widgets.dart';

import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/login_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SkinIssuesOnboardingPage extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;

  const SkinIssuesOnboardingPage({this.user, this.onLogout});

  @override
  State<StatefulWidget> createState() {
    return SkinIssuesOnboardingPageState();
  }
}

class SkinIssuesOnboardingPageState extends State<SkinIssuesOnboardingPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  UserModel userModel;
  AnimationController _doneButtonController;

  List<String> selectedIssues = [];
  List<String> skinIssues = ['Mụn', 'Chàm', 'Nhăn', 'Tăng sắc tố da'];

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

  Future _updateSkinIssues(context) async {
    try {
      await userModel.updateUserIssues(selectedIssues);
      //1. success popup
      Navigator.of(context).popUntil((route) => route.isFirst);
      //2. pop everything and go to setting pagess
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
            Text('Choose your skin issues', style: textTheme.headline2),
            const SizedBox(
              height: 30,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: skinIssues.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () async {
                        setState(() {
                          if (selectedIssues.contains(skinIssues[index])) {
                            selectedIssues.remove(skinIssues[index]);
                          } else {
                            selectedIssues.add(skinIssues[index]);
                          }
                        });
                      },
                      trailing: selectedIssues.contains(skinIssues[index])
                          ? const Icon(
                              Icons.check,
                              color: kPrimaryOrange,
                            )
                          : const Icon(
                              Icons.check,
                              color: kPrimaryOrange,
                              size: 0,
                            ),
                      title: Text(skinIssues[index], style: textTheme.button),
                    ),
                    if (skinIssues.length - 1 != index) kDivider
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
                        buttonTitle: 'Start Glowvy',
                        buttonController: _doneButtonController.view,
                        onTap: () {
                          _updateSkinIssues(context);
                        }),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
