import 'package:Dimodo/common/styles.dart';

import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:Dimodo/common/constants.dart';
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

backIcon(context, {color = kDarkAccent}) {
  return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: SvgPicture.asset(
        'assets/icons/arrow_backward.svg',
        width: 26,
        color: color,
      ));
}

arrowForwardIcon(context, {color = kDarkAccent, width = 26}) {
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

closeIcon(context, {color = Colors.black87}) {
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

forwardIcon(context, color) {
  return SvgPicture.asset(
    'assets/icons/arrow_forward.svg',
    width: 24,
    color: color,
  );
}

class CustomTextField extends StatefulWidget {
  CustomTextField(
      {@required this.onTextChange,
      @required this.hintText,
      this.keyboardType,
      this.validator,
      this.autoFocus});
  Function onTextChange;
  Function validator;

  String hintText;
  bool autoFocus;

  var keyboardType;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  TextEditingController _textFieldController = TextEditingController();
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
          autofocus: widget.autoFocus != null ? widget.autoFocus : true,
          keyboardType: widget.keyboardType != null
              ? widget.keyboardType
              : TextInputType.text,
          controller: _textFieldController,
          cursorColor: theme.cursorColor,
          style: textTheme.headline5,
          onChanged: (value) {
            widget.onTextChange(value);
            setState(() {
              text = value;
            });
          },
          decoration: kTextField.copyWith(
            hintText: widget.hintText,
            suffixIcon: text == null
                ? IconButton(
                    icon: Icon(
                      Icons.cancel,
                      size: 0,
                    ),
                  )
                : IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Color(0xffC4C4C4),
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
