import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/models/order/orderItem.dart';
import 'package:Dimodo/widgets/orderItem.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../common/tools.dart';
import 'package:provider/provider.dart';
import '../../common/config.dart';
import '../../generated/i18n.dart';
import '../../models/order/cart.dart';
import '../../models/user/userModel.dart';
import '../../models/app.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'orderSummary.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/tools.dart';

class OrderSubmitted extends StatefulWidget {
  OrderSubmitted();

  @override
  _OrderSubmittedState createState() => _OrderSubmittedState();
}

class _OrderSubmittedState extends State<OrderSubmitted>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  var bottomPopupHeightFactor;
  var screenSize;
  bool isOrderConfirmed = false;
  CartModel cartModel;

  List<Widget> _createCartItems(
    CartModel model,
  ) {
    final userModel = Provider.of<UserModel>(context, listen: false); //

    var countKeys = 0;

    return model.cartItems.keys.map(
      (key) {
        countKeys++;
        return OrderItemRow(
          isDividerNeeded: model.cartItems.length > 1 &&
                  model.cartItems.keys.length != countKeys
              ? true
              : false,
          cartItem: model.getCartItemById(key),
        );
      },
    ).toList();
  }

  void onOrderConfirmed(context) {
    showModalBottomSheet(
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
                heightFactor: bottomPopupHeightFactor,
                child: Container(
                  decoration: BoxDecoration(
                    color: kDefaultBackground,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  width: screenSize.width,
                  height: screenSize.height * bottomPopupHeightFactor -
                      AppBar().preferredSize.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Stack(children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                            ),
                            height: AppBar().preferredSize.height,
                            width: kScreenSizeWidth,
                            child: Center(
                              child: DynamicText(S.of(context).writeReview,
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
                          width: 200,
                          height: 236,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Image.asset(
                                'assets/icons/cart/received-package-illustration.png'),
                          )),
                      // SizedBox(height: 20),
                      DynamicText(S.of(context).askServiceQuality,
                          style: kBaseTextStyle.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center),
                      SizedBox(height: 28),
                      Container(
                        height: 140,
                        color: Colors.white,
                        padding: EdgeInsets.only(left: 16),
                        child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            cursorColor: kPinkAccent,
                            style: kBaseTextStyle.copyWith(
                                fontSize: 15 * kSizeConfig.textMultiplier,
                                fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                                hintText: S.of(context).askForFeedback,
                                hintStyle: kBaseTextStyle.copyWith(
                                    fontSize: 14,
                                    color: kDarkSecondary.withOpacity(0.5)),
                                border: InputBorder.none,
                                hintMaxLines: 3,
                                labelStyle: kBaseTextStyle.copyWith(
                                    fontSize: 15 * kSizeConfig.textMultiplier,
                                    fontWeight: FontWeight.w600,
                                    color: kDarkAccent.withOpacity(0.5)),
                                focusColor: kPinkAccent,
                                fillColor: kPinkAccent,
                                hoverColor: kPinkAccent),
                            validator: (val) {
                              return val.isEmpty
                                  ? S.of(context).fullNameIsRequired
                                  : null;
                            },
                            onChanged: (String value) {}),
                      ),
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 40.0),
                            child: MaterialButton(
                                elevation: 0,
                                color: kPinkAccent,
                                minWidth: kScreenSizeWidth,
                                height: 40,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    side: BorderSide(
                                        color: kPinkAccent, width: 1.5)),
                                child: DynamicText(S.of(context).send,
                                    style: kBaseTextStyle.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)),
                                onPressed: () async => {
                                      await FlutterMailer.send(MailOptions(
                                        body: '',
                                        subject: 'Feedback',
                                        recipients: ['support@dimodo.app'],
                                        isHTML: true,
                                      ))
                                    }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final address =
        Provider.of<UserModel>(context, listen: false).user.address; //
    var fullAddress = address.recipientName +
        ", " +
        address.street +
        ", " +
        address.ward.name;

    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) print(arguments['cartModel']);
    cartModel = arguments['cartModel'];
    isOrderConfirmed = arguments['isOrderConfirmed'] ?? false;

    screenSize = MediaQuery.of(context).size;
    bottomPopupHeightFactor = 1 -
        (AppBar().preferredSize.height +
                60 +
                MediaQuery.of(context).padding.bottom) /
            kScreenSizeHeight;

    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
            top: false,
            bottom: false,
            child: Container(
              height: screenSize.height,
              decoration:
                  BoxDecoration(color: Theme.of(context).backgroundColor),
              child: CustomScrollView(slivers: [
                SliverAppBar(
                  brightness: Brightness.light,
                  leading: IconButton(
                    icon: CommonIcons.arrowBackwardWhite,
                    onPressed: () {
                      cartModel.clearCart();
                      Navigator.of(context).popAndPushNamed("/home");
                    },
                  ),
                  elevation: 0,
                  backgroundColor: kPinkAccent,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: DynamicText(S.of(context).orderSubmitted,
                        style: kBaseTextStyle.copyWith(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Container(
                      color: kPinkAccent,
                      padding: EdgeInsets.only(top: 30, bottom: 16),
                      child: Column(
                        children: <Widget>[
                          DynamicText(
                              isOrderConfirmed
                                  ? S.of(context).thankYouForUsingDimodo
                                  : S.of(context).oneStepLeft,
                              textAlign: TextAlign.center,
                              style: kBaseTextStyle.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          SizedBox(height: 27),
                          Padding(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: DynamicText(
                                isOrderConfirmed
                                    ? S.of(context).shippingDescription
                                    : S.of(context).transferDescription,
                                style: kBaseTextStyle.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                          )
                        ],
                      )),
                  Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        if (!isOrderConfirmed)
                          Padding(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: BankTransferSummary(model: cartModel),
                          ),
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0, bottom: 15, left: 16, right: 16),
                            child: MaterialButton(
                                elevation: 0,
                                padding: EdgeInsets.all(0),
                                color: kLightPink,
                                minWidth: screenSize.width,
                                height: 48,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                ),
                                child: DynamicText(S.of(context).support,
                                    style: kBaseTextStyle.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: kPinkAccent)),
                                onPressed: () =>
                                    CustomerSupport.openFacebookMessenger(
                                        context)),
                          ),
                        ),
                        Container(height: 10, color: kDefaultBackground),
                        if (isOrderConfirmed)
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, left: 16, right: 16),
                              child: MaterialButton(
                                  elevation: 0,
                                  padding: EdgeInsets.all(0),
                                  color: Colors.white,
                                  minWidth: screenSize.width,
                                  height: 48,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      side: BorderSide(
                                          color: kPinkAccent, width: 1.5)),
                                  child: DynamicText(
                                      S.of(context).confirmReceivePackage,
                                      style: kBaseTextStyle.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: kPinkAccent)),
                                  onPressed: () => onOrderConfirmed(context)),
                            ),
                          ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 16, right: 16, top: 30, bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              DynamicText(
                                S.of(context).shippingFrom,
                                style: kBaseTextStyle.copyWith(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 19),
                              DynamicText(
                                S.of(context).localKoreanShips,
                                style: kBaseTextStyle.copyWith(
                                    fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                              DynamicText(
                                S.of(context).seoulKorea,
                                style: kBaseTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: kDarkSecondary),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 16, right: 16, top: 30, bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              DynamicText(
                                S.of(context).shippingTo,
                                style: kBaseTextStyle.copyWith(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 19),
                              DynamicText(
                                fullAddress,
                                // S.of(context).localKoreanShips,
                                style: kBaseTextStyle.copyWith(
                                    fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        Container(height: 10, color: kDefaultBackground),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: _createCartItems(cartModel),
                    ),
                  ),
                  Container(
                    child: OrderSummary(model: cartModel),
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 16, right: 16),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 12),
                    color: Colors.white,
                    child: SvgPicture.asset(
                      'assets/icons/heart-ballon.svg',
                      width: 30,
                      height: 42,
                    ),
                  ),
                ])),
              ]),
            )));
  }

  void doCheckout() async {
    showLoading();
    try {
      hideLoading();

      // widget.controller.animateTo(1,
      //     duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
    } catch (err) {
      hideLoading();
      Fluttertoast.showToast(
          msg: err.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void showLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void hideLoading() {
    setState(() {
      isLoading = false;
    });
  }
}

class BankTransferSummary extends StatefulWidget {
  BankTransferSummary({this.model});

  final CartModel model;

  @override
  _BankTransferSummaryState createState() => _BankTransferSummaryState();
}

class _BankTransferSummaryState extends State<BankTransferSummary> {
  Map<String, dynamic> defaultCurrency = kAdvanceConfig['DefaultCurrency'];

  @override
  void initState() {
    super.initState();
  }

  void showError(String message) {
    final snackBar = SnackBar(
      content: Text('Warning: $message'),
      duration: Duration(seconds: 30),
      action: SnackBarAction(
        label: S.of(context).close,
        onPressed: () {},
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<AppModel>(context, listen: false).currency;

    return Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            OrderSummaryCard(
              isBankTransferSummary: true,
              currency: currency,
              title: S.of(context).paymentMethod,
              subTitle: S.of(context).bankTransfer,
              fee: Tools.getCurrecyFormatted(widget.model.getTotal(),
                  currency: currency),
            ),
            SizedBox(height: 20),
            OrderSummaryCard(
              isBankTransferSummary: true,
              currency: currency,
              title: S.of(context).bankInfo,
              subTitle: "Shinhan Bank Vietnam 700-014-783205",
              fee: Tools.getCurrecyFormatted(widget.model.getTotal(),
                  currency: currency),
            ),
            SizedBox(height: 20),
            OrderSummaryCard(
              isBankTransferSummary: true,
              currency: currency,
              title: S.of(context).accountHolder,
              subTitle: "Hongbeom Park",
              fee: Tools.getCurrecyFormatted(widget.model.getTotal(),
                  currency: currency),
            ),
            SizedBox(height: 20),
            OrderSummaryCard(
              isBankTransferSummary: true,
              isTotalFee: true,
              currency: currency,
              title: S.of(context).totalAmount,
              subTitle: Tools.getCurrecyFormatted(widget.model.getTotal()),
              fee: Tools.getCurrecyFormatted(widget.model.getTotal(),
                  currency: currency),
            ),
            SizedBox(height: 20),
          ],
        ));
  }
}
