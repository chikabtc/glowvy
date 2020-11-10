import 'package:Dimodo/common/popups.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/setting/login.dart';
import 'package:Dimodo/screens/setting/verify_email.dart';
import 'package:Dimodo/widgets/login_animation.dart';
import 'package:flutter/material.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/user/user.dart';

import 'package:provider/provider.dart';

class EditEmailPage extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;

  EditEmailPage({this.user, this.onLogout});

  @override
  State<StatefulWidget> createState() {
    return EditEmailPageState();
  }
}

class EditEmailPageState extends State<EditEmailPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  UserModel userModel;
  String email;
  AnimationController _doneButtonController;
  bool isEmailSent = false;

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

  validateInput(String value) {
    print(value);
    if (value == null) {
      throw ('Please provide year.');
    } else if (value.length < 3) {
      throw ('Please input valid name.');
    }
  }

  _sendEmailVerification(email, context) async {
    try {
      await userModel.sendEmailVerification(email);
      // setState(() {
      //   isEmailSent = true;
      // });
    } catch (e) {
      Popups.failMessage(e, context);
      _doneButtonController.reverse();

      // if (e?.code == 'requires-recent-login') {
      //   Popups.failMessage(e.message, context);
      // } else {
      // }
    }
  }

  _verifyEmail(context) async {
    try {
      if (await userModel.isEmailVerified()) {
        await _updateEmail(context);
        Navigator.pop(context);
      }
    } catch (e) {
      Popups.failMessage(e, context);
    }
    _doneButtonController.reverse();
  }

  _updateEmail(context) async {
    try {
      validateInput(email);
      await userModel.updateEmail(email);
    } catch (e) {
      print("_updateUserName error: ${e}");
      if (e.code == 'requires-recent-login') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
      Popups.failMessage(e, context);
    }
    _doneButtonController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    // var verificationBtn =
    return Scaffold(
      appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          actions: [
            !isEmailSent
                ? Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Center(
                      child: Builder(
                        builder: (context) => StaggerAnimation(
                          btnColor: kPrimaryOrange,
                          width: 57,
                          height: 34,
                          buttonTitle: "Done",
                          buttonController: _doneButtonController.view,
                          onTap: () async {
                            _doneButtonController.forward();
                            await _sendEmailVerification(email, context);

                            // await _updateUserName(context);
                          },
                        ),
                      ),
                    ),
                  )
                : Container()
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
                  email = value;
                });
              },
              hintText: userModel.user.email,
              isReadOnly: isEmailSent,
            ),
            SizedBox(height: 32),
            isEmailSent
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: customButton(
                        function: () => _verifyEmail(context), text: 'verify'),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
