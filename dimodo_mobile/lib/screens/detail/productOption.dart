import 'package:Dimodo/models/order/cartItem.dart';
import 'package:flutter/material.dart';
import '../../common/styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Dimodo/widgets/login_animation.dart';

import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/productAttribute.dart';
import 'package:Dimodo/models/brandi/option.dart';
import 'package:Dimodo/models/order/cart.dart';

import 'package:Dimodo/models/user/userModel.dart';
import '../../common/constants.dart';
import 'package:Dimodo/common/tools.dart';

class ProductOption extends StatefulWidget {
  final Product product;
  final bool isLoggedIn;
  ProductOption(this.product, this.isLoggedIn);
  @override
  _ProductOptionState createState() => _ProductOptionState();
}

class _ProductOptionState extends State<ProductOption>
    with TickerProviderStateMixin {
  Function onSupport;
  bool isLoading = false;
  Size screenSize;
  AnimationController addToCartButtonController;
  int quantity = 1;
  bool isSingleOption;
  SingleOptions singleOptions;
  var chosenOptions = ["", ""];
  List<CompoundOption> compoundOptions;

  @override
  void initState() {
    parseOptions(widget.product);
    addToCartButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
    super.initState();
  }

  //parseOptions will take a list of option and return either single or compound options
  //that are easier for creating options UI widgets;
  void parseOptions(Product product) {
    var options = product.options;
    //check whether there are two options
    if (options == null) {
      return;
    }
    if (options[0].attributes.length == 1) {
      singleOptions = Option.newSingleOptions(options);
      isSingleOption = true;
    } else if (options[0].attributes.length == 2) {
      compoundOptions = Option.newCompoundOptions(options);
      isSingleOption = false;
    }
  }

  void addToCart(Product product) {
    final cartModel = Provider.of<CartModel>(context, listen: false); //
    print("adding to cart price: ${product.salePrice}");
    var cartItem = CartItem(
        product: product,
        optionId: getOptionId(),
        quantity: quantity,
        option: isSingleOption
            ? chosenOptions[0]
            : "${chosenOptions[0]} / ${chosenOptions[1]}");
    cartModel.addProductToCart(cartItem: cartItem);
    Navigator.of(context).pop();
    Future.delayed(const Duration(milliseconds: 300), () {
      showAddedToCartAlert();
    });
  }

  Future<void> showAddedToCartAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user can tap anywhere to dismiss the popup!
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: DynamicText(
            "Thanks for liking it!",
            style: kBaseTextStyle.copyWith(fontSize: 16),
          ),
          actions: <Widget>[
            FlatButton(
              child: DynamicText(
                'Ok',
                style: kBaseTextStyle,
              ),
              onPressed: () {
                Navigator.of(buildContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //returns the product_id of the option with the same attribute Value

  int getOptionId() {
    var optionID;
    widget.product.options.forEach((option) {
      if (isSingleOption) {
        if (option.attributes[0].value == chosenOptions[0]) {
          print("single option ID: ${option.productId}");
          optionID = option.productId;
        }
      } else {
        if (option.attributes[0].value == chosenOptions[0] &&
            option.attributes[1].value == chosenOptions[1]) {
          print("compound option ID: ${option.productId}");
          optionID = option.productId;
        }
      }
    });
    return int.parse(optionID);
  }

  Widget showSingleOption(StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 10),
          child: DynamicText(
            singleOptions.title,
            style: kBaseTextStyle.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: kDarkSecondary),
          ),
        ),
        Wrap(
          children: <Widget>[
            for (var attribute in singleOptions.attributes)
              Container(
                child: ActionChip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  elevation: 0,
                  onPressed: () {
                    if (!attribute.isSoldOut)
                      setState(() {
                        chosenOptions[0] = attribute.value;
                      });
                  },
                  backgroundColor: chosenOptions[0] == attribute.value
                      ? kAccentRed
                      : attribute.isSoldOut
                          ? kDarkAccent.withOpacity(0.4)
                          : kLightBG,
                  label: DynamicText(
                    attribute.value,
                    style: kBaseTextStyle.copyWith(
                        fontSize: 15,
                        color: chosenOptions[0] == attribute.value
                            ? Colors.white
                            : attribute.isSoldOut
                                ? Colors.black.withOpacity(0.4)
                                : kDarkSecondary,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                margin: EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 2),
              )
          ],
        ),
      ],
    );
  }

  List<ProductAttribute> getAssociatedAttributes(
      CompoundOption compound, String chosenKey) {
    List<ProductAttribute> list;
    compound.options.forEach((key, value) {
      if (chosenKey == key) {
        list = value;
      }
    });
    return list;
  }

  /**
 * check whether certain size or color is available. 
 * if no chosenKey is provided, then return true
 */
  bool isSoldOut(
      CompoundOption compound, String chosenValue, String chosenKey) {
    bool isSoldOut = false;
    if (chosenKey == "") {
      isSoldOut = false;
    } else {
      //compound represents colors (s, m, l)
      compound.options.forEach((key, option) {
        //chosen key represents the s
        if (chosenValue == key) {
          option.forEach((element) {
            //chosen value represents color blue
            if (element.value == chosenKey) {
              isSoldOut = element.isSoldOut;
            }
          });
        }
      });
    }
    return isSoldOut;
  }

  bool isProductChosen() {
    if (isSingleOption && chosenOptions[0] != "") {
      return true;
    } else if (!isSingleOption &&
        chosenOptions[0] != "" &&
        chosenOptions[1] != "") {
      return true;
    } else {
      return false;
    }
  }

  Widget showCompoundOptions(StateSetter setState) {
    List<Widget> widgets = [];
    // enumerate the two compound options
    compoundOptions.asMap().forEach((index, compoundOption) {
      var associatedKey = index == 0 ? chosenOptions[1] : chosenOptions[0];
      var header = DynamicText(
        compoundOption.title,
        style: kBaseTextStyle.copyWith(
            fontSize: 13, fontWeight: FontWeight.w600, color: kDarkSecondary),
      );
      var options = Wrap(children: <Widget>[
        for (var key in compoundOption.options.keys)
          Container(
            child: ActionChip(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              elevation: 0,
              onPressed: () {
                setState(() {
                  if (!isSoldOut(compoundOption, key, associatedKey)) {
                    chosenOptions[index] = key;
                  }
                });
              },
              backgroundColor: chosenOptions[index] == key
                  ? kAccentRed
                  : isSoldOut(compoundOption, key, associatedKey)
                      ? kDarkAccent.withOpacity(0.4)
                      : kLightBG,
              label: DynamicText(
                key,
                style: kBaseTextStyle.copyWith(
                    fontSize: 15,
                    color: chosenOptions[index] == key
                        ? Colors.white
                        : kDarkSecondary,
                    fontWeight: FontWeight.w600),
              ),
            ),
            margin: EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 2),
          )
      ]);
      widgets.addAll([header, options, Container(height: 10)]);
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Future show(context, heightFactor, isLoggedIn, isLoading) {
    return showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return FractionallySizedBox(
                heightFactor: heightFactor,
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    width: kScreenSizeWidth,
                    height: kScreenSizeHeight,
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Stack(children: <Widget>[
                          Container(
                              color: Colors.transparent,
                              height: AppBar().preferredSize.height,
                              width: kScreenSizeWidth,
                              child: Center(
                                child: DynamicText(S.of(context).choose,
                                    style: kBaseTextStyle.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                              )),
                          Positioned(
                            top: 6,
                            right: 0,
                            child: IconButton(
                                icon: SvgPicture.asset(
                                    'assets/icons/address/close-popup.svg'),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          )
                        ]),
                        Container(
                          height: screenSize.height * heightFactor -
                              AppBar().preferredSize.height -
                              100,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                if (singleOptions != null)
                                  showSingleOption(setState),
                                if (compoundOptions != null)
                                  showCompoundOptions(setState),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.0, bottom: 10.0),
                                  child: Divider(
                                    height: 1,
                                    color: kDarkSecondary.withOpacity(0.3),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        DynamicText(
                                          S.of(context).quantity,
                                          style: kBaseTextStyle.copyWith(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: kDarkSecondary),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              width: 24,
                                              child: IconButton(
                                                  padding: EdgeInsets.all(0),
                                                  icon: SvgPicture.asset(
                                                      'assets/icons/product_detail/substract-stepper.svg'),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (quantity == 0) {
                                                        return;
                                                      }
                                                      quantity -= 1;
                                                    });
                                                  }),
                                            ),
                                            Container(
                                              height: 24,
                                              width: 32,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(6.0)),
                                                  border: Border.all(
                                                      style: BorderStyle.solid,
                                                      color: kLightBG,
                                                      width: 1.5)),
                                              child: DynamicText(
                                                quantity.toString(),
                                                textAlign: TextAlign.center,
                                                style: kBaseTextStyle.copyWith(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: kDarkSecondary),
                                              ),
                                            ),
                                            Container(
                                              width: 24,
                                              child: IconButton(
                                                  padding: EdgeInsets.all(0),
                                                  icon: SvgPicture.asset(
                                                      'assets/icons/product_detail/add-stepper.svg'),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (quantity == 10) {
                                                        return;
                                                      }
                                                      quantity += 1;
                                                    });
                                                  }),
                                            ),
                                          ],
                                        )
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                bottom: 40.0,
                              ),
                              child: Consumer<UserModel>(
                                  builder: (context, model, child) {
                                return StaggerAnimation(
                                  buttonTitle: S.of(context).addToCart,
                                  btnColor: isProductChosen()
                                      ? kAccentRed
                                      : kDarkAccent.withOpacity(0.4),
                                  btnTitleColor: isProductChosen()
                                      ? Colors.white
                                      : kDarkSecondary,
                                  buttonController:
                                      addToCartButtonController.view,
                                  // onTap: () => showAddedToCartAlert(),
                                  onTap: isProductChosen()
                                      ? () {
                                          (model.isLoggedIn)
                                              ? addToCart(widget.product)
                                              : Navigator.pushNamed(
                                                  context, "/login");
                                        }
                                      : null,
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    )),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    var bottomPopupHeightFactor = 1 -
        (AppBar().preferredSize.height +
                60 +
                MediaQuery.of(context).padding.bottom) /
            kScreenSizeHeight;
    return Container(
      height: 60.0 + MediaQuery.of(context).padding.bottom,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 9.0, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            MaterialButton(
                elevation: 0,
                minWidth: (screenSize.width - 48) * 0.5,
                height: 40,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    side: BorderSide(color: kAccentRed, width: 1.5)),
                child: Text(S.of(context).customerSupport,
                    style: kBaseTextStyle.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: kAccentRed)),
                onPressed: () =>
                    CustomerSupport.openFacebookMessenger(context)),
            SizedBox(width: 16),
            MaterialButton(
                elevation: 0,
                color: kAccentRed,
                minWidth: (screenSize.width - 48) * 0.5,
                height: 40,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    side: BorderSide(color: kAccentRed, width: 1.5)),
                child: Text("Love it",
                    style: kBaseTextStyle.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                onPressed: () {
                  showAddedToCartAlert();
                  // show(context, bottomPopupHeightFactor, widget.isLoggedIn,
                  //     isLoading);
                }),
          ],
        ),
      ),
    );
  }
}
