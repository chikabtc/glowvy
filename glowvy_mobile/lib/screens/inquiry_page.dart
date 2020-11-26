import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/popups.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/login_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InquiryPage extends StatefulWidget {
  @override
  _InquiryPageState createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage>
    with TickerProviderStateMixin {
  Size screenSize;
  AnimationController _postButtonController;
  final TextEditingController _reviewTextController = TextEditingController();

  UserModel userModel;
  String inquiry;
  List<String> inquiryTypes = ['Idea Suggestion', 'Report Bugs'];
  String inquiryType;
  String email;
  AnimationController _doneButtonController;
  @override
  void initState() {
    super.initState();
    inquiryType = inquiryTypes.first;
    userModel = Provider.of<UserModel>(context, listen: false);
    // print('user:${userModel.user.toJson()}');

    _postButtonController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _postButtonController.dispose();
    super.dispose();
  }

  void validateInput() {
    if (inquiry == null) {
      throw 'select product';
    } else if (inquiry.length < 20) {
      throw 'content too show at least over 20 characters';
    } else if (inquiry.length > 5000) {
      throw 'content too long (up to 5000 chars';
    }
  }

  Future sendInquiry(context) async {
    try {
      await Tools.sendSlackMessage(
          'inquiry type: $inquiryType\nemail: $email\ninquiry: $inquiry');
      await _postButtonController.reverse();
      Popups.showSuccesPopup(context);
      Navigator.of(context).pop();
    } catch (e) {
      await _postButtonController.reverse();

      Popups.simpleAlert(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    // if (user)

    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: kWhite,
          leading: backIcon(context),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Builder(
                  builder: (context) => StaggerAnimation(
                    width: 57,
                    height: 34,
                    buttonTitle: 'Send',
                    buttonController: _postButtonController.view,
                    onTap: () async {
                      _postButtonController.forward();
                      await sendInquiry(context);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          top: true,
          bottom: false,
          child: Container(
              color: kWhite,
              height: screenSize.height,
              child: Consumer<UserModel>(builder: (context, userModel, child) {
                return ListView(
                  children: <Widget>[
                    Container(
                      color: kQuaternaryGrey,
                      padding: const EdgeInsets.only(
                          top: 26, left: 16, right: 16, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tell us about the issues you encountered and features you wish existed ',
                            style: textTheme.headline5.copyWith(
                                color: kDarkGrey,
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                          ),
                          Text(
                            'Glowvy is a service we make with you.',
                            style: textTheme.bodyText1.copyWith(
                              color: kSecondaryGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Text(
                            'Inquiry Types',
                            style: textTheme.headline3,
                          ),
                          const SizedBox(height: 15),
                          DropdownButton<String>(
                            value: inquiryType,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 0,
                            style: textTheme.bodyText1,
                            underline: kFullDivider,
                            onChanged: (String newValue) {
                              setState(() {
                                inquiryType = newValue;
                              });
                            },
                            items: inquiryTypes
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: textTheme.bodyText1,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Inquiry Explanation',
                            style: textTheme.headline3,
                          ),
                          const SizedBox(height: 15),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: kQuaternaryGrey, width: 1.5),
                            ),
                            padding: const EdgeInsets.all(8),
                            height: screenSize.height / 2,
                            child: TextFormField(
                              controller: _reviewTextController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              cursorColor: kPinkAccent,
                              onChanged: (value) {
                                inquiry = value;
                              },
                              style: textTheme.headline5
                                  .copyWith(color: kDefaultFontColor),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintMaxLines: 10,
                                hintText:
                                    'Share any thoughts about this product (advantage, disadvantage, result, how to use...)',
                                hintStyle: textTheme.headline5.copyWith(
                                  color: kSecondaryGrey.withOpacity(0.5),
                                ),
                                // contentPadding: const EdgeInsets.only(left: 20),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Feedback email',
                            style: textTheme.headline3,
                          ),
                          const SizedBox(height: 15),
                          Container(
                            decoration: BoxDecoration(
                              color: kSecondaryWhite,
                              border: Border.all(
                                  color: kQuaternaryGrey, width: 1.5),
                            ),
                            child: Column(
                              children: [
                                CustomTextField(
                                  autoFocus: false,
                                  onTextChange: (value) {
                                    setState(() {
                                      email = value;
                                    });
                                  },
                                  hintText: userModel.user.email,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    )
                  ],
                );
              })),
        ));
  }
}
