import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/inquiry_page.dart';
import 'package:Dimodo/widgets/webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class FeedbackCenter extends StatefulWidget {
  @override
  _FeedbackCenterState createState() => _FeedbackCenterState();
}

class _FeedbackCenterState extends State<FeedbackCenter> {
  Size screenSize;
  UserModel userModel;
  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            elevation: 0,
            title: Text(
              'Phản hồi',
              style: textTheme.headline3.copyWith(
                color: kPrimaryBlue,
              ),
            ),
            // expandedHeight: screenSize.height * 0.3,
            brightness: Brightness.light,
            leading: backIcon(context, color: kPrimaryBlue),
            backgroundColor: kQuaternaryBlue),
        body: SafeArea(
          bottom: false,
          child: Container(
            width: screenSize.width,
            color: kQuaternaryBlue,
            child: Scrollbar(
              thickness: kScrollbarThickness,
              child: ListView(
                padding: const EdgeInsets.only(bottom: 30),
                children: <Widget>[
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Container(
                        height: 160,
                        color: kQuaternaryBlue,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebView(
                                    url:
                                        'https://parker893633.typeform.com/to/RgVtWWyZ',
                                    title: 'Glowvy Survey ⭐️'))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 20.0, right: 20, bottom: 30),
                          child: Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: kSecondaryBlue),
                            padding: const EdgeInsets.only(
                                left: 16, right: 30, top: 14, bottom: 14),
                            child: Row(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Thích/không thích ứng dụng?',
                                      style: textTheme.headline3.copyWith(
                                        color: kPrimaryBlue,
                                      ),
                                    ),
                                    Text(
                                      'Làm khảo sát bây giờ',
                                      // textAlign: TextAlign.center,
                                      style: textTheme.headline5.copyWith(
                                        color: kPrimaryBlue,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                SvgPicture.asset('assets/icons/arrow-more.svg')
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 0,
                          child: SvgPicture.asset(
                              'assets/icons/blue-big-logo.svg')),
                      Positioned(
                          top: 0,
                          left: screenSize.width / 2 + 58,
                          child: SvgPicture.asset(
                              'assets/icons/light-blue-star.svg'))
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/icons/nolt-illustration.svg',
                        width: screenSize.width,
                      ),
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(height: 15),
                              Text('Để giúp Glowvy phát triển hơn, bạn có thể:',
                                  style: textTheme.headline3
                                      .copyWith(color: kSecondaryGrey)),
                              TextWithIcon(
                                  'Đề xuất tính năng bạn muốn thêm vào trong ứng dụng',
                                  'assets/icons/blue-smiley-face.svg'),
                              TextWithIcon(
                                  'Chia sẻ câu chuyện của bạn về trải nghiệm tốt/không tốt khi mua mỹ phẩm',
                                  'assets/icons/blue-smiley-face.svg'),
                              TextWithIcon(
                                  'Bình chọn cho bất cứ tính năng nào bạn yêu thích',
                                  'assets/icons/blue-smiley-face.svg'),
                              TextWithIcon(
                                  'Theo dõi quá trình phát triển của Glowvy',
                                  'assets/icons/blue-smiley-face.svg'),
                              const SizedBox(height: 36),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebView(
                                              url:
                                                  'https://glowvy.nolt.io/newest',
                                            ))),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                      color: kPrimaryBlue),
                                  width: screenSize.width,
                                  height: 48,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Phát triển Glowvy',
                                    style: textTheme.headline5.copyWith(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 54),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 24),
                            SvgPicture.asset(
                              'assets/icons/email-illustration.svg',
                              width: screenSize.width,
                            ),
                            Container(
                              color: kQuaternaryBlue,
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 48, right: 48),
                                    child: Text(
                                      'Có vấn đề với ứng dụng? Hãy gửi mail cho nhà phát triển! Glowvy team sẽ phản hồi nhanh nhất có thể.',
                                      textAlign: TextAlign.center,
                                      style: textTheme.headline4.copyWith(
                                          color: kSecondaryGrey,
                                          fontSize: 16,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const SizedBox(height: 22),
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                InquiryPage())),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 48, right: 48),
                                      child: Container(
                                          height: 48,
                                          alignment: Alignment.center,
                                          child: Text(
                                              'Liên hệ nhà phát triển Glowvy',
                                              textAlign: TextAlign.center,
                                              style: textTheme.button1.copyWith(
                                                  color: kPrimaryBlue,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: kSecondaryBlue,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class TextWithIcon extends StatelessWidget {
  TextWithIcon(this.text, this.iconPath);

  String text;
  String iconPath;

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
