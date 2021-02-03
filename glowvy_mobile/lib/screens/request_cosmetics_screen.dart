import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/popups.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/product_request.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/login_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class CosmeticsRequestScreen extends StatefulWidget {
  @override
  _CosmeticsRequestScreenState createState() => _CosmeticsRequestScreenState();
}

class _CosmeticsRequestScreenState extends State<CosmeticsRequestScreen>
    with TickerProviderStateMixin {
  Size screenSize;
  UserModel userModel;
  AnimationController _requestController;
  ProductRequest _productRequest = ProductRequest();
  bool isLoading;
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestController = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);
    userModel = Provider.of<UserModel>(context, listen: false);
  }

  Future<Null> _playAnimation() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _requestController.forward();
    } on TickerCanceled {}
  }

  Future<Null> _stopAnimation() async {
    try {
      await _requestController.reverse();
      setState(() {
        isLoading = false;
      });
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    var user = FirebaseAuth.instance.currentUser;

    return Scaffold(
        backgroundColor: kSecondaryOrange,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            elevation: 0,
            title: Text(
              'Phản hồi',
              style: textTheme.headline3.copyWith(
                color: kPrimaryOrange,
              ),
            ),
            // expandedHeight: screenSize.height * 0.3,
            brightness: Brightness.light,
            leading: backIcon(context, color: kPrimaryOrange),
            backgroundColor: kSecondaryOrange),
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Container(
              width: screenSize.width,
              color: kSecondaryOrange,
              padding: EdgeInsets.only(left: 10, top: 20, right: 10),
              child: Container(
                height: 612,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                padding:
                    EdgeInsets.only(top: 40, bottom: 53, left: 16, right: 16),
                child: Column(
                  children: [
                    SvgPicture.asset('assets/icons/request_flower.svg'),
                    Container(height: 14),
                    const SizedBox(height: 12.0),
                    Text(
                      '${userModel.user.fullName} ơi \Nhập thông tin sản phẩm tại đây',
                      style: textTheme.headline1,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Nhanh thôi, bạn sẽ có thể kiểm tra thành phần và đánh giá của sản phẩm này. Glowvy sẽ gửi thông báo ngay khi sản phẩm được cập nhật',
                      style: textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    Container(
                        width: screenSize.width,
                        height: 48,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            color: kQuaternaryOrange),
                        child: // Group 6
                            Center(
                          child: TextField(
                              style: textTheme.headline5
                                  .copyWith(color: kPrimaryOrange),
                              controller: _categoryController,
                              cursorColor: theme.cursorColor,
                              onChanged: (value) =>
                                  _productRequest.categoryName = value,
                              keyboardType: TextInputType.text,
                              decoration:
                                  kTextField.copyWith(hintText: 'Danh mục')),
                        )),
                    const SizedBox(height: 12.0),
                    Container(
                        width: screenSize.width,
                        height: 48,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            color: kQuaternaryOrange),
                        child: // Group 6
                            Center(
                          child: TextField(
                              style: textTheme.headline5
                                  .copyWith(color: kPrimaryOrange),
                              controller: _brandController,
                              cursorColor: theme.cursorColor,
                              onChanged: (value) =>
                                  _productRequest.productName = value,
                              keyboardType: TextInputType.text,
                              decoration: kTextField.copyWith(
                                  hintText: 'Tên sản phẩm')),
                        )),
                    const SizedBox(height: 12.0),
                    Container(
                        width: screenSize.width,
                        height: 48,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            color: kQuaternaryOrange),
                        child: // Group 6
                            Center(
                          child: TextField(
                              style: textTheme.headline5
                                  .copyWith(color: kPrimaryOrange),
                              controller: _productNameController,
                              cursorColor: theme.cursorColor,
                              onChanged: (value) =>
                                  _productRequest.brandName = value,
                              keyboardType: TextInputType.text,
                              decoration:
                                  kTextField.copyWith(hintText: 'Tên hãng')),
                        )),
                    const SizedBox(height: 13),
                    //add the product to the firestore
                    //then the trigger function will send the slack notification

                    StaggerAnimation(
                        height: 48,
                        buttonTitle: S.of(context).send,
                        buttonController: _requestController.view,
                        onTap: () {
                          _playAnimation();

                          try {
                            Future.delayed(const Duration(milliseconds: 1000),
                                //only save the uid, full_name here?
                                () async {
                              var cosmeticsRequest = {
                                'name': _productRequest.productName,
                                'brand': _productRequest.brandName,
                                'category': _productRequest.categoryName,
                                'user': userModel.user.toJson(),
                              };
                              await FirebaseFirestore.instance
                                  .collection('product_requests')
                                  .add(cosmeticsRequest);

                              await _stopAnimation();
                              Popups.showSuccesPopup(context);
                              Navigator.pop(context);
                              var attachment = {
                                'attachments': [
                                  {
                                    'fallback':
                                        'Plain-text summary of the attachment.',
                                    'color': '#2eb886',
                                    'user_id': user.uid,
                                    'user_name': 'user.uid',
                                    'user_email': user.email,
                                    'title': 'User Feedback',
                                    'text':
                                        'cosmetics request:\nbrand: ${_productRequest.brandName}\nemail: ${_productRequest.categoryName}\nproduct name: ${_productRequest.productName}\n',
                                    'image_url':
                                        'https://d9vmi5fxk1gsw.cloudfront.net/home/glowmee/upload/20180417/1523927677516_160.png',
                                    'ts': DateTime.now().millisecondsSinceEpoch
                                  },
                                ]
                              };

                              Tools.sendSlackMessage(request: attachment);
                            });
                          } catch (err) {
                            //handle errors

                            print('error sending cosmetics request: $err');
                            rethrow;
                          }
                          //save the requested cosmetics info on the firestore
                          //se
                          // _submitRegister(fullName, email, password);
                        }),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class TextWithIcon extends StatelessWidget {
  String text;
  String iconPath;
  TextWithIcon(this.text, this.iconPath);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: Row(
        children: <Widget>[
          SvgPicture.asset(iconPath),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              text,
              style: textTheme.headline5.copyWith(
                color: kSecondaryGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileCardPainter extends CustomPainter {
  //2
  ProfileCardPainter({@required this.color});

  //3
  final Color color;

  //4
  @override
  void paint(Canvas canvas, Size size) {
    //1
    final shapeBounds = Rect.fromLTRB(0, 0, size.width, size.height);

    final curvedShapeBounds = Rect.fromLTRB(
      shapeBounds.left,
      shapeBounds.top,
      shapeBounds.right,
      shapeBounds.bottom,
    );

//2
    _drawCurvedShape(canvas, curvedShapeBounds, shapeBounds);
  }

  void _drawCurvedShape(Canvas canvas, Rect bounds, Rect avatarBounds) {
    //1
    final paint = Paint()..color = color;
    //2
    final handlePoint = Offset(bounds.left + (bounds.width * 0.75), bounds.top);

    //3
    final curvePath = Path()
      ..moveTo(bounds.topLeft.dx, bounds.topLeft.dy) //4
      ..lineTo(bounds.bottomLeft.dx, bounds.bottomLeft.dy) //6
      ..lineTo(bounds.bottomRight.dx, bounds.bottomRight.dy) //7
      ..lineTo(bounds.topRight.dx, 51) //7
      ..quadraticBezierTo(handlePoint.dx, handlePoint.dy, bounds.topLeft.dx,
          bounds.topLeft.dy) //8
      ..close(); //9

    //10
    canvas.drawPath(curvePath, paint);
  }

  //5qq
  @override
  bool shouldRepaint(ProfileCardPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
