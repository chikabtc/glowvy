import 'package:flutter/material.dart';
import 'dart:math';
import '../../common/constants.dart';
import '../../widgets/image_galery.dart';
import '../../common/styles.dart';
import '../../models/review.dart';
import 'package:Dimodo/widgets/customWidgets.dart';

class CosmeticsReviewCard extends StatelessWidget {
  CosmeticsReviewCard(
      {this.review,
      this.isKorean = false,
      this.context,
      this.isPreview = false});

  final Review review;
  final bool isPreview;
  final bool isKorean;
  final BuildContext context;
  Random rng = new Random();
  String sanitizedText;
  String kSanitizedText;

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
    sanitizedText = review.content.replaceAll("\n", "");
    kSanitizedText = review.scontent.replaceAll("\n", "");

    if (isPreview && sanitizedText.length > 70) {
      sanitizedText =
          review.content.replaceAll("\n", "").substring(1, 70) + " ...";
    }

    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(2.0)),
      margin: EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //todo: assign the same profile pic
              Image.asset(
                'assets/icons/account/profile${1}.png',
                width: isPreview ? 18 : 38,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DynamicText(review.user.name,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    Row(
                      children: <Widget>[
                        DynamicText(review.user.name,
                            style: TextStyle(
                                fontSize: isPreview ? 11 : 13,
                                fontWeight: FontWeight.w500,
                                color: kSecondaryGrey)),
                        SizedBox(width: 10),
                        DynamicText(review.user.age.toString(),
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: kSecondaryGrey)),
                        SizedBox(width: 10),
                        DynamicText(review.user.skinType,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: kSecondaryGrey)),
                      ],
                    ),

                    SizedBox(height: 7),
                    DynamicText(isKorean ? kSanitizedText : sanitizedText,
                        maxLines: isPreview ? 2 : 20,
                        style: kBaseTextStyle.copyWith(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    Container(
                      height: 20,
                      width: kScreenSizeWidth,
                      // color: kDefaultBackground,
                    ),
                    // if (review.images?.length != 0 && !isPreview)
                    //   Container(
                    //     height: 150,
                    //     child: ListView(
                    //         scrollDirection: Axis.horizontal,
                    //         children: renderImgs(context, review)),
                    //   ),
                    // Row(children: renderImgs(context, review)),
                  ],
                ),
              ),
            ],
          ),
          if (!isPreview)
            Container(
              height: 5,
              width: kScreenSizeWidth,
              color: kDefaultBackground,
            ),
        ],
      ),
    );
  }
}
