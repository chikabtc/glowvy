import 'package:Dimodo/common/popups.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/login_animation.dart';

import 'package:Dimodo/widgets/setting_card.dart';

import 'package:flutter/material.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:notification_permissions/notification_permissions.dart';

import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/user/user.dart';

import 'package:provider/provider.dart';

class EditPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditPasswordPageState();
  }
}

class EditPasswordPageState extends State<EditPasswordPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  UserModel userModel;

  String newPassword;
  String doubleCheckPw;
  String currentPassword;
  AnimationController _doneButtonController;

  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);
    _doneButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _doneButtonController.dispose();
    super.dispose();
  }

  validateInput() {
    if (currentPassword == null ||
        newPassword == null ||
        doubleCheckPw == null) {
      throw ('Please provide passwords');
    } else if (currentPassword == newPassword) {
      throw ('Please provide new password.');
    } else if (newPassword != doubleCheckPw) {
      throw ('The new password does not equal');
    }
  }

  _updateUserName(context) async {
    try {
      validateInput();
      await userModel.updatePassword(newPassword);
      await _doneButtonController.reverse();
      Navigator.pop(context);
    } catch (e) {
      print("_updateUserName error: $e");
      await _doneButtonController.reverse();
      Popups.failMessage(e, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Builder(
                  builder: (context) => StaggerAnimation(
                    btnColor: kPrimaryOrange,
                    width: 65,
                    height: 34,
                    buttonTitle: "Done",
                    buttonController: _doneButtonController.view,
                    onTap: () async {
                      _doneButtonController.forward();
                      await _updateUserName(context);
                    },
                  ),
                ),
              ),
            ),
          ],
          leading: backIcon(context),
          backgroundColor: Colors.white,
          title: Text(S.of(context).name, style: textTheme.headline3)),
      backgroundColor: kDefaultBackground,
      body: Container(
        color: kSecondaryWhite,
        child: Column(
          children: [
            CustomTextField(
              onTextChange: (value) {
                setState(() {
                  currentPassword = value;
                });
              },
              obscureText: true,
              hintText: 'Current Password',
            ),
            kDivider,
            CustomTextField(
              onTextChange: (value) {
                setState(() {
                  newPassword = value;
                });
              },
              obscureText: true,
              hintText: 'New Password',
            ),
            kDivider,
            CustomTextField(
              onTextChange: (value) {
                setState(() {
                  doubleCheckPw = value;
                });
              },
              obscureText: true,
              hintText: 'New Password Again',
            ),
          ],
        ),
      ),
    );
  }
}
