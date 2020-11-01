import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:Dimodo/common/styles.dart';

import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/models/user/userModel.dart';

import 'shippingAddressCard.dart';

class ManageShippingScreen extends StatefulWidget {
  bool isFromOrderScreen;

  ManageShippingScreen({this.isFromOrderScreen = false});
  @override
  State<StatefulWidget> createState() {
    return ManageShippingScreenState();
  }
}

class ManageShippingScreenState extends State<ManageShippingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool enabledNotification = true;
  User user;
  var isFromConfirm;
  @override
  void initState() {
    super.initState();
  }

  List<Widget> renderAddressCards(User user, bool isFromOrderScreen) {
    List<Widget> lists = [];
    print("renderAddressCardsddd: ${user.addresses[0].toJson()}");

    user.addresses.forEach((element) {
      lists.add(ShippingAddressCard(
        address: element,
        isFromOrderScreen: isFromOrderScreen,
      ));
    });
    return lists;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      isFromConfirm = arguments['isFromConfirmOrderScreen'];
      print("isFromConfirmOrderScreen: ${isFromConfirm}");
    } else {
      isFromConfirm = false;
    }

    return Consumer<UserModel>(builder: (context, value, child) {
      return Scaffold(
        body: Container(
            color: kSecondaryWhite,
            width: screenSize.width,
            height: screenSize.height,
            child: CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                brightness: Brightness.light,
                leading: IconButton(
                  icon: CommonIcons.arrowBackward,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                elevation: 0,
                backgroundColor: Colors.white,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(S.of(context).manageShippingAddress,
                      style: kBaseTextStyle.copyWith(
                          fontSize: 15,
                          color: kDarkAccent,
                          fontWeight: FontWeight.w600)),
                ),
                actions: <Widget>[
                  IconButton(
                      icon: SvgPicture.asset(
                          "assets/icons/address/square_add.svg"),
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/add_address')),
                ],
              ),
              if (value.user.addresses == null ||
                  value.user.addresses.length == 0)
                SliverList(
                    delegate: SliverChildListDelegate([EmptyShipping()])),
              if (value.user.addresses != null &&
                  value.user.addresses.length != 0)
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      height: screenSize.height -
                          AppBar().preferredSize.height -
                          MediaQuery.of(context).padding.bottom -
                          MediaQuery.of(context).padding.top,
                      color: kSecondaryWhite,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: renderAddressCards(value.user, isFromConfirm),
                      ),
                    ),
                  ]),
                ),
            ])),
      );
    });
  }
}

class EmptyShipping extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        height: screenSize.height -
            AppBar().preferredSize.height -
            MediaQuery.of(context).padding.bottom -
            MediaQuery.of(context).padding.top,
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 120),
                Center(
                  child: Container(
                      width: 270,
                      height: 236,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Image.asset(
                            'assets/icons/address/empty-shipping-address-illustration.png'),
                      )),
                ),
                Text(S.of(context).noAddress,
                    style: kBaseTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: kSecondaryGrey),
                    textAlign: TextAlign.center),
                SizedBox(height: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
