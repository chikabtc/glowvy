import 'package:Dimodo/models/ingredient.dart';
import 'package:Dimodo/screens/detail/ingredient_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/colors.dart';
import '../../common/constants.dart';
import '../../common/styles.dart';
import '../../common/widgets.dart';
import '../../generated/i18n.dart';

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
          backgroundColor: kLightYellow,
          title: Text('Thông tin thành phần',
              style: textTheme.headline3.copyWith(color: kDarkYellow)),
          brightness: Brightness.light,
          leading: backIcon(context, color: kDarkYellow),
          bottom: PreferredSize(
            child: Container(
              width: screenSize.width,
              height: 178,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 34),
                      Text(widget.hazardLevel ?? 'unknown',
                          style: textTheme.headline3),
                      Text(S.of(context).ewgSafeLevel,
                          style: textTheme.caption2.copyWith(
                            color: kSecondaryGrey,
                          )),
                    ],
                  ),
                  const SizedBox(height: 35),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.only(
                        left: 44, right: 44, top: 16, bottom: 14),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(children: <Widget>[
                          SvgPicture.asset('assets/icons/grey_shield.svg'),
                          Text(S.of(context).undecided,
                              style: textTheme.caption2)
                        ]),
                        Column(children: <Widget>[
                          SvgPicture.asset('assets/icons/green-shield.svg'),
                          Text(S.of(context).low, style: textTheme.caption2)
                        ]),
                        Column(children: <Widget>[
                          SvgPicture.asset('assets/icons/orange_shield.svg'),
                          Text(S.of(context).moderate,
                              style: textTheme.caption2)
                        ]),
                        Column(children: <Widget>[
                          SvgPicture.asset('assets/icons/red_shield.svg'),
                          Text(S.of(context).high, style: textTheme.caption2)
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            preferredSize: Size(screenSize.width, 178),
          ),
          elevation: 0,
        ),
        body: Container(
          color: kDefaultBackground,
          width: screenSize.width,
          height: screenSize.height,
          padding:
              const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 24),
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.ingredients.length,
              itemBuilder: (context, i) => IngredientCard(
                  ingredient: widget.ingredients[i],
                  showDivider: widget.ingredients.length != i + 1)),
        ));
  }
}
