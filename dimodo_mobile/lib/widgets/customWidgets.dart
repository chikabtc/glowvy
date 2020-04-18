import 'package:flutter/material.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonIcons {
  static final SvgPicture arrowForward =
      SvgPicture.asset('assets/icons/arrow_forward.svg', width: 24);
  static final SvgPicture arrowBackward =
      SvgPicture.asset('assets/icons/arrow_backward.svg', width: 24);
  static final SvgPicture arrowBackwardWhite = SvgPicture.asset(
    'assets/icons/arrow_backward.svg',
    width: 24,
    color: Colors.white,
  );
}

class DynamicText extends StatelessWidget {
  final TextStyle style;
  final String text;
  final TextAlign textAlign;
  final int maxLines;
  DynamicText(this.text, {this.style, this.textAlign, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLines == null ? null : maxLines,
        textAlign: textAlign ?? TextAlign.justify,
        style: style.copyWith(

            // fontWeight: FontWeight.w600,
            fontSize: style.fontSize * kSizeConfig.textMultiplier));
  }
}
