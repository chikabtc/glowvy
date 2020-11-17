import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:flutter/material.dart';

class SettingCard extends StatelessWidget {
  final String title;
  final Function onTap;
  final Widget trailingWidget;
  final Color color;
  final Color fontColor;
  final String trailingText;

  SettingCard(
      {this.title,
      this.onTap,
      this.fontColor = kDarkBG,
      this.trailingWidget,
      this.trailingText,
      this.color = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
          width: screenSize.width,
          color: color,
          padding: EdgeInsets.only(left: 16, right: 12, top: 16),
          child: Column(children: [
            Row(children: [
              Text(
                title,
                style: textTheme.headline5,
              ),
              const Spacer(),
              if (trailingText != null)
                Text(trailingText,
                    style: textTheme.bodyText2.copyWith(color: kDarkSecondary)),
              if (trailingWidget != null) trailingWidget,
              arrowForward,
            ]),
            const SizedBox(height: 16),
            kFullDivider
          ])),
    );
  }
}
