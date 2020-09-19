import 'package:Dimodo/models/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math';
import '../../common/constants.dart';
import '../../widgets/image_galery.dart';
import '../../common/styles.dart';
import '../../models/review.dart';
import 'package:Dimodo/widgets/customWidgets.dart';

class IngredientCard extends StatelessWidget {
  IngredientCard({this.ingredient, this.showDivider = true});

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

  getHazardIcon() {
    switch (ingredient.hazardScore) {
      case 0:
        return "grey_shield.svg";
        break;
      case 1:
        return "green-shield.svg";
        break;
      case 2:
        return "orange_shield.svg";
        break;
      case 3:
        return "red_shield.svg";
        break;
      default:
        return "grey_shield.svg";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //todo: assign the same profile pic
          Container(
            // height: 57,
            child: Column(
              children: <Widget>[
                SvgPicture.asset("assets/icons/${getHazardIcon()}"),
                SizedBox(height: 14),
              ],
            ),
          ),
          SizedBox(width: 20),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 14),
                Text(ingredient.nameEn,
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                SizedBox(height: 3),
                Text(ingredient.purposes.join(','),
                    style: TextStyle(
                        color: kDarkSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
                SizedBox(height: 14),
                if (showDivider) Divider(color: Colors.black.withOpacity(0.1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
