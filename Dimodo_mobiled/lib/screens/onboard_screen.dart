import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/material.dart';
import '../common/constants.dart';
import '../common/config.dart' as config;
import '../common/styles.dart';
import '../common/sizeConfig.dart';
import 'package:Dimodo/generated/i18n.dart';

class OnBoardScreen extends StatefulWidget {
  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  List<Widget> pages = [];
  final isRequiredLogin = config.kAdvanceConfig['IsRequiredLogin'];

  @override
  void initState() {
    Widget loginWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Image.asset(
          "assets/images/fogg-order-completed.png",
          height: 200,
          fit: BoxFit.fitWidth,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Text(
                  'Sign In',
                  style: TextStyle(color: kTeal400, fontSize: 20.0),
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
              Text(
                "    |    ",
                style: TextStyle(color: kTeal400, fontSize: 20.0),
              ),
              GestureDetector(
                child: Text(
                  'Sign Up',
                  style: TextStyle(color: kTeal400, fontSize: 20.0),
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/register');
                },
              ),
            ],
          ),
        ),
      ],
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    kSizeConfig = SizeConfig(screenSize);

    for (int i = 0; i < config.onBoardingData.length; i++) {
      var page = Container(
        color: kLightPink,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 40),
            Center(
              child: Image.asset(
                config.onBoardingData[i]['image'],
              ),
            ),
            SizedBox(height: 20),
            DynamicText(config.onBoardingData[i]['title'],
                style: kBaseTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: kDefaultFontColor,
                    decoration: TextDecoration.none,
                    fontSize: 24)),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    if (i == 2)
                      MaterialButton(
                          elevation: 0,
                          minWidth: 180,
                          color: kPinkAccent,
                          height: 48,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                          ),
                          child: Text(S.of(context).getStarted,
                              style: kBaseTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.white)),
                          onPressed: () {
                            Navigator.pushNamed(context, "/home");
                          }),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 33,
                        left: 16,
                        right: 16,
                        bottom: 40.0,
                      ),
                      child: Image.asset(
                        config.onBoardingData[i]['indicator'],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
      pages.add(page);
    }
    return Container(
      color: kLightPink,
      height: kSizeConfig.screenHeight,
      child: SafeArea(
        child: PageView.builder(
          itemBuilder: (context, i) {
            return pages[i];
          },
          itemCount: pages.length, // Can be null
        ),
      ),
    );
  }
}
