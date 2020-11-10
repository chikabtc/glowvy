import 'package:Dimodo/common/popups.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/models/address/addressModel.dart';
import 'package:Dimodo/models/address/province.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/login_animation.dart';

import 'package:Dimodo/widgets/setting_card.dart';

import 'package:flutter/material.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:notification_permissions/notification_permissions.dart';

import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/user/user.dart';

import 'package:provider/provider.dart';

class EditGenderPage extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;

  EditGenderPage({this.user, this.onLogout});

  @override
  State<StatefulWidget> createState() {
    return EditGenderPageState();
  }
}

class EditGenderPageState extends State<EditGenderPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  UserModel userModel;
  AnimationController _doneButtonController;
  String gender;
  List<String> genders = ["female", "male"];

  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);
    _doneButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _doneButtonController.dispose();
    super.dispose();
  }

  validateInput(String value) {
    print(value);
    if (value == null) {
      throw ('Please provide year.');
    } else if (value.length < 3) {
      throw ('Please input valid name.');
    }
  }

  _updateRegion(context) async {
    try {
      // validateInput(name);
      await userModel.updateUser(field: 'gender', value: gender);
      await _doneButtonController.reverse();
      Navigator.pop(context);
    } catch (e) {
      print("_updateUserName error: $e");
      await _doneButtonController.reverse();
      Popups.failMessage(e, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Builder(
                  builder: (context) => StaggerAnimation(
                    btnColor: kPrimaryOrange,
                    width: 57,
                    height: 34,
                    buttonTitle: "Done",
                    buttonController: _doneButtonController.view,
                    onTap: () async {
                      _doneButtonController.forward();
                      await _updateRegion(context);
                    },
                  ),
                ),
              ),
            ),
          ],
          leading: backIcon(context),
          backgroundColor: Colors.white,
          title: Text(S.of(context).name, style: textTheme.headline3)),
      backgroundColor: kDefaultBackground,
      body: Container(
        color: kWhite,
        child: ListView.builder(
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
                      ? Icon(
                          Icons.check,
                          color: kPrimaryOrange,
                        )
                      : Icon(
                          Icons.check,
                          color: kPrimaryOrange,
                          size: 0,
                        ),
                  title: Text(
                    '${genders[index]}',
                    style: kBaseTextStyle.copyWith(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                kDivider
              ],
            );
          },
        ),
      ),
    );
  }
}
