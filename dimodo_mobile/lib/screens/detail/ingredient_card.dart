import 'package:Dimodo/models/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math';
import '../../common/constants.dart';
import '../../widgets/image_galery.dart';
import '../../common/styles.dart';
import '../../models/review.dart';
import 'package:Dimodo/widgets/customWidgets.dart';

class IngredientInfoCard extends StatelessWidget {
  IngredientInfoCard({this.ingredient, this.showDivider = true});

  final Ingredient ingredient;
  final showDivider;
  String safetyIcon = "assets/icons/green_shield.svg";

  List<Widget> renderImgs(context, Review review) {
    var imgButtons = <Widget>[];

    review.images?.forEach((element) {
      var imgBtn = ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          child: IconButton(
              iconSize: 150,
              icon: Image.network(
                element,
                fit: BoxFit.fill,
              ),
              onPressed: () => _onShowGallery(context, review.images)));

      imgButtons.add(imgBtn);
    });
    return imgButtons;
    //on the external display, the lag is unusable..
  }

  _onShowGallery(context, images, [index = 0]) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return ImageGalery(images: images, index: index);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(2.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //todo: assign the same profile pic
          if (ingredient.hazardScore == 0)
            SvgPicture.asset("assets/icons/grey_shield.svg"),
          if (ingredient.hazardScore == 1)
            SvgPicture.asset("assets/icons/green_shield.svg"),
          if (ingredient.hazardScore == 2)
            SvgPicture.asset("assets/icons/orange_shield.svg"),
          if (ingredient.hazardScore == 3)
            SvgPicture.asset("assets/icons/red_shield.svg"),
          SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 12),
                Text(ingredient.nameEn,
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                SizedBox(height: 12),
                Text(ingredient.purposes.join(','),
                    style: TextStyle(
                        color: kSecondaryGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
                if (showDivider) Divider(color: Colors.black.withOpacity(0.1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
