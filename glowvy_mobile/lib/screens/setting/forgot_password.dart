import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/popups.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/login_animation.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin, AfterLayoutMixin {
  AnimationController _emailButtonController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String email, code, password;
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;
  bool isChecked = false;
  bool isEmailSent = false;
  BuildContext parentContext;
  String accessToken;

  @override
  void initState() {
    super.initState();
    _emailButtonController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _emailButtonController.dispose();
    super.dispose();
  }

  //update the UI of the screen to show input PIN
  void _welcomeMessage(context) {
    _stopAnimation();
    final snackBar =
        SnackBar(content: Text('Pin is sent !', style: kBaseTextStyle));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _inputPIN(accessToken) {
    print('_input pin called');
    _stopAnimation();
    this.accessToken = accessToken;
    kAccessToken = accessToken;
    print('accessToken Received here: $accessToken');
    _emailController.clear();
  }

  void _reset_password() {
    print('_reset_password called');
    Navigator.pushNamed(context, '/reset_password');
  }

  void _failMess(message) {
    _stopAnimation();

    _snackBar(message);
  }

  void _snackBar(String text) {
    final snackBar = SnackBar(
      content:
          Text('$text', style: kBaseTextStyle.copyWith(color: Colors.white)),
      duration: const Duration(seconds: 10),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future _playAnimation() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _emailButtonController.forward();
    } on TickerCanceled {}
  }

  Future<Null> _stopAnimation() async {
    try {
      await _emailButtonController.reverse();
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
      content: Text('Warning: $message', style: kBaseTextStyle),
      duration: const Duration(seconds: 30),
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

  Future _onFailure(message, context) async {
    await _emailButtonController.reverse();
    Popups.failMessage(message, context);
  }

  @override
  Widget build(BuildContext context) {
    var buttonTextStyle =
        Theme.of(context).textTheme.button.copyWith(fontSize: 16);
    final screenSize = MediaQuery.of(context).size;
    parentContext = context;

    Future _sendPasswordResetEmail(email, context) async {
      _playAnimation();
      try {
        Validator.validateEmail(email);

        await Provider.of<UserModel>(context, listen: false)
            .sendPasswordResetEmail(email, success: () {
          _stopAnimation();
          Popups.showSuccesPopup(context, message: 'sent');
          setState(() {
            isEmailSent = true;
          });
        }, fail: () {
          _stopAnimation();
        });
      } catch (e) {
        _onFailure(e, context);
        // _onLoginFailure(e, context);
      }
    }

    Future _checkPIN() {
      if (email == null) {
        _snackBar('Please input fill in all fields');
      } else {
        _playAnimation();
        print('check this pin $code,  accessToken: $accessToken');
        // Provider.of<UserModel>(context, listen: false).checkPIN(
        //     pin: code,
        //     token: accessToken,
        //     success: _reset_password,
        //     fail: _failMess);
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        brightness: Brightness.light,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                })
            : Container(),
        //logout the user and send to the login page
        actions: <Widget>[
          FlatButton(
            child: Text(S.of(context).login,
                style: buttonTextStyle.copyWith(fontWeight: FontWeight.bold)),
            onPressed: () async {
              //1. logout
              //2. pop all the pages except the
              //3. go to login in page
              await Provider.of<UserModel>(context, listen: false).logout();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => route.isFirst);
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
                              Text(
                                S.of(parentContext).forgotpassword,
                                style: kBaseTextStyle.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 23.0),
                      Text(S.of(context).enterEmailToGetPIN,
                          style: kBaseTextStyle.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 16.0),
                      Container(
                          width: screenSize.width,
                          height: 48,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              color: kPureWhite),
                          child: // Group 6
                              Center(
                            child: TextField(
                              controller: _emailController,
                              onChanged: (value) => email = value,
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: theme.cursorColor,
                              style: textTheme.headline5
                                  .copyWith(color: kPrimaryOrange),
                              decoration: kTextField.copyWith(
                                border: InputBorder.none,
                                hintText: S.of(parentContext).enterYourEmail,
                                hintStyle: kBaseTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: kSecondaryGrey.withOpacity(0.5),
                                ),
                                contentPadding: const EdgeInsets.only(left: 20),
                              ),
                            ),
                          )),
                      const SizedBox(height: 16.0),
                      StaggerAnimation(
                          buttonTitle:
                              isEmailSent ? 'resend' : S.of(context).send,
                          buttonController: _emailButtonController.view,
                          onTap: () {
                            _sendPasswordResetEmail(email, context);
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
  void afterFirstLayout(BuildContext context) {}
}
