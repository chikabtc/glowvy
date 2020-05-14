import 'package:Dimodo/common/styles.dart';
import 'package:flutter/material.dart';
import '../../common/tools.dart';
import 'package:provider/provider.dart';
import '../../common/config.dart';
import '../../generated/i18n.dart';
import '../../models/order/cart.dart';
import '../../models/app.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderSummary extends StatefulWidget {
  OrderSummary({this.model});

  final CartModel model;
  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
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

  Future<void> showShippingInfo() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user can tap anywhere to dismiss the popup!
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: DynamicText(
            S.of(context).shippingFeePolicy,
            style: kBaseTextStyle,
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

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<AppModel>(context, listen: false).currency;

    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        OrderSummaryCard(
            currency: currency,
            isDiscount: true,
            title: S.of(context).discount,
            subTitle: S.of(context).discount,
            fee: Tools.getCurrecyFormatted(widget.model.getTotalDiscounts())),
        SizedBox(height: 20),
        OrderSummaryCard(
          showExtraInfo: () async => showShippingInfo(),
          currency: currency,
          title: S.of(context).deliveryMethod,
          subTitle: S.of(context).deliveryMethodDescription,
          fee: Tools.getCurrecyFormatted(widget.model.getShippingFee(),
              currency: currency),
        ),
        SizedBox(height: 20),
        OrderSummaryCard(
          currency: currency,
          title: S.of(context).importTax,
          subTitle: S.of(context).includedInPrice,
          fee: Tools.getCurrecyFormatted(0.0, currency: currency),
        ),
        SizedBox(height: 20),
        OrderSummaryCard(
          currency: currency,
          title: S.of(context).dimodoGuarantee,
          subTitle: S.of(context).dimodoGuaranteeDescription,
          fee: null,
        ),
        SizedBox(height: 20),
        OrderSummaryCard(
            currency: currency,
            title: S.of(context).returnPolicy,
            subTitle: S.of(context).returnPolicyDescription,
            fee: null),
        SizedBox(height: 20),
        Divider(
          color: kDarkSecondary.withOpacity(0.1),
        ),
        SizedBox(height: 20),
        OrderSummaryCard(
          isTotalFee: true,
          currency: currency,
          title: S.of(context).total,
          subTitle:
              "(${widget.model.totalCartQuantity}) " + S.of(context).totalItems,
          fee: Tools.getCurrecyFormatted(widget.model.getTotal(),
              currency: currency),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class OrderSummaryCard extends StatelessWidget {
  final String currency;
  final String title;
  final String subTitle;
  final String fee;
  final bool isTotalFee;
  final bool isDiscount;
  final bool isBankTransferSummary;
  final Function showExtraInfo;

  OrderSummaryCard(
      {this.currency,
      this.title,
      this.isDiscount = false,
      this.subTitle,
      this.fee,
      this.isBankTransferSummary = false,
      this.showExtraInfo,
      this.isTotalFee = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showExtraInfo,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        Row(
          children: <Widget>[
            DynamicText(
              title,
              style: kBaseTextStyle.copyWith(
                  fontSize: isBankTransferSummary ? 12 : 13,
                  fontWeight:
                      isBankTransferSummary ? FontWeight.w500 : FontWeight.w600,
                  color: isBankTransferSummary ? kDarkSecondary : kDarkBG),
            ),
            showExtraInfo != null
                ? Center(child: SvgPicture.asset('assets/icons/cart/info.svg'))
                : Container()
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: DynamicText(
                subTitle,
                textAlign: TextAlign.start,
                style: kBaseTextStyle.copyWith(
                    fontWeight: isBankTransferSummary
                        ? FontWeight.w600
                        : FontWeight.w500,
                    fontSize: isBankTransferSummary ? 15 : 12,
                    color: isBankTransferSummary ? kDarkBG : kDarkSecondary),
              ),
            ),
            if (fee != null) Spacer(),
            if (!isBankTransferSummary && fee != null)
              DynamicText(
                isDiscount ? "-" + fee : fee,
                style: kBaseTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: isBankTransferSummary
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: isTotalFee
                        ? kPinkAccent
                        : isDiscount ? kPinkAccent : kDefaultFontColor),
              ),
          ],
        ),
      ]),
    );
  }
}
