import 'dart:io';
import 'dart:math';

import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/popups.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/login_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

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
  List<PickedFile> pickedFiles = [];
  final picker = ImagePicker();
  PickedFile pickedFile;
  AnimationController _doneButtonController;
  ScreenshotController screenshotController = ScreenshotController();

  // int _counter = 0;
  // File _imageFile;

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
      validateInput();
      //1. save the screenshots on the cloud storage
      //2. random value to the url
      var imageUrls = [];
      for (final file in pickedFiles) {
        // print(file.path);
        final fileName = '${new Random().nextInt(10000)}.jpg';
        final filePath =
            'http://storage.googleapis.com/glowvy-b6cf4.appspot.com/feedbacks/screenshots/$fileName';

        imageUrls.add(filePath);
        await userModel.uploadScreenshot(File(file.path), path: fileName);
      }

      var imageJsons = [];
      if (imageUrls.isNotEmpty) {
        for (final url in imageUrls) {
          imageJsons.add(
            {
              'fallback': 'User Feedback',
              'color': '#2eb886',
              'image_url': url,
            },
          );
          print(url);
        }
      }
      var userInfo = 'anonymous';
      if (userModel.user.uid == null) {
        userInfo = '${userModel.user.fullName} uid: ${userModel.user.uid}';
      }

      //2. generate URL
      //3. attach the images in the slack messages
      //4. send slack message
      final attachment = {
        'attachments': [
          {
            'fallback': 'User Feedback',
            'pretext': '$userInfo left us feedback🙏',
            'color': '#2eb886',
            'uid': userModel.user != null ? userModel.user.uid : null,
            'title': 'User Feedback',
            'text': inquiry,
            'ts': DateTime.now().millisecondsSinceEpoch
          },
          for (final json in imageJsons) json
        ]
      };
      print(attachment);

      Tools.sendSlackMessage(request: attachment);
      _postButtonController.reverse();
      Popups.showSuccesPopup(context);
      Navigator.of(context).pop();
    } catch (e) {
      await _postButtonController.reverse();

      Popups.simpleAlert(context, e.toString());
    }
  }

  Future uploadImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      // this.pickedFile = pickedFile;
      if (pickedFile != null) {
        setState(() {
          pickedFiles.add(pickedFile);

          // isLoading = true;
        });
      }
    } catch (e) {
      print(e);
    }

    // if (pickedFile != null) {
    //   await userModel.uploadProfilePicture(File(pickedFile.path));
    // } else {
    //   print('No image selected.');
    // }
    setState(() {
      // isLoading = false;
    });
  }

  getImages() {
    var imageWidgets = <Widget>[];
    pickedFiles.forEach((element) {
      Widget imageWidget = Container(
        color: Colors.yellow,
        child: Stack(
          overflow: Overflow.clip,
          children: [
            Image.file(
              File(element.path),
              width: screenSize.width / 5,
              // height: 300,
              // fit: BoxFit.cover,
            ),
            Positioned(
                top: 0.5,
                right: 5,
                child: GestureDetector(
                  onTap: () {
                    pickedFiles.remove(element);

                    setState(() {});
                  },
                  child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(28),
                              bottomLeft: Radius.circular(28))),
                      width: 20,
                      height: 20,
                      padding: const EdgeInsets.all(3),
                      child: Icon(
                        Icons.close,
                        color: kPureWhite.withOpacity(0.7),
                      )),
                )),
          ],
        ),
      );
      imageWidgets.add(imageWidget);
    });
    return Row(children: imageWidgets);
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
          title: Text('Gửi phản hồi', style: textTheme.headline3),
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
                  // physics: const ClampingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  children: <Widget>[
                    // Container(
                    //   color: kQuaternaryGrey,
                    //   padding: const EdgeInsets.only(
                    //       top: 26, left: 16, right: 16, bottom: 16),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         'Hãy nói cho chúng tôi biết những vấn đề mà bạn gặp phải cũng như tính năng mà bạn muốn có trên Glowvy!',
                    //         style: textTheme.headline5.copyWith(
                    //             color: kDarkGrey,
                    //             fontWeight: FontWeight.w700,
                    //             fontSize: 18),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Text(
                      'Bạn mong muốn Glowvy cải thiện điều gì?',
                      style: textTheme.bodyText1.copyWith(),
                    ),
                    const SizedBox(height: 18),
                    if (pickedFiles.isNotEmpty) getImages(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: (screenSize.width - 58) / 2,
                          child: MaterialButton(
                              elevation: 0,
                              minWidth: 48,
                              height: 36,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  side: const BorderSide(
                                      color: kPrimaryOrange, width: 1.5)),
                              child: Text('Thư viện ảnh',
                                  style: textTheme.button
                                      .copyWith(color: kPrimaryOrange)),
                              onPressed: () async {
                                await uploadImage();
                                // if (!isLoading) {
                                //   Navigator.of(context)
                                //       .pushReplacementNamed('/forgot_password');
                                // }
                              }),
                        ),
                        const SizedBox(width: 10),
                        // Container(
                        //   width: (screenSize.width - 58) / 2,
                        //   child: MaterialButton(
                        //       elevation: 0,
                        //       minWidth: 48,
                        //       height: 36,
                        //       shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(25.0),
                        //           side: const BorderSide(
                        //               color: kPrimaryOrange, width: 1.5)),
                        //       child: Text('gallery',
                        //           style: textTheme.button
                        //               .copyWith(color: kPinkAccent)),
                        //       onPressed: () {
                        //         // if (!isLoading) {
                        //         //   Navigator.of(context)
                        //         //       .pushReplacementNamed('/forgot_password');
                        //         // }
                        //       }),
                        // ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _reviewTextController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          cursorColor: kPrimaryOrange,
                          onChanged: (value) {
                            inquiry = value;
                          },
                          style: textTheme.headline5
                              .copyWith(color: kDefaultFontColor),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintMaxLines: 10,
                            hintText:
                                'Hãy cho chúng tôi biết bất kỳ ý kiến nào từ bạn',
                            hintStyle: textTheme.headline5.copyWith(
                              color: kSecondaryGrey.withOpacity(0.5),
                            ),
                            // contentPadding: const EdgeInsets.only(left: 20),
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    )
                  ],
                );
              })),
        ));
  }
}
