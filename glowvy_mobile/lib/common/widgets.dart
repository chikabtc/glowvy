import 'dart:io';
import 'dart:math' as math;

import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

final SvgPicture arrowForward = SvgPicture.asset(
  'assets/icons/arrow_forward.svg',
  width: 24,
);
final SvgPicture arrowForwardPink = SvgPicture.asset(
  'assets/icons/arrow-forward-pink.svg',
  width: 24,
);

final Container arrowBackward = Container(
  width: 33,
  child: IconButton(
      icon: SvgPicture.asset(
    'assets/icons/arrow_backward.svg',
    width: 24,
  )),
);

final SvgPicture arrowBackwardWhite = SvgPicture.asset(
  'assets/icons/arrow_backward.svg',
  width: 24,
  color: Colors.white,
);

Widget kIndicator() {
  return Platform.isAndroid
      ? Container(
          width: 24,
          height: 24,
          child: const CircularProgressIndicator(
            strokeWidth: 3,
          ),
        )
      : const CupertinoActivityIndicator();
}

Widget backIcon(context, {color = kDarkAccent, Function onPop}) {
  var pop = () {
    if (onPop != null) {
      onPop();
    } else {
      Navigator.pop(context);
    }
  };
  return Navigator.of(context).canPop()
      ? Container(
          padding: const EdgeInsets.all(0.0),
          width: 24,
          child: PlatformIconButton(
              padding: EdgeInsets.zero,
              materialIcon: Icon(
                Icons.arrow_back,
                color: color,
                size: 24,
              ),
              cupertinoIcon: Icon(
                Icons.arrow_back_ios,
                color: color,
                size: 22,
              ),
              onPressed: pop),
        )
      : Container();
}

Widget arrowForwardIcon(context, {color = kDarkAccent, width = 26}) {
  return GestureDetector(
    onTap: () => Navigator.of(context).pop(),
    child: IconButton(
        icon: SvgPicture.asset(
      'assets/icons/arrow_forward.svg',
      width: width,
      color: color,
    )),
  );
}

Widget closeIcon(context, {color = Colors.black87}) {
  return GestureDetector(
    onTap: () => Navigator.of(context).pop(),
    child: Container(
      width: 33,
      child: IconButton(
          icon: SvgPicture.asset(
        'assets/icons/address/close-popup.svg',
        width: 24,
        color: color,
      )),
    ),
  );
}

Widget forwardIcon(context, color) {
  return SvgPicture.asset(
    'assets/icons/arrow_forward.svg',
    width: 24,
    color: color,
  );
}

Widget customButton(
    {@required function,
    @required text,
    buttonColor = kPrimaryOrange,
    borderColor = Colors.transparent,
    textColor = kWhite}) {
  return GestureDetector(
    onTap: function,
    child: Container(
        height: 48,
        alignment: Alignment.center,
        child: Text(text,
            textAlign: TextAlign.center,
            style: textTheme.button1.copyWith(
                color: textColor, fontSize: 15, fontWeight: FontWeight.bold)),
        decoration: BoxDecoration(
          color: buttonColor,
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(16),
        )),
  );
}

Widget customDivider({color, thickness}) {
  return Divider(
    color: color ?? kQuaternaryGrey,
    height: 0.7,
    thickness: thickness ?? 0.7,
  );
}

class CustomTextField extends StatefulWidget {
  CustomTextField(
      {@required this.onTextChange,
      @required this.hintText,
      this.keyboardType,
      this.validator,
      this.isReadOnly = false,
      this.obscureText = false,
      this.height = 48,
      this.autoFocus});
  Function onTextChange;
  String initialValue;
  bool obscureText;
  Function validator;
  bool isReadOnly;
  double height;

  String hintText;
  bool autoFocus;

  TextInputType keyboardType;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final TextEditingController _textFieldController = TextEditingController();
  String text;
  final _formKey = GlobalKey<FormState>();
  bool isNumber(String value) {
    if (value == null) {
      return true;
    }
    final n = num.tryParse(value);
    return n != null;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      height: widget.height,
      width: screenSize.width,
      color: kWhite,
      child: Form(
        child: TextFormField(
          textAlignVertical: TextAlignVertical.center,
          autofocus: widget.autoFocus ?? true,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          controller: _textFieldController,
          cursorColor: theme.cursorColor,
          obscureText: widget.obscureText,
          style: textTheme.headline5,
          onChanged: (value) {
            widget.onTextChange(value);
            setState(() {
              text = value;
            });
          },
          readOnly: widget.isReadOnly,
          decoration: kTextField.copyWith(
            contentPadding: EdgeInsets.only(
              left: 16,
            ),
            hintText: widget.hintText,
            suffixIcon: (text == null || widget.isReadOnly)
                ? IconButton(
                    icon: Icon(
                      Icons.cancel,
                      size: 0,
                    ),
                  )
                : IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: const Color(0xffC4C4C4),
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        text = null;
                        _textFieldController.clear();
                      });
                    }),
          ),
        ),
      ),
    );
  }
}

/// Solid tab bar indicator.
class SolidIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback onChanged]) {
    return SolidIndicatorPainter(this, onChanged);
  }
}

class SolidIndicatorPainter extends BoxPainter {
  final SolidIndicator decoration;

  SolidIndicatorPainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);

    final rect = offset & configuration.size;
    final paint = Paint();
    paint.color = kDarkAccent;
    paint.style = PaintingStyle.fill;

    canvas.drawRect(rect, paint);
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
