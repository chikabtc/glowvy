import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/popups.dart';

import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/gender_onboarding_page.dart';
import 'package:Dimodo/screens/region_onboarding_page.dart';
import 'package:Dimodo/widgets/login_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BirthyearOnboardingPage extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;

  const BirthyearOnboardingPage({this.user, this.onLogout});

  @override
  State<StatefulWidget> createState() {
    return BirthyearOnboardingPageState();
  }
}

class BirthyearOnboardingPageState extends State<BirthyearOnboardingPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool enabledNotification = true;
  UserModel userModel;
  String year;
  bool isLoading = false;
  AnimationController _doneButtonController;

  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);

    _doneButtonController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _doneButtonController.dispose();
    super.dispose();
  }

  Future _playAnimation() async {
    await _doneButtonController.forward();
  }

  Future _stopAnimation() async {
    await _doneButtonController.reverse();
  }

  void validateInput(String value) {
    final year = double.parse(value);
    print(year);

    // TODO(parker): translate
    if (value == null) {
      throw 'Hãy nhập năm sinh';
    } else if (value.length != 4) {
      throw 'Hãy nhập đúng năm sinh của bạn';
    } else if (year > 2020 || year < 1900) {
      throw 'Hãy nhập đúng năm sinh của bạn';
    }
  }

  Future _updateUserBirthYear(context) async {
    // await _playAnimation();

    try {
      validateInput(year);
      await userModel.updateUser(
        field: 'birth_year',
        value: double.parse(year).toInt(),
      );
      // _stopAnimation();
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const GenderOnboardingPage()));
      // Navigator.pop(context);
    } catch (e) {
      print('_updateUserName error: $e');
      // _stopAnimation();
      Popups.failMessage(e, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          leading: Container(),
          backgroundColor: kDefaultBackground,
        ),
        backgroundColor: kDefaultBackground,
        body: Container(
          height: kScreenSizeHeight,
          color: kSecondaryWhite,
          child: Column(
            children: [
              // TODO(parker): translate
              Text('Năm sinh',
                  style: textTheme.headline1.copyWith(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w800)),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Text(
                    'Năm sinh được sử dụng để giúp Glowvy lọc ra những sản phẩm và đánh giá phù hợp với độ tuổi da của bạn',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyText1),
              ),
              const SizedBox(
                height: 45,
              ),
              CustomTextField(
                onTextChange: (value) {
                  setState(() {
                    year = value;
                  });
                },
                hintText: userModel.user.birthYear != null
                    ? userModel.user.birthYear.toString()
                    : '1998',
                keyboardType: TextInputType.number,
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 35.0),
                    child: Builder(
                      builder: (context) => StaggerAnimation(
                          btnColor: kPrimaryOrange,
                          buttonTitle: 'Tiếp tục',
                          buttonController: _doneButtonController.view,
                          onTap: () {
                            _updateUserBirthYear(context);
                          }),
                    ),
                  ),
                ),
              )
              //next page button
              //button here
            ],
          ),
        ));
  }
}
