import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/popups.dart';
import 'package:Dimodo/common/widgets.dart';

import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/skin_type_onboarding_page.dart';
import 'package:Dimodo/widgets/login_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GenderOnboardingPage extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;

  const GenderOnboardingPage({this.user, this.onLogout});

  @override
  State<StatefulWidget> createState() {
    return GenderOnboardingPageState();
  }
}

class GenderOnboardingPageState extends State<GenderOnboardingPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  UserModel userModel;
  AnimationController _doneButtonController;
  String gender;
  List<String> genders = ['Nữ', 'Nam'];

  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);
    gender = userModel.user.gender;

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
      throw 'Please provide year.';
    } else if (value.length != 4) {
      throw 'Please input valid birthyear.';
    } else if (year > 2020 || year < 1900) {
      throw 'Please input valid birthyear.';
    }
  }

  Future _updateGender(context) async {
    try {
      // validateInput(year);
      await userModel.updateUserGender(gender);
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const SkinTypeOnboardingPage()));
      // _stopAnimation();
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
          leading: backIcon(context),
          backgroundColor: kDefaultBackground,
        ),
        backgroundColor: kDefaultBackground,
        body: Column(
          children: [
            // TODO(parker): translate
            Text('Giới tính',
                textAlign: TextAlign.center,
                style: textTheme.headline1.copyWith(
                    fontStyle: FontStyle.normal, fontWeight: FontWeight.w800)),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Text(
                  'Giới tính được sử dụng để giúp Glowvy lọc ra những sản phẩm và đánh giá phù hợp với làn da của bạn',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyText1),
            ),
            const SizedBox(
              height: 45,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: genders.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () async {
                        setState(() {
                          gender = genders[index];
                        });
                      },
                      trailing: gender == genders[index]
                          ? const Icon(
                              Icons.check,
                              color: kPrimaryOrange,
                            )
                          : const Icon(
                              Icons.check,
                              color: kPrimaryOrange,
                              size: 0,
                            ),
                      title: Text(genders[index], style: textTheme.button),
                    ),
                    if (genders.length - 1 != index) kDivider
                  ],
                );
              },
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 35.0),
                  child: Builder(
                    builder: (context) => StaggerAnimation(
                        btnColor: kPrimaryOrange,
                        buttonTitle: 'Tiếp tục',
                        buttonController: _doneButtonController.view,
                        onTap: () {
                          _updateGender(context);
                        }),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
