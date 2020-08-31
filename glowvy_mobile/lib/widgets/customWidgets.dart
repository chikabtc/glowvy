import 'package:Dimodo/common/styles.dart';
import 'package:flutter/material.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonIcons {
  static final SvgPicture arrowForward = SvgPicture.asset(
    'assets/icons/arrow_forward.svg',
    width: 24,
  );
  static final SvgPicture arrowForwardPink = SvgPicture.asset(
    'assets/icons/arrow-forward-pink.svg',
    width: 24,
  );

  static final SvgPicture arrowBackward =
      SvgPicture.asset('assets/icons/arrow_backward.svg', width: 24);
  static final SvgPicture arrowBackwardWhite = SvgPicture.asset(
    'assets/icons/arrow_backward.svg',
    width: 24,
    color: Colors.white,
  );

  static backIcon(context, color) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 33,
        child: IconButton(
            icon: SvgPicture.asset(
          'assets/icons/arrow_backward.svg',
          width: 24,
          color: color,
        )),
      ),
    );
  }
}

class DynamicText extends StatelessWidget {
  final TextStyle style;
  final String text;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int maxLines;
  DynamicText(this.text,
      {this.style, this.textAlign, this.maxLines, this.overflow});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        overflow: overflow == null ? TextOverflow.ellipsis : overflow,
        maxLines: maxLines == null ? null : maxLines,
        textAlign: textAlign ?? TextAlign.start,
        style: style.copyWith(
            fontSize: style.fontSize * kSizeConfig.textMultiplier));
  }
}
