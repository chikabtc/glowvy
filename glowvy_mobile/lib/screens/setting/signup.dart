import 'dart:io';

import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/popups.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/login_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  final bool fromCart;
  const SignupScreen({this.fromCart = false});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin {
  AnimationController _loginButtonController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String fullName, email, password;
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = false;
  bool isChecked = false;
  BuildContext parentContext;

  @override
  void initState() {
    super.initState();
    _loginButtonController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  Future _playAnimation() async {
    await _loginButtonController.forward();
  }

  Future _stopAnimation() async {
    await _loginButtonController.reverse();
  }

  void _onsignupFailure(message, context) {
    _stopAnimation();
    showFailMessage(message, context);
  }

  Future onSignupSuccess(User user) async {
    Future.delayed(const Duration(milliseconds: 1000), () {
      Navigator.of(context).pop();
    });
  }

  bool isInputValid() {
    final emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    if (!email.contains('@')) {
      throw 'Please input valid email format';
    } else if (fullName == null || email == null || password == null) {
      throw 'Please input fill in all fields';
    } else if (!emailValid) {
      throw 'wrong email format';
    } else {
      return true;
    }
  }

  Future _registerWithEmail(fullName, email, password, context) async {
    try {
      _playAnimation();
      Validator.validateEmail(email);
      await Provider.of<UserModel>(context, listen: false).registerWithEmail(
        email: email,
        password: password,
        fullName: fullName,
        success: (user) {
          onSignupSuccess(user);
        },
        fail: (message) {
          _onsignupFailure(message, context);
        },
      );
    } catch (e) {
      _onsignupFailure(e, context);
    }
  }

  Future _registerWithFacebook(context) async {
    await _playAnimation();
    await Provider.of<UserModel>(context, listen: false).loginFB(
      success: (user) {
        onSignupSuccess(user);
      },
      fail: (message) {
        _onsignupFailure(message, context);
      },
    );
  }

  Future _registerWithGoogle(context) async {
    _playAnimation();

    await Provider.of<UserModel>(context, listen: false).loginGoogle(
      success: (user) {
        onSignupSuccess(user);
      },
      fail: (message) {
        _onsignupFailure(message, context);
      },
    );
  }

  Future _registerWithApple(context) async {
    _playAnimation();

    Provider.of<UserModel>(context, listen: false).loginApple(
      success: (user) {
        _playAnimation();

        onSignupSuccess(user);
      },
      fail: (message) {
        _onsignupFailure(message, context);
      },
    );
  }

  //

  Future showFailMessage(message, context) async {
    Popups.failMessage(message, context);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    parentContext = context;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        brightness: Brightness.light,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                })
            : Container(),
        actions: <Widget>[
          FlatButton(
            child: Text(S.of(context).login,
                style: textTheme.button.copyWith(fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
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
                  padding: const EdgeInsets.only(right: 16, left: 16),
                  width: screenSize.width,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 0.0),
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(S.of(parentContext).signup,
                                  style: textTheme.headline1)
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 23.0),
                      Container(
                          width: screenSize.width,
                          height: 48,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              color: kQuaternaryOrange),
                          child: // Group 6
                              Center(
                            child: TextField(
                              cursorColor: kPinkAccent,
                              onChanged: (value) => fullName = value,
                              style: textTheme.headline5
                                  .copyWith(color: kPrimaryOrange),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: S.of(parentContext).fullName,
                                hintStyle: textTheme.headline5.copyWith(
                                  color: kSecondaryGrey.withOpacity(0.5),
                                ),
                                contentPadding: const EdgeInsets.only(left: 20),
                              ),
                            ),
                          )),
                      const SizedBox(height: 12.0),
                      Container(
                          width: screenSize.width,
                          height: 48,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              color: kQuaternaryOrange),
                          child: // Group 6
                              Center(
                            child: TextField(
                                style: textTheme.headline5
                                    .copyWith(color: kPrimaryOrange),
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: kPinkAccent,
                                onChanged: (value) => email = value,
                                decoration: kTextField.copyWith(
                                  hintText: S.of(parentContext).enterYourEmail,
                                )),
                          )),
                      const SizedBox(height: 12.0),
                      Container(
                          width: screenSize.width,
                          height: 48,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              color: kQuaternaryOrange),
                          child: // Group 6
                              Center(
                                  child: TextField(
                            style: textTheme.headline5
                                .copyWith(color: kPrimaryOrange),
                            keyboardType: TextInputType.text,
                            cursorColor: kPinkAccent,
                            onChanged: (value) => password = value,
                            obscureText: isPasswordVisible,
                            decoration: kTextField.copyWith(
                              hintText: S.of(parentContext).password,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ))),
                      const SizedBox(
                        height: 16.0,
                      ),
                      const SizedBox(height: 10),
                      Builder(
                        builder: (context) => StaggerAnimation(
                            btnColor: kPrimaryOrange,
                            buttonTitle: S.of(context).signup,
                            buttonController: _loginButtonController.view,
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              _registerWithEmail(
                                  fullName, email, password, context);
                            }),
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      Text(S.of(context).loginWithSNS,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade400)),
                      const SizedBox(
                        height: 24.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          MaterialButton(
                            color: kPrimaryOrange,
                            minWidth: 48,
                            height: 48,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            onPressed: () => _registerWithFacebook(context),
                            child: SvgPicture.asset(
                              'assets/icons/facebook-social.svg',
                              width: 24,
                            ),
                            elevation: 0.0,
                          ),
                          // const SizedBox(width: 35),
                          // MaterialButton(
                          //   color: kPrimaryOrange,
                          //   minWidth: 48,
                          //   height: 48,
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(16.0)),
                          //   onPressed: () => _registerWithGoogle(context),
                          //   child: SvgPicture.asset(
                          //     'assets/icons/google-social.svg',
                          //     width: 24,
                          //   ),
                          //   elevation: 0.0,
                          // ),
                          if (Platform.isIOS) const SizedBox(width: 35),
                          if (Platform.isIOS)
                            MaterialButton(
                              color: kPrimaryOrange,
                              minWidth: 48,
                              height: 48,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0)),
                              onPressed: () => _registerWithApple(context),
                              child: SvgPicture.asset(
                                'assets/icons/apple.svg',
                                width: 24,
                              ),
                              elevation: 0.0,
                            ),
                        ],
                      ),
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
