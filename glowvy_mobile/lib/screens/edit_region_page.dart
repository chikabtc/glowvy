import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/popups.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/address/addressModel.dart';
import 'package:Dimodo/models/address/province.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/login_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditRegionPage extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;

  EditRegionPage({this.user, this.onLogout});

  @override
  State<StatefulWidget> createState() {
    return EditRegionPageState();
  }
}

class EditRegionPageState extends State<EditRegionPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  UserModel userModel;
  AnimationController _doneButtonController;
  AddressModel addressModel;
  Province province;

  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);
    addressModel = Provider.of<AddressModel>(context, listen: false);
    _doneButtonController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    province = userModel.user.address.province;
  }

  @override
  void dispose() {
    _doneButtonController.dispose();
    super.dispose();
  }

  void validateInput(String value) {
    print(value);
    if (value == null) {
      throw 'Please provide year.';
    } else if (value.length < 3) {
      throw 'Please input valid name.';
    }
  }

  Future _updateRegion(context) async {
    try {
      // void validateInput(name);
      await userModel.updateUser(
          field: 'address.province', value: province.toJson());
      await _doneButtonController.reverse();
      Navigator.pop(context);
    } catch (e) {
      print('_updateUserName error: $e');
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
              padding: EdgeInsets.only(right: 16.0),
              child: Center(
                child: Builder(
                  builder: (context) => StaggerAnimation(
                    btnColor: kPrimaryOrange,
                    width: 57,
                    height: 34,
                    buttonTitle: 'Done',
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
          // TODO(parker): translate
          title: Text('region', style: textTheme.headline3)),
      backgroundColor: kDefaultBackground,
      body: Container(
        color: kWhite,
        child: ListView.builder(
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
                  title: Text(
                    addressModel.provinces[index].name,
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
