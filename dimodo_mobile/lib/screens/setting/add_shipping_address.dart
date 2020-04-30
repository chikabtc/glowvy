import 'package:Dimodo/common/constants.dart';
import 'package:flutter/material.dart';
import '../../generated/i18n.dart';
import '../../models/address/address.dart';
import '../../models/address/province.dart';
import '../../models/address/ward.dart';
import '../../models/address/district.dart';
import '../../models/address/addressModel.dart';

import '../../models/user/user.dart';
import '../../models/user/userModel.dart';

import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:Dimodo/widgets/login_animation.dart';

class AddShippingAddress extends StatefulWidget {
  Address address;

  AddShippingAddress({this.address});
  @override
  _AddShippingAddressState createState() => _AddShippingAddressState();
}

class _AddShippingAddressState extends State<AddShippingAddress>
    with TickerProviderStateMixin {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  TextEditingController _streetNameController = TextEditingController();
  TextEditingController _deliverArea = TextEditingController();
  AnimationController _loginButtonController;

  Address address =
      Address(ward: Ward(district: District(), province: Province()));
  int currentPage = 0;
  AddressModel addressModel = AddressModel();
  bool isLoading = false;
  User user;
  List<District> districts = [];
  List<Ward> wards = [];

  @override
  void initState() {
    super.initState();
    _loginButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);

    if (widget.address != null) {
      // print("Got saved address");
      address = widget.address;
      WidgetsBinding.instance.addPostFrameCallback((_) => updateState());
    }
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    user = Provider.of<UserModel>(context, listen: false).user;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // call this method here to hide soft keyboard
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          color: kLightBG,
          width: screenSize.width,
          height: screenSize.height,
          child: CustomScrollView(
            slivers: [
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
                  title: DynamicText(S.of(context).addAddress,
                      style: kBaseTextStyle.copyWith(
                          fontSize: 15,
                          color: kDarkAccent,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                      padding: EdgeInsets.only(top: 5),
                      color: Colors.transparent,
                      width: screenSize.width,
                      child: Container(
                        color: Colors.transparent,
                        width: screenSize.width,
                        height: screenSize.height -
                            AppBar().preferredSize.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom,
                        child: Stack(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CustomTextFormField(
                                    nameController: _nameController,
                                    labelText: S.of(context).fullName,
                                    address: address),
                                CustomTextFormField(
                                    isNumber: true,
                                    nameController: _phoneNumberController,
                                    labelText: S.of(context).phoneNumber,
                                    address: address),
                                GestureDetector(
                                  onTap: () => showAreas(context),
                                  child: Container(
                                    color: Colors.white,
                                    width: screenSize.width,
                                    child: CustomTextFormField(
                                        nameController: _deliverArea,
                                        isEnabled: false,
                                        labelText: S.of(context).deliveryArea,
                                        address: address),
                                  ),
                                ),
                                CustomTextFormField(
                                    nameController: _streetNameController,
                                    labelText: S.of(context).streetName,
                                    isMaxLineOne: true,
                                    address: address),
                                Container(
                                    color: Colors.white,
                                    height: 48,
                                    width: screenSize.width),
                                Expanded(
                                  child: Align(
                                    alignment: FractionalOffset.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        bottom: 40.0,
                                      ),
                                      child: StaggerAnimation(
                                        buttonTitle: S.of(context).save,
                                        buttonController:
                                            _loginButtonController.view,
                                        onTap: () {
                                          if (!isLoading) {
                                            _updateAddress(address, context);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ))
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _playAnimation() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _loginButtonController.forward();
    } on TickerCanceled {}
  }

  Future<Null> _stopAnimation() async {
    try {
      await _loginButtonController.reverse();
      setState(() {
        isLoading = false;
      });
    } on TickerCanceled {}
  }

  void _failMessage(message, context) {
    FocusScope.of(context).requestFocus(FocusNode());

    final snackBar = SnackBar(
      content: DynamicText(
        'Warning: $message',
        style: kBaseTextStyle.copyWith(color: Colors.white),
      ),
      duration: Duration(seconds: 30),
      action: SnackBarAction(
        label: S.of(context).close,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  _updateAddress(Address address, context) async {
    print("address to update:${address.toJson()}");
    _playAnimation();
    Provider.of<UserModel>(context, listen: false).updateAddress(
      address: address,
      token: user.accessToken,
      success: (isSuccess) {
        _stopAnimation();
        // address.saveAddress();

        Navigator.of(context).pop();
      },
      fail: (message) {
        print("msg: $message");
        _stopAnimation();
        // _failMessage(message, context);
      },
    );
  }

  void updateState() async {
    setState(() {
      _nameController.text = address.recipientName;
      _phoneNumberController.text = address.phoneNumber.toString();
      _deliverArea.text = address.ward.province.name +
          "   " +
          address.ward.district.name +
          "   " +
          address.ward.name;
      _streetNameController.text = address.street;
    });
  }

  List<Widget> renderTabbar() {
    List<String> tabList = ["Province", "District", "Ward"];
    List<Widget> list = [];

    tabList.asMap().forEach((index, item) {
      list.add(Container(
        child: Tab(
            child: DynamicText(item,
                style: kBaseTextStyle.copyWith(
                    fontSize: 13,
                    color: currentPage == index ? kPinkAccent : kDarkSecondary,
                    fontWeight: FontWeight.w600))),
      ));
    });
    return list;
  }

  renderAreas({StateSetter onTap}) {
    switch (currentPage) {
      case 0:
        return Expanded(
          child: ListView.builder(
            itemCount: addressModel.provinces.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () async {
                  address.ward.province.name =
                      addressModel.provinces[index].name;
                  addressModel.districts = await addressModel.getDistricts(
                      provinceId: addressModel.provinces[index].id);
                  print("chosen province name: ${address.ward.province.name}");
                  DefaultTabController.of(context).animateTo(1);
                  onTap(() => currentPage = 1);
                },
                title: DynamicText(
                  '${addressModel.provinces[index].name}',
                  style: kBaseTextStyle.copyWith(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              );
            },
          ),
        );
        break;
      case 1:
        return Expanded(
          child: ListView.builder(
            itemCount: addressModel.districts.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () async {
                  addressModel.wards = await addressModel.getWards(
                      districtId: addressModel.districts[index].id);
                  address.ward.district.name =
                      addressModel.districts[index].name;
                  print("chosen district name: ${address.ward.district.name}");

                  DefaultTabController.of(context).animateTo(2);
                  onTap(() => currentPage = 2);
                },
                title: DynamicText(
                  '${addressModel.districts[index].name}',
                  style: kBaseTextStyle.copyWith(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              );
            },
          ),
        );
        break;
      case 2:
        return Expanded(
          child: ListView.builder(
            itemCount: addressModel.wards.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () async {
                  address.ward.name = addressModel.wards[index].name;
                  address.ward.id = addressModel.wards[index].id;
                  print("chosen ward: ${address.ward.name}");

                  updateState();

                  onTap(() => Navigator.of(context).pop());
                },
                title: DynamicText(
                  '${addressModel.wards[index].name}',
                  style: kBaseTextStyle.copyWith(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              );
            },
          ),
        );
    }
  }

  void showAreas(context) {
    currentPage = 0;
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
                heightFactor: 1 -
                    (AppBar().preferredSize.height +
                            MediaQuery.of(context).padding.bottom) /
                        kScreenSizeHeight,
                child: DefaultTabController(
                  length: 3,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      width: kScreenSizeWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Stack(children: <Widget>[
                            Container(
                                color: Colors.transparent,
                                height: AppBar().preferredSize.height,
                                width: kScreenSizeWidth,
                                child: Center(
                                  child: DynamicText(S.of(context).deliveryArea,
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
                                    currentPage = 0;
                                    Navigator.pop(context);
                                  }),
                            )
                          ]),
                          IgnorePointer(
                            ignoring: true,
                            child: TabBar(
                              isScrollable: true,
                              indicatorColor: kPinkAccent,
                              onTap: (index) {
                                setState(() {
                                  currentPage = index;
                                });
                              },
                              tabs: renderTabbar(),
                            ),
                          ),
                          renderAreas(onTap: setState)
                        ],
                      )),
                ),
              );
            },
          );
        });
  }

  bool get wantKeepAlive => true;
}

class CustomTextFormField extends StatelessWidget {
  final Address address;
  final labelText;
  final Function onTap;
  final bool isEnabled;
  final bool isNumber;
  final bool isReviewForm;
  final bool isMaxLineOne;

  final TextEditingController nameController;

  CustomTextFormField(
      {this.address,
      this.labelText,
      this.nameController,
      this.onTap,
      this.isMaxLineOne = false,
      this.isReviewForm = false,
      this.isEnabled = true,
      this.isNumber = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 16),
      child: TextFormField(
          keyboardType:
              isNumber ? TextInputType.number : TextInputType.multiline,
          maxLines: isMaxLineOne ? 1 : 2,
          onTap: onTap,
          enabled: isEnabled,
          controller: nameController,
          cursorColor: kPinkAccent,
          style: kBaseTextStyle.copyWith(
              fontSize: 15 * kSizeConfig.textMultiplier,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: kDarkSecondary.withOpacity(0.1)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: kDarkSecondary.withOpacity(0.1)),
              ),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: kDarkSecondary.withOpacity(0.1)),
              ),
              labelText: labelText,
              labelStyle: kBaseTextStyle.copyWith(
                  fontSize: 15 * kSizeConfig.textMultiplier,
                  fontWeight: FontWeight.w600,
                  color: kDarkAccent.withOpacity(0.5)),
              focusColor: kPinkAccent,
              fillColor: kPinkAccent,
              hoverColor: kPinkAccent),
          validator: (val) {
            return val.isEmpty ? S.of(context).fullNameIsRequired : null;
          },
          onChanged: (String value) {
            // var name = S.of(context).name
            if (labelText == S.of(context).fullName) {
              print("is it updating?");
              address.recipientName = value;
            } else if (labelText == S.of(context).phoneNumber) {
              address.phoneNumber = value;
            } else if (labelText == S.of(context).province) {
              address.phoneNumber = value;
            } else if (labelText == S.of(context).streetName) {
              address.street = value;
            }
            print("address updated: ${address.toJson()}");
          }),
    );
  }
}
