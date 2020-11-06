import 'package:Dimodo/common/popups.dart';
import 'package:flutter/material.dart';
import 'package:Dimodo/common/styles.dart';

import 'package:Dimodo/common/colors.dart';
import 'package:provider/provider.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/widgets/login_animation.dart';
import 'package:after_layout/after_layout.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:Dimodo/common/constants.dart';

class VerifyEmailScreen extends StatefulWidget {
  VerifyEmailScreen();

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen>
    with TickerProviderStateMixin {
  AnimationController _verifyAnimationController;
  String code;
  bool isEmailSent = false;
  String accessToken;

  @override
  void initState() {
    super.initState();
    _verifyAnimationController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _verifyAnimationController.dispose();
    super.dispose();
  }

  //update the UI of the screen to show input PIN
  void _onVerifySuccess() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      Navigator.of(context).pop();
    });
  }
  // void onCorrectPin(context) {
  //   print("email is verified!");
  //   _welcomeMessage(context);

  // }

// show fail message in two cases: 1. the email is not registed. 2. PIN is wrong.
  _onVerifyFailure(message, context) async {
    await _verifyAnimationController.reverse();
    Popups.failMessage(message, context);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) print(arguments['fullName']);
    var fullName = arguments['fullName'];

    _verifyEmail(email) async {
      try {
        await Provider.of<UserModel>(context, listen: false)
            .verifyEmail(fullName: fullName);
        _onVerifySuccess();
      } catch (e) {}
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                })
            : Container(),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Builder(
          builder: (context) => Stack(children: [
            ListenableProvider.value(
              value: Provider.of<UserModel>(context, listen: false),
              child: Consumer<UserModel>(builder: (context, model, child) {
                return Container(
                  padding: EdgeInsets.only(right: 16, left: 16),
                  width: screenSize.width,
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                isEmailSent
                                    ? S.of(context).enterPINCode
                                    : S.of(context).forgotpassword,
                                style: kBaseTextStyle.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 23.0),
                      Text(
                          "We sent email to your address to verify your account. Please check the link and click verify button 🙏",
                          style: kBaseTextStyle.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      SizedBox(height: 16.0),
                      SizedBox(height: 16.0),
                      StaggerAnimation(
                          buttonTitle: "verify email",
                          buttonController: _verifyAnimationController.view,
                          onTap: () {
                            _verifyEmail(code);
                          }),
                    ],
                  ),
                );
              }),
            ),
          ]),
        ),
      ),
    );
  }
}
