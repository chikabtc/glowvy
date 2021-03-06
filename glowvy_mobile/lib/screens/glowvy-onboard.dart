import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../common/colors.dart';
import '../common/config.dart' as config;
import '../common/constants.dart';
import '../common/sizeConfig.dart';

class GlowvyOnBoardScreen extends StatefulWidget {
  @override
  _GlowvyOnBoardScreenState createState() => _GlowvyOnBoardScreenState();
}

class _GlowvyOnBoardScreenState extends State<GlowvyOnBoardScreen> {
  List<Widget> pages = [];
  final isRequiredLogin = config.kAdvanceConfig['IsRequiredLogin'];
  final PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    kSizeConfig = SizeConfig(screenSize);
    return Scaffold(
      body: Container(
          width: screenSize.width,
          height: screenSize.height,
          color: Colors.white,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset('assets/icons/onborading-illustration-1.svg'),
                const SizedBox(height: 50),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 39.0),
                    child: Text('Tỏa sáng làn da', style: textTheme.headline1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text('Đề xuất cho bạn những mỹ phẩm phù hợp',
                      style: textTheme.headline5.copyWith(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/home'),
                  child: Container(
                      height: 34,
                      width: 150,
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(17)),
                        border: Border.all(color: kPrimaryOrange),
                      ),
                      alignment: Alignment.center,
                      child: Text('Khám phá thêm',
                          style: textTheme.headline5.copyWith(
                            color: kPrimaryOrange,
                          ))),
                ),
                // MaterialButton(
                //   color: Colors.white,
                //   disabledElevation: 0.0,
                //   elevation: 0.0,
                //   splashColor: Colors.transparent,
                //   highlightColor: Colors.transparent,
                //   enableFeedback: false,
                //   minWidth: screenSize.width / 2 - 24,
                //   height: 34,
                //   shape: RoundedRectangleBorder(
                //       side: BorderSide(
                //           color: kPrimaryOrange,
                //           width: 1,
                //           style: BorderStyle.solid),
                //       borderRadius: BorderRadius.circular(17)),
                //   onPressed: () => Navigator.pushNamed(context, '/home'),
                //   child: Text('Explore Now',
                //       style: kBaseTextStyle.copyWith(
                //           fontSize: 15,
                //           color: kPrimaryOrange,
                //           fontStyle: FontStyle.italic,
                //           fontWeight: FontWeight.w600)),
                // ),
              ])),
    );
  }
}

//
