import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/models/second_category.dart';
import 'package:Dimodo/models/third_category.dart';
import 'package:Dimodo/screens/category_ranking_page.dart';
import 'package:flutter/material.dart';

class SecondCategoryButton extends StatefulWidget {
  const SecondCategoryButton(this.category, {this.onTap});
  final SecondCategory category;
  final Function onTap;

  @override
  _SecondCategoryButtonState createState() => _SecondCategoryButtonState();
}

class _SecondCategoryButtonState extends State<SecondCategoryButton> {
  ThirdCategory selectedThirdCategory;
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          if (widget.category.thirdCategories.isEmpty) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RankingByCategory(secondCategory: widget.category)));
          }
        });
      },
      child: Column(
        children: [
          Container(
            height: 50,
            color: Colors.transparent,
            padding: const EdgeInsets.only(left: 16, right: 5),
            child: Center(
              child: Row(
                children: [
                  Text(widget.category.secondCategoryName,
                      textAlign: TextAlign.left,
                      style: textTheme.headline5.copyWith(fontSize: 16)),
                  const Spacer(),
                  Icon(
                    isSelected ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: widget.category.thirdCategories.isEmpty
                        ? Colors.transparent
                        : kSecondaryGrey,
                  ),
                ],
              ),
            ),
          ),
          if (isSelected)
            ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.category.thirdCategories.length,
                itemBuilder: (context, index) => Container(
                      padding: const EdgeInsets.all(16),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RankingByCategory(
                                    secondCategory: widget.category,
                                    thirdCategory: widget
                                        .category.thirdCategories[index]))),
                        child: Text(
                          widget.category.thirdCategories[index]
                              .thirdCategoryName,
                          style: textTheme.caption.copyWith(color: kDarkAccent),
                        ),
                      ),
                    )),
          kDivider
        ],
      ),
    );
  }
}
