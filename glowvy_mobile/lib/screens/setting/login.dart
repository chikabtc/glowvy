import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/popups.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/login_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final bool fromCart;

  LoginScreen({this.fromCart = false});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> with TickerProviderStateMixin {
  AnimationController _loginButtonController;
  String email, password;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  BuildContext parentContext;
  bool isLoading = false;
  bool isAvailableApple = false;

  @override
  void initState() {
    super.initState();
    _loginButtonController = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  void _welcomeMessage(user, context) {
    if (widget.fromCart) {
      // Navigator.of(context).pop(user);
    } else {
      final snackBar = SnackBar(
          content: Text(S.of(context).welcome + ' ${user.fullName} !',
              style: textTheme.headline5.copyWith(color: Colors.white)));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future _loginEmail(context) async {
    try {
      _loginButtonController.forward();

      if (email == null || password == null) {
        throw S.of(context).pleaseInput;
      } else {
        var user =
            await Provider.of<UserModel>(context, listen: false).loginWithEmail(
          email: email.trim(),
          password: password.trim(),
        );
        _onLoginSuccess(user, context);
      }
    } catch (e) {
      _onLoginFailure(e, context);
    }
  }

  Future _onLoginSuccess(user, context) async {
    await _loginButtonController.reverse();
    _welcomeMessage(user, context);
    Navigator.pop(context);
  }

  Future _onLoginFailure(message, context) async {
    await _loginButtonController.reverse();
    Popups.failMessage(message, context);
  }

  @override
  Widget build(BuildContext context) {
    var buttonTextStyle =
        Theme.of(context).textTheme.button.copyWith(fontSize: 16);
    parentContext = context;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        leading:
            Navigator.of(context).canPop() ? backIcon(context) : Container(),
        actions: <Widget>[
          FlatButton(
            child: Text(S.of(context).signup,
                style: buttonTextStyle.copyWith(fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/signup');
              // Navigator.pushNamed(context, ');
            },
          )
        ],
        backgroundColor: Colors.white,
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
                          SvgPicture.asset('assets/icons/star-vy-red.svg'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                S.of(parentContext).login,
                                style: textTheme.headline1,
                              )
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
                                controller: _emailController,
                                cursorColor: theme.cursorColor,
                                style: textTheme.headline5
                                    .copyWith(color: kPrimaryOrange),
                                onChanged: (value) => email = value,
                                decoration: kTextField.copyWith(
                                  hintText: S.of(parentContext).email,
                                )),
                          )),
                      const SizedBox(height: 12.0),
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
                                cursorColor: theme.cursorColor,
                                style: textTheme.headline5
                                    .copyWith(color: kPrimaryOrange),
                                onChanged: (value) => password = value,
                                obscureText: true,
                                controller: _passwordController,
                                decoration: kTextField.copyWith(
                                  hintText: S.of(parentContext).password,
                                )),
                          )),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Builder(
                        builder: (context) => StaggerAnimation(
                          btnColor: kPrimaryOrange,
                          buttonTitle: S.of(context).signInWithEmail,
                          buttonController: _loginButtonController.view,
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            _loginEmail(context);
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      MaterialButton(
                          elevation: 0,
                          minWidth: 48,
                          height: 48,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: BorderSide(color: kPinkAccent, width: 1.5)),
                          child: Text(S.of(context).forgotpassword,
                              style: textTheme.button2
                                  .copyWith(color: kPinkAccent)),
                          onPressed: () {
                            if (!isLoading) {
                              Navigator.of(context)
                                  .pushReplacementNamed('/verify_email');
                            }
                          }),
                      const SizedBox(
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
