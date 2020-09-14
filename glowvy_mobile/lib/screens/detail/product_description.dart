import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/material.dart';
import '../../common/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/generated/i18n.dart';

class ProductDescription extends StatefulWidget {
  Product product;

  ProductDescription(this.product);

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription>
    with AutomaticKeepAliveClientMixin<ProductDescription> {
  @override
  bool get wantKeepAlive => true;
  bool isKorean = false;
  List<bool> isSelected;

  @override
  void initState() {
    isSelected = [true, false];

    super.initState();
  }

  Widget renderSizeDetail() {
    var sizeDetailWidget = <Widget>[];
    //create a concanteanated string
    var sizeDetails = widget.product.sizeDetails;
    if (sizeDetails != null) {
      sizeDetails.forEach((sizeDetail) {
        sizeDetail.attributes.forEach((attribute) {
          sizeDetailWidget.add(Text(
            "${attribute.title} ${attribute.value}",
            textAlign: TextAlign.start,
            style: kBaseTextStyle.copyWith(fontSize: 12),
          ));
        });
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sizeDetailWidget,
    );
  }

  Widget renderDescriptionImgs() {
    var imagesWidget = <Widget>[];
    //create a concanteanated string
    var images = widget.product.descImages;
    images?.forEach((img) {
      // print("image to render: $img");
      if (img != null && img != "") {
        imagesWidget.add(Tools.image(
          url: img,
          fit: BoxFit.cover,
          size: kSize.large,
        ));
      }
    });
    return Column(
      children: imagesWidget,
    );
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
        // height: max(MediaQuery.of(context).size.height, webViewHeight),
        width: kScreenSizeWidth,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: kDarkAccent),
                            textAlign: TextAlign.start,
                          ),
                          Text(S.of(context).supportedByGoogleTranslate,
                              style: kBaseTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: kSecondaryGrey,
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
                                  left: 10, right: 10, top: 8, bottom: 8),
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
                                isKorean = i == 0 ? false : true;
                              }
                            });
                          },
                          isSelected: isSelected,
                        ),
                      ),
                    ]),

                SizedBox(height: 50),
                // DynamicText(
                //   "in CM",
                //   style: kBaseTextStyle.copyWith(
                //       fontSize: 14,
                //       fontWeight: FontWeight.w500,
                //       color: kDarkAccent),
                //   textAlign: TextAlign.start,
                // ),
                renderSizeDetail(),
                SizedBox(height: 35),
                widget.product.description != null
                    ? Text(
                        formattedDescription,
                        style: kBaseTextStyle.copyWith(
                            fontSize: 12, color: kDarkAccent),
                        textAlign: TextAlign.start,
                      )
                    : Container(width: 0, height: 0),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 30.0),
                  child: renderDescriptionImgs(),
                )
              ]),
        ));
  }
}
