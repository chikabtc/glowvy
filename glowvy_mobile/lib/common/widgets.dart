import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:flutter/material.dart';
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

Widget backIcon(context, {color = kDarkAccent}) {
  return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: SvgPicture.asset(
        'assets/icons/arrow_backward.svg',
        width: 26,
        color: color,
      ));
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
          border: Border.all(color: buttonColor, width: 1),
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
      this.autoFocus});
  Function onTextChange;
  bool obscureText;
  Function validator;
  bool isReadOnly;

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
      height: 52,
      width: screenSize.width,
      color: kWhite,
      child: Form(
        child: TextFormField(
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
            contentPadding: EdgeInsets.only(left: 16, top: 16),
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
