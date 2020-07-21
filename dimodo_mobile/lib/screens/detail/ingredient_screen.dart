import 'package:Dimodo/models/ingredient.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/screens/detail/Cosmetics_review_card.dart';
import 'package:Dimodo/screens/detail/ingredient_card.dart';
import 'package:Dimodo/widgets/cosmetics_review_filter_bar.dart';
import 'package:flutter/material.dart';
import '../../common/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/styles.dart';
import '../../generated/i18n.dart';
import '../../models/reviews.dart';
import '../../services/index.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/cupertino.dart';
import 'cartAction.dart';

class IngredientScreen extends StatefulWidget {
  final List<Ingredient> ingredients;
  String hazardLevel;

  IngredientScreen(this.ingredients, this.hazardLevel);

  @override
  IngredientScreenStates createState() => IngredientScreenStates();
}

class IngredientScreenStates extends State<IngredientScreen>
    with AutomaticKeepAliveClientMixin<IngredientScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          leading: IconButton(
            icon: CommonIcons.arrowBackward,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          bottom: PreferredSize(
            child: Container(
              width: screenSize.width - 88,
              height: 104,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.hazardLevel,
                          style: kBaseTextStyle.copyWith(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                      Text(S.of(context).ewgSafeLevel,
                          style: kBaseTextStyle.copyWith(
                              fontSize: 12,
                              color: kDarkSecondary,
                              fontWeight: FontWeight.w500)),
                      SizedBox(width: 16)
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(children: <Widget>[
                        SvgPicture.asset("assets/icons/grey_shield.svg"),
                        Text(
                          S.of(context).undecided,
                          style: kBaseTextStyle.copyWith(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        )
                      ]),
                      Column(children: <Widget>[
                        SvgPicture.asset("assets/icons/green_shield.svg"),
                        Text(
                          S.of(context).low,
                          style: kBaseTextStyle.copyWith(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        )
                      ]),
                      Column(children: <Widget>[
                        SvgPicture.asset("assets/icons/orange_shield.svg"),
                        Text(
                          S.of(context).moderate,
                          style: kBaseTextStyle.copyWith(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        )
                      ]),
                      Column(children: <Widget>[
                        SvgPicture.asset("assets/icons/red_shield.svg"),
                        Text(
                          S.of(context).high,
                          style: kBaseTextStyle.copyWith(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        )
                      ]),
                    ],
                  ),
                ],
              ),
            ),
            preferredSize: Size(screenSize.width, 104),
          ),
          actions: <Widget>[CartAction()],
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Container(
          color: Colors.white,
          width: screenSize.width,
          height: screenSize.height,
          padding: EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 24),
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.ingredients.length,
              itemBuilder: (context, i) => IngredientInfoCard(
                    ingredient: widget.ingredients[i],
                    showDivider:
                        widget.ingredients.length == i + 1 ? false : true,
                  )),
        ));
  }
}
