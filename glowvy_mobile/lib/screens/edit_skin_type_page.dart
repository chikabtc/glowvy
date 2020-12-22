import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/app.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/login_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditSkinTypePage extends StatefulWidget {
  const EditSkinTypePage();

  @override
  State<StatefulWidget> createState() {
    return EditSkinTypePageState();
  }
}

class EditSkinTypePageState extends State<EditSkinTypePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  UserModel userModel;
  AnimationController _doneButtonController;
  List<String> skinTypes = ['Da dầu', 'Da khô', 'Da hỗn hợp', 'Da thường'];
  String skinType;

  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);

    _doneButtonController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    skinType = userModel.user.skinType;
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

  Future _updateSkinType(context) async {
    // try {
    //   // void validateInput(name);
    //   await userModel.updateUser(
    //       field: 'skin_type', value:
    //   await _doneButtonController.reverse();
    //   Navigator.pop(context);
    // } catch (e) {
    //   print('_updateUserName error: $e');
    //   await _doneButtonController.reverse();
    //   Popups.failMessage(e, context);
    // }
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
                    buttonTitle: 'Done',
                    buttonController: _doneButtonController.view,
                    onTap: () async {
                      _doneButtonController.forward();
                      await _updateSkinType(context);
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
          itemCount: skinTypes.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  onTap: () async {
                    setState(() {
                      skinType = skinTypes[index];
                    });
                  },
                  trailing: skinType == skinTypes[index]
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
                    skinTypes[index],
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
