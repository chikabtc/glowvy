import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:Dimodo/widgets/image_galery.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../common/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:custom_switch/custom_switch.dart';

class CosmeticsProductDescription extends StatefulWidget {
  Product product;

  CosmeticsProductDescription(this.product);

  @override
  _CosmeticsProductDescriptionState createState() =>
      _CosmeticsProductDescriptionState();
}

class _CosmeticsProductDescriptionState
    extends State<CosmeticsProductDescription>
    with AutomaticKeepAliveClientMixin<CosmeticsProductDescription> {
  @override
  bool get wantKeepAlive => true;
  bool isKorean = false;
  List<bool> isSelected;

  @override
  void initState() {
    isSelected = [true, false];

    super.initState();
  }

  Widget build(BuildContext context) {
    // if \n has more than 4, replace them with null string
    String formattedDescription;
    if (widget.product.description != null) {
      formattedDescription = isKorean
          ? widget.product.sdescription.replaceAll('\n\n\n\n\n\n', "")
          : widget.product.description.replaceAll('\n\n\n\n\n\n', "");
    }

    return Container(
        color: Colors.white,
        width: kScreenSizeWidth,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Mô tả sản phẩm",
                      style: kBaseTextStyle.copyWith(
                          fontSize: 15, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 33),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "ID: ${widget.product.sid.toString()}",
                                style: kBaseTextStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: kDarkSecondary),
                                textAlign: TextAlign.start,
                              ),
                              Text(S.of(context).supportedByGoogleTranslate,
                                  style: kBaseTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: kDarkSecondary,
                                  )),
                            ],
                          ),
                          Container(
                            height: 32,
                            decoration: BoxDecoration(
                              color: kTertiaryGray,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.all(2),
                            child: ToggleButtons(
                              fillColor: Colors.white,
                              borderWidth: 0,
                              selectedBorderColor: Colors.white,
                              selectedColor: Colors.black,
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 6, top: 8, bottom: 8),
                                  child: Text(
                                    'Tiếng Việt',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 6, right: 10, top: 8, bottom: 8),
                                  child: Text(
                                    'Original',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              ],
                              onPressed: (int index) {
                                setState(() {
                                  for (int i = 0; i < isSelected.length; i++) {
                                    isSelected[i] = i == index;
                                    isKorean = index == 0 ? false : true;
                                  }
                                });
                              },
                              isSelected: isSelected,
                            ),
                          ),
                        ]),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Container(
                height: 28,
                child: ListView.separated(
                    padding: EdgeInsets.only(left: 10),
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(width: 10),
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.product.tags.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: kDefaultBackground,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 6, bottom: 6),
                        child: Text(
                          widget.product.tags[index].name,
                          maxLines: 1,
                          style: kBaseTextStyle.copyWith(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      );
                    }),
              ),
              SizedBox(height: 14),
              Container(
                padding: EdgeInsets.all(16),
                child: widget.product.sdescription != null
                    ? Text(
                        formattedDescription,
                        maxLines: 100,
                        style: kBaseTextStyle.copyWith(
                            fontSize: 14, color: kDarkAccent),
                        textAlign: TextAlign.start,
                      )
                    : Container(width: 0, height: 0),
              ),
            ]));
  }
}
