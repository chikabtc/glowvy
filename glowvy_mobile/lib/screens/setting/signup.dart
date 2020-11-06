import 'package:Dimodo/common/popups.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/models/user/userModel.dart';

import 'package:Dimodo/common/constants.dart';

import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/common/styles.dart';

import 'package:Dimodo/common/colors.dart';

import 'package:Dimodo/widgets/login_animation.dart';

import 'package:flutter/services.dart';

class SignupScreen extends StatefulWidget {
  final bool fromCart;
  SignupScreen({this.fromCart = false});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin {
  AnimationController _loginButtonController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String fullName, email, password;
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;
  bool isChecked = false;
  var parentContext;

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

  void onSignupSuccess(User user) async {
    await _loginButtonController.reverse();
    Navigator.of(context).pushReplacementNamed('/verify_email',
        arguments: {'fullName': fullName});
  }

  _registerWithEmail(fullName, email, password, context) async {
    try {
      _loginButtonController.forward();
      if (!email.contains("@")) {
        throw ('Please input valid email format');
      } else if (fullName == null || email == null || password == null) {
        throw ('Please input fill in all fields');
      } else {
        var user =
            await Provider.of<UserModel>(context, listen: false).createUser(
          fullName: fullName,
          password: password,
          email: email,
        );
        onSignupSuccess(user);
      }
    } catch (e) {
      _onSignupFailure(e, context);
    }
  }
  //

  _onSignupFailure(message, context) async {
    await _loginButtonController.reverse();
    Popups.failMessage(message, context);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle buttonTextStyle =
        Theme.of(context).textTheme.button.copyWith(fontSize: 16);
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
                style: buttonTextStyle.copyWith(fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/login");
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
                      const SizedBox(height: 0.0),
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(S.of(parentContext).signup,
                                  style: textTheme.headline2)
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 23.0),
                      Container(
                          width: screenSize.width,
                          height: 48,
                          decoration: BoxDecoration(
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
                                contentPadding: EdgeInsets.only(left: 20),
                              ),
                            ),
                          )),
                      SizedBox(height: 12.0),
                      Container(
                          width: screenSize.width,
                          height: 48,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              color: kQuaternaryOrange),
                          child: // Group 6
                              Center(
                            child: TextField(
                                style: textTheme.headline5
                                    .copyWith(color: kPrimaryOrange),
                                controller: _emailController,
                                cursorColor: kPinkAccent,
                                onChanged: (value) => email = value,
                                keyboardType: TextInputType.emailAddress,
                                decoration: kTextField.copyWith(
                                  hintText: S.of(parentContext).enterYourEmail,
                                )),
                          )),
                      SizedBox(height: 12.0),
                      Container(
                          width: screenSize.width,
                          height: 48,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              color: kQuaternaryOrange),
                          child: // Group 6
                              Center(
                            child: TextField(
                                style: textTheme.headline5
                                    .copyWith(color: kPrimaryOrange),
                                cursorColor: kPinkAccent,
                                onChanged: (value) => password = value,
                                obscureText: true,
                                decoration: kTextField.copyWith(
                                  hintText: S.of(parentContext).password,
                                )),
                          )),
                      SizedBox(
                        height: 16.0,
                      ),
                      SizedBox(height: 10),
                      Builder(
                        builder: (context) => StaggerAnimation(
                            btnColor: kPrimaryOrange,
                            buttonTitle: S.of(context).signup,
                            buttonController: _loginButtonController.view,
                            onTap: () {
                              _registerWithEmail(
                                  fullName, email, password, context);
                            }),
                      ),
                      SizedBox(
                        height: 24.0,
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
