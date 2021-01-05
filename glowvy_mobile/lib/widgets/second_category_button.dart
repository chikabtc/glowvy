import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/models/second_category.dart';
import 'package:Dimodo/models/third_category.dart';
import 'package:Dimodo/screens/category_ranking_page.dart';
import 'package:flutter/material.dart';

class SecondCategoryButton extends StatefulWidget {
  SecondCategoryButton(this.category);
  final SecondCategory category;
  var isSelected = false;

  @override
  _SecondCategoryButtonState createState() => _SecondCategoryButtonState();
}

class _SecondCategoryButtonState extends State<SecondCategoryButton>
    with AutomaticKeepAliveClientMixin<SecondCategoryButton> {
  ThirdCategory selectedThirdCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlatButton(
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
                  widget.isSelected
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                  color: widget.category.thirdCategories.isEmpty
                      ? Colors.transparent
                      : kSecondaryGrey,
                ),
              ],
            ),
          ),
          onPressed: () {
            setState(() {
              widget.isSelected = !widget.isSelected;
              if (widget.category.thirdCategories.isEmpty) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RankingByCategory(
                            secondCategory: widget.category)));
              }
            });
          },
        ),
        if (widget.isSelected && widget.category.thirdCategories.isNotEmpty)
          FlatButton(
            color: Colors.transparent,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RankingByCategory(secondCategory: widget.category)));
            },
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tất cả sản phẩm',
                textAlign: TextAlign.start,
                style: textTheme.caption.copyWith(color: kDarkAccent),
              ),
            ),
          ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 100),
          secondChild: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.category.thirdCategories.length,
            itemBuilder: (context, index) => FlatButton(
              color: Colors.transparent,
              onPressed: () {
                setState(() {
                  selectedThirdCategory =
                      widget.category.thirdCategories[index];
                });

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RankingByCategory(
                            secondCategory: widget.category,
                            thirdCategory: selectedThirdCategory)));
              },
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.category.thirdCategories[index].thirdCategoryName,
                  textAlign: TextAlign.start,
                  style: textTheme.caption.copyWith(color: kDarkAccent),
                ),
              ),
            ),
          ),
          firstChild: Container(), // When you don't want to show menu..
          crossFadeState: widget.isSelected
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),
        // if (isSelected)
        kDivider
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
