import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:flutter/material.dart';

class Keyword extends StatelessWidget {
  const Keyword({
    Key key,
    @required this.keyword,
    @required this.onTap,
  }) : super(key: key);

  final String keyword;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          color: kLightYellow,
          borderRadius: BorderRadius.circular(10),
        ),
        // alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 6),
          child: Text(
            keyword,
            textAlign: TextAlign.center,
            style: textTheme.bodyText2.copyWith(color: kDarkYellow),
          ),
        ),
      ),
    );
  }
}
