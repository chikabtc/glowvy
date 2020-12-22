import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/popups.dart';

import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/address/addressModel.dart';
import 'package:Dimodo/models/address/province.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/gender_onboarding_page.dart';
import 'package:Dimodo/widgets/login_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegionOnboardingPage extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;

  const RegionOnboardingPage({this.user, this.onLogout});

  @override
  State<StatefulWidget> createState() {
    return RegionOnboardingPageState();
  }
}

class RegionOnboardingPageState extends State<RegionOnboardingPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  UserModel userModel;
  AddressModel addressModel;
  Province province;
  AnimationController _doneButtonController;

  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);
    addressModel = Provider.of<AddressModel>(context, listen: false);
    _doneButtonController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
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

  Future _updateRegion(context) async {
    try {
      // void validateInput(name);
      await userModel.updateUser(
          field: 'address.province', value: province.toJson());
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const GenderOnboardingPage()));
    } catch (e) {
      print('_updateUserName error: $e');
      Popups.failMessage(e, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 35.0),
        child: Builder(
          builder: (context) => StaggerAnimation(
              btnColor: kPrimaryOrange,
              buttonTitle: 'continue',
              buttonController: _doneButtonController.view,
              onTap: () {
                _updateRegion(context);

                // _updateUserBirthYear(context);
              }),
        ),
      ),
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        leading: backIcon(context),
        backgroundColor: kDefaultBackground,
      ),
      backgroundColor: kDefaultBackground,
      body: Column(
        children: [
          Text('Where are you from?', style: textTheme.headline2),
          const SizedBox(
            height: 30,
          ),
          Container(
            height: kScreenSizeHeight - 243,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: addressModel.provinces.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () async {
                        setState(() {
                          province = addressModel.provinces[index];
                        });
                      },
                      trailing: province?.id == addressModel.provinces[index].id
                          ? const Icon(
                              Icons.check,
                              color: kPrimaryOrange,
                            )
                          : const Icon(
                              Icons.check,
                              color: kPrimaryOrange,
                              size: 0,
                            ),
                      title: Text(addressModel.provinces[index].name,
                          style: textTheme.button),
                    ),
                    kDivider,
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
