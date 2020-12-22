import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/colors.dart';
import '../common/styles.dart';

class FilterOptionButton extends StatelessWidget {
  FilterOptionButton({
    Key key,
    @required this.name,
    this.isSelected,
    @required this.onTap,
  }) : super(key: key);

  final String name;
  final onTap;
  bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ActionChip(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isSelected ? kPrimaryOrange : kSecondaryWhite,
          ),
          borderRadius: BorderRadius.circular(6.0),
        ),
        backgroundColor: kSecondaryWhite,
        onPressed: () => onTap(),
        label: Text(
          name,
          style: kBaseTextStyle.copyWith(
              fontSize: 15,
              color: isSelected ? kPrimaryOrange : kSecondaryGrey,
              fontWeight: FontWeight.w600),
        ),
      ),
      margin: const EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 2),
    );
  }
}
