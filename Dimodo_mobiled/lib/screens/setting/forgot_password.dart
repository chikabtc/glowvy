import 'package:flutter/material.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:provider/provider.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/widgets/login_animation.dart';
import 'package:after_layout/after_layout.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:Dimodo/common/constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen();

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin, AfterLayoutMixin {
  AnimationController _loginButtonController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String email, pin, password;
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;
  bool isChecked = false;
  bool isEmailSent = false;
  var parentContext;
  String accessToken;

  @override
  void initState() {
    super.initState();
    _loginButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  //update the UI of the screen to show input PIN
  void _welcomeMessage(context) {
    _stopAnimation();
    final snackBar =
        SnackBar(content: DynamicText('Pin is sent !', style: kBaseTextStyle));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _inputPIN(accessToken) {
    print("_input pin called");
    _stopAnimation();
    this.accessToken = accessToken;
    kAccessToken = accessToken;
    print("accessToken Received here: $accessToken");
    isEmailSent = true;
    _emailController.clear();
  }

  void _reset_password() {
    print("_reset_password called");
    Navigator.pushNamed(context, "/reset_password");
  }

  void _failMess(message) {
    _stopAnimation();

    _snackBar(message);
  }

  void _snackBar(String text) {
    final snackBar = SnackBar(
      content: DynamicText('$text',
          style: kBaseTextStyle.copyWith(color: Colors.white)),
      duration: Duration(seconds: 10),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<Null> _playAnimation() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _loginButtonController.forward();
    } on TickerCanceled {}
  }

  Future<Null> _stopAnimation() async {
    try {
      await _loginButtonController.reverse();
      setState(() {
        isLoading = false;
      });
    } on TickerCanceled {}
  }

// show fail message in two cases: 1. the email is not registed. 2. PIN is wrong.
  void _failMessage(message, context) {
    /// Showing Error messageSnackBarDemo
    /// Ability so close message
    final snackBar = SnackBar(
      content: DynamicText('Warning: $message', style: kBaseTextStyle),
      duration: Duration(seconds: 30),
      action: SnackBarAction(
        label: S.of(context).close,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    _stopAnimation();
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle buttonTextStyle =
        Theme.of(context).textTheme.button.copyWith(fontSize: 16);
    final screenSize = MediaQuery.of(context).size;
    parentContext = context;

    _requestPIN(email) {
      print("request pin: $email");
      if (!email.contains("@")) {
        print(
            "Please input valid email'Please input valid email'Please input valid email'");
        _snackBar('Please input valid email');
      } else if (email == null) {
        _snackBar('Please input fill in all fields');
      } else {
        _playAnimation();
        Provider.of<UserModel>(context, listen: false)
            .requestPIN(email: email, success: _inputPIN, fail: _failMess);
      }
    }

    _checkPIN() {
      if (email == null) {
        _snackBar('Please input fill in all fields');
      } else {
        _playAnimation();
        print("check this pin $pin,  accessToken: $accessToken");
        Provider.of<UserModel>(context, listen: false).checkPIN(
            pin: pin,
            token: accessToken,
            success: _reset_password,
            fail: _failMess);
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                })
            : Container(),
        actions: <Widget>[
          FlatButton(
            child: DynamicText(S.of(context).login,
                style: buttonTextStyle.copyWith(fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.pushNamed(context, "/login");
            },
          )
        ],
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
                              DynamicText(
                                isEmailSent
                                    ? S.of(parentContext).enterPINCode
                                    : S.of(parentContext).forgotpassword,
                                style: kBaseTextStyle.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 23.0),
                      DynamicText(
                          isEmailSent
                              ? S.of(context).enterSixDigitCode
                              : S.of(context).enterEmailToGetPIN,
                          style: kBaseTextStyle.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      SizedBox(height: 16.0),
                      Container(
                          width: screenSize.width,
                          height: 48,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              color: kPureWhite),
                          child: // Group 6
                              Center(
                            child: TextField(
                              controller: _emailController,
                              onChanged: (value) =>
                                  isEmailSent ? pin = value : email = value,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: isEmailSent
                                    ? S.of(parentContext).enterPIN
                                    : S.of(parentContext).enterYourEmail,
                                hintStyle: kBaseTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: kDarkSecondary.withOpacity(0.5),
                                ),
                                contentPadding: EdgeInsets.only(left: 20),
                              ),
                            ),
                          )),
                      SizedBox(height: 16.0),
                      StaggerAnimation(
                          titleButton: isEmailSent
                              ? S.of(context).enter
                              : S.of(context).send,
                          buttonController: _loginButtonController.view,
                          onTap: () {
                            isEmailSent ? _checkPIN() : _requestPIN(email);
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

  @override
  void afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout
  }
}
