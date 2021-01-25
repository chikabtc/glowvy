import 'dart:ui';

import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/setting/login.dart';
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
                    kScreenSizeHeight > 667
                        ? 'assets/images/before_login_bg.png'
                        : 'assets/images/before_login_banner_small.png',
                    fit: BoxFit.fill,
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 16.0, right: 16),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       const SizedBox(
                //         height: 84,
                //       ),
                //       SvgPicture.asset('assets/icons/white_star.svg'),
                //       Text(
                //         'Về Glowvy  ——\Ra đời để trở thành người bạn đáng tin cậy cùng mọi người tìm ra sản phẩm chăm sóc da phù hợp nhất cho mỗi loại da đặc thù.',
                //         style: textTheme.headline5.copyWith(color: kWhite),
                //       ),
                //     ],
                //   ),
                // )
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
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 48,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset('assets/icons/logo_smile.svg'),
                        ],
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Text(
                          'Ra đời để trở thành người bạn đáng tin cậy cùng mọi người tìm ra sản phẩm chăm sóc da phù hợp nhất cho mỗi loại da đặc thù',
                          style: textTheme.bodyText1.copyWith(height: 1.5)),
                      // Text(
                      //   'Bắt đầu quá trình tìm hiểu làn da thực sự của mình',
                      //   textAlign: TextAlign.center,
                      //   style: textTheme.headline2,
                      // ),
                      const SizedBox(
                        height: 28,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen())),
                            child: Container(
                                height: 48,
                                width: kScreenSizeWidth / 2 - 37,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text('Đăng" ký',
                                    textAlign: TextAlign.center,
                                    style: textTheme.button.copyWith(
                                        color: kPrimaryOrange,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                decoration: BoxDecoration(
                                  color: kWhite,
                                  border: Border.all(
                                      color: kPrimaryOrange, width: 1.5),
                                  borderRadius: BorderRadius.circular(16),
                                )),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignupScreen())),
                            child: Container(
                                height: 48,
                                width: kScreenSizeWidth / 2 - 37,
                                alignment: Alignment.center,
                                child: Text('Đăng" ký',
                                    textAlign: TextAlign.center,
                                    style: textTheme.button.copyWith(
                                        color: kWhite,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                decoration: BoxDecoration(
                                  color: kPrimaryOrange,
                                  border: Border.all(
                                      color: kPrimaryOrange, width: 1),
                                  borderRadius: BorderRadius.circular(16),
                                )),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 29,
                      ),
                      // SvgPicture.asset('assets/icons/pink_logo.svg'),

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
