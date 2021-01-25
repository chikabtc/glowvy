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
  //ideas suggestion, report bugs
  List<String> inquiryTypes = ['Đề xuất ý tưởng', 'Báo cáo lỗi'];
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
      throw 'Sản phẩm chưa được chọn';
    } else if (inquiry.length < 20) {
      // content too short. type at least over 20 characters
      throw 'Nội dung quá ngắn. Hãy nhập ít nhất 20 ký tự';
    } else if (inquiry.length > 5000) {
      // content too long (up to 5000 chars)
      throw 'Nội dung quá dài (tối đa 5000 ký tự)';
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
                    buttonTitle: 'Gửi',
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
                            'Hãy nói cho chúng tôi biết những vấn đề mà bạn gặp phải cũng như tính năng mà bạn muốn có trên Glowvy!',
                            style: textTheme.headline5.copyWith(
                                color: kDarkGrey,
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                          ),
                          Text(
                            'Glowvy là sản phẩm chung mà chúng ta cùng nhau tạo nên!',
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
                            'Yêu cầu',
                            style: textTheme.headline3,
                          ),
                          const SizedBox(height: 15),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.7, color: kQuaternaryGrey)),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButton<String>(
                              value: inquiryType,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 0,
                              style: textTheme.bodyText1,
                              underline: SizedBox(),
                              onChanged: (String newValue) {
                                setState(() {
                                  inquiryType = newValue;
                                });
                              },
                              items: inquiryTypes.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: textTheme.bodyText1,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Giải thích thêm',
                            style: textTheme.headline3,
                          ),
                          const SizedBox(height: 15),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: kQuaternaryGrey, width: 1.5),
                            ),
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 8),
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
                            'Email của bạn',
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
                                  height: 48,
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
