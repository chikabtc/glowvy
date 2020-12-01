import 'dart:math';

import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/product_thumbnail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../common/colors.dart';
import '../common/constants.dart';
import '../common/styles.dart';
import '../models/review.dart';
import 'image_galery.dart';

class UserReviewCard extends StatefulWidget {
  const UserReviewCard({this.review, this.context});

  final Review review;
  // final Product product;
  final BuildContext context;

  @override
  _UserReviewCardState createState() => _UserReviewCardState();
}

class _UserReviewCardState extends State<UserReviewCard> {
  String sanitizedText;
  Product product;
  final df = DateFormat('dd/MM/yyyy');
  bool showAll = false;
  User user;

  // @override
  // void initState() {
  //   super.initState();
  // }
  @override
  void initState() {
    super.initState();
    user = Provider.of<UserModel>(context, listen: false).user;
  }

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

  void _onShowGallery(context, images, [index = 0]) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return ImageGalery(images: images, index: index);
        });
  }

  @override
  Widget build(BuildContext context) {
    sanitizedText = widget.review.content.replaceAll('\n', '');
    // if (isPreview && sanitizedText.length > 70) {
    //   sanitizedText =
    //       review.content.replaceAll('\n', '').substring(1, 70) + ' ...';
    // }

    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(2.0)),
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //todo: assign the same profile pic
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl:
                      user.picture + '?v=${ValueKey(Random().nextInt(100))}',
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.review.user.fullName,
                        style: textTheme.headline5
                            .copyWith(color: kDarkSecondary)),
                    Text(
                        df.format(DateTime.fromMillisecondsSinceEpoch(
                            widget.review.createdAt)),
                        style: textTheme.headline5
                            .copyWith(color: kDarkSecondary)),
                    // Text(review.optionName,
                    //     style: TextStyle(
                    //         color: kDarkSecondary.withOpacity(0.5),
                    //         fontSize: 11,
                    //         fontWeight: FontWeight.w500)),

                    // if (review.images?.length != 0)
                    //   Container(
                    //     height: 150,
                    //     child: ListView(
                    //         scrollDirection: Axis.horizontal,
                    //         children: renderImgs(context, review)),
                    //   ),
                    // // Row(children: renderImgs(context, review)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => setState(() {
              showAll = !showAll;
            }),
            child: Wrap(
              children: <Widget>[
                const SizedBox(height: 10),
                Text(sanitizedText,
                    textAlign: TextAlign.start,
                    maxLines: showAll ? 300 : 3,
                    style: textTheme.headline5),
                (!showAll && sanitizedText.length > 300)
                    ? Text(
                        '... Nhiều hơn',
                        textAlign: TextAlign.start,
                        style: textTheme.headline5.copyWith(
                          color: kSecondaryGrey,
                        ),
                      )
                    : Container()
              ],
            ),
          ),

          // Text(sanitizedText, maxLines: 200, style: textTheme.headline5),
          const SizedBox(height: 10),
          RatingBar(
              itemSize: 18,
              initialRating: widget.review.rating.toDouble(),
              ignoreGestures: true,
              direction: Axis.horizontal,
              itemCount: 5,
              ratingWidget: RatingWidget(
                full: SvgPicture.asset('assets/icons/rank-flower.svg',
                    color: kPrimaryOrange),
                half: SvgPicture.asset('assets/icons/rank-flower.svg'),
                empty: SvgPicture.asset('assets/icons/rank-flower.svg'),
              ),
              onRatingUpdate: (rating) => print('dsd')),
          const SizedBox(height: 10),

          ProductThumbnail(widget.review.product),
          // Container(
          //   height: 35,
          //   width: kScreenSizeWidth,
          //   color: kDefaultBackground,
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 15, bottom: 36),
            child: Text(
              'helpful (${widget.review.likeCount})',
              style: textTheme.caption2.copyWith(color: kSecondaryGrey),
            ),
          )
        ],
      ),
    );
  }
}
