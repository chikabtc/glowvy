import 'package:Dimodo/common/styles.dart';

import 'package:Dimodo/common/colors.dart';
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
  return GestureDetector(
    onTap: () => Navigator.of(context).pop(),
    child: IconButton(
        // iconSize: 35,
        icon: SvgPicture.asset(
      'assets/icons/arrow_backward.svg',
      width: 26,
      color: color,
    )),
  );
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
