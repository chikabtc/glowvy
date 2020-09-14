import 'package:flutter/material.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:provider/provider.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/login_animation.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:Dimodo/models/order/cart.dart';

class LoginScreen extends StatefulWidget {
  final bool fromCart;

  LoginScreen({this.fromCart = false});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen>
    with TickerProviderStateMixin, AfterLayoutMixin {
  AnimationController _loginButtonController;
  String email, password;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var parentContext;
  bool isLoading = false;
  bool isAvailableApple = false;

  @override
  void initState() {
    super.initState();
    _loginButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void afterFirstLayout(BuildContext context) async {}

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
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

  void _welcomeMessage(user, context) {
    if (widget.fromCart) {
      // Navigator.of(context).pop(user);
    } else {
      final snackBar = SnackBar(
          content: Text(S.of(context).welcome + ' ${user.fullName} !',
              style: kBaseTextStyle.copyWith(color: Colors.white)));
      Scaffold.of(context).showSnackBar(snackBar);

      Navigator.of(context).pop();
    }
  }

  void _failMessage(message, context) {
    FocusScope.of(context).requestFocus(FocusNode());

    final snackBar = SnackBar(
      content: Text(
        '$message',
        style: kBaseTextStyle.copyWith(color: Colors.white),
      ),
      duration: Duration(seconds: 30),
      action: SnackBarAction(
        label: S.of(context).close,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  _loginEmail(context) async {
    if (email == null || password == null) {
      var snackBar = SnackBar(
          content: Text(S.of(context).pleaseInput,
              style: kBaseTextStyle.copyWith(color: Colors.white)));
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      _playAnimation();
      Provider.of<UserModel>(context, listen: false).login(
        email: email.trim(),
        password: password.trim(),
        success: (user) {
          _onLoginSuccess(user, context);
        },
        fail: (message) {
          _onLoginFailure(message, context);
        },
      );
    }
  }

  _loginFacebook(context) async {
    _playAnimation();
    Provider.of<UserModel>(context, listen: false).loginFB(
      success: (user) {
        _onLoginSuccess(user, context);
      },
      fail: (message) {
        _onLoginFailure(message, context);
      },
    );
  }

  _onLoginSuccess(user, context) {
    Provider.of<CartModel>(context, listen: false)
        .getAllCartItems(Provider.of<UserModel>(context, listen: false));
    _stopAnimation();
    _welcomeMessage(user, context);
  }

  _onLoginFailure(message, context) {
    _stopAnimation();
    _failMessage(message, context);
  }

  _loginGoogle(context) async {
    _playAnimation();
    Provider.of<UserModel>(context, listen: false).loginGoogle(
      success: (user) {
        _onLoginSuccess(user, context);
      },
      fail: (message) {
        _onLoginFailure(message, context);
      },
    );
  }

  _loginApple(context) async {
    _playAnimation();
    Provider.of<UserModel>(context, listen: false).loginApple(
      success: (user) {
        _onLoginSuccess(user, context);
      },
      fail: (message) {
        _onLoginFailure(message, context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle buttonTextStyle =
        Theme.of(context).textTheme.button.copyWith(fontSize: 16);
    parentContext = context;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: CommonIcons.arrowBackward,
                onPressed: () {
                  Navigator.of(context).pop();
                })
            : Container(),
        actions: <Widget>[
          FlatButton(
            child: Text(S.of(context).signup,
                style: buttonTextStyle.copyWith(fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/register");
              // Navigator.pushNamed(context, ");
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
                          SvgPicture.asset("assets/icons/star-vy-red.svg"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                S.of(parentContext).login,
                                style: kBaseTextStyle.copyWith(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 24),
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
                              color: kQuaternaryPink),
                          child: // Group 6
                              Center(
                            child: TextField(
                              controller: _emailController,
                              cursorColor: kPrimaryOrange,
                              style: kBaseTextStyle.copyWith(
                                  color: kPrimaryOrange),
                              onChanged: (value) => email = value,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: S.of(parentContext).email,
                                hintStyle: kBaseTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: kDarkSecondary.withOpacity(0.5),
                                ),
                                contentPadding: EdgeInsets.only(left: 20),
                              ),
                            ),
                          )),
                      const SizedBox(height: 12.0),
                      Container(
                          width: screenSize.width,
                          height: 48,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              color: kQuaternaryPink),
                          child: // Group 6
                              Center(
                            child: TextField(
                                cursorColor: kPinkAccent,
                                style: kBaseTextStyle.copyWith(
                                    color: kPrimaryOrange),
                                onChanged: (value) => password = value,
                                obscureText: true,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: S.of(parentContext).password,
                                  hintStyle: kBaseTextStyle.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: kDarkSecondary.withOpacity(0.5),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 20),
                                )),
                          )),
                      SizedBox(
                        height: 16.0,
                      ),
                      StaggerAnimation(
                        btnColor: kPrimaryOrange,
                        buttonTitle: S.of(context).signInWithEmail,
                        buttonController: _loginButtonController.view,
                        onTap: () {
                          if (!isLoading) {
                            _loginEmail(context);
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      MaterialButton(
                          elevation: 0,
                          minWidth: 48,
                          height: 48,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              side: BorderSide(color: kPinkAccent, width: 1.5)),
                          child: Text(S.of(context).forgotpassword,
                              style: kBaseTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: kPinkAccent)),
                          onPressed: () {
                            if (!isLoading) {
                              Navigator.of(context)
                                  .pushReplacementNamed('/forgot_password');
                            }
                          }),
                      SizedBox(
                        height: 24.0,
                      ),
                      Text(S.of(context).loginWithSNS,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade400)),
                      SizedBox(
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
                                borderRadius: new BorderRadius.circular(16.0)),
                            onPressed: () => _loginFacebook(context),
                            child: SvgPicture.asset(
                              'assets/icons/facebook-social.svg',
                              width: 24,
                            ),
                            elevation: 0.0,
                          ),
                          SizedBox(width: 35),
                          MaterialButton(
                            color: kPrimaryOrange,
                            minWidth: 48,
                            height: 48,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(16.0)),
                            onPressed: () => _loginGoogle(context),
                            child: SvgPicture.asset(
                              'assets/icons/google-social.svg',
                              width: 24,
                            ),
                            elevation: 0.0,
                          ),
                          SizedBox(width: 35),
                          MaterialButton(
                            color: kPrimaryOrange,
                            minWidth: 48,
                            height: 48,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(16.0)),
                            onPressed: () => _loginApple(context),
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

  void showLoading() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
              child: new Container(
            padding: new EdgeInsets.all(50.0),
            child: kLoadingWidget(context),
          ));
        });
  }

  void hideLoading() {
    Navigator.of(context).pop();
  }
}

class PrimaryColorOverride extends StatelessWidget {
  const PrimaryColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(primaryColor: color),
    );
  }
}
