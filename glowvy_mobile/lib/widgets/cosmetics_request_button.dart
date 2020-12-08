import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/screens/request_cosmetics_screen.dart';
import 'package:Dimodo/screens/setting/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../common/constants.dart';

class CosmeticsRequestBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: screenSize.width,
      // height: screenSize.height / 3,
      child: Column(
        children: [
          Container(height: 14),
          SvgPicture.asset('assets/images/banner_request.svg'),
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        FirebaseAuth.instance.currentUser != null
                            ? CosmeticsRequestScreen()
                            : LoginScreen())),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 30),
              child: Container(
                height: 72,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: kSecondaryOrange),
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 14, bottom: 14),
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Thích/không thích ứng dụng?',
                          style: textTheme.headline3.copyWith(
                            color: kPrimaryOrange,
                          ),
                        ),
                        Text(
                          'Làm khảo sát bây giờ',
                          // textAlign: TextAlign.center,
                          style: textTheme.headline5.copyWith(
                            color: kPrimaryOrange,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SvgPicture.asset('assets/icons/arrow-more-red.svg')
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
