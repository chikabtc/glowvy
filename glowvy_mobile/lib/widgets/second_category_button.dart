import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/second_category.dart';
import 'package:Dimodo/models/third_category.dart';
import 'package:Dimodo/screens/category_ranking_page.dart';
import 'package:flutter/material.dart';

class SecondCategoryButton extends StatefulWidget {
  SecondCategoryButton(this.category);
  final Category category;
  var isSelected = false;

  @override
  _SecondCategoryButtonState createState() => _SecondCategoryButtonState();
}

class _SecondCategoryButtonState extends State<SecondCategoryButton>
    with AutomaticKeepAliveClientMixin<SecondCategoryButton> {
  Category selectedThirdCategory;

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
                Text(widget.category.name ?? 'ds',
                    textAlign: TextAlign.left,
                    style: textTheme.headline5.copyWith(fontSize: 16)),
                const Spacer(),
                Icon(
                  widget.isSelected
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                  color: widget.category.subCategories.isEmpty
                      ? Colors.transparent
                      : kSecondaryGrey,
                ),
              ],
            ),
          ),
          onPressed: () {
            setState(() {
              widget.isSelected = !widget.isSelected;
              if (widget.category.subCategories.isEmpty) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RankingByCategory(
                            secondCategory: widget.category)));
              }
            });
          },
        ),
        if (widget.isSelected && widget.category.subCategories.isNotEmpty)
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
            itemCount: widget.category.subCategories.length,
            itemBuilder: (context, index) => FlatButton(
              color: Colors.transparent,
              onPressed: () {
                setState(() {
                  selectedThirdCategory = widget.category.subCategories[index];
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
                  widget.category.subCategories[index].name,
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
