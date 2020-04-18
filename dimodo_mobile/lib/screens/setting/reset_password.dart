import 'package:flutter/material.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:provider/provider.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/widgets/login_animation.dart';
import 'package:after_layout/after_layout.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:Dimodo/common/constants.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with TickerProviderStateMixin, AfterLayoutMixin {
  AnimationController _resetButtonController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String password, recheckPassword;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _recheckPasswordController =
      TextEditingController();

  bool isLoading = false;
  bool isChecked = false;
  var parentContext;
  //get kAccessToken from user information PRovider Package

  @override
  void initState() {
    super.initState();
    _resetButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _resetButtonController.dispose();
    super.dispose();
  }

  void _onPasswordChanged(kAccessToken) {
    print("_onPasswordChanged");
    _stopAnimation();
    Navigator.of(context).pushReplacementNamed('/setting');
  }

  //update the UI of the screen to show input PIN
  void _welcomeMessage(context) {
    _stopAnimation();
    final snackBar =
        SnackBar(content: DynamicText('Pin is sent !', style: kBaseTextStyle));
    Scaffold.of(context).showSnackBar(snackBar);
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
      await _resetButtonController.forward();
    } on TickerCanceled {}
  }

  Future<Null> _stopAnimation() async {
    try {
      await _resetButtonController.reverse();
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

    _resetPassword() {
      if (password == null || password != recheckPassword) {
        _snackBar('Please input fill in all fields');
      } else {
        _playAnimation();
        print("check this pin $password and accessToken: $kAccessToken");
        Provider.of<UserModel>(context, listen: false).resetPassword(
            password: password.trim(),
            accessToken: kAccessToken,
            success: _onPasswordChanged,
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
                                S.of(parentContext).resetpassword,
                                style: kBaseTextStyle.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 23.0),
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
                              obscureText: true,
                              controller: _passwordController,
                              onChanged: (value) => password = value,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: S.of(parentContext).newPassword,
                                hintStyle: kBaseTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: kDarkSecondary.withOpacity(0.5),
                                ),
                                contentPadding: EdgeInsets.only(left: 20),
                              ),
                            ),
                          )),
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
                              obscureText: true,
                              controller: _recheckPasswordController,
                              onChanged: (value) => recheckPassword = value,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: S.of(parentContext).confirmPassword,
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
                          titleButton: S.of(context).resetpassword,
                          buttonController: _resetButtonController.view,
                          onTap: () {
                            _resetPassword();
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
