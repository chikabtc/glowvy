import 'dart:ui';

import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/setting/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class BeforeLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BeforeLoginPageState();
  }
}

class BeforeLoginPageState extends State<BeforeLoginPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  UserModel userModel;
  Size screenSize;

  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    var bottomSafeArea = 0;
    if (window.viewPadding.bottom != 0) {
      bottomSafeArea = 34;
    }

    return Container(
        color: const Color(0xffFFE0B7),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: kScreenSizeWidth,
                  height: screenSize.height - 294 - 64 - bottomSafeArea,
                  child: Image.asset(
                    'assets/icons/before_login_banner.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 84,
                      ),
                      SvgPicture.asset('assets/icons/white_star.svg'),
                      Text(
                        'About Glowvy  ——\nborn to help people find the suitable cosmetics for people’s skin type and issues.',
                        style: textTheme.headline5.copyWith(color: kWhite),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                width: kScreenSizeWidth,
                // height: 297,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 48,
                      ),
                      Text(
                        'Spend three mins \nGet know my skin better',
                        textAlign: TextAlign.center,
                        style: textTheme.headline2,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      customButton(
                        function: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupScreen())),
                        text: 'sign up',
                      ),
                      const SizedBox(
                        height: 29,
                      ),
                      SvgPicture.asset('assets/icons/pink_logo.svg'),
                      const SizedBox(
                        height: 15,
                      ),
                      Text('Making Vietnamese Skin Glow',
                          style: textTheme.bodyText2
                              .copyWith(color: kSecondaryGrey)),
                      const SizedBox(height: 15)
                    ],
                  ),
                ),
              ),
            ),
            // Container(child:
            // ,)
          ],
        ));
  }
}
