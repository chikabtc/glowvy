import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/models/user/userModel.dart';

import 'shippingAddressCard.dart';

class ManageShippingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ManageShippingScreenState();
  }
}

class ManageShippingScreenState extends State<ManageShippingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool enabledNotification = true;
  User user;

  @override
  void initState() {
    super.initState();
    //when getting user info, we get address info as well.
  }

  renderAddressCards() {
    List<Widget> lists = [];
    user.addresses.forEach((element) {
      lists.add(ShippingAddressCard(user.defaultAddress));
    });
    return lists;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Consumer<UserModel>(builder: (context, value, child) {
      return Scaffold(
        body: Container(
            color: kLightBG,
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
                  title: DynamicText(S.of(context).manageShippingAddress,
                      style: kBaseTextStyle.copyWith(
                          fontSize: 15,
                          color: kDarkAccent,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              if (value.user.defaultAddress == null)
                SliverList(
                    delegate: SliverChildListDelegate([EmptyShipping()])),
              if (value.user.defaultAddress != null)
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      height: screenSize.height -
                          AppBar().preferredSize.height -
                          MediaQuery.of(context).padding.bottom -
                          MediaQuery.of(context).padding.top,
                      color: kLightBG,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ShippingAddressCard(value.user.defaultAddress),
                          SizedBox(
                            height: 42,
                          ),
                          // Expanded(
                          //   child: Align(
                          //     alignment: FractionalOffset.bottomCenter,
                          //     child: Padding(
                          //       padding: const EdgeInsets.only(
                          //           bottom: 40.0, left: 16, right: 16),
                          //       child: MaterialButton(
                          //           elevation: 0,
                          //           color: Colors.transparent,
                          //           minWidth: screenSize.width,
                          //           height: 48,
                          //           shape: RoundedRectangleBorder(
                          //               borderRadius:
                          //                   new BorderRadius.circular(25.0),
                          //               side: BorderSide(
                          //                   color: kPinkAccent, width: 1.5)),
                          //           child: DynamicText(S.of(context).addAddress,
                          //               style: kBaseTextStyle.copyWith(
                          //                   fontWeight: FontWeight.w600,
                          //                   fontSize: 14,
                          //                   color: kPinkAccent)),
                          //           onPressed: () {
                          //             Navigator.of(context)
                          //                 .pushNamed('/add_address');
                          //           }),
                          //     ),
                          //   ),
                          // ),
                        ],
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
                Container(
                    width: 200,
                    height: 236,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Image.asset(
                          'assets/icons/address/empty-shipping-address-illustration.png'),
                    )),
                // SizedBox(height: 20),
                DynamicText(S.of(context).noAddress,
                    style: kBaseTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: kDarkSecondary),
                    textAlign: TextAlign.center),
                SizedBox(height: 50),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: MaterialButton(
                          elevation: 0,
                          color: Colors.transparent,
                          minWidth: screenSize.width,
                          height: 48,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              side: BorderSide(color: kPinkAccent, width: 1.5)),
                          child: DynamicText(S.of(context).addAddress,
                              style: kBaseTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: kPinkAccent)),
                          onPressed: () {
                            Navigator.of(context).pushNamed('/add_address');
                          }),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
