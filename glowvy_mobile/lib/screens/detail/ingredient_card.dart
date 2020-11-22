import 'package:Dimodo/models/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/colors.dart';
import '../../widgets/image_galery.dart';

class IngredientCard extends StatelessWidget {
  const IngredientCard({this.ingredient, this.showDivider = true});

  final Ingredient ingredient;
  final bool showDivider;
  final String safetyIcon = 'assets/icons/green_shield.svg';

  void _onShowGallery(context, images, [index = 0]) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return ImageGalery(images: images, index: index);
        });
  }

  String getHazardIcon() {
    switch (ingredient.hazardScore) {
      case 0:
        return 'grey_shield.svg';
        break;
      case 1:
        return 'green-shield.svg';
        break;
      case 2:
        return 'orange_shield.svg';
        break;
      case 3:
        return 'red_shield.svg';
        break;
      default:
        return 'grey_shield.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ingredient.nameEn != null)
      return Container(
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
                  SvgPicture.asset('assets/icons/${getHazardIcon()}'),
                  const SizedBox(height: 14),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 14),
                  Text(ingredient.nameEn,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 3),
                  if (ingredient.purposes != null)
                    Text(ingredient.purposes.join(','),
                        style: TextStyle(
                            color: kSecondaryGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                  const SizedBox(height: 14),
                  if (showDivider)
                    Divider(color: Colors.black.withOpacity(0.1)),
                ],
              ),
            ),
          ],
        ),
      );
    else
      return Container();
  }
}
