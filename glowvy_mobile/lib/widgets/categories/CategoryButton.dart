import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/category.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatefulWidget {
  CategoryButton(this.category,
      {@required this.onTap, this.isSelected = false});
  final Category category;
  final Function onTap;
  bool isSelected;

  @override
  _CategoryButtonState createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Wrap(
        children: [
          Container(
            width: 80,
            height: 80,
            color: widget.isSelected ? kPrimaryOrange : kQuaternaryGrey,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Center(
              child: Text(widget.category.firstCategoryName,
                  textAlign: TextAlign.center,
                  style: textTheme.button.copyWith(
                      fontSize: 15,
                      color: widget.isSelected
                          ? kWhite
                          : kDarkAccent.withOpacity(0.7),
                      fontWeight: FontWeight.w800)),
            ),
          ),
          customDivider(color: kDarkAccent.withOpacity(0.1))
        ],
      ),
    );
  }
}
